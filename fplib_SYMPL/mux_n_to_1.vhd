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

entity Mux_N_To_1 is
  generic ( wIn   : positive := 1;
            wAddr : positive );
  port ( input  : in  std_logic_vector((2**wAddr)*wIn-1 downto 0);
         addr   : in  std_logic_vector(wAddr-1 downto 0);
         output : out std_logic_vector(wIn-1 downto 0) );
end entity;

architecture arch of Mux_N_To_1 is
  constant wInput : positive := 2**wAddr;

  signal tree : std_logic_vector((2**(wAddr+1)-1)*wIn-1 downto 0);
begin
  tree((2**(wAddr+1)-1)*wIn-1 downto (2**wAddr-1)*wIn) <= input;

  mux_tree : for i in wAddr-1 downto 0 generate
    with addr(i) select
      tree((2**(i+1)-1)*wIn-1 downto (2**i-1)*wIn) <= tree((4*(2**i)-1)*wIn-1 downto (3*(2**i)-1)*wIn) when '1',
                                        tree((3*(2**i)-1)*wIn-1 downto (2*(2**i)-1)*wIn) when others;
  end generate;

  output <= tree(wIn-1 downto 0);
end architecture;
