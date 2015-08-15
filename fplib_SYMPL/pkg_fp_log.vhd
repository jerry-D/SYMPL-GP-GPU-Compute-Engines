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
--use fplib.pkg_fp_log.all;
use fplib.pkg_misc.all;

package pkg_fp_log is

  function mult_latency ( wX, wY : positive;
                          first  : integer;
                          steps  : positive )
    return positive;

  function fp_log_log_g ( w : positive )
    return positive;

  function fp_log_log_latency ( w : positive )
    return positive;

--  function min ( x, y : integer )
--    return integer;

--  function max ( x, y : integer )
--    return integer;
  
--  function log2 ( x : positive )
--    return integer;

--  function cst_Log2 ( w : positive )
--    return std_logic_vector;

  component delay_buffer is
    generic ( w : positive;
              n : integer := 1 );
    port ( nX_0 : in  std_logic_vector(w-1 downto 0);
           nX_d : out std_logic_vector(w-1 downto 0);
           clk  : in  std_logic );
  end component;

  component vec_mux_n_to_1 is
    generic ( wAddr : positive );
    port ( nIn   : in  std_logic_vector(2**wAddr-1 downto 0);
           nAddr : in  std_logic_vector(wAddr-1 downto 0);
           nOut  : out std_logic );
  end component;

--  component mult_clk is
  component mult_clk_log is
    generic ( wX    : positive;
              wY    : positive;
              sgnX  : boolean  := false;
              sgnY  : boolean  := false;
              first : integer  := 0;
              steps : positive := 2 );
    port ( nX  : in  std_logic_vector(wX-1 downto 0);
           nY  : in  std_logic_vector(wY-1 downto 0);
           nR  : out std_logic_vector(wX+wY-1 downto 0);
           clk : in  std_logic );
  end component;

  component fp_log_log is
    generic ( w : positive );
    port ( nX    : in  std_logic_vector(w-1 downto 0);
           nLogX : out std_logic_vector(w+fp_log_log_g(w) downto 0) );
  end component;

  component fp_log_log_clk is
    generic ( w : positive );
    port ( nX    : in  std_logic_vector(w-1 downto 0);
           nLogX : out std_logic_vector(w+fp_log_log_g(w) downto 0);
           clk   : in  std_logic );
  end component;

  component fp_log_normalize is
    generic ( w : positive;
              n : positive );
    port ( nX : in  std_logic_vector(w-1 downto 0);
           fX : out std_logic_vector(w-n-1 downto 0);
           nZ : out std_logic_vector(log2(n) downto 0) );
  end component;
  
  
  component fp_log is
  generic ( wE : positive := 6;
            wF : positive := 13 );
  port ( fpX : in  std_logic_vector(2+wE+wF downto 0);
         fpR : out std_logic_vector(2+wE+wF downto 0) );
end component;

component fp_log_clk is
  generic ( wE : positive := 8;
            wF : positive := 23 );
  port ( fpX : in  std_logic_vector(2+wE+wF downto 0);
         fpR : out std_logic_vector(2+wE+wF downto 0);
         clk : in  std_logic );
end component;


end package;

package body pkg_fp_log is

  function mult_latency ( wX, wY : positive;
                          first  : integer;
                          steps  : positive ) return positive is
  begin
    return (log2(minimum(wX, wY)-1)+1+1 + first + steps-1) / steps;
  end function;

  function fp_log_log_g ( w : positive ) return positive is
    type lut_t is array (7 to 24) of positive;
    constant lut : lut_t := (  7 => 1,
                               8 => 1,
                               9 => 2,
                              10 => 3,
                              11 => 2,
                              12 => 3,
                              13 => 3,
                              14 => 2,
                              15 => 4,
                              16 => 3,
                              17 => 3,
                              18 => 3,
                              19 => 3,
                              20 => 3,
                              21 => 3,
                              22 => 3,
                              23 => 4,
                              24 => 4 );
  begin
    return lut(w);
  end function;

  function fp_log_log_latency ( w : positive ) return positive is
  begin
    if (w <= 10) then
      return 1;
    elsif (w <= 17) then
      return 2;
    elsif (w <= 23) then
      return 5;
    elsif (w = 24) then
      return 6;
    end if;
  end function;

  function minimum ( x, y : integer ) return integer is
  begin
    if x <= y then
      return x;
    else
      return y;
    end if;
  end function;

