----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:12:26 03/27/2015 
-- Design Name: 
-- Module Name:    FSM - Behavioral 
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


entity FSM is
    generic(
		ancho_bus_dir:integer:=4;
		VAL_SAT_CONT:integer:=5012;
		ANCHO_CONTADOR:integer:=13);
    Port ( clk : in  STD_LOGIC;
           reset: in std_logic;
			  button : in  STD_LOGIC;
			  --Esta parte no la puedo conseguir de manera generalista a causa de lo lento que es
			  --la transmision por la UART
			  direcc_memoriafinal: out STD_LOGIC_VECTOR (9 downto 0);
			  modulacion: in  STD_LOGIC_VECTOR (2 downto 0);
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           TX : out  STD_LOGIC);
end FSM; 

architecture Behavioral of FSM is

Type estado is (Reposo, Inicio, Text_Data, B_Start, B_0, B_Paridad, B_Stop);
signal a_estado, p_estado: estado;
signal cont, p_cont: integer; --Necesito contar hasta Val_sat_cont

signal cont1, pcont1: integer;








signal a_dir, p_dir: STD_LOGIC_VECTOR (9 downto 0);


begin
dirrec_memoriafinal<=a_dir;
sinc:process(clk,reset) 
begin  
	if(reset='1') then   
		cont<=0;
		cont1<=0; 
a_dir<=0;		
	elsif (rising_edge(clk)) then 
	   cont<=p_cont;
		cont1<=pcont1; 
		a_estado<=p_estado; 
		a_dir<=p_dir;
	end if; 
end process;
  
maquina_estado:process( a_estado, button, data ,cont, cont1,a_dir)
 

 begin 
      p_dir<=a_dir;
		p_estado<=a_estado;
		p_cont<=cont;	
		pcont1<=cont1; 
		TX<='1';
	case a_estado is
	
		when reposo =>
			TX<='1';
			p_cont<=0;
			pcont1<=0; 
			if(button='1') then
				p_estado<=Inicio;
			end if;
			
		when inicio =>
			TX<='1';
			p_estado<=Text_Data;
			
		when  Text_Data =>
			TX<='1';
			p_estado<=B_Start;
			--He calculado la ultima direccion de memoria que se llena en funcion del tipo de 
			--modulacion, 7 simbolos en dbpsk, 4 en dqpsk y 3 en d8psk
			if(a_dir="1110000000" and modulacion="001") then  
				p_estado<=Reposo; 
			elsif(a_dir="0111111111" and modulacion="010") then  
				p_estado<=Reposo; 
			elsif(a_dir="0110000000" and modulacion="100") then  
				p_estado<=Reposo; 
			end if;
			  
		when B_Start =>
			TX<='0';
			p_cont<=cont+1;
			if(cont=VAL_SAT_CONT) then
				p_cont<=0;
				p_estado<=B_0;
			end if;
			
		when B_0 =>
		
			p_cont<=cont+1;
			if(cont=VAL_SAT_CONT) then
				 p_cont<=0;
				 pcont1<=cont1+1; 
			end if;
			
			if(cont1<=7) then
				 TX<=data(cont1);
			else
				 p_estado<=B_Paridad;
				 pcont1<=0;
		   end if;


		when B_Paridad =>
			TX<=(data(0) xor data(1) xor data(2) xor data(3) xor data(4) xor data(5) xor data(6) xor data(7));
			p_cont<=cont+1;
			
			if(cont=VAL_SAT_CONT) then
				p_cont<=0;
				p_estado<=B_Stop;
			end if;
			
		when others => 
			TX<='1';
			p_cont<=cont+1;
			if(cont=VAL_SAT_CONT) then
				p_cont<=0;
				p_estado<=Inicio;
				p_dir<=a_dir+1;
			end if;  
			
		end case;
	
end process;


end Behavioral;

