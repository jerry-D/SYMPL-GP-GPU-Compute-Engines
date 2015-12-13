-- vagrant@vagrant-ubuntu-trusty-32:~/flopoco-3.0.beta5$ ./flopoco -name=IEEE754_To_FP -frequency=200 -useHardMult=no InputIEEE 8 23 9 23
-- > InputIEEE: wEI=8 wFI=23 wEO=9 wFO=23
-- 
-- Final report:
-- Entity IEEE754_To_FP9
--    Not pipelined
-- Output file: flopoco.vhdl
--------------------------------------------------------------------------------
--                               IEEE754_To_FP9
--                          (InputIEEE_8_23_to_9_23)
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved
-- Authors: Florent de Dinechin (2008)
--------------------------------------------------------------------------------
-- Pipeline depth: 0 cycles

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IEEE754_To_FP9 is
   port ( clk, rst : in std_logic;
          X : in  std_logic_vector(31 downto 0);
          R : out  std_logic_vector(9+23+2 downto 0)   );
end entity;

architecture arch of IEEE754_To_FP9 is
signal expX :  std_logic_vector(7 downto 0);
signal fracX :  std_logic_vector(22 downto 0);
signal sX :  std_logic;
signal expZero :  std_logic;
signal expInfty :  std_logic;
signal fracZero :  std_logic;
signal overflow :  std_logic;
signal underflow :  std_logic;
signal expR :  std_logic_vector(8 downto 0);
signal fracR :  std_logic_vector(22 downto 0);
signal roundOverflow :  std_logic;
signal NaN :  std_logic;
signal infinity :  std_logic;
signal zero :  std_logic;
signal exnR :  std_logic_vector(1 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
         end if;
      end process;
   expX  <= X(30 downto 23);
   fracX  <= X(22 downto 0);
   sX  <= X(31);
   expZero  <= '1' when expX = (7 downto 0 => '0') else '0';
   expInfty  <= '1' when expX = (7 downto 0 => '1') else '0';
   fracZero <= '1' when fracX = (22 downto 0 => '0') else '0';
   overflow <= '0';--  overflow never happens for these (wE_in, wE_out)
   underflow <= '0';--  underflow never happens for these (wE_in, wE_out)
   expR <= ((8 downto 8 => '0')  & expX) + "010000000";
   fracR <= fracX;
   roundOverflow <= '0';
   NaN <= expInfty and not fracZero;
   infinity <= (expInfty and fracZero) or (not NaN and (overflow or roundOverflow));
 --  zero <= expZero or underflow;  --by JDH Nov 10, 2015
   zero <= expZero and fracZero;
   exnR <=
           "11" when NaN='1'
      else "10" when infinity='1'
      else "00" when zero='1'
      else "01" ;  -- normal number
   R <= exnR & sX & expR & fracR;
end architecture;