--  function max ( x, y : integer ) return integer is
--  begin
--    if x >= y then
--      return x;
--    else
--      return y;
--    end if;
--  end function;

--  function log2 ( x : positive ) return integer is
--    variable n : natural := 0;
--  begin
--    while 2**(n+1) <= x loop
--      n := n+1;
--    end loop;
--    return n;
--  end function;

--  function cst_Log2 ( w : positive ) return std_logic_vector is
--    type lut_t is array (8 to 32) of std_logic_vector(31 downto 0);
--    constant lut : lut_t := (  8 => "00000000000000000000000010110001",
--                               9 => "00000000000000000000000101100011",
--                              10 => "00000000000000000000001011000110",
--                              11 => "00000000000000000000010110001100",
--                              12 => "00000000000000000000101100010111",
--                              13 => "00000000000000000001011000101110",
--                              14 => "00000000000000000010110001011101",
--                              15 => "00000000000000000101100010111001",
--                              16 => "00000000000000001011000101110010",
--                              17 => "00000000000000010110001011100100",
--                              18 => "00000000000000101100010111001000",
--                              19 => "00000000000001011000101110010001",
--                              20 => "00000000000010110001011100100001",
--                              21 => "00000000000101100010111001000011",
--                              22 => "00000000001011000101110010000110",
--                              23 => "00000000010110001011100100001100",
--                              24 => "00000000101100010111001000011000",
--                              25 => "00000001011000101110010000110000",
--                              26 => "00000010110001011100100001100000",
--                              27 => "00000101100010111001000011000000",
--                              28 => "00001011000101110010000101111111",
--                              29 => "00010110001011100100001011111111",
--                              30 => "00101100010111001000010111111110",
--                              31 => "01011000101110010000101111111100",
--                              32 => "10110001011100100001011111111000" );
--  begin
--    return lut(w)(w-1 downto 0);
--  end function;

end package body;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity delay_buffer is
  generic ( w : positive;
            n : integer := 1 );
  port ( nX_0 : in  std_logic_vector(w-1 downto 0);
         nX_d : out std_logic_vector(w-1 downto 0);
         clk  : in  std_logic );
end entity;

architecture arch of delay_buffer is
  signal buf : std_logic_vector((n+1)*w-1 downto 0);
begin

  buf(w-1 downto 0) <= nX_0;

  process(clk)
  begin
    if clk'event and clk = '1' then
      buf((n+1)*w-1 downto w) <= buf(n*w-1 downto 0);
    end if;
  end process;

  nX_d <= buf((n+1)*w-1 downto n*w);

end architecture;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity vec_mux_n_to_1 is
  generic ( wAddr : positive );
  port ( nIn   : in  std_logic_vector(2**wAddr-1 downto 0);
         nAddr : in  std_logic_vector(wAddr-1 downto 0);
         nOut  : out std_logic );
end entity;

architecture arch of vec_mux_n_to_1 is
  signal buf : std_logic_vector(2**(wAddr+1)-1 downto 1);
begin
  buf(2**(wAddr+1)-1 downto 2**wAddr) <= nIn;

  mux : for i in wAddr-1 downto 0 generate
    buf(2**(i+1)-1 downto 2**i) <= buf(2**(i+2)-1 downto 2**(i+1)+2**i) when nAddr(i) = '1' else
                                   buf(2**(i+1)+2**i-1 downto 2**(i+1));
  end generate;

  nOut <= buf(1);
end architecture;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_fp_log.all;
use fplib.pkg_misc.all;

--entity mult_clk is
entity mult_clk_log is
  generic ( wX    : positive;
            wY    : positive;
            sgnX  : boolean  := false;
            sgnY  : boolean  := false;
            first : integer  := 0;
            steps : positive := 2 );
  port ( nX  : in  std_logic_vector(wX-1 downto 0);
         nY  : in  std_logic_vector(wY-1 downto 0);
         nR  : out std_logic_vector(wX+wY-1 downto 0);
         clk : in  std_logic );
end entity;

