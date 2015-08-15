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

entity FXP_Shift is
  generic ( wE  : positive;
            wFX : positive );
  port ( fA : in  std_logic_vector(wFX+1 downto 0);
         n  : in  std_logic_vector(wE-1 downto 0);
         fR : out std_logic_vector(wFX+1 downto 0) );
end entity;

architecture arch of FXP_Shift is
  constant maxShift : positive := min(log(wFX)+1, wE);

  signal shift : std_logic_vector((maxShift+1)*(wFX+1)-1 downto 0);
  signal s     : std_logic_vector(maxShift downto 0);
  signal kill  : std_logic;
begin
  shift(wFX downto 0) <= fA(wFX+1 downto 1);
  s(0) <= fA(0);

  shift_unit : for i in 0 to maxShift generate
    shift_regular : if i < maxShift generate
      with n(i) select
        shift((i+2)*(wFX+1)-1 downto (i+1)*(wFX+1)) <=
          (2**i-1 downto 0 => '0') & shift((i+1)*(wFX+1)-1 downto i*(wFX+1)+2**i) when '1',
          shift((i+1)*(wFX+1)-1 downto i*(wFX+1))                                 when others;
      s(i+1) <= s(i) when shift(i*(wFX+1)+2**i-1 downto i*(wFX+1)) = (2**i-1 downto 0 => '0') else
                n(i) or s(i);
    end generate;
    
    shift_last : if i = maxShift generate
      shift_kill : if maxShift < wE generate
        kill <= '0' when n(wE-1 downto maxShift) = (wE-1 downto maxShift => '0') else
                '1';
        with kill select
          fR(wFX+1 downto 1) <= (wFX+1 downto 1 => '0')                               when '1',
                                shift((maxShift+1)*(wFX+1)-1 downto maxShift*(wFX+1)) when others;
        fR(0) <= s(maxShift) when shift((maxShift+1)*(wFX+1)-1 downto maxShift*(wFX+1)) = (wFX downto 0 => '0') else
                 kill or s(maxShift);
      end generate;
      
      shift_none : if maxShift = wE generate
        fR <= shift((maxShift+1)*(wFX+1)-1 downto maxShift*(wFX+1)) & s(maxShift);
      end generate;
    end generate;
  end generate;
end architecture;
