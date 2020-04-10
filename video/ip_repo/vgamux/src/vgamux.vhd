----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2016 16:56:39
-- Design Name: 
-- Module Name: vgamux - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vgamux is
    Port ( clk      : in STD_LOGIC;
           sel      : in STD_LOGIC;
           vid_data : in STD_LOGIC_VECTOR (23 downto 0);
           vid_hs   : in STD_LOGIC;
           vid_vs   : in STD_LOGIC;
           rgb_data : in STD_LOGIC_VECTOR (23 downto 0);
           hsin     : in STD_LOGIC;
           vsin     : in STD_LOGIC;
           vgaRed   : out STD_LOGIC_VECTOR (7 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (7 downto 0);
           vgaBlue  : out STD_LOGIC_VECTOR (7 downto 0);
           Hsync    : out STD_LOGIC;
           Vsync    : out STD_LOGIC
   );
end vgamux;

architecture Behavioral of vgamux is

begin
process
begin
  wait until rising_edge(clk);
  if sel = '0' then
    vgaRed   <= vid_data(23 downto 16);
    vgaBlue  <= vid_data(15 downto  8);
    vgaGreen <= vid_data( 7 downto  0);
    Hsync    <= vid_hs;
    Vsync    <= vid_vs;
  else
    vgaRed   <= rgb_data(23 downto 16);
    vgaGreen <= rgb_data(15 downto  8);
    vgaBlue  <= rgb_data( 7 downto  0);
    Hsync    <= hsin;
    Vsync    <= vsin;
  end if;
end process;

end Behavioral;
