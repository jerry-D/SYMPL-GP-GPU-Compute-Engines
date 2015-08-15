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
use fplib.pkg_misc.all;

package pkg_fp_exp is

  function mult_latency ( wX, wY : positive;
                          first  : integer;
                          steps  : positive )
    return positive;

  function fp_exp_g ( wF : positive )
    return positive;

  function fp_exp_wy1 ( wF : positive )
    return positive;

  function fp_exp_wy2 ( wF : positive )
    return positive;

  function fp_exp_shift_wx ( wE, wF : positive )
    return positive;

  function fp_exp_shift_latency ( wE, wF : positive )
    return positive;

  function fp_exp_exp_y2_latency ( wF : positive )
    return positive;

  function fp_exp_add_z0_latency ( wF : positive )
    return integer;

  component delay_buf is
    generic ( w : positive;
              n : integer := 1 );
    port ( nX_0 : in  std_logic_vector(w-1 downto 0);
           nX_d : out std_logic_vector(w-1 downto 0);
           clk  : in  std_logic );
  end component;

--  component mult_clk is
  component mult_clk_exp is
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

  component fp_exp_shift is
    generic ( wE : positive;
              wF : positive );
    port ( fpX : in  std_logic_vector(wE+wF downto 0);
           nX  : out std_logic_vector(wE+wF+fp_exp_g(wF)-1 downto 0);
           ofl : out std_logic;
           ufl : out std_logic );
  end component;

  component fp_exp_shift_clk is
    generic ( wE : positive;
              wF : positive );
    port ( fpX : in  std_logic_vector(wE+wF downto 0);
           nX  : out std_logic_vector(wE+wF+fp_exp_g(wF)-1 downto 0);
           ofl : out std_logic;
           ufl : out std_logic;
           clk : in  std_logic );
  end component;

  component fp_exp_exp_y1 is
    generic ( wF : positive );
    port ( nY1    : in  std_logic_vector(fp_exp_wy1(wF)-1 downto 0);
           nExpY1 : out std_logic_vector(wF+fp_exp_g(wF)-1 downto 0) );
  end component;

  component fp_exp_exp_y2 is
    generic ( wF : positive );
    port ( nY2    : in  std_logic_vector(fp_exp_wy2(wF)-1 downto 0);
           nExpY2 : out std_logic_vector(fp_exp_wy2(wF) downto 0) );
  end component;

  component fp_exp_exp_y2_clk is
    generic ( wF : positive );
    port ( nY2    : in  std_logic_vector(fp_exp_wy2(wF)-1 downto 0);
           nExpY2 : out std_logic_vector(fp_exp_wy2(wF) downto 0);
           clk    : in  std_logic );
  end component;

  component fp_exp is
  generic ( wE : positive;
            wF : positive  );
  port ( fpX : in  std_logic_vector(2+wE+wF downto 0);
         fpR : out std_logic_vector(2+wE+wF downto 0) );
  end component;

  component fp_exp_clk is
  generic ( wE : positive;
            wF : positive );
  port ( fpX : in  std_logic_vector(2+wE+wF downto 0);
         fpR : out std_logic_vector(2+wE+wF downto 0);
         clk : in  std_logic );
  end component;

end package;


package body pkg_fp_exp is

  function mult_latency ( wX, wY : positive;
                          first  : integer;
                          steps  : positive ) return positive is
  begin
    return (log2(minimum(wX, wY)-1)+1+1 + first + steps-1) / steps;
  end function;

  function fp_exp_g ( wF : positive ) return positive is
  begin
    return 5;
  end function;

  function fp_exp_wy1 ( wF : positive ) return positive is
  begin
    if wF <= 19 then
      return (wF+fp_exp_g(wF)+1)/3;
    else
      return 8;
    end if;
  end function;

  function fp_exp_wy2 ( wF : positive ) return positive is
  begin
    return wF + fp_exp_g(wF) - 2*fp_exp_wy1(wF);
  end function;

  function fp_exp_shift_wx ( wE, wF : positive ) return positive is
  begin
    return minimum(wF+fp_exp_g(wF), 2**(wE-1)-1);
  end function;

  function fp_exp_shift_latency ( wE, wF : positive ) return positive is
    constant first : integer  := 4;
    constant steps : positive := 8;
  begin
    return (log2(fp_exp_shift_wx(wE, wF)+wE-2)+1 + first-1) / steps + 1;
  end function;

  function fp_exp_exp_y2_latency ( wF : positive ) return positive is
  begin
    if wF <= 19 then
      return 1;
    else
      return 2;
    end if;
  end function;

  function fp_exp_add_z0_latency ( wF : positive ) return integer is
  begin
    if wF <= 19 then
      return 0;
    else
      return 1;
    end if;                    
  end function;

