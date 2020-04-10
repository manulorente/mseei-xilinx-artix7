----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Manuel Lorente Alman - 77844874V
-- 
-- Create Date: 15.01.2020 21:58:48
-- Design Name: 
-- Module Name: TOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: HEX7SEG conversor with comb processes
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
    Port (
    CLK : in STD_LOGIC; 
    SW  : in STD_LOGIC_VECTOR (15 downto 0);    
    CAT : out STD_LOGIC_VECTOR (7 downto 0);
    AN  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end TOP;

architecture BEHAVIORAL of TOP is
    signal DDi : STD_LOGIC_VECTOR (15 downto 0);
begin
    -- Cada grupo de 4 palancas consecutivas controlan un dígito del display
    DDi <= SW;
    
    Disp: entity WORK.DISPLAY
    Generic Map (N => 21) -- N debe estar entre 16 y 21 para una correcta visualización periodica
    Port Map(
        C   => CLK,
        DD  => DDi,
        CAT => CAT,
        AN  => AN
     );

end BEHAVIORAL;