--architecture arch of mult_clk is
architecture arch of mult_clk_log is
  constant wX0   : positive := max(wX, wY)+1;
  constant wY0   : positive := minimum(wX, wY);
  constant sgnX0 : boolean  := ((wX >= wY) and sgnX) or ((wX < wY) and sgnY);
  constant sgnY0 : boolean  := ((wX >= wY) and sgnY) or ((wX < wY) and sgnX);
  constant n     : positive := log2(wY0-1)+1;

  signal nX0_0 : std_logic_vector(wX0-1 downto 0);
  signal nY0_0 : std_logic_vector(wY0-1 downto 0);

  signal buf_x : std_logic_vector((n+1)*(2**n) + (2**(n+1)-1)*wX0 - 1 downto 0);
  signal buf_r : std_logic_vector((n+1)*(2**n) + (2**(n+1)-1)*wX0 - 1 downto 0);
  
  signal nR_a0 : std_logic_vector(wX+wY-1 downto 0);
begin

  no_swap : if wX >= wY generate
    nX0_0(wX0-2 downto 0) <= nX;
    nY0_0 <= nY;
  end generate;

  swap : if wX < wY generate
    nX0_0(wX0-2 downto 0) <= nY;
    nY0_0 <= nX;
  end generate;

  no_signed_x0 : if not sgnX0 generate
    nX0_0(wX0-1) <= '0';
  end generate;
  
  signed_x0 : if sgnX0 generate
    nX0_0(wX0-1) <= nX0_0(wX0-2);
  end generate;

  partial_prod : for i in 0 to wY0-1 generate
    no_signed_y0 : if (i < wY0-1) or (not sgnY0) generate
      buf_x(i*(wX0+1)+wX0 downto i*(wX0+1)) <= nX0_0(wX0-1) & nX0_0 when nY0_0(i) = '1' else
                                               "" & (wX0 downto 0 => '0');
    end generate;

    signed_y0 : if (i = wY0-1) and sgnY0 generate
      buf_x(i*(wX0+1)+wX0 downto i*(wX0+1)) <= (wX0 downto 0 => '0') - (nX0_0(wX0-1) & nX0_0) when nY0_0(i) = '1' else
                                               "" & (wX0 downto 0 => '0');
    end generate;
  end generate;

  adder_tree : for k in 1 to n generate
    reg : if ((k+first) mod steps = 0) and (k+first > 0) generate
      process(clk)
      begin
        if clk'event and clk = '1' then
          buf_r((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + (wY0+2**(k-1)-1)/(2**(k-1))*(wX0+2**(k-1)) - 1 downto
                (k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0)
            <= buf_x((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + (wY0+2**(k-1)-1)/(2**(k-1))*(wX0+2**(k-1)) - 1 downto
                     (k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0);
        end if;
      end process;
    end generate;

    row : for i in 0 to (wY0+2**k-1)/(2**k)-1 generate
      adder : if 2*i < (wY0+2**(k-1)-1)/(2**(k-1))-1 generate
        no_reg : if ((k+first) mod steps /= 0) or (k+first = 0) generate
          buf_x(k*(2**n) + (2**(n+1)-2**(n-k+1))*wX0 + i*(wX0+2**k) + wX0+2**k-1 downto
                k*(2**n) + (2**(n+1)-2**(n-k+1))*wX0 + i*(wX0+2**k))
            <= (  (2**(k-1)-1 downto 0 => buf_x((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)) + wX0+2**(k-1)-1))
                & buf_x((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)) + wX0+2**(k-1)-1 downto
                        (k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1))))
            +  (buf_x((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + (2*i+1)*(wX0+2**(k-1)) + wX0+2**(k-1)-1 downto
                      (k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + (2*i+1)*(wX0+2**(k-1))) & (2**(k-1)-1 downto 0 => '0'));
        end generate;

        reg : if ((k+first) mod steps = 0) and (k+first > 0) generate
          buf_x(k*(2**n) + (2**(n+1)-2**(n-k+1))*wX0 + i*(wX0+2**k) + wX0+2**k-1 downto
                k*(2**n) + (2**(n+1)-2**(n-k+1))*wX0 + i*(wX0+2**k))
            <= (  (2**(k-1)-1 downto 0 => buf_r((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)) + wX0+2**(k-1)-1))
                & buf_r((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)) + wX0+2**(k-1)-1 downto
                        (k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1))))
            +  (buf_r((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + (2*i+1)*(wX0+2**(k-1)) + wX0+2**(k-1)-1 downto
                      (k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + (2*i+1)*(wX0+2**(k-1))) & (2**(k-1)-1 downto 0 => '0'));
        end generate;
      end generate;

      pass : if 2*i = (wY0+2**(k-1)-1)/(2**(k-1))-1 generate
        no_reg : if ((k+first) mod steps /= 0) or (k+first = 0) generate
          buf_x(k*(2**n) + (2**(n+1)-2**(n-k+1))*wX0 + i*(wX0+2**k) + wX0+2**k-1 downto
                k*(2**n) + (2**(n+1)-2**(n-k+1))*wX0 + i*(wX0+2**k))
            <= (2**(k-1)-1 downto 0 => buf_x((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)) + wX0+2**(k-1)-1))
            &  buf_x((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)) + wX0+2**(k-1)-1 downto
                     (k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)));
        end generate;

        reg : if ((k+first) mod steps = 0) and (k+first > 0) generate
          buf_x(k*(2**n) + (2**(n+1)-2**(n-k+1))*wX0 + i*(wX0+2**k) + wX0+2**k-1 downto
                k*(2**n) + (2**(n+1)-2**(n-k+1))*wX0 + i*(wX0+2**k))
            <= (2**(k-1)-1 downto 0 => buf_r((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)) + wX0+2**(k-1)-1))
            &  buf_r((k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)) + wX0+2**(k-1)-1 downto
                     (k-1)*(2**n) + (2**(n+1)-2**(n-k+2))*wX0 + 2*i*(wX0+2**(k-1)));
        end generate;
      end generate;
    end generate;
  end generate;

  nR_a0 <= buf_x(n*(2**n) + (2**(n+1)-2)*wX0 + wX+wY-1 downto n*(2**n) + (2**(n+1)-2)*wX0);

  nR <= nR_a0;

