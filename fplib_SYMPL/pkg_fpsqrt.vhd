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
library fplib;
use fplib.pkg_misc.all;

package pkg_fpsqrt is
  function sqrtLatency( wF : positive ) return natural;

  component FPSqrt_SRT2_Step is
    generic ( wF : positive;
              step  : positive );
    port ( x : in  std_logic_vector(wF+3 downto 0);
           s : in  std_logic_vector(wF+3 downto wF+4-step);
           d : out std_logic;
           w : out std_logic_vector(wF+3 downto 0) );
  end component;

  component FPSqrt_Sqrt is
    generic ( wF : positive );
    port ( fA  : in  std_logic_vector(wF+1 downto 0);
           fR  : out std_logic_vector(wF+3 downto 0) );
  end component;

  component FPSqrt_Sqrt_Clk is
    generic ( wF : positive );
    port ( fA  : in  std_logic_vector(wF+1 downto 0);
           fR  : out std_logic_vector(wF+3 downto 0);
           clk : in  std_logic );
  end component;
end package;

package body pkg_fpsqrt is
  function sqrtLatency( wF : positive ) return natural is
  begin
    return (wF+2)/2;
  end function;
end package body;
