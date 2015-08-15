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
library fplib;
use fplib.pkg_misc.all;

entity FPSqrt_SRT2_Step is
  generic ( wF : positive;
            step  : positive );
  port ( x : in  std_logic_vector(wF+3 downto 0);
         s : in  std_logic_vector(wF+3 downto wF+4-step);
         d : out std_logic;
         w : out std_logic_vector(wF+3 downto 0) );
end entity;

architecture arch of FPSqrt_SRT2_Step is
  signal d0 : std_logic;
  signal x0 : std_logic_vector(wF+4 downto 0);
  signal s0 : std_logic_vector(wF+4 downto wF+4-step);
  signal ds : std_logic_vector(wF+4 downto wF+2-step);
  signal x1 : std_logic_vector(wF+4 downto wF+2-step);
  signal w1 : std_logic_vector(wF+4 downto wF+2-step);
  signal w0 : std_logic_vector(wF+4 downto 0);
begin
  d0 <= x(wF+3);

  x0 <= x & "0";
  
  s0 <= "0" & s;
  ds <= s0(wF+4 downto wF+5-step) & (not d0) & d0 & "1";

  x1 <= x0(wF+4 downto wF+2-step);
  with d0 select
    w1 <= x1 - ds when '0',
          x1 + ds when others;
  w0(wF+4 downto wF+2-step) <= w1;
  zeros : if step <= wF+1 generate
    w0(wF+1-step downto 0) <= x0(wF+1-step downto 0);
  end generate;

  d <= d0;
  w <= w0(wF+3 downto 0);
end architecture;
