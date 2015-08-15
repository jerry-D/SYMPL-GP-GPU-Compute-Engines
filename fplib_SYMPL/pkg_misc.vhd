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

package pkg_misc is
  type vector is array (natural range <>) of integer;

  function min( x, y : integer ) return integer;
  function max( x, y : integer ) return integer;
  function minimum( x, y : positive ) return positive;
  function log( x : integer ) return natural;
  function log2( x : integer ) return natural;

  function int2str( x : natural ) return string;
  function int2sig( x : natural ) return std_logic_vector;
  function cst_InvLog2 ( w : positive ) return std_logic_vector;
  function cst_Log2 ( w : positive ) return std_logic_vector;

  component Mux_N_To_1 is
    generic ( wIn   : positive := 1;
              wAddr : positive );
    port ( input  : in  std_logic_vector((2**wAddr)*wIn-1 downto 0);
           addr   : in  std_logic_vector(wAddr-1 downto 0);
           output : out std_logic_vector(wIn-1 downto 0) );
  end component;

  component Delay is
    generic ( w : positive := 1;
              n : natural );
    port ( input  : in  std_logic_vector(w-1 downto 0);
           output : out std_logic_vector(w-1 downto 0);
           clk    : in  std_logic );
  end component;
end package;

package body pkg_misc is
  function min( x, y : integer ) return integer is
  begin
    if x <= y then
      return x;
    else
      return y;
    end if;
  end function;

  function minimum( x, y : positive ) return positive is
  begin
    if x <= y then
      return x;
    else
      return y;
    end if;
  end function;

  function max( x, y : integer ) return integer is
  begin
    if x >= y then
      return x;
    else
      return y;
    end if;
  end function;

  function log( x : integer ) return natural is
    variable n : natural := 0;
  begin
    while 2**(n+1) <= x loop
      n := n+1;
    end loop;
    return n;
  end function;

  function log2( x : integer ) return natural is
    variable n : natural := 0;
  begin
    while 2**(n+1) <= x loop
      n := n+1;
    end loop;
    return n;
  end function;

  function int2str( x : natural ) return string is
    variable i : positive := 1;
    variable r : natural := x;
    variable s : string(8 downto 1) := "        ";
  begin
    if r = 0 then
      s(1) := '0';
    end if;
    while r > 0 loop
      case r mod 10 is
        when 0      => s(i) := '0';
        when 1      => s(i) := '1';
        when 2      => s(i) := '2';
        when 3      => s(i) := '3';
        when 4      => s(i) := '4';
        when 5      => s(i) := '5';
        when 6      => s(i) := '6';
        when 7      => s(i) := '7';
        when 8      => s(i) := '8';
        when others => s(i) := '9';
      end case;
      r := r / 10;
      i := i + 1;
    end loop;
    return s;
  end function;

  function int2sig( x : natural ) return std_logic_vector is
    variable s : std_logic_vector(log(x) downto 0);
  begin
    if x = 0 then
      s(0) := '0';
      return s;
    end if;
    for i in 0 to log(x) loop
      if (x/(2**i)) mod 2 = 0 then
        s(i) := '0';
      else
        s(i) := '1';
      end if;
    end loop;
    return s;
  end function;

  function cst_InvLog2 ( w : positive ) return std_logic_vector is
    type lut_t is array (4 to 12) of std_logic_vector(12 downto 0);
    constant lut : lut_t := (  4 => "0000000010111",
                               5 => "0000000101110",
                               6 => "0000001011100",
                               7 => "0000010111001",
                               8 => "0000101110001",
                               9 => "0001011100011",
                              10 => "0010111000101",
                              11 => "0101110001011",
                              12 => "1011100010101" );
  begin
    return lut(w)(w downto 0);
  end function;

  function cst_Log2 ( w : positive ) return std_logic_vector is
    type lut_t is array (10 to 40) of std_logic_vector(39 downto 0);
    constant lut : lut_t := ( 10 => "0000000000000000000000000000001011000110",
                              11 => "0000000000000000000000000000010110001100",
                              12 => "0000000000000000000000000000101100010111",
                              13 => "0000000000000000000000000001011000101110",
                              14 => "0000000000000000000000000010110001011101",
                              15 => "0000000000000000000000000101100010111001",
                              16 => "0000000000000000000000001011000101110010",
                              17 => "0000000000000000000000010110001011100100",
                              18 => "0000000000000000000000101100010111001000",
                              19 => "0000000000000000000001011000101110010001",
                              20 => "0000000000000000000010110001011100100001",
                              21 => "0000000000000000000101100010111001000011",
                              22 => "0000000000000000001011000101110010000110",
                              23 => "0000000000000000010110001011100100001100",
                              24 => "0000000000000000101100010111001000011000",
                              25 => "0000000000000001011000101110010000110000",
                              26 => "0000000000000010110001011100100001100000",
                              27 => "0000000000000101100010111001000011000000",
                              28 => "0000000000001011000101110010000101111111",
                              29 => "0000000000010110001011100100001011111111",
                              30 => "0000000000101100010111001000010111111110",
                              31 => "0000000001011000101110010000101111111100",
                              32 => "0000000010110001011100100001011111111000",
                              33 => "0000000101100010111001000010111111110000",
                              34 => "0000001011000101110010000101111111011111",
                              35 => "0000010110001011100100001011111110111111",
                              36 => "0000101100010111001000010111111101111101",
                              37 => "0001011000101110010000101111111011111010",
                              38 => "0010110001011100100001011111110111110100",
                              39 => "0101100010111001000010111111101111101001",
                              40 => "1011000101110010000101111111011111010010" );
  begin
    return lut(w)(w-1 downto 0);
  end function;

end package body;

