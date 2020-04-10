----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:48:12 04/26/2015 
-- Design Name: 
-- Module Name:    Interleaver - Interleaver_arch 
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
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Interleaver is
    Port ( CLK : in  STD_LOGIC;
           RESET: in STD_LOGIC;
			  DATO_SC : in  STD_LOGIC;--dato de entrada desde el scrambler
          modulacion : in  STD_LOGIC_VECTOR (2 downto 0);--modulacion seleccionada
--			  SD : out STD_LOGIC;--aviso a bloques anteriores para que envien otra tanda de datos
           ENABLE : in  STD_LOGIC;--habilita los datos de entrada
	        DIR_RAM : out  STD_LOGIC_VECTOR (8 downto 0); --Para que llegue a todos los tipos de modulaciones
			  W_R : out STD_LOGIC_VECTOR (0 downto 0);--para poder leer la memoria
			  DATO_VALIDO : out STD_LOGIC;--da un dato valido al teminar de escribir toda la memoria
			  DATOS_RAM : out STD_LOGIC);--datos que vam a la memoria
end Interleaver;

--El contador se incrementa en cada ACK hasta 96,192,288 dependiendo de la palanca activa.
--El contador va indicando el índice de la v(k) que es el vector y ese será el índice de la ROM
--esta ROM serán 3 diferentes dependiendo del tipo de modulación y son ROMs fijas de punteros con índices
--(punteros) de dónde escribir en la memoria RAM para así barajar los datos, todos estos índices
--calculados e introducidos en la ROM previamente.


architecture Interleaver_arch of Interleaver is

	type estado is (S0, Sb1, Sb2, Sb3, Sb4, Sb5, Sb6, Sb7, Sb8, Sb9, Sb10, Sb11, Sb12,
						Sq1, Sq2, Sq3, Sq4, Sq5, Sq6, Sq7, Sq8, Sq9, Sq10, Sq11, Sq12,
						S81, S82, S83, S84, S85, S86, S87, S88, S89, S810, S811, S812, S813, S814, S815, S816);
	signal estado_actual, estado_nuevo: estado;
	signal pcont_h, cont_h: std_logic_vector(4 downto 0);
	signal salida_dir, psalida_dir: std_logic_vector(8 downto 0);
	signal dato_mem: std_logic;--señal que conecta los datos de entrada y los de salida
