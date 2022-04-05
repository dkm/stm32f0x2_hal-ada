pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package STM32.USB_Btable is

  --  TX
  subtype ADDRN_TX_Field is HAL.UInt14;

  type USB_ADDRN_TX_Register is record
    Reserved_0 : HAL.Bit := 16#0#;
    ADDRN_TX   : ADDRN_TX_Field := 16#0#;

  end record
    with Volatile_Full_Access, Object_Size => 16,
         Bit_Order => System.Low_Order_First;

  for USB_ADDRN_TX_Register use record
    Reserved_0 at 0 range 0 .. 0;
    ADDRN_TX   at 0 range 1 .. 15;
  end record;

  subtype COUNTN_TX_Field is HAL.UInt10;

  type USB_COUNTN_TX_Register is record
    COUNTN_TX  : COUNTN_TX_Field := 16#0#;
    Reserved_0 : HAL.UInt6       := 16#0#;
  end record
    with Volatile_Full_Access, Object_Size => 16,
         Bit_Order => System.Low_Order_First;

  for USB_COUNTN_TX_Register use record
    COUNTN_TX  at 0 range 0 .. 9;
    Reserved_0 at 0 range 10 .. 15;
  end record;

  --  RX
  subtype ADDRN_RX_Field is HAL.UInt14;

  type USB_ADDRN_RX_Register is record
    Reserved_0 : HAL.Bit        := 16#0#;
    ADDRN_RX   : ADDRN_RX_Field := 16#0#;

  end record
    with Volatile_Full_Access, Object_Size => 16,
         Bit_Order => System.Low_Order_First;

  for USB_ADDRN_RX_Register use record
    Reserved_0 at 0 range 0 .. 0;
    ADDRN_RX   at 0 range 1 .. 15;
  end record;

  subtype COUNTN_RX_Field is HAL.UInt10;

  type USB_COUNTN_RX_Register is record
    COUNTN_RX : COUNTN_RX_Field := 16#0#;
    NUM_BLOCK : HAL.UInt5       := 16#0#;
    BL_SIZE   : HAL.Bit         := 16#0#;
  end record
    with Volatile_Full_Access, Object_Size => 16,
         Bit_Order => System.Low_Order_First;

  for USB_COUNTN_RX_Register use record
    COUNTN_RX at 0 range 0 .. 9;
    NUM_BLOCK at 0 range 10 .. 14;
    BL_SIZE   at 0 range 15 .. 15;
  end record;

  type EP_Group is record
    ADDR_TX  : USB_ADDRN_TX_Register;
    COUNT_TX : USB_COUNTN_TX_Register;
    ADDR_RX  : USB_ADDRN_RX_Register;
    COUNT_RX : USB_COUNTN_RX_Register;
  end record
    with Object_Size => 64,
         Bit_Order => System.Low_Order_First;

  for EP_Group use record
    ADDR_TX  at 16#0# range 0 .. 15;
    COUNT_TX at 16#2# range 0 .. 15;
    ADDR_RX  at 16#4# range 0 .. 15;
    COUNT_RX at 16#6# range 0 .. 15;
  end record;

  type Btable_Type is array (UInt4) of EP_Group
    with Volatile;

  -- type Btable_Type is record
  --   ADDR0_TX : USB_ADDRN_TX_Register;
  --   COUNT0_TX : USB_COUNTN_TX_Register;
  --   ADDR0_RX : USB_ADDRN_RX_Register;
  --   COUNT0_RX : USB_COUNTN_RX_Register;
  -- end record
  --   with Volatile;

  -- for Btable_Type use record
  --   ADDR0_TX at 16#0# range 0 .. 15;
  --   COUNT0_TX at 16#2# range 0 .. 15;
  --   ADDR0_RX at 16#4# range 0 .. 15;
  --   COUNT0_RX at 16#6# range 0 .. 15;
  -- end record;

  Btable_Base : constant System.Address := System'To_Address (16#4000_6000#);

  Btable : aliased Btable_Type
    with Import, Address => Btable_Base;
end STM32.USB_Btable;
