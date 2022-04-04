with System;

with System.Storage_Elements;
with STM32.Device; use STM32.Device;
with STM32_SVD.USB; use STM32_SVD.USB;
with STM32_SVD.RCC; use STM32_SVD.RCC;

with STM32.GPIO;    use STM32.GPIO;

--  handcrafted view for BTable that can be viewed as registers (but are living
--  in packet buffer memory)

with STM32.USB_Btable; use STM32.USB_Btable;

package body STM32.USB_Device is

   --  The SVD package exports 1 type per register.
   --  It doesn't merge identical types or instances in arrays.
   --  Do it manually here.
  type EPR_Register is new EP0R_Register;

  type EPR_Registers is
     array (UInt4 range 0 .. Num_Endpoints - 1)
     of EPR_Register
     with Size => 32 * Num_Endpoints;

   EPRS : aliased EPR_Registers
     with Import, Address => USB_Periph.EP0R'Address;

   function Get_EPR_With_Invariant (Current : EPR_Register) return EPR_Register;

   procedure EP_Configure (This : in out UDC;
                           EP   : EP_Id);

   procedure EP_Start (This : in out UDC;
                       EP   : EP_Id);

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

   begin
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

     USB_Periph.CNTR := (USB_Periph.CNTR with delta
                         FRES => True);

     USB_Periph.CNTR := (FRES => False,
                         PDWN => False,
                         others => <>);
     USB_Periph.BTABLE.BTABLE := 0;

   end Initialize;

   overriding
   function Request_Buffer (This          : in out UDC;
                            Ep            :        EP_Addr;
                            Len           :        UInt11;
                            Min_Alignment :        UInt8 := 1)
                            return System.Address
   is
      use System.Storage_Elements;
      Offset    : Packet_Buffer_Offset;
      Alignment : UInt32 := UInt32 (Min_Alignment);

      Use_32b_block : Boolean := False;
      Num_Blocks : Natural := 0;

   begin
      --  buffers must be half-word aligned (16-bits)
      Alignment := Alignment and (not 16#F#);

      if Alignment = 0 or Alignment < UInt32 (Min_Alignment) then
         Alignment := Alignment + 16;
      end if;

      Offset := Allocate_Buffer (This, Natural (Len), Natural (Alignment));

      case EP.Dir is
        when EP_In =>
          Btable (Ep.Num).ADDR_TX.ADDRN_TX := UInt14 (Offset);
          This.EP_Status (Ep.Num).Tx_Buffer_Address := Offset;

        when EP_Out =>
          Btable (Ep.Num).ADDR_RX.ADDRN_RX := UInt14 (Offset);
          if Len <= 62 then
            Num_Blocks := Integer(Len) / 2;
          else
            Num_Blocks := Integer (Len) / 32;
            Use_32b_block := True;
          end if;

          Btable (Ep.Num).COUNT_RX.BL_SIZE := Bit (if Use_32b_block then 1 else 0);
          Btable (Ep.Num).COUNT_RX.NUM_BLOCK := UInt5 (Num_Blocks);

          This.EP_Status (Ep.Num).Rx_Buffer_Address := Offset;
      end case;

      return Packet_Buffer_Base + Offset;
   end Request_Buffer;

   overriding
   procedure Start (This : in out UDC) is
   begin

     This.In_Reset := False;

     USB_Periph.CNTR := (USB_Periph.CNTR with delta
                         FRES => False,
                         RESETM => True,
                         SUSPM => True,
                         WKUPM => True,
                         CTRM => True);

     Reset_ISTR;

     This.Reset;

   end Start;

   overriding
   procedure Reset (This : in out UDC)
   is
   begin
     Reset_ISTR;

     for Ep in EPR_Registers'range when This.EP_Status (EP).Valid loop
       This.EP_Configure (EP);
       This.EP_Start (EP);
     end loop;

     --  Enable Pull Up for Full Speed
     USB_Periph.BCDR.DPPU := True;
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

   overriding
   function Poll (This : in out UDC) return UDC_Event is
     Istr : constant ISTR_Register := USB_Periph.ISTR;
   begin
     if Istr.WKUP then
       --  See rm0091 p871

       --  Clear WKUP by writing 0. Writing 1 in other fields leave them unchanged.
       USB_Periph.ISTR := (Istr with delta
                           L1REQ => True,
                           ESOF => True,
                           SOF => True,
                           RESET => True,
                           SUSP => True,
                           WKUP => False, --  Clear
                           ERR => True,
                           PMAOVR => True
                           );
       USB_Periph.CNTR.FSUSP := False;
       raise Program_Error with "not handled correctly yet";
     elsif Istr.RESET or else This.In_Reset then
       --  Clear RESET by writing 0. Writing 1 in other fields leave them unchanged.
       USB_Periph.ISTR := (Istr with delta
                           L1REQ => True,
                           ESOF => True,
                           SOF => True,
                           RESET => False, --  Clear
                           SUSP => True,
                           WKUP => True,
                           ERR => True,
                           PMAOVR => True
                           );
       This.In_Reset := False;
       return (Kind => USB.HAL.Device.Reset);
     elsif Istr.SUSP then
       --  Clear SUSP by writing 0. Writing 1 in other fields leave them unchanged.
       USB_Periph.ISTR := (Istr with delta
                           L1REQ => True,
                           ESOF => True,
                           SOF => True,
                           RESET => True,
                           SUSP => False,  -- Clear
                           WKUP => True,
                           ERR => True,
                           PMAOVR => True
                           );
       raise Program_Error with "not correctly handled yet";
     elsif Istr.CTR then
       declare
         EP_Id : UInt4 := Istr.EP_ID;
         Dir   : EP_Dir := (if Istr.DIR then EP_In else EP_Out);
         EP_Data_Size : UInt10;

       begin
         case Dir is
           when EP_Out =>
             -- OUT transaction, RX from device PoV
             -- Need to copy DATA from EP buffer to app buffer.
             EP_Data_Size := Btable(Ep_Id).COUNT_RX.COUNTN_RX;
             Copy_Endpoint_Rx_Buffer (This, EP_Id);

             Clear_Ctr_Rx (EP_Id);  --  ACK the reception

             return (Kind => Transfer_Complete,
                     EP   => (UInt4 (EP_Id), EP_In),
                     BCNT => UInt11 (EP_Data_Size));

           when EP_In =>
             --  IN transaction, TX from device PoV
             --  Only need to ACK and report back the number of bytes sent.

             EP_Data_Size := Btable(Ep_Id).COUNT_TX.COUNTN_TX;

             Clear_Ctr_Tx (EP_Id);  -- ACK the transmission

             return (Kind => Transfer_Complete,
                     EP   => (UInt4 (EP_Id), EP_In),
                     BCNT => UInt11 (EP_Data_Size));
         end case;
       end;

     end if;
     return No_Event;
   end Poll;

   function Endpoint_Buffer_Address
      (Ep : USB.EP_Addr)
      return System.Address
   is
      use System.Storage_Elements;
      Offset : UInt14;

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
   procedure EP_Write_Packet (This : in out UDC;
                              Ep   :        EP_Id;
                              Addr :        System.Address;
                              Len  :        UInt32)
   is
      use System.Storage_Elements;
      Source : Storage_Array (1 .. Storage_Offset (Len))
         with Address => Addr;
      Target : Storage_Array (1 .. Storage_Offset (Len))
         with Address => Endpoint_Buffer_Address ((Num => Ep, Dir => USB.EP_In));

      UPR: EPR_Register renames EPRS (Ep);
      Cur : EPR_Register := UPR;
   begin
     case Cur.STAT_TX is
       when 0|3 => raise Program_Error with "Would block";
       when others => null;
     end case;
     Target := Source;

     Btable(Ep).COUNT_TX.COUNTN_TX := UInt10 (Len);

     --  Set STAT_TX to VALID
     UPR := (Get_EPR_With_Invariant (Cur) with delta
             STAT_TX => Cur.STAT_TX xor 3);
   end EP_Write_Packet;

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

   overriding
   procedure EP_Setup (This     : in out UDC;
                       EP       :        EP_Addr;
                       Typ      :        EP_Type;
                       Max_Size :        UInt16)
   is

     UPR: EPR_Register renames EPRS (Ep.Num);

     type EP_Type_Mapping_T is array (EP_Type) of UInt2;
     EPM : constant EP_Type_Mapping_T := (
       Bulk => 0,
       Control => 1,
       Isochronous => 2,
       Interrupt => 3);

     Cur : EPR_Register := UPR;

     U : System.Address;
   begin
     if Ep.Num > Num_Endpoints then
       raise Program_Error with "Invalid endpoint number";
     end if;

     U := This.Request_Buffer (Ep, UInt11 (Max_Size), 1);

     This.EP_Status (EP.Num).Typ := Typ;

     This.EP_Status (EP.Num).Valid := True;

     UPR := (Get_EPR_With_Invariant (Cur) with delta
             CTR_RX => False,
             CTR_TX => False,
             EP_KIND => False,
             EA => EP.Num,
             EP_TYPE => EPM (Typ)
             -- STAT_TX => (if EP.Dir = EP_In then Cur.STAT_TX xor 2 else 0),
             -- STAT_RX => (if EP.Dir = EP_Out then Cur.STAT_RX xor 3 else 0)
             );
   end EP_Setup;

   procedure EP_Configure (This : in out UDC;
                           EP   : EP_Id)
   is
     UPR: EPR_Register renames EPRS (Ep);

     type EP_Type_Mapping_T is array (EP_Type) of UInt2;
     EPM : constant EP_Type_Mapping_T := (
       Bulk => 0,
       Control => 1,
       Isochronous => 2,
       Interrupt => 3);

     Cur : EPR_Register := UPR;
     Typ : EP_Type := This.EP_Status (EP).Typ;

   begin
     if This.EP_Status (Ep).Valid then
       UPR := (Get_EPR_With_Invariant (Cur) with delta
               CTR_RX => False,
               CTR_TX => False,
               EP_KIND => False,
               EA => EP,
               EP_TYPE => EPM (Typ));
     end if;
   end EP_Configure;

  procedure EP_Start (This : in out UDC;
                      EP   : EP_Id)
  is
    use System.Storage_Elements;
    use System;

    UPR: EPR_Register renames EPRS (Ep);
    Cur : EPR_Register := UPR;

    Pending_RX : Boolean := This.EP_Status (Ep).Rx_User_Buffer_Address /= System.Null_Address;

    --  Set to NAK if needed. Leave DISABLED otherwise.
    Stat_Tx : UInt2 := (if Btable (Ep).ADDR_TX.ADDRN_TX /= 0 then 2 else 0);

    --  Set to STALL/VALID if needed. Leave DISABLED otherwise
    Stat_Rx : UInt2 := (if Btable (Ep).ADDR_RX.ADDRN_RX /= 0 then 2 else 0);
  begin
    if This.EP_Status (Ep).Valid then

      if Stat_Rx /= 0 and then Pending_RX
      then
         Stat_Rx := 3;
      end if;

      UPR := (Get_EPR_With_Invariant (Cur) with delta
              STAT_TX => Cur.STAT_TX xor Stat_Tx,
              STAT_RX => Cur.STAT_RX xor Stat_Rx);
    end if;
  end EP_Start;

   overriding
   procedure EP_Ready_For_Data (This  : in out UDC;
                                EP    :        EP_Id;
                                Addr  :        System.Address;
                                Size  :        UInt32;
                                Ready :        Boolean := True)
   is
     UPR: EPR_Register renames EPRS (Ep);
     Cur : EPR_Register := UPR;
     --  Tmp : EPR_Register := Get_EPR_With_Invariant (Ep);

     -- Status : UInt2 := UPR.STAT_TX;

   begin
     --  Keep track of the user buffer where received data will be moved after
     --  reception.
     This.EP_Status (Ep).Rx_User_Buffer_Address := Addr;

     if Ready then
       --  Set STAT_RX to VALID (0b11) to enable data reception.
       UPR := (Get_EPR_With_Invariant (Cur) with delta
               STAT_RX => Cur.STAT_RX xor 3);
     else
       --  Set to NAK if not ready (why is it needed??)
       UPR := (Get_EPR_With_Invariant (Cur) with delta
               STAT_RX => Cur.STAT_RX xor 1);
     end if;

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

   begin
     case Ep.Dir is
       when USB.EP_In =>
         UPR := (Get_EPR_With_Invariant (Cur) with delta
                 STAT_TX => Cur.STAT_TX xor 1);
       when USB.EP_Out =>
         UPR := (Get_EPR_With_Invariant (Cur) with delta
                 STAT_RX => Cur.STAT_RX xor 1);
     end case;
   end EP_Stall;

   overriding
   procedure Set_Address (This : in out UDC;
                          Addr :        UInt7)
   is
   begin
     USB_Periph.DADDR.ADD := Addr;
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

       if Length = 0 or Target_Address = System.Null_Address or Source_Address = Target_Address then
         return;
       end if;

       declare
         Source : Storage_Array (1 .. Length)
         with Address => Source_Address;
       Target : Storage_Array (1 .. Length)
         with Address => Target_Address;
       begin
         Target := Source;
       end;
   end Copy_Endpoint_Rx_Buffer;

   function Allocate_Buffer
      (This      : in out UDC;
       Size      : Natural;
       Alignment : Natural)
      return Packet_Buffer_Offset
   is
      use System.Storage_Elements;
      Addr  : Packet_Buffer_Offset := This.Next_Buffer;
      A     : constant Natural := Natural (Addr) mod Alignment;
      Extra : constant Natural := Alignment - A;
   begin
      if A /= 0 then
         Addr := Addr + Storage_Offset (Extra);
      end if;

      This.Next_Buffer := This.Next_Buffer + Storage_Offset (Extra) + Storage_Offset (Size);
      return Addr;
   end Allocate_Buffer;

end STM32.USB_Device;
