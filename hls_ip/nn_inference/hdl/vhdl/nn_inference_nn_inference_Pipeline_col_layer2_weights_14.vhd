-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity nn_inference_nn_inference_Pipeline_col_layer2_weights_14 is 
    generic(
             DataWidth     : integer := 32; 
             AddressWidth     : integer := 4; 
             AddressRange    : integer := 16
    ); 
    port (
          address0      : in std_logic_vector(AddressWidth-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DataWidth-1 downto 0);
          reset     : in std_logic;
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of nn_inference_nn_inference_Pipeline_col_layer2_weights_14 is 

signal address0_tmp : std_logic_vector(AddressWidth-1 downto 0); 
type mem_array is array (0 to AddressRange-1) of std_logic_vector (DataWidth-1 downto 0); 
signal mem : mem_array := (
    0 => "10111110011101010110000101001100", 
    1 => "00111101111110011110110001110110", 
    2 => "10111110011101111100100111010010", 
    3 => "00111111001010101000010011001110", 
    4 => "00111111011101001010111111001100", 
    5 => "00111111000010011000100110101101", 
    6 => "10111110011001010111001000100000", 
    7 => "00111110100011011001001110101011", 
    8 => "10111111000001110100101011011110", 
    9 => "00111111001001110011001000011110", 
    10 => "10111111000001100111011100000100", 
    11 => "00111110001001010011010011010100", 
    12 => "00111111000000000111100010010110", 
    13 => "00111110111001000100110101111011", 
    14 => "00111110100001110100010111010101", 
    15 => "00111111011000101101111011011111" );


begin 


memory_access_guard_0: process (address0) 
begin
      address0_tmp <= address0;
--synthesis translate_off
      if (CONV_INTEGER(address0) > AddressRange-1) then
           address0_tmp <= (others => '0');
      else 
           address0_tmp <= address0;
      end if;
--synthesis translate_on
end process;

p_rom_access: process (clk)  
begin 
    if (clk'event and clk = '1') then
        if (ce0 = '1') then 
            q0 <= mem(CONV_INTEGER(address0_tmp)); 
        end if;
    end if;
end process;

end rtl;