end architecture;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_fp_log.all;
use fplib.pkg_misc.all;

entity fp_log_normalize is
  generic ( w : positive;
            n : positive );
  port ( nX : in  std_logic_vector(w-1 downto 0);
         fX : out std_logic_vector(w-n-1 downto 0);
         nZ : out std_logic_vector(log2(n) downto 0) );
end entity;

architecture arch of fp_log_normalize is
  constant wZ : positive := log2(n)+1;

  signal ranges : std_logic_vector(2**(wZ-1)-1 downto 1);
  signal rngbuf : std_logic_vector(2**(wZ-2)-1 downto 1);

  signal sticky : std_logic_vector(wZ-2 downto 0);
  signal buf : std_logic_vector(wZ*(w-2**(wZ-1)) + 2**wZ-1 - 1 downto 0);

  signal nZ0 : std_logic_vector(wZ-1 downto 0);
begin

  tree : for k in 2 to wZ-1 generate
    block4 : if k = 2 generate
      scan : for i in 1 to (n+3)/4 generate
        ranges(2**(wZ-1)-i) <= '0' when nX(w-4*i+3 downto w-4*i) = "0000" else
                               '1';
      end generate;
    end generate;

    merge : if k > 2 generate
      scan : for i in 1 to (n+2**k-1)/(2**k) generate
        ranges(2**(wZ+1-k)-i) <= ranges(2**(wZ+1-k+1)-2*i+1) or ranges(2**(wZ+1-k+1)-2*i);
      end generate;
    end generate;

    pad : if (n+2**k-1)/(2**k) < 2**(wZ-k) generate
      ranges(2**(wZ+1-k)-(n+2**k-1)/(2**k)-1 downto 2**(wZ-k)) <= (2**(wZ+1-k)-(n+2**k-1)/(2**k)-1 downto 2**(wZ-k) => '1');
    end generate;

    filter : for i in 1 to 2**(wZ-k-1) generate
      rngbuf(2**(wZ-k)-i) <= not ranges(2**(wZ-k)-1+2*i);
    end generate;
  end generate;

  nZ0(wZ-1) <= rngbuf(1);
  count : for k in wZ-2 downto 2 generate
    mux : vec_mux_n_to_1
      generic map ( wAddr => wZ-1-k )
      port map ( nIn   => rngbuf(2**(wZ-k)-1 downto 2**(wZ-1-k)),
                 nAddr => nZ0(wZ-1 downto k+1),
                 nOut  => nZ0(k) );
  end generate;

  buf(wZ*(w-2**(wZ-1)) + 2**wZ-1 - 1 downto (wZ-1)*(w-2**(wZ-1)) + 2**(wZ-1)-1) <=
    nX(w-2**(wZ-1)-1 downto 0) & (2**(wZ-1)-1 downto 0 => '0') when nZ0(wZ-1) = '1' else
    nX;
  shift : for k in wZ-2 downto 0 generate
    sticky(k) <= '0' when buf((k+1)*(w-2**(wZ-1)) + 2**(k+1)-1 + 2**k downto (k+1)*(w-2**(wZ-1)) + 2**(k+1)-1) = (2**k downto 0 => '0') else
                 '1';
    buf((k+1)*(w-2**(wZ-1)) + 2**(k+1)-1 - 1 downto k*(w-2**(wZ-1)) + 2**k-1) <=
      buf((k+2)*(w-2**(wZ-1)) + 2**(k+2)-1 - 2**k - 1 downto (k+1)*(w-2**(wZ-1)) + 2**(k+1)-1) when nZ0(k) = '1' else
      buf((k+2)*(w-2**(wZ-1)) + 2**(k+2)-1 - 1 downto (k+1)*(w-2**(wZ-1)) + 2**(k+1)-1 + 2**k+1) & sticky(k);
  end generate;

  nZ0(1) <= '1' when buf(3*(w-2**(wZ-1)) + 2**3-1 - 1 downto 3*(w-2**(wZ-1)) + 2**3-1 - 2) = "00" else
            '0';
  nZ0(0) <= not buf(2*(w-2**(wZ-1)) + 2**2-1 - 1);

  fX(w-n-1 downto 1) <= buf(w-2**(wZ-1) downto n-2**(wZ-1)+2);
  fX(0) <= '0' when buf(n-2**(wZ-1)+1 downto 0) = (n-2**(wZ-1)+1 downto 0 => '0') else
           '1';

  nZ <= nZ0;

