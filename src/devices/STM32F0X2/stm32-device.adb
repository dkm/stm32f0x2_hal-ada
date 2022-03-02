with System; use System;

with STM32_SVD.RCC; use STM32_SVD.RCC;

package body STM32.Device is

   ------------------------------
   -- GPIO_Port_Representation --
   ------------------------------

   function GPIO_Port_Representation (Port : GPIO_Port) return UInt4 is
   begin
      --  TODO: rather ugly to have this board-specific range here
      if Port'Address = GPIOA_Base then
         return 0;
      elsif Port'Address = GPIOB_Base then
         return 1;
      elsif Port'Address = GPIOC_Base then
         return 2;
      elsif Port'Address = GPIOD_Base then
         return 3;
      elsif Port'Address = GPIOE_Base then
         return 4;
      elsif Port'Address = GPIOF_Base then
         return 5;
      else
         raise Program_Error;
      end if;
   end GPIO_Port_Representation;


   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (This : aliased in out GPIO_Port) is
   begin
      if This'Address = GPIOA_Base then
         RCC_Periph.AHBENR.IOPAEN := True;
      elsif This'Address = GPIOB_Base then
         RCC_Periph.AHBENR.IOPBEN := True;
      elsif This'Address = GPIOC_Base then
         RCC_Periph.AHBENR.IOPCEN := True;
      elsif This'Address = GPIOD_Base then
         RCC_Periph.AHBENR.IOPDEN := True;
      --  elsif This'Address = GPIOE_Base then
      --     RCC_Periph.AHBENR.IOPEEN := True;
      elsif This'Address = GPIOF_Base then
         RCC_Periph.AHBENR.IOPFEN := True;
      else
         raise Unknown_Device;
      end if;
   end Enable_Clock;


   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (Point : GPIO_Point)
   is
   begin
      Enable_Clock (Point.Periph.all);
   end Enable_Clock;

   ------------------
   -- Enable_Clock --
   ------------------

   procedure Enable_Clock (Points : GPIO_Points)
   is
   begin
      for Point of Points loop
         Enable_Clock (Point.Periph.all);
      end loop;
   end Enable_Clock;

   -----------
   -- Reset --
   -----------

   procedure Reset (This : aliased in out GPIO_Port) is
   begin
      if This'Address = GPIOA_Base then
         RCC_Periph.AHBRSTR.IOPARST := True;
         RCC_Periph.AHBRSTR.IOPARST := False;
      elsif This'Address = GPIOB_Base then
         RCC_Periph.AHBRSTR.IOPBRST := True;
         RCC_Periph.AHBRSTR.IOPBRST := False;
      elsif This'Address = GPIOC_Base then
         RCC_Periph.AHBRSTR.IOPCRST := True;
         RCC_Periph.AHBRSTR.IOPCRST := False;
      elsif This'Address = GPIOD_Base then
         RCC_Periph.AHBRSTR.IOPDRST := True;
         RCC_Periph.AHBRSTR.IOPDRST := False;
      --  elsif This'Address = GPIOE_Base then
      --     RCC_Periph.AHBRSTR.IOPERST := True;
      --     RCC_Periph.AHBRSTR.IOPERST := False;
      elsif This'Address = GPIOF_Base then
         RCC_Periph.AHBRSTR.IOPFRST := True;
         RCC_Periph.AHBRSTR.IOPFRST := False;
      else
         raise Unknown_Device;
      end if;
   end Reset;

   -----------
   -- Reset --
   -----------

   procedure Reset (Point : GPIO_Point) is
   begin
      Reset (Point.Periph.all);
   end Reset;

   -----------
   -- Reset --
   -----------

   procedure Reset (Points : GPIO_Points) is
        Do_Reset : Boolean;
   begin
      for J in Points'Range loop
         Do_Reset := True;
         for K in Points'First .. J - 1 loop
            if Points (K).Periph = Points (J).Periph then
               Do_Reset := False;

               exit;
            end if;
         end loop;

         if Do_Reset then
            Reset (Points (J).Periph.all);
         end if;
      end loop;
   end Reset;

end STM32.Device;