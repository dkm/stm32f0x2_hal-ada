------------------------------------------------------------------------------
--                                                                          --
--                     Copyright (C) 2015-2018, AdaCore                     --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of STMicroelectronics nor the names of its       --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with STM32_SVD;    use STM32_SVD;
with STM32.GPIO;   use STM32.GPIO;
with STM32.USARTs; use STM32.USARTs;
with STM32.Timers; use STM32.Timers;

with STM32.USB_Device; use STM32.USB_Device;

package STM32.Device is
   pragma Elaborate_Body;

   procedure Delay_Cycles (Cycles : UInt32);

   Unknown_Device : exception;
   --  Raised by the routines below for a device passed as an actual parameter
   --  when that device is not present on the given hardware instance.

   procedure Enable_Clock (This : aliased in out GPIO_Port);
   procedure Enable_Clock (Point : GPIO_Point);
   procedure Enable_Clock (Points : GPIO_Points);

   procedure Reset (This : aliased in out GPIO_Port)
   with Inline;
   procedure Reset (Point : GPIO_Point)
   with Inline;
   procedure Reset (Points : GPIO_Points)
   with Inline;

   function GPIO_Port_Representation (Port : GPIO_Port) return UInt4
   with Inline;

   GPIO_A : aliased GPIO_Port
   with Import, Volatile, Address => GPIOA_Base;
   GPIO_B : aliased GPIO_Port
   with Import, Volatile, Address => GPIOB_Base;
   GPIO_C : aliased GPIO_Port
   with Import, Volatile, Address => GPIOC_Base;
   GPIO_D : aliased GPIO_Port
   with Import, Volatile, Address => GPIOD_Base;
   GPIO_E : aliased GPIO_Port
   with Import, Volatile, Address => GPIOE_Base;
   GPIO_F : aliased GPIO_Port
   with Import, Volatile, Address => GPIOF_Base;

   PA0  : aliased GPIO_Point := (GPIO_A'Access, Pin_0);
   PA1  : aliased GPIO_Point := (GPIO_A'Access, Pin_1);
   PA2  : aliased GPIO_Point := (GPIO_A'Access, Pin_2);
   PA3  : aliased GPIO_Point := (GPIO_A'Access, Pin_3);
   PA4  : aliased GPIO_Point := (GPIO_A'Access, Pin_4);
   PA5  : aliased GPIO_Point := (GPIO_A'Access, Pin_5);
   PA6  : aliased GPIO_Point := (GPIO_A'Access, Pin_6);
   PA7  : aliased GPIO_Point := (GPIO_A'Access, Pin_7);
   PA8  : aliased GPIO_Point := (GPIO_A'Access, Pin_8);
   PA9  : aliased GPIO_Point := (GPIO_A'Access, Pin_9);
   PA10 : aliased GPIO_Point := (GPIO_A'Access, Pin_10);
   PA11 : aliased GPIO_Point := (GPIO_A'Access, Pin_11);
   PA12 : aliased GPIO_Point := (GPIO_A'Access, Pin_12);
   PA13 : aliased GPIO_Point := (GPIO_A'Access, Pin_13);
   PA14 : aliased GPIO_Point := (GPIO_A'Access, Pin_14);
   PA15 : aliased GPIO_Point := (GPIO_A'Access, Pin_15);
   PB0  : aliased GPIO_Point := (GPIO_B'Access, Pin_0);
   PB1  : aliased GPIO_Point := (GPIO_B'Access, Pin_1);
   PB2  : aliased GPIO_Point := (GPIO_B'Access, Pin_2);
   PB3  : aliased GPIO_Point := (GPIO_B'Access, Pin_3);
   PB4  : aliased GPIO_Point := (GPIO_B'Access, Pin_4);
   PB5  : aliased GPIO_Point := (GPIO_B'Access, Pin_5);
   PB6  : aliased GPIO_Point := (GPIO_B'Access, Pin_6);
   PB7  : aliased GPIO_Point := (GPIO_B'Access, Pin_7);
   PB8  : aliased GPIO_Point := (GPIO_B'Access, Pin_8);
   PB9  : aliased GPIO_Point := (GPIO_B'Access, Pin_9);
   PB10 : aliased GPIO_Point := (GPIO_B'Access, Pin_10);
   PB11 : aliased GPIO_Point := (GPIO_B'Access, Pin_11);
   PB12 : aliased GPIO_Point := (GPIO_B'Access, Pin_12);
   PB13 : aliased GPIO_Point := (GPIO_B'Access, Pin_13);
   PB14 : aliased GPIO_Point := (GPIO_B'Access, Pin_14);
   PB15 : aliased GPIO_Point := (GPIO_B'Access, Pin_15);
   PC0  : aliased GPIO_Point := (GPIO_C'Access, Pin_0);
   PC1  : aliased GPIO_Point := (GPIO_C'Access, Pin_1);
   PC2  : aliased GPIO_Point := (GPIO_C'Access, Pin_2);
   PC3  : aliased GPIO_Point := (GPIO_C'Access, Pin_3);
   PC4  : aliased GPIO_Point := (GPIO_C'Access, Pin_4);
   PC5  : aliased GPIO_Point := (GPIO_C'Access, Pin_5);
   PC6  : aliased GPIO_Point := (GPIO_C'Access, Pin_6);
   PC7  : aliased GPIO_Point := (GPIO_C'Access, Pin_7);
   PC8  : aliased GPIO_Point := (GPIO_C'Access, Pin_8);
   PC9  : aliased GPIO_Point := (GPIO_C'Access, Pin_9);
   PC10 : aliased GPIO_Point := (GPIO_C'Access, Pin_10);
   PC11 : aliased GPIO_Point := (GPIO_C'Access, Pin_11);
   PC12 : aliased GPIO_Point := (GPIO_C'Access, Pin_12);
   PC13 : aliased GPIO_Point := (GPIO_C'Access, Pin_13);
   PC14 : aliased GPIO_Point := (GPIO_C'Access, Pin_14);
   PC15 : aliased GPIO_Point := (GPIO_C'Access, Pin_15);
   PD0  : aliased GPIO_Point := (GPIO_D'Access, Pin_0);
   PD1  : aliased GPIO_Point := (GPIO_D'Access, Pin_1);
   PD2  : aliased GPIO_Point := (GPIO_D'Access, Pin_2);
   PD3  : aliased GPIO_Point := (GPIO_D'Access, Pin_3);
   PD4  : aliased GPIO_Point := (GPIO_D'Access, Pin_4);
   PD5  : aliased GPIO_Point := (GPIO_D'Access, Pin_5);
   PD6  : aliased GPIO_Point := (GPIO_D'Access, Pin_6);
   PD7  : aliased GPIO_Point := (GPIO_D'Access, Pin_7);
   PD8  : aliased GPIO_Point := (GPIO_D'Access, Pin_8);
   PD9  : aliased GPIO_Point := (GPIO_D'Access, Pin_9);
   PD10 : aliased GPIO_Point := (GPIO_D'Access, Pin_10);
   PD11 : aliased GPIO_Point := (GPIO_D'Access, Pin_11);
   PD12 : aliased GPIO_Point := (GPIO_D'Access, Pin_12);
   PD13 : aliased GPIO_Point := (GPIO_D'Access, Pin_13);
   PD14 : aliased GPIO_Point := (GPIO_D'Access, Pin_14);
   PD15 : aliased GPIO_Point := (GPIO_D'Access, Pin_15);
   PE0  : aliased GPIO_Point := (GPIO_E'Access, Pin_0);
   PE1  : aliased GPIO_Point := (GPIO_E'Access, Pin_1);
   PE2  : aliased GPIO_Point := (GPIO_E'Access, Pin_2);
   PE3  : aliased GPIO_Point := (GPIO_E'Access, Pin_3);
   PE4  : aliased GPIO_Point := (GPIO_E'Access, Pin_4);
   PE5  : aliased GPIO_Point := (GPIO_E'Access, Pin_5);
   PE6  : aliased GPIO_Point := (GPIO_E'Access, Pin_6);
   PE7  : aliased GPIO_Point := (GPIO_E'Access, Pin_7);
   PE8  : aliased GPIO_Point := (GPIO_E'Access, Pin_8);
   PE9  : aliased GPIO_Point := (GPIO_E'Access, Pin_9);
   PE10 : aliased GPIO_Point := (GPIO_E'Access, Pin_10);
   PE11 : aliased GPIO_Point := (GPIO_E'Access, Pin_11);
   PE12 : aliased GPIO_Point := (GPIO_E'Access, Pin_12);
   PE13 : aliased GPIO_Point := (GPIO_E'Access, Pin_13);
   PE14 : aliased GPIO_Point := (GPIO_E'Access, Pin_14);
   PE15 : aliased GPIO_Point := (GPIO_E'Access, Pin_15);
   PF0  : aliased GPIO_Point := (GPIO_F'Access, Pin_0);
   PF1  : aliased GPIO_Point := (GPIO_F'Access, Pin_1);
   PF2  : aliased GPIO_Point := (GPIO_F'Access, Pin_2);
   PF3  : aliased GPIO_Point := (GPIO_F'Access, Pin_3);
   PF6  : aliased GPIO_Point := (GPIO_F'Access, Pin_6);
   PF9  : aliased GPIO_Point := (GPIO_F'Access, Pin_9);
   PF10 : aliased GPIO_Point := (GPIO_F'Access, Pin_10);

   GPIO_A_AF_USART1_0 : constant GPIO_Alternate_Function;
   GPIO_A_AF_USART2_0 : constant GPIO_Alternate_Function;
   GPIO_B_AF_USART1_0 : constant GPIO_Alternate_Function;
   GPIO_C_AF_USART4_0 : constant GPIO_Alternate_Function;
   GPIO_D_AF_USART2_0 : constant GPIO_Alternate_Function;
   GPIO_D_AF_USART3_0 : constant GPIO_Alternate_Function;

   GPIO_C_AF_USART3_0 : constant GPIO_Alternate_Function;
   GPIO_A_AF_USART4_4 : constant GPIO_Alternate_Function;
   GPIO_B_AF_USART4_4 : constant GPIO_Alternate_Function;
   GPIO_B_AF_USART3_4 : constant GPIO_Alternate_Function;

   GPIO_AF_RTC_50Hz_0 : constant GPIO_Alternate_Function;
   GPIO_AF_MCO_0      : constant GPIO_Alternate_Function;
   GPIO_AF_TAMPER_0   : constant GPIO_Alternate_Function;
   GPIO_AF_SWJ_0      : constant GPIO_Alternate_Function;
   GPIO_AF_TRACE_0    : constant GPIO_Alternate_Function;
   GPIO_AF_TIM1_1     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM2_1     : constant GPIO_Alternate_Function;

   GPIO_AF_TIM3_2  : constant GPIO_Alternate_Function;
   GPIO_AF_TIM4_2  : constant GPIO_Alternate_Function;
   GPIO_AF_TIM5_2  : constant GPIO_Alternate_Function;
   GPIO_AF_TIM8_3  : constant GPIO_Alternate_Function;
   GPIO_AF_TIM9_3  : constant GPIO_Alternate_Function;
   GPIO_AF_TIM10_3 : constant GPIO_Alternate_Function;
   GPIO_AF_TIM11_3 : constant GPIO_Alternate_Function;

   GPIO_AF_I2C1_4      : constant GPIO_Alternate_Function;
   GPIO_AF_I2C2_4      : constant GPIO_Alternate_Function;
   GPIO_AF_I2C3_4      : constant GPIO_Alternate_Function;
   GPIO_AF_SPI1_5      : constant GPIO_Alternate_Function;
   GPIO_AF_SPI2_5      : constant GPIO_Alternate_Function;
   GPIO_AF_I2S2_5      : constant GPIO_Alternate_Function;
   GPIO_AF_I2S2ext_5   : constant GPIO_Alternate_Function;
   GPIO_AF_SPI3_6      : constant GPIO_Alternate_Function;
   GPIO_AF_I2S3_6      : constant GPIO_Alternate_Function;
   GPIO_AF_I2Sext_6    : constant GPIO_Alternate_Function;
   GPIO_AF_I2S3ext_7   : constant GPIO_Alternate_Function;
   GPIO_AF_CAN1_9      : constant GPIO_Alternate_Function;
   GPIO_AF_CAN2_9      : constant GPIO_Alternate_Function;
   GPIO_AF_TIM12_9     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM13_9     : constant GPIO_Alternate_Function;
   GPIO_AF_TIM14_9     : constant GPIO_Alternate_Function;
   GPIO_AF_OTG_FS_10   : constant GPIO_Alternate_Function;
   GPIO_AF_OTG_HS_10   : constant GPIO_Alternate_Function;
   GPIO_AF_ETH_11      : constant GPIO_Alternate_Function;
   GPIO_AF_FMC_12      : constant GPIO_Alternate_Function;
   GPIO_AF_OTG_FS_12   : constant GPIO_Alternate_Function;
   GPIO_AF_SDIO_12     : constant GPIO_Alternate_Function;
   GPIO_AF_DCMI_13     : constant GPIO_Alternate_Function;
   GPIO_AF_EVENTOUT_15 : constant GPIO_Alternate_Function;

   -----------------------------
   -- Reset and Clock Control --
   -----------------------------

   type RCC_System_Clocks is record
      SYSCLK : UInt32;
      HCLK   : UInt32;  --  AHB clock
      PCLK   : UInt32;  --  APB clock
      CRS    : UInt32;
   end record;

   function System_Clock_Frequencies return RCC_System_Clocks;

   UDC : aliased STM32.USB_Device.UDC;

   Internal_USART_1 : aliased Internal_USART
   with Import, Volatile, Address => USART1_Base;
   Internal_USART_2 : aliased Internal_USART
   with Import, Volatile, Address => USART2_Base;
   Internal_USART_3 : aliased Internal_USART
   with Import, Volatile, Address => USART3_Base;
   Internal_USART_4 : aliased Internal_USART
   with Import, Volatile, Address => USART4_Base;

   USART_1 : aliased USART (Internal_USART_1'Access);
   USART_2 : aliased USART (Internal_USART_2'Access);
   USART_3 : aliased USART (Internal_USART_3'Access);
   USART_4 : aliased USART (Internal_USART_4'Access);

   procedure Enable_Clock (This : aliased in out USART);

   procedure Reset (This : aliased in out USART);

   Timer_1 : aliased Timer
   with Import, Volatile, Address => TIM1_Base;
   Timer_2 : aliased Timer
   with Import, Volatile, Address => TIM2_Base;
   Timer_3 : aliased Timer
   with Import, Volatile, Address => TIM3_Base;

   Timer_14 : aliased Timer
   with Import, Volatile, Address => TIM14_Base;
   Timer_15 : aliased Timer
   with Import, Volatile, Address => TIM15_Base;
   Timer_16 : aliased Timer
   with Import, Volatile, Address => TIM16_Base;
   Timer_17 : aliased Timer
   with Import, Volatile, Address => TIM17_Base;

   Timer_6 : aliased Timer
   with Import, Volatile, Address => TIM6_Base;
   Timer_7 : aliased Timer
   with Import, Volatile, Address => TIM7_Base;

   procedure Enable_Clock (This : in out Timer);

   procedure Reset (This : in out Timer);

private

   GPIO_A_AF_USART1_0 : constant GPIO_Alternate_Function := 0;
   GPIO_A_AF_USART2_0 : constant GPIO_Alternate_Function := 0;
   GPIO_B_AF_USART1_0 : constant GPIO_Alternate_Function := 0;
   GPIO_C_AF_USART4_0 : constant GPIO_Alternate_Function := 0;
   GPIO_D_AF_USART2_0 : constant GPIO_Alternate_Function := 0;
   GPIO_D_AF_USART3_0 : constant GPIO_Alternate_Function := 0;

   GPIO_AF_RTC_50Hz_0 : constant GPIO_Alternate_Function := 0;
   GPIO_AF_MCO_0      : constant GPIO_Alternate_Function := 0;
   GPIO_AF_TAMPER_0   : constant GPIO_Alternate_Function := 0;
   GPIO_AF_SWJ_0      : constant GPIO_Alternate_Function := 0;
   GPIO_AF_TRACE_0    : constant GPIO_Alternate_Function := 0;
   GPIO_AF_TIM1_1     : constant GPIO_Alternate_Function := 1;
   GPIO_AF_TIM2_1     : constant GPIO_Alternate_Function := 1;

   GPIO_AF_TIM3_2 : constant GPIO_Alternate_Function := 2;
   GPIO_AF_TIM4_2 : constant GPIO_Alternate_Function := 2;
   GPIO_AF_TIM5_2 : constant GPIO_Alternate_Function := 2;

   GPIO_C_AF_USART3_0 : constant GPIO_Alternate_Function := 3;
   GPIO_AF_TIM8_3     : constant GPIO_Alternate_Function := 3;
   GPIO_AF_TIM9_3     : constant GPIO_Alternate_Function := 3;
   GPIO_AF_TIM10_3    : constant GPIO_Alternate_Function := 3;
   GPIO_AF_TIM11_3    : constant GPIO_Alternate_Function := 3;

   GPIO_A_AF_USART4_4 : constant GPIO_Alternate_Function := 4;
   GPIO_B_AF_USART4_4 : constant GPIO_Alternate_Function := 4;
   GPIO_B_AF_USART3_4 : constant GPIO_Alternate_Function := 4;

   GPIO_AF_I2C1_4    : constant GPIO_Alternate_Function := 4;
   GPIO_AF_I2C2_4    : constant GPIO_Alternate_Function := 4;
   GPIO_AF_I2C3_4    : constant GPIO_Alternate_Function := 4;
   GPIO_AF_SPI1_5    : constant GPIO_Alternate_Function := 5;
   GPIO_AF_SPI2_5    : constant GPIO_Alternate_Function := 5;
   GPIO_AF_I2S2_5    : constant GPIO_Alternate_Function := 5;
   GPIO_AF_I2S2ext_5 : constant GPIO_Alternate_Function := 5;
   GPIO_AF_SPI3_6    : constant GPIO_Alternate_Function := 6;
   GPIO_AF_I2S3_6    : constant GPIO_Alternate_Function := 6;
   GPIO_AF_I2Sext_6  : constant GPIO_Alternate_Function := 6;
   GPIO_AF_I2S3ext_7 : constant GPIO_Alternate_Function := 7;

   GPIO_AF_CAN1_9      : constant GPIO_Alternate_Function := 9;
   GPIO_AF_CAN2_9      : constant GPIO_Alternate_Function := 9;
   GPIO_AF_TIM12_9     : constant GPIO_Alternate_Function := 9;
   GPIO_AF_TIM13_9     : constant GPIO_Alternate_Function := 9;
   GPIO_AF_TIM14_9     : constant GPIO_Alternate_Function := 9;
   GPIO_AF_OTG_FS_10   : constant GPIO_Alternate_Function := 10;
   GPIO_AF_OTG_HS_10   : constant GPIO_Alternate_Function := 10;
   GPIO_AF_ETH_11      : constant GPIO_Alternate_Function := 11;
   GPIO_AF_FMC_12      : constant GPIO_Alternate_Function := 12;
   GPIO_AF_OTG_FS_12   : constant GPIO_Alternate_Function := 12;
   GPIO_AF_SDIO_12     : constant GPIO_Alternate_Function := 12;
   GPIO_AF_DCMI_13     : constant GPIO_Alternate_Function := 13;
   GPIO_AF_EVENTOUT_15 : constant GPIO_Alternate_Function := 15;

end STM32.Device;
