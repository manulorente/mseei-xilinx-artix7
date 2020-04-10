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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Generic (
    --vector size
    N : NATURAL := 26 
    );
    Port (
    -- Clock Input 100MHz
    CLK : in STD_LOGIC;
    SW  : in STD_LOGIC_VECTOR (15 downto 0);
    BTN : in STD_LOGIC_VECTOR (4 downto 0);
    LED : out STD_LOGIC_VECTOR (15 downto 0);
    CAT : out STD_LOGIC_VECTOR (7 downto 0);
    AN  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end TOP;

architecture BEHAVIORAL of TOP is
    -- Vector declaration for counter
    signal r_reg, r_next: unsigned(N-1 downto 0);
    signal A, B, C, D, Q: STD_LOGIC_VECTOR(3 downto 0);
    signal RST, CE, CEN: STD_LOGIC;
    signal AUX : STD_LOGIC_VECTOR (3 downto 0);
    alias SSEG: STD_LOGIC_VECTOR(7 downto 0) is CAT(7 downto 0);
begin
    -- Contador binario
    U0: entity WORK.CD4RE
    port map (
    	-- Señal de reloj es el bit de mayor peso del contador free-running
        C   => r_reg(N-1),
        R   => RST,
        CE  => CEN,
        Q   => Q,
        TC  => open,
        CEO => open
    );
      
    -- Proceso síncrono para la cuenta Free running
    cont: process(CLK)
    begin
        if (CLK'event and CLK='1') then
            r_reg <= r_reg + 1;
        end if;
    end process;

    -- Asignamos botones a señal auxiliar    
    mux: process (BTN, A, B, C, D) is
       begin
         case BTN(4 downto 1) is
           when "0001" => AUX <= A;
           when "0010" => AUX <= B;
           when "0100" => AUX <= C;
           when others => AUX <= D;
         end case;
    end process;
           
    -- Implementamos tabla de la verdad del convertidor
	tabla: process(AUX)
		begin 
			case AUX is 
				when "0000"=> SSEG  <= "11000000"; -- '0'
				when "0001"=> SSEG  <= "11111001"; -- '1' 
				when "0010"=> SSEG  <= "10100100"; -- '2' 
				when "0011"=> SSEG  <= "10110000"; -- '3' 
				when "0100"=> SSEG  <= "10011001"; -- '4' 
				when "0101"=> SSEG  <= "10010010"; -- '5' 
				when "0110"=> SSEG  <= "10000010"; -- '6' 
				when "0111"=> SSEG  <= "11111000"; -- '7' 
				when "1000"=> SSEG  <= "10000000"; -- '8' 
				when "1001"=> SSEG  <= "10010000"; -- '9' 
				when "1010"=> SSEG  <= "10001000"; -- 'a'
				when "1011"=> SSEG  <= "10000011"; -- 'b'
				when "1100"=> SSEG  <= "11000110"; -- 'c'
				when "1101"=> SSEG  <= "10100001"; -- 'd'
				when "1110"=> SSEG  <= "10000110"; -- 'e'
				when "1111"=> SSEG  <= "10001110"; -- 'f'				
				when others=> SSEG  <= "11111111"; -- todo apagado por efecto
			end case; 
	end process;
	
  	-- Conectamos los 16MSb del contador a los LED
    LED <= std_logic_vector(r_reg(N-1 downto N-16));
    
    -- Anodos del display controlados por botones
    AN <= not(BTN(4 downto 1));
    
    -- SW(0) conectado al terminal de Reset
    RST   <= SW(0);

    -- SW(1) conectado al terminal de habilitación
    CEN   <= SW(1);
    
   -- Asignación del contador al Mux
        -- 4MSb a la entrada del MUX para AN1
        -- 4 siguientes MSb a la entrada del MUX para AN0
        -- Salida Q conectada a la entrada del MUX para AN2
        -- 4 ultimas palancas controlan la otra entrada del MUX PARA AN3
    A <= std_logic_vector(r_reg(N-5 downto N-8));
    B <= std_logic_vector(r_reg(N-1 downto N-4));
    C <= Q;
    D <= SW(15 downto 12);
       
end BEHAVIORAL;
