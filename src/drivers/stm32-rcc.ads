--  SPDX-License-Identifier: BSD-3-Clause

--  Copyright 2022 (C) Marc PoulhiÃ¨s
--  This file has been adapted for the STM32F0 (ARM Cortex M4)
--  Beware that most of this has been reused from Ada Drivers Library
--  (https://github.com/AdaCore/Ada_Drivers_Library) and has been
--  tested (as of this writing) in only one very restricted scenario.

pragma Restrictions (No_Elaboration_Code);

package STM32.RCC is
   type Sys_Clock_Source is (HSI, HSE, HSI48);
   HSI_Freq   : constant Positive := 8_000_000;
   HSI48_Freq : constant Positive := 48_000_000;
   HSE_Freq   : Positive := Positive'Last;

   type Usb_Clock_Source is (HSI48, PLL);

   type Rcc_Cfgr is record
      Hclk         : Natural := 0;
      Pclk         : Natural := 0;
      Sysclk       : Natural := 0;
      Clock_Source : Sys_Clock_Source := HSI;
      Usb_Source   : Usb_Clock_Source := HSI48;
      Use_Crs      : Boolean := False;
   end record;

   procedure Set_Sys_Clock_Source
     (This : in out Rcc_Cfgr; Source : Sys_Clock_Source);
   procedure Enable_Crs (This : in out Rcc_Cfgr);
   procedure Set_Sys_Clock (This : in out Rcc_Cfgr; Freq : Positive);
   procedure Set_P_Clock (This : in out Rcc_Cfgr; Freq : Positive);

   procedure Freeze (This : in out Rcc_Cfgr);
end STM32.RCC;