end architecture;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_fp_log.all;
use fplib.pkg_misc.all;

entity fp_log is
  generic ( wE : positive := 6;
            wF : positive := 13 );
  port ( fpX : in  std_logic_vector(2+wE+wF downto 0);
         fpR : out std_logic_vector(2+wE+wF downto 0) );
end entity;

architecture arch of fp_log is
  constant g   : positive := fp_log_log_g(wF+1);
  constant wE0 : positive := max(wE, log2(wE+wF)+2);

  constant cstSqrt2 : std_logic_vector(5 downto 0) := "011010";
  
  signal cmpSqrt2 : std_logic;

  signal nE0 : std_logic_vector(wE downto 0);
  signal nE  : std_logic_vector(wE-1 downto 0);

  constant cstLog2 : std_logic_vector(wF+2 downto 0) := cst_Log2(wF+3);
  
  signal nELog2 : std_logic_vector(wE+wF+2 downto 0);

  signal nX0 : std_logic_vector(wF downto 0);
  signal nX1 : std_logic_vector(wF downto 0);
  signal nX  : std_logic_vector(wF downto 0);

  signal nLogX : std_logic_vector(wF+g+1 downto 0);

  signal nY0 : std_logic_vector(wF+wF+g+1 downto 0);
  signal nY  : std_logic_vector(wF+wF+g+2 downto 0);

  signal nZ : std_logic_vector(wE+wF+wF+g+1 downto 0);

  signal sR : std_logic;

  signal eR0 : std_logic_vector(log2(wE+wF) downto 0);
  signal eR1 : std_logic_vector(wE0-1 downto 0);
  signal eR2 : std_logic_vector(wE0-1 downto 0);
  signal eR  : std_logic_vector(wE-1 downto 0);

  signal fR0 : std_logic_vector(wF+g+1 downto 0);
  signal fR1 : std_logic_vector(wF downto 0);
  signal fR  : std_logic_vector(wF-1 downto 0);

  signal sticky : std_logic;
  signal round  : std_logic;

  signal ufl  : std_logic;
