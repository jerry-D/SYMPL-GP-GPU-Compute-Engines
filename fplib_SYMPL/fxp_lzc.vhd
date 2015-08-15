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

entity FXP_LZC is
  generic ( w : positive );
  port ( f : in  std_logic_vector(w-1 downto 0);
         n : out std_logic_vector(log((w+3)/4)+2 downto 2) );
end entity;

architecture arch of FXP_LZC is
  constant nBlock     : positive := (w+3)/4;
  constant wN         : positive := log(nBlock)+3;
  constant wLastBlock : positive := w-4*(nBlock-1);
  constant wRanges    : positive := 2**(wN-2)-1;
  constant wTree      : positive := 2**(wN-2)-2*(wN-3);

  signal zeros  : std_logic_vector(nBlock-1 downto 0);
  signal ranges : std_logic_vector(wRanges-1 downto 0);
  signal n0     : std_logic_vector(wN-3 downto 0);
begin
  scan_zeros : for i in 0 to nBlock-1 generate
    regular_block : if i < nBlock-1 or (i = nBlock-1 and w+3-4*nBlock = 3) generate
      zeros(nBlock-1-i) <= '1' when f(w-1-4*i downto w-4-4*i) = "0000" else
                           '0';
    end generate;

    last_block : if i = nBlock-1 and w+3-4*nBlock < 3 generate
--      zeros(0) <= '1' when f(w+3-4*nBlock downto 0) = (w+3-4*nBlock downto 0 => '0') else
--                  '0';
      zeros(0) <= '0';
    end generate;
  end generate;

  scan_ranges : for i in 0 to wN-3 generate
    scan_ranges_sub : block
      constant rangeLen : positive := 2**(wN-3-i);
    begin
      scan_ranges_sub : for j in 0 to 2**i-1 generate
        scan_unit : block
          constant rangeIdx : integer := nBlock - (2*j+1)*rangeLen;
        begin
          scan_regular : if rangeIdx >= 0 generate
            ranges(2**i-1+j) <= '1' when zeros(rangeIdx+rangeLen-1 downto rangeIdx) =
                                         (rangeLen-1 downto 0 => '1') else
                                '0';
          end generate;
          scan_dummy : if rangeIdx < 0 generate
            ranges(2**i-1+j) <= '0';
          end generate;
        end block;
      end generate;
    end block;
  end generate;

  count_tree : for i in wN-3 downto 0 generate
    count_first : if i = wN-3 generate
      n0(i) <= ranges(0);
    end generate;
    count_regular : if i < wN-3 generate
      count_mux : Mux_N_To_1
        generic map ( wAddr => wN-3-i )
        port map ( input => ranges(2**(wN-2-i)-2 downto 2**(wN-3-i)-1),
                   addr => n0(wN-3 downto i+1),
                   output => n0(i downto i) );
    end generate;
  end generate;

  n <= n0;
end architecture;
