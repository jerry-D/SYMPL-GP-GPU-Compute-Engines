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
use fplib.pkg_misc.all;
use fplib.pkg_fpmul.all;

entity FPMul_AddTree_Clk is
  generic ( wF  : positive;
            nPProd : positive;
            wS     : positive;
            depth  : natural );
  port ( pprod : in  std_logic_vector(((nPProd+wS-1)/wS)*(wF+1+wS)-(wS-((nPProd-1) mod wS)-1)-1 downto 0);
         sum   : out std_logic_vector(wF+nPProd downto 0);
         clk   : in  std_logic );
end entity;

architecture arch of FPMul_AddTree_Clk is
  component FPMul_AddTree_Clk is
    generic ( wF  : positive;
              nPProd : positive;
              wS     : positive;
              depth  : natural );
    port ( pprod : in  std_logic_vector(((nPProd+wS-1)/wS)*(wF+1+wS)-(wS-((nPProd-1) mod wS)-1)-1 downto 0);
           sum   : out std_logic_vector(wF+nPProd downto 0);
           clk   : in  std_logic );
  end component;

  constant k1 : natural := 2**(log((nPProd+wS-1)/wS-1))*wS;
  constant k2 : natural := max(nPProd-k1, 0);

  signal pprod_1 : std_logic_vector(((nPProd+wS-1)/wS)*(wF+1+wS)-(wS-((nPProd-1) mod wS)-1)-1 downto 0);

  signal psum1_10 : std_logic_vector(wF+k1 downto 0);
  signal psum1_11 : std_logic_vector(wF+k1 downto 0);
  signal psum2_10 : std_logic_vector(wF+k2 downto 0);
  signal psum2_11 : std_logic_vector(wF+k2 downto 0);

  signal sum_10 : std_logic_vector(wF+nPProd downto 0);
  signal sum_11 : std_logic_vector(wF+nPProd downto 0);
begin
  pprod_1 <= pprod;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  
  leaf : if depth = 0 and nPProd <= wS generate
    sum_10 <= pprod_1(wF+nPProd downto 0);
    sum_11 <= sum_10;
  end generate;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  
  buff : if depth > 0 and nPProd <= wS*2**(depth-1) generate
    partial_sum : FPMul_AddTree_Clk
      generic map ( wF  => wF,
                    nPProd => nPProd,
                    wS     => wS,
                    depth  => depth-1 )
      port map ( pprod => pprod_1, ---------------------------------------------
                 sum   => sum_10, ----------------------------------------------
                 clk   => clk );

    reg : if depth-regOffset >= 0 and (depth-regOffset) mod regPeriod = 0 generate
      process(clk)
      begin
        if clk'event and clk='1' then
          sum_11 <= sum_10;
        end if;
      end process;
    end generate;
    noreg : if depth-regOffset < 0 or (depth-regOffset) mod regPeriod /= 0 generate
      sum_11 <= sum_10;
    end generate;
    
--------------------------------------------------------------------------------
    
  end generate;
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  
  node : if depth > 0 and nPProd > wS*2**(depth-1) generate
    partial_sum1 : FPMul_AddTree_Clk
      generic map ( wF  => wF,
                    nPProd => k1,
                    wS     => wS,
                    depth  => depth-1 )
      port map ( pprod => pprod_1((k1/wS)*(wF+1+wS)-1 downto 0), ------------
                 sum   => psum1_10, --------------------------------------------
                 clk   => clk );

    partial_sum2 : FPMul_AddTree_Clk
      generic map ( wF  => wF,
                    nPProd => k2,
                    wS     => wS,
                    depth  => depth-1 )
      port map ( pprod => pprod_1(((nPProd+wS-1)/wS)*(wF+1+wS)-(wS-((nPProd-1) mod wS)-1)-1 downto (k1/wS)*(wF+1+wS)),
                 sum   => psum2_10, --------------------------------------------
                 clk   => clk ); -----------------------------------------------

    reg : if depth-regOffset >= 0 and (depth-regOffset) mod regPeriod = 0 generate
      process(clk)
      begin
        if clk'event and clk='1' then
          psum1_11 <= psum1_10;
          psum2_11 <= psum2_10;
        end if;
      end process;
    end generate;
    noreg : if depth-regOffset < 0 or (depth-regOffset) mod regPeriod /= 0 generate
      psum1_11 <= psum1_10;
      psum2_11 <= psum2_10;
    end generate;

--------------------------------------------------------------------------------
    
    sum_11(k1-1 downto 0) <= psum1_11(k1-1 downto 0);
    sum_11(wF+nPProd downto k1) <= ((k2 downto 1 => '0') & psum1_11(wF+k1 downto k1)) + psum2_11;
  end generate;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  
  sum <= sum_11;
end architecture;
