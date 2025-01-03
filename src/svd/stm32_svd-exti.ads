pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F0x2.svd

pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package STM32_SVD.EXTI is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   --  IMR_MR array
   type IMR_MR_Field_Array is array (0 .. 27) of Boolean
   with Component_Size => 1, Size => 28;

   --  Type definition for IMR_MR
   type IMR_MR_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  MR as a value
            Val : HAL.UInt28;

         when True =>
            --  MR as an array
            Arr : IMR_MR_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 28;

   for IMR_MR_Field use
     record
       Val at 0 range 0 .. 27;
       Arr at 0 range 0 .. 27;
     end record;

   --  Interrupt mask register (EXTI_IMR)
   type IMR_Register is record
      --  Interrupt Mask on line 0
      MR             : IMR_MR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_28_31 : HAL.UInt4 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for IMR_Register use
     record
       MR at 0 range 0 .. 27;
       Reserved_28_31 at 0 range 28 .. 31;
     end record;

   --  EMR_MR array
   type EMR_MR_Field_Array is array (0 .. 27) of Boolean
   with Component_Size => 1, Size => 28;

   --  Type definition for EMR_MR
   type EMR_MR_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  MR as a value
            Val : HAL.UInt28;

         when True =>
            --  MR as an array
            Arr : EMR_MR_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 28;

   for EMR_MR_Field use
     record
       Val at 0 range 0 .. 27;
       Arr at 0 range 0 .. 27;
     end record;

   --  Event mask register (EXTI_EMR)
   type EMR_Register is record
      --  Event Mask on line 0
      MR             : EMR_MR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_28_31 : HAL.UInt4 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for EMR_Register use
     record
       MR at 0 range 0 .. 27;
       Reserved_28_31 at 0 range 28 .. 31;
     end record;

   --  RTSR_TR array
   type RTSR_TR_Field_Array is array (0 .. 17) of Boolean
   with Component_Size => 1, Size => 18;

   --  Type definition for RTSR_TR
   type RTSR_TR_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  TR as a value
            Val : HAL.UInt18;

         when True =>
            --  TR as an array
            Arr : RTSR_TR_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 18;

   for RTSR_TR_Field use
     record
       Val at 0 range 0 .. 17;
       Arr at 0 range 0 .. 17;
     end record;

   --  Rising Trigger selection register (EXTI_RTSR)
   type RTSR_Register is record
      --  Rising trigger event configuration of line 0
      TR             : RTSR_TR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Rising trigger event configuration of line 19
      TR19           : Boolean := False;
      --  unspecified
      Reserved_20_31 : HAL.UInt12 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for RTSR_Register use
     record
       TR at 0 range 0 .. 17;
       Reserved_18_18 at 0 range 18 .. 18;
       TR19 at 0 range 19 .. 19;
       Reserved_20_31 at 0 range 20 .. 31;
     end record;

   --  FTSR_TR array
   type FTSR_TR_Field_Array is array (0 .. 17) of Boolean
   with Component_Size => 1, Size => 18;

   --  Type definition for FTSR_TR
   type FTSR_TR_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  TR as a value
            Val : HAL.UInt18;

         when True =>
            --  TR as an array
            Arr : FTSR_TR_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 18;

   for FTSR_TR_Field use
     record
       Val at 0 range 0 .. 17;
       Arr at 0 range 0 .. 17;
     end record;

   --  Falling Trigger selection register (EXTI_FTSR)
   type FTSR_Register is record
      --  Falling trigger event configuration of line 0
      TR             : FTSR_TR_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Falling trigger event configuration of line 19
      TR19           : Boolean := False;
      --  unspecified
      Reserved_20_31 : HAL.UInt12 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for FTSR_Register use
     record
       TR at 0 range 0 .. 17;
       Reserved_18_18 at 0 range 18 .. 18;
       TR19 at 0 range 19 .. 19;
       Reserved_20_31 at 0 range 20 .. 31;
     end record;

   --  SWIER array
   type SWIER_Field_Array is array (0 .. 17) of Boolean
   with Component_Size => 1, Size => 18;

   --  Type definition for SWIER
   type SWIER_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  SWIER as a value
            Val : HAL.UInt18;

         when True =>
            --  SWIER as an array
            Arr : SWIER_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 18;

   for SWIER_Field use
     record
       Val at 0 range 0 .. 17;
       Arr at 0 range 0 .. 17;
     end record;

   --  Software interrupt event register (EXTI_SWIER)
   type SWIER_Register is record
      --  Software Interrupt on line 0
      SWIER          : SWIER_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Software Interrupt on line 19
      SWIER19        : Boolean := False;
      --  unspecified
      Reserved_20_31 : HAL.UInt12 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for SWIER_Register use
     record
       SWIER at 0 range 0 .. 17;
       Reserved_18_18 at 0 range 18 .. 18;
       SWIER19 at 0 range 19 .. 19;
       Reserved_20_31 at 0 range 20 .. 31;
     end record;

   --  PR_PIF array
   type PR_PIF_Field_Array is array (0 .. 17) of Boolean
   with Component_Size => 1, Size => 18;

   --  Type definition for PR_PIF
   type PR_PIF_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  PIF as a value
            Val : HAL.UInt18;

         when True =>
            --  PIF as an array
            Arr : PR_PIF_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 18;

   for PR_PIF_Field use
     record
       Val at 0 range 0 .. 17;
       Arr at 0 range 0 .. 17;
     end record;

   --  PR_PIF array
   type PR_PIF_Field_Array_1 is array (19 .. 22) of Boolean
   with Component_Size => 1, Size => 4;

   --  Type definition for PR_PIF
   type PR_PIF_Field_1 (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  PIF as a value
            Val : HAL.UInt4;

         when True =>
            --  PIF as an array
            Arr : PR_PIF_Field_Array_1;
      end case;
   end record
   with Unchecked_Union, Size => 4;

   for PR_PIF_Field_1 use
     record
       Val at 0 range 0 .. 3;
       Arr at 0 range 0 .. 3;
     end record;

   --  Pending register (EXTI_PR)
   type PR_Register is record
      --  Pending interrupt flag on line 0
      PIF            : PR_PIF_Field := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_18_18 : HAL.Bit := 16#0#;
      --  Pending interrupt flag on line 19
      PIF_1          : PR_PIF_Field_1 := (As_Array => False, Val => 16#0#);
      --  unspecified
      Reserved_23_30 : HAL.UInt8 := 16#0#;
      --  Pending interrupt flag on line 31
      PIF31          : Boolean := False;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for PR_Register use
     record
       PIF at 0 range 0 .. 17;
       Reserved_18_18 at 0 range 18 .. 18;
       PIF_1 at 0 range 19 .. 22;
       Reserved_23_30 at 0 range 23 .. 30;
       PIF31 at 0 range 31 .. 31;
     end record;

   -----------------
   -- Peripherals --
   -----------------

   --  External interrupt/event controller
   type EXTI_Peripheral is record
      --  Interrupt mask register (EXTI_IMR)
      IMR   : aliased IMR_Register;
      --  Event mask register (EXTI_EMR)
      EMR   : aliased EMR_Register;
      --  Rising Trigger selection register (EXTI_RTSR)
      RTSR  : aliased RTSR_Register;
      --  Falling Trigger selection register (EXTI_FTSR)
      FTSR  : aliased FTSR_Register;
      --  Software interrupt event register (EXTI_SWIER)
      SWIER : aliased SWIER_Register;
      --  Pending register (EXTI_PR)
      PR    : aliased PR_Register;
   end record
   with Volatile;

   for EXTI_Peripheral use
     record
       IMR at 16#0# range 0 .. 31;
       EMR at 16#4# range 0 .. 31;
       RTSR at 16#8# range 0 .. 31;
       FTSR at 16#C# range 0 .. 31;
       SWIER at 16#10# range 0 .. 31;
       PR at 16#14# range 0 .. 31;
     end record;

   --  External interrupt/event controller
   EXTI_Periph : aliased EXTI_Peripheral
   with Import, Address => EXTI_Base;

end STM32_SVD.EXTI;
