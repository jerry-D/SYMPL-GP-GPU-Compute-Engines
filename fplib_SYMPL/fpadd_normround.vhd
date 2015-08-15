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

entity FPAdd_NormRound is
  generic ( wE : positive;
            wF : positive );
  port ( eA : in  std_logic_vector(wE downto 0);
         fA : in  std_logic_vector(wF+1 downto 0);
         n  : in  std_logic_vector(log((wF+5)/4)+2 downto 2);
         eR : out std_logic_vector(wE downto 0);
         fR : out std_logic_vector(wF downto 0) );
end entity;

architecture arch of FPAdd_NormRound is
  constant wNZeros : positive := log((wF+5)/4)+3;

  signal nZeros : std_logic_vector(wNZeros-1 downto 0);
  signal round  : std_logic;
  signal eZero  : std_logic;

  signal shift : std_logic_vector(wNZeros*(wF+2)-1 downto 0);
  signal eRn0  : std_logic_vector(wE downto 0);
  signal eRn   : std_logic_vector(wE downto 0);
  signal fRn   : std_logic_vector(wF downto 0);
  signal fRr   : std_logic_vector(wF-1 downto 0);
begin
  nZeros(wNZeros-1 downto 2) <= n;
  round <= fA(wF+1) and fA(1) and fA(0);

  shift(wNZeros*(wF+2)-1 downto (wNZeros-1)*(wF+2)) <= fA;

  shift_unit : for i in wNZeros-1 downto 2 generate
    shift_normal : if i < wNZeros-1 or 2**(wNZeros-1) <= wF+2 generate
    with nZeros(i) select
      shift(i*(wF+2)-1 downto (i-1)*(wF+2)) <= shift((i+1)*(wF+2)-2**i-1 downto i*(wF+2)) &
                                                     (2**i-1 downto 0 => '0')                           when '1',
                                                     shift((i+1)*(wF+2)-1 downto i*(wF+2))        when others;
    end generate;
    shift_bypass : if i = wNZeros-1 and 2**(wNZeros-1) > wF+2 generate
      shift(i*(wF+2)-1 downto (i-1)*(wF+2)) <= shift((i+1)*(wF+2)-1 downto i*(wF+2));
    end generate;
  end generate;

  nZeros(1) <= not (shift(2*(wF+2)-1) or shift(2*(wF+2)-2));
  with nZeros(1) select
    nZeros(0) <= not shift(2*(wF+2)-3) when '1',
                 not shift(2*(wF+2)-1) when others;

  with nZeros(1) select
    shift(wF+1 downto 0) <= shift(2*(wF+2)-3 downto wF+2) & "00" when '1',
                               shift(2*(wF+2)-1 downto wF+2)        when others;
  with nZeros(0) select
    fRn <= shift(wF downto 0)   when '1',
           shift(wF+1 downto 1) when others;

  exp_norm_normal : if wE >= wNZeros generate
    eRn0 <= eA - ((wE downto wNZeros => '0') & nZeros);
    eZero <= eRn0(wE);
  end generate;
  exp_norm_over : if wE < wNZeros generate
    eRn0 <= eA - ("0" & nZeros(wE-1 downto 0));
    eZero <= eRn0(wE) when nZeros(wNZeros-1 downto wE) = (wNZeros-1 downto wE => '0') else
             '1';
  end generate;
  with eZero select
    eRn <= (wE downto 0 => '0') when '1',
           eRn0                   when others;

  fRr <= ("0" & fA(wF downto 2)) + ((wF-1 downto 1 => '0') & "1");

  with round select
    eR <= eRn                                            when '0',
          eA + ((wE-1 downto 0 => '0') & fRr(wF-1)) when others;
  with round select
    fR <= fRn                               when '0',
          "1" & fRr(wF-2 downto 0) & "0" when others;
end architecture;
