-- vagrant@vagrant-ubuntu-trusty-32:~/flopoco-3.0.beta5$ ./flopoco -name=fusedADD38 -frequency=200 -useHardMult=no FPAdd 9 38
-- Updating entity name to: fusedADD38
-- 
-- Final report:
-- |---Entity IntAdder_50_f200_uid4
-- |      Not pipelined
-- |---Entity FPAdd_9_38_uid2_RightShifter
-- |      Not pipelined
-- |---Entity IntAdder_42_f200_uid14
-- |      Not pipelined
-- |---Entity LZCShifter_43_to_43_counting_64_uid21
-- |      Pipeline depth = 2
-- |---Entity IntAdder_50_f200_uid24
-- |      Pipeline depth = 1
-- Entity fusedADD38
--    Pipeline depth = 5
-- Output file: flopoco.vhdl
--------------------------------------------------------------------------------
--                           IntAdder_50_f200_uid4
--                     (IntAdderAlternative_50_f200_uid8)
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

entity IntAdder_50_f200_uid4 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(49 downto 0);
          Y : in  std_logic_vector(49 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(49 downto 0)   );
end entity;

architecture arch of IntAdder_50_f200_uid4 is
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
--                        FPAdd_9_38_uid2_RightShifter
--                     (RightShifter_39_by_max_41_uid11)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2011)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPAdd_9_38_uid2_RightShifter is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(38 downto 0);
          S : in  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(79 downto 0)   );
end entity;

