pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F0x2.svd

pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package STM32_SVD.SCB is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CPUID_Revision_Field is HAL.UInt4;
   subtype CPUID_PartNo_Field is HAL.UInt12;
   subtype CPUID_Constant_Field is HAL.UInt4;
   subtype CPUID_Variant_Field is HAL.UInt4;
   subtype CPUID_Implementer_Field is HAL.UInt8;

   --  CPUID base register
   type CPUID_Register is record
      --  Read-only. Revision number
      Revision    : CPUID_Revision_Field;
      --  Read-only. Part number of the processor
      PartNo      : CPUID_PartNo_Field;
      --  Read-only. Reads as 0xF
      Constant_k  : CPUID_Constant_Field;
      --  Read-only. Variant number
      Variant     : CPUID_Variant_Field;
      --  Read-only. Implementer code
      Implementer : CPUID_Implementer_Field;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for CPUID_Register use
     record
       Revision at 0 range 0 .. 3;
       PartNo at 0 range 4 .. 15;
       Constant_k at 0 range 16 .. 19;
       Variant at 0 range 20 .. 23;
       Implementer at 0 range 24 .. 31;
     end record;

   subtype ICSR_VECTACTIVE_Field is HAL.UInt6;
   subtype ICSR_VECTPENDING_Field is HAL.UInt6;

   --  Interrupt control and state register
   type ICSR_Register is record
      --  Active vector
      VECTACTIVE     : ICSR_VECTACTIVE_Field := 16#0#;
      --  unspecified
      Reserved_6_11  : HAL.UInt6 := 16#0#;
      --  Pending vector
      VECTPENDING    : ICSR_VECTPENDING_Field := 16#0#;
      --  unspecified
      Reserved_18_21 : HAL.UInt4 := 16#0#;
      --  Interrupt pending flag
      ISRPENDING     : Boolean := False;
      --  unspecified
      Reserved_23_24 : HAL.UInt2 := 16#0#;
      --  SysTick exception clear-pending bit
      PENDSTCLR      : Boolean := False;
      --  SysTick exception set-pending bit
      PENDSTSET      : Boolean := False;
      --  PendSV clear-pending bit
      PENDSVCLR      : Boolean := False;
      --  PendSV set-pending bit
      PENDSVSET      : Boolean := False;
      --  unspecified
      Reserved_29_30 : HAL.UInt2 := 16#0#;
      --  NMI set-pending bit.
      NMIPENDSET     : Boolean := False;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for ICSR_Register use
     record
       VECTACTIVE at 0 range 0 .. 5;
       Reserved_6_11 at 0 range 6 .. 11;
       VECTPENDING at 0 range 12 .. 17;
       Reserved_18_21 at 0 range 18 .. 21;
       ISRPENDING at 0 range 22 .. 22;
       Reserved_23_24 at 0 range 23 .. 24;
       PENDSTCLR at 0 range 25 .. 25;
       PENDSTSET at 0 range 26 .. 26;
       PENDSVCLR at 0 range 27 .. 27;
       PENDSVSET at 0 range 28 .. 28;
       Reserved_29_30 at 0 range 29 .. 30;
       NMIPENDSET at 0 range 31 .. 31;
     end record;

   subtype AIRCR_VECTKEYSTAT_Field is HAL.UInt16;

   --  Application interrupt and reset control register
   type AIRCR_Register is record
      --  unspecified
      Reserved_0_0  : HAL.Bit := 16#0#;
      --  VECTCLRACTIVE
      VECTCLRACTIVE : Boolean := False;
      --  SYSRESETREQ
      SYSRESETREQ   : Boolean := False;
      --  unspecified
      Reserved_3_14 : HAL.UInt12 := 16#0#;
      --  ENDIANESS
      ENDIANESS     : Boolean := False;
      --  Register key
      VECTKEYSTAT   : AIRCR_VECTKEYSTAT_Field := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for AIRCR_Register use
     record
       Reserved_0_0 at 0 range 0 .. 0;
       VECTCLRACTIVE at 0 range 1 .. 1;
       SYSRESETREQ at 0 range 2 .. 2;
       Reserved_3_14 at 0 range 3 .. 14;
       ENDIANESS at 0 range 15 .. 15;
       VECTKEYSTAT at 0 range 16 .. 31;
     end record;

   --  System control register
   type SCR_Register is record
      --  unspecified
      Reserved_0_0  : HAL.Bit := 16#0#;
      --  SLEEPONEXIT
      SLEEPONEXIT   : Boolean := False;
      --  SLEEPDEEP
      SLEEPDEEP     : Boolean := False;
      --  unspecified
      Reserved_3_3  : HAL.Bit := 16#0#;
      --  Send Event on Pending bit
      SEVEONPEND    : Boolean := False;
      --  unspecified
      Reserved_5_31 : HAL.UInt27 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SCR_Register use
     record
       Reserved_0_0 at 0 range 0 .. 0;
       SLEEPONEXIT at 0 range 1 .. 1;
       SLEEPDEEP at 0 range 2 .. 2;
       Reserved_3_3 at 0 range 3 .. 3;
       SEVEONPEND at 0 range 4 .. 4;
       Reserved_5_31 at 0 range 5 .. 31;
     end record;

   --  Configuration and control register
   type CCR_Register is record
      --  unspecified
      Reserved_0_2   : HAL.UInt3 := 16#0#;
      --  UNALIGN_ TRP
      UNALIGN_TRP    : Boolean := False;
      --  unspecified
      Reserved_4_8   : HAL.UInt5 := 16#0#;
      --  STKALIGN
      STKALIGN       : Boolean := False;
      --  unspecified
      Reserved_10_31 : HAL.UInt22 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for CCR_Register use
     record
       Reserved_0_2 at 0 range 0 .. 2;
       UNALIGN_TRP at 0 range 3 .. 3;
       Reserved_4_8 at 0 range 4 .. 8;
       STKALIGN at 0 range 9 .. 9;
       Reserved_10_31 at 0 range 10 .. 31;
     end record;

   subtype SHPR2_PRI_11_Field is HAL.UInt8;

   --  System handler priority registers
   type SHPR2_Register is record
      --  unspecified
      Reserved_0_23 : HAL.UInt24 := 16#0#;
      --  Priority of system handler 11
      PRI_11        : SHPR2_PRI_11_Field := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SHPR2_Register use
     record
       Reserved_0_23 at 0 range 0 .. 23;
       PRI_11 at 0 range 24 .. 31;
     end record;

   subtype SHPR3_PRI_14_Field is HAL.UInt8;
   subtype SHPR3_PRI_15_Field is HAL.UInt8;

   --  System handler priority registers
   type SHPR3_Register is record
      --  unspecified
      Reserved_0_15 : HAL.UInt16 := 16#0#;
      --  Priority of system handler 14
      PRI_14        : SHPR3_PRI_14_Field := 16#0#;
      --  Priority of system handler 15
      PRI_15        : SHPR3_PRI_15_Field := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SHPR3_Register use
     record
       Reserved_0_15 at 0 range 0 .. 15;
       PRI_14 at 0 range 16 .. 23;
       PRI_15 at 0 range 24 .. 31;
     end record;

   -----------------
   -- Peripherals --
   -----------------

   --  System control block
   type SCB_Peripheral is record
      --  CPUID base register
      CPUID : aliased CPUID_Register;
      --  Interrupt control and state register
      ICSR  : aliased ICSR_Register;
      --  Application interrupt and reset control register
      AIRCR : aliased AIRCR_Register;
      --  System control register
      SCR   : aliased SCR_Register;
      --  Configuration and control register
      CCR   : aliased CCR_Register;
      --  System handler priority registers
      SHPR2 : aliased SHPR2_Register;
      --  System handler priority registers
      SHPR3 : aliased SHPR3_Register;
   end record
   with Volatile;

   for SCB_Peripheral use
     record
       CPUID at 16#0# range 0 .. 31;
       ICSR at 16#4# range 0 .. 31;
       AIRCR at 16#C# range 0 .. 31;
       SCR at 16#10# range 0 .. 31;
       CCR at 16#14# range 0 .. 31;
       SHPR2 at 16#1C# range 0 .. 31;
       SHPR3 at 16#20# range 0 .. 31;
     end record;

   --  System control block
   SCB_Periph : aliased SCB_Peripheral
   with Import, Address => SCB_Base;

end STM32_SVD.SCB;
