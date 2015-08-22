-- ./flopoco -name=FXP_To_FP -frequency=200 -useHardMult=no Fix2FP S 31 0 8 23
--
--
-- Final report:
-- |---Entity Fix2FP_0_31_US_8_23_LZCS
-- |      Pipeline depth = 1
-- |---Entity Fix2FP_0_31_US_8_23exponentConversion
-- |      Not pipelined
-- |---Entity Fix2FP_0_31_US_8_23exponentFinal
-- |      Not pipelined
-- |---Entity Fix2FP_0_31_US_8_23zeroD
-- |      Not pipelined
-- |---Entity Fix2FP_0_31_US_8_23_oneSubstracter
-- |      Not pipelined
-- |---Entity Fix2FP_0_31_US_8_23roundingAdder
-- |      Not pipelined
-- Entity FXP_To_FP
--   Pipeline depth = 1
-- 
--
----------------------------------------------------------------------------------
--                          Fix2FP_0_31_US_8_23_LZCS
--                   (LZCShifter_32_to_32_counting_64_uid3)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin, Bogdan Pasca (2007)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Fix2FP_0_31_US_8_23_LZCS is
   port ( clk, rst : in std_logic;
          I : in  std_logic_vector(31 downto 0);
          Count : out  std_logic_vector(5 downto 0);
          O : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of Fix2FP_0_31_US_8_23_LZCS is
signal level6 :  std_logic_vector(31 downto 0);
signal count5, count5_d1 :  std_logic;
signal level5 :  std_logic_vector(31 downto 0);
signal count4, count4_d1 :  std_logic;
signal level4 :  std_logic_vector(31 downto 0);
signal count3, count3_d1 :  std_logic;
signal level3, level3_d1 :  std_logic_vector(31 downto 0);
signal count2 :  std_logic;
signal level2 :  std_logic_vector(31 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(31 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(31 downto 0);
signal sCount :  std_logic_vector(5 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            count5_d1 <=  count5;
            count4_d1 <=  count4;
            count3_d1 <=  count3;
            level3_d1 <=  level3;
         end if;
      end process;
   level6 <= I ;
   count5<= '1' when level6(31 downto 0) = (31 downto 0=>'0') else '0';
   level5<= level6(31 downto 0) when count5='0' else (31 downto 0 => '0');

   count4<= '1' when level5(31 downto 16) = (31 downto 16=>'0') else '0';
   level4<= level5(31 downto 0) when count4='0' else level5(15 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(31 downto 24) = (31 downto 24=>'0') else '0';
   level3<= level4(31 downto 0) when count3='0' else level4(23 downto 0) & (7 downto 0 => '0');

   ----------------Synchro barrier, entering cycle 1----------------
   count2<= '1' when level3_d1(31 downto 28) = (31 downto 28=>'0') else '0';
   level2<= level3_d1(31 downto 0) when count2='0' else level3_d1(27 downto 0) & (3 downto 0 => '0');

   count1<= '1' when level2(31 downto 30) = (31 downto 30=>'0') else '0';
   level1<= level2(31 downto 0) when count1='0' else level2(29 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(31 downto 31) = (31 downto 31=>'0') else '0';
   level0<= level1(31 downto 0) when count0='0' else level1(30 downto 0) & (0 downto 0 => '0');

   O <= level0;
   sCount <= count5_d1 & count4_d1 & count3_d1 & count2 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                   Fix2FP_0_31_US_8_23exponentConversion
--                           (IntAdder_8_f200_uid6)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Fix2FP_0_31_US_8_23exponentConversion is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(7 downto 0);
          Y : in  std_logic_vector(7 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(7 downto 0)   );
end entity;

architecture arch of Fix2FP_0_31_US_8_23exponentConversion is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Alternative
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--                      Fix2FP_0_31_US_8_23exponentFinal
--                          (IntAdder_9_f200_uid13)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Fix2FP_0_31_US_8_23exponentFinal is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(8 downto 0);
          Y : in  std_logic_vector(8 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(8 downto 0)   );
end entity;

architecture arch of Fix2FP_0_31_US_8_23exponentFinal is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Alternative
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--                          Fix2FP_0_31_US_8_23zeroD
--                          (IntAdder_33_f200_uid20)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Fix2FP_0_31_US_8_23zeroD is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(32 downto 0);
          Y : in  std_logic_vector(32 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(32 downto 0)   );
end entity;

architecture arch of Fix2FP_0_31_US_8_23zeroD is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Alternative
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--                     Fix2FP_0_31_US_8_23_oneSubstracter
--                          (IntAdder_7_f200_uid27)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Fix2FP_0_31_US_8_23_oneSubstracter is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(6 downto 0);
          Y : in  std_logic_vector(6 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(6 downto 0)   );
end entity;

architecture arch of Fix2FP_0_31_US_8_23_oneSubstracter is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Alternative
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--                      Fix2FP_0_31_US_8_23roundingAdder
--                          (IntAdder_32_f200_uid34)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Fix2FP_0_31_US_8_23roundingAdder is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(31 downto 0);
          Y : in  std_logic_vector(31 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of Fix2FP_0_31_US_8_23roundingAdder is
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   --Alternative
    R <= X + Y + Cin;
end architecture;

--------------------------------------------------------------------------------
--                                  FXP_To_FP
--                           (Fix2FP_0_31_US_8_23)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Radu Tudoran, Bogdan Pasca (2009)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FXP_To_FP is
   port ( clk, rst : in std_logic;
          I : in  std_logic_vector(31 downto 0);
          O : out  std_logic_vector(8+23+2 downto 0)   );
end entity;

architecture arch of FXP_To_FP is
   component Fix2FP_0_31_US_8_23_LZCS is
      port ( clk, rst : in std_logic;
             I : in  std_logic_vector(31 downto 0);
             Count : out  std_logic_vector(5 downto 0);
             O : out  std_logic_vector(31 downto 0)   );
   end component;

   component Fix2FP_0_31_US_8_23_oneSubstracter is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(6 downto 0);
             Y : in  std_logic_vector(6 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(6 downto 0)   );
   end component;

   component Fix2FP_0_31_US_8_23exponentConversion is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(7 downto 0);
             Y : in  std_logic_vector(7 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(7 downto 0)   );
   end component;

   component Fix2FP_0_31_US_8_23exponentFinal is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(8 downto 0);
             Y : in  std_logic_vector(8 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(8 downto 0)   );
   end component;

   component Fix2FP_0_31_US_8_23roundingAdder is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(31 downto 0);
             Y : in  std_logic_vector(31 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(31 downto 0)   );
   end component;

   component Fix2FP_0_31_US_8_23zeroD is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(32 downto 0);
             Y : in  std_logic_vector(32 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(32 downto 0)   );
   end component;

signal input :  std_logic_vector(31 downto 0);
signal signSignal, signSignal_d1 :  std_logic;
signal passedInput :  std_logic_vector(31 downto 0);
signal input2LZOC :  std_logic_vector(30 downto 0);
signal temporalExponent :  std_logic_vector(5 downto 0);
signal temporalFraction :  std_logic_vector(31 downto 0);
signal MSB2Signal :  std_logic_vector(7 downto 0);
signal zeroPadding4Exponent :  std_logic_vector(1 downto 0);
signal valueExponent :  std_logic_vector(7 downto 0);
signal partialConvertedExponent :  std_logic_vector(7 downto 0);
signal biassOfOnes :  std_logic_vector(6 downto 0);
signal biassSignal :  std_logic_vector(7 downto 0);
signal biassSignalBit :  std_logic_vector(8 downto 0);
signal partialConvertedExponentBit :  std_logic_vector(8 downto 0);
signal sign4OU :  std_logic;
signal convertedExponentBit :  std_logic_vector(8 downto 0);
signal convertedExponent :  std_logic_vector(7 downto 0);
signal underflowSignal :  std_logic;
signal overflowSignal :  std_logic;
signal minusOne4ZD :  std_logic_vector(32 downto 0);
signal passedInputBit :  std_logic_vector(32 downto 0);
signal zeroDS :  std_logic_vector(32 downto 0);
signal zeroInput, zeroInput_d1 :  std_logic;
signal tempFractionResult :  std_logic_vector(32 downto 0);
signal correctingExponent :  std_logic;
signal fractionConverted :  std_logic_vector(22 downto 0);
signal firstBitofRest :  std_logic;
signal lastBitOfFraction :  std_logic;
signal minusOne :  std_logic_vector(6 downto 0);
signal fractionRemainder :  std_logic_vector(6 downto 0);
signal zeroFractionResult :  std_logic_vector(6 downto 0);
signal zeroRemainder :  std_logic;
signal outputOfMux3 :  std_logic;
signal outputOfMux2 :  std_logic;
signal outputOfMux1 :  std_logic;
signal possibleCorrector4Rounding :  std_logic_vector(31 downto 0);
signal concatenationForRounding :  std_logic_vector(31 downto 0);
signal testC :  std_logic_vector(31 downto 0);
signal testR :  std_logic_vector(31 downto 0);
signal testM :  std_logic;
signal roundedResult :  std_logic_vector(31 downto 0);
signal convertedExponentAfterRounding :  std_logic_vector(7 downto 0);
signal convertedFractionAfterRounding :  std_logic_vector(22 downto 0);
signal MSBSelection :  std_logic;
signal LSBSelection :  std_logic;
signal Selection :  std_logic_vector(1 downto 0);
signal specialBits :  std_logic_vector(1 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            signSignal_d1 <=  signSignal;
            zeroInput_d1 <=  zeroInput;
         end if;
      end process;
   input <= I;
   signSignal<= '0';
   passedInput<=input(31 downto 0);
   input2LZOC<=passedInput(30 downto 0);
   LZC_component: Fix2FP_0_31_US_8_23_LZCS  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Count => temporalExponent,
                 I => passedInput,
                 O => temporalFraction);
   ----------------Synchro barrier, entering cycle 1----------------
   MSB2Signal<=CONV_STD_LOGIC_VECTOR(31,8);
   zeroPadding4Exponent<=CONV_STD_LOGIC_VECTOR(0,2);
   valueExponent<= not (zeroPadding4Exponent & temporalExponent );
   exponentConversion: Fix2FP_0_31_US_8_23exponentConversion  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '1',
                 R => partialConvertedExponent,
                 X => MSB2Signal,
                 Y => valueExponent);
   biassOfOnes<=CONV_STD_LOGIC_VECTOR(255,7);
   biassSignal<='0' & biassOfOnes;
   biassSignalBit<='0' & biassSignal;
   partialConvertedExponentBit<= '0' & partialConvertedExponent;
   sign4OU<=partialConvertedExponent(7);
   exponentFinal: Fix2FP_0_31_US_8_23exponentFinal  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '0',
                 R => convertedExponentBit,
                 X => partialConvertedExponentBit,
                 Y => biassSignalBit);
   convertedExponent<= convertedExponentBit(7 downto 0);
   underflowSignal<= '1' when (sign4OU='1' and convertedExponentBit(8 downto 7) = "01" ) else '0' ;
   overflowSignal<= '1' when (sign4OU='0' and convertedExponentBit(8 downto 7) = "10" ) else '0' ;
   ---------------- cycle 0----------------
   minusOne4ZD<=CONV_STD_LOGIC_VECTOR(-1,33);
   passedInputBit<= '0' & passedInput;
   zeroD: Fix2FP_0_31_US_8_23zeroD  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '0',
                 R => zeroDS,
                 X => passedInputBit,
                 Y => minusOne4ZD);
   ---------------- cycle 0----------------
   zeroInput<= zeroDS(32) and not (signSignal);
   ---------------- cycle 1----------------
   tempFractionResult<= '0' & temporalFraction;
   correctingExponent<=tempFractionResult(32);
   fractionConverted<=tempFractionResult(30 downto 8);
   firstBitofRest<=tempFractionResult(7);
   lastBitOfFraction<=tempFractionResult(8);
   ---------------- cycle 1----------------
   minusOne<=CONV_STD_LOGIC_VECTOR(-1,7);
   fractionRemainder<= tempFractionResult(6 downto 0);
   oneSubstracter: Fix2FP_0_31_US_8_23_oneSubstracter  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '0',
                 R => zeroFractionResult,
                 X => fractionRemainder,
                 Y => minusOne);
   zeroRemainder<= not( not (tempFractionResult(6)) and zeroFractionResult(6));
   outputOfMux3<=lastBitOfFraction;
   with zeroRemainder select
   outputOfMux2 <= outputOfMux3 when '0', '1' when others;
   with firstBitofRest select
   outputOfMux1 <= outputOfMux2 when '1', '0' when others;
   possibleCorrector4Rounding<=CONV_STD_LOGIC_VECTOR(0,8) & correctingExponent & CONV_STD_LOGIC_VECTOR(0,23);
   concatenationForRounding<= '0' & convertedExponent & fractionConverted;
   testC<= concatenationForRounding;
   testR<= possibleCorrector4Rounding;
   testM<= outputOfMux1;
   roundingAdder: Fix2FP_0_31_US_8_23roundingAdder  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => outputOfMux1,
                 R => roundedResult,
                 X => concatenationForRounding,
                 Y => possibleCorrector4Rounding);
   convertedExponentAfterRounding<= roundedResult(30 downto 23);
   convertedFractionAfterRounding<= roundedResult(22 downto 0);
   MSBSelection<= overflowSignal or roundedResult(31);
   LSBSelection<= not(underflowSignal and not(zeroInput_d1));
   Selection<= MSBSelection & LSBSelection when zeroInput_d1='0' else "00";
   specialBits <= Selection;
   O<= specialBits & signSignal_d1 & convertedExponentAfterRounding & convertedFractionAfterRounding;
end architecture;

