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

entity FPMul_Product_Clk is
  generic ( wF : positive );
  port ( fA  : in  std_logic_vector(wF downto 0);
         fB  : in  std_logic_vector(wF downto 0);
         fR  : out std_logic_vector(2*wF+1 downto 0);
         clk : in  std_logic );
end entity;

architecture arch of FPMul_Product_Clk is
  constant wS : positive := wSlice;
  
  signal fA_1 : std_logic_vector(wF downto 0);
  signal fB_1 : std_logic_vector(wF downto 0);

  signal pprod_1 : std_logic_vector(((wF+wS)/wS)*(wF+1+wS)-(wS-(wF mod wS)-1)-1 downto 0);

  signal fR_10 : std_logic_vector(2*wF+1 downto 0);
begin
  fA_1 <= fA;
  fB_1 <= fB;

  partial_prod : for i in 0 to (wF+wS)/wS-1 generate
    prod_normal : if wS*(i+1)-1 <= wF generate
      pprod_1((i+1)*(wF+1+wS)-1 downto i*(wF+1+wS)) <= fA_1 * fB_1(wS*(i+1)-1 downto wS*i);
    end generate;
    prod_last : if wS*(i+1)-1 > wF generate
      pprod_1((i+1)*(wF+1+wS)-(wS-(wF mod wS)-1)-1 downto i*(wF+1+wS)) <= fA_1 * fB_1(wF downto wS*i);
    end generate;
  end generate;

  add_tree : FPMul_AddTree_Clk
    generic map ( wF  => wF,
                  nPProd => wF+1,
                  wS     => wS,
                  depth  => log(wF)+1 - log(wS) )
    port map ( pprod => pprod_1, -----------------------------------------------
               sum   => fR_10, -------------------------------------------------
               clk   => clk );

  fR <= fR_10;
end architecture;
