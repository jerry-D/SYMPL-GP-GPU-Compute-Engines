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

entity FPAdd_Shift_Clk is
  generic ( wE : positive;
            wF : positive );
  port ( fA  : in  std_logic_vector(wF downto 0);
         n   : in  std_logic_vector(wE-1 downto 0);
         fR  : out std_logic_vector(wF+3 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of FPAdd_Shift_Clk is
  constant maxShift : positive := minimum(log(wF+2)+1, wE);

  signal fA_1 : std_logic_vector(wF downto 0);

  signal n_1 : std_logic_vector(wE-1 downto 0);
  signal n_2 : std_logic_vector(wE-1 downto 0);

  signal shift_1 : std_logic_vector(maxShift*(wF+3)-2 downto (maxShift-2)*(wF+3));
  signal shift_2 : std_logic_vector((maxShift-1)*(wF+3)-1 downto 0);

  signal s_2 : std_logic_vector(maxShift-2 downto 0);
  signal s_1 : std_logic_vector(0 downto 0);

  signal kill_2 : std_logic;

  signal fR_2 : std_logic_vector(wF+3 downto 0);
begin
  fA_1 <= fA;
  n_1 <= n;

  shift_unit : for i in 0 to maxShift generate
    shift_first : if i = 0 generate
      with n_1(0) select
        shift_1(maxShift*(wF+3)-2 downto (maxShift-1)*(wF+3)) <= "0" & fA_1 when '1',
                                                                       fA_1 & "0" when others;
    end generate;
    
    shift_second : if i = 1 generate
      with n_1(1) select
        shift_1((maxShift-1)*(wF+3)-1 downto (maxShift-2)*(wF+3)) <=
          "00" & shift_1(maxShift*(wF+3)-2 downto (maxShift-1)*(wF+3)+1) when '1',
          shift_1(maxShift*(wF+3)-2 downto (maxShift-1)*(wF+3)) & "0"    when others;
      s_1(0) <= n_1(1) and shift_1((maxShift-1)*(wF+3));
    end generate;

    reg_1_2 : if i = 1 generate
      process(clk)
      begin
        if clk'event and clk='1' then
          n_2 <= n_1;
          shift_2((maxShift-1)*(wF+3)-1 downto (maxShift-2)*(wF+3)) <=
            shift_1((maxShift-1)*(wF+3)-1 downto (maxShift-2)*(wF+3));
          s_2(0) <= s_1(0);
        end if;
      end process;
    end generate;

--------------------------------------------------------------------------------

    shift_regular : if i > 1 and i < maxShift generate
      with n_2(i) select
        shift_2((maxShift-i)*(wF+3)-1 downto (maxShift-1-i)*(wF+3)) <=
          (2**i-1 downto 0 => '0') & shift_2((maxShift+1-i)*(wF+3)-1 downto (maxShift-i)*(wF+3)+2**i) when '1',
          shift_2((maxShift+1-i)*(wF+3)-1 downto (maxShift-i)*(wF+3))                                 when others;
      s_2(i-1) <= s_2(i-2) when shift_2((maxShift-i)*(wF+3)+2**i-1 downto (maxShift-i)*(wF+3)) =
                                (2**i-1 downto 0 => '0')                                               else
                  n_2(i) or s_2(i-2);
    end generate;
    
    shift_last : if i = maxShift generate
      shift_kill : if maxShift < wE generate
        kill_2 <= '0' when n_2(wE-1 downto maxShift) = (wE-1 downto maxShift => '0') else
                  '1';
        with kill_2 select
          fR_2(wF+3 downto 1) <= (wF+3 downto 1 => '0') when '1',
                                    shift_2(wF+2 downto 0)   when others;
        fR_2(0) <= s_2(maxShift-2) when shift_2(wF+2 downto 0) = (wF+2 downto 0 => '0') else
                   kill_2 or s_2(maxShift-2);
      end generate;
      
      shift_none : if maxShift = wE generate
        fR_2 <= shift_2(wF+2 downto 0) & s_2(maxShift-2);
      end generate;
    end generate;
  end generate;

  fR <= fR_2;
end architecture;
