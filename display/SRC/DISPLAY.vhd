----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Manuel Lorente Alman - 77844874V
-- 
-- Create Date: 19.01.2020 01:48:38
-- Design Name: 
-- Module Name: DISPLAY - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;    -- Síntesis.   [Xilinx]. Operador de suma '+'

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DISPLAY is
    Generic (
    -- Valor maximo de la cuenta del contador FREE-RUNNING
    N : INTEGER := 18
    );
    Port ( 
        C : in STD_LOGIC;                           -- CLK=100MHz
        DD : in STD_LOGIC_VECTOR (15 downto 0);     -- 4x4 nibbles que vamos a visualizar en el display
        CAT : out STD_LOGIC_VECTOR (7 downto 0);    -- CAT(7)=DP, CAT(6)=CG, ..., CAT(0)=CA
        AN : out STD_LOGIC_VECTOR (3 downto 0)      -- AN(3)=izda, ..., AN(0)=dcha
   );
end DISPLAY;

architecture Behavioral of DISPLAY is
    -- Señales internas
    signal Q_reg, Q_next: STD_LOGIC_VECTOR(N-1 downto 0);
    signal SSEG: STD_LOGIC_VECTOR(6 downto 0);
    signal HEX: STD_LOGIC_VECTOR(3 downto 0);
    signal SEL: STD_LOGIC_VECTOR(1 downto 0);
    signal DOT: STD_LOGIC;
    
    -- Alias de entradas
    alias Hin3 is DD(15 downto 12);
    alias Hin2 is DD(11 downto 8);
    alias Hin1 is DD(7 downto 4);
    alias Hin0 is DD(3 downto 0);
begin

    -- Modelamos tabla de la verdad del convertidor
	HEX7LED: process(HEX)
		begin 
			case HEX is 
				when "0000"=> SSEG  <= "1000000"; -- '0'
				when "0001"=> SSEG  <= "1111001"; -- '1' 
				when "0010"=> SSEG  <= "0100100"; -- '2' 
				when "0011"=> SSEG  <= "0110000"; -- '3' 
				when "0100"=> SSEG  <= "0011001"; -- '4' 
				when "0101"=> SSEG  <= "0010010"; -- '5' 
				when "0110"=> SSEG  <= "0000010"; -- '6' 
				when "0111"=> SSEG  <= "1111000"; -- '7' 
				when "1000"=> SSEG  <= "0000000"; -- '8' 
				when "1001"=> SSEG  <= "0010000"; -- '9' 
				when "1010"=> SSEG  <= "0001000"; -- 'a'
				when "1011"=> SSEG  <= "0000011"; -- 'b'
				when "1100"=> SSEG  <= "1000110"; -- 'c'
				when "1101"=> SSEG  <= "0100001"; -- 'd'
				when "1110"=> SSEG  <= "0000110"; -- 'e'
				when "1111"=> SSEG  <= "0001110"; -- 'f'				
				when others=> SSEG  <= "1111111"; -- todo apagado por efecto
			end case; 
	end process;
	
    -- Modelamos multiplexor de 4 a 1  
    MUX41: process (SEL, Hin0, Hin1, Hin2, Hin3) is
       begin
         case SEL is
           when "00"    => HEX <= Hin0;
           when "01"    => HEX <= Hin1;
           when "10"    => HEX <= Hin2;
           when others  => HEX <= Hin3;
         end case;
    end process;
    
    -- Modelamos el decodificador 2 a 4   
    DECOD24: process (SEL) is
       begin
         case SEL is
           when "00"    => AN <= "1110";
           when "01"    => AN <= "1101";
           when "10"    => AN <= "1011";
           when others  => AN <= "0111";
         end case;
    end process;
    
    -- Proceso síncrono para registrar la cuenta Free Running
    FREERUNNING_COUNT: process(C)
    begin
        if (C'event and C='1') then
            Q_next <= Q_next + 1;
        end if;
    end process;
        
    -- Actualizamos la cuenta Free Running
    Q_reg <= Q_next;
    
    -- La señal SEL irá iterando de forma continuada e indefinida asociada a la cuenta
    SEL <= Q_reg(N-1 downto N-2);
    
    -- Dejamos los puntos del display apagados
    DOT <= '1';
    
    -- Lógica de salida
    CAT <= DOT & SSEG;
    
end Behavioral;
