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

-- Copyright 2007 OptNgn Software
-- Added support for operator Slack adjustment, in an operator network,
--      via a Delay FIFO attached to the operator output.
--

library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;

entity Add is
  generic ( wE  : positive := 6;
            wF  : positive := 13);
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nB : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end entity;

architecture arch of Add is
begin
    add : FPAdd generic map (wE => wE, wF => wF) port map (nA => nA, nB => nB, nR => nR);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;
use fplib.pkg_misc.all;

entity Add_Clk is
  generic (
            wE  : positive := 6;
            wF  : positive := 13;
            reg : boolean  := true;
            SzSlk  : natural  := 0 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nB  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of Add_Clk is
  signal pipebuf_nR  : std_logic_vector(wE+wF+2 downto 0);
begin
    wreg : if reg = true generate
      addreg : FPAdd_Clk generic map ( wE => wE, wF => wF )
                      port map ( nA  => nA, nB => nB, nR  => pipebuf_nR, clk => clk );
      
      wPipeBuf : if SzSlk>=0 generate
        add_pipeBuf: Delay
          generic map (w=>wE+wF+2+1, n=> SzSlk)
          port map (input=> pipebuf_nR, output=>nR, clk=> clk);
      end generate;    
    end generate;

    woreg_woPipeBuf : if reg = false generate
      addcmb : FPAdd
        generic map ( wE => wE, wF => wF )
        port map ( nA  => nA, nB  => nB, nR  => nR );
    end generate;
       
end architecture;


library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;


entity Mul is
  generic ( wE  : positive := 6;
            wF  : positive := 13 );
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nB : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end entity;

architecture arch of Mul is
begin
    mul : FPMul  generic map ( wE => wE,  wF => wF)
                 port map ( nA => nA, nB => nB,  nR => nR );
end architecture;


library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;
use fplib.pkg_misc.all;

entity Mul_Clk is
  generic ( wE  : positive := 6;
            wF  : positive := 13;
            reg : boolean  := true;
            SzSlk  : natural  := 0 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nB  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of Mul_Clk is
  signal pipebuf_nR  : std_logic_vector(wE+wF+2 downto 0);
begin
    wreg : if reg = true generate
      mulreg : FPMul_Clk
        generic map ( wE => wE,  wF => wF )
        port map ( nA  => nA,  nB  => nB,  nR  => pipebuf_nR, clk => clk );
      wreg_wPipeBuf : if SzSlk>=0 generate
        mul_pipeBuf: Delay
          generic map (w=>wE+wF+2+1, n=> SzSlk)
          port map (input=> pipebuf_nR, output=>nR, clk=> clk);
      end generate;    
    end generate;

    woreg_woPipeBuf : if reg = false generate
      mulcmb : FPMul
        generic map ( wE => wE, wF => wF )
        port map ( nA  => nA, nB  => nB, nR  => nR );
    end generate;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;

entity Div is
  generic ( wE  : positive := 6;
            wF  : positive := 13 );
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nB : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end entity;

architecture arch of Div is
begin
    div : FPDiv
      generic map ( wE => wE, wF => wF )
      port map ( nA => nA, nB => nB, nR => nR );
end architecture;


library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;
use fplib.pkg_misc.all;

entity Div_Clk is
  generic ( wE  : positive := 6;
            wF  : positive := 13;
            reg : boolean  := true;
            SzSlk  : natural  := 0 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nB  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of Div_Clk is
  signal pipebuf_nR  : std_logic_vector(wE+wF+2 downto 0);
begin

    wreg : if reg = true generate
      divreg : FPDiv_Clk
        generic map ( wE => wE, wF => wF )
        port map ( nA  => nA,  nB  => nB,  nR  =>  pipebuf_nR, clk => clk );
            
      wreg_wPipeBuf : if SzSlk>=0 generate
        div_pipeBuf: Delay
          generic map (w=>wE+wF+2+1, n=> SzSlk)
          port map (input=> pipebuf_nR, output=>nR, clk=> clk);
      end generate;    
    end generate;

    woreg_woPipeBuf  : if reg = false generate
      divcmb : FPDiv
        generic map ( wE => wE, wF => wF )
        port map ( nA  => nA,  nB  => nB, nR  => nR );
    end generate;

end architecture;


library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;

entity Sqrt is
  generic ( wE  : positive := 6;
            wF  : positive := 13 );
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end entity;

architecture arch of Sqrt is
begin
    sqrt : FPSqrt
      generic map ( wE => wE, wF => wF )
      port map ( nA => nA, nR => nR );
end architecture;


library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;
use fplib.pkg_misc.all;

entity Sqrt_Clk is
  generic (
            wE  : positive := 6;
            wF  : positive := 13;
            reg : boolean  := true;
            SzSlk  : natural  := 0 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of Sqrt_Clk is
  signal pipebuf_nR  : std_logic_vector(wE+wF+2 downto 0);
begin
    wreg : if reg = true generate
      sqrtreg : FPSqrt_Clk
        generic map ( wE => wE,   wF => wF )
        port map ( nA  => nA,   nR  => pipebuf_nR ,  clk => clk );
            
      wreg_wPipeBuf : if SzSlk>=0 generate
        sqrt_pipeBuf: Delay
          generic map (w=>wE+wF+2+1, n=> SzSlk)
          port map (input=> pipebuf_nR, output=>nR, clk=> clk);
      end generate;    
    end generate;

    woreg_woPipeBuf : if reg = false generate
        sqrtcmb : FPSqrt
      generic map ( wE => wE, wF => wF )
      port map ( nA => nA, nR => nR );
    end generate;
end architecture;