begin





	sinc:process(reset,clk)
	 begin
		if(reset='1') then
			cont_h<=(others=>'0');
		elsif (clk='1' and clk'event) then
			estado_actual<=estado_nuevo;
			cont_h<=pcont_h;
			salida_dir<=psalida_dir;
			DATOS_RAM<=dato_mem;-- hacemos la salida síncrona
		end if;
	 end process;


	maquina:process(modulacion, cont_h, estado_actual, ENABLE, DATO_SC, salida_dir)
	 begin
	 
	 DATO_VALIDO<='0';----------------------------
	 DIR_RAM<=salida_dir;
	 pcont_h<=cont_h;--añadidos para quitar latches
	 estado_nuevo<=estado_actual;--añadidos para quitar latches
	 psalida_dir<=salida_dir;
	 W_R<="1";
	 dato_mem<='0';
			 case estado_actual is
			--hemos realizado una maquina de estados que bifurca según la modulacion, recibe un simbolo y lo escribe directamente en 
			--una memoria dela forma que al leerla el bloque del  mapper ya lea secuencialmente de las direcciones 1,2,3...; e decir
			--realizamos el interliever como una rutina de escritura
			 when S0 =>--compara modulacion y va a la rama correspondiente, ya sea Sb, Sq, S8
				if(enable='1' and modulacion(0)='1')then
					W_R<="1";
					estado_nuevo<=Sb1;
					pcont_h<=(others=>'0');
					psalida_dir<="000000001";
				elsif(enable='1' and modulacion(1)='1')then
					W_R<="1";
					estado_nuevo<=Sq1;
					pcont_h<=(others=>'0');
					psalida_dir<="000000001";
				elsif(enable='1' and modulacion(2)='1')then
					W_R<="1";
					estado_nuevo<=S81;
					pcont_h<=(others=>'0');
					psalida_dir<="000000001";
				
				else
					psalida_dir<=(others=>'0');
				end if;


			 ------------------------------------------------------------------
			 ---------------------------------------------------------------------
			 -------------------------------------------------------------------
			 --parte de la rutina para bpsk, consta de 12 estados, muy similares entre ellos que recorre la memoria 
			 --cada 12 direcciones
			 
			 
			 when Sb1 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="111")then--se cuentas 8 direcciones hasta desbordar escritura, 1 simbolo 96bits, 
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";--sumamos las 12 direcciones
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb2;
					pcont_h<=(others=>'0');
					psalida_dir<="000000010";
				end if;
				
				
			 when Sb2 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb3;
					pcont_h<=(others=>'0');
					psalida_dir<="000000011";
				end if;
				
			 when Sb3 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb4;
					pcont_h<=(others=>'0');
					psalida_dir<="000000100";
				end if;
				
			 when Sb4 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb5;
					pcont_h<=(others=>'0');
					psalida_dir<="000000101";
				end if;


			 when Sb5 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb6;
					pcont_h<=(others=>'0');
					psalida_dir<="000000110";
				end if;
				
			 when Sb6 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb7;
					pcont_h<=(others=>'0');
					psalida_dir<="000000111";
				end if;	
				

			 when Sb7 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb8;
					pcont_h<=(others=>'0');
					psalida_dir<="000001000";
				end if;

			 

			 when Sb8 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="0111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb9;
					pcont_h<=(others=>'0');
					psalida_dir<="000001001";
				end if;
				
			 when Sb9 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="0111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb10;
					pcont_h<=(others=>'0');
					psalida_dir<="000001010";
				end if;

			 when Sb10 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="0111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb11;
					pcont_h<=(others=>'0');
					psalida_dir<="000001011";
				end if;

			 when Sb11 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="0111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sb12;
					pcont_h<=(others=>'0');
					psalida_dir<="000001100";
				end if;

			 when Sb12 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1000")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S0;
					pcont_h<=(others=>'0');
					psalida_dir<=(others=>'0');
					DATO_VALIDO<='1';
				end if;
				

			-------------------------------------------------------------
			----------------qpsk-----------------------------------
			-------------------------------------------------------
			--parte de la rutina para bpsk, consta de 12 estados, muy similares entre ellos que recorre la memoria 
			 --cada 12 direcciones


			when Sq1 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then--se cuentas 16 direcciones hasta desbordar escritura, 1 simbolo 192bits, 
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";--suma las 12 direcciones
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq2;
					pcont_h<=(others=>'0');
					psalida_dir<="000000010";
				end if;
				
			when Sq2 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq3;
					pcont_h<=(others=>'0');
					psalida_dir<="000000011";
				end if;
				
			when Sq3 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq4;
					pcont_h<=(others=>'0');
					psalida_dir<="000000100";
				end if;


			when Sq4 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq5;
					pcont_h<=(others=>'0');
					psalida_dir<="000000101";
				end if;


			when Sq5 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq6;
					pcont_h<=(others=>'0');
					psalida_dir<="000000110";
				end if;



			when Sq6 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq7;
					pcont_h<=(others=>'0');
					psalida_dir<="000000111";
				end if;
				
				
			when Sq7 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq8;
					pcont_h<=(others=>'0');
					psalida_dir<="000001000";
				end if;


			when Sq8 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq9;
					pcont_h<=(others=>'0');
					psalida_dir<="000001001";
				end if;
				
				
			when Sq9 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq10;
					pcont_h<=(others=>'0');
					psalida_dir<="000001010";
				end if;

			when Sq10 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq11;
					pcont_h<=(others=>'0');
					psalida_dir<="000001011";
				end if;


			when Sq11 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=Sq12;
					pcont_h<=(others=>'0');
					psalida_dir<="000001100";
				end if;
				

			when Sq12 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="1111")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"1100";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S0;
					pcont_h<=(others=>'0');
					psalida_dir<=(others=>'0');
					DATO_VALIDO<='1';
					end if;
			 
			 
			 ---------------------------------------------------------------
			 ---------------------------------------------------------------
			----------------------------------------------------------------
			--parte de la rutina para bpsk, consta de 16 estados, muy similares entre ellos que recorre la memoria 
			--cada 16 direcciones




			when S81 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then--se cuentas 18 direcciones hasta desbordar escritura, 1 simbolo 288bits, 
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";--suma las 16 direcciones
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S82;
					pcont_h<=(others=>'0');
					psalida_dir<="000000010";
				end if;



			when S82 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S83;
					pcont_h<=(others=>'0');
					psalida_dir<="000000011";
				end if;



			when S83 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S84;
					pcont_h<=(others=>'0');
					psalida_dir<="000000100";
				end if;


			when S84 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S85;
					pcont_h<=(others=>'0');
					psalida_dir<="000000101";
				end if;




			when S85 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S86;
					pcont_h<=(others=>'0');
					psalida_dir<="000000110";
				end if;


			when S86 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S87;
					pcont_h<=(others=>'0');
					psalida_dir<="000000111";
				end if;

			when S87 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S88;
					pcont_h<=(others=>'0');
					psalida_dir<="000001000";
				end if;

			when S88 =>	
				W_R<="0";
				dato_mem<=DATO_SC;  
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S89;
					pcont_h<=(others=>'0');
					psalida_dir<="000001001";
				end if;

			when S89 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S810;
					pcont_h<=(others=>'0');
					psalida_dir<="000001010";
				end if;

			when S810 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S811;
					pcont_h<=(others=>'0');
					psalida_dir<="000001011";
				end if;


			when S811 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S812;
					pcont_h<=(others=>'0');
					psalida_dir<="000001100";
				end if;


			when S812 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S813;
					pcont_h<=(others=>'0');
					psalida_dir<="000001101";
				end if;


			when S813 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S814;
					pcont_h<=(others=>'0');
					psalida_dir<="000001110";
				end if;

			when S814 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S815;
					pcont_h<=(others=>'0');
					psalida_dir<="000001111";
				end if;


			when S815 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
			
				if(cont_h/="10001")then
				 if (enable='1')then
						psalida_dir<=salida_dir+"10000";
						pcont_h<=cont_h+'1';
				 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S816;
					pcont_h<=(others=>'0');
					psalida_dir<="000010000";
				end if;


			when S816 =>	
				W_R<="0";
				dato_mem<=DATO_SC;
				if(cont_h/="10001")then
					 if (enable='1')then
							psalida_dir<=salida_dir+"10000";
							pcont_h<=cont_h+'1';
					 end if;
					estado_nuevo<=estado_actual;
				else
					estado_nuevo<=S0;
					pcont_h<=(others=>'0');
					psalida_dir<=(others=>'0');
					DATO_VALIDO<='1';
				end if;




				
				
			 end case;
			 end process;

end Interleaver_arch;