end package body;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity delay_buf is
  generic ( w : positive;
            n : integer := 1 );
  port ( nX_0 : in  std_logic_vector(w-1 downto 0);
         nX_d : out std_logic_vector(w-1 downto 0);
         clk  : in  std_logic );
end entity;

architecture arch of delay_buf is
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

library fplib;
use fplib.pkg_fp_exp.all;
use fplib.pkg_misc.all;

--entity mult_clk is
entity mult_clk_exp is
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
architecture arch of mult_clk_exp is
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
use fplib.pkg_fp_exp.all;
use fplib.pkg_misc.all;

entity fp_exp_shift is
  generic ( wE : positive;
            wF : positive );
  port ( fpX : in  std_logic_vector(wE+wF downto 0);
         nX  : out std_logic_vector(wE+wF+fp_exp_g(wF)-1 downto 0);
         ofl : out std_logic;
         ufl : out std_logic );
end entity;

architecture arch of fp_exp_shift is
  constant g  : positive := fp_exp_g(wF);
  constant wX : integer  := fp_exp_shift_wx(wE, wF);
  constant n  : positive := log2(wX+wE-2)+1;

  signal e0 : std_logic_vector(wE+1 downto 0);
  signal eX : std_logic_vector(wE+1 downto 0);

  signal mXu : std_logic_vector(wF downto 0);
  signal mXs : std_logic_vector(wF+1 downto 0);

  signal buf : std_logic_vector((n+1)*(wF+2**n+1)-1 downto 0);
begin

  e0 <= conv_std_logic_vector(2**(wE-1)-1 - wX, wE+2);
  eX <= ("00" & fpX(wE+wF-1 downto wF)) - e0;

  ufl <= eX(wE+1);
  ofl <= not eX(wE+1) when eX(wE downto 0) > conv_std_logic_vector(wX+wE-2, wE+1) else
         '0';

  mXu <= "1" & fpX(wF-1 downto 0);

  mXs <= (wF+1 downto 0 => '0') - ("0" & mXu) when fpX(wE+wF) = '1' else
         "0" & mXu;

  buf(wF+1 downto 0) <= mXs;

  shift : for i in 0 to n-1 generate
    buf((i+1)*(wF+2**n+1)+wF+2**(i+1) downto (i+1)*(wF+2**n+1)) <=
      (2**i-1 downto 0 => buf(i*(wF+2**n+1)+wF+2**i)) & buf(i*(wF+2**n+1)+wF+2**i downto i*(wF+2**n+1)) when eX(i) = '0' else
      buf(i*(wF+2**n+1)+wF+2**i downto i*(wF+2**n+1)) & (2**i-1 downto 0 => '0');
  end generate;

  no_padding : if wX >= g generate
    nX <= buf(n*(wF+2**n+1)+wF+wE+wX-1 downto n*(wF+2**n+1)+wX-g);
  end generate;

  padding : if wX < g generate
    nX <= buf(n*(wF+2**n+1)+wF+wE+wX-1 downto n*(wF+2**n+1)) & (g-wX-1 downto 0 => '0');
  end generate;

end architecture;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use work.pkg_fp_exp.all;
use work.pkg_misc.all;

entity fp_exp_shift_clk is
  generic ( wE : positive;
            wF : positive );
  port ( fpX : in  std_logic_vector(wE+wF downto 0);
         nX  : out std_logic_vector(wE+wF+fp_exp_g(wF)-1 downto 0);
         ofl : out std_logic;
         ufl : out std_logic;
         clk : in  std_logic );
