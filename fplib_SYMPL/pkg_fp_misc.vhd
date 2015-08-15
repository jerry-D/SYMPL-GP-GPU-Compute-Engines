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

package pkg_fp_misc is
  component FP_Round is
    generic ( wE : positive;
              wF : positive );
    port ( eA : in  std_logic_vector(wE downto 0);
           fA : in  std_logic_vector(wF+2 downto 0);
           eR : out std_logic_vector(wE downto 0);
           fR : out std_logic_vector(wF downto 0) );
  end component;

  component FP_Format is
    generic ( wE : positive;
              wF : positive );
    port ( sA : in  std_logic;
           eA : in  std_logic_vector(wE downto 0);
           fA : in  std_logic_vector(wF downto 0);
           nR : out std_logic_vector(wE+wF+2 downto 0) );
  end component;
end package;
