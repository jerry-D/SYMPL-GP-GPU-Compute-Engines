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

entity FP_Round is
  generic ( wE : positive;
            wF : positive );
  port ( eA : in  std_logic_vector(wE downto 0);
         fA : in  std_logic_vector(wF+2 downto 0);
         eR : out std_logic_vector(wE downto 0);
         fR : out std_logic_vector(wF downto 0) );
end entity;

architecture arch of FP_Round is
  signal round  : std_logic;

  signal fR0   : std_logic_vector(wF+1 downto 0);
begin
  round <= fA(1) and (fA(2) or fA(0));

  fR0 <= ("0" & fA(wF+2 downto 2)) + ((wF downto 0 => '0') & round);

  eR <= eA + ((wE-1 downto 0 => '0') & fR0(wF+1));
  fR <= (fR0(wF+1) or fR0(wF)) & fR0(wF-1 downto 0);
end architecture;
