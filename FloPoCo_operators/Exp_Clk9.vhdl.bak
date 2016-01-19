-- vagrant@vagrant-ubuntu-trusty-32:~/flopoco-3.0.beta5$ ./flopoco -name=Exp_Clk -frequency=200 -useHardMult=no FPExp 9 23
-- Warning: the given expression is not a constant but an expression to evaluate. A faithful evaluation to 10000 bits will be used.
-- Warning: the given expression is not a constant but an expression to evaluate. A faithful evaluation to 10000 bits will be used.
-- Updating entity name to: Exp_Clk
-- 
-- Final report:
-- Entity SmallMultTableP3x3r6XuYu
--    Not pipelined
-- Entity Compressor_6_3
--    Not pipelined
-- Entity Compressor_14_3
--    Not pipelined
-- Entity Compressor_4_3
--    Not pipelined
-- Entity Compressor_23_3
--    Not pipelined
-- Entity Compressor_3_2
--    Not pipelined
-- |---Entity LeftShifter_24_by_max_34_uid3
-- |      Not pipelined
-- |   |---Entity FixRealKCM_M3_7_0_1_log_2_unsigned_Table_1
-- |   |      Not pipelined
-- |   |---Entity FixRealKCM_M3_7_0_1_log_2_unsigned_Table_0
-- |   |      Not pipelined
-- |   |---Entity IntAdder_13_f200_uid11
-- |   |      Not pipelined
-- |---Entity FixRealKCM_M3_7_0_1_log_2_unsigned
-- |      Pipeline depth = 1
-- |   |---Entity FixRealKCM_0_8_M26_log_2_unsigned_Table_1
-- |   |      Not pipelined
-- |   |---Entity FixRealKCM_0_8_M26_log_2_unsigned_Table_0
-- |   |      Not pipelined
-- |   |---Entity IntAdder_35_f200_uid24
-- |   |      Pipeline depth = 1
-- |---Entity FixRealKCM_0_8_M26_log_2_unsigned
-- |      Pipeline depth = 1
-- |---Entity IntAdder_26_f219_uid32
-- |      Not pipelined
-- |---Entity MagicSPExpTable
-- |      Not pipelined
-- |---Entity IntAdder_18_f200_uid41
-- |      Not pipelined
-- |---Entity IntAdder_18_f200_uid48
-- |      Not pipelined
-- |   |---Entity IntAdder_24_f200_uid155
-- |   |      Not pipelined
-- |---Entity IntMultiplier_UsingDSP_17_18_19_unsigned_uid55
-- |      Pipeline depth = 1
-- |---Entity IntAdder_27_f200_uid163
-- |      Not pipelined
-- |---Entity IntAdder_34_f200_uid170
-- |      Not pipelined
-- Entity Exp_Clk
--    Pipeline depth = 6
-- Output file: flopoco.vhdl
--------------------------------------------------------------------------------
--                          SmallMultTableP3x3r6XuYu
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin (2007-2012)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
entity SmallMultTableP3x3r6XuYu is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(5 downto 0);
          Y : out  std_logic_vector(5 downto 0)   );
end entity;

architecture arch of SmallMultTableP3x3r6XuYu is
begin
  with X select  Y <=
   "000000" when "000000",
   "000000" when "000001",
   "000000" when "000010",
   "000000" when "000011",
   "000000" when "000100",
   "000000" when "000101",
   "000000" when "000110",
   "000000" when "000111",
   "000000" when "001000",
   "000001" when "001001",
   "000010" when "001010",
   "000011" when "001011",
   "000100" when "001100",
   "000101" when "001101",
   "000110" when "001110",
   "000111" when "001111",
   "000000" when "010000",
   "000010" when "010001",
   "000100" when "010010",
   "000110" when "010011",
   "001000" when "010100",
   "001010" when "010101",
   "001100" when "010110",
   "001110" when "010111",
   "000000" when "011000",
   "000011" when "011001",
   "000110" when "011010",
   "001001" when "011011",
   "001100" when "011100",
   "001111" when "011101",
   "010010" when "011110",
   "010101" when "011111",
   "000000" when "100000",
   "000100" when "100001",
   "001000" when "100010",
   "001100" when "100011",
   "010000" when "100100",
   "010100" when "100101",
   "011000" when "100110",
   "011100" when "100111",
   "000000" when "101000",
   "000101" when "101001",
   "001010" when "101010",
   "001111" when "101011",
   "010100" when "101100",
   "011001" when "101101",
   "011110" when "101110",
   "100011" when "101111",
   "000000" when "110000",
   "000110" when "110001",
   "001100" when "110010",
   "010010" when "110011",
   "011000" when "110100",
   "011110" when "110101",
   "100100" when "110110",
   "101010" when "110111",
   "000000" when "111000",
   "000111" when "111001",
   "001110" when "111010",
   "010101" when "111011",
   "011100" when "111100",
   "100011" when "111101",
   "101010" when "111110",
   "110001" when "111111",
   "------" when others;
end architecture;

--------------------------------------------------------------------------------
--                               Compressor_6_3
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

entity Compressor_6_3 is
   port ( X0 : in  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_6_3 is
signal X :  std_logic_vector(5 downto 0);
begin
   X <=X0 ;
   with X select R <=
      "000" when "000000",
      "001" when "000001",
      "001" when "000010",
      "010" when "000011",
      "001" when "000100",
      "010" when "000101",
      "010" when "000110",
      "011" when "000111",
      "001" when "001000",
      "010" when "001001",
      "010" when "001010",
      "011" when "001011",
      "010" when "001100",
      "011" when "001101",
      "011" when "001110",
      "100" when "001111",
      "001" when "010000",
      "010" when "010001",
      "010" when "010010",
      "011" when "010011",
      "010" when "010100",
      "011" when "010101",
      "011" when "010110",
      "100" when "010111",
      "010" when "011000",
      "011" when "011001",
      "011" when "011010",
      "100" when "011011",
      "011" when "011100",
      "100" when "011101",
      "100" when "011110",
      "101" when "011111",
      "001" when "100000",
      "010" when "100001",
      "010" when "100010",
      "011" when "100011",
      "010" when "100100",
      "011" when "100101",
      "011" when "100110",
      "100" when "100111",
      "010" when "101000",
      "011" when "101001",
      "011" when "101010",
      "100" when "101011",
      "011" when "101100",
      "100" when "101101",
      "100" when "101110",
      "101" when "101111",
      "010" when "110000",
      "011" when "110001",
      "011" when "110010",
      "100" when "110011",
      "011" when "110100",
      "100" when "110101",
      "100" when "110110",
      "101" when "110111",
      "011" when "111000",
      "100" when "111001",
      "100" when "111010",
      "101" when "111011",
      "100" when "111100",
      "101" when "111101",
      "101" when "111110",
      "110" when "111111",
      "---" when others;

end architecture;

--------------------------------------------------------------------------------
--                              Compressor_14_3
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

entity Compressor_14_3 is
   port ( X0 : in  std_logic_vector(3 downto 0);
          X1 : in  std_logic_vector(0 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_14_3 is
signal X :  std_logic_vector(4 downto 0);
begin
   X <=X1 & X0 ;
   with X select R <=
      "000" when "00000",
      "001" when "00001",
      "001" when "00010",
      "010" when "00011",
      "001" when "00100",
      "010" when "00101",
      "010" when "00110",
      "011" when "00111",
      "001" when "01000",
      "010" when "01001",
      "010" when "01010",
      "011" when "01011",
      "010" when "01100",
      "011" when "01101",
      "011" when "01110",
      "100" when "01111",
      "010" when "10000",
      "011" when "10001",
      "011" when "10010",
      "100" when "10011",
      "011" when "10100",
      "100" when "10101",
      "100" when "10110",
      "101" when "10111",
      "011" when "11000",
      "100" when "11001",
      "100" when "11010",
      "101" when "11011",
      "100" when "11100",
      "101" when "11101",
      "101" when "11110",
      "110" when "11111",
      "---" when others;

end architecture;

--------------------------------------------------------------------------------
--                               Compressor_4_3
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

entity Compressor_4_3 is
   port ( X0 : in  std_logic_vector(3 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_4_3 is
signal X :  std_logic_vector(3 downto 0);
begin
   X <=X0 ;
   with X select R <=
      "000" when "0000",
      "001" when "0001",
      "001" when "0010",
      "010" when "0011",
      "001" when "0100",
      "010" when "0101",
      "010" when "0110",
      "011" when "0111",
      "001" when "1000",
      "010" when "1001",
      "010" when "1010",
      "011" when "1011",
      "010" when "1100",
      "011" when "1101",
      "011" when "1110",
      "100" when "1111",
      "---" when others;

end architecture;

--------------------------------------------------------------------------------
--                              Compressor_23_3
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

entity Compressor_23_3 is
   port ( X0 : in  std_logic_vector(2 downto 0);
          X1 : in  std_logic_vector(1 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_23_3 is
signal X :  std_logic_vector(4 downto 0);
begin
   X <=X1 & X0 ;
   with X select R <=
      "000" when "00000",
      "001" when "00001",
      "001" when "00010",
      "010" when "00011",
      "001" when "00100",
      "010" when "00101",
      "010" when "00110",
      "011" when "00111",
      "010" when "01000",
      "011" when "01001",
      "011" when "01010",
      "100" when "01011",
      "011" when "01100",
      "100" when "01101",
      "100" when "01110",
      "101" when "01111",
      "010" when "10000",
      "011" when "10001",
      "011" when "10010",
      "100" when "10011",
      "011" when "10100",
      "100" when "10101",
      "100" when "10110",
      "101" when "10111",
      "100" when "11000",
      "101" when "11001",
      "101" when "11010",
      "110" when "11011",
      "101" when "11100",
      "110" when "11101",
      "110" when "11110",
      "111" when "11111",
      "---" when others;

end architecture;

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
--                       LeftShifter_24_by_max_34_uid3
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

entity LeftShifter_24_by_max_34_uid3 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(23 downto 0);
          S : in  std_logic_vector(5 downto 0);
          R : out  std_logic_vector(57 downto 0)   );
end entity;

architecture arch of LeftShifter_24_by_max_34_uid3 is
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
--                 FixRealKCM_M3_7_0_1_log_2_unsigned_Table_1
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin (2007-2012)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
entity FixRealKCM_M3_7_0_1_log_2_unsigned_Table_1 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(4 downto 0);
          Y : out  std_logic_vector(12 downto 0)   );
end entity;

architecture arch of FixRealKCM_M3_7_0_1_log_2_unsigned_Table_1 is
begin
  with X select  Y <=
   "0000000001000" when "00000",
   "0000011000001" when "00001",
   "0000101111001" when "00010",
   "0001000110010" when "00011",
   "0001011101011" when "00100",
   "0001110100011" when "00101",
   "0010001011100" when "00110",
   "0010100010101" when "00111",
   "0010111001101" when "01000",
   "0011010000110" when "01001",
   "0011100111111" when "01010",
   "0011111110111" when "01011",
   "0100010110000" when "01100",
   "0100101101001" when "01101",
   "0101000100001" when "01110",
   "0101011011010" when "01111",
   "0101110010011" when "10000",
   "0110001001011" when "10001",
   "0110100000100" when "10010",
   "0110110111101" when "10011",
   "0111001110101" when "10100",
   "0111100101110" when "10101",
   "0111111100111" when "10110",
   "1000010011111" when "10111",
   "1000101011000" when "11000",
   "1001000010001" when "11001",
   "1001011001001" when "11010",
   "1001110000010" when "11011",
   "1010000111011" when "11100",
   "1010011110011" when "11101",
   "1010110101100" when "11110",
   "1011001100101" when "11111",
   "-------------" when others;
end architecture;

--------------------------------------------------------------------------------
--                 FixRealKCM_M3_7_0_1_log_2_unsigned_Table_0
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin (2007-2012)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
entity FixRealKCM_M3_7_0_1_log_2_unsigned_Table_0 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(5 downto 0);
          Y : out  std_logic_vector(7 downto 0)   );
end entity;

architecture arch of FixRealKCM_M3_7_0_1_log_2_unsigned_Table_0 is
begin
  with X select  Y <=
   "00000000" when "000000",
   "00000011" when "000001",
   "00000110" when "000010",
   "00001001" when "000011",
   "00001100" when "000100",
   "00001110" when "000101",
   "00010001" when "000110",
   "00010100" when "000111",
   "00010111" when "001000",
   "00011010" when "001001",
   "00011101" when "001010",
   "00100000" when "001011",
   "00100011" when "001100",
   "00100110" when "001101",
   "00101000" when "001110",
   "00101011" when "001111",
   "00101110" when "010000",
   "00110001" when "010001",
   "00110100" when "010010",
   "00110111" when "010011",
   "00111010" when "010100",
   "00111101" when "010101",
   "00111111" when "010110",
   "01000010" when "010111",
   "01000101" when "011000",
   "01001000" when "011001",
   "01001011" when "011010",
   "01001110" when "011011",
   "01010001" when "011100",
   "01010100" when "011101",
   "01010111" when "011110",
   "01011001" when "011111",
   "01011100" when "100000",
   "01011111" when "100001",
   "01100010" when "100010",
   "01100101" when "100011",
   "01101000" when "100100",
   "01101011" when "100101",
   "01101110" when "100110",
   "01110001" when "100111",
   "01110011" when "101000",
   "01110110" when "101001",
   "01111001" when "101010",
   "01111100" when "101011",
   "01111111" when "101100",
   "10000010" when "101101",
   "10000101" when "101110",
   "10001000" when "101111",
   "10001010" when "110000",
   "10001101" when "110001",
   "10010000" when "110010",
   "10010011" when "110011",
   "10010110" when "110100",
   "10011001" when "110101",
   "10011100" when "110110",
   "10011111" when "110111",
   "10100010" when "111000",
   "10100100" when "111001",
   "10100111" when "111010",
   "10101010" when "111011",
   "10101101" when "111100",
   "10110000" when "111101",
   "10110011" when "111110",
   "10110110" when "111111",
   "--------" when others;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_13_f200_uid11
--                    (IntAdderAlternative_13_f200_uid15)
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

entity IntAdder_13_f200_uid11 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(12 downto 0);
          Y : in  std_logic_vector(12 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(12 downto 0)   );
end entity;

architecture arch of IntAdder_13_f200_uid11 is
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
--                     FixRealKCM_M3_7_0_1_log_2_unsigned
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors:
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FixRealKCM_M3_7_0_1_log_2_unsigned is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(10 downto 0);
          R : out  std_logic_vector(8 downto 0)   );
end entity;

architecture arch of FixRealKCM_M3_7_0_1_log_2_unsigned is
   component FixRealKCM_M3_7_0_1_log_2_unsigned_Table_0 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             Y : out  std_logic_vector(7 downto 0)   );
   end component;

   component FixRealKCM_M3_7_0_1_log_2_unsigned_Table_1 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(4 downto 0);
             Y : out  std_logic_vector(12 downto 0)   );
   end component;

   component IntAdder_13_f200_uid11 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(12 downto 0);
             Y : in  std_logic_vector(12 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(12 downto 0)   );
   end component;

signal d1 :  std_logic_vector(4 downto 0);
signal d0 :  std_logic_vector(5 downto 0);
signal pp0, pp0_d1 :  std_logic_vector(7 downto 0);
signal pp1, pp1_d1 :  std_logic_vector(12 downto 0);
signal addOp0 :  std_logic_vector(12 downto 0);
signal OutRes :  std_logic_vector(12 downto 0);
attribute rom_extract: string;
attribute rom_style: string;
attribute rom_extract of FixRealKCM_M3_7_0_1_log_2_unsigned_Table_0: component is "yes";
attribute rom_extract of FixRealKCM_M3_7_0_1_log_2_unsigned_Table_1: component is "yes";
attribute rom_style of FixRealKCM_M3_7_0_1_log_2_unsigned_Table_0: component is "distributed";
attribute rom_style of FixRealKCM_M3_7_0_1_log_2_unsigned_Table_1: component is "distributed";
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            pp0_d1 <=  pp0;
            pp1_d1 <=  pp1;
         end if;
      end process;
   d1 <= X(10 downto 6);
   d0 <= X(5 downto 0);
   KCMTable_0: FixRealKCM_M3_7_0_1_log_2_unsigned_Table_0  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => d0,
                 Y => pp0);
   KCMTable_1: FixRealKCM_M3_7_0_1_log_2_unsigned_Table_1  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => d1,
                 Y => pp1);
   ----------------Synchro barrier, entering cycle 1----------------
   addOp0 <= (12 downto 8 => '0') & pp0_d1;
   Result_Adder: IntAdder_13_f200_uid11  -- pipelineDepth=0 maxInDelay=1.08008e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '0',
                 R => OutRes,
                 X => addOp0,
                 Y => pp1_d1);
   R <= OutRes(12 downto 4);
end architecture;

--------------------------------------------------------------------------------
--                 FixRealKCM_0_8_M26_log_2_unsigned_Table_1
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin (2007-2012)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
entity FixRealKCM_0_8_M26_log_2_unsigned_Table_1 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(2 downto 0);
          Y : out  std_logic_vector(34 downto 0)   );
end entity;

architecture arch of FixRealKCM_0_8_M26_log_2_unsigned_Table_1 is
begin
  with X select  Y <=
   "00000000000000000000000000000000000" when "000",
   "00010110001011100100001011111111000" when "001",
   "00101100010111001000010111111110000" when "010",
   "01000010100010101100100011111100111" when "011",
   "01011000101110010000101111111011111" when "100",
   "01101110111001110100111011111010111" when "101",
   "10000101000101011001000111111001111" when "110",
   "10011011010000111101010011111000111" when "111",
   "-----------------------------------" when others;
end architecture;

--------------------------------------------------------------------------------
--                 FixRealKCM_0_8_M26_log_2_unsigned_Table_0
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin (2007-2012)
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
entity FixRealKCM_0_8_M26_log_2_unsigned_Table_0 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(5 downto 0);
          Y : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of FixRealKCM_0_8_M26_log_2_unsigned_Table_0 is
