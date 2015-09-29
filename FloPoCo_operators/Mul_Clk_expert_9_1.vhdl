-- vagrant@vagrant-ubuntu-trusty-32:~/flopoco-3.0.beta5$ ./flopoco -frequency=200 -useHardMult=no FPMultExpert 9 1 38 23 1 0
-- 
-- Final report:
-- Entity Compressor_3_2
--    Not pipelined
-- |   |---Entity IntAdder_42_f200_uid15
-- |   |      Not pipelined
-- |---Entity IntMultiplier_UsingDSP_2_39_41_unsigned_uid4
-- |      Not pipelined
-- |---Entity IntAdder_34_f200_uid23
-- |      Not pipelined
-- Entity FPMult_9_1_9_38_9_23_uid2
--    Pipeline depth = 1
-- Output file: flopoco.vhdl
--------------------------------------------------------------------------------
--                               Compressor_3_2
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Popa, Illyes Kinga, 2012
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Compressor_3_2 is
   port ( X0 : in  std_logic_vector(2 downto 0);
          R : out  std_logic_vector(1 downto 0)   );
end entity;

architecture arch of Compressor_3_2 is
signal X :  std_logic_vector(2 downto 0);
begin
   X <=X0 ;
   with X select R <=
      "00" when "000",
      "01" when "001",
      "01" when "010",
      "10" when "011",
      "01" when "100",
      "10" when "101",
      "10" when "110",
      "11" when "111",
      "--" when others;

end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_42_f200_uid15
--                    (IntAdderAlternative_42_f200_uid19)
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

entity IntAdder_42_f200_uid15 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(41 downto 0);
          Y : in  std_logic_vector(41 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(41 downto 0)   );
end entity;

architecture arch of IntAdder_42_f200_uid15 is
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
--                IntMultiplier_UsingDSP_2_39_41_unsigned_uid4
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin, Kinga Illyes, Bogdan Popa, Bogdan Pasca, 2012
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity IntMultiplier_UsingDSP_2_39_41_unsigned_uid4 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(1 downto 0);
          Y : in  std_logic_vector(38 downto 0);
          R : out  std_logic_vector(40 downto 0)   );
end entity;

architecture arch of IntMultiplier_UsingDSP_2_39_41_unsigned_uid4 is
   component IntAdder_42_f200_uid15 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(41 downto 0);
             Y : in  std_logic_vector(41 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(41 downto 0)   );
   end component;

