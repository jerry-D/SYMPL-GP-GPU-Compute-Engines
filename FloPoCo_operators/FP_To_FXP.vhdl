-- ./flopoco -name=FP_To_FXP -frequency=200 -useHardMult=no FP2Fix 8 23 S 31 0 0
-- 
-- Final report:
-- |---Entity FP2Fix_8_23_0_31_US_NTExponent_difference
-- |      Not pipelined
-- |---Entity LeftShifter_24_by_max_34_uid10
-- |      Not pipelined
-- |---Entity FP2Fix_8_23_0_31_US_NTMantSum
-- |      Not pipelined
-- Entity FP_To_FXP
--    Not pipelined
-- 
-- 
-- --------------------------------------------------------------------------------
--                 FP2Fix_8_23_0_31_US_NTExponent_difference
--                           (IntAdder_8_f200_uid3)
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

entity FP2Fix_8_23_0_31_US_NTExponent_difference is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(7 downto 0);
          Y : in  std_logic_vector(7 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(7 downto 0)   );
end entity;

architecture arch of FP2Fix_8_23_0_31_US_NTExponent_difference is
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
--                       LeftShifter_24_by_max_34_uid10
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

entity LeftShifter_24_by_max_34_uid10 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(23 downto 0);
          S : in  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(57 downto 0)   );
end entity;

architecture arch of LeftShifter_24_by_max_34_uid10 is
signal level0 :  std_logic_vector(23 downto 0);
signal ps :  std_logic_vector(5 downto 0);
signal level1 :  std_logic_vector(24 downto 0);
signal level2 :  std_logic_vector(26 downto 0);
signal level3 :  std_logic_vector(30 downto 0);
signal level4 :  std_logic_vector(38 downto 0);
signal level5 :  std_logic_vector(54 downto 0);
signal level6 :  std_logic_vector(86 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   level0<= X;
   ps<= S;
   level1<= level0 & (0 downto 0 => '0') when ps(0)= '1' else     (0 downto 0 => '0') & level0;
   level2<= level1 & (1 downto 0 => '0') when ps(1)= '1' else     (1 downto 0 => '0') & level1;
   level3<= level2 & (3 downto 0 => '0') when ps(2)= '1' else     (3 downto 0 => '0') & level2;
   level4<= level3 & (7 downto 0 => '0') when ps(3)= '1' else     (7 downto 0 => '0') & level3;
   level5<= level4 & (15 downto 0 => '0') when ps(4)= '1' else     (15 downto 0 => '0') & level4;
   level6<= level5 & (31 downto 0 => '0') when ps(5)= '1' else     (31 downto 0 => '0') & level5;
   R <= level6(57 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                       FP2Fix_8_23_0_31_US_NTMantSum
--                          (IntAdder_33_f200_uid13)
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

entity FP2Fix_8_23_0_31_US_NTMantSum is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(32 downto 0);
          Y : in  std_logic_vector(32 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(32 downto 0)   );
end entity;

architecture arch of FP2Fix_8_23_0_31_US_NTMantSum is
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
--                                 FP_To_FXP
--                          (FP2Fix_8_23_0_31_US_NT)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Fabrizio Ferrandi (2012)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FP_To_FXP is
   port ( clk, rst : in std_logic;
          I : in  std_logic_vector(8+23+2 downto 0);
          O : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of FP_To_FXP is
   component FP2Fix_8_23_0_31_US_NTExponent_difference is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(7 downto 0);
             Y : in  std_logic_vector(7 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(7 downto 0)   );
   end component;

   component FP2Fix_8_23_0_31_US_NTMantSum is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(32 downto 0);
             Y : in  std_logic_vector(32 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(32 downto 0)   );
   end component;

   component LeftShifter_24_by_max_34_uid10 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(23 downto 0);
             S : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(57 downto 0)   );
   end component;

signal eA0 :  std_logic_vector(7 downto 0);
signal fA0 :  std_logic_vector(23 downto 0);
signal bias :  std_logic_vector(7 downto 0);
signal eA1 :  std_logic_vector(7 downto 0);
signal shiftedby :  std_logic_vector(5 downto 0);
signal fA1 :  std_logic_vector(57 downto 0);
signal fA2a :  std_logic_vector(32 downto 0);
signal notallzero :  std_logic;
signal round :  std_logic;
signal fA2b :  std_logic_vector(32 downto 0);
signal fA3 :  std_logic_vector(32 downto 0);
signal fA4 :  std_logic_vector(31 downto 0);
signal overFl0 :  std_logic;
signal overFl1 :  std_logic;
signal eTest :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   eA0 <= I(30 downto 23);
   fA0 <= "1" & I(22 downto 0);
   bias <= not conv_std_logic_vector(126, 8);
   Exponent_difference: FP2Fix_8_23_0_31_US_NTExponent_difference  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '1',
                 R => eA1,
                 X => bias,
                 Y => eA0);
   ---------------- cycle 0----------------
   shiftedby <= eA1(5 downto 0) when eA1(7) = '0' else (5 downto 0 => '0');
   FXP_shifter: LeftShifter_24_by_max_34_uid10  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => fA1,
                 S => shiftedby,
                 X => fA0);
   fA2a<= '0' & fA1(55 downto 24);
   notallzero <= '0' when fA1(22 downto 0) = (22 downto 0 => '0') else '1';
   round <= fA1(23) and notallzero ;
   fA2b<= '0' & (31 downto 1 => '0') & round;
   MantSum: FP2Fix_8_23_0_31_US_NTMantSum  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '0',
                 R => fA3,
                 X => fA2a,
                 Y => fA2b);
   ---------------- cycle 0----------------
   fA4<= fA3(31 downto 0);
   overFl0<= '1' when I(30 downto 23) > conv_std_logic_vector(158,8) else I(33);
   overFl1 <= fA3(32);
   eTest <= (overFl0 or overFl1);
   O <= fA4 when eTest = '0' else
      I(31) & (30 downto 0 => not I(31));
end architecture;
