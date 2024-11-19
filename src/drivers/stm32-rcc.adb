--  SPDX-License-Identifier: BSD-3-Clause

--  Copyright 2022 (C) Marc PoulhiÃ¨s
--  This file has been adapted for the STM32F0 (ARM Cortex M4)
--  Beware that most of this has been reused from Ada Drivers Library
--  (https://github.com/AdaCore/Ada_Drivers_Library) and has been
--  tested (as of this writing) in only one very restricted scenario.

with STM32_SVD.PWR; use STM32_SVD.PWR;
with STM32_SVD.RCC; use STM32_SVD.RCC;
with STM32_SVD.CRS; use STM32_SVD.CRS;

package body STM32.RCC is

   procedure Set_Sys_Clock_Source
     (This : in out Rcc_Cfgr; Source : Sys_Clock_Source) is
   begin
      This.Clock_Source := Source;
   end Set_Sys_Clock_Source;

   procedure Enable_Crs (This : in out Rcc_Cfgr) is
   begin
      This.Use_Crs := True;
   end Enable_Crs;

   procedure Set_Sys_Clock (This : in out Rcc_Cfgr; Freq : Positive) is
   begin
      This.Sysclk := Freq;
   end Set_Sys_Clock;

   procedure Set_P_Clock (This : in out Rcc_Cfgr; Freq : Positive) is
   begin
      This.Pclk := Freq;
   end Set_P_Clock;

   function Get_Freq (Source : Sys_Clock_Source) return Positive is
   begin
      case Source is
         when Hse =>
            return Hse_Freq;

         when Hsi =>
            return Hsi_Freq;

         when Hsi48 =>
            return HSI48_Freq;
      end case;
   end Get_Freq;

   procedure Enable_Clock (Source : Sys_Clock_Source) is
   begin
      case Source is
         when Hsi =>
            RCC_Periph.CR.HSION := True;
            while not RCC_Periph.CR.HSIRDY loop
               null;
            end loop;

         when Hsi48 =>
            RCC_Periph.CR2.HSI48ON := True;
            while not RCC_Periph.CR2.HSI48RDY loop
               null;
            end loop;

         when Hse =>
            raise Program_Error;
      end case;
   end Enable_Clock;

   procedure Freeze (This : in out Rcc_Cfgr) is
      Src_Clock_Freq : constant Positive := Get_Freq (This.Clock_Source);
      Pllmul_Bits    : Integer := 0;

      --  Real_Sysclk : Natural := 0;

      --  do not divide AHB clock
      --  Hpre_Bits : constant CFGR_HPRE_Field := 0;

      --  do not divide APB clock
      --  Ppre_Bits : constant CFGR_PPRE_Field := 0;

      Cfgr_To_Write : STM32_SVD.RCC.CFGR_Register;
   begin

      if This.Sysclk = Src_Clock_Freq then
         Pllmul_Bits := 0;
         --  Real_Sysclk := Src_Clock_Freq;

      else
         --  User requests a freq that needs some config.
         raise Program_Error;
      end if;

      --  FIXME: adjust flash wait states.

      Enable_Clock (This.Clock_Source);

      -- FIXME: enable USB clock selected
      case This.Usb_Source is
         when PLL =>
            --  no pll support yet
            raise Program_Error;

         when HSI48 =>
            --  False : HSI48, True : PLL
            RCC_Periph.CFGR3.USBSW := False;
      end case;

      if Pllmul_Bits /= 0 then
         --  no pll support
         raise Program_Error;
      end if;

      if This.Use_Crs then
         RCC_Periph.APB1ENR.CRSEN := True;
         CRS_Periph.CR.AUTOTRIMEN := True;
         CRS_Periph.CR.CEN := True;
      end if;

      --  write config
      Cfgr_To_Write.Sw := 16#02#; -- HSI48
      RCC_Periph.CFGR := Cfgr_To_Write;
   end Freeze;

end STM32.RCC;
