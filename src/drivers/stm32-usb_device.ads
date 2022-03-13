with System;
with HAL; use HAL;

with USB; use USB;
with USB.HAL.Device; use USB.HAL.Device;
with USB.Utils;

with STM32_SVD.USB;

package STM32.USB_Device is

   type UDC
   is new USB_Device_Controller with private;

   overriding
   procedure Initialize (This : in out UDC);

   overriding
   function Request_Buffer (This          : in out UDC;
                            Ep            :        EP_Addr;
                            Len           :        UInt11;
                            Min_Alignment :        UInt8 := 1)
                            return System.Address;

   overriding
   function Valid_EP_Id (This : in out UDC;
                         EP   :        EP_Id)
                         return Boolean
   is (Natural (EP) in 0 .. 7);

   overriding
   procedure Start (This : in out UDC);

   overriding
   procedure Reset (This : in out UDC);

   overriding
   function Poll (This : in out UDC) return UDC_Event;

   overriding
   procedure EP_Write_Packet (This : in out UDC;
                              Ep   : EP_Id;
                              Addr : System.Address;
                              Len  : UInt32);

   overriding
   procedure EP_Setup (This     : in out UDC;
                       EP       : EP_Addr;
                       Typ      : EP_Type;
                       Max_Size : UInt16);

   overriding
   procedure EP_Ready_For_Data (This  : in out UDC;
                                EP    : EP_Id;
                                Addr  : System.Address;
                                Size  : UInt32;
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

   EP_Buffer_Min_Alignment : constant := 4;

   type UDC
   is new USB_Device_Controller with record
      Alloc : Standard.USB.Utils.Basic_RAM_Allocator (200);
   end record;
end STM32.USB_Device;