end entity;

architecture arch of fp_exp_shift_clk is
  constant g  : positive := fp_exp_g(wF);
  constant wX : integer  := fp_exp_shift_wx(wE, wF);
  constant n  : positive := log2(wX+wE-2)+1;

  constant first : integer  := 4;
  constant steps : positive := 8;
  constant nr    : integer  := (n+first-1)/steps;

  signal fpX_0 : std_logic_vector(wE+wF downto 0);
  
  constant e0 : std_logic_vector(wE+1 downto 0) := conv_std_logic_vector(2**(wE-1)-1 - wX, wE+2);

  signal eX_0 : std_logic_vector(wE+1 downto 0);
  signal eX_x : std_logic_vector((nr+1)*n-1 downto 0);
  signal eX_r : std_logic_vector((nr+1)*n-1 downto 0);

  signal ofl_0  : std_logic_vector(0 downto 0);
  signal ofl_a0 : std_logic_vector(0 downto 0);
  signal ufl_0  : std_logic_vector(0 downto 0);
  signal ufl_a0 : std_logic_vector(0 downto 0);

  signal mXu_0 : std_logic_vector(wF downto 0);
  signal mXs_0 : std_logic_vector(wF+1 downto 0);

  signal buf_x : std_logic_vector((n+1)*(wF+2**n+1)-1 downto 0);
  signal buf_r : std_logic_vector(nr*(wF+2**n+1)-1 downto 0);

  signal nX_a0 : std_logic_vector(wE+wF+g-1 downto 0);
begin

  fpX_0 <= fpX;

  eX_0 <= ("00" & fpX_0(wE+wF-1 downto wF)) - e0;

  ufl_0(0) <= eX_0(wE+1);
  ofl_0(0) <= not eX_0(wE+1) when eX_0(wE downto 0) > conv_std_logic_vector(wX+wE-2, wE+1) else
              '0';

  mXu_0 <= "1" & fpX_0(wF-1 downto 0);

  mXs_0 <= (wF+1 downto 0 => '0') - ("0" & mXu_0) when fpX_0(wE+wF) = '1' else
           "0" & mXu_0;

  buf_x(wF+1 downto 0) <= mXs_0;

  eX_x(n-1 downto 0) <= eX_0(n-1 downto 0);

  shift : for i in 0 to n-1 generate
    no_reg : if ((i+first) mod steps /= 0) or (i+first <= 0) generate
      buf_x((i+1)*(wF+2**n+1)+wF+2**(i+1) downto (i+1)*(wF+2**n+1)) <=
        (2**i-1 downto 0 => buf_x(i*(wF+2**n+1)+wF+2**i)) & buf_x(i*(wF+2**n+1)+wF+2**i downto i*(wF+2**n+1)) when eX_x(((i+first)/steps)*n+i) = '0' else
        buf_x(i*(wF+2**n+1)+wF+2**i downto i*(wF+2**n+1)) & (2**i-1 downto 0 => '0');
    end generate;

    reg : if ((i+first) mod steps = 0) and (i+first > 0) generate
      process(clk)
      begin
        if clk'event and clk = '1' then
          buf_r((i/steps)*(wF+2**n+1)+wF+2**i downto (i/steps)*(wF+2**n+1)) <= buf_x(i*(wF+2**n+1)+wF+2**i downto i*(wF+2**n+1));
          eX_r((i/steps+1)*n+n-1 downto (i/steps+1)*n+i)                    <= eX_x((i/steps)*n+n-1 downto (i/steps)*n+i);
        end if;
      end process;

      eX_x((i/steps+1)*n+n-1 downto (i/steps+1)*n+i) <= eX_r((i/steps+1)*n+n-1 downto (i/steps+1)*n+i);

      buf_x((i+1)*(wF+2**n+1)+wF+2**(i+1) downto (i+1)*(wF+2**n+1)) <=
        (2**i-1 downto 0 => buf_r((i/steps)*(wF+2**n+1)+wF+2**i)) & buf_r((i/steps)*(wF+2**n+1)+wF+2**i downto (i/steps)*(wF+2**n+1)) when eX_x((i/steps+1)*n+i) = '0' else
        buf_r((i/steps)*(wF+2**n+1)+wF+2**i downto (i/steps)*(wF+2**n+1)) & (2**i-1 downto 0 => '0');
    end generate;
  end generate;

  no_padding : if wX >= g generate
    nX_a0 <= buf_x(n*(wF+2**n+1)+wF+wE+wX-1 downto n*(wF+2**n+1)+wX-g);
  end generate;

  padding : if wX < g generate
    nX_a0 <= buf_x(n*(wF+2**n+1)+wF+wE+wX-1 downto n*(wF+2**n+1)) & (g-wX-1 downto 0 => '0');
  end generate;

  delay_buf_ofl : delay_buf
    generic map ( w => 1,
                  n => nr )
    port map ( nX_0 => ofl_0,
               nX_d => ofl_a0,
               clk  => clk );

  delay_buf_ufl : delay_buf
    generic map ( w => 1,
                  n => nr )
    port map ( nX_0 => ufl_0,
               nX_d => ufl_a0,
               clk  => clk );

  nX  <= nX_a0;
  ofl <= ofl_a0(0);
  ufl <= ufl_a0(0);

