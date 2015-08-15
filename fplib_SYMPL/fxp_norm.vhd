-- Copyright 2003-2004 Jérémie Detrey, Florent de Dinechin
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

entity FXP_Norm is
  generic ( wE    : positive;
            wF    : positive;
            wFX_I : positive;
            wFX_F : positive;
            wN    : positive );
  port ( nA : in  std_logic_vector(wFX_I+wFX_F-1 downto 0);
         n  : in  std_logic_vector(wN-1 downto 2);
         eR : out std_logic_vector(wE-1 downto 0);
         fR : out std_logic_vector(wF-1 downto 0) );
end entity;

architecture arch of FXP_Norm is
  constant wFX  : positive := wFX_I+wFX_F;
  
  signal nZeros : std_logic_vector(wN-1 downto 0);
  signal shift : std_logic_vector(wN*wFX-1 downto 0);
  signal eR0   : std_logic_vector(wE-1 downto 0);
  signal fR0   : std_logic_vector(wFX-1 downto 0);
  signal eR1   : std_logic_vector(wE-1 downto 0);
  signal fR1   : std_logic_vector(wF downto 0);
  
  signal round  : std_logic;
begin
  nZeros(wN-1 downto 2) <= n;

  shift(wN*wFX-1 downto (wN-1)*wFX) <= nA;

  shift_unit : for i in wN-1 downto 2 generate
    shift_normal : if i < wN-1 or 2**(wN-1) <= wFX generate
    with nZeros(i) select
      shift(i*wFX-1 downto (i-1)*wFX) <= shift((i+1)*wFX-2**i-1 downto i*wFX) & (2**i-1 downto 0 => '0') when '1',
                                         shift((i+1)*wFX-1 downto i*wFX)                                 when others;
    end generate;
    shift_bypass : if i = wN-1 and 2**(wN-1) > wFX generate
      shift(i*wFX-1 downto (i-1)*wFX) <= shift((i+1)*wFX-1 downto i*wFX);
    end generate;
  end generate;

  nZeros(1) <= not (shift(2*wFX-1) or shift(2*wFX-2));
  with nZeros(1) select
    nZeros(0) <= not shift(2*wFX-3) when '1',
                 not shift(2*wFX-1) when others;

  with nZeros(1) select
    shift(wFX-1 downto 0) <= shift(2*wFX-3 downto wFX) & "00" when '1',
                             shift(2*wFX-1 downto wFX)        when others;
  with nZeros(0) select
    fR0 <= shift(wFX-2 downto 0) & "0" when '1',
           shift(wFX-1 downto 0)       when others;

  exp_normal : if wN < wE generate
    eR0 <= conv_std_logic_vector(wFX_I-1 + 2**(wE-1)-1, wE) - ((wE-1 downto wN => '0') & nZeros);
  end generate;
  exp_over : if wN >= wE generate
    eR0 <= conv_std_logic_vector(wFX_I-1 + 2**(wE-1)-1, wE) - nZeros(wE-1 downto 0);
  end generate;

  frac_noround : if wFX-1 <= wF generate
    pad : if wFX-1 < wF generate
      fR1 <= fR0(wFX-1 downto 0) & (wF-wFX downto 0 => '0');
    end generate;
    nopad : if wFX-1 = wF generate
      fR1 <= fR0(wFX-1 downto 0);
    end generate;
    eR1 <= eR0;
  end generate;
  frac_round : if wFX-1 > wF generate
    round1 : if wFX-1 = wF+1 generate
      round <= nA(wFX-1) and nA(1) and nA(0);
      with round select
        fR1 <= fR0(wFX-1 downto 1)                                 when '0',
               nA(wFX-1 downto 1) + ((wFX-1 downto 2 => '0') & '1') when others;
      with round select
        eR1 <= eR0                                                                                  when '0',
               conv_std_logic_vector(wFX_I-1 + 2**(wE-1)-1, wE) + ((wE-1 downto 1 => '0') & (not fR1(wF))) when others;
    end generate;
    round2 : if wFX-1 > wF+1 generate
      round <= fR0(wFX-wF-1) when fR0(wFX-wF-2) = '1' and fR0(wFX-wF-3 downto 0) = (wFX-wF-3 downto 0 => '0') else
               fR0(wFX-wF-2);
      fR1 <= fR0(wFX-1 downto wFX-wF-1) + ((wFX-1 downto wFX-wF => '0') & round);
      eR1 <= eR0 + ((wE-1 downto 1 => '0') & (not fR1(wF)));
    end generate;
  end generate;

  eR <= eR1;
  fR <= fR1(wF-1 downto 0);
end architecture;
