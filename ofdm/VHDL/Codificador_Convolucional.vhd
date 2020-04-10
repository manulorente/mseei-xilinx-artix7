----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:52:14 04/20/2015 
-- Design Name: 
-- Module Name:    Codificador_Convolucional - Behavioral 
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity Codificador_Convolucional is
generic(
	val_sat_cont3:integer:=10   --AQUI FALTARIA SABER CUAL ES EL ESTANDAR PERO SÉ QUE FUNCIONA
		);
    Port ( clk : in  STD_LOGIC;
           reset: in std_logic;
           data : in  STD_LOGIC;--dato de entrada
			  enable: in std_logic;--señal que habilita la entrada
		     ackCodConv : out STD_LOGIC;--señal hablita bloque siguiente
--           direcc : out  STD_LOGIC_VECTOR (ancho_bus_dir-1 downto 0);
           dataout_CodConv : out  STD_LOGIC);--dato de salida
end Codificador_Convolucional;
--   Vamos a almacenar el valor de las Xor del registro en dos biestables y los transmitiremos secuencialmente 
--(de esta manera pasamos de paralelo a serie directamente) activando una señal de 
--ack(ackCodConv) que indica que el valor es correcto



architecture Behavioral of Codificador_Convolucional is

signal a_salida_ack, p_salida_ack, a_salida_out, p_salida_out: std_logic;--las salidas las hacemos sincronas
signal b_actual, b_nuevo: std_logic_vector(5 downto 0);--biestables para xor
type estado is (S0, S1, S2, S3, S4, espera1, espera2);
signal estado_actual, estado_nuevo: estado;
signal cont3, p_cont3: integer;
--STD_LOGIC_VECTOR (val_sat_cont3-1 downto 0); --Usado para darle tiempo al encoder 

begin

ackCodConv<=a_salida_ack;--asignamos las señales de salida
dataout_CodConv<=a_salida_out;

sinc:process(reset,clk)
 begin
	if(reset='1') then--inicializamos las señales
		a_salida_out<='0';
		b_actual<=(others=>'0');
		cont3<=0;
		estado_actual<=S0;
		a_salida_ack<='0';
	elsif (clk='1' and clk'event) then
		estado_actual<=estado_nuevo;
		b_actual<=b_nuevo;
		cont3<=p_cont3;  --Para darle un respiro al encoder y que solo salgan datos cada dos clk
		a_salida_out<=p_salida_out;
		a_salida_ack<=p_salida_ack;
	end if;
 end process; 



maquina:process(enable, estado_actual, data, b_actual, cont3, a_salida_ack, a_salida_out)
--variable sat_cont3 : STD_LOGIC_VECTOR (val_sat_cont3-1 downto 0); --Para comprobacion de final de mensaje

 begin
 --sat_cont3:=(others=>'1');
	p_salida_out<=a_salida_out;--salida en serie
	b_nuevo<=(others=>'0');
	p_salida_ack<='0';
	p_cont3<=0;
	estado_nuevo<=estado_actual;
	
 case estado_actual is
 
 
	when S0 =>
		b_nuevo<=b_actual;
		p_salida_ack<='0';
		if(enable='1')then
			estado_nuevo<=S1;
		else
			estado_nuevo<=S0;
		end if;
		
		--hemos dividido las xor en varios estados, para serializar las salidas, de esta forma por cada dato de entrada
		--esperamos 5 pulsos de reloj y sacamos las dos salidas de la forma =>(no saco->saco la primera->no saco->saco la segunda)
	when S1 =>
		b_nuevo<=b_actual;
		p_salida_out<= data xor b_actual(0) xor b_actual(2) xor b_actual(4) xor b_actual(5);
		p_salida_ack<='1';
		estado_nuevo<=S2;
		
		
	when S2 =>
		b_nuevo<=b_actual;
		p_salida_ack<='0';
		estado_nuevo<=espera1;
		
		
	when S3 =>
		b_nuevo<=b_actual;
		p_salida_ack<='1';
		p_salida_out<= data xor b_actual(2) xor b_actual(3) xor b_actual(5);
		estado_nuevo<=S4;
		
		
	when S4 =>
		p_salida_ack<='0';
		b_nuevo(0)<=data;
		b_nuevo(1)<=b_actual(0);
		b_nuevo(2)<=b_actual(1);
		b_nuevo(3)<=b_actual(2);
		b_nuevo(4)<=b_actual(3);
		b_nuevo(5)<=b_actual(4);
		estado_nuevo<=espera2;
		
		
	when espera1 =>
		b_nuevo<=b_actual;
		p_salida_ack<='0';
      p_cont3<=cont3+1; --En este caso me interesa que no pare de contar nunca y se autodesborde

			if(cont3=val_sat_cont3) then   --Para darle un respiro al encoder val_sat_cont3
				estado_nuevo<=S3;
				p_cont3<=0;
			end if;	
			
			
	when espera2 =>
		b_nuevo<=b_actual;
		p_salida_ack<='0';
      p_cont3<=cont3+1; --En este caso me interesa que no pare de contar nunca y se autodesborde

			if(cont3=val_sat_cont3) then   --Para darle un respiro al encoder val_sat_cont3
				estado_nuevo<=S0;
				p_cont3<=0;
			end if;
			
	end case;
 end process;

end Behavioral;