begin
  with X select  Y <=
   "00000000000000000000000000000000" when "000000",
   "00000010110001011100100001100000" when "000001",
   "00000101100010111001000011000000" when "000010",
   "00001000010100010101100100100000" when "000011",
   "00001011000101110010000101111111" when "000100",
   "00001101110111001110100111011111" when "000101",
   "00010000101000101011001000111111" when "000110",
   "00010011011010000111101010011111" when "000111",
   "00010110001011100100001011111111" when "001000",
   "00011000111101000000101101011111" when "001001",
   "00011011101110011101001110111111" when "001010",
   "00011110011111111001110000011111" when "001011",
   "00100001010001010110010001111110" when "001100",
   "00100100000010110010110011011110" when "001101",
   "00100110110100001111010100111110" when "001110",
   "00101001100101101011110110011110" when "001111",
   "00101100010111001000010111111110" when "010000",
   "00101111001000100100111001011110" when "010001",
   "00110001111010000001011010111110" when "010010",
   "00110100101011011101111100011110" when "010011",
   "00110111011100111010011101111101" when "010100",
   "00111010001110010110111111011101" when "010101",
   "00111100111111110011100000111101" when "010110",
   "00111111110001010000000010011101" when "010111",
   "01000010100010101100100011111101" when "011000",
   "01000101010100001001000101011101" when "011001",
   "01001000000101100101100110111101" when "011010",
   "01001010110111000010001000011101" when "011011",
   "01001101101000011110101001111100" when "011100",
   "01010000011001111011001011011100" when "011101",
   "01010011001011010111101100111100" when "011110",
   "01010101111100110100001110011100" when "011111",
   "01011000101110010000101111111100" when "100000",
   "01011011011111101101010001011100" when "100001",
   "01011110010001001001110010111100" when "100010",
   "01100001000010100110010100011100" when "100011",
   "01100011110100000010110101111011" when "100100",
   "01100110100101011111010111011011" when "100101",
   "01101001010110111011111000111011" when "100110",
   "01101100001000011000011010011011" when "100111",
   "01101110111001110100111011111011" when "101000",
   "01110001101011010001011101011011" when "101001",
   "01110100011100101101111110111011" when "101010",
   "01110111001110001010100000011011" when "101011",
   "01111001111111100111000001111010" when "101100",
   "01111100110001000011100011011010" when "101101",
   "01111111100010100000000100111010" when "101110",
   "10000010010011111100100110011010" when "101111",
   "10000101000101011001000111111010" when "110000",
   "10000111110110110101101001011010" when "110001",
   "10001010101000010010001010111010" when "110010",
   "10001101011001101110101100011001" when "110011",
   "10010000001011001011001101111001" when "110100",
   "10010010111100100111101111011001" when "110101",
   "10010101101110000100010000111001" when "110110",
   "10011000011111100000110010011001" when "110111",
   "10011011010000111101010011111001" when "111000",
   "10011110000010011001110101011001" when "111001",
   "10100000110011110110010110111001" when "111010",
   "10100011100101010010111000011000" when "111011",
   "10100110010110101111011001111000" when "111100",
   "10101001001000001011111011011000" when "111101",
   "10101011111001101000011100111000" when "111110",
   "10101110101011000100111110011000" when "111111",
   "--------------------------------" when others;
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_35_f200_uid24
--                     (IntAdderClassical_35_f200_uid26)
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

entity IntAdder_35_f200_uid24 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(34 downto 0);
          Y : in  std_logic_vector(34 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(34 downto 0)   );
end entity;

architecture arch of IntAdder_35_f200_uid24 is
signal X_d1 :  std_logic_vector(34 downto 0);
signal Y_d1 :  std_logic_vector(34 downto 0);
signal Cin_d1 :  std_logic;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            X_d1 <=  X;
            Y_d1 <=  Y;
            Cin_d1 <=  Cin;
         end if;
      end process;
   --Classical
   ----------------Synchro barrier, entering cycle 1----------------
    R <= X_d1 + Y_d1 + Cin_d1;
end architecture;

--------------------------------------------------------------------------------
--                     FixRealKCM_0_8_M26_log_2_unsigned
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors:
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FixRealKCM_0_8_M26_log_2_unsigned is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(8 downto 0);
          R : out  std_logic_vector(34 downto 0)   );
end entity;

architecture arch of FixRealKCM_0_8_M26_log_2_unsigned is
   component FixRealKCM_0_8_M26_log_2_unsigned_Table_0 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             Y : out  std_logic_vector(31 downto 0)   );
   end component;

   component FixRealKCM_0_8_M26_log_2_unsigned_Table_1 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(2 downto 0);
             Y : out  std_logic_vector(34 downto 0)   );
   end component;

   component IntAdder_35_f200_uid24 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(34 downto 0);
             Y : in  std_logic_vector(34 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(34 downto 0)   );
   end component;

signal d1 :  std_logic_vector(2 downto 0);
signal d0 :  std_logic_vector(5 downto 0);
signal pp0 :  std_logic_vector(31 downto 0);
signal pp1 :  std_logic_vector(34 downto 0);
signal addOp0 :  std_logic_vector(34 downto 0);
signal OutRes :  std_logic_vector(34 downto 0);
attribute rom_extract: string;
attribute rom_style: string;
attribute rom_extract of FixRealKCM_0_8_M26_log_2_unsigned_Table_0: component is "yes";
attribute rom_extract of FixRealKCM_0_8_M26_log_2_unsigned_Table_1: component is "yes";
attribute rom_style of FixRealKCM_0_8_M26_log_2_unsigned_Table_0: component is "distributed";
attribute rom_style of FixRealKCM_0_8_M26_log_2_unsigned_Table_1: component is "distributed";
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   d1 <= X(8 downto 6);
   d0 <= X(5 downto 0);
   KCMTable_0: FixRealKCM_0_8_M26_log_2_unsigned_Table_0  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => d0,
                 Y => pp0);
   KCMTable_1: FixRealKCM_0_8_M26_log_2_unsigned_Table_1  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => d1,
                 Y => pp1);
   addOp0 <= (34 downto 32 => '0') & pp0;
   Result_Adder: IntAdder_35_f200_uid24  -- pipelineDepth=1 maxInDelay=3.93836e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '0',
                 R => OutRes,
                 X => addOp0,
                 Y => pp1);
   ----------------Synchro barrier, entering cycle 1----------------
   R <= OutRes(34 downto 0);
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_26_f219_uid32
--                    (IntAdderAlternative_26_f219_uid36)
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

entity IntAdder_26_f219_uid32 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(25 downto 0);
          Y : in  std_logic_vector(25 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(25 downto 0)   );
end entity;

architecture arch of IntAdder_26_f219_uid32 is
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
--                              MagicSPExpTable
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Radu Tudoran, Florent de Dinechin (2009)
--------------------------------------------------------------------------------
-- combinatorial

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity MagicSPExpTable is
   port ( X1 : in  std_logic_vector(8 downto 0);
          Y1 : out  std_logic_vector(35 downto 0);
          X2 : in  std_logic_vector(8 downto 0);
          Y2 : out  std_logic_vector(35 downto 0)   );
end entity;

architecture arch of MagicSPExpTable is
type ROMContent is array (0 to 511) of std_logic_vector(35 downto 0);
constant memVar: ROMContent :=    (
      "100000000000000000000000000000000000",       "100000000100000000010000000000000000",       "100000001000000001000000001000000000",       "100000001100000010010000010000000000",
      "100000010000000100000000101000000000",       "100000010100000110010001010000000000",       "100000011000001001000010010000000000",       "100000011100001100010011101000000000",
      "100000100000010000000101011000000000",       "100000100100010100010111101000000000",       "100000101000011001001010100000000000",       "100000101100011110011110000000000000",
      "100000110000100100010010001000000000",       "100000110100101010100111000000000000",       "100000111000110001011100110000000000",       "100000111100111000110011011000000000",
      "100001000001000000101011000000000000",       "100001000101001001000011101000000000",       "100001001001010001111101010000000000",       "100001001101011011011000001000000000",
      "100001010001100101010100001000000000",       "100001010101101111110001100000000000",       "100001011001111010110000001000000000",       "100001011110000110010000001000000000",
      "100001100010010010010001110000000000",       "100001100110011110110100110000000000",       "100001101010101011111001011000000000",       "100001101110111001011111110000000000",
      "100001110011000111100111111000000000",       "100001110111010110010001110000000000",       "100001111011100101011101011000000000",       "100001111111110101001011001000000000",
      "100010000100000101011010110000000001",       "100010001000010110001100100000000001",       "100010001100100111100000010000000001",       "100010010000111001010110011000000001",
      "100010010101001011101110101000000001",       "100010011001011110101001010000000001",       "100010011101110010000110011000000001",       "100010100010000110000101111000000001",
      "100010100110011010100111111000000001",       "100010101010101111101100100000000001",       "100010101111000101010011111000000001",       "100010110011011011011101111000000001",
      "100010110111110010001010110000000001",       "100010111100001001011010100000000001",       "100011000000100001001101001000000001",       "100011000100111001100010110000000001",
      "100011001001010010011011100000000001",       "100011001101101011110111011000000001",       "100011010010000101110110100000000001",       "100011010110100000011000111000000001",
      "100011011010111011011110101000000001",       "100011011111010111000111110000000001",       "100011100011110011010100011000000001",       "100011101000010000000100101000000001",
      "100011101100101101011000100000000010",       "100011110001001011010000000000000010",       "100011110101101001101011010000000010",       "100011111010001000101010100000000010",
      "100011111110101000001101100000000010",       "100100000011001000010100100000000010",       "100100000111101000111111101000000010",       "100100001100001010001110110000000010",
      "100100010000101100000010001000000010",       "100100010101001110011001111000000010",       "100100011001110001010101110000000010",       "100100011110010100110110001000000010",
      "100100100010111000111011000000000010",       "100100100111011101100100100000000010",       "100100101100000010110010100000000010",       "100100110000101000100101001000000010",
      "100100110101001110111100101000000011",       "100100111001110101111000111000000011",       "100100111110011101011010001000000011",       "100101000011000101100000010000000011",
      "100101000111101110001011100000000011",       "100101001100010111011011111000000011",       "100101010001000001010001011000000011",       "100101010101101011101100010000000011",
      "100101011010010110101100011000000011",       "100101011111000010010001111000000011",       "100101100011101110011101000000000011",       "100101101000011011001101100000000011",
      "100101101101001000100011110000000011",       "100101110001110110011111110000000100",       "100101110110100101000001011000000100",       "100101111011010100001001000000000100",
      "100110000000000011110110100000000100",       "100110000100110100001010000000000100",       "100110001001100101000011100000000100",       "100110001110010110100011010000000100",
      "100110010011001000101001010000000100",       "100110010111111011010101100000000100",       "100110011100101110101000001000000100",       "100110100001100010100001001000000100",
      "100110100110010111000000110000000101",       "100110101011001100000110111000000101",       "100110110000000001110011110000000101",       "100110110100111000000111011000000101",
      "100110111001101111000001111000000101",       "100110111110100110100011001000000101",       "100111000011011110101011100000000101",       "100111001000010111011010111000000101",
      "100111001101010000110001011000000101",       "100111010010001010101111001000000101",       "100111010111000101010100001000000101",       "100111011100000000100000011000000110",
      "100111100000111100010100010000000110",       "100111100101111000101111100000000110",       "100111101010110101110010100000000110",       "100111101111110011011101000000000110",
      "100111110100110001101111011000000110",       "100111111001110000101001100000000110",       "100111111110110000001011100000000110",       "101000000011110000010101100000000110",
      "101000001000110001000111101000000111",       "101000001101110010100001111000000111",       "101000010010110100100100010000000111",       "101000010111110111001111000000000111",
      "101000011100111010100010001000000111",       "101000100001111110011101101000000111",       "101000100111000011000001110000000111",       "101000101100001000001110100000000111",
      "101000110001001110000011111000001000",       "101000110110010100100010000000001000",       "101000111011011011101001000000001000",       "101001000000100011011001000000001000",
      "101001000101101011110001111000001000",       "101001001010110100110011111000001000",       "101001001111111110011111001000001000",       "101001010101001000110011100000001000",
      "101001011010010011110001011000001001",       "101001011111011111011000100000001001",       "101001100100101011101001010000001001",       "101001101001111000100011100000001001",
      "101001101111000110000111011000001001",       "101001110100010100010101000000001001",       "101001111001100011001100100000001001",       "101001111110110010101101111000001001",
      "101010000100000010111001010000001010",       "101010001001010011101110101000001010",       "101010001110100101001110001000001010",       "101010010011110111010111111000001010",
      "101010011001001010001100000000001010",       "101010011110011101101010100000001010",       "101010100011110001110011100000001010",       "101010101001000110100111000000001011",
      "101010101110011100000101001000001011",       "101010110011110010001110000000001011",       "101010111001001001000001110000001011",       "101010111110100000100000011000001011",
      "101011000011111000101001111000001011",       "101011001001010001011110100000001011",       "101011001110101010111110010000001100",       "101011010100000101001001010000001100",
      "101011011001011111111111101000001100",       "101011011110111011100001010000001100",       "101011100100010111101110100000001100",       "101011101001110100100111010000001100",
      "101011101111010010001011110000001101",       "101011110100110000011011111000001101",       "101011111010001111010111111000001101",       "101011111111101110111111110000001101",
      "101100000101001111010011101000001101",       "101100001010110000010011101000001101",       "101100010000010001111111110000001101",       "101100010101110100011000001000001110",
      "101100011011010111011100111000001110",       "101100100000111011001110000000001110",       "101100100110011111101011101000001110",       "101100101100000100110110000000001110",
      "101100110001101010101100111000001110",       "101100110111010001010000101000001111",       "101100111100111000100001010000001111",       "101101000010100000011110110000001111",
      "101101001000001001001001011000001111",       "101101001101110010100001001000001111",       "101101010011011100100110000000001111",       "101101011001000111011000010000010000",
      "101101011110110010110111111000010000",       "101101100100011111000101000000010000",       "101101101010001011111111110000010000",       "101101101111111001101000001000010000",
      "101101110101100111111110001000010001",       "101101111011010111000010001000010001",       "101110000001000110110100000000010001",       "101110000110110111010011111000010001",
      "101110001100101000100001111000010001",       "101110010010011010011110000000010001",       "101110011000001101001000100000010010",       "101110011110000000100001010000010010",
      "101110100011110100101000101000010010",       "101110101001101001011110100000010010",       "101110101111011111000011000000010010",       "101110110101010101010110010000010011",
      "101110111011001100011000011000010011",       "101111000001000100001001011000010011",       "101111000110111100101001100000010011",       "101111001100110101111000101000010011",
      "101111010010101111110111000000010100",       "101111011000101010100100101000010100",       "101111011110100110000001101000010100",       "101111100100100010001110001000010100",
      "101111101010011111001010010000010100",       "101111110000011100110110000000010101",       "101111110110011011010001100000010101",       "101111111100011010011100110000010101",
      "110000000010011010011000001000010101",       "110000001000011011000011011000010101",       "110000001110011100011110111000010110",       "110000010100011110101010101000010110",
      "110000011010100001100110101000010110",       "110000100000100101010011000000010110",       "110000100110101001110000000000010110",       "110000101100101110111101100000010111",
      "110000110010110100111011110000010111",       "110000111000111011101010110000010111",       "110000111111000011001010101000010111",       "110001000101001011011011101000010111",
      "110001001011010100011101100000011000",       "110001010001011110010000110000011000",       "110001010111101000110101001000011000",       "110001011101110100001011000000011000",
      "110001100100000000010010010000011001",       "110001101010001101001011001000011001",       "110001110000011010110101100000011001",       "110001110110101001010001110000011001",
      "110001111100111000011111111000011001",       "110010000011001000100000000000011010",       "110010001001011001010010001000011010",       "110010001111101010110110011000011010",
      "110010010101111101001100111000011010",       "110010011100010000010101101000011011",       "110010100010100100010000111000011011",       "110010101000111000111110110000011011",
      "110010101111001110011111010000011011",       "110010110101100100110010011000011011",       "110010111011111011111000100000011100",       "110011000010010011110001011000011100",
      "110011001000101100011101011000011100",       "110011001111000101111100100000011100",       "110011010101100000001110111000011101",       "110011011011111011010100101000011101",
      "110011100010010111001101110000011101",       "110011101000110011111010100000011101",       "110011101111010001011010110000011110",       "110011110101101111101110111000011110",
      "110011111100001110110110110000011110",       "110100000010101110110010101000011110",       "110100001001001111100010100000011111",       "110100001111110001000110100000011111",
      "110100010110010011011110111000011111",       "110100011100110110101011100000011111",       "110100100011011010101100100000100000",       "110100101001111111100010001000100000",
      "010011011010001011001100000000100000",       "010011011100100110100111000000100000",       "010011011111000010010101101000100001",       "010011100001011110010111101000100001",
      "010011100011111010101101010000100001",       "010011100110010111010110011000100001",       "010011101000110100010011001000100010",       "010011101011010001100011011000100010",
      "010011101101101111000111100000100010",       "010011110000001100111111010000100010",       "010011110010101011001010110000100011",       "010011110101001001101010000000100011",
      "010011110111101000011101001000100011",       "010011111010000111100100001000100011",       "010011111100100110111111000000100100",       "010011111111000110101101111000100100",
      "010100000001100110110000110000100100",       "010100000100000111000111101000100100",       "010100000110100111110010100000100101",       "010100001001001000110001101000100101",
      "010100001011101010000100110000100101",       "010100001110001011101100001000100101",       "010100010000101101100111101000100110",       "010100010011001111110111100000100110",
      "010100010101110010011011101000100110",       "010100011000010101010100001000100111",       "010100011010111000100001000000100111",       "010100011101011100000010010000100111",
      "010100011111111111111000000000100111",       "010100100010100100000010010000101000",       "010100100101001000100001000000101000",       "010100100111101101010100011000101000",
      "010100101010010010011100011000101001",       "010100101100110111111001000000101001",       "010100101111011101101010011000101001",       "010100110010000011110000100000101001",
      "010100110100101010001011011000101010",       "010100110111010000111011000000101010",       "010100111001110111111111101000101010",       "010100111100011111011001000000101011",
      "010100111111000111000111100000101011",       "010101000001101111001010111000101011",       "010101000100010111100011010000101011",       "010101000111000000010000110000101100",
      "010101001001101001010011011000101100",       "010101001100010010101011001000101100",       "010101001110111100011000000000101101",       "010101010001100110011010001000101101",
      "010101010100010000110001101000101101",       "010101010110111011011110011000101101",       "010101011001100110100000100000101110",       "010101011100010001111000000000101110",
      "010101011110111101100101000000101110",       "010101100001101001100111011000101111",       "010101100100010101111111011000101111",       "010101100111000010101101000000101111",
      "010101101001101111110000001000110000",       "010101101100011101001000111000110000",       "010101101111001010110111011000110000",       "010101110001111000111011101000110000",
      "010101110100100111010101101000110001",       "010101110111010110000101100000110001",       "010101111010000101001011001000110001",       "010101111100110100100110110000110010",
      "010101111111100100011000011000110010",       "010110000010010100011111111000110010",       "010110000101000100111101100000110011",       "010110000111110101110001001000110011",
      "010110001010100110111011000000110011",       "010110001101011000011010111000110100",       "010110010000001010010001000000110100",       "010110010010111100011101100000110100",
      "010110010101101111000000001000110101",       "010110011000100001111001010000110101",       "010110011011010101001000101000110101",       "010110011110001000101110100000110110",
      "010110100000111100101010111000110110",       "010110100011110000111101110000110110",       "010110100110100101100111001000110110",       "010110101001011010100111001000110111",
      "010110101100001111111101110000110111",       "010110101111000101101011001000110111",       "010110110001111011101111010000111000",       "010110110100110010001010001000111000",
      "010110110111101000111011110000111000",       "010110111010100000000100011000111001",       "010110111101010111100011111000111001",       "010111000000001111011010010000111001",
      "010111000011000111100111101000111010",       "010111000110000000001100001000111010",       "010111001000111001000111110000111010",       "010111001011110010011010100000111011",
      "010111001110101100000100011000111011",       "010111010001100110000101100000111011",       "010111010100100000011101111000111100",       "010111010111011011001101101000111100",
      "010111011010010110010100110000111101",       "010111011101010001110011010000111101",       "010111100000001101101001001000111101",       "010111100011001001110110101000111110",
      "010111100110000110011011101000111110",       "010111101001000011011000010000111110",       "010111101100000000101100100000111111",       "010111101110111110011000100000111111",
      "010111110001111100011100001000111111",       "010111110100111010110111101001000000",       "010111110111111001101010111001000000",       "010111111010111000110110000001000000",
      "010111111101111000011001001001000001",       "011000000000111000010100001001000001",       "011000000011111000100111001001000001",       "011000000110111001010010010001000010",
      "011000001001111010010101100001000010",       "011000001100111011110000111001000011",       "011000001111111101100100100001000011",       "011000010010111111110000010001000011",
      "011000010110000010010100011001000100",       "011000011001000101010000111001000100",       "011000011100001000100101110001000100",       "011000011111001100010011001001000101",
      "011000100010010000011000111001000101",       "011000100101010100110111001001000101",       "011000101000011001101110001001000110",       "011000101011011110111101101001000110",
      "011000101110100100100101111001000111",       "011000110001101010100110110001000111",       "011000110100110001000000100001000111",       "011000110111110111110011000001001000",
      "011000111010111110111110100001001000",       "011000111110000110100010111001001000",       "011001000001001110100000001001001001",       "011001000100010110110110100001001001",
      "011001000111011111100101111001001010",       "011001001010101000101110011001001010",       "011001001101110010010000000001001010",       "011001010000111100001011000001001011",
      "011001010100000110011111001001001011",       "011001010111010001001100101001001011",       "011001011010011100010011011001001100",       "011001011101100111110011101001001100",
      "011001100000110011101101011001001101",       "011001100100000000000000101001001101",       "011001100111001100101101011001001101",       "011001101010011001110011111001001110",
      "011001101101100111010011111001001110",       "011001110000110101001101101001001111",       "011001110100000011100001010001001111",       "011001110111010010001110101001001111",
      "011001111010100001010101110001010000",       "011001111101110000110110111001010000",       "011010000001000000110010000001010001",       "011010000100010001000111001001010001",
      "011010000111100001110110010001010001",       "011010001010110010111111101001010010",       "011010001110000100100011001001010010",       "011010010001010110100000110001010011",
      "011010010100101000111000110001010011",       "011010010111111011101011000001010011",       "011010011011001110110111101001010100",       "011010011110100010011110110001010100",
      "011010100001110110100000010001010101",       "011010100101001010111100011001010101",       "011010101000011111110011000001010101",       "011010101011110101000100011001010110",
      "011010101111001010110000011001010110",       "011010110010100000110111000001010111",       "011010110101110111011000101001010111",       "011010111001001110010100111001010111",
      "011010111100100101101100001001011000",       "011010111111111101011110011001011000",       "011011000011010101101011100001011001",       "011011000110101110010011110001011001",
      "011011001010000111010111001001011001",       "011011001101100000110101101001011010",       "011011010000111010101111011001011010",       "011011010100010101000100011001011011",
      "011011010111101111110100101001011011",       "011011011011001011000000011001011100",       "011011011110100110100111011001011100",       "011011100010000010101010000001011100",
      "011011100101011111001000001001011101",       "011011101000111100000001110001011101",       "011011101100011001010111001001011110",       "011011101111110111001000001001011110",
      "011011110011010101010100111001011111",       "011011110110110011111101100001011111",       "011011111010010011000010000001011111",       "011011111101110010100010010001100000",
      "011100000001010010011110101001100000",       "011100000100110010110110111001100001",       "011100001000010011101011011001100001",       "011100001011110100111011111001100010",
      "011100001111010110101000101001100010",       "011100010010111000110001100001100010",       "011100010110011011010110110001100011",       "011100011001111110011000011001100011",
      "011100011101100001110110011001100100",       "011100100001000101110000111001100100",       "011100100100101010000111111001100101",       "011100101000001110111011011001100101",
      "011100101011110100001011101001100110",       "011100101111011001111000100001100110",       "011100110011000000000010001001100110",       "011100110110100110101000100001100111",
      "011100111010001101101011110001100111",       "011100111101110101001100000001101000",       "011101000001011101001001001001101000",       "011101000101000101100011010001101001",
      "011101001000101110011010100001101001",       "011101001100010111101110111001101010",       "011101010000000001100000100001101010",       "011101010011101011101111010001101011",
      "011101010111010110011011011001101011",       "011101011011000001100100111001101011",       "011101011110101101001011111001101100",       "011101100010011001010000010001101100",
      "011101100110000101110010001001101101",       "011101101001110010110001101001101101",       "011101101101100000001110111001101110",       "011101110001001110001001110001101110",
      "011101110100111100100010011001101111",       "011101111000101011011000111001101111",       "011101111100011010101101010001110000",       "011110000000001010011111101001110000",
      "011110000011111010101111111001110001",       "011110000111101011011110011001110001",       "011110001011011100101010111001110010",       "011110001111001110010101100001110010",
      "011110010011000000011110011001110010",       "011110010110110011000101101001110011",       "011110011010100110001011010001110011",       "011110011110011001101111010001110100",
      "011110100010001101110001101001110100",       "011110100110000010010010101001110101",       "011110101001110111010010010001110101",       "011110101101101100110000100001110110",
      "011110110001100010101101100001110110",       "011110110101011001001001010001110111",       "011110111001010000000011110001110111",       "011110111101000111011101010001111000",
      "011111000000111111010101101001111000",       "011111000100110111101101001001111001",       "011111001000110000100011101001111001",       "011111001100101001111001010001111010",
      "011111010000100011101110001001111010",       "011111010100011110000010010001111011",       "011111011000011000110101101001111011",       "011111011100010100001000100001111100",
      "011111100000001111111010101001111100",       "011111100100001100001100100001111101",       "011111101000001000111101110001111101",       "011111101100000110001110110001111110",
      "011111110000000011111111011001111110",       "011111110100000010001111110001111111",       "011111111000000000111111111001111111",       "011111111100000000010000000010000000"
)
;
begin
          Y1 <= memVar(conv_integer(X1));
          Y2 <= memVar(conv_integer(X2));
