-- ./flopoco -name=FP_To_IEEE754 -frequency=200 -useHardMult=no OutputIEEE 8 23 8 23
--
-- Final report:
-- Entity FP_To_IEEE754.vhdl
--   Not pipelined
--
--------------------------------------------------------------------------------
--                             FP9_To_IEEE754
--                         (OutputIEEE_8_23_to_8_23)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: F. Ferrandi  (2009-2012)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity FP9_To_IEEE754 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(9+23+2 downto 0);
          R : out  std_logic_vector(31 downto 0)   );
end entity;

architecture arch of FP9_To_IEEE754 is
signal expX :  std_logic_vector(8 downto 0);
signal fracX :  std_logic_vector(22 downto 0);
signal exnX :  std_logic_vector(1 downto 0);
signal sX :  std_logic;
signal expZero :  std_logic;
signal sfracX :  std_logic_vector(22 downto 0);
signal fracR :  std_logic_vector(22 downto 0);
signal expR :  std_logic_vector(7 downto 0);
signal expR8 : std_logic_vector(8 downto 0); -- mod by JDH Sept 23, 2015
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   expX  <= X(31 downto 23);
   expR8 <= (expX(8 downto 7) - "01") & expX(6 downto 0); -- mod by JDH Sept 23, 2015
    fracX  <= X(22 downto 0);
   exnX  <= X(34 downto 33);
   sX  <= X(32) when (exnX = "01" or exnX = "10" or exnX = "00") else '0';
   expZero  <= '1' when expX = (8 downto 0 => '0') else '0';
   -- since we have one more exponent value than IEEE (field 0...0, value emin-1),
   -- we can represent subnormal numbers whose mantissa field begins with a 1
   sfracX <=
      (22 downto 0 => '0') when (exnX = "00") else
      '1' & fracX(22 downto 1) when (expZero = '1' and exnX = "01") else
      fracX when (exnX = "01") else
      (22 downto 1 => '0') & exnX(0);
   fracR <= sfracX;
   expR <=
      (7 downto 0 => '0') when (exnX = "00") else
      expR8(7 downto 0) when (exnX = "01") else  -- mod by JDH Sept 23, 2015
      (7 downto 0 => '1');
   R <= sX & expR & fracR;  
end architecture;
