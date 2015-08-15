-- Copyright 2003 Jérémie Detrey, Florent de Dinechin
--
-- This file is part of FPLibrary
--
-- FPLibrary is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- FPLibrary is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with FPLibrary; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FPDiv_SRT4_Step is
  generic ( wF : positive );
  port ( x  : in  std_logic_vector(wF+2 downto 0);
         d  : in  std_logic_vector(wF downto 0);
         d3 : in  std_logic_vector(wF+2 downto 0);
         q  : out std_logic_vector(2 downto 0);
         w  : out std_logic_vector(wF+2 downto 0) );
end entity;

architecture arch of FPDiv_SRT4_Step is
  signal sel : std_logic_vector(4 downto 0);
  signal q0 : std_logic_vector(2 downto 0);
  signal qd : std_logic_vector(wF+3 downto 0);
  signal x0 : std_logic_vector(wF+3 downto 0);
  signal w0 : std_logic_vector(wF+4 downto 1);
begin
  sel <= x(wF+2 downto wF-1) & d(wF-1);
  with sel select
    q0 <= "001" when "00010" | "00011",
          "010" when "00100" | "00101" | "00111",
          "011" when "00110" | "01000" | "01001" | "01010" | "01011" | "01101" | "01111",
          "101" when "11000" | "10110" | "10111" | "10100" | "10101" | "10011" | "10001",
          "110" when "11010" | "11011" | "11001",
          "111" when "11100" | "11101",
          "000" when "00000" | "00001" | "11110" | "11111",
          "---" when others;

  with q0 select
    qd <= "000" & d                 when "001" | "111",
          "00" & d & "0"            when "010" | "110",
          "0" & d3                  when "011" | "101",
          (wF+3 downto 0 => '0') when "000",
          (wF+3 downto 0 => '-') when others;

  x0 <= x & "0";
  with q0(2) select
    w0 <= x0 - qd when '0',
          x0 + qd when others;

  q <= q0;
  w <= w0(wF+2 downto 1) & "0";
end architecture;
