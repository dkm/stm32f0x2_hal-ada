pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F0x2.svd

pragma Restrictions (No_Elaboration_Code);

with System;

--  STM32F0x2

package STM32_SVD is
   pragma Preelaborate;

   --------------------
   -- Base addresses --
   --------------------

   CRC_Base         : constant System.Address :=
     System'To_Address (16#4002_3000#);
   GPIOF_Base       : constant System.Address :=
     System'To_Address (16#4800_1400#);
   GPIOD_Base       : constant System.Address :=
     System'To_Address (16#4800_0C00#);
   GPIOC_Base       : constant System.Address :=
     System'To_Address (16#4800_0800#);
   GPIOB_Base       : constant System.Address :=
     System'To_Address (16#4800_0400#);
   GPIOE_Base       : constant System.Address :=
     System'To_Address (16#4800_1000#);
   GPIOA_Base       : constant System.Address :=
     System'To_Address (16#4800_0000#);
   SPI1_Base        : constant System.Address :=
     System'To_Address (16#4001_3000#);
   SPI2_Base        : constant System.Address :=
     System'To_Address (16#4000_3800#);
   DAC_Base         : constant System.Address :=
     System'To_Address (16#4000_7400#);
   PWR_Base         : constant System.Address :=
     System'To_Address (16#4000_7000#);
   I2C1_Base        : constant System.Address :=
     System'To_Address (16#4000_5400#);
   I2C2_Base        : constant System.Address :=
     System'To_Address (16#4000_5800#);
   IWDG_Base        : constant System.Address :=
     System'To_Address (16#4000_3000#);
   WWDG_Base        : constant System.Address :=
     System'To_Address (16#4000_2C00#);
   TIM1_Base        : constant System.Address :=
     System'To_Address (16#4001_2C00#);
   TIM2_Base        : constant System.Address :=
     System'To_Address (16#4000_0000#);
   TIM3_Base        : constant System.Address :=
     System'To_Address (16#4000_0400#);
   TIM14_Base       : constant System.Address :=
     System'To_Address (16#4000_2000#);
   TIM6_Base        : constant System.Address :=
     System'To_Address (16#4000_1000#);
   TIM7_Base        : constant System.Address :=
     System'To_Address (16#4000_1400#);
   EXTI_Base        : constant System.Address :=
     System'To_Address (16#4001_0400#);
   NVIC_Base        : constant System.Address :=
     System'To_Address (16#E000_E100#);
   DMA1_Base        : constant System.Address :=
     System'To_Address (16#4002_0000#);
   RCC_Base         : constant System.Address :=
     System'To_Address (16#4002_1000#);
   SYSCFG_COMP_Base : constant System.Address :=
     System'To_Address (16#4001_0000#);
   ADC_Base         : constant System.Address :=
     System'To_Address (16#4001_2400#);
   USART1_Base      : constant System.Address :=
     System'To_Address (16#4001_3800#);
   USART2_Base      : constant System.Address :=
     System'To_Address (16#4000_4400#);
   USART3_Base      : constant System.Address :=
     System'To_Address (16#4000_4800#);
   USART4_Base      : constant System.Address :=
     System'To_Address (16#4000_4C00#);
   RTC_Base         : constant System.Address :=
     System'To_Address (16#4000_2800#);
   TIM15_Base       : constant System.Address :=
     System'To_Address (16#4001_4000#);
   TIM16_Base       : constant System.Address :=
     System'To_Address (16#4001_4400#);
   TIM17_Base       : constant System.Address :=
     System'To_Address (16#4001_4800#);
   TSC_Base         : constant System.Address :=
     System'To_Address (16#4002_4000#);
   CEC_Base         : constant System.Address :=
     System'To_Address (16#4000_7800#);
   Flash_Base       : constant System.Address :=
     System'To_Address (16#4002_2000#);
   DBGMCU_Base      : constant System.Address :=
     System'To_Address (16#4001_5800#);
   USB_Base         : constant System.Address :=
     System'To_Address (16#4000_5C00#);
   CRS_Base         : constant System.Address :=
     System'To_Address (16#4000_6C00#);
   CAN_Base         : constant System.Address :=
     System'To_Address (16#4000_6400#);
   SCB_Base         : constant System.Address :=
     System'To_Address (16#E000_ED00#);
   STK_Base         : constant System.Address :=
     System'To_Address (16#E000_E010#);

end STM32_SVD;
