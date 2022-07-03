package STM32.USB_Serialtrace is

   procedure Init_Serialtrace;

   procedure Log (S : String; L: Integer := 1;

                  Deindent : Integer := 0);
   procedure EndLog (S: String; L: Integer :=1);
   procedure StartLog (S: String; L: Integer := 1);
end STM32.USB_Serialtrace;