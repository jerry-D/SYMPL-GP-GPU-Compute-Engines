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

entity FP_Format is
  generic ( wE : positive;
            wF : positive );
  port ( sA : in  std_logic;
         eA : in  std_logic_vector(wE downto 0);
         fA : in  std_logic_vector(wF downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end entity;

architecture arch of FP_Format is
  signal eMax  : std_logic;
  signal eMin  : std_logic;
  signal eTest : std_logic_vector(1 downto 0);
begin
  eMax <= '1' when eA(wE-1 downto 0) = (wE-1 downto 0 => '1') else
          '0';
  eMin <= '1' when eA(wE-1 downto 0) = (wE-1 downto 0 => '0') else
          '0';
  eTest(1) <= (eMax and not eA(wE)) or (eA(wE) and not eA(wE-1));
  eTest(0) <= (eMin and not eA(wE)) or (eA(wE) and eA(wE-1)) or not fA(wF);

  with eTest select
    nR(wE+wF+2 downto wE+wF+1) <= "00" when "01",
                                  "10" when "10",
                                  "01" when others;
  nR(wE+wF downto 0) <= sA & eA(wE-1 downto 0) & fA(wF-1 downto 0);
end architecture;