end architecture;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_fp_exp.all;
use fplib.pkg_misc.all;

entity fp_exp is
  generic ( wE : positive := 6;
            wF : positive := 13 );
  port ( fpX : in  std_logic_vector(2+wE+wF downto 0);
         fpR : out std_logic_vector(2+wE+wF downto 0) );
end entity;

architecture arch of fp_exp is
  constant g   : positive := fp_exp_g(wF);
  constant wY1 : positive := fp_exp_wy1(wF);
  constant wY2 : positive := fp_exp_wy2(wF);

  signal nX : std_logic_vector(wE+wF+g-1 downto 0);

  constant cstInvLog2 : std_logic_vector(wE+1 downto 0) := cst_InvLog2(wE+1);

  signal nK0 : std_logic_vector(wE+4+wE downto 0);
  signal nK1 : std_logic_vector(wE+4+wE+1 downto 0);
  signal nK  : std_logic_vector(wE downto 0);

  constant cstLog2 : std_logic_vector(wE-1+wF+g-1 downto 0) := cst_Log2(wE-1+wF+g);

  signal nKLog20 : std_logic_vector(wE+wE-1+wF+g-1 downto 0);
  signal nKLog2  : std_logic_vector(wE+wE-1+wF+g downto 0);
  
  signal nY  : std_logic_vector(wE+wF+g-1 downto 0);
  signal nY1 : std_logic_vector(wY1-1 downto 0);

  signal nEY1 : std_logic_vector(wF+g-1 downto 0);
  signal nEY2 : std_logic_vector(wY2 downto 0);

  signal nZ0 : std_logic_vector(wF+g-wY1+1 downto 0);
  signal nZ1 : std_logic_vector(wF+g+wF+g-wY1+1 downto 0);
  signal nZ2 : std_logic_vector(wF+g-wY1 downto 0);
  signal nZ  : std_logic_vector(wF+g-1 downto 0);

  signal sticky : std_logic;
  signal round  : std_logic;

  signal fR0 : std_logic_vector(wF+1 downto 0);
  signal fR1 : std_logic_vector(wF downto 0);
  signal fR  : std_logic_vector(wF-1 downto 0);

  signal eR : std_logic_vector(wE downto 0);
  
  signal ofl0 : std_logic;
  signal ofl1 : std_logic;
  signal ofl2 : std_logic;
  signal ufl0 : std_logic;
  signal ufl1 : std_logic;
