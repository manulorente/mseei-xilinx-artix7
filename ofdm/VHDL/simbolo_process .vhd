----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:54:48 07/05/2015 
-- Design Name: 
-- Module Name:    simbolo_process - Behavioral 
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


entity simbolo_process is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
	   enable: in std_logic;
           modulacion : in  STD_LOGIC_VECTOR (2 downto 0);
           psimb : in  STD_LOGIC_VECTOR (2 downto 0);--proximo simbolo
           simb : out  STD_LOGIC_VECTOR (2 downto 0));--simbolo procesado que sacamos
end simbolo_process;

architecture Behavioral of simbolo_process is

type estado is (reposo, generando);
signal estado_actual,estado_nuevo: estado;
signal simbolo_old,simbolo_new: std_logic_vector(2 downto 0);

begin

	sinc:process(clk,reset,modulacion)
		begin
			if(reset='1') then
				simb<=(others =>'0');
				simbolo_old<=(others =>'0');	
				estado_actual<=reposo;
			elsif(rising_edge(clk)) then
		-- Actualizamos símbolo enviado y lo almacenamos para el siguiente cálculo
				simb <= simbolo_new;
				simbolo_old<=simbolo_new;
				estado_actual<=estado_nuevo;
			end if;
			
	end process;
	
	comb:process(psimb,enable,estado_actual,modulacion, simbolo_old)
	begin
	-- Inicializamos las signals para evitar latches
		simbolo_new<=(others =>'0');
		case estado_Actual is
			when reposo =>--este estado lo utilizamos para la precarga del sistema, es decir elprimer simbolo con el que se compara
				if modulacion(2)='1' then
					simbolo_new<="110";
					estado_nuevo<=generando;
				elsif modulacion(1)='1' then
					simbolo_new<="011";
					estado_nuevo<=generando;
				elsif modulacion(0)='1' then
					simbolo_new<="001";
					estado_nuevo<=generando;
				else
					simbolo_new<=(others=>'0');
					estado_nuevo<=estado_actual;
				end if;
			when generando =>--en este estado realizamos la comparacion de los simbolos y asignamos el valor simbolo_new que 
					 --va conectado a la salida, para ello guardamos el dato de entrada en simbolo_new, y el simbolo_new anterior
					 --va conectado a simbolo_old y con estos dos datos se realiza la rutina
					if (enable='1') then
							if (modulacion(2)='1') then
								estado_nuevo<=estado_actual;
										case simbolo_old is
											when "110" =>
												case psimb is
													when "000" =>
														simbolo_new<="110";
													when "001" =>
														simbolo_new<="111";
													when "011" =>
														simbolo_new<="101";
													when "010" =>
														simbolo_new<="100";
													when "110" =>
														simbolo_new<="000";
													when "111" =>
														simbolo_new<="001";
													when "101" =>
														simbolo_new<="011";
													when others =>
														simbolo_new<="010";
												end case;
											when "111" =>
												case psimb is
													when "000" =>
														simbolo_new<="010";
													when "001" =>
														simbolo_new<="110";
													when "011" =>
														simbolo_new<="111";
													when "010" =>
														simbolo_new<="101";
													when "110" =>
														simbolo_new<="100";
													when "111" =>
														simbolo_new<="000";
													when "101" =>
														simbolo_new<="001";
													when others =>
														simbolo_new<="011";
												end case;
											when "101" =>
												case psimb is
													when "000" =>
														simbolo_new<="011";
													when "001" =>
														simbolo_new<="010";
													when "011" =>
														simbolo_new<="110";
													when "010" =>
														simbolo_new<="111";
													when "110" =>
														simbolo_new<="101";
													when "111" =>
														simbolo_new<="100";
													when "101" =>
														simbolo_new<="000";
													when others =>
														simbolo_new<="001";
												end case;
											when "100" =>
												case psimb is
													when "000" =>
														simbolo_new<="001";
													when "001" =>
														simbolo_new<="011";
													when "011" =>
														simbolo_new<="010";
													when "010" =>
														simbolo_new<="110";
													when "110" =>
														simbolo_new<="111";
													when "111" =>
														simbolo_new<="101";
													when "101" =>
														simbolo_new<="100";
													when others =>
														simbolo_new<="000";
												end case;
											when "000" =>
												case psimb is
													when "000" =>
														simbolo_new<="000";
													when "001" =>
														simbolo_new<="001";
													when "011" =>
														simbolo_new<="011";
													when "010" =>
														simbolo_new<="010";
													when "110" =>
														simbolo_new<="110";
													when "111" =>
														simbolo_new<="111";
													when "101" =>
														simbolo_new<="101";
													when others =>
														simbolo_new<="100";
												end case;
											when "001" =>
												case psimb is
													when "000" =>
														simbolo_new<="100";
													when "001" =>
														simbolo_new<="000";
													when "011" =>
														simbolo_new<="001";
													when "010" =>
														simbolo_new<="011";
													when "110" =>
														simbolo_new<="010";
													when "111" =>
														simbolo_new<="110";
													when "101" =>
														simbolo_new<="111";
													when others =>
														simbolo_new<="101";
												end case;
											when "011" =>
												case psimb is
													when "000" =>
														simbolo_new<="101";
													when "001" =>
														simbolo_new<="100";
													when "011" =>
														simbolo_new<="000";
													when "010" =>
														simbolo_new<="001";
													when "110" =>
														simbolo_new<="011";
													when "111" =>
														simbolo_new<="010";
													when "101" =>
														simbolo_new<="110";
													when others =>
														simbolo_new<="111";
												end case;
											when others =>
												case psimb is
													when "000" =>
														simbolo_new<="111";
													when "001" =>
														simbolo_new<="101";
													when "011" =>
														simbolo_new<="100";
													when "010" =>
														simbolo_new<="000";
													when "110" =>
														simbolo_new<="001";
													when "111" =>
														simbolo_new<="011";
													when "101" =>
														simbolo_new<="010";
													when others =>
														simbolo_new<="110";
												end case;
											end case;
							elsif (modulacion(1)='1') then
								estado_nuevo<=estado_actual;
									case simbolo_old is
												when "010" =>
													case psimb is
														when "000" =>
															simbolo_new<="001";
														when "001" =>
															simbolo_new<="011";
														when "011" =>
															simbolo_new<="010";
														when others =>
															simbolo_new<="000";
													end case;
												when "000" =>
													case psimb is
														when "000" =>
															simbolo_new<="000";
														when "001" =>
															simbolo_new<="001";
														when "011" =>
															simbolo_new<="011";
														when others =>
															simbolo_new<="010";
													end case;
												when "001" =>
													case psimb is
														when "000" =>
															simbolo_new<="010";
														when "001" =>
															simbolo_new<="000";
														when "011" =>
															simbolo_new<="001";
														when others =>
															simbolo_new<="011";
													end case;
												when others =>
													case psimb is
														when "000" =>
															simbolo_new<="011";
														when "001" =>
															simbolo_new<="010";
														when "011" =>
															simbolo_new<="000";
														when others =>
															simbolo_new<="001";
													end case;
									end case;
							elsif (modulacion(0)='1') then 
								estado_nuevo<=estado_actual;
										case simbolo_old is
													when "000" =>
														case psimb is
															when "000" =>
																simbolo_new<="000";
															when others =>
																simbolo_new<="001";
														end case;
													when others =>
														case psimb is
															when "000" =>
																	simbolo_new<="001";
															when others =>
																	simbolo_new<="000";
														end case;
										end case;
							end if;
					else
						estado_nuevo<=reposo;
					end if;
		end case;
	end process;

end Behavioral;