signal XX_m5 :  std_logic_vector(38 downto 0);
signal YY_m5 :  std_logic_vector(1 downto 0);
signal R0_m5 :  std_logic_vector(40 downto 0);
signal R1i_m5 :  std_logic_vector(40 downto 0);
signal R1_m5 :  std_logic_vector(40 downto 0);
signal heap_bh6_w0_0 :  std_logic;
signal heap_bh6_w0_1 :  std_logic;
signal heap_bh6_w1_0 :  std_logic;
signal heap_bh6_w1_1 :  std_logic;
signal heap_bh6_w2_0 :  std_logic;
signal heap_bh6_w2_1 :  std_logic;
signal heap_bh6_w3_0 :  std_logic;
signal heap_bh6_w3_1 :  std_logic;
signal heap_bh6_w4_0 :  std_logic;
signal heap_bh6_w4_1 :  std_logic;
signal heap_bh6_w5_0 :  std_logic;
signal heap_bh6_w5_1 :  std_logic;
signal heap_bh6_w6_0 :  std_logic;
signal heap_bh6_w6_1 :  std_logic;
signal heap_bh6_w7_0 :  std_logic;
signal heap_bh6_w7_1 :  std_logic;
signal heap_bh6_w8_0 :  std_logic;
signal heap_bh6_w8_1 :  std_logic;
signal heap_bh6_w9_0 :  std_logic;
signal heap_bh6_w9_1 :  std_logic;
signal heap_bh6_w10_0 :  std_logic;
signal heap_bh6_w10_1 :  std_logic;
signal heap_bh6_w11_0 :  std_logic;
signal heap_bh6_w11_1 :  std_logic;
signal heap_bh6_w12_0 :  std_logic;
signal heap_bh6_w12_1 :  std_logic;
signal heap_bh6_w13_0 :  std_logic;
signal heap_bh6_w13_1 :  std_logic;
signal heap_bh6_w14_0 :  std_logic;
signal heap_bh6_w14_1 :  std_logic;
signal heap_bh6_w15_0 :  std_logic;
signal heap_bh6_w15_1 :  std_logic;
signal heap_bh6_w16_0 :  std_logic;
signal heap_bh6_w16_1 :  std_logic;
signal heap_bh6_w17_0 :  std_logic;
signal heap_bh6_w17_1 :  std_logic;
signal heap_bh6_w18_0 :  std_logic;
signal heap_bh6_w18_1 :  std_logic;
signal heap_bh6_w19_0 :  std_logic;
signal heap_bh6_w19_1 :  std_logic;
signal heap_bh6_w20_0 :  std_logic;
signal heap_bh6_w20_1 :  std_logic;
signal heap_bh6_w21_0 :  std_logic;
signal heap_bh6_w21_1 :  std_logic;
signal heap_bh6_w22_0 :  std_logic;
signal heap_bh6_w22_1 :  std_logic;
signal heap_bh6_w23_0 :  std_logic;
signal heap_bh6_w23_1 :  std_logic;
signal heap_bh6_w24_0 :  std_logic;
signal heap_bh6_w24_1 :  std_logic;
signal heap_bh6_w25_0 :  std_logic;
signal heap_bh6_w25_1 :  std_logic;
signal heap_bh6_w26_0 :  std_logic;
signal heap_bh6_w26_1 :  std_logic;
signal heap_bh6_w27_0 :  std_logic;
signal heap_bh6_w27_1 :  std_logic;
signal heap_bh6_w28_0 :  std_logic;
signal heap_bh6_w28_1 :  std_logic;
signal heap_bh6_w29_0 :  std_logic;
signal heap_bh6_w29_1 :  std_logic;
signal heap_bh6_w30_0 :  std_logic;
signal heap_bh6_w30_1 :  std_logic;
signal heap_bh6_w31_0 :  std_logic;
signal heap_bh6_w31_1 :  std_logic;
signal heap_bh6_w32_0 :  std_logic;
signal heap_bh6_w32_1 :  std_logic;
signal heap_bh6_w33_0 :  std_logic;
signal heap_bh6_w33_1 :  std_logic;
signal heap_bh6_w34_0 :  std_logic;
signal heap_bh6_w34_1 :  std_logic;
signal heap_bh6_w35_0 :  std_logic;
signal heap_bh6_w35_1 :  std_logic;
signal heap_bh6_w36_0 :  std_logic;
signal heap_bh6_w36_1 :  std_logic;
signal heap_bh6_w37_0 :  std_logic;
signal heap_bh6_w37_1 :  std_logic;
signal heap_bh6_w38_0 :  std_logic;
signal heap_bh6_w38_1 :  std_logic;
signal heap_bh6_w39_0 :  std_logic;
signal heap_bh6_w39_1 :  std_logic;
signal heap_bh6_w40_0 :  std_logic;
signal heap_bh6_w40_1 :  std_logic;
signal finalAdderIn0_bh6 :  std_logic_vector(41 downto 0);
signal finalAdderIn1_bh6 :  std_logic_vector(41 downto 0);
signal finalAdderCin_bh6 :  std_logic;
signal finalAdderOut_bh6 :  std_logic_vector(41 downto 0);
signal CompressionResult6 :  std_logic_vector(41 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   XX_m5 <= Y ;
   YY_m5 <= X ;
   R0_m5 <= ("00" & XX_m5) when YY_m5(0)='1' else "00000000000000000000000000000000000000000";
   R1i_m5 <= ('0' & XX_m5 & '0') when YY_m5(1)='1' else "00000000000000000000000000000000000000000";
   R1_m5 <= R1i_m5;
   heap_bh6_w0_0 <= R0_m5(0); -- cycle= 0 cp= 0
   heap_bh6_w0_1 <= R1_m5(0); -- cycle= 0 cp= 0
   heap_bh6_w1_0 <= R0_m5(1); -- cycle= 0 cp= 0
   heap_bh6_w1_1 <= R1_m5(1); -- cycle= 0 cp= 0
   heap_bh6_w2_0 <= R0_m5(2); -- cycle= 0 cp= 0
   heap_bh6_w2_1 <= R1_m5(2); -- cycle= 0 cp= 0
   heap_bh6_w3_0 <= R0_m5(3); -- cycle= 0 cp= 0
   heap_bh6_w3_1 <= R1_m5(3); -- cycle= 0 cp= 0
   heap_bh6_w4_0 <= R0_m5(4); -- cycle= 0 cp= 0
   heap_bh6_w4_1 <= R1_m5(4); -- cycle= 0 cp= 0
   heap_bh6_w5_0 <= R0_m5(5); -- cycle= 0 cp= 0
   heap_bh6_w5_1 <= R1_m5(5); -- cycle= 0 cp= 0
   heap_bh6_w6_0 <= R0_m5(6); -- cycle= 0 cp= 0
   heap_bh6_w6_1 <= R1_m5(6); -- cycle= 0 cp= 0
   heap_bh6_w7_0 <= R0_m5(7); -- cycle= 0 cp= 0
   heap_bh6_w7_1 <= R1_m5(7); -- cycle= 0 cp= 0
   heap_bh6_w8_0 <= R0_m5(8); -- cycle= 0 cp= 0
   heap_bh6_w8_1 <= R1_m5(8); -- cycle= 0 cp= 0
   heap_bh6_w9_0 <= R0_m5(9); -- cycle= 0 cp= 0
   heap_bh6_w9_1 <= R1_m5(9); -- cycle= 0 cp= 0
   heap_bh6_w10_0 <= R0_m5(10); -- cycle= 0 cp= 0
   heap_bh6_w10_1 <= R1_m5(10); -- cycle= 0 cp= 0
   heap_bh6_w11_0 <= R0_m5(11); -- cycle= 0 cp= 0
   heap_bh6_w11_1 <= R1_m5(11); -- cycle= 0 cp= 0
   heap_bh6_w12_0 <= R0_m5(12); -- cycle= 0 cp= 0
   heap_bh6_w12_1 <= R1_m5(12); -- cycle= 0 cp= 0
   heap_bh6_w13_0 <= R0_m5(13); -- cycle= 0 cp= 0
   heap_bh6_w13_1 <= R1_m5(13); -- cycle= 0 cp= 0
   heap_bh6_w14_0 <= R0_m5(14); -- cycle= 0 cp= 0
   heap_bh6_w14_1 <= R1_m5(14); -- cycle= 0 cp= 0
   heap_bh6_w15_0 <= R0_m5(15); -- cycle= 0 cp= 0
   heap_bh6_w15_1 <= R1_m5(15); -- cycle= 0 cp= 0
   heap_bh6_w16_0 <= R0_m5(16); -- cycle= 0 cp= 0
   heap_bh6_w16_1 <= R1_m5(16); -- cycle= 0 cp= 0
   heap_bh6_w17_0 <= R0_m5(17); -- cycle= 0 cp= 0
   heap_bh6_w17_1 <= R1_m5(17); -- cycle= 0 cp= 0
   heap_bh6_w18_0 <= R0_m5(18); -- cycle= 0 cp= 0
   heap_bh6_w18_1 <= R1_m5(18); -- cycle= 0 cp= 0
   heap_bh6_w19_0 <= R0_m5(19); -- cycle= 0 cp= 0
   heap_bh6_w19_1 <= R1_m5(19); -- cycle= 0 cp= 0
   heap_bh6_w20_0 <= R0_m5(20); -- cycle= 0 cp= 0
   heap_bh6_w20_1 <= R1_m5(20); -- cycle= 0 cp= 0
   heap_bh6_w21_0 <= R0_m5(21); -- cycle= 0 cp= 0
   heap_bh6_w21_1 <= R1_m5(21); -- cycle= 0 cp= 0
   heap_bh6_w22_0 <= R0_m5(22); -- cycle= 0 cp= 0
   heap_bh6_w22_1 <= R1_m5(22); -- cycle= 0 cp= 0
   heap_bh6_w23_0 <= R0_m5(23); -- cycle= 0 cp= 0
   heap_bh6_w23_1 <= R1_m5(23); -- cycle= 0 cp= 0
   heap_bh6_w24_0 <= R0_m5(24); -- cycle= 0 cp= 0
   heap_bh6_w24_1 <= R1_m5(24); -- cycle= 0 cp= 0
   heap_bh6_w25_0 <= R0_m5(25); -- cycle= 0 cp= 0
   heap_bh6_w25_1 <= R1_m5(25); -- cycle= 0 cp= 0
   heap_bh6_w26_0 <= R0_m5(26); -- cycle= 0 cp= 0
   heap_bh6_w26_1 <= R1_m5(26); -- cycle= 0 cp= 0
   heap_bh6_w27_0 <= R0_m5(27); -- cycle= 0 cp= 0
   heap_bh6_w27_1 <= R1_m5(27); -- cycle= 0 cp= 0
   heap_bh6_w28_0 <= R0_m5(28); -- cycle= 0 cp= 0
   heap_bh6_w28_1 <= R1_m5(28); -- cycle= 0 cp= 0
   heap_bh6_w29_0 <= R0_m5(29); -- cycle= 0 cp= 0
   heap_bh6_w29_1 <= R1_m5(29); -- cycle= 0 cp= 0
   heap_bh6_w30_0 <= R0_m5(30); -- cycle= 0 cp= 0
   heap_bh6_w30_1 <= R1_m5(30); -- cycle= 0 cp= 0
   heap_bh6_w31_0 <= R0_m5(31); -- cycle= 0 cp= 0
   heap_bh6_w31_1 <= R1_m5(31); -- cycle= 0 cp= 0
   heap_bh6_w32_0 <= R0_m5(32); -- cycle= 0 cp= 0
   heap_bh6_w32_1 <= R1_m5(32); -- cycle= 0 cp= 0
   heap_bh6_w33_0 <= R0_m5(33); -- cycle= 0 cp= 0
   heap_bh6_w33_1 <= R1_m5(33); -- cycle= 0 cp= 0
   heap_bh6_w34_0 <= R0_m5(34); -- cycle= 0 cp= 0
   heap_bh6_w34_1 <= R1_m5(34); -- cycle= 0 cp= 0
   heap_bh6_w35_0 <= R0_m5(35); -- cycle= 0 cp= 0
   heap_bh6_w35_1 <= R1_m5(35); -- cycle= 0 cp= 0
   heap_bh6_w36_0 <= R0_m5(36); -- cycle= 0 cp= 0
   heap_bh6_w36_1 <= R1_m5(36); -- cycle= 0 cp= 0
   heap_bh6_w37_0 <= R0_m5(37); -- cycle= 0 cp= 0
   heap_bh6_w37_1 <= R1_m5(37); -- cycle= 0 cp= 0
   heap_bh6_w38_0 <= R0_m5(38); -- cycle= 0 cp= 0
   heap_bh6_w38_1 <= R1_m5(38); -- cycle= 0 cp= 0
   heap_bh6_w39_0 <= R0_m5(39); -- cycle= 0 cp= 0
   heap_bh6_w39_1 <= R1_m5(39); -- cycle= 0 cp= 0
   heap_bh6_w40_0 <= R0_m5(40); -- cycle= 0 cp= 0
   heap_bh6_w40_1 <= R1_m5(40); -- cycle= 0 cp= 0

   -- Beginning of code generated by BitHeap::generateCompressorVHDL
   -- code generated by BitHeap::generateSupertileVHDL()
   ----------------Synchro barrier, entering cycle 0----------------

   -- Adding the constant bits
      -- All the constant bits are zero, nothing to add

   ----------------Synchro barrier, entering cycle 0----------------
   ----------------Synchro barrier, entering cycle 0----------------
   finalAdderIn0_bh6 <= "0" & heap_bh6_w40_1 & heap_bh6_w39_1 & heap_bh6_w38_1 & heap_bh6_w37_1 & heap_bh6_w36_1 & heap_bh6_w35_1 & heap_bh6_w34_1 & heap_bh6_w33_1 & heap_bh6_w32_1 & heap_bh6_w31_1 & heap_bh6_w30_1 & heap_bh6_w29_1 & heap_bh6_w28_1 & heap_bh6_w27_1 & heap_bh6_w26_1 & heap_bh6_w25_1 & heap_bh6_w24_1 & heap_bh6_w23_1 & heap_bh6_w22_1 & heap_bh6_w21_1 & heap_bh6_w20_1 & heap_bh6_w19_1 & heap_bh6_w18_1 & heap_bh6_w17_1 & heap_bh6_w16_1 & heap_bh6_w15_1 & heap_bh6_w14_1 & heap_bh6_w13_1 & heap_bh6_w12_1 & heap_bh6_w11_1 & heap_bh6_w10_1 & heap_bh6_w9_1 & heap_bh6_w8_1 & heap_bh6_w7_1 & heap_bh6_w6_1 & heap_bh6_w5_1 & heap_bh6_w4_1 & heap_bh6_w3_1 & heap_bh6_w2_1 & heap_bh6_w1_1 & heap_bh6_w0_1;
   finalAdderIn1_bh6 <= "0" & heap_bh6_w40_0 & heap_bh6_w39_0 & heap_bh6_w38_0 & heap_bh6_w37_0 & heap_bh6_w36_0 & heap_bh6_w35_0 & heap_bh6_w34_0 & heap_bh6_w33_0 & heap_bh6_w32_0 & heap_bh6_w31_0 & heap_bh6_w30_0 & heap_bh6_w29_0 & heap_bh6_w28_0 & heap_bh6_w27_0 & heap_bh6_w26_0 & heap_bh6_w25_0 & heap_bh6_w24_0 & heap_bh6_w23_0 & heap_bh6_w22_0 & heap_bh6_w21_0 & heap_bh6_w20_0 & heap_bh6_w19_0 & heap_bh6_w18_0 & heap_bh6_w17_0 & heap_bh6_w16_0 & heap_bh6_w15_0 & heap_bh6_w14_0 & heap_bh6_w13_0 & heap_bh6_w12_0 & heap_bh6_w11_0 & heap_bh6_w10_0 & heap_bh6_w9_0 & heap_bh6_w8_0 & heap_bh6_w7_0 & heap_bh6_w6_0 & heap_bh6_w5_0 & heap_bh6_w4_0 & heap_bh6_w3_0 & heap_bh6_w2_0 & heap_bh6_w1_0 & heap_bh6_w0_0;
   finalAdderCin_bh6 <= '0';
   Adder_final6_0: IntAdder_42_f200_uid15  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => finalAdderCin_bh6,
                 R => finalAdderOut_bh6   ,
                 X => finalAdderIn0_bh6,
                 Y => finalAdderIn1_bh6);
   -- concatenate all the compressed chunks
   CompressionResult6 <= finalAdderOut_bh6;
   -- End of code generated by BitHeap::generateCompressorVHDL
   R <= CompressionResult6(40 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_34_f200_uid23
--                    (IntAdderAlternative_34_f200_uid27)
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

entity IntAdder_34_f200_uid23 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(33 downto 0);
          Y : in  std_logic_vector(33 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(33 downto 0)   );
end entity;

architecture arch of IntAdder_34_f200_uid23 is
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
--                         FPMult_9_1_9_38_9_23_uid2
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Bogdan Pasca, Florent de Dinechin 2008-2011
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FPMult_9_1_9_38_9_23_uid2 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(9+1+2 downto 0);
          Y : in  std_logic_vector(9+38+2 downto 0);
          R : out  std_logic_vector(9+23+2 downto 0);
---- mod by JDH Sept 21, 2015 -------          
          round : buffer std_logic;
          sign  : buffer std_logic;
          roundit : in std_logic   );
