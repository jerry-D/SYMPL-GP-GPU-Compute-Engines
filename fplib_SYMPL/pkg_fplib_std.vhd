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

-- Added generic parameter SzSlk === Size of Pipeline Slack added.
--      Purpose: to help adjust the containing operator network to zero slack.
--              Adds a Delay FIFO buffer, of depth SzSlk to the operator result, so that creating
--              a zero-slack pipelined operator network is easily
--              representable, using the generics.

library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_fp.all;

package pkg_fplib_std is
  component Add is
    generic ( wE  : positive := 8;
              wF  : positive := 23 );
    port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
           nB : in  std_logic_vector(wE+wF+2 downto 0);
           nR : out std_logic_vector(wE+wF+2 downto 0) );
  end component;

  component Add_Clk is
    generic ( wE  : positive := 8;
              wF  : positive := 23;
              reg : boolean  := true;
            szSlk : natural := 0);
    port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
           nB  : in  std_logic_vector(wE+wF+2 downto 0);
           nR  : out std_logic_vector(wE+wF+2 downto 0);
           clk : in  std_logic );
  end component;

  function addLatency( wE, wF : positive ; szSlk : natural) return natural;
  
  component Mul is
    generic ( wE  : positive := 8;
              wF  : positive := 23 );
    port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
           nB : in  std_logic_vector(wE+wF+2 downto 0);
           nR : out std_logic_vector(wE+wF+2 downto 0) );
  end component;

  component Mul_Clk is
    generic ( wE  : positive := 8;
              wF  : positive := 23;
              reg : boolean  := true;
            szSlk : natural := 0 );
    port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
           nB  : in  std_logic_vector(wE+wF+2 downto 0);
           nR  : out std_logic_vector(wE+wF+2 downto 0);
           clk : in  std_logic );
  end component;
  
  function mulLatency( wE, wF : positive ; szSlk : natural ) return natural;
  
  component Div is
    generic ( wE  : positive := 8;
              wF  : positive := 23 );
    port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
           nB : in  std_logic_vector(wE+wF+2 downto 0);
           nR : out std_logic_vector(wE+wF+2 downto 0) );
  end component;

  component Div_Clk is
    generic ( wE  : positive := 8;
              wF  : positive := 23;
              reg : boolean  := true;
            szSlk : natural := 0 );
    port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
           nB  : in  std_logic_vector(wE+wF+2 downto 0);
           nR  : out std_logic_vector(wE+wF+2 downto 0);
           clk : in  std_logic );
  end component;
  
  function divLatency( wE, wF : positive ; szSlk : natural ) return natural;
  
  component Sqrt is
    generic ( wE  : positive := 8;
              wF  : positive := 23 );
    port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
           nR : out std_logic_vector(wE+wF+2 downto 0) );
  end component;

  component Sqrt_Clk is
    generic ( wE  : positive := 8;
              wF  : positive := 23;
              reg : boolean  := true;
            szSlk : natural := 0 );
    port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
           nR  : out std_logic_vector(wE+wF+2 downto 0);
           clk : in  std_logic );
  end component;

  function sqrtLatency(  wE, wF : positive ; szSlk : natural ) return natural;
  
  component FXP_To_FP is
    generic ( wE    : positive := 8;
              wF    : positive := 23;
              wFX_I : positive := 8;
              wFX_F : positive := 23 );
    port ( nA : in  std_logic_vector(wFX_I+wFX_F-1 downto 0);
           nR : out std_logic_vector(wE+wF+2 downto 0));
  end component;

  component FP_To_FXP is
    generic ( wE    : positive := 8;
              wF    : positive := 23;
              wFX_I : positive := 8;
              wFX_F : positive := 23 );
    port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
           nR : out std_logic_vector(wFX_I+wFX_F-1 downto 0));
  end component;

  component IEEE754_To_FP is
    generic ( wE : positive := 8;
              wF : positive := 23 );
    port ( nA : in  std_logic_vector(wE+wF downto 0);
           nR : out std_logic_vector(wE+wF+2 downto 0));
  end component;

  component FP_To_IEEE754 is
    generic ( wE : positive := 8;
              wF : positive := 23 );
    port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
           nR : out std_logic_vector(wE+wF downto 0));
  end component;

end package;

package body pkg_fplib_std is
  function addLatency( wE, wF : positive; szSlk : natural ) return natural is
  begin
      return fpaddLatency(wE, wF) + szSlk;
  end function;
  
  function mulLatency( wE, wF : positive; szSlk : natural ) return natural is
  begin
      return fpmulLatency(wE, wF) + szSlk;
  end function;
  
  function divLatency( wE, wF : positive; szSlk : natural ) return natural is
  begin
      return fpdivLatency(wE, wF) + szSlk;
  end function;
  
  function sqrtLatency( wE, wF : positive; szSlk : natural ) return natural is
  begin
      return fpsqrtLatency(wE, wF) + szSlk;
  end function;
end package body;

-------------------------------------------------------------------------------
-- IEEE 754 Conversion Components
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity IEEE754_To_FP is
  generic ( wE : positive := 8;
            wF : positive := 23 );
  port ( nA : in  std_logic_vector(wE+wF downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0));
end entity;

architecture arch of IEEE754_To_FP is
  signal eMax  : std_logic;
  signal eMin  : std_logic;
  signal eTest : std_logic_vector(1 downto 0);
  signal fZero : std_logic;
begin
  eMax <= '1' when nA(wE+wF-1 downto wF) = (wE-1 downto 0 => '1') else
          '0';
  eMin <= '1' when nA(wE+wF-1 downto wF) = (wE-1 downto 0 => '0') else
          '0';
  eTest <= eMax & eMin;

  fZero <= '0' when nA(wF-1 downto 0) = (wF-1 downto 0 => '0') else
           '1';

  with eTest select
    nR(wE+wF+2 downto wE+wF+1) <= "00"        when "01",
                                  "1" & fZero when "10",
                                  "01"        when others;
  nR(wE+wF downto wF) <= nA(wE+wF downto wF);

  with eMin select
    nR(wF-1 downto 0) <= (wF-1 downto 0 => '0') when '1',
                         nA(wF-1 downto 0)      when others;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FP_To_IEEE754 is
  generic ( wE : positive := 8;
            wF : positive := 23 );
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF downto 0));
end entity;

architecture arch of FP_To_IEEE754 is
  signal xA : std_logic_vector(1 downto 0);
begin
  xA <= nA(wE+wF+2 downto wE+wF+1);

  with xA select
    nR <= nA(wE+wF) & (wE+wF-1 downto 0 => '0')                                   when "00",
          nA(wE+wF downto 0)                                                      when "01",
          nA(wE+wF) & (wE+wF-1 downto wF => '1') & (wF-1 downto 1 => '0') & xA(0) when others;
end architecture;