architecture arch of FPAdd_9_38_uid2_RightShifter is
signal level0 :  std_logic_vector(38 downto 0);
signal ps :  std_logic_vector(5 downto 0);
signal level1 :  std_logic_vector(39 downto 0);
signal level2 :  std_logic_vector(41 downto 0);
signal level3 :  std_logic_vector(45 downto 0);
signal level4 :  std_logic_vector(53 downto 0);
signal level5 :  std_logic_vector(69 downto 0);
signal level6 :  std_logic_vector(101 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   level0<= X;
   ps<= S;
   level1<=  (0 downto 0 => '0') & level0 when ps(0) = '1' else    level0 & (0 downto 0 => '0');
   level2<=  (1 downto 0 => '0') & level1 when ps(1) = '1' else    level1 & (1 downto 0 => '0');
   level3<=  (3 downto 0 => '0') & level2 when ps(2) = '1' else    level2 & (3 downto 0 => '0');
   level4<=  (7 downto 0 => '0') & level3 when ps(3) = '1' else    level3 & (7 downto 0 => '0');
   level5<=  (15 downto 0 => '0') & level4 when ps(4) = '1' else    level4 & (15 downto 0 => '0');
   level6<=  (31 downto 0 => '0') & level5 when ps(5) = '1' else    level5 & (31 downto 0 => '0');
   R <= level6(101 downto 22);
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_42_f200_uid14
--                    (IntAdderAlternative_42_f200_uid18)
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

entity IntAdder_42_f200_uid14 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(41 downto 0);
          Y : in  std_logic_vector(41 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(41 downto 0)   );
end entity;

architecture arch of IntAdder_42_f200_uid14 is
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
--                   LZCShifter_43_to_43_counting_64_uid21
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin, Bogdan Pasca (2007)
--------------------------------------------------------------------------------
-- Pipeline depth: 2 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity LZCShifter_43_to_43_counting_64_uid21 is
   port ( clk, rst : in std_logic;
          I : in  std_logic_vector(42 downto 0);
          Count : out  std_logic_vector(5 downto 0);
          O : out  std_logic_vector(42 downto 0)   );
end entity;

architecture arch of LZCShifter_43_to_43_counting_64_uid21 is
signal level6, level6_d1 :  std_logic_vector(42 downto 0);
signal count5, count5_d1, count5_d2 :  std_logic;
signal level5 :  std_logic_vector(42 downto 0);
signal count4, count4_d1 :  std_logic;
signal level4 :  std_logic_vector(42 downto 0);
signal count3, count3_d1 :  std_logic;
signal level3 :  std_logic_vector(42 downto 0);
signal count2, count2_d1 :  std_logic;
signal level2, level2_d1 :  std_logic_vector(42 downto 0);
signal count1 :  std_logic;
signal level1 :  std_logic_vector(42 downto 0);
signal count0 :  std_logic;
signal level0 :  std_logic_vector(42 downto 0);
signal sCount :  std_logic_vector(5 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            level6_d1 <=  level6;
            count5_d1 <=  count5;
            count5_d2 <=  count5_d1;
            count4_d1 <=  count4;
            count3_d1 <=  count3;
            count2_d1 <=  count2;
            level2_d1 <=  level2;
         end if;
      end process;
   level6 <= I ;
   count5<= '1' when level6(42 downto 11) = (42 downto 11=>'0') else '0';
   ----------------Synchro barrier, entering cycle 1----------------
   level5<= level6_d1(42 downto 0) when count5_d1='0' else level6_d1(10 downto 0) & (31 downto 0 => '0');

   count4<= '1' when level5(42 downto 27) = (42 downto 27=>'0') else '0';
   level4<= level5(42 downto 0) when count4='0' else level5(26 downto 0) & (15 downto 0 => '0');

   count3<= '1' when level4(42 downto 35) = (42 downto 35=>'0') else '0';
   level3<= level4(42 downto 0) when count3='0' else level4(34 downto 0) & (7 downto 0 => '0');

   count2<= '1' when level3(42 downto 39) = (42 downto 39=>'0') else '0';
   level2<= level3(42 downto 0) when count2='0' else level3(38 downto 0) & (3 downto 0 => '0');

   ----------------Synchro barrier, entering cycle 2----------------
   count1<= '1' when level2_d1(42 downto 41) = (42 downto 41=>'0') else '0';
   level1<= level2_d1(42 downto 0) when count1='0' else level2_d1(40 downto 0) & (1 downto 0 => '0');

   count0<= '1' when level1(42 downto 42) = (42 downto 42=>'0') else '0';
   level0<= level1(42 downto 0) when count0='0' else level1(41 downto 0) & (0 downto 0 => '0');

   O <= level0;
   sCount <= count5_d2 & count4_d1 & count3_d1 & count2_d1 & count1 & count0;
   Count <= sCount;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_50_f200_uid24
--                    (IntAdderAlternative_50_f200_uid28)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2008-2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntAdder_50_f200_uid24 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(49 downto 0);
          Y : in  std_logic_vector(49 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(49 downto 0)   );
end entity;

architecture arch of IntAdder_50_f200_uid24 is
signal s_sum_l0_idx0 :  std_logic_vector(45 downto 0);
signal s_sum_l0_idx1, s_sum_l0_idx1_d1 :  std_logic_vector(5 downto 0);
signal sum_l0_idx0, sum_l0_idx0_d1 :  std_logic_vector(44 downto 0);
signal c_l0_idx0, c_l0_idx0_d1 :  std_logic_vector(0 downto 0);
signal sum_l0_idx1 :  std_logic_vector(4 downto 0);
signal c_l0_idx1 :  std_logic_vector(0 downto 0);
signal s_sum_l1_idx1 :  std_logic_vector(5 downto 0);
signal sum_l1_idx1 :  std_logic_vector(4 downto 0);
signal c_l1_idx1 :  std_logic_vector(0 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            s_sum_l0_idx1_d1 <=  s_sum_l0_idx1;
            sum_l0_idx0_d1 <=  sum_l0_idx0;
            c_l0_idx0_d1 <=  c_l0_idx0;
         end if;
      end process;
   --Alternative
   s_sum_l0_idx0 <= ( "0" & X(44 downto 0)) + ( "0" & Y(44 downto 0)) + Cin;
   s_sum_l0_idx1 <= ( "0" & X(49 downto 45)) + ( "0" & Y(49 downto 45));
   sum_l0_idx0 <= s_sum_l0_idx0(44 downto 0);
   c_l0_idx0 <= s_sum_l0_idx0(45 downto 45);
   sum_l0_idx1 <= s_sum_l0_idx1(4 downto 0);
   c_l0_idx1 <= s_sum_l0_idx1(5 downto 5);
   ----------------Synchro barrier, entering cycle 1----------------
   s_sum_l1_idx1 <=  s_sum_l0_idx1_d1 + c_l0_idx0_d1(0 downto 0);
   sum_l1_idx1 <= s_sum_l1_idx1(4 downto 0);
   c_l1_idx1 <= s_sum_l1_idx1(5 downto 5);
   R <= sum_l1_idx1(4 downto 0) & sum_l0_idx0_d1(44 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                                 fusedADD38
--                             (FPAdd_9_38_uid2)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin (2010)
--------------------------------------------------------------------------------
-- Pipeline depth: 5 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity fusedADD38 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(9+38+2 downto 0);
          Y : in  std_logic_vector(9+38+2 downto 0);
          R : out  std_logic_vector(9+38+2 downto 0);
          rnd : buffer std_logic   );  -- mod by JDH Sept 21, 2015
end entity;

architecture arch of fusedADD38 is
   component FPAdd_9_38_uid2_RightShifter is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(38 downto 0);
             S : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(79 downto 0)   );
   end component;

   component IntAdder_42_f200_uid14 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(41 downto 0);
             Y : in  std_logic_vector(41 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(41 downto 0)   );
   end component;

   component IntAdder_50_f200_uid24 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(49 downto 0);
             Y : in  std_logic_vector(49 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(49 downto 0)   );
   end component;

   component IntAdder_50_f200_uid4 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(49 downto 0);
             Y : in  std_logic_vector(49 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(49 downto 0)   );
   end component;

   component LZCShifter_43_to_43_counting_64_uid21 is
      port ( clk, rst : in std_logic;
             I : in  std_logic_vector(42 downto 0);
             Count : out  std_logic_vector(5 downto 0);
             O : out  std_logic_vector(42 downto 0)   );
   end component;

signal excExpFracX :  std_logic_vector(48 downto 0);
signal excExpFracY :  std_logic_vector(48 downto 0);
signal eXmeY :  std_logic_vector(9 downto 0);
signal eYmeX :  std_logic_vector(9 downto 0);
signal addCmpOp1 :  std_logic_vector(49 downto 0);
signal addCmpOp2 :  std_logic_vector(49 downto 0);
signal cmpRes :  std_logic_vector(49 downto 0);
signal swap :  std_logic;
signal newX, newX_d1, newX_d2 :  std_logic_vector(49 downto 0);
signal newY :  std_logic_vector(49 downto 0);
signal expX, expX_d1, expX_d2 :  std_logic_vector(8 downto 0);
signal excX :  std_logic_vector(1 downto 0);
signal excY :  std_logic_vector(1 downto 0);
signal signX, signX_d1 :  std_logic;
signal signY :  std_logic;
signal EffSub, EffSub_d1, EffSub_d2, EffSub_d3, EffSub_d4, EffSub_d5 :  std_logic;
signal sXsYExnXY, sXsYExnXY_d1 :  std_logic_vector(5 downto 0);
signal sdExnXY :  std_logic_vector(3 downto 0);
signal fracY, fracY_d1 :  std_logic_vector(38 downto 0);
signal excRt, excRt_d1, excRt_d2, excRt_d3, excRt_d4, excRt_d5 :  std_logic_vector(1 downto 0);
signal signR, signR_d1, signR_d2, signR_d3, signR_d4 :  std_logic;
signal expDiff, expDiff_d1 :  std_logic_vector(9 downto 0);
signal shiftedOut, shiftedOut_d1 :  std_logic;
signal shiftVal :  std_logic_vector(5 downto 0);
signal shiftedFracY, shiftedFracY_d1 :  std_logic_vector(79 downto 0);
signal sticky :  std_logic;
signal fracYfar :  std_logic_vector(41 downto 0);
signal EffSubVector :  std_logic_vector(41 downto 0);
signal fracYfarXorOp :  std_logic_vector(41 downto 0);
signal fracXfar :  std_logic_vector(41 downto 0);
signal cInAddFar :  std_logic;
signal fracAddResult :  std_logic_vector(41 downto 0);
signal fracGRS :  std_logic_vector(42 downto 0);
signal extendedExpInc, extendedExpInc_d1, extendedExpInc_d2 :  std_logic_vector(10 downto 0);
signal nZerosNew :  std_logic_vector(5 downto 0);
signal shiftedFrac :  std_logic_vector(42 downto 0);
signal updatedExp :  std_logic_vector(10 downto 0);
signal eqdiffsign, eqdiffsign_d1 :  std_logic;
signal expFrac :  std_logic_vector(49 downto 0);
signal stk :  std_logic;
--signal rnd :  std_logic;
signal grd :  std_logic;
signal lsb :  std_logic;
signal addToRoundBit :  std_logic;
signal RoundedExpFrac :  std_logic_vector(49 downto 0);
signal upExc :  std_logic_vector(1 downto 0);
signal fracR :  std_logic_vector(37 downto 0);
signal expR :  std_logic_vector(8 downto 0);
signal exExpExc :  std_logic_vector(3 downto 0);
signal excRt2 :  std_logic_vector(1 downto 0);
signal excR :  std_logic_vector(1 downto 0);
signal signR2 :  std_logic;
signal computedR :  std_logic_vector(49 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            newX_d1 <=  newX;
            newX_d2 <=  newX_d1;
            expX_d1 <=  expX;
            expX_d2 <=  expX_d1;
            signX_d1 <=  signX;
            EffSub_d1 <=  EffSub;
            EffSub_d2 <=  EffSub_d1;
            EffSub_d3 <=  EffSub_d2;
            EffSub_d4 <=  EffSub_d3;
            EffSub_d5 <=  EffSub_d4;
            sXsYExnXY_d1 <=  sXsYExnXY;
            fracY_d1 <=  fracY;
            excRt_d1 <=  excRt;
            excRt_d2 <=  excRt_d1;
            excRt_d3 <=  excRt_d2;
            excRt_d4 <=  excRt_d3;
            excRt_d5 <=  excRt_d4;
            signR_d1 <=  signR;
            signR_d2 <=  signR_d1;
            signR_d3 <=  signR_d2;
            signR_d4 <=  signR_d3;
            expDiff_d1 <=  expDiff;
            shiftedOut_d1 <=  shiftedOut;
            shiftedFracY_d1 <=  shiftedFracY;
            extendedExpInc_d1 <=  extendedExpInc;
            extendedExpInc_d2 <=  extendedExpInc_d1;
            eqdiffsign_d1 <=  eqdiffsign;
         end if;
      end process;
-- Exponent difference and swap  --
   excExpFracX <= X(49 downto 48) & X(46 downto 0);
   excExpFracY <= Y(49 downto 48) & Y(46 downto 0);
   eXmeY <= ("0" & X(46 downto 38)) - ("0" & Y(46 downto 38));
   eYmeX <= ("0" & Y(46 downto 38)) - ("0" & X(46 downto 38));
   addCmpOp1<= "0" & excExpFracX;
   addCmpOp2<= "1" & not(excExpFracY);
   cmpAdder: IntAdder_50_f200_uid4  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '1',
                 R => cmpRes,
                 X => addCmpOp1,
                 Y => addCmpOp2);

   swap <= cmpRes(49);
   newX <= X when swap = '0' else Y;
   newY <= Y when swap = '0' else X;
   expX<= newX(46 downto 38);
   excX<= newX(49 downto 48);
   excY<= newY(49 downto 48);
   signX<= newX(47);
   signY<= newY(47);
   EffSub <= signX xor signY;
   sXsYExnXY <= signX & signY & excX & excY;
   sdExnXY <= excX & excY;
   fracY <= "000000000000000000000000000000000000000" when excY="00" else ('1' & newY(37 downto 0));
   with sXsYExnXY select
   excRt <= "00" when "000000"|"010000"|"100000"|"110000",
      "01" when "000101"|"010101"|"100101"|"110101"|"000100"|"010100"|"100100"|"110100"|"000001"|"010001"|"100001"|"110001",
      "10" when "111010"|"001010"|"001000"|"011000"|"101000"|"111000"|"000010"|"010010"|"100010"|"110010"|"001001"|"011001"|"101001"|"111001"|"000110"|"010110"|"100110"|"110110",
      "11" when others;
   ----------------Synchro barrier, entering cycle 1----------------
   signR<= '0' when (sXsYExnXY_d1="100000" or sXsYExnXY_d1="010000") else signX_d1;
   ---------------- cycle 0----------------
   expDiff <= eXmeY when swap = '0' else eYmeX;
   shiftedOut <= '1' when (expDiff >= 40) else '0';
   ----------------Synchro barrier, entering cycle 1----------------
   shiftVal <= expDiff_d1(5 downto 0) when shiftedOut_d1='0' else CONV_STD_LOGIC_VECTOR(41,6) ;
   RightShifterComponent: FPAdd_9_38_uid2_RightShifter  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => shiftedFracY,
                 S => shiftVal,
                 X => fracY_d1);
   ----------------Synchro barrier, entering cycle 2----------------
   sticky <= '0' when (shiftedFracY_d1(38 downto 0)=CONV_STD_LOGIC_VECTOR(0,38)) else '1';
   ---------------- cycle 1----------------
   ----------------Synchro barrier, entering cycle 2----------------
   fracYfar <= "0" & shiftedFracY_d1(79 downto 39);
   EffSubVector <= (41 downto 0 => EffSub_d2);
   fracYfarXorOp <= fracYfar xor EffSubVector;
   fracXfar <= "01" & (newX_d2(37 downto 0)) & "00";
   cInAddFar <= EffSub_d2 and not sticky;
   fracAdder: IntAdder_42_f200_uid14  -- pipelineDepth=0 maxInDelay=1.52744e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => cInAddFar,
                 R => fracAddResult,
                 X => fracXfar,
                 Y => fracYfarXorOp);
   fracGRS<= fracAddResult & sticky;
   extendedExpInc<= ("00" & expX_d2) + '1';
   LZC_component: LZCShifter_43_to_43_counting_64_uid21  -- pipelineDepth=2 maxInDelay=3.16144e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Count => nZerosNew,
                 I => fracGRS,
                 O => shiftedFrac);
   ----------------Synchro barrier, entering cycle 4----------------
   updatedExp <= extendedExpInc_d2 - ("00000" & nZerosNew);
   eqdiffsign <= '1' when nZerosNew="111111" else '0';
   expFrac<= updatedExp & shiftedFrac(41 downto 3);
   ---------------- cycle 4----------------
   stk<= shiftedFrac(1) or shiftedFrac(0);
   rnd<= shiftedFrac(2);
   grd<= shiftedFrac(3);
   lsb<= shiftedFrac(4);
