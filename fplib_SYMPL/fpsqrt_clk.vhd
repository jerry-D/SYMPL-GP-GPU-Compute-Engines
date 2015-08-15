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
use fplib.pkg_fpsqrt.all;
use fplib.pkg_misc.all;
use fplib.pkg_fp_misc.all;

entity FPSqrt_Clk is
  generic ( wE : positive := 8;
            wF : positive := 23 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of FPSqrt_Clk is
  signal nA_1 : std_logic_vector(wE+wF+2 downto 0);
  
  signal fA0_1 : std_logic_vector(wF+1 downto 0);

  signal eRn0_1  : std_logic_vector(wE downto 0);
  signal fRn0_10 : std_logic_vector(wF+3 downto 0);
  signal eRn1_1  : std_logic_vector(wE downto 0);
  signal eRn1_11 : std_logic_vector(wE downto 0);
  signal fRn1_10 : std_logic_vector(wF+2 downto 0);
  signal fRn1_11 : std_logic_vector(wF+2 downto 0);
  signal sRn_1   : std_logic;
  signal sRn_12  : std_logic;
  signal eRn_11  : std_logic_vector(wE downto 0);
  signal eRn_12  : std_logic_vector(wE downto 0);
  signal fRn_11  : std_logic_vector(wF downto 0);
  signal fRn_12  : std_logic_vector(wF downto 0);
  signal nRn_12  : std_logic_vector(wE+wF+2 downto 0);

  signal xsA_1  : std_logic_vector(2 downto 0);
  signal xsA_12 : std_logic_vector(2 downto 0);

  signal nR_12 : std_logic_vector(wE+wF+2 downto 0);
begin
  nA_1 <= nA;
  
  fA0_1 <= "1" & nA_1(wF-1 downto 0) & "0" when nA_1(wF) = '0' else
           "01" & nA_1(wF-1 downto 0);

  sqrt : FPSqrt_Sqrt_Clk
    generic map ( wF => wF )
    port map ( fA  => fA0_1,
               fR  => fRn0_10,
               clk => clk );
  with fRn0_10(wF+3) select
    fRn1_10(wF+2 downto 0) <= fRn0_10(wF+3 downto 2) & (fRn0_10(1) or fRn0_10(0)) when '1',
                                 fRn0_10(wF+2 downto 0)                              when others;

  eRn0_1 <= "00" & nA_1(wE+wF-1 downto wF+1);
  eRn1_1 <= eRn0_1 + ("000" & (wE-3 downto 0 => '1')) + nA_1(wF);

  ern1_delay : Delay
    generic map ( w => wE+1,
                  n => sqrtLatency(wF)+1 )
    port map ( input  => eRn1_1, -----------------------------------------------
               output => eRn1_11, ----------------------------------------------
               clk    => clk );

  process(clk)
  begin
    if clk'event and clk='1' then
      fRn1_11 <= fRn1_10;
    end if;
  end process;

--------------------------------------------------------------------------------

  round : FP_Round
    generic map ( wE => wE,
                  wF => wF )
    port map ( eA => eRn1_11,
               fA => fRn1_11,
               eR => eRn_11,
               fR => fRn_11 );

  sRn_1 <= nA_1(wE+wF);

  srn_delay : Delay
    generic map ( w => 1,
                  n => sqrtLatency(wF)+2 )
    port map ( input(0)  => sRn_1, ---------------------------------------------
               output(0) => sRn_12, --------------------------------------------
               clk       => clk );

  process(clk)
  begin
    if clk'event and clk='1' then
      eRn_12 <= eRn_11;
      fRn_12 <= fRn_11;
    end if;
  end process;
  
--------------------------------------------------------------------------------

  format : FP_Format
    generic map ( wE => wE,
                  wF => wF )
    port map ( sA => sRn_12,
               eA => eRn_12,
               fA => fRn_12,
               nR => nRn_12 );

  xsA_1 <= nA_1(wE+wF+2 downto wE+wF);

  xsa_delay : Delay
    generic map ( w => 3,
                  n => sqrtLatency(wF)+2 )
    port map ( input  => xsA_1, ------------------------------------------------
               output => xsA_12, -----------------------------------------------
               clk    => clk );

  with xsA_12 select
    nR_12(wE+wF+2 downto wE+wF+1) <= nRn_12(wE+wF+2 downto wE+wF+1) when "010",
                                               xsA_12(2 downto 1)                       when "001" | "000" | "100",
                                               "11"                                     when others;
  nR_12(wE+wF downto 0) <= nRn_12(wE+wF downto 0);

  nR <= nR_12;
end architecture;