begin

  shift : fp_exp_shift
    generic map ( wE => wE,
                  wF => wF )
    port map ( fpX => fpX(wE+wF downto 0),
               nX  => nX,
               ofl => ofl0,
               ufl => ufl0 );

  nK0 <= nX(wE+wF+g-2 downto wF+g-4) * cstInvLog2;
  nK1 <= ("0" & nK0) - ("0" & cstInvLog2 & (wE+4-2 downto 0 => '0')) when nX(wE+wF+g-1) = '1' else
         "0" & nK0;

  nK <= nK1(wE+4+wE+1 downto 4+wE+1) + ((wE downto 1 => '0') & nK1(4+wE));

  nKLog20 <= nK(wE-1 downto 0) * cstLog2;
  nKLog2  <= ("0" & nKLog20) - ("0" & cstLog2 & (wE-1 downto 0 => '0')) when nK(wE) = '1' else
             "0" & nKLog20;

  nY <= nX - nKLog2(wE+wE-1+wF+g-1 downto wE-1);

  nY1 <= (not nY(wF+g-1)) & nY(wF+g-2 downto wF+g-wY1);

  exp_y1 : fp_exp_exp_y1
    generic map ( wF => wF )
    port map ( nY1    => nY1,
               nExpY1 => nEY1 );

  exp_y2 : fp_exp_exp_y2
    generic map ( wF => wF )
    port map ( nY2    => nY(wF+g-wY1-1 downto wY1),
               nExpY2 => nEY2 );

  nZ0 <= ((wF+g-wY1+1 downto wY2+1 => '0') & nEY2) + ("0" & nY(wF+g-wY1-1 downto 0) & "0");

  nZ1 <= nEY1 * nZ0;
  nZ2 <= nZ1(wF+g+wF+g-wY1+1 downto wF+g+1);

  nZ <= nEY1 + ((wF+g-1 downto wF+g-wY1+1 => '0') & nZ2);

  sticky <= '1' when nZ(g-4 downto 0) /= (g-4 downto 0 => '0') else
            '0';
  fR0 <= nZ(wF+g-2 downto g-2) & (nZ(g-3) or sticky) when nZ(wF+g-1) = '1' else
         nZ(wF+g-3 downto g-3) & sticky;

  round <= fR0(1) and (fR0(2) or fR0(0));
  fR1 <= ("0" & fR0(wF+1 downto 2)) + ((wF+1 downto 3 => '0') & round);

  fR <= fR1(wF-1 downto 0);

  eR <= nK + ("0" & (wE-2 downto 1 => '1') & (nZ(wF+g-1) or fR1(wF)));

  ofl1 <= '1' when eR(wE-1 downto 0) = (wE-1 downto 0 => '0') else
          '1' when eR(wE-1 downto 0) = (wE-1 downto 0 => '1') else
          ofl0 or eR(wE);

  ufl1 <= '1' when fpX(wE+wF+2 downto wE+wF+1) = "00" else
          ufl0;

  ofl2 <= '1' when fpX(wE+wF+2 downto wE+wF+1) = "10" else
          ofl1 and (not ufl1);
  
  fpR(wE+wF+2 downto wE+wF+1) <= "11"                   when fpX(wE+wF+2 downto wE+wF+1) = "11" else
                                 (not fpX(wE+wF)) & "0" when ofl2 = '1'                         else
                                 "01";

  fpR(wE+wF downto 0) <= "00" & (wE-2 downto 0 => '1') & (wF-1 downto 0 => '0') when ufl1 = '1' else
                         "0" & eR(wE-1 downto 0) & fR;

end architecture;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_fp_exp.all;
use fplib.pkg_misc.all;

entity fp_exp_clk is
  generic ( wE : positive := 6;
            wF : positive := 13 );
  port ( fpX : in  std_logic_vector(2+wE+wF downto 0);
         fpR : out std_logic_vector(2+wE+wF downto 0);
         clk : in  std_logic );
end entity;