--   addToRoundBit<= '0' when (lsb='0' and grd='1' and rnd='0' and stk='0')  else '1';
   addToRoundBit<= '0' when (lsb='0' and grd='1' and stk='0')  else '1'; -- mod by JDH Sept 16, 2015
   roundingAdder: IntAdder_50_f200_uid24  -- pipelineDepth=1 maxInDelay=3.28588e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => addToRoundBit,
                 R => RoundedExpFrac,
                 X => expFrac,
                 Y => "00000000000000000000000000000000000000000000000000");
   ---------------- cycle 5----------------
   upExc <= RoundedExpFrac(49 downto 48);
   fracR <= RoundedExpFrac(38 downto 1);
   expR <= RoundedExpFrac(47 downto 39);
   exExpExc <= upExc & excRt_d5;
   with (exExpExc) select
   excRt2<= "00" when "0000"|"0100"|"1000"|"1100"|"1001"|"1101",
      "01" when "0001",
      "10" when "0010"|"0110"|"1010"|"1110"|"0101",
      "11" when others;
   excR <= "00" when (eqdiffsign_d1='1' and EffSub_d5='1') else excRt2;
   signR2 <= '0' when (eqdiffsign_d1='1' and EffSub_d5='1') else signR_d4;
   computedR <= excR & signR2 & expR & fracR;
   R <= computedR;
end architecture;
