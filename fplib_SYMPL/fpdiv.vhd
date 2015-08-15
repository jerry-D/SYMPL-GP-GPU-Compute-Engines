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
use fplib.pkg_fpdiv.all;
use fplib.pkg_misc.all;
use fplib.pkg_fp_misc.all;

entity FPDiv is
  generic ( wE : positive := 8;
            wF : positive := 23 );
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nB : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0) );
end entity;

architecture arch of FPDiv is
  signal fA0 : std_logic_vector(wF downto 0);
  signal fB0 : std_logic_vector(wF downto 0);

  signal eRn0 : std_logic_vector(wE downto 0);
  signal fRn0 : std_logic_vector(wF+3 downto 0);
  signal eRn1 : std_logic_vector(wE downto 0);
  signal fRn1 : std_logic_vector(wF+2 downto 0);
  signal sRn  : std_logic;
  signal eRn  : std_logic_vector(wE downto 0);
  signal fRn  : std_logic_vector(wF downto 0);
  signal nRn  : std_logic_vector(wE+wF+2 downto 0);

  signal xAB : std_logic_vector(3 downto 0);
begin
  fA0 <= "1" & nA(wF-1 downto 0);
  fB0 <= "1" & nB(wF-1 downto 0);

  division : FPDiv_Division
    generic map ( wF => wF )
    port map ( fA => fA0,
               fB => fB0,
               fR => fRn0 );
  with fRn0(wF+3) select
    fRn1(wF+2 downto 0) <= fRn0(wF+3 downto 2) & (fRn0(1) or fRn0(0)) when '1',
                              fRn0(wF+2 downto 0)                        when others;

  eRn0 <= ("0" & nA(wE+wF-1 downto wF)) - ("0" & nB(wE+wF-1 downto wF));
  eRn1 <= eRn0 + ("00" & (wE-2 downto 1 => '1') & fRn0(wF+3));

  round : FP_Round
    generic map ( wE => wE,
                  wF => wF )
    port map ( eA => eRn1,
               fA => fRn1,
               eR => eRn,
               fR => fRn );

  sRn <= nA(wE+wF) xor nB(wE+wF);

  format : FP_Format
    generic map ( wE => wE,
                  wF => wF )
    port map ( sA => sRn,
               eA => eRn,
               fA => fRn,
               nR => nRn );

  xAB <= nA(wE+wF+2 downto wE+wF+1) & nB(wE+wF+2 downto wE+wF+1);

  with xAB select
    nR(wE+wF+2 downto wE+wF+1) <= nRn(wE+wF+2 downto wE+wF+1) when "0101",
                                            "00"                                  when "0001" | "0010" | "0110",
                                            "10"                                  when "0100" | "1000" | "1001",
                                            "11"                                  when others;

  nR(wE+wF downto 0) <= nRn(wE+wF downto 0);
end architecture;
