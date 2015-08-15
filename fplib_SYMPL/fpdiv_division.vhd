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
use fplib.pkg_fpdiv.all;

entity FPDiv_Division is
  generic ( wF : positive );
  port ( fA  : in  std_logic_vector(wF downto 0);
         fB  : in  std_logic_vector(wF downto 0);
         fR  : out std_logic_vector(wF+3 downto 0) );
end entity;

architecture arch of FPDiv_Division is
  constant nDigit : positive := (wF+6)/2;

  signal fB3 : std_logic_vector(wF+2 downto 0);
  signal w  : std_logic_vector(nDigit*(wF+3)-1 downto 0);
  signal q  : std_logic_vector(nDigit*3-1 downto 0);
  signal qP : std_logic_vector(2*nDigit-1 downto 0);
  signal qM : std_logic_vector(2*nDigit downto 1);

  signal fR0 : std_logic_vector(2*nDigit-1 downto 0);
begin
  fB3 <= ("00" & fB) + ("0" & fB & "0");

  w(nDigit*(wF+3)-1 downto (nDigit-1)*(wF+3)) <= "00" & fA;
  srt : for i in nDigit-1 downto 1 generate
    step : FPDiv_SRT4_Step
      generic map ( wF => wF )
      port map ( x  => w((i+1)*(wF+3)-1 downto i*(wF+3)),
                 d  => fB,
                 d3 => fB3,
                 q  => q((i+1)*3-1 downto i*3),
                 w  => w(i*(wF+3)-1 downto (i-1)*(wF+3)) );
    qP(2*i+1 downto 2*i)   <= q(i*3+1 downto i*3);
    qM(2*i+2 downto 2*i+1) <= q(i*3+2) & "0";
  end generate;

  q(2 downto 0) <= "000" when w(wF+2 downto 0) = (wF+1 downto 0 => '0') else
                   w(wF+2) & "10";
  qP(1 downto 0) <= q(1 downto 0);
  qM(2 downto 1) <= q(2) & "0";

  fR0 <= qP - (qM(2*nDigit-1 downto 1) & "0");

  round_odd : if wF mod 2 = 1 generate
    fR <= fR0(2*nDigit-1 downto 1);
  end generate;
  round_even : if wF mod 2 = 0 generate
    fR <= fR0(2*nDigit-1 downto 3) & (fR0(2) or fR0(1));
  end generate;
end architecture;