begin

  cmpSqrt2 <= '1' when fpX(wF-1 downto wF-6) >= cstSqrt2 else
              '0';

  nE0 <= ("0" & fpX(wE+wF-1 downto wF)) - ("00" & (wE-2 downto 1 => '1') & (not cmpSqrt2));

  sR <= cmpSqrt2 when nE0 = (wE downto 0 => '0') else
        nE0(wE);

  nE <= (wE-1 downto 0 => '0') - nE0(wE-1 downto 0) when sR = '1' else
        nE0(wE-1 downto 0);

  nELog2 <= nE * cstLog2;

  nX0 <= "1" & fpX(wF-2 downto 0) & "0" when cmpSqrt2 = '0' else
         "0" & fpX(wF-1 downto 0);
  
  nX1 <= (not nX0(wF)) & nX0(wF-1 downto 0);

  nX <= (wF downto 0 => '0') - nX1 when sR = '1' else
        nX1;

  log : fp_log_log
    generic map ( w => wF+1 )
    port map ( nX    => nX0,
               nLogX => nLogX );

  nY0 <= nX(wF-1 downto 0) * nLogX;
  nY <= ("0" & nY0) - ("0" & nLogX & (wF-1 downto 0 => '0')) when nX(wF) = '1' else
        "0" & nY0;

  nZ <= ((wE-1 downto 1 => nY(wF+wF+g+1)) & nY) + (nELog2 & (wF+g-2 downto 0 => '0'));

  normalize : fp_log_normalize
    generic map ( w => wE+wF+wF+g+2,
                  n => wE+wF )
    port map ( nX => nZ,
               fX => fR0,
               nZ => eR0 );

  eR1 <= conv_std_logic_vector(2**(wE-1)-1 + wE-1, wE0) - ((wE0-1 downto log2(wE+wF)+1 => '0') & eR0);

  sticky <= '0' when fR0(g-1 downto 0) = (g-1 downto 0 => '0') else
            '1';
  round <= fR0(g) and (fR0(g+1) or sticky);

  fR1 <= ("0" & fR0(wF+g downto g+1)) + ((wF downto 1 => '0') & round);

  eR2 <= eR1 + ((wE0-1 downto 1 => '0') & fR1(wF));

  eR <= eR2(wE-1 downto 0);

  underflow : if wE0 > wE generate
    ufl <= '1' when (eR2(wE0-1) = '1') or (eR = (wE-1 downto 0 => '0')) else
           '0';
  end generate;

  no_underflow : if wE0 = wE generate
    ufl <= '0';
  end generate;

  fR <= fR1(wF-1 downto 0);

  fpR(wE+wF+2 downto wE+wF) <= "110" when ((fpX(wE+wF+2) and (fpX(wE+wF+1) or fpX(wE+wF))) or (fpX(wE+wF+1) and fpX(wE+wF))) = '1' else
                               "101" when fpX(wE+wF+2 downto wE+wF+1) = "00"                                                       else
                               "100" when fpX(wE+wF+2 downto wE+wF+1) = "10"                                                       else
                               "00" & sR when (fR0(wF+g+1) = '0') or (ufl = '1')                                                   else
                               "01" & sR;

  fpR(wE+wF-1 downto 0) <= eR & fR;

end architecture;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_fp_log.all;
use fplib.pkg_misc.all;

entity fp_log_clk is
  generic ( wE : positive := 8;
            wF : positive := 23 );
  port ( fpX : in  std_logic_vector(2+wE+wF downto 0);
         fpR : out std_logic_vector(2+wE+wF downto 0);
         clk : in  std_logic );
end entity;

