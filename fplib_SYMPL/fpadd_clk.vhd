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
use fplib.pkg_fpadd.all;
use fplib.pkg_misc.all;
use fplib.pkg_fp_misc.all;

entity FPAdd_Clk is
  generic ( wE : positive := 8;
            wF : positive := 23 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nB  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of FPAdd_Clk is
  signal nA_1 : std_logic_vector(wE+wF+2 downto 0);
  signal nB_1 : std_logic_vector(wE+wF+2 downto 0);

  signal sAB_1 : std_logic;
  signal sAB_2 : std_logic;
  signal sAB_3 : std_logic;
  signal sAB_4 : std_logic;

  signal nA0_1 : std_logic_vector(wE+wF+2 downto 0);
  signal nA0_2 : std_logic_vector(wE+wF+2 downto 0);
  signal nA0_3 : std_logic_vector(wE+wF+2 downto 0);
  signal nA0_4 : std_logic_vector(wE+wF+2 downto 0);
  signal nB0_1 : std_logic_vector(wE+wF+2 downto 0);
  signal nB0_2 : std_logic_vector(wE+wF+2 downto 0);
  signal nB0_3 : std_logic_vector(wE+wF+2 downto 0);
  signal nB0_4 : std_logic_vector(wE+wF+2 downto 0);

  signal expDiff_1 : std_logic_vector(wE-1 downto 0);
  signal close_1   : std_logic;
  signal close_2   : std_logic;
  signal close_3   : std_logic;
  signal close_4   : std_logic;

  signal fAc1_1 : std_logic_vector(wF+2 downto 0);
  signal fBc1_1 : std_logic_vector(wF+2 downto 0);
  signal fRc0_1 : std_logic_vector(wF+2 downto 0);
  signal fRc0_2 : std_logic_vector(wF+2 downto 0);
  signal fRc0_3 : std_logic_vector(wF+2 downto 0);
  signal eRc1_3 : std_logic_vector(wE downto 0);
  signal fRc1_2 : std_logic_vector(wF+1 downto 0);
  signal fRc1_3 : std_logic_vector(wF+1 downto 0);
  signal eRc_3  : std_logic_vector(wE downto 0);
  signal fRc_3  : std_logic_vector(wF downto 0);
  signal eRc_4  : std_logic_vector(wE downto 0);
  signal fRc_4  : std_logic_vector(wF downto 0);

  constant wNZeros : natural := log((wF+5)/4)+3;
  signal nZeros_2 : std_logic_vector(wNZeros-1 downto 2);
  signal nZeros_3 : std_logic_vector(wNZeros-1 downto 2);

  signal fBf1_1 : std_logic_vector(wF downto 0);
  signal fBf2_2 : std_logic_vector(wF+3 downto 0);
  signal fAf3_2 : std_logic_vector(wF+4 downto 0);
  signal fBf3_2 : std_logic_vector(wF+4 downto 0);
  signal eRf0_3 : std_logic_vector(wE downto 0);
  signal fRf0_2 : std_logic_vector(wF+4 downto 0);
  signal fRf0_3 : std_logic_vector(wF+4 downto 0);
  signal eRf1_3 : std_logic_vector(wE downto 0);
  signal fRf1_3 : std_logic_vector(wF+2 downto 0);
  signal eRf_3  : std_logic_vector(wE downto 0);
  signal eRf_4  : std_logic_vector(wE downto 0);
  signal fRf_3  : std_logic_vector(wF downto 0);
  signal fRf_4  : std_logic_vector(wF downto 0);

  signal sRn_3 : std_logic;
  signal sRn_4 : std_logic;
  signal eRn_4 : std_logic_vector(wE downto 0);
  signal fRn_4 : std_logic_vector(wF downto 0);
  signal nRn_4 : std_logic_vector(wE+wF+2 downto 0);

  signal xAB_4 : std_logic_vector(3 downto 0);

  signal nR_4 : std_logic_vector(wE+wF+2 downto 0);
begin
  nA_1 <= nA;
  nB_1 <= nB;

  sAB_1 <= nA_1(wE+wF) xor nB_1(wE+wF);

  swap : FPAdd_Swap
    generic map ( wE => wE,
                  wF => wF )
    port map ( nA => nA_1,
               nB => nB_1,
               nR => nA0_1,
               nS => nB0_1,
               eD => expDiff_1 );

  close_1 <= sAB_1 when expDiff_1(wE-1 downto 1) = (wE-1 downto 1 => '0') else
             '0';

  process(clk)
  begin
    if clk'event and clk='1' then
      sAB_2   <= sAB_1;
      nA0_2   <= nA0_1;
      nB0_2   <= nB0_1;
      close_2 <= close_1;
    end if;
  end process;

--------------------------------------------------------------------------------

  process(clk)
  begin
    if clk'event and clk='1' then
      sAB_3   <= sAB_2;
      nA0_3   <= nA0_2;
      nB0_3   <= nB0_2;
      close_3 <= close_2;
    end if;
  end process;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

  fAc1_1 <= "01" & nA0_1(wF-1 downto 0) & '0';
  with expDiff_1(0) select
    fBc1_1 <= "01" & nB0_1(wF-1 downto 0) & '0' when '0',
              "001" & nB0_1(wF-1 downto 0)      when others;
  fRc0_1 <= fAc1_1 - fBc1_1;

  process(clk)
  begin
    if clk'event and clk='1' then
      fRc0_2 <= fRc0_1;
    end if;
  end process;

--------------------------------------------------------------------------------

  with fRc0_2(wF+2) select
    fRc1_2 <= fRc0_2(wF+1 downto 0)                          when '0',
              (wF+1 downto 0 => '0') - fRc0_2(wF+1 downto 0) when others;

  lzc : FPAdd_LZC
    generic map ( wF => wF )
    port map( f => fRc1_2,
              n => nZeros_2 );

  process(clk)
  begin
    if clk'event and clk='1' then
      fRc0_3   <= fRc0_2;
      fRc1_3   <= fRc1_2;
      nZeros_3 <= nZeros_2;
    end if;
  end process;

--------------------------------------------------------------------------------

  eRc1_3 <= "0" & nA0_3(wE+wF-1 downto wF);

  norm_round : FPAdd_NormRound
    generic map ( wE => wE,
                  wF => wF )
    port map ( eA => eRc1_3,
               fA => fRc1_3,
               n  => nZeros_3,
               eR => eRc_3,
               fR => fRc_3 );

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

  fBf1_1 <= "1" & nB0_1(wF-1 downto 0);
  shift : FPAdd_Shift_Clk
    generic map ( wE => wE,
                  wF => wF )
    port map ( fA => fBf1_1,
               n  => expDiff_1, ------------------------------------------------
               fR => fBf2_2,
               clk => clk );

  fAf3_2 <= "01" & nA0_2(wF-1 downto 0) & "000";
  fBf3_2 <= "0" & fBf2_2;
  with sAB_2 select
    fRf0_2 <= fAf3_2 - fBf3_2 when '1',
              fAf3_2 + fBf3_2 when others;

  process(clk)
  begin
    if clk'event and clk='1' then
      fRf0_3 <= fRf0_2;
    end if;
  end process;

--------------------------------------------------------------------------------

  eRf0_3 <= "0" & nA0_3(wE+wF-1 downto wF);
  fRf1_3 <= fRf0_3(wF+3 downto 2) & (fRf0_3(1) or fRf0_3(0)) when fRf0_3(wF+4 downto wF+3) = "01" else
            fRf0_3(wF+2 downto 0)                            when fRf0_3(wF+4 downto wF+3) = "00" else
            fRf0_3(wF+4 downto 3) & (fRf0_3(2) or fRf0_3(1) or fRf0_3(0));

  eRf1_3 <= eRf0_3                                when fRf0_3(wF+4 downto wF+3) = "01" else
            eRf0_3 - ((wE downto 1 => '0') & "1") when fRf0_3(wF+4 downto wF+3) = "00" else
            eRf0_3 + ((wE downto 1 => '0') & "1");

  round : FP_Round
    generic map ( wE => wE,
                  wF => wF )
    port map ( eA => eRf1_3,
               fA => fRf1_3,
               eR => eRf_3,
               fR => fRf_3 );

  process(clk)
  begin
    if clk'event and clk='1' then
      eRf_4 <= eRf_3;
      fRf_4 <= fRf_3;
    end if;
  end process;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

  sRn_3 <= '0' when close_3 = '1' and fRc1_3 = (wF+1 downto 0 => '0') else
           nA0_3(wE+wF) xor (close_3 and fRc0_3(wF+2));

  process(clk)
  begin
    if clk'event and clk='1' then
      sAB_4   <= sAB_3;
      nA0_4   <= nA0_3;
      nB0_4   <= nB0_3;
      close_4 <= close_3;
      sRn_4   <= sRn_3;
      eRc_4   <= eRc_3;
      fRc_4   <= fRc_3;
    end if;
  end process;

--------------------------------------------------------------------------------

  with close_4 select
    eRn_4 <= eRc_4 when '1',
             eRf_4 when others;
  with close_4 select
    fRn_4 <= fRc_4 when '1',
             fRf_4 when others;

  format : FP_Format
    generic map ( wE => wE,
                  wF => wF )
    port map ( sA => sRn_4,
               eA => eRn_4,
               fA => fRn_4,
               nR => nRn_4 );

  xAB_4 <= nA0_4(wE+wF+2 downto wE+wF+1) & nB0_4(wE+wF+2 downto wE+wF+1);

  with xAB_4 select
    nR_4(wE+wF+2 downto wE+wF+1) <= nRn_4(wE+wF+2 downto wE+wF+1) when "0101",
                                    "1" & sAB_4                   when "1010",
                                    "11"                          when "1011",
                                    xAB_4(3 downto 2)             when others;
  with xAB_4 select
    nR_4(wE+wF) <= nRn_4(wE+wF)                  when "0101",
                   nA0_4(wE+wF) and nB0_4(wE+wF) when "0000",
                   nA0_4(wE+wF)                  when others;
  with xAB_4 select
    nR_4(wE+wF-1 downto 0) <= nRn_4(wE+wF-1 downto 0) when "0101",
                              nA0_4(wE+wF-1 downto 0) when others;
  
  nR <= nR_4;
end architecture;
