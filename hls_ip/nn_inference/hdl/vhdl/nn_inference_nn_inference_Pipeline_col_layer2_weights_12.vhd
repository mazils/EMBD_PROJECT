-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity nn_inference_nn_inference_Pipeline_col_layer2_weights_12 is 
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


architecture rtl of nn_inference_nn_inference_Pipeline_col_layer2_weights_12 is 

signal address0_tmp : std_logic_vector(AddressWidth-1 downto 0); 
type mem_array is array (0 to AddressRange-1) of std_logic_vector (DataWidth-1 downto 0); 
signal mem : mem_array := (
    0 => "10111110000110100000110011001001", 
    1 => "00111111100011111111011110011010", 
    2 => "00111111000100000010010100011111", 
    3 => "10111111010100010111101110000111", 
    4 => "10111101101010000010101111011100", 
    5 => "00111111011111010100000110100110", 
    6 => "00111111000011010001110010011101", 
    7 => "00111110101110111000001111100100", 
    8 => "10111101100110000100101101110010", 
    9 => "10111111011110101101111110100101", 
    10 => "10111111001101000110101001110101", 
    11 => "10111110101111001010001011011110", 
    12 => "10111110101110111100001000110010", 
    13 => "00111110011110010000110000100100", 
    14 => "00111100111000010011001001011100", 
    15 => "10111111010001100000001111001101" );


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

