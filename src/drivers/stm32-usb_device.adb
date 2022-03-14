with System;

with System.Storage_Elements;
with STM32_SVD.USB; use STM32_SVD.USB;

package body STM32.USB_Device is

   overriding
   procedure Initialize (This : in out UDC) is
   begin
     null;
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
   begin
      Offset := Allocate_Buffer (This, Natural (Len), Natural (Alignment));
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
      null;
   end Reset;


   overriding
   function Poll (This : in out UDC) return UDC_Event is
   begin
         return No_Event;
   end Poll;


   overriding
   procedure EP_Write_Packet (This : in out UDC;
                              Ep   :        EP_Id;
                              Addr :        System.Address;
                              Len  :        UInt32)
   is
   begin
     null;
   end EP_Write_Packet;

  
   overriding
   procedure EP_Setup (This     : in out UDC;
                       EP       :        EP_Addr;
                       Typ      :        EP_Type;
                       Max_Size :        UInt16)
   is
   begin
     null;
   end EP_Setup;


   overriding
   procedure EP_Ready_For_Data (This  : in out UDC;
                                EP    :        EP_Id;
                                Addr  :        System.Address;
                                Size  :        UInt32;
                                Ready :        Boolean := True)
   is
   begin
     null;
   end EP_Ready_For_Data;

   
   overriding
   procedure EP_Stall (This : in out UDC;
                       EP   :        EP_Addr;
                       Set  :        Boolean := True)
   is
   begin
     null;
   end EP_Stall;

   overriding
   procedure Set_Address (This : in out UDC;
                          Addr :        UInt7)
   is
   begin
     null;
   end Set_Address;


   function Allocate_Buffer
      (This      : in out UDC;
       Size      : Natural;
       Alignment : Natural)
      return Packet_Buffer_Offset
   is
      use System.Storage_Elements;
      Addr  : Packet_Buffer_Offset := This.Next_Buffer;
      --  A     : constant Natural := Natural (Addr) mod Alignment;
      --  Extra : constant Natural := Alignment - A;
   begin
      --  if A /= 0 then
      --     Addr := Addr + Storage_Offset (Extra);
      --  end if;
      --  This.Next_Buffer := This.Next_Buffer + Storage_Offset (Extra) + Storage_Offset (Size);
      return Addr;
   end Allocate_Buffer;


end STM32.USB_Device;