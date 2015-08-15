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

--library ieee;
--use ieee.std_logic_1164.all;
--library fplib;
--use fplib.pkg_fplib_std.all;
--use fplib.pkg_fplib_fp.all;
--
--entity Add is
--  generic ( wE  : positive := 8;
--            wF  : positive := 23);
--  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
--         nB : in  std_logic_vector(wE+wF+2 downto 0);
--         nR : out std_logic_vector(wE+wF+2 downto 0) );
--end entity;
--
--architecture arch of Add is
--begin
--    add : FPAdd generic map (wE => wE, wF => wF) port map (nA => nA, nB => nB, nR => nR);
--end architecture;
--
--library ieee;
--use ieee.std_logic_1164.all;
--library fplib;
--use fplib.pkg_fplib_std.all;
--use fplib.pkg_fplib_fp.all;
--use fplib.pkg_misc.all;

entity Add_Clk is
  generic (
            wE  : positive := 8;
            wF  : positive := 23;
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


--library ieee;
--use ieee.std_logic_1164.all;
--library fplib;
--use fplib.pkg_fplib_std.all;
--use fplib.pkg_fplib_fp.all;
--
--
--entity Mul is
--  generic ( wE  : positive := 8;
--            wF  : positive := 23 );
--  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
--         nB : in  std_logic_vector(wE+wF+2 downto 0);
--         nR : out std_logic_vector(wE+wF+2 downto 0) );
--end entity;
--
--architecture arch of Mul is
--begin
--    mul : FPMul  generic map ( wE => wE,  wF => wF)
--                 port map ( nA => nA, nB => nB,  nR => nR );
--end architecture;


library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;
use fplib.pkg_misc.all;

entity Mul_Clk is
  generic ( wE  : positive := 8;
            wF  : positive := 23;
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

--library ieee;
--use ieee.std_logic_1164.all;
--library fplib;
--use fplib.pkg_fplib_std.all;
--use fplib.pkg_fplib_fp.all;
--
--entity Div is
--  generic ( wE  : positive := 8;
--            wF  : positive := 23 );
--  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
--         nB : in  std_logic_vector(wE+wF+2 downto 0);
--         nR : out std_logic_vector(wE+wF+2 downto 0) );
--end entity;
--
--architecture arch of Div is
--begin
--    div : FPDiv
--      generic map ( wE => wE, wF => wF )
--      port map ( nA => nA, nB => nB, nR => nR );
--end architecture;


library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;
use fplib.pkg_misc.all;

entity Div_Clk is
  generic ( wE  : positive := 8;
            wF  : positive := 23;
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


--library ieee;
--use ieee.std_logic_1164.all;
--library fplib;
--use fplib.pkg_fplib_std.all;
--use fplib.pkg_fplib_fp.all;
--
--entity Sqrt is
--  generic ( wE  : positive := 8;
--            wF  : positive := 23 );
--  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
--         nR : out std_logic_vector(wE+wF+2 downto 0) );
--end entity;
--
--architecture arch of Sqrt is
--begin
--    sqrt : FPSqrt
--      generic map ( wE => wE, wF => wF )
--      port map ( nA => nA, nR => nR );
--end architecture;


library ieee;
use ieee.std_logic_1164.all;
library fplib;
use fplib.pkg_fplib_std.all;
use fplib.pkg_fplib_fp.all;
use fplib.pkg_misc.all;

