with System;

with System.Storage_Elements;
with STM32_SVD.USB; use STM32_SVD.USB;
with STM32_SVD.RCC; use STM32_SVD.RCC;

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

  function Get_EPR_With_Invariant (EP_Id : UInt4) return EPR_Register;

   procedure Reset_ISTR is
   begin
     USB_Periph.ISTR := (USB_Periph.ISTR with delta
                         L1REQ => False,
                         ESOF => False,
                         SOF => False,
                         RESET => False,
                         SUSP => False,
                         WKUP => False,
                         ERR => False,
                         PMAOVR => False);
   end Reset_ISTR;

   overriding
   procedure Initialize (This : in out UDC) is
   begin
     --  Should be UBSEN but SVD is wrong. Should fix it.
     RCC_Periph.APB1ENR.USBRST := True;

     RCC_Periph.APB1RSTR.USBRST := True;
     RCC_Periph.APB1RSTR.USBRST := False;

     USB_Periph.CNTR.PDWN := False;

     -- wait a bit
     USB_Periph.BTABLE.BTABLE := 0;

     USB_Periph.CNTR := (USB_Periph.CNTR with delta
                        FRES => False,
                        RESETM => True,
                        SUSPM => True,
                        WKUPM => True,
                         CTRM => True);

     Reset_ISTR;

     --  Maybe set the PULL_UP here.
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
        when EP_Out =>
          Btable(Ep.Num).ADDR_TX.ADDRN_TX := UInt14 (Offset);
        when EP_In =>
          Btable(Ep.Num).ADDR_RX.ADDRN_RX := UInt14 (Offset);
          if Len <= 62 then
            Num_Blocks := Integer(Len) / 2;
          else
            Num_Blocks := Integer (Len) / 32;
            Use_32b_block := True;
          end if;
          Btable(Ep.Num).COUNT_RX.BL_SIZE := Bit (if Use_32b_block then 1 else 0);
          Btable(Ep.Num).COUNT_RX.NUM_BLOCK := UInt5 (Num_Blocks);
      end case;

      This.EP_Status (Ep.Num, Ep.Dir).Buffer_Address := Offset;

      return Packet_Buffer_Base + Offset;
   end Request_Buffer;

   overriding
   procedure Start (This : in out UDC) is
   begin
     null;
   end Start;

   overriding
   procedure Reset (This : in out UDC)
   is
   begin
     Reset_ISTR;

     USB_Periph.DADDR := (USB_Periph.DADDR with delta
                          EF => True,
                          ADD => 0);
     --  Configure at least EP0
   end Reset;


   overriding
   function Poll (This : in out UDC) return UDC_Event is
     Istr : constant ISTR_Register := USB_Periph.ISTR;
     EP_Out_Size, EP_In_Size : UInt10;
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
     elsif Istr.RESET then
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
       for EP_Id in EPRS'range loop
         if EPRS (EP_Id).CTR_RX then
           EP_In_Size := Btable(Ep_Id).COUNT_RX.COUNTN_RX;
           Copy_Endpoint_Buffer (This, EP_Id, EP_In);

           return (Kind => Transfer_Complete,
                   EP   => (UInt4 (EP_Id), EP_In),
                   BCNT => UInt11 (EP_In_Size));
         end if;

         if EPRS (EP_Id).CTR_TX then
           EP_Out_Size := Btable(Ep_Id).COUNT_TX.COUNTN_TX;
           return (Kind => Transfer_Complete,
                   EP   => (UInt4 (EP_Id), EP_Out),
                   BCNT => UInt11 (EP_Out_Size));
         end if;
       end loop;  -- Loop over endpoints
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
         Offset := Btable(Ep.Num).ADDR_TX.ADDRN_TX;
       when EP_In =>
         Offset := Btable(Ep.Num).ADDR_RX.ADDRN_RX;
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
      Tmp : EPR_Register;
   begin
     case UPR.STAT_TX is
       when 0|3 => raise Program_Error with "Would block";
       when others => null;
     end case;
     Target := Source;

     Btable(Ep).COUNT_TX.COUNTN_TX := UInt10 (Len);

     --  Set STAT_TX to VALID
     Tmp := Get_EPR_With_Invariant (Ep);
     UPR := (Tmp with delta
             STAT_TX => Tmp.STAT_TX xor 3);
   end EP_Write_Packet;

   function Get_EPR_With_Invariant (EP_Id : UInt4) return EPR_Register
   is
     UPR: EPR_Register renames EPRS (Ep_Id);
   begin

     --  Invariant fields as described in the doc (RM0091 p883).
     --  When doing RMW, the recommended way is
     --  - load value from register
     --  - write 'invariant' values in fields that can only be modified by the
     --    hw
     --  - modify other fields
     --  - write back the register

     return (UPR with delta
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

     --  If EP is IN, set CTR_TX as NAK, else DISABLE it.
     NStat_Tx : UInt2 := (if EP.Dir = EP_In then 2 else 0);

     --  If EP is OUT, set CTR_RX as VALID, else DISABLE it.
     NStat_Rx : UInt2 := (if EP.Dir = EP_Out then 3 else 0);

     Tmp : EPR_Register := Get_EPR_With_Invariant (Ep.Num);

   begin
     if Ep.Num > Num_Endpoints then
       raise Program_Error with "Invalid endpoint number";
     end if;

     UPR := (Tmp with delta
             CTR_RX => False,
             CTR_TX => False,
             EP_KIND => False,
             EA => EP.Num,
             EP_TYPE => EPM (Typ),
             STAT_TX => Tmp.STAT_TX xor NStat_Tx,
             STAT_RX => Tmp.STAT_RX xor NStat_Rx
             );
   end EP_Setup;


   overriding
   procedure EP_Ready_For_Data (This  : in out UDC;
                                EP    :        EP_Id;
                                Addr  :        System.Address;
                                Size  :        UInt32;
                                Ready :        Boolean := True)
   is
     UPR: EPR_Register renames EPRS (Ep);

     Tmp : EPR_Register := Get_EPR_With_Invariant (Ep);

     -- Status : UInt2 := UPR.STAT_TX;

     Dir : constant USB.EP_Dir := USB.EP_Out;

   begin
     --  Keep track of the user buffer where received data will be moved after
     --  reception.
     This.EP_Status (Ep, Dir).Addr := Addr;

     if Ready then
       --  Set STAT_RX to VALID (0b11) to enable data reception.
       UPR := (Tmp with delta
               STAT_RX => Tmp.STAT_RX xor 2);
     else
       UPR := (Tmp with delta
               STAT_RX => Tmp.STAT_RX xor 0);
     end if;
     -- --  Clear CTR_RX
     -- UPR := (UPR with delta
     --          CTR_RX => False, --  clear
     --          DTOG_RX => False,
     --          STAT_RX => 0,
     --          CTR_TX => True,
     --          DTOG_TX => False,
     --          STAT_TX => 0
     --          );
   end EP_Ready_For_Data;

   overriding
   procedure EP_Stall (This : in out UDC;
                       EP   :        EP_Addr;
                       Set  :        Boolean := True)
   is
     UPR: EPR_Register renames EPRS (Ep.Num);
     Tmp : EPR_Register := (UPR with delta
                             CTR_RX => True,
                             DTOG_RX => False,
                             STAT_RX => 0,
                             CTR_TX => True,
                             DTOG_TX => False,
                             STAT_TX => 0
                             );

   begin
     case Ep.Dir is
       when USB.EP_In =>
         UPR := (Tmp with delta
                 STAT_TX => Tmp.STAT_TX xor 1);
       when USB.EP_Out =>
         UPR := (Tmp with delta
                 STAT_RX => Tmp.STAT_RX xor 1);
     end case;
   end EP_Stall;

   overriding
   procedure Set_Address (This : in out UDC;
                          Addr :        UInt7)
   is
   begin
     USB_Periph.DADDR.ADD := Addr;
   end Set_Address;

   procedure Copy_Endpoint_Buffer
     (This : in out UDC;
      Num  : USB.EP_Id;
      Dir  : USB.EP_Dir)
   is
   begin
     null;
   end Copy_Endpoint_Buffer;

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
