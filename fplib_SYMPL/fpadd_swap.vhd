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

entity FPAdd_Swap is
  generic ( wE : positive;
            wF : positive );
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nB : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0);
         nS : out std_logic_vector(wE+wF+2 downto 0);
         eD : out std_logic_vector(wE-1 downto 0) );
end entity;

architecture arch of FPAdd_Swap is
  signal xABsup : std_logic;
  signal xABeq  : std_logic;
  
  signal eD0  : std_logic_vector(wE downto 0);
  signal eD1  : std_logic_vector(wE-1 downto 0);
  signal swap : std_logic;
begin
  xABsup <= '1' when nA(wE+wF+2 downto wE+wF+1) >= nB(wE+wF+2 downto wE+wF+1) else
            '0';
  xABeq <= '1' when nA(wE+wF+2 downto wE+wF+1) = nB(wE+wF+2 downto wE+wF+1) else
           '0';
  
  eD0 <= ("0" & nA(wE+wF-1 downto wF)) - ("0" & nB(wE+wF-1 downto wF));
  swap <= (eD0(wE) and xABeq) or (not xABsup);

  nR <= nB when swap = '1' else
        nA;   
  nS <= nA when swap = '1' else
        nB;

  diff_xor : for i in wE-1 downto 0 generate
    eD1(i) <= eD0(i) xor swap;
  end generate;
  eD <= eD1 + ((wE-1 downto 1 => '0') & swap);
end architecture;