-------------------------------------          
end entity;

architecture arch of FPMult_9_1_9_38_9_23_uid2 is
   component IntAdder_34_f200_uid23 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(33 downto 0);
             Y : in  std_logic_vector(33 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(33 downto 0)   );
   end component;

   component IntMultiplier_UsingDSP_2_39_41_unsigned_uid4 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(1 downto 0);
             Y : in  std_logic_vector(38 downto 0);
             R : out  std_logic_vector(40 downto 0)   );
   end component;

--signal sign, sign_d1 :  std_logic;
signal sign_d1 :  std_logic;
signal expX :  std_logic_vector(8 downto 0);
signal expY :  std_logic_vector(8 downto 0);
signal expSumPreSub :  std_logic_vector(10 downto 0);
signal bias :  std_logic_vector(10 downto 0);
signal expSum :  std_logic_vector(10 downto 0);
signal sigX :  std_logic_vector(1 downto 0);
signal sigY :  std_logic_vector(38 downto 0);
signal sigProd :  std_logic_vector(40 downto 0);
signal excSel :  std_logic_vector(3 downto 0);
signal exc, exc_d1 :  std_logic_vector(1 downto 0);
signal norm :  std_logic;
signal expPostNorm :  std_logic_vector(10 downto 0);
signal sigProdExt, sigProdExt_d1 :  std_logic_vector(40 downto 0);
signal expSig, expSig_d1 :  std_logic_vector(33 downto 0);
signal sticky, sticky_d1 :  std_logic;
signal guard :  std_logic;
--signal round :  std_logic;
signal expSigPostRound :  std_logic_vector(33 downto 0);
signal excPostNorm :  std_logic_vector(1 downto 0);
signal finalExc :  std_logic_vector(1 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            sign_d1 <=  sign;
            exc_d1 <=  exc;
            sigProdExt_d1 <=  sigProdExt;
            expSig_d1 <=  expSig;
            sticky_d1 <=  sticky;
         end if;
      end process;
   sign <= X(10) xor Y(47);
   expX <= X(9 downto 1);
   expY <= Y(46 downto 38);
   expSumPreSub <= ("00" & expX) + ("00" & expY);
   bias <= CONV_STD_LOGIC_VECTOR(255,11);
   expSum <= expSumPreSub - bias;
   ----------------Synchro barrier, entering cycle 0----------------
   sigX <= "1" & X(0 downto 0);
   sigY <= "1" & Y(37 downto 0);
   SignificandMultiplication: IntMultiplier_UsingDSP_2_39_41_unsigned_uid4  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => sigProd,
                 X => sigX,
                 Y => sigY);
   ----------------Synchro barrier, entering cycle 0----------------
   excSel <= X(12 downto 11) & Y(49 downto 48);
   with excSel select
   exc <= "00" when  "0000" | "0001" | "0100",
          "01" when "0101",
          "10" when "0110" | "1001" | "1010" ,
          "11" when others;
   norm <= sigProd(40);
   -- exponent update
   expPostNorm <= expSum + ("0000000000" & norm);
   -- significand normalization shift
   sigProdExt <= sigProd(39 downto 0) & "0" when norm='1' else
                         sigProd(38 downto 0) & "00";
   expSig <= expPostNorm & sigProdExt(40 downto 18);
   sticky <= sigProdExt(17);
   ----------------Synchro barrier, entering cycle 1----------------
   guard <= '0' when sigProdExt_d1(16 downto 0)="00000000000000000" else '1';
   round <= sticky_d1 and ( (guard and not(sigProdExt_d1(18))) or (sigProdExt_d1(18) ))  ;
   RoundingAdder: IntAdder_34_f200_uid23  -- pipelineDepth=0 maxInDelay=5.3072e-10
      port map ( clk  => clk,
                 rst  => rst,
 --                Cin => round,
                 Cin => roundit,  -- mod by JDH Sept 21, 2015
                 R => expSigPostRound   ,
                 X => expSig_d1,
                 Y => "0000000000000000000000000000000000");
   with expSigPostRound(33 downto 32) select
   excPostNorm <=  "01"  when  "00",
                               "10"             when "01",
                               "00"             when "11"|"10",
                               "11"             when others;
   with exc_d1 select
   finalExc <= exc_d1 when  "11"|"10"|"00",
                       excPostNorm when others;
   R <= finalExc & sign_d1 & expSigPostRound(31 downto 0);
end architecture;

