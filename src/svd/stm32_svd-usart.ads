pragma Style_Checks (Off);

--  This spec has been automatically generated from STM32F0x2.svd

pragma Restrictions (No_Elaboration_Code);

with HAL;
with System;

package STM32_SVD.USART is
   pragma Preelaborate;

   ---------------
   -- Registers --
   ---------------

   subtype CR1_DEDT_Field is HAL.UInt5;
   subtype CR1_DEAT_Field is HAL.UInt5;

   --  Control register 1
   type CR1_Register is record
      --  USART enable
      UE             : Boolean := False;
      --  USART enable in Stop mode
      UESM           : Boolean := False;
      --  Receiver enable
      RE             : Boolean := False;
      --  Transmitter enable
      TE             : Boolean := False;
      --  IDLE interrupt enable
      IDLEIE         : Boolean := False;
      --  RXNE interrupt enable
      RXNEIE         : Boolean := False;
      --  Transmission complete interrupt enable
      TCIE           : Boolean := False;
      --  interrupt enable
      TXEIE          : Boolean := False;
      --  PE interrupt enable
      PEIE           : Boolean := False;
      --  Parity selection
      PS             : Boolean := False;
      --  Parity control enable
      PCE            : Boolean := False;
      --  Receiver wakeup method
      WAKE           : Boolean := False;
      --  Word length
      M              : Boolean := False;
      --  Mute mode enable
      MME            : Boolean := False;
      --  Character match interrupt enable
      CMIE           : Boolean := False;
      --  Oversampling mode
      OVER8          : Boolean := False;
      --  Driver Enable deassertion time
      DEDT           : CR1_DEDT_Field := 16#0#;
      --  Driver Enable assertion time
      DEAT           : CR1_DEAT_Field := 16#0#;
      --  Receiver timeout interrupt enable
      RTOIE          : Boolean := False;
      --  End of Block interrupt enable
      EOBIE          : Boolean := False;
      --  Word length
      M1             : Boolean := False;
      --  unspecified
      Reserved_29_31 : HAL.UInt3 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for CR1_Register use
     record
       UE at 0 range 0 .. 0;
       UESM at 0 range 1 .. 1;
       RE at 0 range 2 .. 2;
       TE at 0 range 3 .. 3;
       IDLEIE at 0 range 4 .. 4;
       RXNEIE at 0 range 5 .. 5;
       TCIE at 0 range 6 .. 6;
       TXEIE at 0 range 7 .. 7;
       PEIE at 0 range 8 .. 8;
       PS at 0 range 9 .. 9;
       PCE at 0 range 10 .. 10;
       WAKE at 0 range 11 .. 11;
       M at 0 range 12 .. 12;
       MME at 0 range 13 .. 13;
       CMIE at 0 range 14 .. 14;
       OVER8 at 0 range 15 .. 15;
       DEDT at 0 range 16 .. 20;
       DEAT at 0 range 21 .. 25;
       RTOIE at 0 range 26 .. 26;
       EOBIE at 0 range 27 .. 27;
       M1 at 0 range 28 .. 28;
       Reserved_29_31 at 0 range 29 .. 31;
     end record;

   subtype CR2_STOP_Field is HAL.UInt2;
   subtype CR2_ABRMOD_Field is HAL.UInt2;
   --  CR2_ADD array element
   subtype CR2_ADD_Element is HAL.UInt4;

   --  CR2_ADD array
   type CR2_ADD_Field_Array is array (0 .. 1) of CR2_ADD_Element
   with Component_Size => 4, Size => 8;

   --  Type definition for CR2_ADD
   type CR2_ADD_Field (As_Array : Boolean := False) is record
      case As_Array is
         when False =>
            --  ADD as a value
            Val : HAL.UInt8;

         when True =>
            --  ADD as an array
            Arr : CR2_ADD_Field_Array;
      end case;
   end record
   with Unchecked_Union, Size => 8;

   for CR2_ADD_Field use
     record
       Val at 0 range 0 .. 7;
       Arr at 0 range 0 .. 7;
     end record;

   --  Control register 2
   type CR2_Register is record
      --  unspecified
      Reserved_0_3 : HAL.UInt4 := 16#0#;
      --  7-bit Address Detection/4-bit Address Detection
      ADDM7        : Boolean := False;
      --  LIN break detection length
      LBDL         : Boolean := False;
      --  LIN break detection interrupt enable
      LBDIE        : Boolean := False;
      --  unspecified
      Reserved_7_7 : HAL.Bit := 16#0#;
      --  Last bit clock pulse
      LBCL         : Boolean := False;
      --  Clock phase
      CPHA         : Boolean := False;
      --  Clock polarity
      CPOL         : Boolean := False;
      --  Clock enable
      CLKEN        : Boolean := False;
      --  STOP bits
      STOP         : CR2_STOP_Field := 16#0#;
      --  LIN mode enable
      LINEN        : Boolean := False;
      --  Swap TX/RX pins
      SWAP         : Boolean := False;
      --  RX pin active level inversion
      RXINV        : Boolean := False;
      --  TX pin active level inversion
      TXINV        : Boolean := False;
      --  Binary data inversion
      DATAINV      : Boolean := False;
      --  Most significant bit first
      MSBFIRST     : Boolean := False;
      --  Auto baud rate enable
      ABREN        : Boolean := False;
      --  Auto baud rate mode
      ABRMOD       : CR2_ABRMOD_Field := 16#0#;
      --  Receiver timeout enable
      RTOEN        : Boolean := False;
      --  Address of the USART node
      ADD          : CR2_ADD_Field := (As_Array => False, Val => 16#0#);
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for CR2_Register use
     record
       Reserved_0_3 at 0 range 0 .. 3;
       ADDM7 at 0 range 4 .. 4;
       LBDL at 0 range 5 .. 5;
       LBDIE at 0 range 6 .. 6;
       Reserved_7_7 at 0 range 7 .. 7;
       LBCL at 0 range 8 .. 8;
       CPHA at 0 range 9 .. 9;
       CPOL at 0 range 10 .. 10;
       CLKEN at 0 range 11 .. 11;
       STOP at 0 range 12 .. 13;
       LINEN at 0 range 14 .. 14;
       SWAP at 0 range 15 .. 15;
       RXINV at 0 range 16 .. 16;
       TXINV at 0 range 17 .. 17;
       DATAINV at 0 range 18 .. 18;
       MSBFIRST at 0 range 19 .. 19;
       ABREN at 0 range 20 .. 20;
       ABRMOD at 0 range 21 .. 22;
       RTOEN at 0 range 23 .. 23;
       ADD at 0 range 24 .. 31;
     end record;

   subtype CR3_SCARCNT_Field is HAL.UInt3;
   subtype CR3_WUS_Field is HAL.UInt2;

   --  Control register 3
   type CR3_Register is record
      --  Error interrupt enable
      EIE            : Boolean := False;
      --  IrDA mode enable
      IREN           : Boolean := False;
      --  IrDA low-power
      IRLP           : Boolean := False;
      --  Half-duplex selection
      HDSEL          : Boolean := False;
      --  Smartcard NACK enable
      NACK           : Boolean := False;
      --  Smartcard mode enable
      SCEN           : Boolean := False;
      --  DMA enable receiver
      DMAR           : Boolean := False;
      --  DMA enable transmitter
      DMAT           : Boolean := False;
      --  RTS enable
      RTSE           : Boolean := False;
      --  CTS enable
      CTSE           : Boolean := False;
      --  CTS interrupt enable
      CTSIE          : Boolean := False;
      --  One sample bit method enable
      ONEBIT         : Boolean := False;
      --  Overrun Disable
      OVRDIS         : Boolean := False;
      --  DMA Disable on Reception Error
      DDRE           : Boolean := False;
      --  Driver enable mode
      DEM            : Boolean := False;
      --  Driver enable polarity selection
      DEP            : Boolean := False;
      --  unspecified
      Reserved_16_16 : HAL.Bit := 16#0#;
      --  Smartcard auto-retry count
      SCARCNT        : CR3_SCARCNT_Field := 16#0#;
      --  Wakeup from Stop mode interrupt flag selection
      WUS            : CR3_WUS_Field := 16#0#;
      --  Wakeup from Stop mode interrupt enable
      WUFIE          : Boolean := False;
      --  unspecified
      Reserved_23_31 : HAL.UInt9 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for CR3_Register use
     record
       EIE at 0 range 0 .. 0;
       IREN at 0 range 1 .. 1;
       IRLP at 0 range 2 .. 2;
       HDSEL at 0 range 3 .. 3;
       NACK at 0 range 4 .. 4;
       SCEN at 0 range 5 .. 5;
       DMAR at 0 range 6 .. 6;
       DMAT at 0 range 7 .. 7;
       RTSE at 0 range 8 .. 8;
       CTSE at 0 range 9 .. 9;
       CTSIE at 0 range 10 .. 10;
       ONEBIT at 0 range 11 .. 11;
       OVRDIS at 0 range 12 .. 12;
       DDRE at 0 range 13 .. 13;
       DEM at 0 range 14 .. 14;
       DEP at 0 range 15 .. 15;
       Reserved_16_16 at 0 range 16 .. 16;
       SCARCNT at 0 range 17 .. 19;
       WUS at 0 range 20 .. 21;
       WUFIE at 0 range 22 .. 22;
       Reserved_23_31 at 0 range 23 .. 31;
     end record;

   subtype BRR_DIV_Fraction_Field is HAL.UInt4;
   subtype BRR_DIV_Mantissa_Field is HAL.UInt12;

   --  Baud rate register
   type BRR_Register is record
      --  fraction of USARTDIV
      DIV_Fraction   : BRR_DIV_Fraction_Field := 16#0#;
      --  mantissa of USARTDIV
      DIV_Mantissa   : BRR_DIV_Mantissa_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : HAL.UInt16 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for BRR_Register use
     record
       DIV_Fraction at 0 range 0 .. 3;
       DIV_Mantissa at 0 range 4 .. 15;
       Reserved_16_31 at 0 range 16 .. 31;
     end record;

   subtype GTPR_PSC_Field is HAL.UInt8;
   subtype GTPR_GT_Field is HAL.UInt8;

   --  Guard time and prescaler register
   type GTPR_Register is record
      --  Prescaler value
      PSC            : GTPR_PSC_Field := 16#0#;
      --  Guard time value
      GT             : GTPR_GT_Field := 16#0#;
      --  unspecified
      Reserved_16_31 : HAL.UInt16 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for GTPR_Register use
     record
       PSC at 0 range 0 .. 7;
       GT at 0 range 8 .. 15;
       Reserved_16_31 at 0 range 16 .. 31;
     end record;

   subtype RTOR_RTO_Field is HAL.UInt24;
   subtype RTOR_BLEN_Field is HAL.UInt8;

   --  Receiver timeout register
   type RTOR_Register is record
      --  Receiver timeout value
      RTO  : RTOR_RTO_Field := 16#0#;
      --  Block Length
      BLEN : RTOR_BLEN_Field := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for RTOR_Register use
     record
       RTO at 0 range 0 .. 23;
       BLEN at 0 range 24 .. 31;
     end record;

   --  Request register
   type RQR_Register is record
      --  Auto baud rate request
      ABRRQ         : Boolean := False;
      --  Send break request
      SBKRQ         : Boolean := False;
      --  Mute mode request
      MMRQ          : Boolean := False;
      --  Receive data flush request
      RXFRQ         : Boolean := False;
      --  Transmit data flush request
      TXFRQ         : Boolean := False;
      --  unspecified
      Reserved_5_31 : HAL.UInt27 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for RQR_Register use
     record
       ABRRQ at 0 range 0 .. 0;
       SBKRQ at 0 range 1 .. 1;
       MMRQ at 0 range 2 .. 2;
       RXFRQ at 0 range 3 .. 3;
       TXFRQ at 0 range 4 .. 4;
       Reserved_5_31 at 0 range 5 .. 31;
     end record;

   --  Interrupt & status register
   type ISR_Register is record
      --  Read-only. Parity error
      PE             : Boolean;
      --  Read-only. Framing error
      FE             : Boolean;
      --  Read-only. Noise detected flag
      NF             : Boolean;
      --  Read-only. Overrun error
      ORE            : Boolean;
      --  Read-only. Idle line detected
      IDLE           : Boolean;
      --  Read-only. Read data register not empty
      RXNE           : Boolean;
      --  Read-only. Transmission complete
      TC             : Boolean;
      --  Read-only. Transmit data register empty
      TXE            : Boolean;
      --  Read-only. LIN break detection flag
      LBDF           : Boolean;
      --  Read-only. CTS interrupt flag
      CTSIF          : Boolean;
      --  Read-only. CTS flag
      CTS            : Boolean;
      --  Read-only. Receiver timeout
      RTOF           : Boolean;
      --  Read-only. End of block flag
      EOBF           : Boolean;
      --  unspecified
      Reserved_13_13 : HAL.Bit;
      --  Read-only. Auto baud rate error
      ABRE           : Boolean;
      --  Read-only. Auto baud rate flag
      ABRF           : Boolean;
      --  Read-only. Busy flag
      BUSY           : Boolean;
      --  Read-only. character match flag
      CMF            : Boolean;
      --  Read-only. Send break flag
      SBKF           : Boolean;
      --  Read-only. Receiver wakeup from Mute mode
      RWU            : Boolean;
      --  Read-only. Wakeup from Stop mode flag
      WUF            : Boolean;
      --  Read-only. Transmit enable acknowledge flag
      TEACK          : Boolean;
      --  Read-only. Receive enable acknowledge flag
      REACK          : Boolean;
      --  unspecified
      Reserved_23_31 : HAL.UInt9;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for ISR_Register use
     record
       PE at 0 range 0 .. 0;
       FE at 0 range 1 .. 1;
       NF at 0 range 2 .. 2;
       ORE at 0 range 3 .. 3;
       IDLE at 0 range 4 .. 4;
       RXNE at 0 range 5 .. 5;
       TC at 0 range 6 .. 6;
       TXE at 0 range 7 .. 7;
       LBDF at 0 range 8 .. 8;
       CTSIF at 0 range 9 .. 9;
       CTS at 0 range 10 .. 10;
       RTOF at 0 range 11 .. 11;
       EOBF at 0 range 12 .. 12;
       Reserved_13_13 at 0 range 13 .. 13;
       ABRE at 0 range 14 .. 14;
       ABRF at 0 range 15 .. 15;
       BUSY at 0 range 16 .. 16;
       CMF at 0 range 17 .. 17;
       SBKF at 0 range 18 .. 18;
       RWU at 0 range 19 .. 19;
       WUF at 0 range 20 .. 20;
       TEACK at 0 range 21 .. 21;
       REACK at 0 range 22 .. 22;
       Reserved_23_31 at 0 range 23 .. 31;
     end record;

   --  Interrupt flag clear register
   type ICR_Register is record
      --  Parity error clear flag
      PECF           : Boolean := False;
      --  Framing error clear flag
      FECF           : Boolean := False;
      --  Noise detected clear flag
      NCF            : Boolean := False;
      --  Overrun error clear flag
      ORECF          : Boolean := False;
      --  Idle line detected clear flag
      IDLECF         : Boolean := False;
      --  unspecified
      Reserved_5_5   : HAL.Bit := 16#0#;
      --  Transmission complete clear flag
      TCCF           : Boolean := False;
      --  unspecified
      Reserved_7_7   : HAL.Bit := 16#0#;
      --  LIN break detection clear flag
      LBDCF          : Boolean := False;
      --  CTS clear flag
      CTSCF          : Boolean := False;
      --  unspecified
      Reserved_10_10 : HAL.Bit := 16#0#;
      --  Receiver timeout clear flag
      RTOCF          : Boolean := False;
      --  End of timeout clear flag
      EOBCF          : Boolean := False;
      --  unspecified
      Reserved_13_16 : HAL.UInt4 := 16#0#;
      --  Character match clear flag
      CMCF           : Boolean := False;
      --  unspecified
      Reserved_18_19 : HAL.UInt2 := 16#0#;
      --  Wakeup from Stop mode clear flag
      WUCF           : Boolean := False;
      --  unspecified
      Reserved_21_31 : HAL.UInt11 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for ICR_Register use
     record
       PECF at 0 range 0 .. 0;
       FECF at 0 range 1 .. 1;
       NCF at 0 range 2 .. 2;
       ORECF at 0 range 3 .. 3;
       IDLECF at 0 range 4 .. 4;
       Reserved_5_5 at 0 range 5 .. 5;
       TCCF at 0 range 6 .. 6;
       Reserved_7_7 at 0 range 7 .. 7;
       LBDCF at 0 range 8 .. 8;
       CTSCF at 0 range 9 .. 9;
       Reserved_10_10 at 0 range 10 .. 10;
       RTOCF at 0 range 11 .. 11;
       EOBCF at 0 range 12 .. 12;
       Reserved_13_16 at 0 range 13 .. 16;
       CMCF at 0 range 17 .. 17;
       Reserved_18_19 at 0 range 18 .. 19;
       WUCF at 0 range 20 .. 20;
       Reserved_21_31 at 0 range 21 .. 31;
     end record;

   subtype RDR_RDR_Field is HAL.UInt9;

   --  Receive data register
   type RDR_Register is record
      --  Read-only. Receive data value
      RDR           : RDR_RDR_Field;
      --  unspecified
      Reserved_9_31 : HAL.UInt23;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for RDR_Register use
     record
       RDR at 0 range 0 .. 8;
       Reserved_9_31 at 0 range 9 .. 31;
     end record;

   subtype TDR_TDR_Field is HAL.UInt9;

   --  Transmit data register
   type TDR_Register is record
      --  Transmit data value
      TDR           : TDR_TDR_Field := 16#0#;
      --  unspecified
      Reserved_9_31 : HAL.UInt23 := 16#0#;
   end record
   with
     Volatile_Full_Access,
     Object_Size => 32,
     Bit_Order => System.Low_Order_First;

   for TDR_Register use
     record
       TDR at 0 range 0 .. 8;
       Reserved_9_31 at 0 range 9 .. 31;
     end record;

   -----------------
   -- Peripherals --
   -----------------

   --  Universal synchronous asynchronous receiver transmitter
   type USART_Peripheral is record
      --  Control register 1
      CR1  : aliased CR1_Register;
      --  Control register 2
      CR2  : aliased CR2_Register;
      --  Control register 3
      CR3  : aliased CR3_Register;
      --  Baud rate register
      BRR  : aliased BRR_Register;
      --  Guard time and prescaler register
      GTPR : aliased GTPR_Register;
      --  Receiver timeout register
      RTOR : aliased RTOR_Register;
      --  Request register
      RQR  : aliased RQR_Register;
      --  Interrupt & status register
      ISR  : aliased ISR_Register;
      --  Interrupt flag clear register
      ICR  : aliased ICR_Register;
      --  Receive data register
      RDR  : aliased RDR_Register;
      --  Transmit data register
      TDR  : aliased TDR_Register;
   end record
   with Volatile;

   for USART_Peripheral use
     record
       CR1 at 16#0# range 0 .. 31;
       CR2 at 16#4# range 0 .. 31;
       CR3 at 16#8# range 0 .. 31;
       BRR at 16#C# range 0 .. 31;
       GTPR at 16#10# range 0 .. 31;
       RTOR at 16#14# range 0 .. 31;
       RQR at 16#18# range 0 .. 31;
       ISR at 16#1C# range 0 .. 31;
       ICR at 16#20# range 0 .. 31;
       RDR at 16#24# range 0 .. 31;
       TDR at 16#28# range 0 .. 31;
     end record;

   --  Universal synchronous asynchronous receiver transmitter
   USART1_Periph : aliased USART_Peripheral
   with Import, Address => USART1_Base;

   --  Universal synchronous asynchronous receiver transmitter
   USART2_Periph : aliased USART_Peripheral
   with Import, Address => USART2_Base;

   --  Universal synchronous asynchronous receiver transmitter
   USART3_Periph : aliased USART_Peripheral
   with Import, Address => USART3_Base;

   --  Universal synchronous asynchronous receiver transmitter
   USART4_Periph : aliased USART_Peripheral
   with Import, Address => USART4_Base;

end STM32_SVD.USART;
