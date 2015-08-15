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
use fplib.pkg_fxpconv.all;

entity FP_To_FXP is
  generic ( wE    : positive := 6;
            wF    : positive := 13;
            wFX_I : positive := 6;
            wFX_F : positive := 13 );
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wFX_I+wFX_F-1 downto 0));
end entity;

architecture arch of FP_To_FXP is
  constant wFX  : positive := wFX_I+wFX_F;
  constant eMax : integer := 2**(wE-1)-1;
  constant eMin : integer := 2**(wE-1)-2;
  constant wFX0 : positive := min(eMax+1,wFX_I)+wFX_F;

  signal overFl0 : std_logic;
  signal overFl1 : std_logic;
  signal undrFl0 : std_logic;
  signal round   : std_logic;
  signal eTest   : std_logic_vector(1 downto 0);
  
  signal eA0 : std_logic_vector(wE-1 downto 0);
  signal eA1 : std_logic_vector(wE-1 downto 0);
  signal fA0 : std_logic_vector(wFX0+1 downto 0);
  signal fA1 : std_logic_vector(wFX0+1 downto 0);
  signal fA2 : std_logic_vector(wFX downto 0);
  signal fA3 : std_logic_vector(wFX-1 downto 0);
  signal fA4 : std_logic_vector(wFX-1 downto 0);
begin
  eA0 <= nA(wE+wF-1 downto wF);
  eA1 <= conv_std_logic_vector(2**(wE-1)-1+min(eMax,wFX_I-1), wE) - eA0;

  fpad : if wF+1 < wFX0+2 generate
    fA0 <= "1" & nA(wF-1 downto 0) & (wFX0-wF downto 0 => '0');
  end generate;
  no_fpad : if wF+1 >= wFX0+2 generate
    fA0 <= "1" & nA(wF-1 downto wF-wFX0);
    fA0(0) <= '0' when nA(wF-wFX0-1 downto 0) = (wF-wFX0-1 downto 0 => '0') else
              '1';
  end generate;

  shift : FXP_Shift
    generic map ( wE  => wE,
                  wFX => wFX0 )
    port map ( fA => fA0,
               n  => eA1,
               fR => fA1 );

  round <= fA1(1) and (fA1(2) or fA1(0));
  fA2 <= ((wFX-wFX0 downto 0 => '0') & fA1(wFX0+1 downto 2)) + ((wFX downto 1 => '0') & round);
  
  overflow0 : if eMax+1 > wFX_I generate
    overFl0 <= '1' when eA0 > conv_std_logic_vector(2**(wE-1)-1+wFX_I-1, wE) else
               nA(wE+wF+2);
  end generate;
  no_overflow0 : if eMax+1 <= wFX_I generate
    overFl0 <= nA(wE+wF+2);
  end generate;

  overFl1 <= fA2(wFX) or fA2(wFX-1);

  underflow0 : if eMin > wFX_F generate
    undrFl0 <= '1' when eA0 < conv_std_logic_vector(2**(wE-1)-1-wFX_F, wE) else
               not (nA(wE+wF+2) or nA(wE+wF+1));
  end generate;
  no_underflow0 : if eMin <= wFX_F generate
    undrFl0 <= not (nA(wE+wF+2) or nA(wE+wF+1));
  end generate;

  neg : for i in wFX-1 downto 0 generate
    fA3(i) <= fA2(i) xor nA(wE+wF);
  end generate;
  fA4 <= fA3 + ((wFX-1 downto 1 => '0') & nA(wE+wF));
  
  eTest <= (overFl0 or overFl1) & undrFl0;
  with eTest select
    nR <= (wFX-1 downto 0 => '0')                       when "01",
          nA(wE+wF) & (wFX-2 downto 0 => not nA(wE+wF)) when "10",
          fA4                                           when others;
end architecture;