end architecture;

--------------------------------------------------------------------------------
--                           IntAdder_18_f200_uid41
--                    (IntAdderAlternative_18_f200_uid45)
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

entity IntAdder_18_f200_uid41 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(17 downto 0);
          Y : in  std_logic_vector(17 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(17 downto 0)   );
end entity;

architecture arch of IntAdder_18_f200_uid41 is
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
--                           IntAdder_18_f200_uid48
--                    (IntAdderAlternative_18_f200_uid52)
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

entity IntAdder_18_f200_uid48 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(17 downto 0);
          Y : in  std_logic_vector(17 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(17 downto 0)   );
end entity;

architecture arch of IntAdder_18_f200_uid48 is
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
--                          IntAdder_24_f200_uid155
--                    (IntAdderAlternative_24_f200_uid159)
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

entity IntAdder_24_f200_uid155 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(23 downto 0);
          Y : in  std_logic_vector(23 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(23 downto 0)   );
end entity;

architecture arch of IntAdder_24_f200_uid155 is
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
--               IntMultiplier_UsingDSP_17_18_19_unsigned_uid55
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin, Kinga Illyes, Bogdan Popa, Bogdan Pasca, 2012
--------------------------------------------------------------------------------
-- Pipeline depth: 1 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;
library work;

entity IntMultiplier_UsingDSP_17_18_19_unsigned_uid55 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(16 downto 0);
          Y : in  std_logic_vector(17 downto 0);
          R : out  std_logic_vector(18 downto 0)   );
end entity;

