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

entity FPAdd_Shift is
  generic ( wE : positive;
            wF : positive );
  port ( fA : in  std_logic_vector(wF downto 0);
         n  : in  std_logic_vector(wE-1 downto 0);
         fR : out std_logic_vector(wF+3 downto 0) );
end entity;

architecture arch of FPAdd_Shift is
  constant maxShift : positive := minimum(log(wF+2)+1, wE);

  signal shift : std_logic_vector(maxShift*(wF+3)-2 downto 0);
  signal s     : std_logic_vector(maxShift-2 downto 0);
  signal kill  : std_logic;
begin
  shift_unit : for i in 0 to maxShift generate
    shift_first : if i = 0 generate
      with n(0) select
        shift(maxShift*(wF+3)-2 downto (maxShift-1)*(wF+3)) <= "0" & fA when '1',
                                                                     fA & "0" when others;
    end generate;
    
    shift_second : if i = 1 generate
      with n(1) select
        shift((maxShift-1)*(wF+3)-1 downto (maxShift-2)*(wF+3)) <=
          "00" & shift(maxShift*(wF+3)-2 downto (maxShift-1)*(wF+3)+1) when '1',
          shift(maxShift*(wF+3)-2 downto (maxShift-1)*(wF+3)) & "0"    when others;
      s(0) <= n(1) and shift((maxShift-1)*(wF+3));
    end generate;
    
    shift_regular : if i > 1 and i < maxShift generate
      with n(i) select
        shift((maxShift-i)*(wF+3)-1 downto (maxShift-1-i)*(wF+3)) <=
          (2**i-1 downto 0 => '0') & shift((maxShift+1-i)*(wF+3)-1 downto (maxShift-i)*(wF+3)+2**i) when '1',
          shift((maxShift+1-i)*(wF+3)-1 downto (maxShift-i)*(wF+3))                                 when others;
      s(i-1) <= s(i-2) when shift((maxShift-i)*(wF+3)+2**i-1 downto (maxShift-i)*(wF+3)) =
                            (2**i-1 downto 0 => '0')                                             else
                n(i) or s(i-2);
    end generate;
    
    shift_last : if i = maxShift generate
      shift_kill : if maxShift < wE generate
        kill <= '0' when n(wE-1 downto maxShift) = (wE-1 downto maxShift => '0') else
                '1';
        with kill select
          fR(wF+3 downto 1) <= (wF+3 downto 1 => '0') when '1',
                                  shift(wF+2 downto 0)   when others;
        fR(0) <= s(maxShift-2) when shift(wF+2 downto 0) = (wF+2 downto 0 => '0') else
                 kill or s(maxShift-2);
      end generate;
      
      shift_none : if maxShift = wE generate
        fR <= shift(wF+2 downto 0) & s(maxShift-2);
      end generate;
    end generate;
  end generate;
end architecture;
