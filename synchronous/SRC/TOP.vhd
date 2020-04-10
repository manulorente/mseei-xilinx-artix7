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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Generic (
    -- Valor maximo de la cuenta del contador FREE-RUNNING = 2^26 a 50MHz (MCLK) para que el digito cambie cada segundo
    N : NATURAL := 67108864
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
    signal r_reg: NATURAL range 0 to N-1;
    signal A, B, C, D, Q: STD_LOGIC_VECTOR(3 downto 0);
    signal MRST, CEN, reset_in, MCLK, locked: STD_LOGIC;
    signal AUX : STD_LOGIC_VECTOR (3 downto 0);
    alias SSEG: STD_LOGIC_VECTOR(6 downto 0) is CAT(6 downto 0);
begin
    -- Módulo MMCM
    MMCM0: entity WORK.clk_wiz_0
    port map (
        clk_in1     => CLK,
        reset       => reset_in,
        clk_out1    => MCLK,
        locked      => locked
    );
    -- Contador binario
    BCD: entity WORK.CD4RE
    port map (
    	-- Señal de reloj viene a 50MHz del bloque MMCM
        C   => MCLK,
        R   => MRST,
        CE  => CEN,
        Q   => Q,
        TC  => open,
        CEO => open
    );
      
    -- Proceso síncrono para la cuenta Free running
    FREERUNNING_COUNT: process(MCLK)
    begin
        if (MCLK'event and MCLK='1') then
            if r_reg = N then
                r_reg <= 0;
            else
                r_reg <= r_reg + 1;
            end if;
        end if;
    end process;

    -- Asignamos botones a señal auxiliar    
    MUX: process (BTN, A, B, C, D) is
       begin
         case BTN(4 downto 1) is
           when "0001" => AUX <= A;
           when "0010" => AUX <= B;
           when "0100" => AUX <= C;
           when others => AUX <= D;
         end case;
    end process;
           
    -- Implementamos tabla de la verdad del convertidor
	HEX7SEG: process(AUX)
		begin 
			case AUX is 
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
	
	-- Reset del MMCM
	reset_in <= BTN(0);
	
	-- señal LOCKED visualizada en el punto del display
	CAT(7) <= not locked;
	
  	-- Apagamos todos los leds
    LED <= (others => '0');
    
    -- Anodos del display controlados por botones
    AN <= not(BTN(4 downto 1));
    
    -- Reset del contador BCD controlado por locked del MMCM
    MRST <= not locked;

    -- Señal que se activa durante un ciclo cada vez que el free running satura
    CEN   <= '1' when r_reg = N else '0';
    
   -- Entrada del multiplexor
    A <= (others => '0');
    B <= (others => '0');
    C <= Q;
    D <= SW(15 downto 12);
       
end BEHAVIORAL;
