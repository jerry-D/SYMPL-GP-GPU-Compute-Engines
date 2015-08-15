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
use fplib.pkg_fp_log.all;
use fplib.pkg_misc.all;

package pkg_log is

  function fp_log_latency ( wE, wF : positive ) 
    return positive;

  component Log is
  generic ( wE  : positive := 6;
            wF  : positive := 13);
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end component;

  component Log_Clk is
  generic (
            wE  : positive := 6;
            wF  : positive := 13;
            reg : boolean  := true;
            SzSlk  : natural  := 0 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end component;

function log_latency ( wE, wF : positive; SzSlk  : natural ) 
    return positive;

end package;

package body pkg_log is

  
  function fp_log_latency ( wE, wF : positive ) return positive is
    constant g     : positive := fp_log_log_g(wF+1);
    constant latD0 : positive := max(1 + mult_latency(wE, wF+3, 0, 2), fp_log_log_latency(wF+1) + mult_latency(wF+1, wF+g+2, 0, 2));
  begin
    return latD0 + 2;
  end function;
  
  function log_latency ( wE, wF : positive; SzSlk: natural ) return positive is
    constant eLat   : positive := fp_log_latency ( wE, wF);
  begin
    return ( eLat + SzSlk );
  end function;

end package body;
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_fp_log.all;

entity Log is
  generic ( wE  : positive := 6;
            wF  : positive := 13);
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end entity;

architecture arch of Log is
begin
    log : fp_log generic map (wE => wE, wF => wF) port map  (fpX=> nA, fpR => nR);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library fplib;
use fplib.pkg_fp_log.all;
use fplib.pkg_misc.all;

entity Log_Clk is
  generic (
            wE  : positive := 6;
            wF  : positive := 13;
            reg : boolean  := true;
            SzSlk  : natural  := 0 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of Log_Clk is
  signal pipebuf_nR  : std_logic_vector(wE+wF+2 downto 0);
begin
    wreg : if reg = true generate
      logreg : fp_log_clk generic map ( wE => wE, wF => wF )
                      port map ( fpX  => nA, fpR  => pipebuf_nR, clk => clk );
      
      wPipeBuf : if SzSlk>=0 generate
        log_pipeBuf: Delay
          generic map (w=>wE+wF+2+1, n=> SzSlk)
          port map (input=> pipebuf_nR, output=>nR, clk=> clk);
      end generate;    
    end generate;

    woreg_woPipeBuf : if reg = false generate
      logcmb : fp_log
        generic map ( wE => wE, wF => wF )
        port map ( fpX  => nA, fpR  => nR );
    end generate;
       
end architecture;

