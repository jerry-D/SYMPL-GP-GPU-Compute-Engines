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

entity Delay is
  generic ( w : positive := 1;
            n : natural );
  port ( input  : in  std_logic_vector(w-1 downto 0);
         output : out std_logic_vector(w-1 downto 0);
         clk    : in  std_logic );
end entity;

architecture arch of Delay is
  component Delay is
    generic ( w : positive := 1;
              n : natural );
    port ( input  : in  std_logic_vector(w-1 downto 0);
           output : out std_logic_vector(w-1 downto 0);
           clk    : in  std_logic );
  end component;

  signal val_1  : std_logic_vector(w-1 downto 0);
  signal val_2  : std_logic_vector(w-1 downto 0);
  signal val_10 : std_logic_vector(w-1 downto 0);
begin
  val_1 <= input;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

  noreg : if n = 0 generate
    val_2  <= val_1;
    val_10 <= val_2;
  end generate;
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

  reg : if n > 0 generate
    process(clk)
    begin
      if clk'event and clk='1' then
        val_2 <= val_1;
      end if;
    end process;

--------------------------------------------------------------------------------

    val_delay : Delay
      generic map ( w => w,
                    n => n-1 )
      port map ( input  => val_2, ----------------------------------------------
                 output => val_10, ---------------------------------------------
                 clk    => clk );
  end generate;                            
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

  output <= val_10;
end architecture;