architecture arch of fp_exp_clk is
  constant g   : positive := fp_exp_g(wF);
  constant wY1 : positive := fp_exp_wy1(wF);
  constant wY2 : positive := fp_exp_wy2(wF);
  
  signal fpX_0  : std_logic_vector(2+wE+wF downto 0);
  signal fpX_e3 : std_logic_vector(2+wE+wF downto 0);

  signal nX_a0 : std_logic_vector(wE+wF+g-1 downto 0);
  signal nX_a1 : std_logic_vector(wE+wF+g-1 downto 0);
  signal nX_c1 : std_logic_vector(wE+wF+g-1 downto 0);

  constant cstInvLog2 : std_logic_vector(wE+1 downto 0) := cst_InvLog2(wE+1);

  signal nK0_b0 : std_logic_vector(wE+4+wE+1 downto 0);
  signal nK_b0  : std_logic_vector(wE downto 0);
  signal nK_b1  : std_logic_vector(wE downto 0);
  signal nK_e3  : std_logic_vector(wE downto 0);

  constant cstLog2 : std_logic_vector(wE-1+wF+g-1 downto 0) := cst_Log2(wE-1+wF+g);

  signal nKLog2_c0 : std_logic_vector(wE+wE-1+wF+g downto 0);
  signal nKLog2_c1 : std_logic_vector(wE+wE-1+wF+g downto 0);
  
  signal nY_c1  : std_logic_vector(wE+wF+g-1 downto 0);
  signal nY_d1  : std_logic_vector(wE+wF+g-1 downto 0);
  signal nY1_c1 : std_logic_vector(wY1-1 downto 0);

  signal nEY1_c1 : std_logic_vector(wF+g-1 downto 0);
  signal nEY1_d2 : std_logic_vector(wF+g-1 downto 0);
  signal nEY1_e1 : std_logic_vector(wF+g-1 downto 0);
  signal nEY2_d0 : std_logic_vector(wY2 downto 0);
  signal nEY2_d1 : std_logic_vector(wY2 downto 0);

  signal nZ0_d1 : std_logic_vector(wF+g-wY1+1 downto 0);
  signal nZ0_d2 : std_logic_vector(wF+g-wY1+1 downto 0);
  signal nZ1_e0 : std_logic_vector(wF+g+wF+g-wY1+1 downto 0);
  signal nZ2_e0 : std_logic_vector(wF+g-wY1 downto 0);
  signal nZ2_e1 : std_logic_vector(wF+g-wY1 downto 0);
  signal nZ_e1  : std_logic_vector(wF+g-1 downto 0);
  signal nZ_e2  : std_logic_vector(wF+g-1 downto 0);
  signal nZ_e3  : std_logic_vector(wF+g-1 downto 0);

  signal sticky_e1 : std_logic;
  signal round_e2  : std_logic;

  signal fR0_e1 : std_logic_vector(wF+1 downto 0);
  signal fR0_e2 : std_logic_vector(wF+1 downto 0);
  signal fR1_e2 : std_logic_vector(wF downto 0);
  signal fR1_e3 : std_logic_vector(wF downto 0);
  signal fR_e3  : std_logic_vector(wF-1 downto 0);

  signal eR_e3 : std_logic_vector(wE downto 0);
  
  signal ofl0_a0 : std_logic;
  signal ofl0_a1 : std_logic;
  signal ofl1_e3 : std_logic;
  signal ofl2_e3 : std_logic;
  signal ufl0_a0 : std_logic;
  signal ufl0_a1 : std_logic;
  signal ufl1_e3 : std_logic;

  signal fpR_e3 : std_logic_vector(2+wE+wF downto 0);
begin

  fpX_0 <= fpX;

-----------------------------------------------------------------------------------------------------------------------

  shift : fp_exp_shift_clk
    generic map ( wE => wE,
                  wF => wF )
    port map ( fpX => fpX_0(wE+wF downto 0),
               nX  => nX_a0,
               ofl => ofl0_a0,
               ufl => ufl0_a0,
               clk => clk );

  process(clk)
  begin
    if clk'event and clk = '1' then
      nX_a1   <= nX_a0;
      ofl0_a1 <= ofl0_a0;
      ufl0_a1 <= ufl0_a0;
    end if;
  end process;

-----------------------------------------------------------------------------------------------------------------------