architecture arch of fp_log_clk is
  constant g     : positive := fp_log_log_g(wF+1);
  constant wE0   : positive := max(wE, log2(wE+wF)+2);
  constant latD0 : positive := max(1 + mult_latency(wE, wF+3, 0, 2), fp_log_log_latency(wF+1) + mult_latency(wF+1, wF+g+2, 0, 2));

  constant cstSqrt2 : std_logic_vector(5 downto 0) := "011010";
  
  signal fpX_0  : std_logic_vector(2+wE+wF downto 0);
  signal fpX_d3 : std_logic_vector(2+wE+wF downto 0);

  signal cmpSqrt2_0 : std_logic;

  signal nE0_0 : std_logic_vector(wE downto 0);
  signal nE_0  : std_logic_vector(wE-1 downto 0);
  signal nE_1  : std_logic_vector(wE-1 downto 0);

  constant cstLog2 : std_logic_vector(wF+2 downto 0) := cst_Log2(wF+3);
  
  signal nX0_0 : std_logic_vector(wF downto 0);
  signal nX1_0 : std_logic_vector(wF downto 0);
  signal nX1_1 : std_logic_vector(wF downto 0);
  signal nX_1  : std_logic_vector(wF downto 0);
  signal nX_b1 : std_logic_vector(wF downto 0);

  signal nELog2_a0 : std_logic_vector(wE+wF+2 downto 0);
  signal nELog2_d1 : std_logic_vector(wE+wF+2 downto 0);

  signal nLogX_b0 : std_logic_vector(wF+g+1 downto 0);
  signal nLogX_b1 : std_logic_vector(wF+g+1 downto 0);

  signal nY_c0 : std_logic_vector(wF+wF+g+2 downto 0);
  signal nY_d1 : std_logic_vector(wF+wF+g+2 downto 0);

  signal nZ_d1 : std_logic_vector(wE+wF+wF+g+1 downto 0);
  signal nZ_d2 : std_logic_vector(wE+wF+wF+g+1 downto 0);

  signal sR_0  : std_logic_vector(0 downto 0);
  signal sR_1  : std_logic_vector(0 downto 0);
  signal sR_d3 : std_logic_vector(0 downto 0);

  signal eR0_d2 : std_logic_vector(log2(wE+wF) downto 0);
  signal eR0_d3 : std_logic_vector(log2(wE+wF) downto 0);
  signal eR1_d3 : std_logic_vector(wE0-1 downto 0);
  signal eR2_d3 : std_logic_vector(wE0-1 downto 0);
  signal eR_d3  : std_logic_vector(wE-1 downto 0);

  signal fR0_d2 : std_logic_vector(wF+g+1 downto 0);
  signal fR0_d3 : std_logic_vector(wF+g+1 downto 0);
  signal fR1_d3 : std_logic_vector(wF downto 0);
  signal fR_d3  : std_logic_vector(wF-1 downto 0);

  signal sticky_d3 : std_logic;
  signal round_d3  : std_logic;

  signal ufl_d3 : std_logic;
  
  signal fpR_d3 : std_logic_vector(2+wE+wF downto 0);
begin

-- 0 ------------------------------------------------------------------------------------------------------------------

  fpX_0 <= fpX;

  cmpSqrt2_0 <= '1' when fpX_0(wF-1 downto wF-6) >= cstSqrt2 else
                '0';

  nE0_0 <= ("0" & fpX_0(wE+wF-1 downto wF)) - ("00" & (wE-2 downto 1 => '1') & (not cmpSqrt2_0));

  sR_0(0) <= cmpSqrt2_0 when nE0_0 = (wE downto 0 => '0') else
             nE0_0(wE);

  nE_0 <= (wE-1 downto 0 => '0') - nE0_0(wE-1 downto 0) when sR_0(0) = '1' else
          nE0_0(wE-1 downto 0);


  nX0_0 <= "1" & fpX_0(wF-2 downto 0) & "0" when cmpSqrt2_0 = '0' else
           "0" & fpX_0(wF-1 downto 0);
  
  log : fp_log_log_clk
    generic map ( w => wF+1 )
    port map ( nX    => nX0_0,
               nLogX => nLogX_b0,
               clk   => clk );

  nX1_0 <= (not nX0_0(wF)) & nX0_0(wF-1 downto 0);

-- 1 ------------------------------------------------------------------------------------------------------------------

  process(clk)
  begin
    if clk'event and clk = '1' then
      sR_1  <= sR_0;
      nE_1  <= nE_0;
      nX1_1 <= nX1_0;
    end if;
  end process;

  nX_1 <= (wF downto 0 => '0') - nX1_1 when sR_1(0) = '1' else
          nX1_1;

--  mult_nelog2 : mult_clk
  mult_nelog2 : mult_clk_log
    generic map ( wX    => wE,
                  wY    => wF+3,
                  first => 0,
                  steps => 2 )
    port map ( nX  => nE_1,
               nY  => cstLog2,
               nR  => nELog2_a0,
               clk => clk );

-- b1 -----------------------------------------------------------------------------------------------------------------

  process(clk)
  begin
    if clk'event and clk = '1' then
      nLogX_b1 <= nLogX_b0;
    end if;
  end process;

  delay_buffer_nx : delay_buffer
    generic map ( w => wF+1,
                  n => fp_log_log_latency(wF+1) - 1 )
    port map ( nX_0 => nX_1,
               nX_d => nX_b1,
               clk  => clk );