entity Sqrt_Clk is
  generic (
            wE  : positive := 8;
            wF  : positive := 23;
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


-----------------------------------------------------------------------------
-- FP/FXP Conversion Components
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_misc.all;
use fplib.pkg_fxpconv.all;

entity FXP_To_FP is
  generic ( wE    : positive := 8;
            wF    : positive := 23;
            wFX_I : positive := 32;
            wFX_F : positive := 1 );
  port ( nA : in  std_logic_vector(wFX_I+wFX_F-1 downto 0);
         nR : out std_logic_vector(wE+wF+2 downto 0));
end entity;

architecture arch of FXP_To_FP is
  constant wFX  : positive := wFX_I+wFX_F;
--  constant eMax : integer := min(2**(wE-1), wFX_I);
--  constant eMin : integer := min(2**(wE-1)-2, wFX_F);

  constant eMax : integer := wFX_I;
  constant eMin : integer := wFX_F;

  signal sR : std_logic;
  signal nA1 : std_logic_vector(wFX-2 downto 0);
  signal nA2 : std_logic_vector(wFX-1 downto 0);
  
  constant wNZeros : natural := log((eMax+eMin+3)/4)+3;
  signal nZeros : std_logic_vector(wNZeros-1 downto 2);
  signal eR     : std_logic_vector(wE-1 downto 0);
  signal fR     : std_logic_vector(wF-1 downto 0);
  
  signal overFl0 : std_logic;
  signal overFl1 : std_logic;
  signal overFl  : std_logic;
  signal undrFl0 : std_logic;
  signal undrFl1 : std_logic;
  signal undrFl  : std_logic;
  signal eTest   : std_logic_vector(1 downto 0);
begin
  sR <= nA(wFX-1);

  neg : for i in wFX-2 downto 0 generate
    nA1(i) <= nA(i) xor sR;
  end generate;
  nA2 <= ('0' & nA1) + ((wFX-1 downto 1 => '0') & sR);

  lzc : FXP_LZC
    generic map ( w => eMax+eMin )
    port map ( f => nA2(eMax+wFX_F-1 downto wFX_F-eMin),
               n => nZeros );

  norm : FXP_Norm
    generic map ( wE    => wE,
                  wF    => wF,
                  wFX_I => eMax,
                  wFX_F => wFX_F,
                  wN    => wNZeros )
    port map ( nA => nA2(eMax+wFX_F-1 downto 0),
               n  => nZeros,
               eR => eR,
               fR => fR );

  overflow0 : if eMax < wFX_I generate
    overFl0 <= '0' when nA2(wFX-1 downto eMax+wFX_F) = (wFX_I-1 downto eMax => '0') else
               '1';
  end generate;
  no_overflow0 : if eMax = wFX_I generate
    overFl0 <= '0';
  end generate;

  overflow1 : if 2**(wE-1) < wFX_I+1 and eMax+wFX_F-1 > wF generate
    overFl1 <= '1' when eR = (wE-1 downto 0 => '1') else
               '0';
  end generate;
  no_overflow1 : if 2**(wE-1) >= wFX_I+1 or eMax+wFX_F-1 <= wF generate
    overFl1 <= '0';
  end generate;

  overFl <= overFl0 or (overFl1 and not overFl0);

  undrFl0 <= '1' when nA2(wFX-1 downto wFX_F-eMin) = (wFX-1 downto wFX_F-eMin => '0') else
             '0';
  undrFl1 <= '0' when eR = (wE-1 downto 1 => '0') & "1" else
             '1';
  undrFl <= undrFl0 and undrFl1;

  eTest <= overFl & undrFl;

  with eTest select
    nR(wE+wF+2 downto wE+wF+1) <= "00" when "01",
                                  "10" when "10",
                                  "01" when others;
  nR(wE+wF downto 0) <= sR & eR & fR;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library fplib;
use fplib.pkg_misc.all;
use fplib.pkg_fxpconv.all;

entity FP_To_FXP is
  generic ( wE    : positive := 8;
            wF    : positive := 23;
            wFX_I : positive := 32;
            wFX_F : positive := 1 );
  port ( nA : in  std_logic_vector(wE+wF+2 downto 0);
         nR : out std_logic_vector(wFX_I+wFX_F-1 downto 0));
end entity;

architecture arch of FP_To_FXP is
  constant wFX  : positive := wFX_I+wFX_F;
  constant eMax : integer := 2**(wE-1)-1;
  constant eMin : integer := 2**(wE-1)-2;
--  constant wFX0 : positive := min(eMax+1,wFX_I)+wFX_F;
  constant wFX0 : positive := wFX_I+wFX_F;

  signal overFl0 : std_logic;
  signal overFl1 : std_logic;
  signal undrFl0 : std_logic;
  signal round   : std_logic;
  signal eTest   : std_logic_vector(1 downto 0);
  
  signal eA0 : std_logic_vector(wE-1 downto 0);
  signal eA1 : std_logic_vector(wE-1 downto 0);
  signal fA0 : std_logic_vector(wFX0+1 downto 0);
  signal fA1 : std_logic_vector(wFX0+1 downto 0);
  signal fA2 : std_logic_vector(wFX downto 0);
  signal fA3 : std_logic_vector(wFX-1 downto 0);
  signal fA4 : std_logic_vector(wFX-1 downto 0);
begin
  eA0 <= nA(wE+wF-1 downto wF);
--  eA1 <= conv_std_logic_vector(2**(wE-1)-1+min(eMax,wFX_I-1), wE) - eA0;
  eA1 <= conv_std_logic_vector(2**(wE-1)-1+wFX_I-1, wE) - eA0;

  fpad : if wF+1 < wFX0+2 generate
    fA0 <= "1" & nA(wF-1 downto 0) & (wFX0-wF downto 0 => '0');
  end generate;
  no_fpad : if wF+1 >= wFX0+2 generate
    fA0 <= "1" & nA(wF-1 downto wF-wFX0);
    fA0(0) <= '0' when nA(wF-wFX0-1 downto 0) = (wF-wFX0-1 downto 0 => '0') else
              '1';
  end generate;

  shift : FXP_Shift
    generic map ( wE  => wE,
                  wFX => wFX0 )
    port map ( fA => fA0,
               n  => eA1,
               fR => fA1 );

  round <= fA1(1) and (fA1(2) or fA1(0));
  fA2 <= ((wFX-wFX0 downto 0 => '0') & fA1(wFX0+1 downto 2)) + ((wFX downto 1 => '0') & round);
  
  overflow0 : if eMax+1 > wFX_I generate
    overFl0 <= '1' when eA0 > conv_std_logic_vector(2**(wE-1)-1+wFX_I-1, wE) else
               nA(wE+wF+2);
  end generate;
  no_overflow0 : if eMax+1 <= wFX_I generate
    overFl0 <= nA(wE+wF+2);
  end generate;

  overFl1 <= fA2(wFX) or fA2(wFX-1);

  underflow0 : if eMin > wFX_F generate
    undrFl0 <= '1' when eA0 < conv_std_logic_vector(2**(wE-1)-1-wFX_F, wE) else
               not (nA(wE+wF+2) or nA(wE+wF+1));
  end generate;
  no_underflow0 : if eMin <= wFX_F generate
    undrFl0 <= not (nA(wE+wF+2) or nA(wE+wF+1));
  end generate;

  neg : for i in wFX-1 downto 0 generate
    fA3(i) <= fA2(i) xor nA(wE+wF);
  end generate;
  fA4 <= fA3 + ((wFX-1 downto 1 => '0') & nA(wE+wF));
  
  eTest <= (overFl0 or overFl1) & undrFl0;
  with eTest select
    nR <= (wFX-1 downto 0 => '0')                       when "01",
          nA(wE+wF) & (wFX-2 downto 0 => not nA(wE+wF)) when "10",
          fA4                                           when others;
end architecture;


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

-----------------------------------------------------------------------------
-- Log_Clk Components
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library fplib;
use fplib.pkg_fp_log.all;
use fplib.pkg_misc.all;

entity Log_Clk is
  generic (
            wE  : positive := 8;
            wF  : positive := 23;
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

-----------------------------------------------------------------------------
-- Exp_Clk Components
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library fplib;
use fplib.pkg_fp_exp.all;
use fplib.pkg_misc.all;

entity Exp_Clk is
  generic (
            wE  : positive := 8;
            wF  : positive := 23;
            reg : boolean  := true;
            SzSlk  : natural  := 0 );
  port ( nA  : in  std_logic_vector(wE+wF+2 downto 0);
         nR  : out std_logic_vector(wE+wF+2 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of Exp_Clk is
  signal pipebuf_nR  : std_logic_vector(wE+wF+2 downto 0);
begin
    wreg : if reg = true generate
      expreg : fp_exp_clk generic map ( wE => wE, wF => wF )
                      port map ( fpX  => nA, fpR  => pipebuf_nR, clk => clk );
      
      wPipeBuf : if SzSlk>=0 generate
        exp_pipeBuf: Delay
          generic map (w=>wE+wF+2+1, n=> SzSlk)
          port map (input=> pipebuf_nR, output=>nR, clk=> clk);
      end generate;    
    end generate;

    woreg_woPipeBuf : if reg = false generate
      expcmb : fp_exp
        generic map ( wE => wE, wF => wF )
        port map ( fpX  => nA, fpR  => nR );
    end generate;
       
end architecture;
