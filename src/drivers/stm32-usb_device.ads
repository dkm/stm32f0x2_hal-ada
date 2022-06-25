with System.Storage_Elements;
with System;
with HAL; use HAL;

with USB; use USB;
with USB.HAL.Device; use USB.HAL.Device;
with USB.Utils;

with STM32_SVD.USB;

package STM32.USB_Device is

   Num_Endpoints : constant := 8;

   type UDC
   is new USB_Device_Controller with private;

   overriding
   procedure Initialize (This : in out UDC);

   overriding
   function Request_Buffer (This          : in out UDC;
                            Ep            :        EP_Addr;
                            Len           :        USB.Packet_Size)
                            return System.Address;

   overriding
   function Valid_EP_Id (This : in out UDC;
                         EP   :        EP_Id)
                         return Boolean
   is (Natural (EP) in 0 .. Num_Endpoints - 1);

   overriding
   procedure Start (This : in out UDC);

   overriding
   procedure Reset (This : in out UDC);

   overriding
   function Poll (This : in out UDC) return UDC_Event;

   overriding
   procedure EP_Send_Packet (This : in out UDC;
                              Ep   : EP_Id;
                              Len  : USB.Packet_Size);

   overriding
   procedure EP_Setup (This     : in out UDC;
                       EP       : EP_Addr;
                       Typ      : EP_Type);

   overriding
   procedure EP_Ready_For_Data (This  : in out UDC;
                                EP    : EP_Id;
                                Size  : USB.Packet_Size;
                                Ready : Boolean := True);

   overriding
   procedure EP_Stall (This : in out UDC;
                       EP   :        EP_Addr;
                       Set  :        Boolean := True);

   overriding
   procedure Set_Address (This : in out UDC;
                          Addr : UInt7);

   overriding
   function Early_Address (This : UDC) return Boolean
   is (False);


private
   Packet_Buffer_Base : constant System.Address := System'To_Address (16#4000_6000#);
   subtype Packet_Buffer_Offset is System.Storage_Elements.Storage_Offset range 16#000# .. 16#3FF#;

   function Allocate_Buffer
      (This      : in out UDC;
       Size      : Natural)
       return Packet_Buffer_Offset;

   --  procedure Copy_Endpoint_Buffer
   --    (This : in out UDC;
   --     Num  : USB.EP_Id;
   --     Dir  : USB.EP_Dir);


   type Endpoint_Status is record

     -- Following pointers points in the packet memory.
     -- The memory is accessible by the CPU, but with particular constraints.
     -- Instead of enforcing constraints everywhere, we copy back and forth
     -- between the  packet memory and RAM.

      Tx_Buffer_Address : Packet_Buffer_Offset := Packet_Buffer_Offset'Last;
      --  TX buffer in Packet memory

      Rx_Buffer_Address : Packet_Buffer_Offset := Packet_Buffer_Offset'Last;
      --  RX buffer in Packet memory

      --  Both folowing pointers points in regular memory: CPU can access it,
      --  no particular constraint.

      Tx_User_Buffer_Address  : System.Address := System.Null_Address;
      --  Buffer where user writes data to be sent
      Tx_User_Buffer_Len      : USB.Packet_Size := 0;

      Rx_User_Buffer_Address  : System.Address := System.Null_Address;
      --  Buffer where user expects received data to be stored
      Rx_User_Buffer_Len      : USB.Packet_Size := 0;

      Typ : EP_Type := Bulk;
      Valid : Boolean := False;
   end record;

   type Endpoint_Status_Array is array (USB.EP_Id) of Endpoint_Status;
   type UDC
   is new USB_Device_Controller with record

     Alloc : Standard.USB.Utils.Basic_RAM_Allocator (64);
     --  4 16-bits words per AP (ADDR_TX + COUNT_TX + ADDR_RX + COUNT_RX)
     --  128 bytes statically reserved for EP0 buffers. Maybe too much. 64 bytes is the minimum for USB FS control.
     Next_Buffer : Packet_Buffer_Offset :=  System.Storage_Elements.Storage_Offset (Num_Endpoints * 8 + 128);
     EP_Status   : Endpoint_Status_Array := (others => <>);
     In_Reset    : Boolean := True;
   end record;
end STM32.USB_Device;
