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

entity FXP_To_FP is
  generic ( wE    : positive := 6;
            wF    : positive := 13;
            wFX_I : positive := 6;
            wFX_F : positive := 13 );
  port ( nA : in  std_logic_vector(wFX_I+wFX_F-1 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0));
end entity;

architecture arch of FXP_To_FP is
  constant wFX  : positive := wFX_I+wFX_F;
  constant eMax : integer := min(2**(wE-1), wFX_I);
  constant eMin : integer := min(2**(wE-1)-2, wFX_F);

  signal sR : std_logic;
  signal nA1 : std_logic_vector(wFX-2 downto 0);
  signal nA2 : std_logic_vector(wFX-1 downto 0);
  
  constant wNZeros : natural := log((eMax+eMin+3)/4)+3;
  signal nZeros : std_logic_vector(wNZeros-1 downto 2);
  signal eR     : std_logic_vector(wE-1 downto 0);
  signal fR     : std_logic_vector(wF-1 downto 0);
  
  signal overFl0 : std_logic;
  signal overFl1 : std_logic;
  signal overFl  : std_logic;
  signal undrFl0 : std_logic;
  signal undrFl1 : std_logic;
  signal undrFl  : std_logic;
  signal eTest   : std_logic_vector(1 downto 0);
begin
  sR <= nA(wFX-1);

  neg : for i in wFX-2 downto 0 generate
    nA1(i) <= nA(i) xor sR;
  end generate;
  nA2 <= ('0' & nA1) + ((wFX-1 downto 1 => '0') & sR);

  lzc : FXP_LZC
    generic map ( w => eMax+eMin )
    port map ( f => nA2(eMax+wFX_F-1 downto wFX_F-eMin),
               n => nZeros );

  norm : FXP_Norm
    generic map ( wE    => wE,
                  wF    => wF,
                  wFX_I => eMax,
                  wFX_F => wFX_F,
                  wN    => wNZeros )
    port map ( nA => nA2(eMax+wFX_F-1 downto 0),
               n  => nZeros,
               eR => eR,
               fR => fR );

  overflow0 : if eMax < wFX_I generate
    overFl0 <= '0' when nA2(wFX-1 downto eMax+wFX_F) = (wFX_I-1 downto eMax => '0') else
               '1';
  end generate;
  no_overflow0 : if eMax = wFX_I generate
    overFl0 <= '0';
  end generate;

  overflow1 : if 2**(wE-1) < wFX_I+1 and eMax+wFX_F-1 > wF generate
    overFl1 <= '1' when eR = (wE-1 downto 0 => '1') else
               '0';
  end generate;
  no_overflow1 : if 2**(wE-1) >= wFX_I+1 or eMax+wFX_F-1 <= wF generate
    overFl1 <= '0';
  end generate;

  overFl <= overFl0 or (overFl1 and not overFl0);

  undrFl0 <= '1' when nA2(wFX-1 downto wFX_F-eMin) = (wFX-1 downto wFX_F-eMin => '0') else
             '0';
  undrFl1 <= '0' when eR = (wE-1 downto 1 => '0') & "1" else
             '1';
  undrFl <= undrFl0 and undrFl1;

  eTest <= overFl & undrFl;

  with eTest select
    nR(wE+wF+2 downto wE+wF+1) <= "00" when "01",
                                  "10" when "10",
                                  "01" when others;
  nR(wE+wF downto 0) <= sR & eR & fR;
end architecture;
