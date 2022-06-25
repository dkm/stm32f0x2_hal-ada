with System;

with System.Storage_Elements;
with STM32.Device; use STM32.Device;
with STM32_SVD.USB; use STM32_SVD.USB;
with STM32_SVD.RCC; use STM32_SVD.RCC;

with STM32.GPIO;    use STM32.GPIO;

with STM32.USARTs;  use STM32.USARTs;

--  handcrafted view for BTable that can be viewed as registers (but are living
--  in packet buffer memory)

with STM32.USB_Btable; use STM32.USB_Btable;

package body STM32.USB_Device is
    Log_Enabled : constant Boolean := False;
    Log_Level : constant Integer := 3;

    type Vol_2Byte is new Interfaces.Unsigned_16 with Volatile_Full_Access;
    type Vol_2Byte_Array is array (Natural range <>) of Vol_2Byte;

    procedure Byte_Copy (Src, Dst : System.Address; Count : Natural) is
      use System.Storage_Elements;
      use System;
      Src_Arr : Vol_2Byte_Array (1 .. (Count+1)/2) with Address => Src;
      Dst_Arr : Vol_2Byte_Array (1 .. (Count+1)/2) with Address => Dst;
    begin
      if Src /= Dst then
        Dst_Arr := Src_Arr;
      end if;
    end Byte_Copy;

    --  Static_Setup_Req_Data : Setup_Data;
    --  Static storage for storing Setup Request data coming from the Host.

  -- DEBUG
    TX_Pin : constant GPIO_Point := PB6;
    RX_Pin : constant GPIO_Point := PB7;
    Indent : Natural := 0;

    procedure Await_Send_Ready (This : USART) is
    begin
      loop
        exit when Tx_Ready (This);
      end loop;
    end Await_Send_Ready;

    procedure Put_Blocking (This : in out USART;  Data : UInt16) is
    begin
      Await_Send_Ready (This);
      Transmit (This, UInt9 (Data));
    end Put_Blocking;

    procedure Log (S : String; L: Integer := 1; Deindent : Integer := 0) is
    begin
      if not Log_Enabled or else L < Log_Level then
        return;
      end if;

      for I in 0 .. Indent loop
        Put_Blocking (USART_1, Character'Pos ('|'));
        Put_Blocking (USART_1, Character'Pos (' '));
      end loop;

      if USB_Periph.ISTR.RESET then
        Put_BLocking (USART_1, Character'Pos('+'));
      end if;

      for C of S loop
        Put_Blocking (USART_1, Character'Pos (C));
      end loop;
      Put_Blocking (USART_1, UInt16 (13)); -- CR
      Put_Blocking (USART_1, UInt16 (10)); -- LF

      Indent := Indent + Deindent;
    end Log;


    procedure StartLog (S: String; L: Integer := 1) is
    begin
      Log (S, L);
      Indent := Indent + 1;
    end StartLog;

    procedure EndLog (S: String; L: Integer :=1) is
    begin
      Indent := Indent - 1;
      Log (S, L);
    end EndLog;

    procedure Init is
    begin
      if not Log_Enabled then
        return;
      end if;

      Enable_Clock (USART_1);
      Enable_Clock (RX_Pin & TX_Pin);
      Configure_IO
          (RX_Pin & TX_Pin,
             (Mode           => Mode_AF,
                AF             => GPIO_B_AF_USART1_0,
                Resistors      => Pull_Up,
                AF_Speed       => Speed_50MHz,
                AF_Output_Type => Push_Pull));

      Disable (USART_1);

      Set_Oversampling_Mode (USART_1, Oversampling_By_16);
      Set_Baud_Rate    (USART_1, 115200);
      Set_Mode         (USART_1, Tx_Rx_Mode);
      Set_Stop_Bits    (USART_1, Stopbits_1);
      Set_Word_Length  (USART_1, Word_Length_8);
      Set_Parity       (USART_1, No_Parity);
      Set_Flow_Control (USART_1, No_Flow_Control);

      Enable (USART_1);
      Log ("START");
      Log ("--");
    end Init;
    -- DEBUG

   --  The SVD package exports 1 type per register.
   --  It doesn't merge identical types or instances in arrays.
   --  Do it manually here.
  type EPR_Register is new EP0R_Register;

  type EPR_Registers is
     array (UInt4 range 0 .. Num_Endpoints - 1)
     of EPR_Register
    with Size => 32 * Num_Endpoints,
         Volatile;

   EPRS : aliased EPR_Registers
     with Import, Volatile, Address => USB_Periph.EP0R'Address;

  function Endpoint_Buffer_Address
    (Ep : USB.EP_Addr)
    return System.Address;

   function Get_EPR_With_Invariant (Current : EPR_Register) return EPR_Register;

   -- procedure EP_Configure (This : in out UDC;
   --                         EP   : EP_Id);

   -- procedure EP_Start (This : in out UDC;
   --                     EP   : EP_Id);

  procedure Copy_Endpoint_Rx_Buffer
    (This : in out UDC;
     Num  : USB.EP_Id);

   procedure Reset_ISTR is
   begin
     USB_Periph.ISTR := (others => <>);
   end Reset_ISTR;

   overriding
   procedure Initialize (This : in out UDC) is
     DM_Pin : constant GPIO_Point := PA11;
     DP_Pin : constant GPIO_Point := PA12;
     use System.Storage_Elements;
   begin
     Init; -- DEBUG

     StartLog ("> Initialize");

     Enable_Clock (DM_Pin & DP_Pin);

     Configure_IO
       (DM_Pin & DP_Pin,
        (Mode  => Mode_In,
         Resistors => Floating));

     --  Should be UBSEN but SVD is wrong. Should fix it.
     RCC_Periph.APB1ENR.USBRST := True;

     RCC_Periph.APB1RSTR.USBRST := True;
     RCC_Periph.APB1RSTR.USBRST := False;

     Delay_Cycles (72);
     -- wait a bit

     USB_Periph.CNTR.PDWN := False;
     Delay_Cycles (72);

     for M in 0 .. 1024 loop
       declare
         Packet_Memory : UInt8 with Address => Packet_Buffer_Base + Packet_Buffer_Offset(M);
       begin
         Packet_Memory := 0;
       end;
     end loop;

     Reset_ISTR;

     USB_Periph.CNTR := (RESETM => True,
                         SUSPM => True,
                         WKUPM => True,
                         CTRM => True,
                         Reserved_6_6 => 0,
                         Reserved_16_31 => 0,
                         others => False);

     --  Clear FRES. When set, RESET is forced and EP*R registers will be
     --  mostly forced to their reset state.
     -- USB_Periph.CNTR := (USB_Periph.CNTR with delta
     --                     FRES => False);

     --  Btable points to start of Packet Memory.
     --  First 64 bytes of PM are used for storing 4*16-bits * 8 EP descriptors.
     USB_Periph.BTABLE.BTABLE := 0;

     --  Enable Pull Up for Full Speed
     USB_Periph.BCDR.DPPU := True;

     -- USB_Periph.CNTR := (FRES => False,
     --                     PDWN => False,
     --                     others => <>);
     -- USB_Periph.BTABLE.BTABLE := 0;
     EndLog ("< Initialize");
   end Initialize;

   procedure Allocate_Endpoint_Buffer (This : in out UDC;
                                       Ep : EP_Addr;
                                       Len : USB.Packet_Size)
   is
     use System.Storage_Elements;
     Offset    : Packet_Buffer_Offset;

     Use_32b_block : Boolean := False;
     Num_Blocks : Natural := 0;

     AddrTx : USB_ADDRN_TX_Register;
     CountTx : USB_COUNTN_TX_Register;

     AddrRx : USB_ADDRN_RX_Register;
     CountRx : USB_COUNTN_RX_Register;

   begin
      StartLog ("> Request buffer " & Ep.Num'Image & ", Dir " & EP.Dir'Image & " Len: " & Len'Image);

      if Ep.Num = 0 then

        --  Use the first Packet Memory for Control EP, always.

        if Ep.Dir = EP_Out then
          Offset := Num_Endpoints * 8;
        else
          Offset := Num_Endpoints * 8 + 64;
        end if;

      else
        --  In EP memory, always align on half-words
        Offset := Allocate_Buffer (This, Natural (Len));
      end if;

      case EP.Dir is
        when EP_In =>

          AddrTx := (ADDRN_TX => UInt16 (Offset));

          Log ("ADDR_TX at " & Btable (Ep.Num).ADDR_TX'Address'Image);
          Btable (Ep.Num).ADDR_TX := AddrTx;

          This.EP_Status (Ep.Num).Tx_Buffer_Address := Offset;

        when EP_Out =>
          AddrRx.ADDRN_RX := UInt16 (Offset);

          Log ("ADDR_RX at " & Btable (Ep.Num).ADDR_RX'Address'Image);

          Btable (Ep.Num).ADDR_RX := AddrRx;

          if Len <= 62 then
            Num_Blocks := Integer(Len) / 2;
          else
            Num_Blocks := Integer (Len) / 32;
            Use_32b_block := True;
          end if;

          CountRx := (BL_SIZE =>Bit (if Use_32b_block then 1 else 0),
                      NUM_BLOCK => UInt5 (Num_Blocks),
                      others => 0);

          Log ("COUNT_RX at " & Btable (Ep.Num).COUNT_RX'Address'Image);
          Btable (Ep.Num).COUNT_RX := CountRx;

          This.EP_Status (Ep.Num).Rx_Buffer_Address := Offset;

      end case;

      EndLog ("< Allocate Endpoint Buffer");
   end Allocate_Endpoint_Buffer;

   --  Allocates 2 memory buffers:
   --  - a user buffer in RAM, used in the API, and the *only* thing that gets
   --  out of this package.
   --  - a packet buffer in packet memory. Used by the hardware, with
   --  particular constraint. Never to be seen outside of the package.

   overriding
   function Request_Buffer (This          : in out UDC;
                            Ep            :        EP_Addr;
                            Len           :        USB.Packet_Size)
                            return System.Address
   is
      -- use System.Storage_Elements;
      -- Offset    : Packet_Buffer_Offset;
      -- Alignment : UInt32 := UInt32 (Min_Alignment);

      -- Use_32b_block : Boolean := False;
      -- Num_Blocks : Natural := 0;

      -- AddrTx : USB_ADDRN_TX_Register;
      -- CountTx : USB_COUNTN_TX_Register;

      -- AddrRx : USB_ADDRN_RX_Register;
      -- CountRx : USB_COUNTN_RX_Register;
      Mcu_Facing_Mem : System.Address;
   begin
      StartLog ("> Request buffer " & Ep.Num'Image & ", Dir " & EP.Dir'Image & " Len: " & Len'Image);

      -- if Ep.Num = 0 then

      --   --  Use the first Packet Memory for Control EP, always.

      --   if Ep.Dir = EP_Out then
      --     Offset := Num_Endpoints * 8;
      --   else
      --     Offset := Num_Endpoints * 8 + 64;
      --   end if;

      -- else

      --   --  buffers must be half-word aligned (16-bits)
      --   Alignment := Alignment and (not 16#F#);

      --   if Alignment = 0 or Alignment < UInt32 (Min_Alignment) then
      --     Alignment := Alignment + 16;
      --   end if;

      --   Offset := Allocate_Buffer (This, Natural (Len), Natural (Alignment));
      -- end if;

      -- case EP.Dir is
      --   when EP_In =>

      --     AddrTx := (ADDRN_TX => UInt16 (Offset));

      --     Log ("ADDR_TX at " & Btable (Ep.Num).ADDR_TX'Address'Image);
      --     Btable (Ep.Num).ADDR_TX := AddrTx;

      --     This.EP_Status (Ep.Num).Tx_Buffer_Address := Offset;

      --   when EP_Out =>
      --     AddrRx.ADDRN_RX := UInt16 (Offset);

      --     Log ("ADDR_RX at " & Btable (Ep.Num).ADDR_RX'Address'Image);

      --     Btable (Ep.Num).ADDR_RX := AddrRx;

      --     if Len <= 62 then
      --       Num_Blocks := Integer(Len) / 2;
      --     else
      --       Num_Blocks := Integer (Len) / 32;
      --       Use_32b_block := True;
      --     end if;

      --     CountRx := (BL_SIZE =>Bit (if Use_32b_block then 1 else 0),
      --                 NUM_BLOCK => UInt5 (Num_Blocks),
      --                 others => 0);

      --     Log ("COUNT_RX at " & Btable (Ep.Num).COUNT_RX'Address'Image);
      --     Btable (Ep.Num).COUNT_RX := CountRx;

      --     This.EP_Status (Ep.Num).Rx_Buffer_Address := Offset;

      -- end case;

      EndLog ("< Request buffer");

      --  Init hw & allocate in packet memory
      This.Allocate_Endpoint_Buffer (Ep, Len);

      -- This.EP_Status (Ep.Num).Rx_Buffer_Address := Offset;

      Mcu_Facing_Mem := Standard.USB.Utils.Allocate
                        (This.Alloc,
                         Alignment => 4,
                         Len       => Len);

      case Ep.Dir is
          when EP_In =>
            This.EP_Status (Ep.Num).Tx_User_Buffer_Address :=
              Mcu_Facing_Mem;
            This.EP_Status (Ep.Num).Tx_User_Buffer_Len := Len;
          when EP_Out =>
            This.EP_Status (Ep.Num).Rx_User_Buffer_Address :=
              Mcu_Facing_Mem;
            This.EP_Status (Ep.Num).Rx_User_Buffer_Len := Len;
      end case;

      return Mcu_Facing_Mem;
      --  return Packet_Buffer_Base + Offset;
   end Request_Buffer;

   overriding
   procedure Start (This : in out UDC) is
   begin
     StartLog ("> Start");

     USB_Periph.CNTR := (USB_Periph.CNTR with delta
                         FRES => False,
                         RESETM => True,
                         SUSPM => True,
                         WKUPM => True,
                         CTRM => True);
     Reset_ISTR;

     --  Btable points to start of Packet Memory.
     --  First 64 bytes of PM are used for storing 4*16-bits * 8 EP descriptors.
     USB_Periph.BTABLE.BTABLE := 0;

     --  Enable Pull Up for Full Speed
     USB_Periph.BCDR.DPPU := True;

     EndLog ("< Start");
   end Start;


   --  Really disables EP, don't really reset anything more than that...
   overriding
   procedure Reset (This : in out UDC)
   is
   begin
     StartLog ("> Reset");
     Log ("Disabling RX/TX for all EP > 0 (1..8)");

     --  Reset ALL Endpoint except for 0 (control)
     --  EP 0 should be setup by controller when doing reset.
     for Ep in EPR_Registers'First+1 .. EPR_Registers'Last  loop
       declare
          UPR: EPR_Register renames EPRS (Ep);
          Cur : EPR_Register := UPR;
        begin
          UPR := (Get_EPR_With_Invariant (Cur) with delta
                  STAT_RX => Cur.STAT_RX xor 0,
                  STAT_TX => Cur.STAT_TX xor 0);
        end;
     end loop;

     Log ("Reseting allocator state");
     --  Deallocate all buffer except for Control
     --  HACK: should be done elsewhere. 64 bytes for Btable, 64 bytes for RX,
     --  64 bytes for TX.

     This.Next_Buffer := System.Storage_Elements.Storage_Offset (Num_Endpoints * 8 + 128);

     EndLog ("< Reset");
   end Reset;

  procedure Clear_Ctr_Tx (Ep : EP_Id ) is
    UPR: EPR_Register renames EPRS (Ep);
    Cur : EPR_Register := UPR;
  begin
    UPR := (Get_EPR_With_Invariant (Cur) with delta
            CTR_TX => False);
  end Clear_Ctr_Tx;

   procedure Clear_Ctr_Rx (Ep : EP_Id ) is
      UPR: EPR_Register renames EPRS (Ep);
      Cur : EPR_Register := UPR;
   begin
      UPR := (Get_EPR_With_Invariant (Cur) with delta
              CTR_RX => False);
   end Clear_Ctr_Rx;

    function Setup_Data_Image (R: Setup_Data) return String is
    begin
      return "SetupData Rtype: " &
        "(Rec: " & R.RType.Recipient'Image & ", Typ:" & R.RType.Typ'Image & " Dir: " &
        (if R.RType.Dir = Device_To_Host then "D2H" else "H2D" ) & ")," &
        "Request: " & R.Request'Image & " ," &
        "Value: " & R.Value'Image & " ," &
        "Index: " & R.Index'Image & "," &
        "Length: " & R.Length'Image;
    end Setup_Data_Image;

    function Istr_Image (Istr: in ISTR_Register) return String is
      Res : String := "EPID: 00, DIR: XXX, L1R: 0, ESOF: 0, SOF: 0, RST: 0, SUSP: 0, WKUP: 0, ERR: 0, PMAOVR: 0, CTR: 0";
    begin
      Res (Res'First + 6 .. Res'First + 7) := Istr.EP_ID'Image;
      Res (Res'First + 15 .. Res'First + 17) := (if Istr.DIR then "OUT" else " IN");
      Res (Res'First + 25) := (if Istr.L1REQ then '1' else '0');

      Res (Res'First + 34) := (if Istr.ESOF then '1' else '0');
      Res (Res'First + 42) := (if Istr.SOF then '1' else '0');
      Res (Res'First + 50) := (if Istr.RESET then '1' else '0');
      Res (Res'First + 59) := (if Istr.SUSP then '1' else '0');
      Res (Res'First + 68) := (if Istr.WKUP then '1' else '0');
      Res (Res'First + 76) := (if Istr.ERR then '1' else '0');
      Res (Res'First + 87) := (if Istr.PMAOVR then '1' else '0');
      Res (Res'First + 95) := (if Istr.CTR then '1' else '0');

      return Res;
    end Istr_Image;

    procedure Reset_EP_Status (This : in out UDC) is
    begin
      for Ep in EPR_Registers'range when This.EP_Status (EP).Valid loop
        This.EP_Status (Ep).Rx_User_Buffer_Address := System.Null_Address;
        This.EP_Status (Ep).Rx_User_Buffer_Len := 0;

        This.EP_Status (Ep).Tx_User_Buffer_Address := System.Null_Address;
        This.EP_Status (Ep).Tx_User_Buffer_Len := 0;

      end loop;
    end Reset_EP_Status;

    function EPR_Image (Epr: EPR_Register) return String is
    begin
      return "EA:" & Epr.EA'Image &
        " STAT_TX:" & Epr.STAT_TX'Image &
        " DTOG_TX: " & Epr.DTOG_TX'Image &
        " CRT_TX: " & Epr.CTR_TX'Image &
        " CTR_TX: " & Epr.CTR_TX'Image &
        " EP_KIND: " & Epr.EP_KIND'Image &
      " EP_TYPE: " & Epr.EP_TYPE'Image &
      " SETUP: " & Epr.SETUP'Image &
      " STAT_RX: " & Epr.STAT_RX'Image &
      " DTOG_RX: " & Epr.DTOG_RX'Image &
      " CTR_RX: " & Epr.CTR_RX'Image;
    end EPR_Image;


   overriding
   function Poll (This : in out UDC) return UDC_Event is
     --  Neutral ISTR register values
     Neutral_Istr : constant ISTR_Register := (EP_ID => 0,
                                               Reserved_5_6 => 0,
                                               Reserved_16_31 => 0,
                                               others => True);
     Istr : ISTR_Register renames USB_Periph.ISTR;
     Cur_Istr : ISTR_Register := Istr;
   begin

--     Log ("Poll " & Istr_Image (Cur_Istr));

     if Cur_Istr.RESET then
        --  Clear RESET by writing 0. Writing 1 in other fields leave them unchanged.
        Startlog ("## Reset");
        Log ("!! Reset RECEIVED");
        Log ("ISTR: " & Istr_Image (Cur_Istr));

        This.Reset_EP_Status;

        Istr := (Neutral_Istr with delta
                 RESET => False --  Clear
                 );
        EndLog("## return RESET to controller");
        --  This.Reset;
        return (Kind => USB.HAL.Device.Reset);

     elsif Cur_Istr.WKUP then
       --  See rm0091 p871

       --  Clear WKUP by writing 0. Writing 1 in other fields leave them unchanged.
       Istr := (Neutral_Istr with delta
                WKUP => False --  Clear
                );
       USB_Periph.CNTR.FSUSP := False;
       --  raise Program_Error with "not handled correctly yet";

     elsif Cur_Istr.SUSP then
       --  Clear SUSP by writing 0. Writing 1 in other fields leave them unchanged.
       Istr := (Neutral_Istr with delta
                SUSP => False  -- Clear
                );
       --  raise Program_Error with "not correctly handled yet";

     elsif Cur_Istr.CTR then

       declare
         EP_Id : UInt4 := Istr.EP_ID;

         EP_Data_Size : UInt10;

       begin
         Startlog ("## CTR", 2);
         Log ("Poll " & Istr_Image (Cur_Istr), 2);
         Log ("EPR: " & EPR_Image (EPRS(EP_Id)), 2);

         if EPRS (EP_Id).CTR_RX then

             if EPRS (EP_Id).SETUP then
               Log ("EPR (clr): " & EPR_Image (EPRS(EP_Id)), 2);
               declare
                 Req : Setup_Data;
               begin
                 Byte_Copy (Endpoint_Buffer_Address ((EP_Id, EP_Out)),
                            Req'Address,
                            Natural (Req'Size));
                 Log (" --> SETUP " & Setup_Data_Image (Req), 2, -1);
                 Endlog("## return Setup_Request");

                 Clear_Ctr_Rx (EP_Id);  --  ACK the reception

                 return (Kind => Setup_Request,
                         Req => Req,
                         Req_Ep => Ep_Id); --  Always EP 0
               end;
             else

               -- OUT transaction, RX from device PoV
               -- Need to copy DATA from EP buffer to app buffer.
               EP_Data_Size := Btable(Ep_Id).COUNT_RX.COUNTN_RX;
               Copy_Endpoint_Rx_Buffer (This, EP_Id);

               Clear_Ctr_Rx (EP_Id);  --  ACK the reception

               Log (" --> TRANSFER OUT/RX OK", 2);
               Endlog("## return Transfer_Complete");
               return (Kind => Transfer_Complete,
                       EP   => (UInt4 (EP_Id), EP_Out),
                       BCNT => USB.Packet_Size (EP_Data_Size));
             end if;
         end if;

         if not EPRS (EP_Id).CTR_TX then
           raise Program_Error with "CTR_TX should be set";
         end if;

         --  If we are here, then CTR_TX must be set.

         --  IN transaction, TX from device PoV
         --  Only need to ACK and report back the number of bytes sent.

         EP_Data_Size := Btable(Ep_Id).COUNT_TX.COUNTN_TX;

         Clear_Ctr_Tx (EP_Id);  -- ACK the transmission
         Log (" --> TRANSFER IN/TX OK (" & EP_Data_Size'Image & ")");
         Endlog ("## return Transfer_Complete");
         return (Kind => Transfer_Complete,
                 EP   => (UInt4 (EP_Id), EP_In),
                 BCNT => USB.Packet_Size (EP_Data_Size));

       end;

     end if;
     return No_Event;
   end Poll;

   function Endpoint_Buffer_Address
      (Ep : USB.EP_Addr)
      return System.Address
   is
      use System.Storage_Elements;
      Offset : UInt16;

   begin
     case EP.Dir is
       when EP_Out =>
         Offset := Btable(Ep.Num).ADDR_RX.ADDRN_RX;
       when EP_In =>
         Offset := Btable(Ep.Num).ADDR_TX.ADDRN_TX;
      end case;
     return Packet_Buffer_Base + Packet_Buffer_Offset (Offset);
   end Endpoint_Buffer_Address;

   overriding
   procedure EP_Send_Packet (This : in out UDC;
                              Ep   :        EP_Id;
                              Len  :        USB.Packet_Size)
   is
      -- use System.Storage_Elements;
      -- Source : Storage_Array (1 .. Storage_Offset (Len))
      --    with Address => Addr;
      -- Target : Storage_Array (1 .. Storage_Offset (Len))
      --    with Address => Endpoint_Buffer_Address ((Num => Ep, Dir => USB.EP_In));

      User_Buffer : System.Address := This.EP_Status(Ep).Rx_User_Buffer_Address;

      UPR: EPR_Register renames EPRS (Ep);
      Cur : EPR_Register := UPR;

   begin
     StartLog ("> EP_Send_Packet " & Ep'Image, 3);

     -- case Cur.STAT_TX is
     --   when 0|3 => raise Program_Error with "Would block";
     --   when others => null;
     -- end case;

     --  If VALID (3), there must be a pending write...
     --  Better panic than do garbage
     if Cur.STAT_TX = 3 then
       raise Program_Error with "Would block";
     end if;


     -- FIXME Buffer must come from elsewhere
     Byte_Copy (User_Buffer,
                Endpoint_Buffer_Address ((Ep, USB.EP_In)),
                Natural(Len));

     --  Target := Source;

     Btable(Ep).COUNT_TX.COUNTN_TX := UInt10 (Len);

     --  Set STAT_TX to VALID
     UPR := (Get_EPR_With_Invariant (Cur) with delta
             STAT_TX => Cur.STAT_TX xor 3);

     EndLog ("< EP_Send_Packet", 3);
   end EP_Send_Packet;

   function Get_EPR_With_Invariant (Current: EPR_Register) return EPR_Register
   is
   begin

     --  Invariant fields as described in the doc (RM0091 p883).
     --  When doing RMW, the recommended way is
     --  - load value from register
     --  - write 'invariant' values in fields that can only be modified by the
     --    hw
     --  - modify other fields
     --  - write back the register

     return (Current with delta
             CTR_RX => True,
             DTOG_RX => False,
             STAT_RX => 0,
             CTR_TX => True,
             DTOG_TX => False,
             STAT_TX => 0);
   end Get_EPR_With_Invariant;


  --  Allocates an EP, but don't touch the HW yet.
  --  In particular, DO NOT set it to ready state for RX.
   overriding
   procedure EP_Setup (This     : in out UDC;
                       EP       :        EP_Addr;
                       Typ      :        EP_Type)
   is

     UPR: EPR_Register renames EPRS (Ep.Num);

     type EP_Type_Mapping_T is array (EP_Type) of UInt2;
          EPM : constant EP_Type_Mapping_T := (
          Bulk => 0,
          Control => 1,
          Isochronous => 2,
          Interrupt => 3);

     type EP_Type_Mapping_T2 is array (EP_Type) of String(1..4);
     EPM2 : constant EP_Type_Mapping_T2 := (
       Bulk => "BULK",
       Control => "CTRL",
       Isochronous => "ISO ",
       Interrupt => "INT ");

     Cur : EPR_Register := UPR;
     Tmp : EPR_Register;

   begin
     StartLog ("> EP_Setup " & EP.Num'Image & ", " & (if EP.Dir = EP_In then "IN" else "OUT")
               & " Typ: " & EPM2(Typ));

     if Ep.Num > Num_Endpoints then
       raise Program_Error with "Invalid endpoint number";
     end if;

     --  Sets ADDR for RX/TX and update BTABLE accordingly
     -- FIXME ALLOCATE BUFFER
     --     This.Allocate_Endpoint_Buffer (Ep, UInt11 (Max_Size));

     This.EP_Status (EP.Num).Typ := Typ;
     This.EP_Status (EP.Num).Valid := True;

     Log("EPR      : " & EPR_Image(UPR));
     Tmp := (Get_EPR_With_Invariant (Cur) with delta

            DTOG_TX => (if EP.Dir = EP_In  then False xor Cur.DTOG_TX else False),
            DTOG_RX => (if EP.Dir = EP_Out then False xor Cur.DTOG_RX else False),
            CTR_RX => False,
            CTR_TX => False,
            EP_KIND => False,
            EA => EP.Num,
            EP_TYPE => EPM (Typ),

            -- NAK RX/TX for corresponding Direction
            STAT_TX => (if EP.Dir = EP_In then Cur.STAT_TX xor 2 else 0),
            STAT_RX => (if EP.Dir = EP_Out then Cur.STAT_RX xor 2 else 0)
            );
     Log("Tmp      : " & EPR_Image(Tmp));
     UPR := Tmp;

     Log("EPR (set): " & EPR_Image(UPR));

     Log("btable: addr_rx" & Btable(Ep.Num).ADDR_RX.ADDRN_RX'Image &
         " count_rx: " & Btable(Ep.Num).COUNT_RX.COUNTN_RX'Image &
         " bl: " & Btable(Ep.Num).COUNT_RX.BL_SIZE'Image &
         " nb: " & Btable(Ep.Num).COUNT_RX.NUM_BLOCK'Image &
         " addr_tx: " & Btable(Ep.Num).ADDR_TX.ADDRN_TX'Image &
         " count_tx: " & Btable(Ep.Num).COUNT_TX.COUNTN_TX'Image);

     EndLog ("< EP_Setup");
   end EP_Setup;


   --  Apply the EP_Status configuration.
   --  NOTE: do not set RX to valid yet as application has not prepared
   --  anything yet. Wait until EP_Ready_For_Data to set STAT_RX to VALID.
   -- procedure EP_Configure (This : in out UDC;
   --                         EP   : EP_Id)
   -- is
   --   UPR: EPR_Register renames EPRS (Ep);

   --   type EP_Type_Mapping_T is array (EP_Type) of UInt2;
   --   EPM : constant EP_Type_Mapping_T := (
   --     Bulk => 0,
   --     Control => 1,
   --     Isochronous => 2,
   --     Interrupt => 3);

   --   Cur : EPR_Register := UPR;
   --   Typ : EP_Type := This.EP_Status (EP).Typ;

   --   use System.Storage_Elements;
   --   use System;

   --   Pending_RX : Boolean := This.EP_Status (Ep).Rx_User_Buffer_Address /= System.Null_Address;

   --   --  Vals for STAT_?X field
   --   --  0 : DISABLE
   --   --  1 : STALL
   --   --  2 : NAK
   --   --  3 : VALID

   --   --  Set to NAK if needed. Leave DISABLED otherwise.
   --   Stat_Tx : UInt2 := (if Btable (Ep).ADDR_TX.ADDRN_TX /= 0 then 2 else 0);

   --   --  Set to STALL if needed. Leave DISABLED otherwise
   --   Stat_Rx : UInt2 := (if Btable (Ep).ADDR_RX.ADDRN_RX /= 0 then 2 else 0);

   -- begin
   --   StartLog ("> EP_Configure " & EP'Image & " SRX " & Stat_Rx'Image & " STX " & Stat_Tx'Image);

   --   if This.EP_Status (Ep).Valid then
   --     Log (" - " & EPR_Image (Cur));

   --     -- --  Only set VALID if user has already called EP_Ready_For_Data with
   --     -- --  valid buffer info. If not, NAK it.
   --     -- if This.EP_Status (Ep).Rx_User_Buffer_Address = System.Null_Address
   --     --   or else This.EP_Status (Ep).Rx_User_Buffer_Len = 0
   --     -- then
   --     --   Stat_Rx := 2;
   --     -- end if;

   --     Cur := (Get_EPR_With_Invariant (Cur) with delta
   --             CTR_RX => False,
   --             CTR_TX => False,
   --             EP_KIND => False,
   --             EA => EP,

   --             STAT_TX => Cur.STAT_TX xor Stat_Tx,
   --             STAT_RX => Cur.STAT_RX xor Stat_Rx,

   --             EP_TYPE => EPM (Typ));

   --    UPR := Cur;
   --    Log (" - [XOR]" & EPR_Image (Cur));
   --    Log (" - " & EPR_Image (UPR));

   --   end if;
   --   EndLog ("< EP_Configure");
   -- end EP_Configure;


  -- procedure EP_Statr (This : in out UDC;
  --                     EP   : EP_Id)
  -- is
  --   use System.Storage_Elements;
  --   use System;

  --   UPR: EPR_Register renames EPRS (Ep);
  --   Cur : EPR_Register := UPR;

  --   Pending_RX : Boolean := This.EP_Status (Ep).Rx_User_Buffer_Address /= System.Null_Address;

  --   --  Set to NAK if needed. Leave DISABLED otherwise.
  --   Stat_Tx : UInt2 := (if Btable (Ep).ADDR_TX.ADDRN_TX /= 0 then 2 else 0);

  --   --  Set to STALL/VALID if needed. Leave DISABLED otherwise
  --   Stat_Rx : UInt2 := (if Btable (Ep).ADDR_RX.ADDRN_RX /= 0 then 2 else 0);
  -- begin
  --   if  This.EP_Status (Ep).Valid then

  --     if Stat_Rx /= 0 and then Pending_RX
  --     then
  --        Stat_Rx := 3;
  --     end if;

  --     UPR := (Get_EPR_With_Invariant (Cur) with delta
  --             STAT_TX => Cur.STAT_TX xor Stat_Tx,
  --             STAT_RX => Cur.STAT_RX xor Stat_Rx);
  --   end if;
  -- end EP_Start;

   --  Set the endpoint in a state ready for EP_Out/RX transactions.
   --  NOTE: Maybe check the buffer address. Should be a user buffer
   --  or a packet buffer address already assigned. We should not touch BTABLE
   --  here.
   overriding
   procedure EP_Ready_For_Data (This  : in out UDC;
                                EP    :        EP_Id;
                                Size  :        USB.Packet_Size;
                                Ready :        Boolean := True)
   is
     UPR: EPR_Register renames EPRS (Ep);
     Cur : EPR_Register := UPR;
   begin

     StartLog ("> EP_Ready_For_Data " & EP'Image
               & " len: " & Size'Image & " ready: " & Ready'Image, 2);

     Log ("EPR      : " & EPR_Image(UPR));

     --  nothing ready, still waiting
     if Cur.STAT_RX = 3 then
       EndLog ("< EP_Ready_For_Data (EP already ready to receive data)", 2);
       return;
     end if;

     --  Keep track of the user buffer where received data will be moved after
     --  reception.

     --  FIXME no more Addr in iface
--     This.EP_Status (Ep).Rx_User_Buffer_Address := Addr;
--     This.EP_Status (Ep).Rx_User_Buffer_Len := Size;

     if Ready then
       --  Set STAT_RX to VALID (0b11) to enable data reception.
       UPR := (Get_EPR_With_Invariant (Cur) with delta
               STAT_RX => Cur.STAT_RX xor 3);
     else
       --  Set to NAK if not ready (why is it needed??)
       UPR := (Get_EPR_With_Invariant (Cur) with delta
               STAT_RX => Cur.STAT_RX xor 2);
     end if;
     Log ("EPR (set): " & EPR_Image(UPR));
     EndLog ("< EP_Ready_For_Data", 2);
   end EP_Ready_For_Data;

   overriding
   procedure EP_Stall (This : in out UDC;
                       EP   :        EP_Addr;
                       Set  :        Boolean := True)
   is
     UPR: EPR_Register renames EPRS (Ep.Num);
     Cur : EPR_Register := UPR;

     -- Tmp : EPR_Register := (UPR with delta
     --                         CTR_RX => True,
     --                         DTOG_RX => False,
     --                         STAT_RX => 0,
     --                         CTR_TX => True,
     --                         DTOG_TX => False,
     --                         STAT_TX => 0
     --                         );
     V : UInt2 := (if Set then 1 else 2);
   begin
     StartLog ("> EP_Stall " & EP.Num'Image & " set: " & Set'Image);

     case Ep.Dir is
       when USB.EP_In =>
         UPR := (Get_EPR_With_Invariant (Cur) with delta
                 STAT_TX => Cur.STAT_TX xor V);

         if not Set then
           UPR := (Get_EPR_With_Invariant (Cur) with delta
                   DTOG_TX => False xor Cur.DTOG_TX);
         end if;
       when USB.EP_Out =>
         UPR := (Get_EPR_With_Invariant (Cur) with delta
                 STAT_RX => Cur.STAT_RX xor V);
         if not Set then
           UPR := (Get_EPR_With_Invariant (Cur) with delta
                   DTOG_RX => False xor Cur.DTOG_RX);
         end if;
       end case;
     EndLog ("< EP_Stall");
   end EP_Stall;

   overriding
   procedure Set_Address (This : in out UDC;
                          Addr :        UInt7)
   is
   begin
     StartLog ("> Set_Address " & Addr'Image);

     USB_Periph.DADDR.ADD := Addr;
     USB_Periph.DADDR.EF := True;
     EndLog ("< Set_Address");
   end Set_Address;

   procedure Copy_Endpoint_Rx_Buffer
     (This : in out UDC;
      Num  : USB.EP_Id)
   is
     use System.Storage_Elements;
     use System;
     Use_32b_Block  : Bit renames Btable (Num).COUNT_RX.BL_SIZE;
     Block_Count    : UInt5 renames Btable (Num).COUNT_RX.NUM_BLOCK;

     Length         : constant Storage_Offset := Storage_Offset ((if Use_32b_Block = 1 then Storage_Offset (Block_Count) * 32 else Storage_Offset (Block_Count) * 2));
     Source_Address : constant Address := Endpoint_Buffer_Address ((Num => Num, Dir => USB.EP_Out));
     Target_Address : constant Address := This.EP_Status (Num).Rx_User_Buffer_Address;

     begin
       StartLog ("Copy_Endpoint_Rx_Buffer " & Num'Image);

       if Length = 0 or Target_Address = System.Null_Address or Source_Address = Target_Address then
         return;
       end if;

       USB.Utils.Copy (Source_Address, Target_Address, Natural (Length));
       EndLog ("< Copy_Endpoint_Rx_Buffer");
   end Copy_Endpoint_Rx_Buffer;

   function Allocate_Buffer
      (This      : in out UDC;
       Size      : Natural)
      return Packet_Buffer_Offset
   is
      use System.Storage_Elements;
      Addr  : Packet_Buffer_Offset := This.Next_Buffer;
      A     : constant Natural := Natural (Addr) mod 16;
      Extra : constant Natural := 16 - A;
   begin
      if A /= 0 then
         Addr := Addr + Storage_Offset (Extra);
      end if;

      This.Next_Buffer := This.Next_Buffer + Storage_Offset (Extra) + Storage_Offset (Size);
      return Addr;
   end Allocate_Buffer;

end STM32.USB_Device;