--  mult_nz : mult_clk
  mult_nz : mult_clk_log
    generic map ( wX    => wF+1,
                  wY    => wF+g+2,
                  sgnX  => true,
                  sgnY  => false,
                  first => 0,
                  steps => 2 )
    port map ( nX  => nX_b1,
               nY  => nLogX_b1,
               nR  => nY_c0,
               clk => clk );
  
-- d1 -----------------------------------------------------------------------------------------------------------------

  delay_buffer_nelog2 : delay_buffer
    generic map ( w => wE+wF+3,
                  n => latD0 - (1 + mult_latency(wE, wF+3, 0, 2)) + 1 )
    port map ( nX_0 => nELog2_a0,
               nX_d => nELog2_d1,
               clk  => clk );

  delay_buffer_ny : delay_buffer
    generic map ( w => wF+wF+g+3,
                  n => latD0 - (fp_log_log_latency(wF+1) + mult_latency(wF+1, wF+g+2, 0, 2)) + 1 )
    port map ( nX_0 => nY_c0,
               nX_d => nY_d1,
               clk  => clk );

  nZ_d1 <= ((wE-1 downto 1 => nY_d1(wF+wF+g+1)) & nY_d1) + (nELog2_d1 & (wF+g-2 downto 0 => '0'));

-- d2 -----------------------------------------------------------------------------------------------------------------

  process(clk)
  begin
    if clk'event and clk = '1' then
      nZ_d2 <= nZ_d1;
    end if;
  end process;

  normalize : fp_log_normalize
    generic map ( w => wE+wF+wF+g+2,
                  n => wE+wF )
    port map ( nX => nZ_d2,
               fX => fR0_d2,
               nZ => eR0_d2 );

-- d3 -----------------------------------------------------------------------------------------------------------------

  process(clk)
  begin
    if clk'event and clk = '1' then
      eR0_d3 <= eR0_d2;
      fR0_d3 <= fR0_d2;
    end if;
  end process;

  delay_buffer_sr : delay_buffer
    generic map ( w => 1,
                  n => latD0 )
    port map ( nX_0 => sR_1,
               nX_d => sR_d3,
               clk  => clk );

  delay_buffer_fpx : delay_buffer
    generic map ( w => 3+wE+wF,
                  n => latD0 + 1 )
    port map ( nX_0 => fpX_0,
               nX_d => fpX_d3,
               clk  => clk );

  eR1_d3 <= conv_std_logic_vector(2**(wE-1)-1 + wE-1, wE0) - ((wE0-1 downto log2(wE+wF)+1 => '0') & eR0_d3);

  sticky_d3 <= '0' when fR0_d3(g-1 downto 0) = (g-1 downto 0 => '0') else
               '1';
  round_d3  <= fR0_d3(g) and (fR0_d3(g+1) or sticky_d3);

  fR1_d3 <= ("0" & fR0_d3(wF+g downto g+1)) + ((wF downto 1 => '0') & round_d3);

  eR2_d3 <= eR1_d3 + ((wE0-1 downto 1 => '0') & fR1_d3(wF));

  eR_d3 <= eR2_d3(wE-1 downto 0);

  underflow : if wE0 > wE generate
    ufl_d3 <= '1' when (eR2_d3(wE0-1) = '1') or (eR_d3 = (wE-1 downto 0 => '0')) else
              '0';
  end generate;

  no_underflow : if wE0 = wE generate
    ufl_d3 <= '0';
  end generate;

  fR_d3 <= fR1_d3(wF-1 downto 0);

  fpR_d3(wE+wF+2 downto wE+wF) <= "110"        when ((fpX_d3(wE+wF+2) and (fpX_d3(wE+wF+1) or fpX_d3(wE+wF))) or
                                                     (fpX_d3(wE+wF+1) and fpX_d3(wE+wF))) = '1'                  else
                                  "101"        when fpX_d3(wE+wF+2 downto wE+wF+1) = "00"                        else
                                  "100"        when fpX_d3(wE+wF+2 downto wE+wF+1) = "10"                        else
                                  "00" & sR_d3 when (fR0_d3(wF+g+1) = '0') or (ufl_d3 = '1')                     else
                                  "01" & sR_d3;

  fpR_d3(wE+wF-1 downto 0) <= eR_d3 & fR_d3;

  fpR <= fpR_d3;

end architecture;
