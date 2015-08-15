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

package pkg_fpdiv is
  function divLatency( wF : positive ) return natural;

  component FPDiv_SRT4_Step is
    generic ( wF : positive );
    port ( x  : in  std_logic_vector(wF+2 downto 0);
           d  : in  std_logic_vector(wF downto 0);
           d3 : in  std_logic_vector(wF+2 downto 0);
           q  : out std_logic_vector(2 downto 0);
           w  : out std_logic_vector(wF+2 downto 0) );
  end component;

  component FPDiv_Division is
    generic ( wF : positive );
    port ( fA : in  std_logic_vector(wF downto 0);
           fB : in  std_logic_vector(wF downto 0);
           fR : out std_logic_vector(wF+3 downto 0) );
  end component;
  
  component FPDiv_Division_Clk is
    generic ( wF : positive );
    port ( fA  : in  std_logic_vector(wF downto 0);
           fB  : in  std_logic_vector(wF downto 0);
           fR  : out std_logic_vector(wF+3 downto 0);
           clk : in  std_logic );
  end component;
end package;

package body pkg_fpdiv is
  function divLatency( wF : positive ) return natural is
  begin
    return (wF+4)/2 ;
  end function;
end package body;
