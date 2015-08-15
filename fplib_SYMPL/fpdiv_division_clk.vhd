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

entity FPDiv_Division_Clk is
  generic ( wF : positive );
  port ( fA  : in  std_logic_vector(wF downto 0);
         fB  : in  std_logic_vector(wF downto 0);
         fR  : out std_logic_vector(wF+3 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of FPDiv_Division_Clk is
  constant nDigit : positive := (wF+6)/2;

  signal fB1 : std_logic_vector(nDigit*(wF+1) downto 0);
  signal fB3 : std_logic_vector(nDigit*(wF+3) downto 0);
  signal x  : std_logic_vector(nDigit*(wF+3)-1 downto 0);
  signal w  : std_logic_vector((nDigit-1)*(wF+3)-1 downto 0);
  signal q  : std_logic_vector(nDigit*3-1 downto 0);
  signal qP : std_logic_vector(nDigit*(nDigit+1)-1 downto 0);
  signal qM : std_logic_vector(nDigit*(nDigit+1) downto 1);

  signal fR0 : std_logic_vector(2*nDigit-1 downto 0);
begin
  fB1(nDigit*(wF+1)-1 downto (nDigit-1)*(wF+1)) <= fB;
  fB3(nDigit*(wF+3)-1 downto (nDigit-1)*(wF+3)) <= ("00" & fB) + ("0" & fB & "0");
  
  x(nDigit*(wF+3)-1 downto (nDigit-1)*(wF+3)) <= "00" & fA;
  srt : for i in nDigit-1 downto 1 generate
    step : FPDiv_SRT4_Step
      generic map ( wF => wF )
      port map ( x  => x((i+1)*(wF+3)-1 downto i*(wF+3)),
                 d  => fB1((i+1)*(wF+1)-1 downto i*(wF+1)),
                 d3 => fB3((i+1)*(wF+3)-1 downto i*(wF+3)),
                 q  => q(i*3+2 downto i*3),
                 w  => w(i*(wF+3)-1 downto (i-1)*(wF+3)) );
    qP((nDigit-i-1)*(nDigit-i)+1 downto (nDigit-i-1)*(nDigit-i))   <= q(i*3+1 downto i*3);
    qM((nDigit-i-1)*(nDigit-i)+2 downto (nDigit-i-1)*(nDigit-i)+1) <= q(i*3+2) & "0";

    process(clk)
    begin
      if clk'event and clk='1' then
        fB1(i*(wF+1)-1 downto (i-1)*(wF+1)) <= fB1((i+1)*(wF+1)-1 downto i*(wF+1));
        fB3(i*(wF+3)-1 downto (i-1)*(wF+3)) <= fB3((i+1)*(wF+3)-1 downto i*(wF+3));
        qP((nDigit-i+1)*(nDigit-i+2)-1 downto (nDigit-i)*(nDigit-i+1)+2) <=
          qP((nDigit-i)*(nDigit-i+1)-1 downto (nDigit-i-1)*(nDigit-i));
        qM((nDigit-i+1)*(nDigit-i+2) downto (nDigit-i)*(nDigit-i+1)+3) <=
          qM((nDigit-i)*(nDigit-i+1) downto (nDigit-i-1)*(nDigit-i)+1);
        x(i*(wF+3)-1 downto (i-1)*(wF+3)) <= w(i*(wF+3)-1 downto (i-1)*(wF+3));
      end if;
    end process;

-------------------------------------------------------------------------------
    
  end generate;

  q(2 downto 0) <= "000" when x(wF+2 downto 0) = (wF+1 downto 0 => '0') else
                   x(wF+2) & "10";
  qP((nDigit-1)*nDigit+1 downto (nDigit-1)*nDigit)   <= q(1 downto 0);
  qM((nDigit-1)*nDigit+2 downto (nDigit-1)*nDigit+1) <= q(2) & "0";

  fR0 <=  qP(nDigit*(nDigit+1)-1 downto (nDigit-1)*nDigit) -
         (qM(nDigit*(nDigit+1)-1 downto (nDigit-1)*nDigit+1) & "0");

  round_odd : if wF mod 2 = 1 generate
    fR <= fR0(2*nDigit-1 downto 1);
  end generate;
  round_even : if wF mod 2 = 0 generate
    fR <= fR0(2*nDigit-1 downto 3) & (fR0(2) or fR0(1));
  end generate;
end architecture;
