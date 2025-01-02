----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2024 03:30:14 PM
-- Design Name: 
-- Module Name: tx_helper - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx_helper is
    Port (  slw_clk     : in std_logic;
            rst         : in std_logic; 
            xmitmt      : in STD_LOGIC;
            shift_load  : out STD_LOGIC);
end tx_helper;

architecture Behavioral of tx_helper is
signal sending          : std_logic := '0';

begin
    process(slw_clk,rst)
    begin
        
        if (rst = '1') then
            sending         <= '0';
            
        elsif (rising_edge (slw_clk) ) then
            if (sending = '0') then
                sending         <= '1';
         
            elsif ( xmitmt = '1' ) then
                sending         <= '0';
                
            end if;
        end if;
    end process;
    
    shift_load <= sending;
    
end Behavioral;
