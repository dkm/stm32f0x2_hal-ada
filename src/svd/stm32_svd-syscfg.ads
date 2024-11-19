pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F0x2.svd

pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package STM32_SVD.SYSCFG is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype SYSCFG_CFGR1_MEM_MODE_Field is HAL.UInt2;

   --  configuration register 1
   type SYSCFG_CFGR1_Register is record
      --  Memory mapping selection bits
      MEM_MODE          : SYSCFG_CFGR1_MEM_MODE_Field := 16#0#;
      --  unspecified
      Reserved_2_7      : HAL.UInt6 := 16#0#;
      --  ADC DMA remapping bit
      ADC_DMA_RMP       : Boolean := False;
      --  USART1_TX DMA remapping bit
      USART1_TX_DMA_RMP : Boolean := False;
      --  USART1_RX DMA request remapping bit
      USART1_RX_DMA_RMP : Boolean := False;
      --  TIM16 DMA request remapping bit
      TIM16_DMA_RMP     : Boolean := False;
      --  TIM17 DMA request remapping bit
      TIM17_DMA_RMP     : Boolean := False;
      --  unspecified
      Reserved_13_15    : HAL.UInt3 := 16#0#;
      --  Fast Mode Plus (FM plus) driving capability activation bits.
      I2C_PB6_FM        : Boolean := False;
      --  Fast Mode Plus (FM+) driving capability activation bits.
      I2C_PB7_FM        : Boolean := False;
      --  Fast Mode Plus (FM+) driving capability activation bits.
      I2C_PB8_FM        : Boolean := False;
      --  Fast Mode Plus (FM+) driving capability activation bits.
      I2C_PB9_FM        : Boolean := False;
      --  FM+ driving capability activation for I2C1
      I2C1_FM_plus      : Boolean := False;
      --  FM+ driving capability activation for I2C2
      I2C2_FM_plus      : Boolean := False;
      --  unspecified
      Reserved_22_23    : HAL.UInt2 := 16#0#;
      --  SPI2 DMA request remapping bit
      SPI2_DMA_RMP      : Boolean := False;
      --  USART2 DMA request remapping bit
      USART2_DMA_RMP    : Boolean := False;
      --  USART3 DMA request remapping bit
      USART3_DMA_RMP    : Boolean := False;
      --  I2C1 DMA request remapping bit
      I2C1_DMA_RMP      : Boolean := False;
      --  TIM1 DMA request remapping bit
      TIM1_DMA_RMP      : Boolean := False;
      --  TIM2 DMA request remapping bit
      TIM2_DMA_RMP      : Boolean := False;
      --  TIM3 DMA request remapping bit
      TIM3_DMA_RMP      : Boolean := False;
      --  unspecified
      Reserved_31_31    : HAL.Bit := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SYSCFG_CFGR1_Register use
     record
       MEM_MODE at 0 range 0 .. 1;
       Reserved_2_7 at 0 range 2 .. 7;
       ADC_DMA_RMP at 0 range 8 .. 8;
       USART1_TX_DMA_RMP at 0 range 9 .. 9;
       USART1_RX_DMA_RMP at 0 range 10 .. 10;
       TIM16_DMA_RMP at 0 range 11 .. 11;
       TIM17_DMA_RMP at 0 range 12 .. 12;
       Reserved_13_15 at 0 range 13 .. 15;
       I2C_PB6_FM at 0 range 16 .. 16;
       I2C_PB7_FM at 0 range 17 .. 17;
       I2C_PB8_FM at 0 range 18 .. 18;
       I2C_PB9_FM at 0 range 19 .. 19;
       I2C1_FM_plus at 0 range 20 .. 20;
       I2C2_FM_plus at 0 range 21 .. 21;
       Reserved_22_23 at 0 range 22 .. 23;
       SPI2_DMA_RMP at 0 range 24 .. 24;
       USART2_DMA_RMP at 0 range 25 .. 25;
       USART3_DMA_RMP at 0 range 26 .. 26;
       I2C1_DMA_RMP at 0 range 27 .. 27;
       TIM1_DMA_RMP at 0 range 28 .. 28;
       TIM2_DMA_RMP at 0 range 29 .. 29;
       TIM3_DMA_RMP at 0 range 30 .. 30;
       Reserved_31_31 at 0 range 31 .. 31;
     end record;

   --  SYSCFG_EXTICR1_EXTI array element
   subtype SYSCFG_EXTICR1_EXTI_Element is HAL.UInt4;

   --  SYSCFG_EXTICR1_EXTI array
   type SYSCFG_EXTICR1_EXTI_Field_Array is
     array (0 .. 3) of SYSCFG_EXTICR1_EXTI_Element
   with Component_Size => 4, Size => 16;

   --  Type definition for SYSCFG_EXTICR1_EXTI
   type SYSCFG_EXTICR1_EXTI_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  EXTI as a value
            Val : HAL.UInt16;

         when True =>
            --  EXTI as an array
            Arr : SYSCFG_EXTICR1_EXTI_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 16;

   for SYSCFG_EXTICR1_EXTI_Field use
     record
       Val at 0 range 0 .. 15;
       Arr at 0 range 0 .. 15;
     end record;

   --  external interrupt configuration register 1
   type SYSCFG_EXTICR1_Register is record
      --  EXTI 0 configuration bits
      EXTI           : SYSCFG_EXTICR1_EXTI_Field :=
        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_16_31 : HAL.UInt16 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SYSCFG_EXTICR1_Register use
     record
       EXTI at 0 range 0 .. 15;
       Reserved_16_31 at 0 range 16 .. 31;
     end record;

   --  SYSCFG_EXTICR2_EXTI array element
   subtype SYSCFG_EXTICR2_EXTI_Element is HAL.UInt4;

   --  SYSCFG_EXTICR2_EXTI array
   type SYSCFG_EXTICR2_EXTI_Field_Array is
     array (4 .. 7) of SYSCFG_EXTICR2_EXTI_Element
   with Component_Size => 4, Size => 16;

   --  Type definition for SYSCFG_EXTICR2_EXTI
   type SYSCFG_EXTICR2_EXTI_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  EXTI as a value
            Val : HAL.UInt16;

         when True =>
            --  EXTI as an array
            Arr : SYSCFG_EXTICR2_EXTI_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 16;

   for SYSCFG_EXTICR2_EXTI_Field use
     record
       Val at 0 range 0 .. 15;
       Arr at 0 range 0 .. 15;
     end record;

   --  external interrupt configuration register 2
   type SYSCFG_EXTICR2_Register is record
      --  EXTI 4 configuration bits
      EXTI           : SYSCFG_EXTICR2_EXTI_Field :=
        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_16_31 : HAL.UInt16 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SYSCFG_EXTICR2_Register use
     record
       EXTI at 0 range 0 .. 15;
       Reserved_16_31 at 0 range 16 .. 31;
     end record;

   --  SYSCFG_EXTICR3_EXTI array element
   subtype SYSCFG_EXTICR3_EXTI_Element is HAL.UInt4;

   --  SYSCFG_EXTICR3_EXTI array
   type SYSCFG_EXTICR3_EXTI_Field_Array is
     array (8 .. 11) of SYSCFG_EXTICR3_EXTI_Element
   with Component_Size => 4, Size => 16;

   --  Type definition for SYSCFG_EXTICR3_EXTI
   type SYSCFG_EXTICR3_EXTI_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  EXTI as a value
            Val : HAL.UInt16;

         when True =>
            --  EXTI as an array
            Arr : SYSCFG_EXTICR3_EXTI_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 16;

   for SYSCFG_EXTICR3_EXTI_Field use
     record
       Val at 0 range 0 .. 15;
       Arr at 0 range 0 .. 15;
     end record;

   --  external interrupt configuration register 3
   type SYSCFG_EXTICR3_Register is record
      --  EXTI 8 configuration bits
      EXTI           : SYSCFG_EXTICR3_EXTI_Field :=
        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_16_31 : HAL.UInt16 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SYSCFG_EXTICR3_Register use
     record
       EXTI at 0 range 0 .. 15;
       Reserved_16_31 at 0 range 16 .. 31;
     end record;

   --  SYSCFG_EXTICR4_EXTI array element
   subtype SYSCFG_EXTICR4_EXTI_Element is HAL.UInt4;

   --  SYSCFG_EXTICR4_EXTI array
   type SYSCFG_EXTICR4_EXTI_Field_Array is
     array (12 .. 15) of SYSCFG_EXTICR4_EXTI_Element
   with Component_Size => 4, Size => 16;

   --  Type definition for SYSCFG_EXTICR4_EXTI
   type SYSCFG_EXTICR4_EXTI_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  EXTI as a value
            Val : HAL.UInt16;

         when True =>
            --  EXTI as an array
            Arr : SYSCFG_EXTICR4_EXTI_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 16;

   for SYSCFG_EXTICR4_EXTI_Field use
     record
       Val at 0 range 0 .. 15;
       Arr at 0 range 0 .. 15;
     end record;

   --  external interrupt configuration register 4
   type SYSCFG_EXTICR4_Register is record
      --  EXTI 12 configuration bits
      EXTI           : SYSCFG_EXTICR4_EXTI_Field :=
        (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_16_31 : HAL.UInt16 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SYSCFG_EXTICR4_Register use
     record
       EXTI at 0 range 0 .. 15;
       Reserved_16_31 at 0 range 16 .. 31;
     end record;

   --  configuration register 2
   type SYSCFG_CFGR2_Register is record
      --  Cortex-M0 LOCKUP bit enable bit
      LOCUP_LOCK       : Boolean := False;
      --  SRAM parity lock bit
      SRAM_PARITY_LOCK : Boolean := False;
      --  PVD lock enable bit
      PVD_LOCK         : Boolean := False;
      --  unspecified
      Reserved_3_7     : HAL.UInt5 := 16#0#;
      --  SRAM parity flag
      SRAM_PEF         : Boolean := False;
      --  unspecified
      Reserved_9_31    : HAL.UInt23 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SYSCFG_CFGR2_Register use
     record
       LOCUP_LOCK at 0 range 0 .. 0;
       SRAM_PARITY_LOCK at 0 range 1 .. 1;
       PVD_LOCK at 0 range 2 .. 2;
       Reserved_3_7 at 0 range 3 .. 7;
       SRAM_PEF at 0 range 8 .. 8;
       Reserved_9_31 at 0 range 9 .. 31;
     end record;

   subtype COMP_CSR_COMP1MODE_Field is HAL.UInt2;
   subtype COMP_CSR_COMP1INSEL_Field is HAL.UInt3;
   subtype COMP_CSR_COMP1OUTSEL_Field is HAL.UInt3;
   subtype COMP_CSR_COMP1HYST_Field is HAL.UInt2;
   subtype COMP_CSR_COMP2MODE_Field is HAL.UInt2;
   subtype COMP_CSR_COMP2INSEL_Field is HAL.UInt3;
   subtype COMP_CSR_COMP2OUTSEL_Field is HAL.UInt3;
   subtype COMP_CSR_COMP2HYST_Field is HAL.UInt2;

   --  control and status register
   type COMP_CSR_Register is record
      --  Comparator 1 enable
      COMP1EN        : Boolean := False;
      --  COMP1_INP_DAC
      COMP1_INP_DAC  : Boolean := False;
      --  Comparator 1 mode
      COMP1MODE      : COMP_CSR_COMP1MODE_Field := 16#0#;
      --  Comparator 1 inverting input selection
      COMP1INSEL     : COMP_CSR_COMP1INSEL_Field := 16#0#;
      --  unspecified
      Reserved_7_7   : HAL.Bit := 16#0#;
      --  Comparator 1 output selection
      COMP1OUTSEL    : COMP_CSR_COMP1OUTSEL_Field := 16#0#;
      --  Comparator 1 output polarity
      COMP1POL       : Boolean := False;
      --  Comparator 1 hysteresis
      COMP1HYST      : COMP_CSR_COMP1HYST_Field := 16#0#;
      --  Read-only. Comparator 1 output
      COMP1OUT       : Boolean := False;
      --  Comparator 1 lock
      COMP1LOCK      : Boolean := False;
      --  Comparator 2 enable
      COMP2EN        : Boolean := False;
      --  unspecified
      Reserved_17_17 : HAL.Bit := 16#0#;
      --  Comparator 2 mode
      COMP2MODE      : COMP_CSR_COMP2MODE_Field := 16#0#;
      --  Comparator 2 inverting input selection
      COMP2INSEL     : COMP_CSR_COMP2INSEL_Field := 16#0#;
      --  Window mode enable
      WNDWEN         : Boolean := False;
      --  Comparator 2 output selection
      COMP2OUTSEL    : COMP_CSR_COMP2OUTSEL_Field := 16#0#;
      --  Comparator 2 output polarity
      COMP2POL       : Boolean := False;
      --  Comparator 2 hysteresis
      COMP2HYST      : COMP_CSR_COMP2HYST_Field := 16#0#;
      --  Read-only. Comparator 2 output
      COMP2OUT       : Boolean := False;
      --  Comparator 2 lock
      COMP2LOCK      : Boolean := False;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for COMP_CSR_Register use
     record
       COMP1EN at 0 range 0 .. 0;
       COMP1_INP_DAC at 0 range 1 .. 1;
       COMP1MODE at 0 range 2 .. 3;
       COMP1INSEL at 0 range 4 .. 6;
       Reserved_7_7 at 0 range 7 .. 7;
       COMP1OUTSEL at 0 range 8 .. 10;
       COMP1POL at 0 range 11 .. 11;
       COMP1HYST at 0 range 12 .. 13;
       COMP1OUT at 0 range 14 .. 14;
       COMP1LOCK at 0 range 15 .. 15;
       COMP2EN at 0 range 16 .. 16;
       Reserved_17_17 at 0 range 17 .. 17;
       COMP2MODE at 0 range 18 .. 19;
       COMP2INSEL at 0 range 20 .. 22;
       WNDWEN at 0 range 23 .. 23;
       COMP2OUTSEL at 0 range 24 .. 26;
       COMP2POL at 0 range 27 .. 27;
       COMP2HYST at 0 range 28 .. 29;
       COMP2OUT at 0 range 30 .. 30;
       COMP2LOCK at 0 range 31 .. 31;
     end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System configuration controller
   type SYSCFG_COMP_Peripheral is record
      --  configuration register 1
      SYSCFG_CFGR1   : aliased SYSCFG_CFGR1_Register;
      --  external interrupt configuration register 1
      SYSCFG_EXTICR1 : aliased SYSCFG_EXTICR1_Register;
      --  external interrupt configuration register 2
      SYSCFG_EXTICR2 : aliased SYSCFG_EXTICR2_Register;
      --  external interrupt configuration register 3
      SYSCFG_EXTICR3 : aliased SYSCFG_EXTICR3_Register;
      --  external interrupt configuration register 4
      SYSCFG_EXTICR4 : aliased SYSCFG_EXTICR4_Register;
      --  configuration register 2
      SYSCFG_CFGR2   : aliased SYSCFG_CFGR2_Register;
      --  control and status register
      COMP_CSR       : aliased COMP_CSR_Register;
   end record
   with Volatile;

   for SYSCFG_COMP_Peripheral use
     record
       SYSCFG_CFGR1 at 16#0# range 0 .. 31;
       SYSCFG_EXTICR1 at 16#8# range 0 .. 31;
       SYSCFG_EXTICR2 at 16#C# range 0 .. 31;
       SYSCFG_EXTICR3 at 16#10# range 0 .. 31;
       SYSCFG_EXTICR4 at 16#14# range 0 .. 31;
       SYSCFG_CFGR2 at 16#18# range 0 .. 31;
       COMP_CSR at 16#1C# range 0 .. 31;
     end record;

   --  System configuration controller
   SYSCFG_COMP_Periph : aliased SYSCFG_COMP_Peripheral
   with Import, Address => SYSCFG_COMP_Base;

end STM32_SVD.SYSCFG;
