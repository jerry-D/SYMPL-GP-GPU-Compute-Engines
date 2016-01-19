-- vagrant@vagrant-ubuntu-trusty-32:~/flopoco-3.0.beta5$ ./flopoco -frequency=200 FPMultExpert 9 23 23 38 0 0
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
-- Entity Compressor_13_3
--    Not pipelined
-- Entity Compressor_3_2
--    Not pipelined
-- |   |---Entity IntAdder_44_f200_uid99
-- |   |      Not pipelined
-- |---Entity IntMultiplier_UsingDSP_24_24_41_unsigned_uid4
-- |      Pipeline depth = 1
-- |---Entity IntAdder_49_f200_uid107
-- |      Not pipelined
-- Entity FPMult_9_23_9_23_9_38_uid2
--    Pipeline depth = 1
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
--                              Compressor_13_3
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

entity Compressor_13_3 is
   port ( X0 : in  std_logic_vector(2 downto 0);
          X1 : in  std_logic_vector(0 downto 0);
          R : out  std_logic_vector(2 downto 0)   );
end entity;

architecture arch of Compressor_13_3 is
signal X :  std_logic_vector(3 downto 0);
begin
   X <=X1 & X0 ;
   with X select R <=
      "000" when "0000",
      "001" when "0001",
      "001" when "0010",
      "010" when "0011",
      "001" when "0100",
      "010" when "0101",
      "010" when "0110",
      "011" when "0111",
      "010" when "1000",
      "011" when "1001",
      "011" when "1010",
      "100" when "1011",
      "011" when "1100",
      "100" when "1101",
      "100" when "1110",
      "101" when "1111",
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
--                           IntAdder_44_f200_uid99
--                    (IntAdderAlternative_44_f200_uid103)
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

entity IntAdder_44_f200_uid99 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(43 downto 0);
          Y : in  std_logic_vector(43 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(43 downto 0)   );
end entity;

architecture arch of IntAdder_44_f200_uid99 is
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
--               IntMultiplier_UsingDSP_24_24_41_unsigned_uid4
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

entity IntMultiplier_UsingDSP_24_24_41_unsigned_uid4 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(23 downto 0);
          Y : in  std_logic_vector(23 downto 0);
          R : out  std_logic_vector(40 downto 0)   );
end entity;

architecture arch of IntMultiplier_UsingDSP_24_24_41_unsigned_uid4 is
   component Compressor_13_3 is
      port ( X0 : in  std_logic_vector(2 downto 0);
             X1 : in  std_logic_vector(0 downto 0);
             R : out  std_logic_vector(2 downto 0)   );
   end component;

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

   component IntAdder_44_f200_uid99 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(43 downto 0);
             Y : in  std_logic_vector(43 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(43 downto 0)   );
   end component;

   component SmallMultTableP3x3r6XuYu is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(5 downto 0);
             Y : out  std_logic_vector(5 downto 0)   );
   end component;

