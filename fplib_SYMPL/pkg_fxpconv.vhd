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
library fplib;
use fplib.pkg_misc.all;

package pkg_fxpconv is
  component FXP_LZC is
    generic ( w : positive );
    port ( f : in  std_logic_vector(w-1 downto 0);
           n : out std_logic_vector(log((w+3)/4)+2 downto 2) );
  end component;

  component FXP_Norm is
    generic ( wE    : positive;
              wF    : positive;
              wFX_I : positive;
              wFX_F : positive;
              wN    : positive );
    port ( nA : in  std_logic_vector(wFX_I+wFX_F-1 downto 0);
           n  : in  std_logic_vector(wN-1 downto 2);
           eR : out std_logic_vector(wE-1 downto 0);
           fR : out std_logic_vector(wF-1 downto 0) );
  end component;

  component FXP_Shift is
    generic ( wE  : positive;
              wFX : positive );
    port ( fA : in  std_logic_vector(wFX+1 downto 0);
           n  : in  std_logic_vector(wE-1 downto 0);
           fR : out std_logic_vector(wFX+1 downto 0) );
  end component;
end package;