--  mult_k : mult_clk
  mult_k : mult_clk_exp
    generic map ( wX    => wE+4,
                  wY    => wE+2,
                  sgnX  => true,
                  first => 0,
                  steps => 3 )
    port map ( nX  => nX_a1(wE+wF+g-1 downto wF+g-4),
               nY  => cstInvLog2,
               nR  => nK0_b0,
               clk => clk );

  nK_b0 <= nK0_b0(wE+4+wE+1 downto 4+wE+1) + ((wE downto 1 => '0') & nK0_b0(4+wE));

  process(clk)
  begin
    if clk'event and clk = '1' then
      nK_b1 <= nK_b0;
    end if;
  end process;

-----------------------------------------------------------------------------------------------------------------------

--  mult_klog2 : mult_clk
  mult_klog2 : mult_clk_exp
    generic map ( wX    => wE+1,
                  wY    => wE-1+wF+g,
                  sgnX  => true,
                  first => -1,
                  steps => 2 )
    port map ( nX  => nK_b1,
               nY  => cstLog2,
               nR  => nKLog2_c0,
               clk => clk );

  process(clk)
  begin
    if clk'event and clk = '1' then
      nKLog2_c1 <= nKLog2_c0;
    end if;
  end process;

  delay_buf_nx : delay_buf
    generic map ( w => wE+wF+g,
                  n => mult_latency(wE+4, wE+2, 0, 3) + mult_latency(wE+1, wE-1+wF+g, -1, 2) )
    port map ( nX_0 => nX_a1,
               nX_d => nX_c1,
               clk  => clk );

-----------------------------------------------------------------------------------------------------------------------
  
  nY_c1 <= nX_c1 - nKLog2_c1(wE+wE-1+wF+g-1 downto wE-1);

  nY1_c1 <= (not nY_c1(wF+g-1)) & nY_c1(wF+g-2 downto wF+g-wY1);

  exp_y1 : fp_exp_exp_y1
    generic map ( wF => wF )
    port map ( nY1    => nY1_c1,
               nExpY1 => nEY1_c1 );

  exp_y2 : fp_exp_exp_y2_clk
    generic map ( wF => wF )
    port map ( nY2    => nY_c1(wF+g-wY1-1 downto wY1),
               nExpY2 => nEY2_d0,       
               clk    => clk );

  process(clk)
  begin
    if clk'event and clk = '1' then
      nEY2_d1 <= nEY2_d0;
    end if;
  end process;

  delay_buf_ny : delay_buf
    generic map ( w => wE+wF+g,
                  n => fp_exp_exp_y2_latency(wF) )
    port map ( nX_0 => nY_c1,
               nX_d => nY_d1,
               clk  => clk );
  
-----------------------------------------------------------------------------------------------------------------------

  nZ0_d1 <= ((wF+g-wY1+1 downto wY2+1 => '0') & nEY2_d1) + ("0" & nY_d1(wF+g-wY1-1 downto 0) & "0");

  delay_buf_ney1_0 : delay_buf
    generic map ( w => wF+g,
                  n => fp_exp_exp_y2_latency(wF) + fp_exp_add_z0_latency(wF) )
    port map ( nX_0 => nEY1_c1,
               nX_d => nEY1_d2,
               clk  => clk );

  delay_buf_nz0 : delay_buf
    generic map ( w => wF+g-wY1+2,
                  n => fp_exp_add_z0_latency(wF) )
    port map ( nX_0 => nZ0_d1,
               nX_d => nZ0_d2,
               clk  => clk );

-----------------------------------------------------------------------------------------------------------------------

--  mult_z1 : mult_clk
  mult_z1 : mult_clk_exp
    generic map ( wX    => wF+g,
                  wY    => wF+g-wY1+2,
                  first => 0,
                  steps => 2 )
    port map ( nX  => nEY1_d2,
               nY  => nZ0_d2,
               nR  => nZ1_e0,
               clk => clk );
  
  nZ2_e0 <= nZ1_e0(wF+g+wF+g-wY1+1 downto wF+g+1);

  process(clk)
  begin
    if clk'event and clk = '1' then
      nZ2_e1 <= nZ2_e0;
    end if;
  end process;

  delay_buf_ney1_1 : delay_buf
    generic map ( w => wF+g,
                  n => mult_latency(wF+g, wF+g-wY1+2, 0, 2) )
    port map ( nX_0 => nEY1_d2,
               nX_d => nEY1_e1,
               clk  => clk );
  