signal XX_m5 :  std_logic_vector(23 downto 0);
signal YY_m5 :  std_logic_vector(23 downto 0);
signal Xp_m5b7 :  std_logic_vector(23 downto 0);
signal Yp_m5b7 :  std_logic_vector(8 downto 0);
signal x_m5b7_0 :  std_logic_vector(2 downto 0);
signal x_m5b7_1 :  std_logic_vector(2 downto 0);
signal x_m5b7_2 :  std_logic_vector(2 downto 0);
signal x_m5b7_3 :  std_logic_vector(2 downto 0);
signal x_m5b7_4 :  std_logic_vector(2 downto 0);
signal x_m5b7_5 :  std_logic_vector(2 downto 0);
signal x_m5b7_6 :  std_logic_vector(2 downto 0);
signal x_m5b7_7 :  std_logic_vector(2 downto 0);
signal y_m5b7_0 :  std_logic_vector(2 downto 0);
signal y_m5b7_1 :  std_logic_vector(2 downto 0);
signal y_m5b7_2 :  std_logic_vector(2 downto 0);
signal Y0X1_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X1Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w0_0 :  std_logic;
signal heap_bh6_w1_0 :  std_logic;
signal heap_bh6_w2_0 :  std_logic;
signal Y0X2_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X2Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w2_1 :  std_logic;
signal heap_bh6_w3_0 :  std_logic;
signal heap_bh6_w4_0 :  std_logic;
signal heap_bh6_w5_0 :  std_logic;
signal Y0X3_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X3Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w5_1 :  std_logic;
signal heap_bh6_w6_0 :  std_logic;
signal heap_bh6_w7_0 :  std_logic;
signal heap_bh6_w8_0 :  std_logic;
signal Y0X4_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X4Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w8_1 :  std_logic;
signal heap_bh6_w9_0 :  std_logic;
signal heap_bh6_w10_0 :  std_logic;
signal heap_bh6_w11_0 :  std_logic;
signal Y0X5_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X5Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w11_1 :  std_logic;
signal heap_bh6_w12_0 :  std_logic;
signal heap_bh6_w13_0 :  std_logic;
signal heap_bh6_w14_0 :  std_logic;
signal Y0X6_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X6Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w14_1 :  std_logic;
signal heap_bh6_w15_0 :  std_logic;
signal heap_bh6_w16_0 :  std_logic;
signal heap_bh6_w17_0 :  std_logic;
signal Y0X7_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X7Y0_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w17_1 :  std_logic;
signal heap_bh6_w18_0 :  std_logic;
signal heap_bh6_w19_0 :  std_logic;
signal heap_bh6_w20_0 :  std_logic;
signal Y1X0_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X0Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w0_1 :  std_logic;
signal heap_bh6_w1_1 :  std_logic;
signal heap_bh6_w2_2 :  std_logic;
signal Y1X1_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X1Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w0_2 :  std_logic;
signal heap_bh6_w1_2 :  std_logic;
signal heap_bh6_w2_3 :  std_logic;
signal heap_bh6_w3_1 :  std_logic;
signal heap_bh6_w4_1 :  std_logic;
signal heap_bh6_w5_2 :  std_logic;
signal Y1X2_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X2Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w3_2 :  std_logic;
signal heap_bh6_w4_2 :  std_logic;
signal heap_bh6_w5_3 :  std_logic;
signal heap_bh6_w6_1 :  std_logic;
signal heap_bh6_w7_1 :  std_logic;
signal heap_bh6_w8_2 :  std_logic;
signal Y1X3_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X3Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w6_2 :  std_logic;
signal heap_bh6_w7_2 :  std_logic;
signal heap_bh6_w8_3 :  std_logic;
signal heap_bh6_w9_1 :  std_logic;
signal heap_bh6_w10_1 :  std_logic;
signal heap_bh6_w11_2 :  std_logic;
signal Y1X4_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X4Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w9_2 :  std_logic;
signal heap_bh6_w10_2 :  std_logic;
signal heap_bh6_w11_3 :  std_logic;
signal heap_bh6_w12_1 :  std_logic;
signal heap_bh6_w13_1 :  std_logic;
signal heap_bh6_w14_2 :  std_logic;
signal Y1X5_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X5Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w12_2 :  std_logic;
signal heap_bh6_w13_2 :  std_logic;
signal heap_bh6_w14_3 :  std_logic;
signal heap_bh6_w15_1 :  std_logic;
signal heap_bh6_w16_1 :  std_logic;
signal heap_bh6_w17_2 :  std_logic;
signal Y1X6_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X6Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w15_2 :  std_logic;
signal heap_bh6_w16_2 :  std_logic;
signal heap_bh6_w17_3 :  std_logic;
signal heap_bh6_w18_1 :  std_logic;
signal heap_bh6_w19_1 :  std_logic;
signal heap_bh6_w20_1 :  std_logic;
signal Y1X7_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X7Y1_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w18_2 :  std_logic;
signal heap_bh6_w19_2 :  std_logic;
signal heap_bh6_w20_2 :  std_logic;
signal heap_bh6_w21_0 :  std_logic;
signal heap_bh6_w22_0 :  std_logic;
signal heap_bh6_w23_0 :  std_logic;
signal Y2X0_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X0Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w0_3 :  std_logic;
signal heap_bh6_w1_3 :  std_logic;
signal heap_bh6_w2_4 :  std_logic;
signal heap_bh6_w3_3 :  std_logic;
signal heap_bh6_w4_3 :  std_logic;
signal heap_bh6_w5_4 :  std_logic;
signal Y2X1_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X1Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w3_4 :  std_logic;
signal heap_bh6_w4_4 :  std_logic;
signal heap_bh6_w5_5 :  std_logic;
signal heap_bh6_w6_3 :  std_logic;
signal heap_bh6_w7_3 :  std_logic;
signal heap_bh6_w8_4 :  std_logic;
signal Y2X2_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X2Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w6_4 :  std_logic;
signal heap_bh6_w7_4 :  std_logic;
signal heap_bh6_w8_5 :  std_logic;
signal heap_bh6_w9_3 :  std_logic;
signal heap_bh6_w10_3 :  std_logic;
signal heap_bh6_w11_4 :  std_logic;
signal Y2X3_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X3Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w9_4 :  std_logic;
signal heap_bh6_w10_4 :  std_logic;
signal heap_bh6_w11_5 :  std_logic;
signal heap_bh6_w12_3 :  std_logic;
signal heap_bh6_w13_3 :  std_logic;
signal heap_bh6_w14_4 :  std_logic;
signal Y2X4_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X4Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w12_4 :  std_logic;
signal heap_bh6_w13_4 :  std_logic;
signal heap_bh6_w14_5 :  std_logic;
signal heap_bh6_w15_3 :  std_logic;
signal heap_bh6_w16_3 :  std_logic;
signal heap_bh6_w17_4 :  std_logic;
signal Y2X5_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X5Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w15_4 :  std_logic;
signal heap_bh6_w16_4 :  std_logic;
signal heap_bh6_w17_5 :  std_logic;
signal heap_bh6_w18_3 :  std_logic;
signal heap_bh6_w19_3 :  std_logic;
signal heap_bh6_w20_3 :  std_logic;
signal Y2X6_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X6Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w18_4 :  std_logic;
signal heap_bh6_w19_4 :  std_logic;
signal heap_bh6_w20_4 :  std_logic;
signal heap_bh6_w21_1 :  std_logic;
signal heap_bh6_w22_1 :  std_logic;
signal heap_bh6_w23_1 :  std_logic;
signal Y2X7_7_m5 :  std_logic_vector(5 downto 0);
signal PP7X7Y2_m5 :  std_logic_vector(5 downto 0);
signal heap_bh6_w21_2 :  std_logic;
signal heap_bh6_w22_2 :  std_logic;
signal heap_bh6_w23_2 :  std_logic;
signal heap_bh6_w24_0 :  std_logic;
signal heap_bh6_w25_0 :  std_logic;
signal heap_bh6_w26_0 :  std_logic;
signal DSP_bh6_ch0_0 :  std_logic_vector(40 downto 0);
signal heap_bh6_w43_0, heap_bh6_w43_0_d1 :  std_logic;
signal heap_bh6_w42_0, heap_bh6_w42_0_d1 :  std_logic;
signal heap_bh6_w41_0, heap_bh6_w41_0_d1 :  std_logic;
signal heap_bh6_w40_0, heap_bh6_w40_0_d1 :  std_logic;
signal heap_bh6_w39_0, heap_bh6_w39_0_d1 :  std_logic;
signal heap_bh6_w38_0, heap_bh6_w38_0_d1 :  std_logic;
signal heap_bh6_w37_0, heap_bh6_w37_0_d1 :  std_logic;
signal heap_bh6_w36_0, heap_bh6_w36_0_d1 :  std_logic;
signal heap_bh6_w35_0, heap_bh6_w35_0_d1 :  std_logic;
signal heap_bh6_w34_0, heap_bh6_w34_0_d1 :  std_logic;
signal heap_bh6_w33_0, heap_bh6_w33_0_d1 :  std_logic;
signal heap_bh6_w32_0, heap_bh6_w32_0_d1 :  std_logic;
signal heap_bh6_w31_0, heap_bh6_w31_0_d1 :  std_logic;
signal heap_bh6_w30_0, heap_bh6_w30_0_d1 :  std_logic;
signal heap_bh6_w29_0, heap_bh6_w29_0_d1 :  std_logic;
signal heap_bh6_w28_0, heap_bh6_w28_0_d1 :  std_logic;
signal heap_bh6_w27_0, heap_bh6_w27_0_d1 :  std_logic;
signal heap_bh6_w26_1 :  std_logic;
signal heap_bh6_w25_1 :  std_logic;
signal heap_bh6_w24_1 :  std_logic;
signal heap_bh6_w23_3 :  std_logic;
signal heap_bh6_w22_3 :  std_logic;
signal heap_bh6_w21_3 :  std_logic;
signal heap_bh6_w20_5 :  std_logic;
signal heap_bh6_w19_5 :  std_logic;
signal heap_bh6_w18_5 :  std_logic;
signal heap_bh6_w17_6 :  std_logic;
signal heap_bh6_w16_5 :  std_logic;
signal heap_bh6_w15_5 :  std_logic;
signal heap_bh6_w14_6 :  std_logic;
signal heap_bh6_w13_5 :  std_logic;
signal heap_bh6_w12_5 :  std_logic;
signal heap_bh6_w11_6 :  std_logic;
signal heap_bh6_w10_5, heap_bh6_w10_5_d1 :  std_logic;
signal heap_bh6_w9_5 :  std_logic;
signal heap_bh6_w8_6 :  std_logic;
signal heap_bh6_w7_5 :  std_logic;
signal heap_bh6_w6_5, heap_bh6_w6_5_d1 :  std_logic;
signal heap_bh6_w5_6 :  std_logic;
signal heap_bh6_w4_5, heap_bh6_w4_5_d1 :  std_logic;
signal heap_bh6_w3_5 :  std_logic;
signal heap_bh6_w2_5 :  std_logic;
signal CompressorIn_bh6_0_0 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_0_0 :  std_logic_vector(2 downto 0);
signal heap_bh6_w2_6 :  std_logic;
signal heap_bh6_w3_6 :  std_logic;
signal heap_bh6_w4_6 :  std_logic;
signal CompressorIn_bh6_1_1 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_1_1 :  std_logic_vector(2 downto 0);
signal heap_bh6_w5_7 :  std_logic;
signal heap_bh6_w6_6 :  std_logic;
signal heap_bh6_w7_6 :  std_logic;
signal CompressorIn_bh6_2_2 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_2_2 :  std_logic_vector(2 downto 0);
signal heap_bh6_w8_7 :  std_logic;
signal heap_bh6_w9_6 :  std_logic;
signal heap_bh6_w10_6 :  std_logic;
signal CompressorIn_bh6_3_3 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_3_3 :  std_logic_vector(2 downto 0);
signal heap_bh6_w11_7 :  std_logic;
signal heap_bh6_w12_6 :  std_logic;
signal heap_bh6_w13_6 :  std_logic;
signal CompressorIn_bh6_4_4 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_4_4 :  std_logic_vector(2 downto 0);
signal heap_bh6_w14_7 :  std_logic;
signal heap_bh6_w15_6 :  std_logic;
signal heap_bh6_w16_6 :  std_logic;
signal CompressorIn_bh6_5_5 :  std_logic_vector(5 downto 0);
signal CompressorOut_bh6_5_5 :  std_logic_vector(2 downto 0);
signal heap_bh6_w17_7 :  std_logic;
signal heap_bh6_w18_6 :  std_logic;
signal heap_bh6_w19_6 :  std_logic;
signal CompressorIn_bh6_6_6 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_6_7 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_6_6 :  std_logic_vector(2 downto 0);
signal heap_bh6_w0_4 :  std_logic;
signal heap_bh6_w1_4, heap_bh6_w1_4_d1 :  std_logic;
signal heap_bh6_w2_7 :  std_logic;
signal CompressorIn_bh6_7_8 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_7_9 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_7_7 :  std_logic_vector(2 downto 0);
signal heap_bh6_w3_7 :  std_logic;
signal heap_bh6_w4_7 :  std_logic;
signal heap_bh6_w5_8 :  std_logic;
signal CompressorIn_bh6_8_10 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_8_11 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_8_8 :  std_logic_vector(2 downto 0);
signal heap_bh6_w6_7 :  std_logic;
signal heap_bh6_w7_7 :  std_logic;
signal heap_bh6_w8_8 :  std_logic;
signal CompressorIn_bh6_9_12 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_9_13 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_9_9 :  std_logic_vector(2 downto 0);
signal heap_bh6_w9_7 :  std_logic;
signal heap_bh6_w10_7 :  std_logic;
signal heap_bh6_w11_8 :  std_logic;
signal CompressorIn_bh6_10_14 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_10_15 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_10_10 :  std_logic_vector(2 downto 0);
signal heap_bh6_w12_7 :  std_logic;
signal heap_bh6_w13_7 :  std_logic;
signal heap_bh6_w14_8 :  std_logic;
signal CompressorIn_bh6_11_16 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_11_17 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_11_11 :  std_logic_vector(2 downto 0);
signal heap_bh6_w15_7 :  std_logic;
signal heap_bh6_w16_7 :  std_logic;
signal heap_bh6_w17_8 :  std_logic;
signal CompressorIn_bh6_12_18 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_12_19 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_12_12 :  std_logic_vector(2 downto 0);
signal heap_bh6_w18_7 :  std_logic;
signal heap_bh6_w19_7 :  std_logic;
signal heap_bh6_w20_6 :  std_logic;
signal CompressorIn_bh6_13_20 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_13_21 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_13_13 :  std_logic_vector(2 downto 0);
signal heap_bh6_w19_8 :  std_logic;
signal heap_bh6_w20_7 :  std_logic;
signal heap_bh6_w21_4 :  std_logic;
signal CompressorIn_bh6_14_22 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_14_23 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_14_14 :  std_logic_vector(2 downto 0);
signal heap_bh6_w20_8 :  std_logic;
signal heap_bh6_w21_5 :  std_logic;
signal heap_bh6_w22_4 :  std_logic;
signal CompressorIn_bh6_15_24 :  std_logic_vector(3 downto 0);
signal CompressorOut_bh6_15_15 :  std_logic_vector(2 downto 0);
signal heap_bh6_w4_8 :  std_logic;
signal heap_bh6_w5_9 :  std_logic;
signal heap_bh6_w6_8 :  std_logic;
signal CompressorIn_bh6_16_25 :  std_logic_vector(3 downto 0);
signal CompressorOut_bh6_16_16 :  std_logic_vector(2 downto 0);
signal heap_bh6_w7_8 :  std_logic;
signal heap_bh6_w8_9 :  std_logic;
signal heap_bh6_w9_8 :  std_logic;
signal CompressorIn_bh6_17_26 :  std_logic_vector(3 downto 0);
signal CompressorOut_bh6_17_17 :  std_logic_vector(2 downto 0);
signal heap_bh6_w10_8 :  std_logic;
signal heap_bh6_w11_9 :  std_logic;
signal heap_bh6_w12_8 :  std_logic;
signal CompressorIn_bh6_18_27 :  std_logic_vector(3 downto 0);
signal CompressorOut_bh6_18_18 :  std_logic_vector(2 downto 0);
signal heap_bh6_w13_8 :  std_logic;
signal heap_bh6_w14_9 :  std_logic;
signal heap_bh6_w15_8 :  std_logic;
signal CompressorIn_bh6_19_28 :  std_logic_vector(3 downto 0);
signal CompressorOut_bh6_19_19 :  std_logic_vector(2 downto 0);
signal heap_bh6_w16_8 :  std_logic;
signal heap_bh6_w17_9 :  std_logic;
signal heap_bh6_w18_8 :  std_logic;
signal CompressorIn_bh6_20_29 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_20_30 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_20_20 :  std_logic_vector(2 downto 0);
signal heap_bh6_w22_5 :  std_logic;
signal heap_bh6_w23_4 :  std_logic;
signal heap_bh6_w24_2 :  std_logic;
signal CompressorIn_bh6_21_31 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_21_21 :  std_logic_vector(1 downto 0);
signal heap_bh6_w1_5, heap_bh6_w1_5_d1 :  std_logic;
signal heap_bh6_w2_8 :  std_logic;
signal tempR_bh6_0, tempR_bh6_0_d1 :  std_logic;
signal CompressorIn_bh6_22_32 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_22_33 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_22_22 :  std_logic_vector(2 downto 0);
signal heap_bh6_w6_9 :  std_logic;
signal heap_bh6_w7_9 :  std_logic;
signal heap_bh6_w8_10 :  std_logic;
signal CompressorIn_bh6_23_34 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_23_35 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_23_23 :  std_logic_vector(2 downto 0);
signal heap_bh6_w9_9 :  std_logic;
signal heap_bh6_w10_9 :  std_logic;
signal heap_bh6_w11_10 :  std_logic;
signal CompressorIn_bh6_24_36 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_24_37 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_24_24 :  std_logic_vector(2 downto 0);
signal heap_bh6_w12_9 :  std_logic;
signal heap_bh6_w13_9 :  std_logic;
signal heap_bh6_w14_10 :  std_logic;
signal CompressorIn_bh6_25_38 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_25_39 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_25_25 :  std_logic_vector(2 downto 0);
signal heap_bh6_w15_9 :  std_logic;
signal heap_bh6_w16_9 :  std_logic;
signal heap_bh6_w17_10 :  std_logic;
signal CompressorIn_bh6_26_40 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_26_41 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_26_26 :  std_logic_vector(2 downto 0);
signal heap_bh6_w18_9 :  std_logic;
signal heap_bh6_w19_9 :  std_logic;
signal heap_bh6_w20_9 :  std_logic;
signal CompressorIn_bh6_27_42 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_27_43 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_27_27 :  std_logic_vector(2 downto 0);
signal heap_bh6_w21_6 :  std_logic;
signal heap_bh6_w22_6 :  std_logic;
signal heap_bh6_w23_5 :  std_logic;
signal CompressorIn_bh6_28_44 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_28_45 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_28_28 :  std_logic_vector(2 downto 0);
signal heap_bh6_w2_9, heap_bh6_w2_9_d1 :  std_logic;
signal heap_bh6_w3_8 :  std_logic;
signal heap_bh6_w4_9 :  std_logic;
signal CompressorIn_bh6_29_46 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_29_47 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_29_29 :  std_logic_vector(2 downto 0);
signal heap_bh6_w4_10 :  std_logic;
signal heap_bh6_w5_10 :  std_logic;
signal heap_bh6_w6_10 :  std_logic;
signal CompressorIn_bh6_30_48 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_30_30 :  std_logic_vector(1 downto 0);
signal heap_bh6_w8_11 :  std_logic;
signal heap_bh6_w9_10 :  std_logic;
signal CompressorIn_bh6_31_49 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_31_31 :  std_logic_vector(1 downto 0);
signal heap_bh6_w11_11 :  std_logic;
signal heap_bh6_w12_10 :  std_logic;
signal CompressorIn_bh6_32_50 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_32_32 :  std_logic_vector(1 downto 0);
signal heap_bh6_w14_11 :  std_logic;
signal heap_bh6_w15_10 :  std_logic;
signal CompressorIn_bh6_33_51 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_33_33 :  std_logic_vector(1 downto 0);
signal heap_bh6_w17_11 :  std_logic;
signal heap_bh6_w18_10 :  std_logic;
signal CompressorIn_bh6_34_52 :  std_logic_vector(2 downto 0);
signal CompressorOut_bh6_34_34 :  std_logic_vector(1 downto 0);
signal heap_bh6_w20_10 :  std_logic;
signal heap_bh6_w21_7 :  std_logic;
signal CompressorIn_bh6_35_53 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_35_54 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_35_35 :  std_logic_vector(2 downto 0);
signal heap_bh6_w7_10 :  std_logic;
signal heap_bh6_w8_12 :  std_logic;
signal heap_bh6_w9_11 :  std_logic;
signal CompressorIn_bh6_36_55 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_36_56 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_36_36 :  std_logic_vector(2 downto 0);
signal heap_bh6_w10_10 :  std_logic;
signal heap_bh6_w11_12 :  std_logic;
signal heap_bh6_w12_11 :  std_logic;
signal CompressorIn_bh6_37_57 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_37_58 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_37_37 :  std_logic_vector(2 downto 0);
signal heap_bh6_w13_10 :  std_logic;
signal heap_bh6_w14_12 :  std_logic;
signal heap_bh6_w15_11 :  std_logic;
signal CompressorIn_bh6_38_59 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_38_60 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_38_38 :  std_logic_vector(2 downto 0);
signal heap_bh6_w16_10 :  std_logic;
signal heap_bh6_w17_12 :  std_logic;
signal heap_bh6_w18_11 :  std_logic;
signal CompressorIn_bh6_39_61 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_39_62 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_39_39 :  std_logic_vector(2 downto 0);
signal heap_bh6_w19_10 :  std_logic;
signal heap_bh6_w20_11 :  std_logic;
signal heap_bh6_w21_8 :  std_logic;
signal CompressorIn_bh6_40_63 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_40_64 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_40_40 :  std_logic_vector(2 downto 0);
signal heap_bh6_w23_6 :  std_logic;
signal heap_bh6_w24_3 :  std_logic;
signal heap_bh6_w25_2 :  std_logic;
signal CompressorIn_bh6_41_65 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_41_66 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_41_41 :  std_logic_vector(2 downto 0);
signal heap_bh6_w9_12, heap_bh6_w9_12_d1 :  std_logic;
signal heap_bh6_w10_11, heap_bh6_w10_11_d1 :  std_logic;
signal heap_bh6_w11_13 :  std_logic;
signal CompressorIn_bh6_42_67 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_42_68 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_42_42 :  std_logic_vector(2 downto 0);
signal heap_bh6_w12_12 :  std_logic;
signal heap_bh6_w13_11 :  std_logic;
signal heap_bh6_w14_13 :  std_logic;
signal CompressorIn_bh6_43_69 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_43_70 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_43_43 :  std_logic_vector(2 downto 0);
signal heap_bh6_w15_12 :  std_logic;
signal heap_bh6_w16_11 :  std_logic;
signal heap_bh6_w17_13 :  std_logic;
signal CompressorIn_bh6_44_71 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_44_72 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_44_44 :  std_logic_vector(2 downto 0);
signal heap_bh6_w18_12 :  std_logic;
signal heap_bh6_w19_11 :  std_logic;
signal heap_bh6_w20_12 :  std_logic;
signal CompressorIn_bh6_45_73 :  std_logic_vector(3 downto 0);
signal CompressorIn_bh6_45_74 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_45_45 :  std_logic_vector(2 downto 0);
signal heap_bh6_w21_9 :  std_logic;
signal heap_bh6_w22_7 :  std_logic;
signal heap_bh6_w23_7, heap_bh6_w23_7_d1 :  std_logic;
signal CompressorIn_bh6_46_75 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_46_76 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_46_46 :  std_logic_vector(2 downto 0);
signal heap_bh6_w3_9, heap_bh6_w3_9_d1 :  std_logic;
signal heap_bh6_w4_11, heap_bh6_w4_11_d1 :  std_logic;
signal heap_bh6_w5_11, heap_bh6_w5_11_d1 :  std_logic;
signal CompressorIn_bh6_47_77 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_47_78 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_47_47 :  std_logic_vector(2 downto 0);
signal heap_bh6_w5_12, heap_bh6_w5_12_d1 :  std_logic;
signal heap_bh6_w6_11, heap_bh6_w6_11_d1 :  std_logic;
signal heap_bh6_w7_11 :  std_logic;
signal CompressorIn_bh6_48_79 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_48_80 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_48_48 :  std_logic_vector(2 downto 0);
signal heap_bh6_w25_3 :  std_logic;
signal heap_bh6_w26_2, heap_bh6_w26_2_d1 :  std_logic;
signal heap_bh6_w27_1, heap_bh6_w27_1_d1 :  std_logic;
signal CompressorIn_bh6_49_81 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_49_82 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_49_49 :  std_logic_vector(2 downto 0);
signal heap_bh6_w7_12, heap_bh6_w7_12_d1 :  std_logic;
signal heap_bh6_w8_13, heap_bh6_w8_13_d1 :  std_logic;
signal heap_bh6_w9_13, heap_bh6_w9_13_d1 :  std_logic;
signal CompressorIn_bh6_50_83 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_50_84 :  std_logic_vector(1 downto 0);
signal CompressorOut_bh6_50_50 :  std_logic_vector(2 downto 0);
signal heap_bh6_w22_8, heap_bh6_w22_8_d1 :  std_logic;
signal heap_bh6_w23_8, heap_bh6_w23_8_d1 :  std_logic;
signal heap_bh6_w24_4 :  std_logic;
signal CompressorIn_bh6_51_85 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_51_86 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_51_51 :  std_logic_vector(2 downto 0);
signal heap_bh6_w11_14, heap_bh6_w11_14_d1 :  std_logic;
signal heap_bh6_w12_13, heap_bh6_w12_13_d1 :  std_logic;
signal heap_bh6_w13_12 :  std_logic;
signal CompressorIn_bh6_52_87 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_52_88 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_52_52 :  std_logic_vector(2 downto 0);
signal heap_bh6_w14_14 :  std_logic;
signal heap_bh6_w15_13, heap_bh6_w15_13_d1 :  std_logic;
signal heap_bh6_w16_12 :  std_logic;
signal CompressorIn_bh6_53_89 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_53_90 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_53_53 :  std_logic_vector(2 downto 0);
signal heap_bh6_w17_14 :  std_logic;
signal heap_bh6_w18_13, heap_bh6_w18_13_d1 :  std_logic;
signal heap_bh6_w19_12 :  std_logic;
signal CompressorIn_bh6_54_91 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_54_92 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_54_54 :  std_logic_vector(2 downto 0);
signal heap_bh6_w20_13 :  std_logic;
signal heap_bh6_w21_10, heap_bh6_w21_10_d1 :  std_logic;
signal heap_bh6_w22_9, heap_bh6_w22_9_d1 :  std_logic;
signal CompressorIn_bh6_55_93 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_55_94 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_55_55 :  std_logic_vector(2 downto 0);
signal heap_bh6_w13_13, heap_bh6_w13_13_d1 :  std_logic;
signal heap_bh6_w14_15, heap_bh6_w14_15_d1 :  std_logic;
signal heap_bh6_w15_14, heap_bh6_w15_14_d1 :  std_logic;
signal CompressorIn_bh6_56_95 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_56_96 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_56_56 :  std_logic_vector(2 downto 0);
signal heap_bh6_w16_13, heap_bh6_w16_13_d1 :  std_logic;
signal heap_bh6_w17_15, heap_bh6_w17_15_d1 :  std_logic;
signal heap_bh6_w18_14, heap_bh6_w18_14_d1 :  std_logic;
signal CompressorIn_bh6_57_97 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_57_98 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_57_57 :  std_logic_vector(2 downto 0);
signal heap_bh6_w19_13, heap_bh6_w19_13_d1 :  std_logic;
signal heap_bh6_w20_14, heap_bh6_w20_14_d1 :  std_logic;
signal heap_bh6_w21_11, heap_bh6_w21_11_d1 :  std_logic;
signal CompressorIn_bh6_58_99 :  std_logic_vector(2 downto 0);
signal CompressorIn_bh6_58_100 :  std_logic_vector(0 downto 0);
signal CompressorOut_bh6_58_58 :  std_logic_vector(2 downto 0);
signal heap_bh6_w24_5, heap_bh6_w24_5_d1 :  std_logic;
signal heap_bh6_w25_4, heap_bh6_w25_4_d1 :  std_logic;
signal heap_bh6_w26_3, heap_bh6_w26_3_d1 :  std_logic;
signal finalAdderIn0_bh6 :  std_logic_vector(43 downto 0);
signal finalAdderIn1_bh6 :  std_logic_vector(43 downto 0);
signal finalAdderCin_bh6 :  std_logic;
signal finalAdderOut_bh6 :  std_logic_vector(43 downto 0);
signal CompressionResult6 :  std_logic_vector(44 downto 0);
attribute rom_extract: string;
attribute rom_style: string;
attribute rom_extract of SmallMultTableP3x3r6XuYu: component is "yes";
attribute rom_style of SmallMultTableP3x3r6XuYu: component is "distributed";
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            heap_bh6_w43_0_d1 <=  heap_bh6_w43_0;
            heap_bh6_w42_0_d1 <=  heap_bh6_w42_0;
            heap_bh6_w41_0_d1 <=  heap_bh6_w41_0;
            heap_bh6_w40_0_d1 <=  heap_bh6_w40_0;
            heap_bh6_w39_0_d1 <=  heap_bh6_w39_0;
            heap_bh6_w38_0_d1 <=  heap_bh6_w38_0;
            heap_bh6_w37_0_d1 <=  heap_bh6_w37_0;
            heap_bh6_w36_0_d1 <=  heap_bh6_w36_0;
            heap_bh6_w35_0_d1 <=  heap_bh6_w35_0;
            heap_bh6_w34_0_d1 <=  heap_bh6_w34_0;
            heap_bh6_w33_0_d1 <=  heap_bh6_w33_0;
            heap_bh6_w32_0_d1 <=  heap_bh6_w32_0;
            heap_bh6_w31_0_d1 <=  heap_bh6_w31_0;
            heap_bh6_w30_0_d1 <=  heap_bh6_w30_0;
            heap_bh6_w29_0_d1 <=  heap_bh6_w29_0;
            heap_bh6_w28_0_d1 <=  heap_bh6_w28_0;
            heap_bh6_w27_0_d1 <=  heap_bh6_w27_0;
            heap_bh6_w10_5_d1 <=  heap_bh6_w10_5;
            heap_bh6_w6_5_d1 <=  heap_bh6_w6_5;
            heap_bh6_w4_5_d1 <=  heap_bh6_w4_5;
            heap_bh6_w1_4_d1 <=  heap_bh6_w1_4;
            heap_bh6_w1_5_d1 <=  heap_bh6_w1_5;
            tempR_bh6_0_d1 <=  tempR_bh6_0;
            heap_bh6_w2_9_d1 <=  heap_bh6_w2_9;
            heap_bh6_w9_12_d1 <=  heap_bh6_w9_12;
            heap_bh6_w10_11_d1 <=  heap_bh6_w10_11;
            heap_bh6_w23_7_d1 <=  heap_bh6_w23_7;
            heap_bh6_w3_9_d1 <=  heap_bh6_w3_9;
            heap_bh6_w4_11_d1 <=  heap_bh6_w4_11;
            heap_bh6_w5_11_d1 <=  heap_bh6_w5_11;
            heap_bh6_w5_12_d1 <=  heap_bh6_w5_12;
            heap_bh6_w6_11_d1 <=  heap_bh6_w6_11;
            heap_bh6_w26_2_d1 <=  heap_bh6_w26_2;
            heap_bh6_w27_1_d1 <=  heap_bh6_w27_1;
            heap_bh6_w7_12_d1 <=  heap_bh6_w7_12;
            heap_bh6_w8_13_d1 <=  heap_bh6_w8_13;
            heap_bh6_w9_13_d1 <=  heap_bh6_w9_13;
            heap_bh6_w22_8_d1 <=  heap_bh6_w22_8;
            heap_bh6_w23_8_d1 <=  heap_bh6_w23_8;
            heap_bh6_w11_14_d1 <=  heap_bh6_w11_14;
            heap_bh6_w12_13_d1 <=  heap_bh6_w12_13;
            heap_bh6_w15_13_d1 <=  heap_bh6_w15_13;
            heap_bh6_w18_13_d1 <=  heap_bh6_w18_13;
            heap_bh6_w21_10_d1 <=  heap_bh6_w21_10;
            heap_bh6_w22_9_d1 <=  heap_bh6_w22_9;
            heap_bh6_w13_13_d1 <=  heap_bh6_w13_13;
            heap_bh6_w14_15_d1 <=  heap_bh6_w14_15;
            heap_bh6_w15_14_d1 <=  heap_bh6_w15_14;
            heap_bh6_w16_13_d1 <=  heap_bh6_w16_13;
            heap_bh6_w17_15_d1 <=  heap_bh6_w17_15;
            heap_bh6_w18_14_d1 <=  heap_bh6_w18_14;
            heap_bh6_w19_13_d1 <=  heap_bh6_w19_13;
            heap_bh6_w20_14_d1 <=  heap_bh6_w20_14;
            heap_bh6_w21_11_d1 <=  heap_bh6_w21_11;
            heap_bh6_w24_5_d1 <=  heap_bh6_w24_5;
            heap_bh6_w25_4_d1 <=  heap_bh6_w25_4;
            heap_bh6_w26_3_d1 <=  heap_bh6_w26_3;
         end if;
      end process;
   XX_m5 <= X ;
   YY_m5 <= Y ;
   -- code generated by IntMultiplier::buildHeapLogicOnly()
   -- buildheaplogiconly called for lsbX=0 lsbY=0 msbX=24 msbY=7
   Xp_m5b7 <= XX_m5(23 downto 0) & "";
   Yp_m5b7 <= YY_m5(6 downto 0) & "00";
   x_m5b7_0 <= Xp_m5b7(2 downto 0);
   x_m5b7_1 <= Xp_m5b7(5 downto 3);
   x_m5b7_2 <= Xp_m5b7(8 downto 6);
   x_m5b7_3 <= Xp_m5b7(11 downto 9);
   x_m5b7_4 <= Xp_m5b7(14 downto 12);
   x_m5b7_5 <= Xp_m5b7(17 downto 15);
   x_m5b7_6 <= Xp_m5b7(20 downto 18);
   x_m5b7_7 <= Xp_m5b7(23 downto 21);
   y_m5b7_0 <= Yp_m5b7(2 downto 0);
   y_m5b7_1 <= Yp_m5b7(5 downto 3);
   y_m5b7_2 <= Yp_m5b7(8 downto 6);
   ----------------Synchro barrier, entering cycle 0----------------
   -- Partial product row number 0
   Y0X1_7_m5 <= y_m5b7_0 & x_m5b7_1;
   PP_m5_7X1Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X1_7_m5,
                 Y => PP7X1Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w0_0 <= PP7X1Y0_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w1_0 <= PP7X1Y0_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w2_0 <= PP7X1Y0_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y0X2_7_m5 <= y_m5b7_0 & x_m5b7_2;
   PP_m5_7X2Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X2_7_m5,
                 Y => PP7X2Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w2_1 <= PP7X2Y0_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w3_0 <= PP7X2Y0_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w4_0 <= PP7X2Y0_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w5_0 <= PP7X2Y0_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y0X3_7_m5 <= y_m5b7_0 & x_m5b7_3;
   PP_m5_7X3Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X3_7_m5,
                 Y => PP7X3Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w5_1 <= PP7X3Y0_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w6_0 <= PP7X3Y0_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w7_0 <= PP7X3Y0_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w8_0 <= PP7X3Y0_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y0X4_7_m5 <= y_m5b7_0 & x_m5b7_4;
   PP_m5_7X4Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X4_7_m5,
                 Y => PP7X4Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w8_1 <= PP7X4Y0_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w9_0 <= PP7X4Y0_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w10_0 <= PP7X4Y0_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w11_0 <= PP7X4Y0_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y0X5_7_m5 <= y_m5b7_0 & x_m5b7_5;
   PP_m5_7X5Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X5_7_m5,
                 Y => PP7X5Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w11_1 <= PP7X5Y0_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w12_0 <= PP7X5Y0_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w13_0 <= PP7X5Y0_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w14_0 <= PP7X5Y0_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y0X6_7_m5 <= y_m5b7_0 & x_m5b7_6;
   PP_m5_7X6Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X6_7_m5,
                 Y => PP7X6Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w14_1 <= PP7X6Y0_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w15_0 <= PP7X6Y0_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w16_0 <= PP7X6Y0_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w17_0 <= PP7X6Y0_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y0X7_7_m5 <= y_m5b7_0 & x_m5b7_7;
   PP_m5_7X7Y0_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y0X7_7_m5,
                 Y => PP7X7Y0_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w17_1 <= PP7X7Y0_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w18_0 <= PP7X7Y0_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w19_0 <= PP7X7Y0_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w20_0 <= PP7X7Y0_m5(5); -- cycle= 0 cp= 5.9176e-10

   -- Partial product row number 1
   Y1X0_7_m5 <= y_m5b7_1 & x_m5b7_0;
   PP_m5_7X0Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X0_7_m5,
                 Y => PP7X0Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w0_1 <= PP7X0Y1_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w1_1 <= PP7X0Y1_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w2_2 <= PP7X0Y1_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y1X1_7_m5 <= y_m5b7_1 & x_m5b7_1;
   PP_m5_7X1Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X1_7_m5,
                 Y => PP7X1Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w0_2 <= PP7X1Y1_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w1_2 <= PP7X1Y1_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w2_3 <= PP7X1Y1_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w3_1 <= PP7X1Y1_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w4_1 <= PP7X1Y1_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w5_2 <= PP7X1Y1_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y1X2_7_m5 <= y_m5b7_1 & x_m5b7_2;
   PP_m5_7X2Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X2_7_m5,
                 Y => PP7X2Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w3_2 <= PP7X2Y1_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w4_2 <= PP7X2Y1_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w5_3 <= PP7X2Y1_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w6_1 <= PP7X2Y1_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w7_1 <= PP7X2Y1_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w8_2 <= PP7X2Y1_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y1X3_7_m5 <= y_m5b7_1 & x_m5b7_3;
   PP_m5_7X3Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X3_7_m5,
                 Y => PP7X3Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w6_2 <= PP7X3Y1_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w7_2 <= PP7X3Y1_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w8_3 <= PP7X3Y1_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w9_1 <= PP7X3Y1_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w10_1 <= PP7X3Y1_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w11_2 <= PP7X3Y1_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y1X4_7_m5 <= y_m5b7_1 & x_m5b7_4;
   PP_m5_7X4Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X4_7_m5,
                 Y => PP7X4Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w9_2 <= PP7X4Y1_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w10_2 <= PP7X4Y1_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w11_3 <= PP7X4Y1_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w12_1 <= PP7X4Y1_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w13_1 <= PP7X4Y1_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w14_2 <= PP7X4Y1_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y1X5_7_m5 <= y_m5b7_1 & x_m5b7_5;
   PP_m5_7X5Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X5_7_m5,
                 Y => PP7X5Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w12_2 <= PP7X5Y1_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w13_2 <= PP7X5Y1_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w14_3 <= PP7X5Y1_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w15_1 <= PP7X5Y1_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w16_1 <= PP7X5Y1_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w17_2 <= PP7X5Y1_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y1X6_7_m5 <= y_m5b7_1 & x_m5b7_6;
   PP_m5_7X6Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X6_7_m5,
                 Y => PP7X6Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w15_2 <= PP7X6Y1_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w16_2 <= PP7X6Y1_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w17_3 <= PP7X6Y1_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w18_1 <= PP7X6Y1_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w19_1 <= PP7X6Y1_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w20_1 <= PP7X6Y1_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y1X7_7_m5 <= y_m5b7_1 & x_m5b7_7;
   PP_m5_7X7Y1_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y1X7_7_m5,
                 Y => PP7X7Y1_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w18_2 <= PP7X7Y1_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w19_2 <= PP7X7Y1_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w20_2 <= PP7X7Y1_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w21_0 <= PP7X7Y1_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w22_0 <= PP7X7Y1_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w23_0 <= PP7X7Y1_m5(5); -- cycle= 0 cp= 5.9176e-10

   -- Partial product row number 2
   Y2X0_7_m5 <= y_m5b7_2 & x_m5b7_0;
   PP_m5_7X0Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X0_7_m5,
                 Y => PP7X0Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w0_3 <= PP7X0Y2_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w1_3 <= PP7X0Y2_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w2_4 <= PP7X0Y2_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w3_3 <= PP7X0Y2_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w4_3 <= PP7X0Y2_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w5_4 <= PP7X0Y2_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y2X1_7_m5 <= y_m5b7_2 & x_m5b7_1;
   PP_m5_7X1Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X1_7_m5,
                 Y => PP7X1Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w3_4 <= PP7X1Y2_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w4_4 <= PP7X1Y2_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w5_5 <= PP7X1Y2_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w6_3 <= PP7X1Y2_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w7_3 <= PP7X1Y2_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w8_4 <= PP7X1Y2_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y2X2_7_m5 <= y_m5b7_2 & x_m5b7_2;
   PP_m5_7X2Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X2_7_m5,
                 Y => PP7X2Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w6_4 <= PP7X2Y2_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w7_4 <= PP7X2Y2_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w8_5 <= PP7X2Y2_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w9_3 <= PP7X2Y2_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w10_3 <= PP7X2Y2_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w11_4 <= PP7X2Y2_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y2X3_7_m5 <= y_m5b7_2 & x_m5b7_3;
   PP_m5_7X3Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X3_7_m5,
                 Y => PP7X3Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w9_4 <= PP7X3Y2_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w10_4 <= PP7X3Y2_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w11_5 <= PP7X3Y2_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w12_3 <= PP7X3Y2_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w13_3 <= PP7X3Y2_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w14_4 <= PP7X3Y2_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y2X4_7_m5 <= y_m5b7_2 & x_m5b7_4;
   PP_m5_7X4Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X4_7_m5,
                 Y => PP7X4Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w12_4 <= PP7X4Y2_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w13_4 <= PP7X4Y2_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w14_5 <= PP7X4Y2_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w15_3 <= PP7X4Y2_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w16_3 <= PP7X4Y2_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w17_4 <= PP7X4Y2_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y2X5_7_m5 <= y_m5b7_2 & x_m5b7_5;
   PP_m5_7X5Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X5_7_m5,
                 Y => PP7X5Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w15_4 <= PP7X5Y2_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w16_4 <= PP7X5Y2_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w17_5 <= PP7X5Y2_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w18_3 <= PP7X5Y2_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w19_3 <= PP7X5Y2_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w20_3 <= PP7X5Y2_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y2X6_7_m5 <= y_m5b7_2 & x_m5b7_6;
   PP_m5_7X6Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X6_7_m5,
                 Y => PP7X6Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w18_4 <= PP7X6Y2_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w19_4 <= PP7X6Y2_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w20_4 <= PP7X6Y2_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w21_1 <= PP7X6Y2_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w22_1 <= PP7X6Y2_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w23_1 <= PP7X6Y2_m5(5); -- cycle= 0 cp= 5.9176e-10

   Y2X7_7_m5 <= y_m5b7_2 & x_m5b7_7;
   PP_m5_7X7Y2_Tbl: SmallMultTableP3x3r6XuYu  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 X => Y2X7_7_m5,
                 Y => PP7X7Y2_m5);
   -- Adding the relevant bits to the heap of bits
   heap_bh6_w21_2 <= PP7X7Y2_m5(0); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w22_2 <= PP7X7Y2_m5(1); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w23_2 <= PP7X7Y2_m5(2); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w24_0 <= PP7X7Y2_m5(3); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w25_0 <= PP7X7Y2_m5(4); -- cycle= 0 cp= 5.9176e-10
   heap_bh6_w26_0 <= PP7X7Y2_m5(5); -- cycle= 0 cp= 5.9176e-10


   -- Beginning of code generated by BitHeap::generateCompressorVHDL
   -- code generated by BitHeap::generateSupertileVHDL()
   ----------------Synchro barrier, entering cycle 0----------------
   DSP_bh6_ch0_0 <= std_logic_vector(unsigned("" & XX_m5(23 downto 0) & "") * unsigned("" & YY_m5(23 downto 7) & ""));
   heap_bh6_w43_0 <= DSP_bh6_ch0_0(40); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w42_0 <= DSP_bh6_ch0_0(39); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w41_0 <= DSP_bh6_ch0_0(38); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w40_0 <= DSP_bh6_ch0_0(37); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w39_0 <= DSP_bh6_ch0_0(36); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w38_0 <= DSP_bh6_ch0_0(35); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w37_0 <= DSP_bh6_ch0_0(34); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w36_0 <= DSP_bh6_ch0_0(33); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w35_0 <= DSP_bh6_ch0_0(32); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w34_0 <= DSP_bh6_ch0_0(31); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w33_0 <= DSP_bh6_ch0_0(30); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w32_0 <= DSP_bh6_ch0_0(29); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w31_0 <= DSP_bh6_ch0_0(28); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w30_0 <= DSP_bh6_ch0_0(27); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w29_0 <= DSP_bh6_ch0_0(26); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w28_0 <= DSP_bh6_ch0_0(25); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w27_0 <= DSP_bh6_ch0_0(24); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w26_1 <= DSP_bh6_ch0_0(23); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w25_1 <= DSP_bh6_ch0_0(22); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w24_1 <= DSP_bh6_ch0_0(21); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w23_3 <= DSP_bh6_ch0_0(20); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w22_3 <= DSP_bh6_ch0_0(19); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w21_3 <= DSP_bh6_ch0_0(18); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w20_5 <= DSP_bh6_ch0_0(17); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w19_5 <= DSP_bh6_ch0_0(16); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w18_5 <= DSP_bh6_ch0_0(15); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w17_6 <= DSP_bh6_ch0_0(14); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w16_5 <= DSP_bh6_ch0_0(13); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w15_5 <= DSP_bh6_ch0_0(12); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w14_6 <= DSP_bh6_ch0_0(11); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w13_5 <= DSP_bh6_ch0_0(10); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w12_5 <= DSP_bh6_ch0_0(9); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w11_6 <= DSP_bh6_ch0_0(8); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w10_5 <= DSP_bh6_ch0_0(7); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w9_5 <= DSP_bh6_ch0_0(6); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w8_6 <= DSP_bh6_ch0_0(5); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w7_5 <= DSP_bh6_ch0_0(4); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w6_5 <= DSP_bh6_ch0_0(3); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w5_6 <= DSP_bh6_ch0_0(2); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w4_5 <= DSP_bh6_ch0_0(1); -- cycle= 0 cp= 2.387e-09
   heap_bh6_w3_5 <= DSP_bh6_ch0_0(0); -- cycle= 0 cp= 2.387e-09
   ----------------Synchro barrier, entering cycle 0----------------

   -- Adding the constant bits
   heap_bh6_w2_5 <= '1'; -- cycle= 0 cp= 0

   ----------------Synchro barrier, entering cycle 0----------------

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_0_0 <= heap_bh6_w2_5 & heap_bh6_w2_4 & heap_bh6_w2_3 & heap_bh6_w2_2 & heap_bh6_w2_1 & heap_bh6_w2_0;
   Compressor_bh6_0: Compressor_6_3
      port map ( R => CompressorOut_bh6_0_0   ,
                 X0 => CompressorIn_bh6_0_0);
   heap_bh6_w2_6 <= CompressorOut_bh6_0_0(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w3_6 <= CompressorOut_bh6_0_0(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w4_6 <= CompressorOut_bh6_0_0(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_1_1 <= heap_bh6_w5_5 & heap_bh6_w5_4 & heap_bh6_w5_3 & heap_bh6_w5_2 & heap_bh6_w5_1 & heap_bh6_w5_0;
   Compressor_bh6_1: Compressor_6_3
      port map ( R => CompressorOut_bh6_1_1   ,
                 X0 => CompressorIn_bh6_1_1);
   heap_bh6_w5_7 <= CompressorOut_bh6_1_1(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w6_6 <= CompressorOut_bh6_1_1(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w7_6 <= CompressorOut_bh6_1_1(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_2_2 <= heap_bh6_w8_5 & heap_bh6_w8_4 & heap_bh6_w8_3 & heap_bh6_w8_2 & heap_bh6_w8_1 & heap_bh6_w8_0;
   Compressor_bh6_2: Compressor_6_3
      port map ( R => CompressorOut_bh6_2_2   ,
                 X0 => CompressorIn_bh6_2_2);
   heap_bh6_w8_7 <= CompressorOut_bh6_2_2(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w9_6 <= CompressorOut_bh6_2_2(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w10_6 <= CompressorOut_bh6_2_2(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_3_3 <= heap_bh6_w11_5 & heap_bh6_w11_4 & heap_bh6_w11_3 & heap_bh6_w11_2 & heap_bh6_w11_1 & heap_bh6_w11_0;
   Compressor_bh6_3: Compressor_6_3
      port map ( R => CompressorOut_bh6_3_3   ,
                 X0 => CompressorIn_bh6_3_3);
   heap_bh6_w11_7 <= CompressorOut_bh6_3_3(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w12_6 <= CompressorOut_bh6_3_3(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w13_6 <= CompressorOut_bh6_3_3(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_4_4 <= heap_bh6_w14_5 & heap_bh6_w14_4 & heap_bh6_w14_3 & heap_bh6_w14_2 & heap_bh6_w14_1 & heap_bh6_w14_0;
   Compressor_bh6_4: Compressor_6_3
      port map ( R => CompressorOut_bh6_4_4   ,
                 X0 => CompressorIn_bh6_4_4);
   heap_bh6_w14_7 <= CompressorOut_bh6_4_4(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w15_6 <= CompressorOut_bh6_4_4(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w16_6 <= CompressorOut_bh6_4_4(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_5_5 <= heap_bh6_w17_5 & heap_bh6_w17_4 & heap_bh6_w17_3 & heap_bh6_w17_2 & heap_bh6_w17_1 & heap_bh6_w17_0;
   Compressor_bh6_5: Compressor_6_3
      port map ( R => CompressorOut_bh6_5_5   ,
                 X0 => CompressorIn_bh6_5_5);
   heap_bh6_w17_7 <= CompressorOut_bh6_5_5(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w18_6 <= CompressorOut_bh6_5_5(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w19_6 <= CompressorOut_bh6_5_5(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_6_6 <= heap_bh6_w0_3 & heap_bh6_w0_2 & heap_bh6_w0_1 & heap_bh6_w0_0;
   CompressorIn_bh6_6_7(0) <= heap_bh6_w1_3;
   Compressor_bh6_6: Compressor_14_3
      port map ( R => CompressorOut_bh6_6_6   ,
                 X0 => CompressorIn_bh6_6_6,
                 X1 => CompressorIn_bh6_6_7);
   heap_bh6_w0_4 <= CompressorOut_bh6_6_6(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w1_4 <= CompressorOut_bh6_6_6(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w2_7 <= CompressorOut_bh6_6_6(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_7_8 <= heap_bh6_w3_4 & heap_bh6_w3_3 & heap_bh6_w3_2 & heap_bh6_w3_1;
   CompressorIn_bh6_7_9(0) <= heap_bh6_w4_4;
   Compressor_bh6_7: Compressor_14_3
      port map ( R => CompressorOut_bh6_7_7   ,
                 X0 => CompressorIn_bh6_7_8,
                 X1 => CompressorIn_bh6_7_9);
   heap_bh6_w3_7 <= CompressorOut_bh6_7_7(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w4_7 <= CompressorOut_bh6_7_7(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w5_8 <= CompressorOut_bh6_7_7(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_8_10 <= heap_bh6_w6_4 & heap_bh6_w6_3 & heap_bh6_w6_2 & heap_bh6_w6_1;
   CompressorIn_bh6_8_11(0) <= heap_bh6_w7_4;
   Compressor_bh6_8: Compressor_14_3
      port map ( R => CompressorOut_bh6_8_8   ,
                 X0 => CompressorIn_bh6_8_10,
                 X1 => CompressorIn_bh6_8_11);
   heap_bh6_w6_7 <= CompressorOut_bh6_8_8(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w7_7 <= CompressorOut_bh6_8_8(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w8_8 <= CompressorOut_bh6_8_8(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_9_12 <= heap_bh6_w9_4 & heap_bh6_w9_3 & heap_bh6_w9_2 & heap_bh6_w9_1;
   CompressorIn_bh6_9_13(0) <= heap_bh6_w10_4;
   Compressor_bh6_9: Compressor_14_3
      port map ( R => CompressorOut_bh6_9_9   ,
                 X0 => CompressorIn_bh6_9_12,
                 X1 => CompressorIn_bh6_9_13);
   heap_bh6_w9_7 <= CompressorOut_bh6_9_9(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w10_7 <= CompressorOut_bh6_9_9(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w11_8 <= CompressorOut_bh6_9_9(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_10_14 <= heap_bh6_w12_4 & heap_bh6_w12_3 & heap_bh6_w12_2 & heap_bh6_w12_1;
   CompressorIn_bh6_10_15(0) <= heap_bh6_w13_4;
   Compressor_bh6_10: Compressor_14_3
      port map ( R => CompressorOut_bh6_10_10   ,
                 X0 => CompressorIn_bh6_10_14,
                 X1 => CompressorIn_bh6_10_15);
   heap_bh6_w12_7 <= CompressorOut_bh6_10_10(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w13_7 <= CompressorOut_bh6_10_10(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w14_8 <= CompressorOut_bh6_10_10(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_11_16 <= heap_bh6_w15_4 & heap_bh6_w15_3 & heap_bh6_w15_2 & heap_bh6_w15_1;
   CompressorIn_bh6_11_17(0) <= heap_bh6_w16_4;
   Compressor_bh6_11: Compressor_14_3
      port map ( R => CompressorOut_bh6_11_11   ,
                 X0 => CompressorIn_bh6_11_16,
                 X1 => CompressorIn_bh6_11_17);
   heap_bh6_w15_7 <= CompressorOut_bh6_11_11(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w16_7 <= CompressorOut_bh6_11_11(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w17_8 <= CompressorOut_bh6_11_11(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_12_18 <= heap_bh6_w18_4 & heap_bh6_w18_3 & heap_bh6_w18_2 & heap_bh6_w18_1;
   CompressorIn_bh6_12_19(0) <= heap_bh6_w19_4;
   Compressor_bh6_12: Compressor_14_3
      port map ( R => CompressorOut_bh6_12_12   ,
                 X0 => CompressorIn_bh6_12_18,
                 X1 => CompressorIn_bh6_12_19);
   heap_bh6_w18_7 <= CompressorOut_bh6_12_12(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w19_7 <= CompressorOut_bh6_12_12(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w20_6 <= CompressorOut_bh6_12_12(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_13_20 <= heap_bh6_w19_3 & heap_bh6_w19_2 & heap_bh6_w19_1 & heap_bh6_w19_0;
   CompressorIn_bh6_13_21(0) <= heap_bh6_w20_4;
   Compressor_bh6_13: Compressor_14_3
      port map ( R => CompressorOut_bh6_13_13   ,
                 X0 => CompressorIn_bh6_13_20,
                 X1 => CompressorIn_bh6_13_21);
   heap_bh6_w19_8 <= CompressorOut_bh6_13_13(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w20_7 <= CompressorOut_bh6_13_13(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w21_4 <= CompressorOut_bh6_13_13(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_14_22 <= heap_bh6_w20_3 & heap_bh6_w20_2 & heap_bh6_w20_1 & heap_bh6_w20_0;
   CompressorIn_bh6_14_23(0) <= heap_bh6_w21_2;
   Compressor_bh6_14: Compressor_14_3
      port map ( R => CompressorOut_bh6_14_14   ,
                 X0 => CompressorIn_bh6_14_22,
                 X1 => CompressorIn_bh6_14_23);
   heap_bh6_w20_8 <= CompressorOut_bh6_14_14(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w21_5 <= CompressorOut_bh6_14_14(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w22_4 <= CompressorOut_bh6_14_14(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_15_24 <= heap_bh6_w4_3 & heap_bh6_w4_2 & heap_bh6_w4_1 & heap_bh6_w4_0;
   Compressor_bh6_15: Compressor_4_3
      port map ( R => CompressorOut_bh6_15_15   ,
                 X0 => CompressorIn_bh6_15_24);
   heap_bh6_w4_8 <= CompressorOut_bh6_15_15(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w5_9 <= CompressorOut_bh6_15_15(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w6_8 <= CompressorOut_bh6_15_15(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_16_25 <= heap_bh6_w7_3 & heap_bh6_w7_2 & heap_bh6_w7_1 & heap_bh6_w7_0;
   Compressor_bh6_16: Compressor_4_3
      port map ( R => CompressorOut_bh6_16_16   ,
                 X0 => CompressorIn_bh6_16_25);
   heap_bh6_w7_8 <= CompressorOut_bh6_16_16(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w8_9 <= CompressorOut_bh6_16_16(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w9_8 <= CompressorOut_bh6_16_16(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_17_26 <= heap_bh6_w10_3 & heap_bh6_w10_2 & heap_bh6_w10_1 & heap_bh6_w10_0;
   Compressor_bh6_17: Compressor_4_3
      port map ( R => CompressorOut_bh6_17_17   ,
                 X0 => CompressorIn_bh6_17_26);
   heap_bh6_w10_8 <= CompressorOut_bh6_17_17(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w11_9 <= CompressorOut_bh6_17_17(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w12_8 <= CompressorOut_bh6_17_17(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_18_27 <= heap_bh6_w13_3 & heap_bh6_w13_2 & heap_bh6_w13_1 & heap_bh6_w13_0;
   Compressor_bh6_18: Compressor_4_3
      port map ( R => CompressorOut_bh6_18_18   ,
                 X0 => CompressorIn_bh6_18_27);
   heap_bh6_w13_8 <= CompressorOut_bh6_18_18(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w14_9 <= CompressorOut_bh6_18_18(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w15_8 <= CompressorOut_bh6_18_18(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_19_28 <= heap_bh6_w16_3 & heap_bh6_w16_2 & heap_bh6_w16_1 & heap_bh6_w16_0;
   Compressor_bh6_19: Compressor_4_3
      port map ( R => CompressorOut_bh6_19_19   ,
                 X0 => CompressorIn_bh6_19_28);
   heap_bh6_w16_8 <= CompressorOut_bh6_19_19(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w17_9 <= CompressorOut_bh6_19_19(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w18_8 <= CompressorOut_bh6_19_19(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_20_29 <= heap_bh6_w22_2 & heap_bh6_w22_1 & heap_bh6_w22_0;
   CompressorIn_bh6_20_30 <= heap_bh6_w23_2 & heap_bh6_w23_1;
   Compressor_bh6_20: Compressor_23_3
      port map ( R => CompressorOut_bh6_20_20   ,
                 X0 => CompressorIn_bh6_20_29,
                 X1 => CompressorIn_bh6_20_30);
   heap_bh6_w22_5 <= CompressorOut_bh6_20_20(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w23_4 <= CompressorOut_bh6_20_20(1); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w24_2 <= CompressorOut_bh6_20_20(2); -- cycle= 0 cp= 1.12248e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_21_31 <= heap_bh6_w1_2 & heap_bh6_w1_1 & heap_bh6_w1_0;
   Compressor_bh6_21: Compressor_3_2
      port map ( R => CompressorOut_bh6_21_21   ,
                 X0 => CompressorIn_bh6_21_31);
   heap_bh6_w1_5 <= CompressorOut_bh6_21_21(0); -- cycle= 0 cp= 1.12248e-09
   heap_bh6_w2_8 <= CompressorOut_bh6_21_21(1); -- cycle= 0 cp= 1.12248e-09
   ----------------Synchro barrier, entering cycle 0----------------
   tempR_bh6_0 <= heap_bh6_w0_4; -- already compressed

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_22_32 <= heap_bh6_w6_0 & heap_bh6_w6_8 & heap_bh6_w6_7 & heap_bh6_w6_6;
   CompressorIn_bh6_22_33(0) <= heap_bh6_w7_8;
   Compressor_bh6_22: Compressor_14_3
      port map ( R => CompressorOut_bh6_22_22   ,
                 X0 => CompressorIn_bh6_22_32,
                 X1 => CompressorIn_bh6_22_33);
   heap_bh6_w6_9 <= CompressorOut_bh6_22_22(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w7_9 <= CompressorOut_bh6_22_22(1); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w8_10 <= CompressorOut_bh6_22_22(2); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_23_34 <= heap_bh6_w9_0 & heap_bh6_w9_8 & heap_bh6_w9_7 & heap_bh6_w9_6;
   CompressorIn_bh6_23_35(0) <= heap_bh6_w10_8;
   Compressor_bh6_23: Compressor_14_3
      port map ( R => CompressorOut_bh6_23_23   ,
                 X0 => CompressorIn_bh6_23_34,
                 X1 => CompressorIn_bh6_23_35);
   heap_bh6_w9_9 <= CompressorOut_bh6_23_23(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w10_9 <= CompressorOut_bh6_23_23(1); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w11_10 <= CompressorOut_bh6_23_23(2); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_24_36 <= heap_bh6_w12_0 & heap_bh6_w12_8 & heap_bh6_w12_7 & heap_bh6_w12_6;
   CompressorIn_bh6_24_37(0) <= heap_bh6_w13_8;
   Compressor_bh6_24: Compressor_14_3
      port map ( R => CompressorOut_bh6_24_24   ,
                 X0 => CompressorIn_bh6_24_36,
                 X1 => CompressorIn_bh6_24_37);
   heap_bh6_w12_9 <= CompressorOut_bh6_24_24(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w13_9 <= CompressorOut_bh6_24_24(1); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w14_10 <= CompressorOut_bh6_24_24(2); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_25_38 <= heap_bh6_w15_0 & heap_bh6_w15_8 & heap_bh6_w15_7 & heap_bh6_w15_6;
   CompressorIn_bh6_25_39(0) <= heap_bh6_w16_8;
   Compressor_bh6_25: Compressor_14_3
      port map ( R => CompressorOut_bh6_25_25   ,
                 X0 => CompressorIn_bh6_25_38,
                 X1 => CompressorIn_bh6_25_39);
   heap_bh6_w15_9 <= CompressorOut_bh6_25_25(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w16_9 <= CompressorOut_bh6_25_25(1); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w17_10 <= CompressorOut_bh6_25_25(2); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_26_40 <= heap_bh6_w18_0 & heap_bh6_w18_8 & heap_bh6_w18_7 & heap_bh6_w18_6;
   CompressorIn_bh6_26_41(0) <= heap_bh6_w19_8;
   Compressor_bh6_26: Compressor_14_3
      port map ( R => CompressorOut_bh6_26_26   ,
                 X0 => CompressorIn_bh6_26_40,
                 X1 => CompressorIn_bh6_26_41);
   heap_bh6_w18_9 <= CompressorOut_bh6_26_26(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w19_9 <= CompressorOut_bh6_26_26(1); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w20_9 <= CompressorOut_bh6_26_26(2); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_27_42 <= heap_bh6_w21_1 & heap_bh6_w21_0 & heap_bh6_w21_5 & heap_bh6_w21_4;
   CompressorIn_bh6_27_43(0) <= heap_bh6_w22_5;
   Compressor_bh6_27: Compressor_14_3
      port map ( R => CompressorOut_bh6_27_27   ,
                 X0 => CompressorIn_bh6_27_42,
                 X1 => CompressorIn_bh6_27_43);
   heap_bh6_w21_6 <= CompressorOut_bh6_27_27(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w22_6 <= CompressorOut_bh6_27_27(1); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w23_5 <= CompressorOut_bh6_27_27(2); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_28_44 <= heap_bh6_w2_8 & heap_bh6_w2_7 & heap_bh6_w2_6;
   CompressorIn_bh6_28_45 <= heap_bh6_w3_0 & heap_bh6_w3_7;
   Compressor_bh6_28: Compressor_23_3
      port map ( R => CompressorOut_bh6_28_28   ,
                 X0 => CompressorIn_bh6_28_44,
                 X1 => CompressorIn_bh6_28_45);
   heap_bh6_w2_9 <= CompressorOut_bh6_28_28(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w3_8 <= CompressorOut_bh6_28_28(1); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w4_9 <= CompressorOut_bh6_28_28(2); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_29_46 <= heap_bh6_w4_8 & heap_bh6_w4_7 & heap_bh6_w4_6;
   CompressorIn_bh6_29_47 <= heap_bh6_w5_9 & heap_bh6_w5_8;
   Compressor_bh6_29: Compressor_23_3
      port map ( R => CompressorOut_bh6_29_29   ,
                 X0 => CompressorIn_bh6_29_46,
                 X1 => CompressorIn_bh6_29_47);
   heap_bh6_w4_10 <= CompressorOut_bh6_29_29(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w5_10 <= CompressorOut_bh6_29_29(1); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w6_10 <= CompressorOut_bh6_29_29(2); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_30_48 <= heap_bh6_w8_9 & heap_bh6_w8_8 & heap_bh6_w8_7;
   Compressor_bh6_30: Compressor_3_2
      port map ( R => CompressorOut_bh6_30_30   ,
                 X0 => CompressorIn_bh6_30_48);
   heap_bh6_w8_11 <= CompressorOut_bh6_30_30(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w9_10 <= CompressorOut_bh6_30_30(1); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_31_49 <= heap_bh6_w11_9 & heap_bh6_w11_8 & heap_bh6_w11_7;
   Compressor_bh6_31: Compressor_3_2
      port map ( R => CompressorOut_bh6_31_31   ,
                 X0 => CompressorIn_bh6_31_49);
   heap_bh6_w11_11 <= CompressorOut_bh6_31_31(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w12_10 <= CompressorOut_bh6_31_31(1); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_32_50 <= heap_bh6_w14_9 & heap_bh6_w14_8 & heap_bh6_w14_7;
   Compressor_bh6_32: Compressor_3_2
      port map ( R => CompressorOut_bh6_32_32   ,
                 X0 => CompressorIn_bh6_32_50);
   heap_bh6_w14_11 <= CompressorOut_bh6_32_32(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w15_10 <= CompressorOut_bh6_32_32(1); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_33_51 <= heap_bh6_w17_9 & heap_bh6_w17_8 & heap_bh6_w17_7;
   Compressor_bh6_33: Compressor_3_2
      port map ( R => CompressorOut_bh6_33_33   ,
                 X0 => CompressorIn_bh6_33_51);
   heap_bh6_w17_11 <= CompressorOut_bh6_33_33(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w18_10 <= CompressorOut_bh6_33_33(1); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_34_52 <= heap_bh6_w20_8 & heap_bh6_w20_7 & heap_bh6_w20_6;
   Compressor_bh6_34: Compressor_3_2
      port map ( R => CompressorOut_bh6_34_34   ,
                 X0 => CompressorIn_bh6_34_52);
   heap_bh6_w20_10 <= CompressorOut_bh6_34_34(0); -- cycle= 0 cp= 1.6532e-09
   heap_bh6_w21_7 <= CompressorOut_bh6_34_34(1); -- cycle= 0 cp= 1.6532e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_35_53 <= heap_bh6_w7_7 & heap_bh6_w7_6 & heap_bh6_w7_9;
   CompressorIn_bh6_35_54 <= heap_bh6_w8_11 & heap_bh6_w8_10;
   Compressor_bh6_35: Compressor_23_3
      port map ( R => CompressorOut_bh6_35_35   ,
                 X0 => CompressorIn_bh6_35_53,
                 X1 => CompressorIn_bh6_35_54);
   heap_bh6_w7_10 <= CompressorOut_bh6_35_35(0); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w8_12 <= CompressorOut_bh6_35_35(1); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w9_11 <= CompressorOut_bh6_35_35(2); -- cycle= 0 cp= 2.18392e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_36_55 <= heap_bh6_w10_7 & heap_bh6_w10_6 & heap_bh6_w10_9;
   CompressorIn_bh6_36_56 <= heap_bh6_w11_11 & heap_bh6_w11_10;
   Compressor_bh6_36: Compressor_23_3
      port map ( R => CompressorOut_bh6_36_36   ,
                 X0 => CompressorIn_bh6_36_55,
                 X1 => CompressorIn_bh6_36_56);
   heap_bh6_w10_10 <= CompressorOut_bh6_36_36(0); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w11_12 <= CompressorOut_bh6_36_36(1); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w12_11 <= CompressorOut_bh6_36_36(2); -- cycle= 0 cp= 2.18392e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_37_57 <= heap_bh6_w13_7 & heap_bh6_w13_6 & heap_bh6_w13_9;
   CompressorIn_bh6_37_58 <= heap_bh6_w14_11 & heap_bh6_w14_10;
   Compressor_bh6_37: Compressor_23_3
      port map ( R => CompressorOut_bh6_37_37   ,
                 X0 => CompressorIn_bh6_37_57,
                 X1 => CompressorIn_bh6_37_58);
   heap_bh6_w13_10 <= CompressorOut_bh6_37_37(0); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w14_12 <= CompressorOut_bh6_37_37(1); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w15_11 <= CompressorOut_bh6_37_37(2); -- cycle= 0 cp= 2.18392e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_38_59 <= heap_bh6_w16_7 & heap_bh6_w16_6 & heap_bh6_w16_9;
   CompressorIn_bh6_38_60 <= heap_bh6_w17_11 & heap_bh6_w17_10;
   Compressor_bh6_38: Compressor_23_3
      port map ( R => CompressorOut_bh6_38_38   ,
                 X0 => CompressorIn_bh6_38_59,
                 X1 => CompressorIn_bh6_38_60);
   heap_bh6_w16_10 <= CompressorOut_bh6_38_38(0); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w17_12 <= CompressorOut_bh6_38_38(1); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w18_11 <= CompressorOut_bh6_38_38(2); -- cycle= 0 cp= 2.18392e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_39_61 <= heap_bh6_w19_7 & heap_bh6_w19_6 & heap_bh6_w19_9;
   CompressorIn_bh6_39_62 <= heap_bh6_w20_10 & heap_bh6_w20_9;
   Compressor_bh6_39: Compressor_23_3
      port map ( R => CompressorOut_bh6_39_39   ,
                 X0 => CompressorIn_bh6_39_61,
                 X1 => CompressorIn_bh6_39_62);
   heap_bh6_w19_10 <= CompressorOut_bh6_39_39(0); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w20_11 <= CompressorOut_bh6_39_39(1); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w21_8 <= CompressorOut_bh6_39_39(2); -- cycle= 0 cp= 2.18392e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_40_63 <= heap_bh6_w23_0 & heap_bh6_w23_4 & heap_bh6_w23_5;
   CompressorIn_bh6_40_64 <= heap_bh6_w24_0 & heap_bh6_w24_2;
   Compressor_bh6_40: Compressor_23_3
      port map ( R => CompressorOut_bh6_40_40   ,
                 X0 => CompressorIn_bh6_40_63,
                 X1 => CompressorIn_bh6_40_64);
   heap_bh6_w23_6 <= CompressorOut_bh6_40_40(0); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w24_3 <= CompressorOut_bh6_40_40(1); -- cycle= 0 cp= 2.18392e-09
   heap_bh6_w25_2 <= CompressorOut_bh6_40_40(2); -- cycle= 0 cp= 2.18392e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_41_65 <= heap_bh6_w9_10 & heap_bh6_w9_9 & heap_bh6_w9_11 & heap_bh6_w9_5;
   CompressorIn_bh6_41_66(0) <= heap_bh6_w10_10;
   Compressor_bh6_41: Compressor_14_3
      port map ( R => CompressorOut_bh6_41_41   ,
                 X0 => CompressorIn_bh6_41_65,
                 X1 => CompressorIn_bh6_41_66);
   heap_bh6_w9_12 <= CompressorOut_bh6_41_41(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w10_11 <= CompressorOut_bh6_41_41(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w11_13 <= CompressorOut_bh6_41_41(2); -- cycle= 0 cp= 2.91772e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_42_67 <= heap_bh6_w12_10 & heap_bh6_w12_9 & heap_bh6_w12_11 & heap_bh6_w12_5;
   CompressorIn_bh6_42_68(0) <= heap_bh6_w13_10;
   Compressor_bh6_42: Compressor_14_3
      port map ( R => CompressorOut_bh6_42_42   ,
                 X0 => CompressorIn_bh6_42_67,
                 X1 => CompressorIn_bh6_42_68);
   heap_bh6_w12_12 <= CompressorOut_bh6_42_42(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w13_11 <= CompressorOut_bh6_42_42(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w14_13 <= CompressorOut_bh6_42_42(2); -- cycle= 0 cp= 2.91772e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_43_69 <= heap_bh6_w15_10 & heap_bh6_w15_9 & heap_bh6_w15_11 & heap_bh6_w15_5;
   CompressorIn_bh6_43_70(0) <= heap_bh6_w16_10;
   Compressor_bh6_43: Compressor_14_3
      port map ( R => CompressorOut_bh6_43_43   ,
                 X0 => CompressorIn_bh6_43_69,
                 X1 => CompressorIn_bh6_43_70);
   heap_bh6_w15_12 <= CompressorOut_bh6_43_43(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w16_11 <= CompressorOut_bh6_43_43(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w17_13 <= CompressorOut_bh6_43_43(2); -- cycle= 0 cp= 2.91772e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_44_71 <= heap_bh6_w18_10 & heap_bh6_w18_9 & heap_bh6_w18_11 & heap_bh6_w18_5;
   CompressorIn_bh6_44_72(0) <= heap_bh6_w19_10;
   Compressor_bh6_44: Compressor_14_3
      port map ( R => CompressorOut_bh6_44_44   ,
                 X0 => CompressorIn_bh6_44_71,
                 X1 => CompressorIn_bh6_44_72);
   heap_bh6_w18_12 <= CompressorOut_bh6_44_44(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w19_11 <= CompressorOut_bh6_44_44(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w20_12 <= CompressorOut_bh6_44_44(2); -- cycle= 0 cp= 2.91772e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_45_73 <= heap_bh6_w21_7 & heap_bh6_w21_6 & heap_bh6_w21_8 & heap_bh6_w21_3;
   CompressorIn_bh6_45_74(0) <= heap_bh6_w22_4;
   Compressor_bh6_45: Compressor_14_3
      port map ( R => CompressorOut_bh6_45_45   ,
                 X0 => CompressorIn_bh6_45_73,
                 X1 => CompressorIn_bh6_45_74);
   heap_bh6_w21_9 <= CompressorOut_bh6_45_45(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w22_7 <= CompressorOut_bh6_45_45(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w23_7 <= CompressorOut_bh6_45_45(2); -- cycle= 0 cp= 2.91772e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_46_75 <= heap_bh6_w3_6 & heap_bh6_w3_8 & heap_bh6_w3_5;
   CompressorIn_bh6_46_76 <= heap_bh6_w4_10 & heap_bh6_w4_9;
   Compressor_bh6_46: Compressor_23_3
      port map ( R => CompressorOut_bh6_46_46   ,
                 X0 => CompressorIn_bh6_46_75,
                 X1 => CompressorIn_bh6_46_76);
   heap_bh6_w3_9 <= CompressorOut_bh6_46_46(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w4_11 <= CompressorOut_bh6_46_46(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w5_11 <= CompressorOut_bh6_46_46(2); -- cycle= 0 cp= 2.91772e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_47_77 <= heap_bh6_w5_7 & heap_bh6_w5_10 & heap_bh6_w5_6;
   CompressorIn_bh6_47_78 <= heap_bh6_w6_10 & heap_bh6_w6_9;
   Compressor_bh6_47: Compressor_23_3
      port map ( R => CompressorOut_bh6_47_47   ,
                 X0 => CompressorIn_bh6_47_77,
                 X1 => CompressorIn_bh6_47_78);
   heap_bh6_w5_12 <= CompressorOut_bh6_47_47(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w6_11 <= CompressorOut_bh6_47_47(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w7_11 <= CompressorOut_bh6_47_47(2); -- cycle= 0 cp= 2.91772e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_48_79 <= heap_bh6_w25_0 & heap_bh6_w25_2 & heap_bh6_w25_1;
   CompressorIn_bh6_48_80 <= heap_bh6_w26_0 & heap_bh6_w26_1;
   Compressor_bh6_48: Compressor_23_3
      port map ( R => CompressorOut_bh6_48_48   ,
                 X0 => CompressorIn_bh6_48_79,
                 X1 => CompressorIn_bh6_48_80);
   heap_bh6_w25_3 <= CompressorOut_bh6_48_48(0); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w26_2 <= CompressorOut_bh6_48_48(1); -- cycle= 0 cp= 2.91772e-09
   heap_bh6_w27_1 <= CompressorOut_bh6_48_48(2); -- cycle= 0 cp= 2.91772e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_49_81 <= heap_bh6_w7_10 & heap_bh6_w7_5 & heap_bh6_w7_11;
   CompressorIn_bh6_49_82 <= heap_bh6_w8_12 & heap_bh6_w8_6;
   Compressor_bh6_49: Compressor_23_3
      port map ( R => CompressorOut_bh6_49_49   ,
                 X0 => CompressorIn_bh6_49_81,
                 X1 => CompressorIn_bh6_49_82);
   heap_bh6_w7_12 <= CompressorOut_bh6_49_49(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w8_13 <= CompressorOut_bh6_49_49(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w9_13 <= CompressorOut_bh6_49_49(2); -- cycle= 0 cp= 3.44844e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_50_83 <= heap_bh6_w22_6 & heap_bh6_w22_3 & heap_bh6_w22_7;
   CompressorIn_bh6_50_84 <= heap_bh6_w23_6 & heap_bh6_w23_3;
   Compressor_bh6_50: Compressor_23_3
      port map ( R => CompressorOut_bh6_50_50   ,
                 X0 => CompressorIn_bh6_50_83,
                 X1 => CompressorIn_bh6_50_84);
   heap_bh6_w22_8 <= CompressorOut_bh6_50_50(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w23_8 <= CompressorOut_bh6_50_50(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w24_4 <= CompressorOut_bh6_50_50(2); -- cycle= 0 cp= 3.44844e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_51_85 <= heap_bh6_w11_12 & heap_bh6_w11_6 & heap_bh6_w11_13;
   CompressorIn_bh6_51_86(0) <= heap_bh6_w12_12;
   Compressor_bh6_51: Compressor_13_3
      port map ( R => CompressorOut_bh6_51_51   ,
                 X0 => CompressorIn_bh6_51_85,
                 X1 => CompressorIn_bh6_51_86);
   heap_bh6_w11_14 <= CompressorOut_bh6_51_51(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w12_13 <= CompressorOut_bh6_51_51(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w13_12 <= CompressorOut_bh6_51_51(2); -- cycle= 0 cp= 3.44844e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_52_87 <= heap_bh6_w14_12 & heap_bh6_w14_6 & heap_bh6_w14_13;
   CompressorIn_bh6_52_88(0) <= heap_bh6_w15_12;
   Compressor_bh6_52: Compressor_13_3
      port map ( R => CompressorOut_bh6_52_52   ,
                 X0 => CompressorIn_bh6_52_87,
                 X1 => CompressorIn_bh6_52_88);
   heap_bh6_w14_14 <= CompressorOut_bh6_52_52(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w15_13 <= CompressorOut_bh6_52_52(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w16_12 <= CompressorOut_bh6_52_52(2); -- cycle= 0 cp= 3.44844e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_53_89 <= heap_bh6_w17_12 & heap_bh6_w17_6 & heap_bh6_w17_13;
   CompressorIn_bh6_53_90(0) <= heap_bh6_w18_12;
   Compressor_bh6_53: Compressor_13_3
      port map ( R => CompressorOut_bh6_53_53   ,
                 X0 => CompressorIn_bh6_53_89,
                 X1 => CompressorIn_bh6_53_90);
   heap_bh6_w17_14 <= CompressorOut_bh6_53_53(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w18_13 <= CompressorOut_bh6_53_53(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w19_12 <= CompressorOut_bh6_53_53(2); -- cycle= 0 cp= 3.44844e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_54_91 <= heap_bh6_w20_11 & heap_bh6_w20_5 & heap_bh6_w20_12;
   CompressorIn_bh6_54_92(0) <= heap_bh6_w21_9;
   Compressor_bh6_54: Compressor_13_3
      port map ( R => CompressorOut_bh6_54_54   ,
                 X0 => CompressorIn_bh6_54_91,
                 X1 => CompressorIn_bh6_54_92);
   heap_bh6_w20_13 <= CompressorOut_bh6_54_54(0); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w21_10 <= CompressorOut_bh6_54_54(1); -- cycle= 0 cp= 3.44844e-09
   heap_bh6_w22_9 <= CompressorOut_bh6_54_54(2); -- cycle= 0 cp= 3.44844e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_55_93 <= heap_bh6_w13_5 & heap_bh6_w13_11 & heap_bh6_w13_12;
   CompressorIn_bh6_55_94(0) <= heap_bh6_w14_14;
   Compressor_bh6_55: Compressor_13_3
      port map ( R => CompressorOut_bh6_55_55   ,
                 X0 => CompressorIn_bh6_55_93,
                 X1 => CompressorIn_bh6_55_94);
   heap_bh6_w13_13 <= CompressorOut_bh6_55_55(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh6_w14_15 <= CompressorOut_bh6_55_55(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh6_w15_14 <= CompressorOut_bh6_55_55(2); -- cycle= 0 cp= 3.97916e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_56_95 <= heap_bh6_w16_5 & heap_bh6_w16_11 & heap_bh6_w16_12;
   CompressorIn_bh6_56_96(0) <= heap_bh6_w17_14;
   Compressor_bh6_56: Compressor_13_3
      port map ( R => CompressorOut_bh6_56_56   ,
                 X0 => CompressorIn_bh6_56_95,
                 X1 => CompressorIn_bh6_56_96);
   heap_bh6_w16_13 <= CompressorOut_bh6_56_56(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh6_w17_15 <= CompressorOut_bh6_56_56(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh6_w18_14 <= CompressorOut_bh6_56_56(2); -- cycle= 0 cp= 3.97916e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_57_97 <= heap_bh6_w19_5 & heap_bh6_w19_11 & heap_bh6_w19_12;
   CompressorIn_bh6_57_98(0) <= heap_bh6_w20_13;
   Compressor_bh6_57: Compressor_13_3
      port map ( R => CompressorOut_bh6_57_57   ,
                 X0 => CompressorIn_bh6_57_97,
                 X1 => CompressorIn_bh6_57_98);
   heap_bh6_w19_13 <= CompressorOut_bh6_57_57(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh6_w20_14 <= CompressorOut_bh6_57_57(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh6_w21_11 <= CompressorOut_bh6_57_57(2); -- cycle= 0 cp= 3.97916e-09

   ----------------Synchro barrier, entering cycle 0----------------
   CompressorIn_bh6_58_99 <= heap_bh6_w24_3 & heap_bh6_w24_1 & heap_bh6_w24_4;
   CompressorIn_bh6_58_100(0) <= heap_bh6_w25_3;
   Compressor_bh6_58: Compressor_13_3
      port map ( R => CompressorOut_bh6_58_58   ,
                 X0 => CompressorIn_bh6_58_99,
                 X1 => CompressorIn_bh6_58_100);
   heap_bh6_w24_5 <= CompressorOut_bh6_58_58(0); -- cycle= 0 cp= 3.97916e-09
   heap_bh6_w25_4 <= CompressorOut_bh6_58_58(1); -- cycle= 0 cp= 3.97916e-09
   heap_bh6_w26_3 <= CompressorOut_bh6_58_58(2); -- cycle= 0 cp= 3.97916e-09
   ----------------Synchro barrier, entering cycle 0----------------
   ----------------Synchro barrier, entering cycle 1----------------
   finalAdderIn0_bh6 <= "0" & heap_bh6_w43_0_d1 & heap_bh6_w42_0_d1 & heap_bh6_w41_0_d1 & heap_bh6_w40_0_d1 & heap_bh6_w39_0_d1 & heap_bh6_w38_0_d1 & heap_bh6_w37_0_d1 & heap_bh6_w36_0_d1 & heap_bh6_w35_0_d1 & heap_bh6_w34_0_d1 & heap_bh6_w33_0_d1 & heap_bh6_w32_0_d1 & heap_bh6_w31_0_d1 & heap_bh6_w30_0_d1 & heap_bh6_w29_0_d1 & heap_bh6_w28_0_d1 & heap_bh6_w27_0_d1 & heap_bh6_w26_2_d1 & heap_bh6_w25_4_d1 & heap_bh6_w24_5_d1 & heap_bh6_w23_7_d1 & heap_bh6_w22_9_d1 & heap_bh6_w21_10_d1 & heap_bh6_w20_14_d1 & heap_bh6_w19_13_d1 & heap_bh6_w18_13_d1 & heap_bh6_w17_15_d1 & heap_bh6_w16_13_d1 & heap_bh6_w15_13_d1 & heap_bh6_w14_15_d1 & heap_bh6_w13_13_d1 & heap_bh6_w12_13_d1 & heap_bh6_w11_14_d1 & heap_bh6_w10_5_d1 & heap_bh6_w9_12_d1 & heap_bh6_w8_13_d1 & heap_bh6_w7_12_d1 & heap_bh6_w6_5_d1 & heap_bh6_w5_12_d1 & heap_bh6_w4_5_d1 & heap_bh6_w3_9_d1 & heap_bh6_w2_9_d1 & heap_bh6_w1_5_d1;
   finalAdderIn1_bh6 <= "0" & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & heap_bh6_w27_1_d1 & heap_bh6_w26_3_d1 & '0' & '0' & heap_bh6_w23_8_d1 & heap_bh6_w22_8_d1 & heap_bh6_w21_11_d1 & '0' & '0' & heap_bh6_w18_14_d1 & '0' & '0' & heap_bh6_w15_14_d1 & '0' & '0' & '0' & '0' & heap_bh6_w10_11_d1 & heap_bh6_w9_13_d1 & '0' & '0' & heap_bh6_w6_11_d1 & heap_bh6_w5_11_d1 & heap_bh6_w4_11_d1 & '0' & '0' & heap_bh6_w1_4_d1;
   finalAdderCin_bh6 <= '0';
   Adder_final6_0: IntAdder_44_f200_uid99  -- pipelineDepth=0 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => finalAdderCin_bh6,
                 R => finalAdderOut_bh6   ,
                 X => finalAdderIn0_bh6,
                 Y => finalAdderIn1_bh6);
   -- concatenate all the compressed chunks
   CompressionResult6 <= finalAdderOut_bh6 & tempR_bh6_0_d1;
   -- End of code generated by BitHeap::generateCompressorVHDL
   R <= CompressionResult6(43 downto 3);
end architecture;

--------------------------------------------------------------------------------
--                          IntAdder_49_f200_uid107
--                    (IntAdderAlternative_49_f200_uid111)
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

entity IntAdder_49_f200_uid107 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(48 downto 0);
          Y : in  std_logic_vector(48 downto 0);
          Cin : in  std_logic;
          R : out  std_logic_vector(48 downto 0)   );
end entity;

architecture arch of IntAdder_49_f200_uid107 is
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
--                         FPMult_9_23_9_23_9_38_uid2
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

entity FPMult_9_23_9_23_9_38_uid2 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(9+23+2 downto 0);
          Y : in  std_logic_vector(9+23+2 downto 0);
          R : out  std_logic_vector(9+38+2 downto 0)   );
end entity;

architecture arch of FPMult_9_23_9_23_9_38_uid2 is
   component IntAdder_49_f200_uid107 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(48 downto 0);
             Y : in  std_logic_vector(48 downto 0);
             Cin : in  std_logic;
             R : out  std_logic_vector(48 downto 0)   );
   end component;

   component IntMultiplier_UsingDSP_24_24_41_unsigned_uid4 is
      port ( clk, rst : in std_logic;
             X : in  std_logic_vector(23 downto 0);
             Y : in  std_logic_vector(23 downto 0);
             R : out  std_logic_vector(40 downto 0)   );
   end component;

signal sign, sign_d1 :  std_logic;
signal expX :  std_logic_vector(8 downto 0);
signal expY :  std_logic_vector(8 downto 0);
signal expSumPreSub :  std_logic_vector(10 downto 0);
signal bias :  std_logic_vector(10 downto 0);
signal expSum, expSum_d1 :  std_logic_vector(10 downto 0);
signal sigX :  std_logic_vector(23 downto 0);
signal sigY :  std_logic_vector(23 downto 0);
signal sigProd :  std_logic_vector(40 downto 0);
signal excSel :  std_logic_vector(3 downto 0);
signal exc, exc_d1 :  std_logic_vector(1 downto 0);
signal norm :  std_logic;
signal expPostNorm :  std_logic_vector(10 downto 0);
signal sigProdExt :  std_logic_vector(40 downto 0);
signal expSig :  std_logic_vector(48 downto 0);
signal round :  std_logic;
signal expSigPostRound :  std_logic_vector(48 downto 0);
signal excPostNorm :  std_logic_vector(1 downto 0);
signal finalExc :  std_logic_vector(1 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            sign_d1 <=  sign;
            expSum_d1 <=  expSum;
            exc_d1 <=  exc;
         end if;
      end process;
   sign <= X(32) xor Y(32);
   expX <= X(31 downto 23);
   expY <= Y(31 downto 23);
   expSumPreSub <= ("00" & expX) + ("00" & expY);
   bias <= CONV_STD_LOGIC_VECTOR(255,11);
   expSum <= expSumPreSub - bias;
   ----------------Synchro barrier, entering cycle 0----------------
   sigX <= "1" & X(22 downto 0);
   sigY <= "1" & Y(22 downto 0);
   SignificandMultiplication: IntMultiplier_UsingDSP_24_24_41_unsigned_uid4  -- pipelineDepth=1 maxInDelay=0
      port map ( clk  => clk,
                 rst  => rst,
                 R => sigProd,
                 X => sigX,
                 Y => sigY);
   ----------------Synchro barrier, entering cycle 1----------------
   ----------------Synchro barrier, entering cycle 0----------------
   excSel <= X(34 downto 33) & Y(34 downto 33);
   with excSel select
   exc <= "00" when  "0000" | "0001" | "0100",
          "01" when "0101",
          "10" when "0110" | "1001" | "1010" ,
          "11" when others;
   ----------------Synchro barrier, entering cycle 1----------------
   norm <= sigProd(40);
   -- exponent update
   expPostNorm <= expSum_d1 + ("0000000000" & norm);
   ----------------Synchro barrier, entering cycle 1----------------
   -- significand normalization shift
   sigProdExt <= sigProd(39 downto 0) & "0" when norm='1' else
                         sigProd(38 downto 0) & "00";
   expSig <= expPostNorm & sigProdExt(40 downto 3);
--   round <= '1' ;
     round <= '0';   -- mod by JDH Sept 21, 2015
   RoundingAdder: IntAdder_49_f200_uid107  -- pipelineDepth=0 maxInDelay=1.36572e-09
      port map ( clk  => clk,
                 rst  => rst,
                 Cin => round,
                 R => expSigPostRound   ,
                 X => expSig,
                 Y => "0000000000000000000000000000000000000000000000000");
   with expSigPostRound(48 downto 47) select
   excPostNorm <=  "01"  when  "00",
                               "10"             when "01",
                               "00"             when "11"|"10",
                               "11"             when others;
   with exc_d1 select
   finalExc <= exc_d1 when  "11"|"10"|"00",
                       excPostNorm when others;
   R <= finalExc & sign_d1 & expSigPostRound(46 downto 0);
end architecture;

