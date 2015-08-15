-- Copyright 2003-2006 Jérémie Detrey, Florent de Dinechin
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
use work.pkg_fp_exp.all;

package pkg_exp is

  function fp_exp_latency ( wE, wF : positive ) 
    return positive;

  component Exp is
  generic ( wE  : positive := 6;
            wF  : positive := 13);
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end component;

  component Exp_Clk is
  generic (
            wE  : positive := 6;
            wF  : positive := 13;
            reg : boolean  := true;
            SzSlk  : natural  := 0 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end component;

function exp_latency ( wE, wF : positive; SzSlk  : natural ) 
    return positive;

end package;

package body pkg_exp is

  function fp_exp_latency ( wE, wF : positive ) return positive is
    constant g   : positive := fp_exp_g(wF);
    constant wY1 : positive := fp_exp_wy1(wF);
    constant wY2 : positive := fp_exp_wy2(wF);
  begin
    return (  fp_exp_shift_latency(wE, wF) + mult_latency(wE+4, wE+2, 0, 3) + mult_latency(wE+1, wE-1+wF+g, -1, 2)
            + fp_exp_exp_y2_latency(wF) + fp_exp_add_z0_latency(wF) + mult_latency(wF+g, wF+g-wY1+2, 0, 2) + 3 );
  end function;

  function exp_latency ( wE, wF : positive; SzSlk: natural ) return positive is
    constant eLat   : positive := fp_exp_latency ( wE, wF);
  begin
    return ( eLat + SzSlk );
  end function;

end package body;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use work.pkg_fp_exp.all;

entity Exp is
  generic ( wE  : positive := 6;
            wF  : positive := 13);
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end entity;

architecture arch of Exp is
begin
    exp : fp_exp generic map (wE => wE, wF => wF) port map  (fpX=> nA, fpR => nR);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library fplib;
use work.pkg_fp_exp.all;
use fplib.pkg_misc.all;

entity Exp_Clk is
  generic (
            wE  : positive := 6;
            wF  : positive := 13;
            reg : boolean  := true;
            SzSlk  : natural  := 0 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of Exp_Clk is
  signal pipebuf_nR  : std_logic_vector(wE+wF+2 downto 0);
begin
    wreg : if reg = true generate
      expreg : fp_exp_clk generic map ( wE => wE, wF => wF )
                      port map ( fpX  => nA, fpR  => pipebuf_nR, clk => clk );
      
      wPipeBuf : if SzSlk>=0 generate
        exp_pipeBuf: Delay
          generic map (w=>wE+wF+2+1, n=> SzSlk)
          port map (input=> pipebuf_nR, output=>nR, clk=> clk);
      end generate;    
    end generate;

    woreg_woPipeBuf : if reg = false generate
      expcmb : fp_exp
        generic map ( wE => wE, wF => wF )
        port map ( fpX  => nA, fpR  => nR );
    end generate;
       
end architecture;

