----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:00:35 06/03/2015 
-- Design Name: 
-- Module Name:    pasasimbolo - Behavioral 
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

entity simbolo_in is
     generic(	length_bus_dir_out: integer:=8);
		 Port ( 	clk : in  std_logic;
					reset : in std_logic;
					dataInterl : in  std_logic_vector(0 downto 0);
					modulacion : in  std_logic_vector(2 downto 0);
					enable_interl : in std_logic;
					enable_process: out std_logic;
					direcc: out std_logic_vector(length_bus_dir_out downto 0);
					simboloin : out std_logic_vector(2 downto 0));
end simbolo_in;

architecture Behavioral of simbolo_in is

type estado is (reposo, s1,s2,s3,s4);
signal estado_actual,estado_nuevo: estado;

-- Contadores para separar datos de entrada en funcion de la modulacion y
-- para la direccion a leer de la memoria
signal dir,pdir: std_logic_vector(length_bus_dir_out downto 0);
-- Dato de salida para el siguiente si­mbolo 
signal dout, pdout: std_logic_vector(2 downto 0);
--signal enable: std_logic;

begin

	sinc:process(clk,reset)
		begin
			if(reset='1') then
			dir<= (others =>'0');
--				simboloin<=(others =>'0');
--				enable<='0';
            enable_process<='0';
--				dout<=(others =>'0');
				estado_actual<=reposo;
			elsif(rising_edge(clk)) then
		      dout<=pdout;
		-- Actualizamos contador de posiciones
				dir<=pdir;
				estado_actual<=estado_nuevo;
			end if;
			
	end process;
 direcc<=dir;
 -- Actualizamos el registro de lectura
--				simboloin<=dout;
				
		-- Actualizamos pulso de lectura de entrada
--				enable_process<=enable;  ,dout
	comb:process(enable_Interl, modulacion, dir, estado_actual,dataInterl)
	begin
	-- Inicializamos las signals para evitar latches
		pdir<=dir; 
--		pdout<=dout;
      simboloin<=(others=>'0');
	   enable_process<='0';
			case estado_actual is
				when reposo =>  
						enable_process<='1';
--						pdout<=(others=>'0');
					if (enable_Interl='1') then 
						estado_nuevo<=s1;
						pdir<=dir+1;
						enable_process<='1';
					else
						estado_nuevo<=estado_actual;
					end if;
				when s1 =>
					enable_process<='1';
					
					if (modulacion(0)='1') then
					   simboloin(0)<=dataInterl(0);
						estado_nuevo<=s4;
						pdir<=dir+1;
					elsif(modulacion(1)='1') then
					   simboloin(1)<=dataInterl(0);
						estado_nuevo<=s2;
						pdir<=dir+1;
					else
						simboloin(2)<=dataInterl(0);
						estado_nuevo<=s2;
						pdir<=dir+1;
					end if;
				when s2 =>
					enable_process<='1';
					
					if (modulacion(1)='1') then
					   simboloin(0)<=dataInterl(0);
						estado_nuevo<=s4;
						pdir<=dir+1;
					else
						simboloin(1)<=dataInterl(0);
						estado_nuevo<=s3;
						pdir<=dir+1;
					end if;
					
				when s3 =>
					simboloin(0)<=dataInterl(0);
					estado_nuevo<=s4;
					pdir<=dir+1;
					
				when s4 =>
					enable_process<='0';
					estado_nuevo<=s1;
					
					if dir="001100001" then
							if modulacion(0)='1' then
								enable_process<='0';
								pdir<=(others => '0');
								estado_nuevo<=reposo;
								dout(0)<=dataInterl(0);
							
							end if;
					elsif dir="011000010" then
							if modulacion(1)='1' then
								enable_process<='0';
								pdir<=(others => '0');
								estado_nuevo<=reposo;
							
							end if;
					elsif dir="100100001" then
							if modulacion(2)='1' then
								enable_process<='0';
								pdir<=(others => '0');
								estado_nuevo<=reposo;
							
							end if;
					
					end if;
			end case;	
	end process;
end Behavioral;  