architecture arch of IntMultiplier_UsingDSP_17_18_19_unsigned_uid55 is
   component Compressor_14_3 is
      port ( X0 : in  std_logic_vector(3 downto 0);
             X1 : in  std_logic_vector(0 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_23_3 is
      port ( X0 : in  std_logic_vector(2 downto 0);
             X1 : in  std_logic_vector(1 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_3_2 is
      port ( X0 : in  std_logic_vector(2 downto 0);
             R : out  std_logic_vector(1 downto 0)   );
   end component;

   component Compressor_4_3 is
      port ( X0 : in  std_logic_vector(3 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component Compressor_6_3 is
      port ( X0 : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

   component IntAdder_24_f200_uid155 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(23 downto 0);
             Y : in  std_logic_vector(23 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(23 downto 0)   );
   end component;

   component SmallMultTableP3x3r6XuYu is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             Y : out  std_logic_vector(5 downto 0)   );
   end component;

signal XX_m56 :  std_logic_vector(17 downto 0);
signal YY_m56 :  std_logic_vector(16 downto 0);
signal Xp_m56b58 :  std_logic_vector(17 downto 0);
signal Yp_m56b58 :  std_logic_vector(17 downto 0);
signal x_m56b58_0 :  std_logic_vector(2 downto 0);
signal x_m56b58_1 :  std_logic_vector(2 downto 0);
signal x_m56b58_2 :  std_logic_vector(2 downto 0);
signal x_m56b58_3 :  std_logic_vector(2 downto 0);
signal x_m56b58_4 :  std_logic_vector(2 downto 0);
signal x_m56b58_5 :  std_logic_vector(2 downto 0);
signal y_m56b58_0 :  std_logic_vector(2 downto 0);
signal y_m56b58_1 :  std_logic_vector(2 downto 0);
signal y_m56b58_2 :  std_logic_vector(2 downto 0);
signal y_m56b58_3 :  std_logic_vector(2 downto 0);
signal y_m56b58_4 :  std_logic_vector(2 downto 0);
signal y_m56b58_5 :  std_logic_vector(2 downto 0);
signal Y0X3_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X3Y0_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w0_0 :  std_logic;
signal heap_bh57_w1_0 :  std_logic;
signal heap_bh57_w2_0 :  std_logic;
signal Y0X4_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X4Y0_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w1_1 :  std_logic;
signal heap_bh57_w2_1 :  std_logic;
signal heap_bh57_w3_0 :  std_logic;
signal heap_bh57_w4_0 :  std_logic;
signal heap_bh57_w5_0 :  std_logic;
signal Y0X5_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X5Y0_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w4_1 :  std_logic;
signal heap_bh57_w5_1 :  std_logic;
signal heap_bh57_w6_0 :  std_logic;
signal heap_bh57_w7_0 :  std_logic;
signal heap_bh57_w8_0 :  std_logic;
signal Y1X2_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X2Y1_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w0_1 :  std_logic;
signal heap_bh57_w1_2 :  std_logic;
signal heap_bh57_w2_2 :  std_logic;
signal Y1X3_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X3Y1_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w0_2 :  std_logic;
signal heap_bh57_w1_3 :  std_logic;
signal heap_bh57_w2_3 :  std_logic;
signal heap_bh57_w3_1 :  std_logic;
signal heap_bh57_w4_2 :  std_logic;
signal heap_bh57_w5_2 :  std_logic;
signal Y1X4_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X4Y1_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w3_2 :  std_logic;
signal heap_bh57_w4_3 :  std_logic;
signal heap_bh57_w5_3 :  std_logic;
signal heap_bh57_w6_1 :  std_logic;
signal heap_bh57_w7_1 :  std_logic;
signal heap_bh57_w8_1 :  std_logic;
signal Y1X5_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X5Y1_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w6_2 :  std_logic;
signal heap_bh57_w7_2 :  std_logic;
signal heap_bh57_w8_2 :  std_logic;
signal heap_bh57_w9_0 :  std_logic;
signal heap_bh57_w10_0 :  std_logic;
signal heap_bh57_w11_0 :  std_logic;
signal Y2X1_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X1Y2_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w0_3 :  std_logic;
signal heap_bh57_w1_4 :  std_logic;
signal heap_bh57_w2_4 :  std_logic;
signal Y2X2_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X2Y2_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w0_4 :  std_logic;
signal heap_bh57_w1_5 :  std_logic;
signal heap_bh57_w2_5 :  std_logic;
signal heap_bh57_w3_3 :  std_logic;
signal heap_bh57_w4_4 :  std_logic;
signal heap_bh57_w5_4 :  std_logic;
signal Y2X3_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X3Y2_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w3_4 :  std_logic;
signal heap_bh57_w4_5 :  std_logic;
signal heap_bh57_w5_5 :  std_logic;
signal heap_bh57_w6_3 :  std_logic;
signal heap_bh57_w7_3 :  std_logic;
signal heap_bh57_w8_3 :  std_logic;
signal Y2X4_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X4Y2_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w6_4 :  std_logic;
signal heap_bh57_w7_4 :  std_logic;
signal heap_bh57_w8_4 :  std_logic;
signal heap_bh57_w9_1 :  std_logic;
signal heap_bh57_w10_1 :  std_logic;
signal heap_bh57_w11_1 :  std_logic;
signal Y2X5_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X5Y2_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w9_2 :  std_logic;
signal heap_bh57_w10_2 :  std_logic;
signal heap_bh57_w11_2 :  std_logic;
signal heap_bh57_w12_0 :  std_logic;
signal heap_bh57_w13_0 :  std_logic;
signal heap_bh57_w14_0 :  std_logic;
signal Y3X0_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X0Y3_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w0_5 :  std_logic;
signal heap_bh57_w1_6 :  std_logic;
signal heap_bh57_w2_6 :  std_logic;
signal Y3X1_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X1Y3_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w0_6 :  std_logic;
signal heap_bh57_w1_7 :  std_logic;
signal heap_bh57_w2_7 :  std_logic;
signal heap_bh57_w3_5 :  std_logic;
signal heap_bh57_w4_6 :  std_logic;
signal heap_bh57_w5_6 :  std_logic;
signal Y3X2_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X2Y3_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w3_6 :  std_logic;
signal heap_bh57_w4_7 :  std_logic;
signal heap_bh57_w5_7 :  std_logic;
signal heap_bh57_w6_5 :  std_logic;
signal heap_bh57_w7_5 :  std_logic;
signal heap_bh57_w8_5 :  std_logic;
signal Y3X3_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X3Y3_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w6_6 :  std_logic;
signal heap_bh57_w7_6 :  std_logic;
signal heap_bh57_w8_6 :  std_logic;
signal heap_bh57_w9_3 :  std_logic;
signal heap_bh57_w10_3 :  std_logic;
signal heap_bh57_w11_3 :  std_logic;
signal Y3X4_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X4Y3_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w9_4 :  std_logic;
signal heap_bh57_w10_4 :  std_logic;
signal heap_bh57_w11_4 :  std_logic;
signal heap_bh57_w12_1 :  std_logic;
signal heap_bh57_w13_1 :  std_logic;
signal heap_bh57_w14_1 :  std_logic;
signal Y3X5_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X5Y3_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w12_2 :  std_logic;
signal heap_bh57_w13_2 :  std_logic;
signal heap_bh57_w14_2 :  std_logic;
signal heap_bh57_w15_0 :  std_logic;
signal heap_bh57_w16_0 :  std_logic;
signal heap_bh57_w17_0 :  std_logic;
signal Y4X0_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X0Y4_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w0_7 :  std_logic;
signal heap_bh57_w1_8 :  std_logic;
signal heap_bh57_w2_8 :  std_logic;
signal heap_bh57_w3_7 :  std_logic;
signal heap_bh57_w4_8 :  std_logic;
signal heap_bh57_w5_8 :  std_logic;
signal Y4X1_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X1Y4_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w3_8 :  std_logic;
signal heap_bh57_w4_9 :  std_logic;
signal heap_bh57_w5_9 :  std_logic;
signal heap_bh57_w6_7 :  std_logic;
signal heap_bh57_w7_7 :  std_logic;
signal heap_bh57_w8_7 :  std_logic;
signal Y4X2_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X2Y4_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w6_8 :  std_logic;
signal heap_bh57_w7_8 :  std_logic;
signal heap_bh57_w8_8 :  std_logic;
signal heap_bh57_w9_5 :  std_logic;
signal heap_bh57_w10_5 :  std_logic;
signal heap_bh57_w11_5 :  std_logic;
signal Y4X3_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X3Y4_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w9_6 :  std_logic;
signal heap_bh57_w10_6 :  std_logic;
signal heap_bh57_w11_6 :  std_logic;
signal heap_bh57_w12_3 :  std_logic;
signal heap_bh57_w13_3 :  std_logic;
signal heap_bh57_w14_3 :  std_logic;
signal Y4X4_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X4Y4_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w12_4 :  std_logic;
signal heap_bh57_w13_4 :  std_logic;
signal heap_bh57_w14_4 :  std_logic;
signal heap_bh57_w15_1 :  std_logic;
signal heap_bh57_w16_1 :  std_logic;
signal heap_bh57_w17_1 :  std_logic;
signal Y4X5_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X5Y4_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w15_2 :  std_logic;
signal heap_bh57_w16_2 :  std_logic;
signal heap_bh57_w17_2 :  std_logic;
signal heap_bh57_w18_0 :  std_logic;
signal heap_bh57_w19_0 :  std_logic;
signal heap_bh57_w20_0 :  std_logic;
signal Y5X0_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X0Y5_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w3_9 :  std_logic;
signal heap_bh57_w4_10 :  std_logic;
signal heap_bh57_w5_10 :  std_logic;
signal heap_bh57_w6_9 :  std_logic;
signal heap_bh57_w7_9 :  std_logic;
signal heap_bh57_w8_9 :  std_logic;
signal Y5X1_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X1Y5_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w6_10 :  std_logic;
signal heap_bh57_w7_10 :  std_logic;
signal heap_bh57_w8_10 :  std_logic;
signal heap_bh57_w9_7 :  std_logic;
signal heap_bh57_w10_7 :  std_logic;
signal heap_bh57_w11_7 :  std_logic;
signal Y5X2_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X2Y5_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w9_8 :  std_logic;
signal heap_bh57_w10_8 :  std_logic;
signal heap_bh57_w11_8 :  std_logic;
signal heap_bh57_w12_5 :  std_logic;
signal heap_bh57_w13_5 :  std_logic;
signal heap_bh57_w14_5 :  std_logic;
signal Y5X3_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X3Y5_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w12_6 :  std_logic;
signal heap_bh57_w13_6 :  std_logic;
signal heap_bh57_w14_6 :  std_logic;
signal heap_bh57_w15_3 :  std_logic;
signal heap_bh57_w16_3 :  std_logic;
signal heap_bh57_w17_3 :  std_logic;
signal Y5X4_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X4Y5_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w15_4 :  std_logic;
signal heap_bh57_w16_4 :  std_logic;
signal heap_bh57_w17_4 :  std_logic;
signal heap_bh57_w18_1 :  std_logic;
signal heap_bh57_w19_1 :  std_logic;
signal heap_bh57_w20_1 :  std_logic;
signal Y5X5_58_m56 :  std_logic_vector(5 downto 0);
signal PP58X5Y5_m56 :  std_logic_vector(5 downto 0);
signal heap_bh57_w18_2 :  std_logic;
signal heap_bh57_w19_2 :  std_logic;
signal heap_bh57_w20_2 :  std_logic;
signal heap_bh57_w21_0 :  std_logic;
signal heap_bh57_w22_0, heap_bh57_w22_0_d1 :  std_logic;
signal heap_bh57_w23_0, heap_bh57_w23_0_d1 :  std_logic;
signal heap_bh57_w4_11 :  std_logic;
signal CompressorIn_bh57_0_0 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_0_0 :  std_logic_vector(2 downto 0);
signal heap_bh57_w0_8 :  std_logic;
signal heap_bh57_w1_9, heap_bh57_w1_9_d1 :  std_logic;
signal heap_bh57_w2_9 :  std_logic;
signal CompressorIn_bh57_1_1 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_1_1 :  std_logic_vector(2 downto 0);
signal heap_bh57_w1_10 :  std_logic;
signal heap_bh57_w2_10 :  std_logic;
signal heap_bh57_w3_10 :  std_logic;
signal CompressorIn_bh57_2_2 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_2_2 :  std_logic_vector(2 downto 0);
signal heap_bh57_w2_11 :  std_logic;
signal heap_bh57_w3_11 :  std_logic;
signal heap_bh57_w4_12 :  std_logic;
signal CompressorIn_bh57_3_3 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_3_3 :  std_logic_vector(2 downto 0);
signal heap_bh57_w3_12 :  std_logic;
signal heap_bh57_w4_13 :  std_logic;
signal heap_bh57_w5_11 :  std_logic;
signal CompressorIn_bh57_4_4 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_4_4 :  std_logic_vector(2 downto 0);
signal heap_bh57_w4_14 :  std_logic;
signal heap_bh57_w5_12 :  std_logic;
signal heap_bh57_w6_11 :  std_logic;
signal CompressorIn_bh57_5_5 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_5_5 :  std_logic_vector(2 downto 0);
signal heap_bh57_w4_15 :  std_logic;
signal heap_bh57_w5_13 :  std_logic;
signal heap_bh57_w6_12 :  std_logic;
signal CompressorIn_bh57_6_6 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_6_6 :  std_logic_vector(2 downto 0);
signal heap_bh57_w5_14 :  std_logic;
signal heap_bh57_w6_13 :  std_logic;
signal heap_bh57_w7_11 :  std_logic;
signal CompressorIn_bh57_7_7 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_7_7 :  std_logic_vector(2 downto 0);
signal heap_bh57_w6_14 :  std_logic;
signal heap_bh57_w7_12 :  std_logic;
signal heap_bh57_w8_11 :  std_logic;
signal CompressorIn_bh57_8_8 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_8_8 :  std_logic_vector(2 downto 0);
signal heap_bh57_w7_13 :  std_logic;
signal heap_bh57_w8_12 :  std_logic;
signal heap_bh57_w9_9 :  std_logic;
signal CompressorIn_bh57_9_9 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_9_9 :  std_logic_vector(2 downto 0);
signal heap_bh57_w8_13 :  std_logic;
signal heap_bh57_w9_10 :  std_logic;
signal heap_bh57_w10_9 :  std_logic;
signal CompressorIn_bh57_10_10 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_10_10 :  std_logic_vector(2 downto 0);
signal heap_bh57_w9_11 :  std_logic;
signal heap_bh57_w10_10 :  std_logic;
signal heap_bh57_w11_9 :  std_logic;
signal CompressorIn_bh57_11_11 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_11_11 :  std_logic_vector(2 downto 0);
signal heap_bh57_w10_11 :  std_logic;
signal heap_bh57_w11_10 :  std_logic;
signal heap_bh57_w12_7 :  std_logic;
signal CompressorIn_bh57_12_12 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_12_12 :  std_logic_vector(2 downto 0);
signal heap_bh57_w11_11 :  std_logic;
signal heap_bh57_w12_8 :  std_logic;
signal heap_bh57_w13_7 :  std_logic;
signal CompressorIn_bh57_13_13 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_13_13 :  std_logic_vector(2 downto 0);
signal heap_bh57_w12_9 :  std_logic;
signal heap_bh57_w13_8 :  std_logic;
signal heap_bh57_w14_7 :  std_logic;
signal CompressorIn_bh57_14_14 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_14_14 :  std_logic_vector(2 downto 0);
signal heap_bh57_w13_9 :  std_logic;
signal heap_bh57_w14_8 :  std_logic;
signal heap_bh57_w15_5 :  std_logic;
signal CompressorIn_bh57_15_15 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_15_15 :  std_logic_vector(2 downto 0);
signal heap_bh57_w14_9 :  std_logic;
signal heap_bh57_w15_6 :  std_logic;
signal heap_bh57_w16_5 :  std_logic;
signal CompressorIn_bh57_16_16 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_16_17 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_16_16 :  std_logic_vector(2 downto 0);
signal heap_bh57_w5_15 :  std_logic;
signal heap_bh57_w6_15 :  std_logic;
signal heap_bh57_w7_14 :  std_logic;
signal CompressorIn_bh57_17_18 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_17_19 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_17_17 :  std_logic_vector(2 downto 0);
signal heap_bh57_w6_16 :  std_logic;
signal heap_bh57_w7_15 :  std_logic;
signal heap_bh57_w8_14 :  std_logic;
signal CompressorIn_bh57_18_20 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_18_21 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_18_18 :  std_logic_vector(2 downto 0);
signal heap_bh57_w7_16 :  std_logic;
signal heap_bh57_w8_15 :  std_logic;
signal heap_bh57_w9_12 :  std_logic;
signal CompressorIn_bh57_19_22 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_19_23 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_19_19 :  std_logic_vector(2 downto 0);
signal heap_bh57_w8_16 :  std_logic;
signal heap_bh57_w9_13 :  std_logic;
signal heap_bh57_w10_12 :  std_logic;
signal CompressorIn_bh57_20_24 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_20_25 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_20_20 :  std_logic_vector(2 downto 0);
signal heap_bh57_w15_7 :  std_logic;
signal heap_bh57_w16_6 :  std_logic;
signal heap_bh57_w17_5 :  std_logic;
signal CompressorIn_bh57_21_26 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_21_27 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_21_21 :  std_logic_vector(2 downto 0);
signal heap_bh57_w16_7 :  std_logic;
signal heap_bh57_w17_6 :  std_logic;
signal heap_bh57_w18_3 :  std_logic;
signal CompressorIn_bh57_22_28 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_22_29 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_22_22 :  std_logic_vector(2 downto 0);
signal heap_bh57_w17_7 :  std_logic;
signal heap_bh57_w18_4 :  std_logic;
signal heap_bh57_w19_3 :  std_logic;
signal CompressorIn_bh57_23_30 :  std_logic_vector(3 downto 0);
signal CompressorOut_bh57_23_23 :  std_logic_vector(2 downto 0);
signal heap_bh57_w3_13 :  std_logic;
signal heap_bh57_w4_16 :  std_logic;
signal heap_bh57_w5_16 :  std_logic;
signal CompressorIn_bh57_24_31 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_24_32 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_24_24 :  std_logic_vector(2 downto 0);
signal heap_bh57_w1_11 :  std_logic;
signal heap_bh57_w2_12 :  std_logic;
signal heap_bh57_w3_14 :  std_logic;
signal CompressorIn_bh57_25_33 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_25_34 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_25_25 :  std_logic_vector(2 downto 0);
signal heap_bh57_w10_13 :  std_logic;
signal heap_bh57_w11_12 :  std_logic;
signal heap_bh57_w12_10 :  std_logic;
signal CompressorIn_bh57_26_35 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_26_36 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_26_26 :  std_logic_vector(2 downto 0);
signal heap_bh57_w19_4 :  std_logic;
signal heap_bh57_w20_3 :  std_logic;
signal heap_bh57_w21_1 :  std_logic;
signal CompressorIn_bh57_27_37 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_27_27 :  std_logic_vector(2 downto 0);
signal heap_bh57_w5_17, heap_bh57_w5_17_d1 :  std_logic;
signal heap_bh57_w6_17 :  std_logic;
signal heap_bh57_w7_17, heap_bh57_w7_17_d1 :  std_logic;
signal CompressorIn_bh57_28_38 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_28_28 :  std_logic_vector(2 downto 0);
signal heap_bh57_w6_18 :  std_logic;
signal heap_bh57_w7_18 :  std_logic;
signal heap_bh57_w8_17 :  std_logic;
signal CompressorIn_bh57_29_39 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_29_29 :  std_logic_vector(2 downto 0);
signal heap_bh57_w7_19 :  std_logic;
signal heap_bh57_w8_18 :  std_logic;
signal heap_bh57_w9_14 :  std_logic;
signal CompressorIn_bh57_30_40 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_30_30 :  std_logic_vector(2 downto 0);
signal heap_bh57_w8_19 :  std_logic;
signal heap_bh57_w9_15 :  std_logic;
signal heap_bh57_w10_14 :  std_logic;
signal CompressorIn_bh57_31_41 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh57_31_31 :  std_logic_vector(2 downto 0);
signal heap_bh57_w9_16 :  std_logic;
signal heap_bh57_w10_15 :  std_logic;
signal heap_bh57_w11_13 :  std_logic;
signal CompressorIn_bh57_32_42 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_32_43 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_32_32 :  std_logic_vector(2 downto 0);
signal heap_bh57_w2_13 :  std_logic;
signal heap_bh57_w3_15 :  std_logic;
signal heap_bh57_w4_17 :  std_logic;
signal CompressorIn_bh57_33_44 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_33_45 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_33_33 :  std_logic_vector(2 downto 0);
signal heap_bh57_w3_16 :  std_logic;
signal heap_bh57_w4_18 :  std_logic;
signal heap_bh57_w5_18 :  std_logic;
signal CompressorIn_bh57_34_46 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_34_47 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_34_34 :  std_logic_vector(2 downto 0);
signal heap_bh57_w4_19 :  std_logic;
signal heap_bh57_w5_19 :  std_logic;
signal heap_bh57_w6_19 :  std_logic;
signal CompressorIn_bh57_35_48 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_35_49 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_35_35 :  std_logic_vector(2 downto 0);
signal heap_bh57_w10_16 :  std_logic;
signal heap_bh57_w11_14 :  std_logic;
signal heap_bh57_w12_11 :  std_logic;
signal CompressorIn_bh57_36_50 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_36_51 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_36_36 :  std_logic_vector(2 downto 0);
signal heap_bh57_w11_15 :  std_logic;
signal heap_bh57_w12_12 :  std_logic;
signal heap_bh57_w13_10 :  std_logic;
signal CompressorIn_bh57_37_52 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_37_53 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_37_37 :  std_logic_vector(2 downto 0);
signal heap_bh57_w12_13 :  std_logic;
signal heap_bh57_w13_11 :  std_logic;
signal heap_bh57_w14_10 :  std_logic;
signal CompressorIn_bh57_38_54 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_38_55 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_38_38 :  std_logic_vector(2 downto 0);
signal heap_bh57_w14_11 :  std_logic;
signal heap_bh57_w15_8 :  std_logic;
signal heap_bh57_w16_8 :  std_logic;
signal CompressorIn_bh57_39_56 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_39_57 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_39_39 :  std_logic_vector(2 downto 0);
signal heap_bh57_w18_5 :  std_logic;
signal heap_bh57_w19_5 :  std_logic;
signal heap_bh57_w20_4 :  std_logic;
signal CompressorIn_bh57_40_58 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_40_59 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_40_40 :  std_logic_vector(2 downto 0);
signal heap_bh57_w0_9 :  std_logic;
signal heap_bh57_w1_12, heap_bh57_w1_12_d1 :  std_logic;
signal heap_bh57_w2_14 :  std_logic;
signal CompressorIn_bh57_41_60 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_41_61 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_41_41 :  std_logic_vector(2 downto 0);
signal heap_bh57_w15_9 :  std_logic;
signal heap_bh57_w16_9 :  std_logic;
signal heap_bh57_w17_8 :  std_logic;
signal CompressorIn_bh57_42_62 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh57_42_42 :  std_logic_vector(1 downto 0);
signal heap_bh57_w13_12 :  std_logic;
signal heap_bh57_w14_12 :  std_logic;
signal CompressorIn_bh57_43_63 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh57_43_43 :  std_logic_vector(1 downto 0);
signal heap_bh57_w17_9 :  std_logic;
signal heap_bh57_w18_6 :  std_logic;
signal tempR_bh57_0, tempR_bh57_0_d1 :  std_logic;
signal CompressorIn_bh57_44_64 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh57_44_65 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh57_44_44 :  std_logic_vector(2 downto 0);
signal heap_bh57_w9_17, heap_bh57_w9_17_d1 :  std_logic;
signal heap_bh57_w10_17, heap_bh57_w10_17_d1 :  std_logic;
signal heap_bh57_w11_16 :  std_logic;
signal CompressorIn_bh57_45_66 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_45_67 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_45_45 :  std_logic_vector(2 downto 0);
signal heap_bh57_w2_15, heap_bh57_w2_15_d1 :  std_logic;
signal heap_bh57_w3_17, heap_bh57_w3_17_d1 :  std_logic;
signal heap_bh57_w4_20, heap_bh57_w4_20_d1 :  std_logic;
signal CompressorIn_bh57_46_68 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_46_69 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_46_46 :  std_logic_vector(2 downto 0);
signal heap_bh57_w4_21, heap_bh57_w4_21_d1 :  std_logic;
signal heap_bh57_w5_20, heap_bh57_w5_20_d1 :  std_logic;
signal heap_bh57_w6_20, heap_bh57_w6_20_d1 :  std_logic;
signal CompressorIn_bh57_47_70 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_47_71 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_47_47 :  std_logic_vector(2 downto 0);
signal heap_bh57_w6_21, heap_bh57_w6_21_d1 :  std_logic;
signal heap_bh57_w7_20, heap_bh57_w7_20_d1 :  std_logic;
signal heap_bh57_w8_20, heap_bh57_w8_20_d1 :  std_logic;
signal CompressorIn_bh57_48_72 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_48_73 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_48_48 :  std_logic_vector(2 downto 0);
signal heap_bh57_w10_18, heap_bh57_w10_18_d1 :  std_logic;
signal heap_bh57_w11_17 :  std_logic;
signal heap_bh57_w12_14 :  std_logic;
signal CompressorIn_bh57_49_74 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_49_75 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_49_49 :  std_logic_vector(2 downto 0);
signal heap_bh57_w12_15 :  std_logic;
signal heap_bh57_w13_13 :  std_logic;
signal heap_bh57_w14_13 :  std_logic;
signal CompressorIn_bh57_50_76 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_50_77 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_50_50 :  std_logic_vector(2 downto 0);
signal heap_bh57_w14_14 :  std_logic;
signal heap_bh57_w15_10, heap_bh57_w15_10_d1 :  std_logic;
signal heap_bh57_w16_10, heap_bh57_w16_10_d1 :  std_logic;
signal CompressorIn_bh57_51_78 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_51_79 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_51_51 :  std_logic_vector(2 downto 0);
signal heap_bh57_w16_11, heap_bh57_w16_11_d1 :  std_logic;
signal heap_bh57_w17_10, heap_bh57_w17_10_d1 :  std_logic;
signal heap_bh57_w18_7 :  std_logic;
signal CompressorIn_bh57_52_80 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_52_81 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_52_52 :  std_logic_vector(2 downto 0);
signal heap_bh57_w20_5, heap_bh57_w20_5_d1 :  std_logic;
signal heap_bh57_w21_2, heap_bh57_w21_2_d1 :  std_logic;
signal heap_bh57_w22_1, heap_bh57_w22_1_d1 :  std_logic;
signal CompressorIn_bh57_53_82 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh57_53_53 :  std_logic_vector(1 downto 0);
signal heap_bh57_w8_21, heap_bh57_w8_21_d1 :  std_logic;
signal heap_bh57_w9_18, heap_bh57_w9_18_d1 :  std_logic;
signal CompressorIn_bh57_54_83 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_54_84 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_54_54 :  std_logic_vector(2 downto 0);
signal heap_bh57_w11_18, heap_bh57_w11_18_d1 :  std_logic;
signal heap_bh57_w12_16, heap_bh57_w12_16_d1 :  std_logic;
signal heap_bh57_w13_14 :  std_logic;
signal CompressorIn_bh57_55_85 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_55_86 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_55_55 :  std_logic_vector(2 downto 0);
signal heap_bh57_w18_8, heap_bh57_w18_8_d1 :  std_logic;
signal heap_bh57_w19_6, heap_bh57_w19_6_d1 :  std_logic;
signal heap_bh57_w20_6, heap_bh57_w20_6_d1 :  std_logic;
signal CompressorIn_bh57_56_87 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh57_56_88 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh57_56_56 :  std_logic_vector(2 downto 0);
signal heap_bh57_w13_15, heap_bh57_w13_15_d1 :  std_logic;
signal heap_bh57_w14_15, heap_bh57_w14_15_d1 :  std_logic;
signal heap_bh57_w15_11, heap_bh57_w15_11_d1 :  std_logic;
signal finalAdderIn0_bh57 :  std_logic_vector(23 downto 0);
signal finalAdderIn1_bh57 :  std_logic_vector(23 downto 0);
signal finalAdderCin_bh57 :  std_logic;
signal finalAdderOut_bh57 :  std_logic_vector(23 downto 0);
signal CompressionResult57 :  std_logic_vector(24 downto 0);
attribute rom_extract: string;
attribute rom_style: string;
attribute rom_extract of SmallMultTableP3x3r6XuYu: component is "yes";
attribute rom_style of SmallMultTableP3x3r6XuYu: component is "distributed";
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            heap_bh57_w22_0_d1 <=  heap_bh57_w22_0;
            heap_bh57_w23_0_d1 <=  heap_bh57_w23_0;
            heap_bh57_w1_9_d1 <=  heap_bh57_w1_9;
            heap_bh57_w5_17_d1 <=  heap_bh57_w5_17;
            heap_bh57_w7_17_d1 <=  heap_bh57_w7_17;
            heap_bh57_w1_12_d1 <=  heap_bh57_w1_12;
            tempR_bh57_0_d1 <=  tempR_bh57_0;
            heap_bh57_w9_17_d1 <=  heap_bh57_w9_17;
            heap_bh57_w10_17_d1 <=  heap_bh57_w10_17;
            heap_bh57_w2_15_d1 <=  heap_bh57_w2_15;
            heap_bh57_w3_17_d1 <=  heap_bh57_w3_17;
            heap_bh57_w4_20_d1 <=  heap_bh57_w4_20;
            heap_bh57_w4_21_d1 <=  heap_bh57_w4_21;
            heap_bh57_w5_20_d1 <=  heap_bh57_w5_20;
            heap_bh57_w6_20_d1 <=  heap_bh57_w6_20;
            heap_bh57_w6_21_d1 <=  heap_bh57_w6_21;
            heap_bh57_w7_20_d1 <=  heap_bh57_w7_20;
            heap_bh57_w8_20_d1 <=  heap_bh57_w8_20;
            heap_bh57_w10_18_d1 <=  heap_bh57_w10_18;
            heap_bh57_w15_10_d1 <=  heap_bh57_w15_10;
            heap_bh57_w16_10_d1 <=  heap_bh57_w16_10;
            heap_bh57_w16_11_d1 <=  heap_bh57_w16_11;
            heap_bh57_w17_10_d1 <=  heap_bh57_w17_10;
            heap_bh57_w20_5_d1 <=  heap_bh57_w20_5;
            heap_bh57_w21_2_d1 <=  heap_bh57_w21_2;
            heap_bh57_w22_1_d1 <=  heap_bh57_w22_1;
            heap_bh57_w8_21_d1 <=  heap_bh57_w8_21;
            heap_bh57_w9_18_d1 <=  heap_bh57_w9_18;
            heap_bh57_w11_18_d1 <=  heap_bh57_w11_18;
            heap_bh57_w12_16_d1 <=  heap_bh57_w12_16;
            heap_bh57_w18_8_d1 <=  heap_bh57_w18_8;
            heap_bh57_w19_6_d1 <=  heap_bh57_w19_6;
            heap_bh57_w20_6_d1 <=  heap_bh57_w20_6;
            heap_bh57_w13_15_d1 <=  heap_bh57_w13_15;
            heap_bh57_w14_15_d1 <=  heap_bh57_w14_15;
            heap_bh57_w15_11_d1 <=  heap_bh57_w15_11;
         end if;
      end process;
   XX_m56 <= Y ;
   YY_m56 <= X ;
   -- code generated by IntMultiplier::buildHeapLogicOnly()
   -- buildheaplogiconly called for lsbX=0 lsbY=0 msbX=18 msbY=17
   Xp_m56b58 <= XX_m56(17 downto 0) & "";
   Yp_m56b58 <= YY_m56(16 downto 0) & "0";
   x_m56b58_0 <= Xp_m56b58(2 downto 0);
   x_m56b58_1 <= Xp_m56b58(5 downto 3);
   x_m56b58_2 <= Xp_m56b58(8 downto 6);
   x_m56b58_3 <= Xp_m56b58(11 downto 9);
   x_m56b58_4 <= Xp_m56b58(14 downto 12);
   x_m56b58_5 <= Xp_m56b58(17 downto 15);
   y_m56b58_0 <= Yp_m56b58(2 downto 0);
   y_m56b58_1 <= Yp_m56b58(5 downto 3);
   y_m56b58_2 <= Yp_m56b58(8 downto 6);
   y_m56b58_3 <= Yp_m56b58(11 downto 9);
   y_m56b58_4 <= Yp_m56b58(14 downto 12);
   y_m56b58_5 <= Yp_m56b58(17 downto 15);
   ----------------Synchro barrier, entering cycle 0----------------
   -- Partial product row number 0
   Y0X3_58_m56 <= y_m56b58_0 & x_m56b58_3;
   PP_m56_58X3Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X3_58_m56,
                 Y => PP58X3Y0_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w0_0 <= PP58X3Y0_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w1_0 <= PP58X3Y0_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w2_0 <= PP58X3Y0_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y0X4_58_m56 <= y_m56b58_0 & x_m56b58_4;
   PP_m56_58X4Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X4_58_m56,
                 Y => PP58X4Y0_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w1_1 <= PP58X4Y0_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w2_1 <= PP58X4Y0_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w3_0 <= PP58X4Y0_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_0 <= PP58X4Y0_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_0 <= PP58X4Y0_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y0X5_58_m56 <= y_m56b58_0 & x_m56b58_5;
   PP_m56_58X5Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X5_58_m56,
                 Y => PP58X5Y0_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w4_1 <= PP58X5Y0_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_1 <= PP58X5Y0_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w6_0 <= PP58X5Y0_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_0 <= PP58X5Y0_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_0 <= PP58X5Y0_m56(5); -- cycle= 0 cp= 5.7432e-10

   -- Partial product row number 1
   Y1X2_58_m56 <= y_m56b58_1 & x_m56b58_2;
   PP_m56_58X2Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X2_58_m56,
                 Y => PP58X2Y1_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w0_1 <= PP58X2Y1_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w1_2 <= PP58X2Y1_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w2_2 <= PP58X2Y1_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y1X3_58_m56 <= y_m56b58_1 & x_m56b58_3;
   PP_m56_58X3Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X3_58_m56,
                 Y => PP58X3Y1_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w0_2 <= PP58X3Y1_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w1_3 <= PP58X3Y1_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w2_3 <= PP58X3Y1_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w3_1 <= PP58X3Y1_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_2 <= PP58X3Y1_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_2 <= PP58X3Y1_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y1X4_58_m56 <= y_m56b58_1 & x_m56b58_4;
   PP_m56_58X4Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X4_58_m56,
                 Y => PP58X4Y1_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w3_2 <= PP58X4Y1_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_3 <= PP58X4Y1_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_3 <= PP58X4Y1_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w6_1 <= PP58X4Y1_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_1 <= PP58X4Y1_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_1 <= PP58X4Y1_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y1X5_58_m56 <= y_m56b58_1 & x_m56b58_5;
   PP_m56_58X5Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X5_58_m56,
                 Y => PP58X5Y1_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w6_2 <= PP58X5Y1_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_2 <= PP58X5Y1_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_2 <= PP58X5Y1_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w9_0 <= PP58X5Y1_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w10_0 <= PP58X5Y1_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w11_0 <= PP58X5Y1_m56(5); -- cycle= 0 cp= 5.7432e-10

   -- Partial product row number 2
   Y2X1_58_m56 <= y_m56b58_2 & x_m56b58_1;
   PP_m56_58X1Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X1_58_m56,
                 Y => PP58X1Y2_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w0_3 <= PP58X1Y2_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w1_4 <= PP58X1Y2_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w2_4 <= PP58X1Y2_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y2X2_58_m56 <= y_m56b58_2 & x_m56b58_2;
   PP_m56_58X2Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X2_58_m56,
                 Y => PP58X2Y2_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w0_4 <= PP58X2Y2_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w1_5 <= PP58X2Y2_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w2_5 <= PP58X2Y2_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w3_3 <= PP58X2Y2_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_4 <= PP58X2Y2_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_4 <= PP58X2Y2_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y2X3_58_m56 <= y_m56b58_2 & x_m56b58_3;
   PP_m56_58X3Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X3_58_m56,
                 Y => PP58X3Y2_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w3_4 <= PP58X3Y2_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_5 <= PP58X3Y2_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_5 <= PP58X3Y2_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w6_3 <= PP58X3Y2_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_3 <= PP58X3Y2_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_3 <= PP58X3Y2_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y2X4_58_m56 <= y_m56b58_2 & x_m56b58_4;
   PP_m56_58X4Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X4_58_m56,
                 Y => PP58X4Y2_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w6_4 <= PP58X4Y2_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_4 <= PP58X4Y2_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_4 <= PP58X4Y2_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w9_1 <= PP58X4Y2_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w10_1 <= PP58X4Y2_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w11_1 <= PP58X4Y2_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y2X5_58_m56 <= y_m56b58_2 & x_m56b58_5;
   PP_m56_58X5Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X5_58_m56,
                 Y => PP58X5Y2_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w9_2 <= PP58X5Y2_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w10_2 <= PP58X5Y2_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w11_2 <= PP58X5Y2_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w12_0 <= PP58X5Y2_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w13_0 <= PP58X5Y2_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w14_0 <= PP58X5Y2_m56(5); -- cycle= 0 cp= 5.7432e-10

   -- Partial product row number 3
   Y3X0_58_m56 <= y_m56b58_3 & x_m56b58_0;
   PP_m56_58X0Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X0_58_m56,
                 Y => PP58X0Y3_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w0_5 <= PP58X0Y3_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w1_6 <= PP58X0Y3_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w2_6 <= PP58X0Y3_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y3X1_58_m56 <= y_m56b58_3 & x_m56b58_1;
   PP_m56_58X1Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X1_58_m56,
                 Y => PP58X1Y3_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w0_6 <= PP58X1Y3_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w1_7 <= PP58X1Y3_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w2_7 <= PP58X1Y3_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w3_5 <= PP58X1Y3_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_6 <= PP58X1Y3_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_6 <= PP58X1Y3_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y3X2_58_m56 <= y_m56b58_3 & x_m56b58_2;
   PP_m56_58X2Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X2_58_m56,
                 Y => PP58X2Y3_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w3_6 <= PP58X2Y3_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_7 <= PP58X2Y3_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_7 <= PP58X2Y3_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w6_5 <= PP58X2Y3_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_5 <= PP58X2Y3_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_5 <= PP58X2Y3_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y3X3_58_m56 <= y_m56b58_3 & x_m56b58_3;
   PP_m56_58X3Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X3_58_m56,
                 Y => PP58X3Y3_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w6_6 <= PP58X3Y3_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_6 <= PP58X3Y3_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_6 <= PP58X3Y3_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w9_3 <= PP58X3Y3_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w10_3 <= PP58X3Y3_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w11_3 <= PP58X3Y3_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y3X4_58_m56 <= y_m56b58_3 & x_m56b58_4;
   PP_m56_58X4Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X4_58_m56,
                 Y => PP58X4Y3_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w9_4 <= PP58X4Y3_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w10_4 <= PP58X4Y3_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w11_4 <= PP58X4Y3_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w12_1 <= PP58X4Y3_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w13_1 <= PP58X4Y3_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w14_1 <= PP58X4Y3_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y3X5_58_m56 <= y_m56b58_3 & x_m56b58_5;
   PP_m56_58X5Y3_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y3X5_58_m56,
                 Y => PP58X5Y3_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w12_2 <= PP58X5Y3_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w13_2 <= PP58X5Y3_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w14_2 <= PP58X5Y3_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w15_0 <= PP58X5Y3_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w16_0 <= PP58X5Y3_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w17_0 <= PP58X5Y3_m56(5); -- cycle= 0 cp= 5.7432e-10

   -- Partial product row number 4
   Y4X0_58_m56 <= y_m56b58_4 & x_m56b58_0;
   PP_m56_58X0Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X0_58_m56,
                 Y => PP58X0Y4_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w0_7 <= PP58X0Y4_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w1_8 <= PP58X0Y4_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w2_8 <= PP58X0Y4_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w3_7 <= PP58X0Y4_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_8 <= PP58X0Y4_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_8 <= PP58X0Y4_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y4X1_58_m56 <= y_m56b58_4 & x_m56b58_1;
   PP_m56_58X1Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X1_58_m56,
                 Y => PP58X1Y4_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w3_8 <= PP58X1Y4_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_9 <= PP58X1Y4_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_9 <= PP58X1Y4_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w6_7 <= PP58X1Y4_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_7 <= PP58X1Y4_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_7 <= PP58X1Y4_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y4X2_58_m56 <= y_m56b58_4 & x_m56b58_2;
   PP_m56_58X2Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X2_58_m56,
                 Y => PP58X2Y4_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w6_8 <= PP58X2Y4_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_8 <= PP58X2Y4_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_8 <= PP58X2Y4_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w9_5 <= PP58X2Y4_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w10_5 <= PP58X2Y4_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w11_5 <= PP58X2Y4_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y4X3_58_m56 <= y_m56b58_4 & x_m56b58_3;
   PP_m56_58X3Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X3_58_m56,
                 Y => PP58X3Y4_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w9_6 <= PP58X3Y4_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w10_6 <= PP58X3Y4_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w11_6 <= PP58X3Y4_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w12_3 <= PP58X3Y4_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w13_3 <= PP58X3Y4_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w14_3 <= PP58X3Y4_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y4X4_58_m56 <= y_m56b58_4 & x_m56b58_4;
   PP_m56_58X4Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X4_58_m56,
                 Y => PP58X4Y4_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w12_4 <= PP58X4Y4_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w13_4 <= PP58X4Y4_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w14_4 <= PP58X4Y4_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w15_1 <= PP58X4Y4_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w16_1 <= PP58X4Y4_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w17_1 <= PP58X4Y4_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y4X5_58_m56 <= y_m56b58_4 & x_m56b58_5;
   PP_m56_58X5Y4_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y4X5_58_m56,
                 Y => PP58X5Y4_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w15_2 <= PP58X5Y4_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w16_2 <= PP58X5Y4_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w17_2 <= PP58X5Y4_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w18_0 <= PP58X5Y4_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w19_0 <= PP58X5Y4_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w20_0 <= PP58X5Y4_m56(5); -- cycle= 0 cp= 5.7432e-10

   -- Partial product row number 5
   Y5X0_58_m56 <= y_m56b58_5 & x_m56b58_0;
   PP_m56_58X0Y5_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y5X0_58_m56,
                 Y => PP58X0Y5_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w3_9 <= PP58X0Y5_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w4_10 <= PP58X0Y5_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w5_10 <= PP58X0Y5_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w6_9 <= PP58X0Y5_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_9 <= PP58X0Y5_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_9 <= PP58X0Y5_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y5X1_58_m56 <= y_m56b58_5 & x_m56b58_1;
   PP_m56_58X1Y5_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y5X1_58_m56,
                 Y => PP58X1Y5_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w6_10 <= PP58X1Y5_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w7_10 <= PP58X1Y5_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w8_10 <= PP58X1Y5_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w9_7 <= PP58X1Y5_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w10_7 <= PP58X1Y5_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w11_7 <= PP58X1Y5_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y5X2_58_m56 <= y_m56b58_5 & x_m56b58_2;
   PP_m56_58X2Y5_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y5X2_58_m56,
                 Y => PP58X2Y5_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w9_8 <= PP58X2Y5_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w10_8 <= PP58X2Y5_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w11_8 <= PP58X2Y5_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w12_5 <= PP58X2Y5_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w13_5 <= PP58X2Y5_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w14_5 <= PP58X2Y5_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y5X3_58_m56 <= y_m56b58_5 & x_m56b58_3;
   PP_m56_58X3Y5_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y5X3_58_m56,
                 Y => PP58X3Y5_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w12_6 <= PP58X3Y5_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w13_6 <= PP58X3Y5_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w14_6 <= PP58X3Y5_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w15_3 <= PP58X3Y5_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w16_3 <= PP58X3Y5_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w17_3 <= PP58X3Y5_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y5X4_58_m56 <= y_m56b58_5 & x_m56b58_4;
   PP_m56_58X4Y5_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y5X4_58_m56,
                 Y => PP58X4Y5_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w15_4 <= PP58X4Y5_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w16_4 <= PP58X4Y5_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w17_4 <= PP58X4Y5_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w18_1 <= PP58X4Y5_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w19_1 <= PP58X4Y5_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w20_1 <= PP58X4Y5_m56(5); -- cycle= 0 cp= 5.7432e-10

   Y5X5_58_m56 <= y_m56b58_5 & x_m56b58_5;
   PP_m56_58X5Y5_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y5X5_58_m56,
                 Y => PP58X5Y5_m56);
   -- Adding the relevant bits to the heap of bits
   heap_bh57_w18_2 <= PP58X5Y5_m56(0); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w19_2 <= PP58X5Y5_m56(1); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w20_2 <= PP58X5Y5_m56(2); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w21_0 <= PP58X5Y5_m56(3); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w22_0 <= PP58X5Y5_m56(4); -- cycle= 0 cp= 5.7432e-10
   heap_bh57_w23_0 <= PP58X5Y5_m56(5); -- cycle= 0 cp= 5.7432e-10


   -- Beginning of code generated by BitHeap::generateCompressorVHDL
   -- code generated by BitHeap::generateSupertileVHDL()
   ----------------Synchro barrier, entering cycle 0----------------

   -- Adding the constant bits
   heap_bh57_w4_11 <= '1'; -- cycle= 0 cp= 0

   ----------------Synchro barrier, entering cycle 0----------------

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_0_0 <= heap_bh57_w0_7 & heap_bh57_w0_6 & heap_bh57_w0_5 & heap_bh57_w0_4 & heap_bh57_w0_3 & heap_bh57_w0_2;
   Compressor_bh57_0: Compressor_6_3
      port map ( R => CompressorOut_bh57_0_0   ,
                 X0 => CompressorIn_bh57_0_0);
   heap_bh57_w0_8 <= CompressorOut_bh57_0_0(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w1_9 <= CompressorOut_bh57_0_0(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w2_9 <= CompressorOut_bh57_0_0(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_1_1 <= heap_bh57_w1_8 & heap_bh57_w1_7 & heap_bh57_w1_6 & heap_bh57_w1_5 & heap_bh57_w1_4 & heap_bh57_w1_3;
   Compressor_bh57_1: Compressor_6_3
      port map ( R => CompressorOut_bh57_1_1   ,
                 X0 => CompressorIn_bh57_1_1);
   heap_bh57_w1_10 <= CompressorOut_bh57_1_1(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w2_10 <= CompressorOut_bh57_1_1(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w3_10 <= CompressorOut_bh57_1_1(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_2_2 <= heap_bh57_w2_8 & heap_bh57_w2_7 & heap_bh57_w2_6 & heap_bh57_w2_5 & heap_bh57_w2_4 & heap_bh57_w2_3;
   Compressor_bh57_2: Compressor_6_3
      port map ( R => CompressorOut_bh57_2_2   ,
                 X0 => CompressorIn_bh57_2_2);
   heap_bh57_w2_11 <= CompressorOut_bh57_2_2(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w3_11 <= CompressorOut_bh57_2_2(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w4_12 <= CompressorOut_bh57_2_2(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_3_3 <= heap_bh57_w3_9 & heap_bh57_w3_8 & heap_bh57_w3_7 & heap_bh57_w3_6 & heap_bh57_w3_5 & heap_bh57_w3_4;
   Compressor_bh57_3: Compressor_6_3
      port map ( R => CompressorOut_bh57_3_3   ,
                 X0 => CompressorIn_bh57_3_3);
   heap_bh57_w3_12 <= CompressorOut_bh57_3_3(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w4_13 <= CompressorOut_bh57_3_3(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w5_11 <= CompressorOut_bh57_3_3(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_4_4 <= heap_bh57_w4_11 & heap_bh57_w4_10 & heap_bh57_w4_9 & heap_bh57_w4_8 & heap_bh57_w4_7 & heap_bh57_w4_6;
   Compressor_bh57_4: Compressor_6_3
      port map ( R => CompressorOut_bh57_4_4   ,
                 X0 => CompressorIn_bh57_4_4);
   heap_bh57_w4_14 <= CompressorOut_bh57_4_4(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w5_12 <= CompressorOut_bh57_4_4(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w6_11 <= CompressorOut_bh57_4_4(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_5_5 <= heap_bh57_w4_5 & heap_bh57_w4_4 & heap_bh57_w4_3 & heap_bh57_w4_2 & heap_bh57_w4_1 & heap_bh57_w4_0;
   Compressor_bh57_5: Compressor_6_3
      port map ( R => CompressorOut_bh57_5_5   ,
                 X0 => CompressorIn_bh57_5_5);
   heap_bh57_w4_15 <= CompressorOut_bh57_5_5(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w5_13 <= CompressorOut_bh57_5_5(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w6_12 <= CompressorOut_bh57_5_5(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_6_6 <= heap_bh57_w5_10 & heap_bh57_w5_9 & heap_bh57_w5_8 & heap_bh57_w5_7 & heap_bh57_w5_6 & heap_bh57_w5_5;
   Compressor_bh57_6: Compressor_6_3
      port map ( R => CompressorOut_bh57_6_6   ,
                 X0 => CompressorIn_bh57_6_6);
   heap_bh57_w5_14 <= CompressorOut_bh57_6_6(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w6_13 <= CompressorOut_bh57_6_6(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w7_11 <= CompressorOut_bh57_6_6(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_7_7 <= heap_bh57_w6_10 & heap_bh57_w6_9 & heap_bh57_w6_8 & heap_bh57_w6_7 & heap_bh57_w6_6 & heap_bh57_w6_5;
   Compressor_bh57_7: Compressor_6_3
      port map ( R => CompressorOut_bh57_7_7   ,
                 X0 => CompressorIn_bh57_7_7);
   heap_bh57_w6_14 <= CompressorOut_bh57_7_7(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w7_12 <= CompressorOut_bh57_7_7(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w8_11 <= CompressorOut_bh57_7_7(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_8_8 <= heap_bh57_w7_10 & heap_bh57_w7_9 & heap_bh57_w7_8 & heap_bh57_w7_7 & heap_bh57_w7_6 & heap_bh57_w7_5;
   Compressor_bh57_8: Compressor_6_3
      port map ( R => CompressorOut_bh57_8_8   ,
                 X0 => CompressorIn_bh57_8_8);
   heap_bh57_w7_13 <= CompressorOut_bh57_8_8(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w8_12 <= CompressorOut_bh57_8_8(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w9_9 <= CompressorOut_bh57_8_8(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_9_9 <= heap_bh57_w8_10 & heap_bh57_w8_9 & heap_bh57_w8_8 & heap_bh57_w8_7 & heap_bh57_w8_6 & heap_bh57_w8_5;
   Compressor_bh57_9: Compressor_6_3
      port map ( R => CompressorOut_bh57_9_9   ,
                 X0 => CompressorIn_bh57_9_9);
   heap_bh57_w8_13 <= CompressorOut_bh57_9_9(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w9_10 <= CompressorOut_bh57_9_9(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w10_9 <= CompressorOut_bh57_9_9(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_10_10 <= heap_bh57_w9_8 & heap_bh57_w9_7 & heap_bh57_w9_6 & heap_bh57_w9_5 & heap_bh57_w9_4 & heap_bh57_w9_3;
   Compressor_bh57_10: Compressor_6_3
      port map ( R => CompressorOut_bh57_10_10   ,
                 X0 => CompressorIn_bh57_10_10);
   heap_bh57_w9_11 <= CompressorOut_bh57_10_10(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w10_10 <= CompressorOut_bh57_10_10(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w11_9 <= CompressorOut_bh57_10_10(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_11_11 <= heap_bh57_w10_8 & heap_bh57_w10_7 & heap_bh57_w10_6 & heap_bh57_w10_5 & heap_bh57_w10_4 & heap_bh57_w10_3;
   Compressor_bh57_11: Compressor_6_3
      port map ( R => CompressorOut_bh57_11_11   ,
                 X0 => CompressorIn_bh57_11_11);
   heap_bh57_w10_11 <= CompressorOut_bh57_11_11(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w11_10 <= CompressorOut_bh57_11_11(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w12_7 <= CompressorOut_bh57_11_11(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_12_12 <= heap_bh57_w11_8 & heap_bh57_w11_7 & heap_bh57_w11_6 & heap_bh57_w11_5 & heap_bh57_w11_4 & heap_bh57_w11_3;
   Compressor_bh57_12: Compressor_6_3
      port map ( R => CompressorOut_bh57_12_12   ,
                 X0 => CompressorIn_bh57_12_12);
   heap_bh57_w11_11 <= CompressorOut_bh57_12_12(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w12_8 <= CompressorOut_bh57_12_12(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w13_7 <= CompressorOut_bh57_12_12(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_13_13 <= heap_bh57_w12_6 & heap_bh57_w12_5 & heap_bh57_w12_4 & heap_bh57_w12_3 & heap_bh57_w12_2 & heap_bh57_w12_1;
   Compressor_bh57_13: Compressor_6_3
      port map ( R => CompressorOut_bh57_13_13   ,
                 X0 => CompressorIn_bh57_13_13);
   heap_bh57_w12_9 <= CompressorOut_bh57_13_13(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w13_8 <= CompressorOut_bh57_13_13(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w14_7 <= CompressorOut_bh57_13_13(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_14_14 <= heap_bh57_w13_6 & heap_bh57_w13_5 & heap_bh57_w13_4 & heap_bh57_w13_3 & heap_bh57_w13_2 & heap_bh57_w13_1;
   Compressor_bh57_14: Compressor_6_3
      port map ( R => CompressorOut_bh57_14_14   ,
                 X0 => CompressorIn_bh57_14_14);
   heap_bh57_w13_9 <= CompressorOut_bh57_14_14(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w14_8 <= CompressorOut_bh57_14_14(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w15_5 <= CompressorOut_bh57_14_14(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_15_15 <= heap_bh57_w14_6 & heap_bh57_w14_5 & heap_bh57_w14_4 & heap_bh57_w14_3 & heap_bh57_w14_2 & heap_bh57_w14_1;
   Compressor_bh57_15: Compressor_6_3
      port map ( R => CompressorOut_bh57_15_15   ,
                 X0 => CompressorIn_bh57_15_15);
   heap_bh57_w14_9 <= CompressorOut_bh57_15_15(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w15_6 <= CompressorOut_bh57_15_15(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w16_5 <= CompressorOut_bh57_15_15(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_16_16 <= heap_bh57_w5_4 & heap_bh57_w5_3 & heap_bh57_w5_2 & heap_bh57_w5_1;
   CompressorIn_bh57_16_17(0) <= heap_bh57_w6_4;
   Compressor_bh57_16: Compressor_14_3
      port map ( R => CompressorOut_bh57_16_16   ,
                 X0 => CompressorIn_bh57_16_16,
                 X1 => CompressorIn_bh57_16_17);
   heap_bh57_w5_15 <= CompressorOut_bh57_16_16(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w6_15 <= CompressorOut_bh57_16_16(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w7_14 <= CompressorOut_bh57_16_16(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_17_18 <= heap_bh57_w6_3 & heap_bh57_w6_2 & heap_bh57_w6_1 & heap_bh57_w6_0;
   CompressorIn_bh57_17_19(0) <= heap_bh57_w7_4;
   Compressor_bh57_17: Compressor_14_3
      port map ( R => CompressorOut_bh57_17_17   ,
                 X0 => CompressorIn_bh57_17_18,
                 X1 => CompressorIn_bh57_17_19);
   heap_bh57_w6_16 <= CompressorOut_bh57_17_17(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w7_15 <= CompressorOut_bh57_17_17(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w8_14 <= CompressorOut_bh57_17_17(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_18_20 <= heap_bh57_w7_3 & heap_bh57_w7_2 & heap_bh57_w7_1 & heap_bh57_w7_0;
   CompressorIn_bh57_18_21(0) <= heap_bh57_w8_4;
   Compressor_bh57_18: Compressor_14_3
      port map ( R => CompressorOut_bh57_18_18   ,
                 X0 => CompressorIn_bh57_18_20,
                 X1 => CompressorIn_bh57_18_21);
   heap_bh57_w7_16 <= CompressorOut_bh57_18_18(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w8_15 <= CompressorOut_bh57_18_18(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w9_12 <= CompressorOut_bh57_18_18(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_19_22 <= heap_bh57_w8_3 & heap_bh57_w8_2 & heap_bh57_w8_1 & heap_bh57_w8_0;
   CompressorIn_bh57_19_23(0) <= heap_bh57_w9_2;
   Compressor_bh57_19: Compressor_14_3
      port map ( R => CompressorOut_bh57_19_19   ,
                 X0 => CompressorIn_bh57_19_22,
                 X1 => CompressorIn_bh57_19_23);
   heap_bh57_w8_16 <= CompressorOut_bh57_19_19(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w9_13 <= CompressorOut_bh57_19_19(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w10_12 <= CompressorOut_bh57_19_19(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_20_24 <= heap_bh57_w15_4 & heap_bh57_w15_3 & heap_bh57_w15_2 & heap_bh57_w15_1;
   CompressorIn_bh57_20_25(0) <= heap_bh57_w16_4;
   Compressor_bh57_20: Compressor_14_3
      port map ( R => CompressorOut_bh57_20_20   ,
                 X0 => CompressorIn_bh57_20_24,
                 X1 => CompressorIn_bh57_20_25);
   heap_bh57_w15_7 <= CompressorOut_bh57_20_20(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w16_6 <= CompressorOut_bh57_20_20(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w17_5 <= CompressorOut_bh57_20_20(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_21_26 <= heap_bh57_w16_3 & heap_bh57_w16_2 & heap_bh57_w16_1 & heap_bh57_w16_0;
   CompressorIn_bh57_21_27(0) <= heap_bh57_w17_4;
   Compressor_bh57_21: Compressor_14_3
      port map ( R => CompressorOut_bh57_21_21   ,
                 X0 => CompressorIn_bh57_21_26,
                 X1 => CompressorIn_bh57_21_27);
   heap_bh57_w16_7 <= CompressorOut_bh57_21_21(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w17_6 <= CompressorOut_bh57_21_21(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w18_3 <= CompressorOut_bh57_21_21(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_22_28 <= heap_bh57_w17_3 & heap_bh57_w17_2 & heap_bh57_w17_1 & heap_bh57_w17_0;
   CompressorIn_bh57_22_29(0) <= heap_bh57_w18_2;
   Compressor_bh57_22: Compressor_14_3
      port map ( R => CompressorOut_bh57_22_22   ,
                 X0 => CompressorIn_bh57_22_28,
                 X1 => CompressorIn_bh57_22_29);
   heap_bh57_w17_7 <= CompressorOut_bh57_22_22(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w18_4 <= CompressorOut_bh57_22_22(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w19_3 <= CompressorOut_bh57_22_22(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_23_30 <= heap_bh57_w3_3 & heap_bh57_w3_2 & heap_bh57_w3_1 & heap_bh57_w3_0;
   Compressor_bh57_23: Compressor_4_3
      port map ( R => CompressorOut_bh57_23_23   ,
                 X0 => CompressorIn_bh57_23_30);
   heap_bh57_w3_13 <= CompressorOut_bh57_23_23(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w4_16 <= CompressorOut_bh57_23_23(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w5_16 <= CompressorOut_bh57_23_23(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_24_31 <= heap_bh57_w1_2 & heap_bh57_w1_1 & heap_bh57_w1_0;
   CompressorIn_bh57_24_32 <= heap_bh57_w2_2 & heap_bh57_w2_1;
   Compressor_bh57_24: Compressor_23_3
      port map ( R => CompressorOut_bh57_24_24   ,
                 X0 => CompressorIn_bh57_24_31,
                 X1 => CompressorIn_bh57_24_32);
   heap_bh57_w1_11 <= CompressorOut_bh57_24_24(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w2_12 <= CompressorOut_bh57_24_24(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w3_14 <= CompressorOut_bh57_24_24(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_25_33 <= heap_bh57_w10_2 & heap_bh57_w10_1 & heap_bh57_w10_0;
   CompressorIn_bh57_25_34 <= heap_bh57_w11_2 & heap_bh57_w11_1;
   Compressor_bh57_25: Compressor_23_3
      port map ( R => CompressorOut_bh57_25_25   ,
                 X0 => CompressorIn_bh57_25_33,
                 X1 => CompressorIn_bh57_25_34);
   heap_bh57_w10_13 <= CompressorOut_bh57_25_25(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w11_12 <= CompressorOut_bh57_25_25(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w12_10 <= CompressorOut_bh57_25_25(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_26_35 <= heap_bh57_w19_2 & heap_bh57_w19_1 & heap_bh57_w19_0;
   CompressorIn_bh57_26_36 <= heap_bh57_w20_2 & heap_bh57_w20_1;
   Compressor_bh57_26: Compressor_23_3
      port map ( R => CompressorOut_bh57_26_26   ,
                 X0 => CompressorIn_bh57_26_35,
                 X1 => CompressorIn_bh57_26_36);
   heap_bh57_w19_4 <= CompressorOut_bh57_26_26(0); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w20_3 <= CompressorOut_bh57_26_26(1); -- cycle= 0 cp= 1.10504e-09
   heap_bh57_w21_1 <= CompressorOut_bh57_26_26(2); -- cycle= 0 cp= 1.10504e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_27_37 <= heap_bh57_w5_0 & heap_bh57_w5_16 & heap_bh57_w5_15 & heap_bh57_w5_14 & heap_bh57_w5_13 & heap_bh57_w5_12;
   Compressor_bh57_27: Compressor_6_3
      port map ( R => CompressorOut_bh57_27_27   ,
                 X0 => CompressorIn_bh57_27_37);
   heap_bh57_w5_17 <= CompressorOut_bh57_27_27(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w6_17 <= CompressorOut_bh57_27_27(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w7_17 <= CompressorOut_bh57_27_27(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_28_38 <= heap_bh57_w6_16 & heap_bh57_w6_15 & heap_bh57_w6_14 & heap_bh57_w6_13 & heap_bh57_w6_12 & heap_bh57_w6_11;
   Compressor_bh57_28: Compressor_6_3
      port map ( R => CompressorOut_bh57_28_28   ,
                 X0 => CompressorIn_bh57_28_38);
   heap_bh57_w6_18 <= CompressorOut_bh57_28_28(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w7_18 <= CompressorOut_bh57_28_28(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w8_17 <= CompressorOut_bh57_28_28(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_29_39 <= heap_bh57_w7_16 & heap_bh57_w7_15 & heap_bh57_w7_14 & heap_bh57_w7_13 & heap_bh57_w7_12 & heap_bh57_w7_11;
   Compressor_bh57_29: Compressor_6_3
      port map ( R => CompressorOut_bh57_29_29   ,
                 X0 => CompressorIn_bh57_29_39);
   heap_bh57_w7_19 <= CompressorOut_bh57_29_29(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w8_18 <= CompressorOut_bh57_29_29(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w9_14 <= CompressorOut_bh57_29_29(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_30_40 <= heap_bh57_w8_16 & heap_bh57_w8_15 & heap_bh57_w8_14 & heap_bh57_w8_13 & heap_bh57_w8_12 & heap_bh57_w8_11;
   Compressor_bh57_30: Compressor_6_3
      port map ( R => CompressorOut_bh57_30_30   ,
                 X0 => CompressorIn_bh57_30_40);
   heap_bh57_w8_19 <= CompressorOut_bh57_30_30(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w9_15 <= CompressorOut_bh57_30_30(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w10_14 <= CompressorOut_bh57_30_30(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_31_41 <= heap_bh57_w9_1 & heap_bh57_w9_0 & heap_bh57_w9_13 & heap_bh57_w9_12 & heap_bh57_w9_11 & heap_bh57_w9_10;
   Compressor_bh57_31: Compressor_6_3
      port map ( R => CompressorOut_bh57_31_31   ,
                 X0 => CompressorIn_bh57_31_41);
   heap_bh57_w9_16 <= CompressorOut_bh57_31_31(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w10_15 <= CompressorOut_bh57_31_31(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w11_13 <= CompressorOut_bh57_31_31(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_32_42 <= heap_bh57_w2_0 & heap_bh57_w2_12 & heap_bh57_w2_11 & heap_bh57_w2_10;
   CompressorIn_bh57_32_43(0) <= heap_bh57_w3_14;
   Compressor_bh57_32: Compressor_14_3
      port map ( R => CompressorOut_bh57_32_32   ,
                 X0 => CompressorIn_bh57_32_42,
                 X1 => CompressorIn_bh57_32_43);
   heap_bh57_w2_13 <= CompressorOut_bh57_32_32(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w3_15 <= CompressorOut_bh57_32_32(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w4_17 <= CompressorOut_bh57_32_32(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_33_44 <= heap_bh57_w3_13 & heap_bh57_w3_12 & heap_bh57_w3_11 & heap_bh57_w3_10;
   CompressorIn_bh57_33_45(0) <= heap_bh57_w4_16;
   Compressor_bh57_33: Compressor_14_3
      port map ( R => CompressorOut_bh57_33_33   ,
                 X0 => CompressorIn_bh57_33_44,
                 X1 => CompressorIn_bh57_33_45);
   heap_bh57_w3_16 <= CompressorOut_bh57_33_33(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w4_18 <= CompressorOut_bh57_33_33(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w5_18 <= CompressorOut_bh57_33_33(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_34_46 <= heap_bh57_w4_15 & heap_bh57_w4_14 & heap_bh57_w4_13 & heap_bh57_w4_12;
   CompressorIn_bh57_34_47(0) <= heap_bh57_w5_11;
   Compressor_bh57_34: Compressor_14_3
      port map ( R => CompressorOut_bh57_34_34   ,
                 X0 => CompressorIn_bh57_34_46,
                 X1 => CompressorIn_bh57_34_47);
   heap_bh57_w4_19 <= CompressorOut_bh57_34_34(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w5_19 <= CompressorOut_bh57_34_34(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w6_19 <= CompressorOut_bh57_34_34(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_35_48 <= heap_bh57_w10_13 & heap_bh57_w10_12 & heap_bh57_w10_11 & heap_bh57_w10_10;
   CompressorIn_bh57_35_49(0) <= heap_bh57_w11_0;
   Compressor_bh57_35: Compressor_14_3
      port map ( R => CompressorOut_bh57_35_35   ,
                 X0 => CompressorIn_bh57_35_48,
                 X1 => CompressorIn_bh57_35_49);
   heap_bh57_w10_16 <= CompressorOut_bh57_35_35(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w11_14 <= CompressorOut_bh57_35_35(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w12_11 <= CompressorOut_bh57_35_35(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_36_50 <= heap_bh57_w11_12 & heap_bh57_w11_11 & heap_bh57_w11_10 & heap_bh57_w11_9;
   CompressorIn_bh57_36_51(0) <= heap_bh57_w12_0;
   Compressor_bh57_36: Compressor_14_3
      port map ( R => CompressorOut_bh57_36_36   ,
                 X0 => CompressorIn_bh57_36_50,
                 X1 => CompressorIn_bh57_36_51);
   heap_bh57_w11_15 <= CompressorOut_bh57_36_36(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w12_12 <= CompressorOut_bh57_36_36(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w13_10 <= CompressorOut_bh57_36_36(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_37_52 <= heap_bh57_w12_10 & heap_bh57_w12_9 & heap_bh57_w12_8 & heap_bh57_w12_7;
   CompressorIn_bh57_37_53(0) <= heap_bh57_w13_0;
   Compressor_bh57_37: Compressor_14_3
      port map ( R => CompressorOut_bh57_37_37   ,
                 X0 => CompressorIn_bh57_37_52,
                 X1 => CompressorIn_bh57_37_53);
   heap_bh57_w12_13 <= CompressorOut_bh57_37_37(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w13_11 <= CompressorOut_bh57_37_37(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w14_10 <= CompressorOut_bh57_37_37(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_38_54 <= heap_bh57_w14_0 & heap_bh57_w14_9 & heap_bh57_w14_8 & heap_bh57_w14_7;
   CompressorIn_bh57_38_55(0) <= heap_bh57_w15_0;
   Compressor_bh57_38: Compressor_14_3
      port map ( R => CompressorOut_bh57_38_38   ,
                 X0 => CompressorIn_bh57_38_54,
                 X1 => CompressorIn_bh57_38_55);
   heap_bh57_w14_11 <= CompressorOut_bh57_38_38(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w15_8 <= CompressorOut_bh57_38_38(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w16_8 <= CompressorOut_bh57_38_38(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_39_56 <= heap_bh57_w18_1 & heap_bh57_w18_0 & heap_bh57_w18_4 & heap_bh57_w18_3;
   CompressorIn_bh57_39_57(0) <= heap_bh57_w19_4;
   Compressor_bh57_39: Compressor_14_3
      port map ( R => CompressorOut_bh57_39_39   ,
                 X0 => CompressorIn_bh57_39_56,
                 X1 => CompressorIn_bh57_39_57);
   heap_bh57_w18_5 <= CompressorOut_bh57_39_39(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w19_5 <= CompressorOut_bh57_39_39(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w20_4 <= CompressorOut_bh57_39_39(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_40_58 <= heap_bh57_w0_1 & heap_bh57_w0_0 & heap_bh57_w0_8;
   CompressorIn_bh57_40_59 <= heap_bh57_w1_11 & heap_bh57_w1_10;
   Compressor_bh57_40: Compressor_23_3
      port map ( R => CompressorOut_bh57_40_40   ,
                 X0 => CompressorIn_bh57_40_58,
                 X1 => CompressorIn_bh57_40_59);
   heap_bh57_w0_9 <= CompressorOut_bh57_40_40(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w1_12 <= CompressorOut_bh57_40_40(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w2_14 <= CompressorOut_bh57_40_40(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_41_60 <= heap_bh57_w15_7 & heap_bh57_w15_6 & heap_bh57_w15_5;
   CompressorIn_bh57_41_61 <= heap_bh57_w16_7 & heap_bh57_w16_6;
   Compressor_bh57_41: Compressor_23_3
      port map ( R => CompressorOut_bh57_41_41   ,
                 X0 => CompressorIn_bh57_41_60,
                 X1 => CompressorIn_bh57_41_61);
   heap_bh57_w15_9 <= CompressorOut_bh57_41_41(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w16_9 <= CompressorOut_bh57_41_41(1); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w17_8 <= CompressorOut_bh57_41_41(2); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_42_62 <= heap_bh57_w13_9 & heap_bh57_w13_8 & heap_bh57_w13_7;
   Compressor_bh57_42: Compressor_3_2
      port map ( R => CompressorOut_bh57_42_42   ,
                 X0 => CompressorIn_bh57_42_62);
   heap_bh57_w13_12 <= CompressorOut_bh57_42_42(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w14_12 <= CompressorOut_bh57_42_42(1); -- cycle= 0 cp= 1.63576e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_43_63 <= heap_bh57_w17_7 & heap_bh57_w17_6 & heap_bh57_w17_5;
   Compressor_bh57_43: Compressor_3_2
      port map ( R => CompressorOut_bh57_43_43   ,
                 X0 => CompressorIn_bh57_43_63);
   heap_bh57_w17_9 <= CompressorOut_bh57_43_43(0); -- cycle= 0 cp= 1.63576e-09
   heap_bh57_w18_6 <= CompressorOut_bh57_43_43(1); -- cycle= 0 cp= 1.63576e-09
   ----------------Synchro barrier, entering cycle 0----------------
   tempR_bh57_0 <= heap_bh57_w0_9; -- already compressed

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_44_64 <= heap_bh57_w9_9 & heap_bh57_w9_16 & heap_bh57_w9_15 & heap_bh57_w9_14;
   CompressorIn_bh57_44_65(0) <= heap_bh57_w10_9;
   Compressor_bh57_44: Compressor_14_3
      port map ( R => CompressorOut_bh57_44_44   ,
                 X0 => CompressorIn_bh57_44_64,
                 X1 => CompressorIn_bh57_44_65);
   heap_bh57_w9_17 <= CompressorOut_bh57_44_44(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w10_17 <= CompressorOut_bh57_44_44(1); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w11_16 <= CompressorOut_bh57_44_44(2); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_45_66 <= heap_bh57_w2_9 & heap_bh57_w2_14 & heap_bh57_w2_13;
   CompressorIn_bh57_45_67 <= heap_bh57_w3_16 & heap_bh57_w3_15;
   Compressor_bh57_45: Compressor_23_3
      port map ( R => CompressorOut_bh57_45_45   ,
                 X0 => CompressorIn_bh57_45_66,
                 X1 => CompressorIn_bh57_45_67);
   heap_bh57_w2_15 <= CompressorOut_bh57_45_45(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w3_17 <= CompressorOut_bh57_45_45(1); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w4_20 <= CompressorOut_bh57_45_45(2); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_46_68 <= heap_bh57_w4_19 & heap_bh57_w4_18 & heap_bh57_w4_17;
   CompressorIn_bh57_46_69 <= heap_bh57_w5_19 & heap_bh57_w5_18;
   Compressor_bh57_46: Compressor_23_3
      port map ( R => CompressorOut_bh57_46_46   ,
                 X0 => CompressorIn_bh57_46_68,
                 X1 => CompressorIn_bh57_46_69);
   heap_bh57_w4_21 <= CompressorOut_bh57_46_46(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w5_20 <= CompressorOut_bh57_46_46(1); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w6_20 <= CompressorOut_bh57_46_46(2); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_47_70 <= heap_bh57_w6_19 & heap_bh57_w6_18 & heap_bh57_w6_17;
   CompressorIn_bh57_47_71 <= heap_bh57_w7_19 & heap_bh57_w7_18;
   Compressor_bh57_47: Compressor_23_3
      port map ( R => CompressorOut_bh57_47_47   ,
                 X0 => CompressorIn_bh57_47_70,
                 X1 => CompressorIn_bh57_47_71);
   heap_bh57_w6_21 <= CompressorOut_bh57_47_47(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w7_20 <= CompressorOut_bh57_47_47(1); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w8_20 <= CompressorOut_bh57_47_47(2); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_48_72 <= heap_bh57_w10_16 & heap_bh57_w10_15 & heap_bh57_w10_14;
   CompressorIn_bh57_48_73 <= heap_bh57_w11_15 & heap_bh57_w11_14;
   Compressor_bh57_48: Compressor_23_3
      port map ( R => CompressorOut_bh57_48_48   ,
                 X0 => CompressorIn_bh57_48_72,
                 X1 => CompressorIn_bh57_48_73);
   heap_bh57_w10_18 <= CompressorOut_bh57_48_48(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w11_17 <= CompressorOut_bh57_48_48(1); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w12_14 <= CompressorOut_bh57_48_48(2); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_49_74 <= heap_bh57_w12_13 & heap_bh57_w12_12 & heap_bh57_w12_11;
   CompressorIn_bh57_49_75 <= heap_bh57_w13_12 & heap_bh57_w13_11;
   Compressor_bh57_49: Compressor_23_3
      port map ( R => CompressorOut_bh57_49_49   ,
                 X0 => CompressorIn_bh57_49_74,
                 X1 => CompressorIn_bh57_49_75);
   heap_bh57_w12_15 <= CompressorOut_bh57_49_49(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w13_13 <= CompressorOut_bh57_49_49(1); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w14_13 <= CompressorOut_bh57_49_49(2); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_50_76 <= heap_bh57_w14_12 & heap_bh57_w14_11 & heap_bh57_w14_10;
   CompressorIn_bh57_50_77 <= heap_bh57_w15_9 & heap_bh57_w15_8;
   Compressor_bh57_50: Compressor_23_3
      port map ( R => CompressorOut_bh57_50_50   ,
                 X0 => CompressorIn_bh57_50_76,
                 X1 => CompressorIn_bh57_50_77);
   heap_bh57_w14_14 <= CompressorOut_bh57_50_50(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w15_10 <= CompressorOut_bh57_50_50(1); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w16_10 <= CompressorOut_bh57_50_50(2); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_51_78 <= heap_bh57_w16_5 & heap_bh57_w16_9 & heap_bh57_w16_8;
   CompressorIn_bh57_51_79 <= heap_bh57_w17_9 & heap_bh57_w17_8;
   Compressor_bh57_51: Compressor_23_3
      port map ( R => CompressorOut_bh57_51_51   ,
                 X0 => CompressorIn_bh57_51_78,
                 X1 => CompressorIn_bh57_51_79);
   heap_bh57_w16_11 <= CompressorOut_bh57_51_51(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w17_10 <= CompressorOut_bh57_51_51(1); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w18_7 <= CompressorOut_bh57_51_51(2); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_52_80 <= heap_bh57_w20_0 & heap_bh57_w20_3 & heap_bh57_w20_4;
   CompressorIn_bh57_52_81 <= heap_bh57_w21_0 & heap_bh57_w21_1;
   Compressor_bh57_52: Compressor_23_3
      port map ( R => CompressorOut_bh57_52_52   ,
                 X0 => CompressorIn_bh57_52_80,
                 X1 => CompressorIn_bh57_52_81);
   heap_bh57_w20_5 <= CompressorOut_bh57_52_52(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w21_2 <= CompressorOut_bh57_52_52(1); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w22_1 <= CompressorOut_bh57_52_52(2); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_53_82 <= heap_bh57_w8_19 & heap_bh57_w8_18 & heap_bh57_w8_17;
   Compressor_bh57_53: Compressor_3_2
      port map ( R => CompressorOut_bh57_53_53   ,
                 X0 => CompressorIn_bh57_53_82);
   heap_bh57_w8_21 <= CompressorOut_bh57_53_53(0); -- cycle= 0 cp= 2.16648e-09
   heap_bh57_w9_18 <= CompressorOut_bh57_53_53(1); -- cycle= 0 cp= 2.16648e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_54_83 <= heap_bh57_w11_13 & heap_bh57_w11_17 & heap_bh57_w11_16;
   CompressorIn_bh57_54_84 <= heap_bh57_w12_15 & heap_bh57_w12_14;
   Compressor_bh57_54: Compressor_23_3
      port map ( R => CompressorOut_bh57_54_54   ,
                 X0 => CompressorIn_bh57_54_83,
                 X1 => CompressorIn_bh57_54_84);
   heap_bh57_w11_18 <= CompressorOut_bh57_54_54(0); -- cycle= 0 cp= 2.6972e-09
   heap_bh57_w12_16 <= CompressorOut_bh57_54_54(1); -- cycle= 0 cp= 2.6972e-09
   heap_bh57_w13_14 <= CompressorOut_bh57_54_54(2); -- cycle= 0 cp= 2.6972e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_55_85 <= heap_bh57_w18_6 & heap_bh57_w18_5 & heap_bh57_w18_7;
   CompressorIn_bh57_55_86 <= heap_bh57_w19_3 & heap_bh57_w19_5;
   Compressor_bh57_55: Compressor_23_3
      port map ( R => CompressorOut_bh57_55_55   ,
                 X0 => CompressorIn_bh57_55_85,
                 X1 => CompressorIn_bh57_55_86);
   heap_bh57_w18_8 <= CompressorOut_bh57_55_55(0); -- cycle= 0 cp= 2.6972e-09
   heap_bh57_w19_6 <= CompressorOut_bh57_55_55(1); -- cycle= 0 cp= 2.6972e-09
   heap_bh57_w20_6 <= CompressorOut_bh57_55_55(2); -- cycle= 0 cp= 2.6972e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh57_56_87 <= heap_bh57_w13_10 & heap_bh57_w13_13 & heap_bh57_w13_14;
   CompressorIn_bh57_56_88 <= heap_bh57_w14_14 & heap_bh57_w14_13;
   Compressor_bh57_56: Compressor_23_3
      port map ( R => CompressorOut_bh57_56_56   ,
                 X0 => CompressorIn_bh57_56_87,
                 X1 => CompressorIn_bh57_56_88);
   heap_bh57_w13_15 <= CompressorOut_bh57_56_56(0); -- cycle= 0 cp= 3.22792e-09
   heap_bh57_w14_15 <= CompressorOut_bh57_56_56(1); -- cycle= 0 cp= 3.22792e-09
   heap_bh57_w15_11 <= CompressorOut_bh57_56_56(2); -- cycle= 0 cp= 3.22792e-09
   ----------------Synchro barrier, entering cycle 0----------------
   ----------------Synchro barrier, entering cycle 1----------------
   finalAdderIn0_bh57 <= "0" & heap_bh57_w23_0_d1 & heap_bh57_w22_0_d1 & heap_bh57_w21_2_d1 & heap_bh57_w20_5_d1 & heap_bh57_w19_6_d1 & heap_bh57_w18_8_d1 & heap_bh57_w17_10_d1 & heap_bh57_w16_11_d1 & heap_bh57_w15_10_d1 & heap_bh57_w14_15_d1 & heap_bh57_w13_15_d1 & heap_bh57_w12_16_d1 & heap_bh57_w11_18_d1 & heap_bh57_w10_18_d1 & heap_bh57_w9_18_d1 & heap_bh57_w8_21_d1 & heap_bh57_w7_17_d1 & heap_bh57_w6_21_d1 & heap_bh57_w5_17_d1 & heap_bh57_w4_21_d1 & heap_bh57_w3_17_d1 & heap_bh57_w2_15_d1 & heap_bh57_w1_9_d1;
   finalAdderIn1_bh57 <= "0" & '0' & heap_bh57_w22_1_d1 & '0' & heap_bh57_w20_6_d1 & '0' & '0' & '0' & heap_bh57_w16_10_d1 & heap_bh57_w15_11_d1 & '0' & '0' & '0' & '0' & heap_bh57_w10_17_d1 & heap_bh57_w9_17_d1 & heap_bh57_w8_20_d1 & heap_bh57_w7_20_d1 & heap_bh57_w6_20_d1 & heap_bh57_w5_20_d1 & heap_bh57_w4_20_d1 & '0' & '0' & heap_bh57_w1_12_d1;
   finalAdderCin_bh57 <= '0';
   Adder_final57_0: IntAdder_24_f200_uid155  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => finalAdderCin_bh57,
                 R => finalAdderOut_bh57   ,
                 X => finalAdderIn0_bh57,
                 Y => finalAdderIn1_bh57);
   -- concatenate all the compressed chunks
   CompressionResult57 <= finalAdderOut_bh57 & tempR_bh57_0_d1;
   -- End of code generated by BitHeap::generateCompressorVHDL
   R <= CompressionResult57(23 downto 5);
end architecture;

--------------------------------------------------------------------------------
--                          IntAdder_27_f200_uid163
--                    (IntAdderAlternative_27_f200_uid167)
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

entity IntAdder_27_f200_uid163 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(26 downto 0);
          Y : in  std_logic_vector(26 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(26 downto 0)   );
end entity;

architecture arch of IntAdder_27_f200_uid163 is
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
--                          IntAdder_34_f200_uid170
--                    (IntAdderAlternative_34_f200_uid174)
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

entity IntAdder_34_f200_uid170 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(33 downto 0);
          Y : in  std_logic_vector(33 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(33 downto 0)   );
end entity;

architecture arch of IntAdder_34_f200_uid170 is
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
--                                  Exp_Clk
--                              (FPExp_9_23_200)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: F. de Dinechin, Bogdan Pasca (2008-2013)
--------------------------------------------------------------------------------
-- Pipeline depth: 6 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity Exp_Clk is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(9+23+2 downto 0);
          R : out  std_logic_vector(9+23+2 downto 0);
--- mod by JDH Sept 21, 2015 --------          
          roundBit : buffer std_logic;
          XSign_d5 : buffer std_logic;
          roundit   : in std_logic   );
-------------------------------------
end entity;

architecture arch of Exp_Clk is
   component FixRealKCM_0_8_M26_log_2_unsigned is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(8 downto 0);
             R : out  std_logic_vector(34 downto 0)   );
   end component;

   component FixRealKCM_M3_7_0_1_log_2_unsigned is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(10 downto 0);
             R : out  std_logic_vector(8 downto 0)   );
   end component;

   component IntAdder_18_f200_uid41 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(17 downto 0);
             Y : in  std_logic_vector(17 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(17 downto 0)   );
   end component;

   component IntAdder_18_f200_uid48 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(17 downto 0);
             Y : in  std_logic_vector(17 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(17 downto 0)   );
   end component;

   component IntAdder_26_f219_uid32 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(25 downto 0);
             Y : in  std_logic_vector(25 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(25 downto 0)   );
   end component;

   component IntAdder_27_f200_uid163 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(26 downto 0);
             Y : in  std_logic_vector(26 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(26 downto 0)   );
   end component;

   component IntAdder_34_f200_uid170 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(33 downto 0);
             Y : in  std_logic_vector(33 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(33 downto 0)   );
   end component;

   component IntMultiplier_UsingDSP_17_18_19_unsigned_uid55 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(16 downto 0);
             Y : in  std_logic_vector(17 downto 0);
             R : out  std_logic_vector(18 downto 0)   );
   end component;

   component LeftShifter_24_by_max_34_uid3 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(23 downto 0);
             S : in  std_logic_vector(5 downto 0);
             R : out  std_logic_vector(57 downto 0)   );
   end component;

   component MagicSPExpTable is
      port ( X1 : in  std_logic_vector(8 downto 0);
             Y1 : out  std_logic_vector(35 downto 0);
             X2 : in  std_logic_vector(8 downto 0);
             Y2 : out  std_logic_vector(35 downto 0)   );
   end component;

signal Xexn, Xexn_d1, Xexn_d2, Xexn_d3, Xexn_d4, Xexn_d5, Xexn_d6 :  std_logic_vector(1 downto 0);
--signal XSign, XSign_d1, XSign_d2, XSign_d3, XSign_d4, XSign_d5, XSign_d6 :  std_logic;
signal XSign, XSign_d1, XSign_d2, XSign_d3, XSign_d4, XSign_d6 :  std_logic;
signal XexpField :  std_logic_vector(8 downto 0);
signal Xfrac :  std_logic_vector(22 downto 0);
signal e0 :  std_logic_vector(10 downto 0);
signal shiftVal :  std_logic_vector(10 downto 0);
signal resultWillBeOne :  std_logic;
signal mXu :  std_logic_vector(23 downto 0);
signal oufl0, oufl0_d1, oufl0_d2, oufl0_d3, oufl0_d4, oufl0_d5, oufl0_d6 :  std_logic;
signal shiftValIn :  std_logic_vector(5 downto 0);
signal fixX0 :  std_logic_vector(57 downto 0);
signal fixX, fixX_d1, fixX_d2 :  std_logic_vector(34 downto 0);
signal xMulIn :  std_logic_vector(10 downto 0);
signal absK :  std_logic_vector(8 downto 0);
signal minusAbsK :  std_logic_vector(9 downto 0);
signal K, K_d1, K_d2, K_d3, K_d4 :  std_logic_vector(9 downto 0);
signal absKLog2 :  std_logic_vector(34 downto 0);
signal subOp1 :  std_logic_vector(25 downto 0);
signal subOp2 :  std_logic_vector(25 downto 0);
signal Y :  std_logic_vector(25 downto 0);
signal Addr1 :  std_logic_vector(8 downto 0);
signal Z :  std_logic_vector(16 downto 0);
signal Addr2 :  std_logic_vector(8 downto 0);
signal expZ_output :  std_logic_vector(35 downto 0);
signal expA_output :  std_logic_vector(35 downto 0);
signal expA, expA_d1, expA_d2, expA_d3 :  std_logic_vector(26 downto 0);
signal expZmZm1 :  std_logic_vector(8 downto 0);
signal expZminus1X :  std_logic_vector(17 downto 0);
signal expZminus1Y :  std_logic_vector(17 downto 0);
signal expZminus1, expZminus1_d1 :  std_logic_vector(17 downto 0);
signal expArounded0 :  std_logic_vector(17 downto 0);
signal expArounded, expArounded_d1 :  std_logic_vector(16 downto 0);
signal lowerProduct, lowerProduct_d1 :  std_logic_vector(18 downto 0);
signal extendedLowerProduct :  std_logic_vector(26 downto 0);
signal expY :  std_logic_vector(26 downto 0);
signal needNoNorm :  std_logic;
signal preRoundBiasSig :  std_logic_vector(33 downto 0);
--signal roundBit :  std_logic;
signal roundNormAddend :  std_logic_vector(33 downto 0);
signal roundedExpSigRes, roundedExpSigRes_d1 :  std_logic_vector(33 downto 0);
signal roundedExpSig :  std_logic_vector(33 downto 0);
signal ofl1 :  std_logic;
signal ofl2 :  std_logic;
signal ofl3 :  std_logic;
signal ofl :  std_logic;
signal ufl1 :  std_logic;
signal ufl2 :  std_logic;
signal ufl3 :  std_logic;
signal ufl :  std_logic;
signal Rexn :  std_logic_vector(1 downto 0);
constant g: positive := 3;
constant wE: positive := 9;
constant wF: positive := 23;
constant wFIn: positive := 23;
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            Xexn_d1 <=  Xexn;
            Xexn_d2 <=  Xexn_d1;
            Xexn_d3 <=  Xexn_d2;
            Xexn_d4 <=  Xexn_d3;
            Xexn_d5 <=  Xexn_d4;
            Xexn_d6 <=  Xexn_d5;
            XSign_d1 <=  XSign;
            XSign_d2 <=  XSign_d1;
            XSign_d3 <=  XSign_d2;
            XSign_d4 <=  XSign_d3;
            XSign_d5 <=  XSign_d4;
            XSign_d6 <=  XSign_d5;
            oufl0_d1 <=  oufl0;
            oufl0_d2 <=  oufl0_d1;
            oufl0_d3 <=  oufl0_d2;
            oufl0_d4 <=  oufl0_d3;
            oufl0_d5 <=  oufl0_d4;
            oufl0_d6 <=  oufl0_d5;
            fixX_d1 <=  fixX;
            fixX_d2 <=  fixX_d1;
            K_d1 <=  K;
            K_d2 <=  K_d1;
            K_d3 <=  K_d2;
            K_d4 <=  K_d3;
            expA_d1 <=  expA;
            expA_d2 <=  expA_d1;
            expA_d3 <=  expA_d2;
            expZminus1_d1 <=  expZminus1;
            expArounded_d1 <=  expArounded;
            lowerProduct_d1 <=  lowerProduct;
            roundedExpSigRes_d1 <=  roundedExpSigRes;
         end if;
      end process;
   Xexn <= X(wE+wFIn+2 downto wE+wFIn+1);
   XSign <= X(wE+wFIn);
   XexpField <= X(wE+wFIn-1 downto wFIn);
   Xfrac <= X(wFIn-1 downto 0);
   e0 <= conv_std_logic_vector(229, wE+2);  -- bias - (wF+g)
   shiftVal <= ("00" & XexpField) - e0; -- for a left shift
   -- underflow when input is shifted to zero (shiftval<0), in which case exp = 1
   resultWillBeOne <= shiftVal(wE+1);
   --  mantissa with implicit bit
   mXu <= "1" & Xfrac;
   -- Partial overflow/underflow detection
   oufl0 <= not shiftVal(wE+1) when shiftVal(wE downto 0) >= conv_std_logic_vector(34, wE+1) else '0';
   ---------------- cycle 0----------------
   shiftValIn <= shiftVal(5 downto 0);
   mantissa_shift: LeftShifter_24_by_max_34_uid3  -- pipelineDepth=0 maxInDelay=2.45572e-09
      port map ( clk  => clk,
                 rst  => rst,
                 R => fixX0,
                 S => shiftValIn,
                 X => mXu);
   fixX <=  fixX0(57 downto 23)when resultWillBeOne='0' else "00000000000000000000000000000000000";
   xMulIn <=  fixX(33 downto 23); -- truncation, error 2^-3
   mulInvLog2: FixRealKCM_M3_7_0_1_log_2_unsigned  -- pipelineDepth=1 maxInDelay=3.81336e-09
      port map ( clk  => clk,
                 rst  => rst,
                 R => absK,
                 X => xMulIn);
   ----------------Synchro barrier, entering cycle 1----------------
   minusAbsK <= (9 downto 0 => '0') - ('0' & absK);
   K <= minusAbsK when  XSign_d1='1'   else ('0' & absK);
   ---------------- cycle 1----------------
   mulLog2: FixRealKCM_0_8_M26_log_2_unsigned  -- pipelineDepth=1 maxInDelay=6.6272e-10
      port map ( clk  => clk,
                 rst  => rst,
                 R => absKLog2,
                 X => absK);
   ----------------Synchro barrier, entering cycle 2----------------
   subOp1 <= fixX_d2(25 downto 0) when XSign_d2='0' else not (fixX_d2(25 downto 0));
   subOp2 <= absKLog2(25 downto 0) when XSign_d2='1' else not (absKLog2(25 downto 0));
   theYAdder: IntAdder_26_f219_uid32  -- pipelineDepth=0 maxInDelay=9.7544e-10
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '1',
                 R => Y,
                 X => subOp1,
                 Y => subOp2);

   -- Now compute the exp of this fixed-point value
   Addr1 <= Y(25 downto 17);
   Z <= Y(16 downto 0);
   Addr2 <= Z(16 downto 8);
   table: MagicSPExpTable
      port map ( X1 => Addr1,
                 X2 => Addr2,
                 Y1 => expA_output,
                 Y2 => expZ_output);
   expA <=  expA_output(35 downto 9);
   expZmZm1 <= expZ_output(8 downto 0);
   -- Computing Z + (exp(Z)-1-Z)
   expZminus1X <= '0' & Z;
   expZminus1Y <= (17 downto 9 => '0') & expZmZm1 ;
   Adder_expZminus1: IntAdder_18_f200_uid41  -- pipelineDepth=0 maxInDelay=2.68616e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin =>  '0' ,
                 R => expZminus1,
                 X => expZminus1X,
                 Y => expZminus1Y);
   ---------------- cycle 2----------------
   -- Rounding expA to the same accuracy as expZminus1
   --   (truncation would not be accurate enough and require one more guard bit)
   Adder_expArounded0: IntAdder_18_f200_uid48  -- pipelineDepth=0 maxInDelay=2.186e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin =>  '1' ,
                 R => expArounded0,
                 X => expA(26 downto 9),
                 Y => "000000000000000000");
   expArounded <= expArounded0(17 downto 1);
   ----------------Synchro barrier, entering cycle 3----------------
   TheLowerProduct: IntMultiplier_UsingDSP_17_18_19_unsigned_uid55  -- pipelineDepth=1 maxInDelay=4.36e-10
      port map ( clk  => clk,
                 rst  => rst,
                 R => lowerProduct,
                 X => expArounded_d1,
                 Y => expZminus1_d1);

   ----------------Synchro barrier, entering cycle 4----------------
   ----------------Synchro barrier, entering cycle 5----------------
   extendedLowerProduct <= ((26 downto 19 => '0') & lowerProduct_d1(18 downto 0));
   -- Final addition -- the product MSB bit weight is -k+2 = -7
   TheFinalAdder: IntAdder_27_f200_uid163  -- pipelineDepth=0 maxInDelay=4.4472e-10
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '0',
                 R => expY,
                 X => expA_d3,
                 Y => extendedLowerProduct);

   needNoNorm <= expY(26);
   -- Rounding: all this should consume one row of LUTs
   preRoundBiasSig <= conv_std_logic_vector(255, wE+2)  & expY(25 downto 3) when needNoNorm = '1'
      else conv_std_logic_vector(254, wE+2)  & expY(24 downto 2) ;
   roundBit <= expY(2)  when needNoNorm = '1'    else expY(1) ;
 --  roundNormAddend <= K_d4(8) & K_d4 & (22 downto 1 => '0') & roundBit;
   roundNormAddend <= K_d4(8) & K_d4 & (22 downto 1 => '0') & roundit;  -- mod by JDH Sept 21, 2015
   roundedExpSigOperandAdder: IntAdder_34_f200_uid170  -- pipelineDepth=0 maxInDelay=3.41492e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => '0',
                 R => roundedExpSigRes,
                 X => preRoundBiasSig,
                 Y => roundNormAddend);

   -- delay at adder output is 4.86492e-09
   ----------------Synchro barrier, entering cycle 6----------------
   roundedExpSig <= roundedExpSigRes_d1 when Xexn_d6="01" else  "000" & (wE-2 downto 0 => '1') & (wF-1 downto 0 => '0');
   ofl1 <= not XSign_d6 and oufl0_d6 and (not Xexn_d6(1) and Xexn_d6(0)); -- input positive, normal,  very large
   ofl2 <= not XSign_d6 and (roundedExpSig(wE+wF) and not roundedExpSig(wE+wF+1)) and (not Xexn_d6(1) and Xexn_d6(0)); -- input positive, normal, overflowed
   ofl3 <= not XSign_d6 and Xexn_d6(1) and not Xexn_d6(0);  -- input was -infty
   ofl <= ofl1 or ofl2 or ofl3;
   ufl1 <= (roundedExpSig(wE+wF) and roundedExpSig(wE+wF+1))  and (not Xexn_d6(1) and Xexn_d6(0)); -- input normal
   ufl2 <= XSign_d6 and Xexn_d6(1) and not Xexn_d6(0);  -- input was -infty
   ufl3 <= XSign_d6 and oufl0_d6  and (not Xexn_d6(1) and Xexn_d6(0)); -- input negative, normal,  very large
   ufl <= ufl1 or ufl2 or ufl3;
   Rexn <= "11" when Xexn_d6 = "11"
      else "10" when ofl='1'
      else "00" when ufl='1'
      else "01";
   R <= Rexn & '0' & roundedExpSig(31 downto 0);
end architecture;
