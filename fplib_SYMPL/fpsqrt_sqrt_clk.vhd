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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_misc.all;
use fplib.pkg_fpsqrt.all;

entity FPSqrt_Sqrt_Clk is
  generic ( wF : positive );
  port ( fA  : in  std_logic_vector(wF+1 downto 0);
         fR  : out std_logic_vector(wF+3 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of FPSqrt_Sqrt_Clk is
  signal x  : std_logic_vector((wF+3)*(wF+4)-1 downto 0);
  signal w  : std_logic_vector((wF+2)*(wF+4)-1 downto 0);
  signal d  : std_logic_vector(wF+3 downto 0);
  signal s  : std_logic_vector((wF+3)*(wF+4)-1 downto 0);
begin
  x((wF+3)*(wF+4)-1 downto (wF+2)*(wF+4)) <= "11" & fA;
  d(wF+3) <= '0';
  s((wF+3)*(wF+4)-1) <= '1';
  sqrt : for i in wF+2 downto 1 generate
    step : FPSqrt_SRT2_Step
      generic map ( wF => wF,
                    step  => wF+3-i )
      port map ( x => x((i+1)*(wF+4)-1 downto i*(wF+4)),
                 s => s((i+1)*(wF+4)-1 downto i*(wF+4)+i+1),
                 d => d(i),
                 w => w(i*(wF+4)-1 downto (i-1)*(wF+4)) );
    
    reg : if (wF+2-i) mod 2 = 1 generate
      process(clk)
      begin
        if clk'event and clk='1' then
          s(i*(wF+4)-1 downto (i-1)*(wF+4)+i) <= s((i+1)*(wF+4)-1 downto i*(wF+4)+i+2) & (not d(i)) & '1';
          x(i*(wF+4)-1 downto (i-1)*(wF+4)) <= w(i*(wF+4)-1 downto (i-1)*(wF+4));
        end if;
      end process;
    end generate;

    noreg : if (wF+2-i) mod 2 = 0 generate
      first : if i = wF+2 generate
        s(i*(wF+4)-1 downto (i-1)*(wF+4)+i) <= (not d(i)) & '1';
      end generate;
      regular : if i < wF+2 generate
        s(i*(wF+4)-1 downto (i-1)*(wF+4)+i) <= s((i+1)*(wF+4)-1 downto i*(wF+4)+i+2) & (not d(i)) & '1';
      end generate;
      x(i*(wF+4)-1 downto (i-1)*(wF+4)) <= w(i*(wF+4)-1 downto (i-1)*(wF+4));
    end generate;
  end generate;
  
  d(0) <= x(wF+3);

  fR <= s(wF+3 downto 2) & (not d(0)) & '1';
end architecture;