-----------------------------------------------------------------------------------------------------------------------

  nZ_e1 <= nEY1_e1 + ((wF+g-1 downto wF+g-wY1+1 => '0') & nZ2_e1);

  sticky_e1 <= '1' when nZ_e1(g-4 downto 0) /= (g-4 downto 0 => '0') else
               '0';
  fR0_e1 <= nZ_e1(wF+g-2 downto g-2) & (nZ_e1(g-3) or sticky_e1) when nZ_e1(wF+g-1) = '1' else
            nZ_e1(wF+g-3 downto g-3) & sticky_e1;

  process(clk)
  begin
    if clk'event and clk = '1' then
      nZ_e2  <= nZ_e1;
      fR0_e2 <= fR0_e1;
    end if;
  end process;

-----------------------------------------------------------------------------------------------------------------------

  round_e2 <= fR0_e2(1) and (fR0_e2(2) or fR0_e2(0));
  fR1_e2 <= ("0" & fR0_e2(wF+1 downto 2)) + ((wF+1 downto 3 => '0') & round_e2);

  process(clk)
  begin
    if clk'event and clk = '1' then
      nZ_e3  <= nZ_e2;
      fR1_e3 <= fR1_e2;
    end if;
  end process;

  delay_buf_fpx : delay_buf
    generic map ( w => 3+wE+wF,
                  n => (  fp_exp_shift_latency(wE, wF) + mult_latency(wE+4, wE+2, 0, 3) + mult_latency(wE+1, wE-1+wF+g, -1, 2)
                        + fp_exp_exp_y2_latency(wF) + fp_exp_add_z0_latency(wF) + mult_latency(wF+g, wF+g-wY1+2, 0, 2) + 2) )
    port map ( nX_0 => fpX_0,
               nX_d => fpX_e3,
               clk  => clk );

  delay_buf_nk : delay_buf
    generic map ( w => wE+1,
                  n => (  mult_latency(wE+1, wE-1+wF+g, -1, 2) + fp_exp_exp_y2_latency(wF) + fp_exp_add_z0_latency(wF)
                        + mult_latency(wF+g, wF+g-wY1+2, 0, 2) + 2) )
    port map ( nX_0 => nK_b1,
               nX_d => nK_e3,
               clk  => clk );
  
-----------------------------------------------------------------------------------------------------------------------

  fR_e3 <= fR1_e3(wF-1 downto 0);

  eR_e3 <= nK_e3 + ("0" & (wE-2 downto 1 => '1') & (nZ_e3(wF+g-1) or fR1_e3(wF)));

  ofl1_e3 <= '1' when eR_e3(wE-1 downto 0) = (wE-1 downto 0 => '0') else
             '1' when eR_e3(wE-1 downto 0) = (wE-1 downto 0 => '1') else
             ofl0_a1 or eR_e3(wE);

  ufl1_e3 <= '1' when fpX_e3(wE+wF+2 downto wE+wF+1) = "00" else
             ufl0_a1;

  ofl2_e3 <= '1' when fpX_e3(wE+wF+2 downto wE+wF+1) = "10" else
             ofl1_e3 and (not ufl1_e3);
  
  fpR_e3(wE+wF+2 downto wE+wF+1) <= "11"                      when fpX_e3(wE+wF+2 downto wE+wF+1) = "11" else
                                    (not fpX_e3(wE+wF)) & "0" when ofl2_e3 = '1'                         else
                                    "01";

  fpR_e3(wE+wF downto 0) <= "00" & (wE-2 downto 0 => '1') & (wF-1 downto 0 => '0') when ufl1_e3 = '1' else
                            "0" & eR_e3(wE-1 downto 0) & fR_e3;

-----------------------------------------------------------------------------------------------------------------------

  fpR <= fpR_e3;

end architecture;
