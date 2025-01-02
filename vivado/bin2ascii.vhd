----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2024 06:04:28 PM
-- Design Name: 
-- Module Name: bin2ascii - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin2ascii is
    Port ( bin  : in    std_logic_vector (7 downto 0);
           char : out   STD_LOGIC_VECTOR (7 downto 0)   );
end bin2ascii;

architecture Behavioral of bin2ascii is
begin
    char <= std_logic_vector(unsigned(bin) + 48);
end Behavioral;
