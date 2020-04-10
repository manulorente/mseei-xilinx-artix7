----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:59:15 07/04/2015 
-- Design Name: 
-- Module Name:    simbolo_out - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simbolo_out is
	   generic(	width_bus_dir_out:integer:=8;
					length_bus_dir_out: integer:=8);
		 Port ( 	clk : in  std_logic;
					reset : in std_logic;
					diff: in std_logic_vector(2 downto 0);--simbolo untilizado para realizar los calculos del mapper
					modulacion : in  std_logic_vector(2 downto 0);
					enable : in std_logic;
					ack_mapper: out std_logic;
					reals: out std_logic_vector (width_bus_dir_out-1 downto 0);--salida real
					imags: out std_logic_vector(width_bus_dir_out-1 downto 0));--salida imaginaria
end simbolo_out;

architecture Behavioral of simbolo_out is

signal real_aux, imag_aux: std_logic_vector(width_bus_dir_out-1 downto 0);
signal pulse_cont: std_logic;

begin

	sinc:process(clk,reset)
		begin
			if(reset='1') then
				reals<=(others =>'0');
				imags<=(others =>'0');
				ack_mapper<='0';
			elsif(rising_edge(clk)) then
				reals <= real_aux;
				imags <= imag_aux;
		-- Incrementamos puntero a memoria si el dato es válido
				ack_mapper<=pulse_cont;
			end if;
	end process; 

	comb:process(enable,modulacion,diff)
	begin
		real_aux<=(others =>'0');
		imag_aux<=(others =>'0');
-- Por convenio: 1="01100100"	-1="10011100"	0.707="01000111"	-0.707="10111001"
--realizamos las asignaciones
--en este bloque hemos realizado la "traduccion de simbolo interno para realizar los calculos a los simbolos necesarios de entrada de la ifft"
			if enable='1' then
				if (modulacion(2)='1') then 
					case diff is
						when "000" =>
							real_aux<= "01100100";
							imag_aux<= (others =>'0');
							pulse_cont<='1';
						when "001" =>
							real_aux<= "01000111";
							imag_aux<= "01000111";
							pulse_cont<='1';
						when "011" =>
							real_aux<= (others =>'0');
							imag_aux<= "01100100";
							pulse_cont<='1';
						when "010" =>
							real_aux<= "10111001";
							imag_aux<= "01000111";
							pulse_cont<='1';
						when "110" =>
							real_aux<= "10011100";
							imag_aux<= (others =>'0');
							pulse_cont<='1';
						when "111" =>
							real_aux<= "10111001";
							imag_aux<= "10111001";
							pulse_cont<='1';
						when "101" =>
							real_aux<= (others =>'0');
							imag_aux<= "10011100";
							pulse_cont<='1';
						when "100" =>
							real_aux<= "01000111";
							imag_aux<= "10111001";
							pulse_cont<='1';
						when others =>
							real_aux<=(others =>'0');
							imag_aux<=(others =>'0');
							pulse_cont<='0';
					end case;

				elsif (modulacion(1)='1') then 
					case diff is
						when "000" =>
							real_aux<= "01100100";
							imag_aux<= (others =>'0');
							pulse_cont<='1';
						when "001" =>
							real_aux<= "01000111";
							imag_aux<= "01000111";
							pulse_cont<='1';
						when "011" =>
							real_aux<= (others =>'0');
							imag_aux<= "01100100";
							pulse_cont<='1';
						when "010" =>
							real_aux<= "10111001";
							imag_aux<= "01000111";
							pulse_cont<='1';
						when others =>
							real_aux<=(others =>'0');
							imag_aux<=(others =>'0');
							pulse_cont<='0';
					end case;

				elsif (modulacion(0)='1') then
					case diff is
						when "000" =>
							real_aux<= "01100100";
							imag_aux<= (others =>'0');
							pulse_cont<='1';
						when "001" =>
							real_aux<= "10011100";
							imag_aux<= (others =>'0');
							pulse_cont<='1';
						when others =>
							real_aux<=(others =>'0');
							imag_aux<=(others =>'0');
							pulse_cont<='0';
					end case;

				end if;
			end if;
	end process;

end Behavioral;




