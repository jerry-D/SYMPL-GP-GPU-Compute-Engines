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

package pkg_fpmul is
  constant wSlice      : positive := 4;
  constant regOffset   : natural  := 1;
  constant regPeriod   : positive := 2;
  function prodLatency( wF : positive ) return natural;

  component FPMul_Product is
    generic ( wF : positive );
    port ( fA : in  std_logic_vector(wF downto 0);
           fB : in  std_logic_vector(wF downto 0);
           fR : out std_logic_vector(2*wF+1 downto 0) );
  end component;

  component FPMul_AddTree_Clk is
    generic ( wF  : positive;
              nPProd : positive;
              wS     : positive;
              depth  : natural );
    port ( pprod : in  std_logic_vector(((nPProd+wS-1)/wS)*(wF+1+wS)-(wS-((nPProd-1) mod wS)-1)-1 downto 0);
           sum   : out std_logic_vector(wF+nPProd downto 0);
           clk   : in  std_logic );
  end component;

  component FPMul_Product_Clk is
    generic ( wF : positive );
    port ( fA  : in  std_logic_vector(wF downto 0);
           fB  : in  std_logic_vector(wF downto 0);
           fR  : out std_logic_vector(2*wF+1 downto 0);
           clk : in  std_logic );
  end component;
end package;

package body pkg_fpmul is
  function prodLatency( wF : positive ) return natural is
    variable depth : natural;
  begin
    if wF+1 <= wSlice then
      depth := 0;
    else
      depth := log((wF+wSlice)/wSlice-1)+1;
    end if;
    return (depth+1 - regOffset + regPeriod-1) / regPeriod;
  end function;
end package body;
