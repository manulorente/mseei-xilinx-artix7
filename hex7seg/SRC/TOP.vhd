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
    SW : in STD_LOGIC_VECTOR (15 downto 0);
    BTN : in STD_LOGIC_VECTOR (4 downto 0);
    CAT : out STD_LOGIC_VECTOR (7 downto 0);
    AN : out STD_LOGIC_VECTOR (3 downto 0)
    );
end TOP;

architecture BEHAVIORAL of TOP is
    alias A: STD_LOGIC_VECTOR (3 downto 0) is SW(3 downto 0);
    alias B: STD_LOGIC_VECTOR (3 downto 0) is SW(7 downto 4);
    alias C: STD_LOGIC_VECTOR (3 downto 0) is SW(11 downto 8);
    alias D: STD_LOGIC_VECTOR (3 downto 0) is SW(15 downto 12);

    signal SEG : STD_LOGIC_VECTOR (6 downto 0);
    signal AUX : STD_LOGIC_VECTOR (3 downto 0);
begin
    -- Anodos del display controlados por botones
    AN <= not(BTN(3 downto 0));
    
	-- Asignamos señal interna al puerto de salida y el punto decimal apagado
    CAT <= '1' & SEG;
 
    -- Asignamos botones a señal auxiliar    
    mux: process (BTN, A, B, C, D) is
       begin
         case BTN is
           when "00001" => AUX <= A;
           when "00010" => AUX <= B;
           when "00100" => AUX <= C;
           when others => AUX <= D;
         end case;
    end process;
    
    -- Implementamos tabla de la verdad del convertidor
	tabla: process(AUX)
		begin 
			case AUX is 
				when "0000"=> SEG  <= "1000000"; -- '0'
				when "0001"=> SEG  <= "1111001"; -- '1' 
				when "0010"=> SEG  <= "0100100"; -- '2' 
				when "0011"=> SEG  <= "0110000"; -- '3' 
				when "0100"=> SEG  <= "0011001"; -- '4' 
				when "0101"=> SEG  <= "0010010"; -- '5' 
				when "0110"=> SEG  <= "0000010"; -- '6' 
				when "0111"=> SEG  <= "1111000"; -- '7' 
				when "1000"=> SEG  <= "0000000"; -- '8' 
				when "1001"=> SEG  <= "0010000"; -- '9' 
				when "1010"=> SEG  <= "0001000"; -- 'a'
				when "1011"=> SEG  <= "0000011"; -- 'b'
				when "1100"=> SEG  <= "1000110"; -- 'c'
				when "1101"=> SEG  <= "0100001"; -- 'd'
				when "1110"=> SEG  <= "0000110"; -- 'e'
				when "1111"=> SEG  <= "0001110"; -- 'f'				
				when others=> SEG  <= "1111111"; -- todo apagado por efecto
			end case; 
	end process;
    
end BEHAVIORAL;
