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

entity FPAdd is
  generic ( wE : positive := 6;
            wF : positive := 13 );
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nB : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end entity;

architecture arch of FPAdd is
  signal sAB : std_logic;

  signal nA0 : std_logic_vector(wE+wF+2 downto 0);
  signal nB0 : std_logic_vector(wE+wF+2 downto 0);

  signal fAc1 : std_logic_vector(wF+2 downto 0);
  signal fBc1 : std_logic_vector(wF+2 downto 0);
  signal fRc0 : std_logic_vector(wF+2 downto 0);
  signal eRc1 : std_logic_vector(wE downto 0);
  signal fRc1 : std_logic_vector(wF+1 downto 0);
  signal eRc  : std_logic_vector(wE downto 0);
  signal fRc  : std_logic_vector(wF downto 0);

  signal fBf1 : std_logic_vector(wF downto 0);
  signal fBf2 : std_logic_vector(wF+3 downto 0);
  signal fAf3 : std_logic_vector(wF+4 downto 0);
  signal fBf3 : std_logic_vector(wF+4 downto 0);
  signal eRf0 : std_logic_vector(wE downto 0);
  signal fRf0 : std_logic_vector(wF+4 downto 0);
  signal eRf1 : std_logic_vector(wE downto 0);
  signal fRf1 : std_logic_vector(wF+2 downto 0);
  signal eRf  : std_logic_vector(wE downto 0);
  signal fRf  : std_logic_vector(wF downto 0);

  signal sRn : std_logic;
  signal eRn : std_logic_vector(wE downto 0);
  signal fRn : std_logic_vector(wF downto 0);
  signal nRn : std_logic_vector(wE+wF+2 downto 0);

  signal expDiff : std_logic_vector(wE-1 downto 0);
  signal close   : std_logic;

  constant wNZeros : natural := log((wF+5)/4)+3;
  signal nZeros : std_logic_vector(wNZeros-1 downto 2);

  signal xAB : std_logic_vector(3 downto 0);
begin
  sAB <= nA(wE+wF) xor nB(wE+wF);

  swap : FPAdd_Swap
    generic map ( wE => wE,
                  wF => wF )
    port map ( nA => nA,
               nB => nB,
               nR => nA0,
               nS => nB0,
               eD => expDiff );

  close <= sAB when expDiff(wE-1 downto 1) = (wE-1 downto 1 => '0') else
           '0';

  fAc1 <= "01" & nA0(wF-1 downto 0) & '0';
  with expDiff(0) select
    fBc1 <= "01" & nB0(wF-1 downto 0) & '0' when '0',
            "001" & nB0(wF-1 downto 0)      when others;

  fRc0 <= fAc1 - fBc1;
  with fRc0(wF+2) select
    fRc1 <= fRc0(wF+1 downto 0)                          when '0',
            (wF+1 downto 0 => '0') - fRc0(wF+1 downto 0) when others;

  lzc : FPAdd_LZC
    generic map ( wF => wF )
    port map( f => fRc1,
              n => nZeros );

  eRc1 <= "0" & nA0(wE+wF-1 downto wF);

  norm_round : FPAdd_NormRound
    generic map ( wE => wE,
                  wF => wF )
    port map ( eA => eRc1,
               fA => fRc1,
               n  => nZeros,
               eR => eRc,
               fR => fRc );

  fBf1 <= "1" & nB0(wF-1 downto 0);
  shift : FPAdd_Shift
    generic map ( wE => wE,
                  wF => wF )
    port map ( fA => fBf1,
               n  => expDiff,
               fR => fBf2 );

  fAf3 <= "01" & nA0(wF-1 downto 0) & "000";
  fBf3 <= "0" & fBf2;
  with sAB select
    fRf0 <= fAf3 - fBf3 when '1',
            fAf3 + fBf3 when others;
  eRf0 <= "0" & nA0(wE+wF-1 downto wF);

  fRf1 <= fRf0(wF+3 downto 2) & (fRf0(1) or fRf0(0)) when fRf0(wF+4 downto wF+3) = "01" else
          fRf0(wF+2 downto 0)                        when fRf0(wF+4 downto wF+3) = "00" else
          fRf0(wF+4 downto 3) & (fRf0(2) or fRf0(1) or fRf0(0));

  eRf1 <= eRf0                                when fRf0(wF+4 downto wF+3) = "01" else
          eRf0 - ((wE downto 1 => '0') & "1") when fRf0(wF+4 downto wF+3) = "00" else
          eRf0 + ((wE downto 1 => '0') & "1");

  round : FP_Round
    generic map ( wE => wE,
                  wF => wF )
    port map ( eA => eRf1,
               fA => fRf1,
               eR => eRf,
               fR => fRf );

  sRn <= '0' when close = '1' and fRc1 = (wF+1 downto 0 => '0') else
         nA0(wE+wF) xor (close and fRc0(wF+2));
  with close select
    eRn <= eRc when '1',
           eRf when others;
  with close select
    fRn <= fRc when '1',
           fRf when others;

  format : FP_Format
    generic map ( wE => wE,
                  wF => wF )
    port map ( sA => sRn,
               eA => eRn,
               fA => fRn,
               nR => nRn );

  xAB <= nA0(wE+wF+2 downto wE+wF+1) & nB0(wE+wF+2 downto wE+wF+1);
  
  with xAB select
    nR(wE+wF+2 downto wE+wF+1) <= nRn(wE+wF+2 downto wE+wF+1) when "0101",
                                  "1" & sAB                   when "1010",
                                  "11"                        when "1011",
                                  xAB(3 downto 2)             when others;
  with xAB select
    nR(wE+wF) <= nRn(wE+wF)                when "0101",
                 nA0(wE+wF) and nB0(wE+wF) when "0000",
                 nA0(wE+wF)                when others;

  with xAB select
    nR(wE+wF-1 downto 0) <= nRn(wE+wF-1 downto 0) when "0101",
                            nA0(wE+wF-1 downto 0) when others;
end architecture;
