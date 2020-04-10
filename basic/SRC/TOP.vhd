----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Manuel Lorente Alman - 77844874V
-- 
-- Create Date: 12.01.2020 21:58:48
-- Design Name: 
-- Module Name: TOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: M14 ejemplo inicial de la asignatura
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

entity TOP is
    Port ( SW : in STD_LOGIC_VECTOR (15 downto 0);
           BTN : in STD_LOGIC_VECTOR (4 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           CAT : out STD_LOGIC_VECTOR (7 downto 0);
           AN : out STD_LOGIC_VECTOR (3 downto 0));
end TOP;

architecture Behavioral of TOP is

begin
-- Leds 11 a 15 controlados por botones
    LED(15 downto 11) <= BTN;
-- Leds 0 a 11 controlados por palancas
    LED(10 downto 0) <= SW(10 downto 0);
-- Catodos del display controlados por palancas
    CAT <= SW(7 downto 0);
-- Anodos del display controlados por botones
    AN <= BTN(4 downto 1);

end Behavioral;
