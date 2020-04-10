----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:59:48 07/01/2015 
-- Design Name: 
-- Module Name:    Descarga_IFFT - Behavioral 
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

entity Descarga_IFFT is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;  --Del DV
           xk_re : in  STD_LOGIC_VECTOR (15 downto 0);
           xk_im : in  STD_LOGIC_VECTOR (15 downto 0);
			  datamemoria: OUT STD_LOGIC_VECTOR (31 downto 0); 
			  data_valid : out  STD_LOGIC;  --directamente de DV de la ifft pero despues de escribir
			  direcc: out STD_LOGIC_VECTOR (9 downto 0)  --De escritura en la memoria son 128+12 y de los 7
																		--simbolos posibles
			 );   


end Descarga_IFFT;

architecture Behavioral of Descarga_IFFT is


--Definicion de señales
--Type estado is (GuardaDato,reposo,espera_nuevoDV); --Para la maquina de estados
--signal a_estado, p_estado: estado;
signal a_dir, p_dir: STD_LOGIC_VECTOR (9 downto 0);  
signal datamemoria_in: STD_LOGIC_VECTOR (31 downto 0); 



		
begin
direcc<=a_dir;
datamemoria<=datamemoria_in;
sinc:process (clk,reset) 
begin
	if (reset='1' ) then 
		--Estado de partida
		a_dir<=(others=>'0');
--		a_estado<=reposo;
		
	elsif(rising_edge(clk)) then  
		a_dir<=p_dir;
--		a_estado<=p_estado;

	end if;

end process;

--a_estado,
comb:process ( a_dir, enable, xk_re, xk_im )

variable fin : STD_LOGIC_VECTOR (7 downto 0);

begin
 
fin:="10001011";    --139, de los 127+12 del prefijo ciclico
	
--	p_estado<=a_estado;
	p_dir<=a_dir;
	data_valid<='0';
	--De esta manera me aseguro de que 
	datamemoria_in(31 downto 16)<=xk_re;
	datamemoria_in(15 downto 0)<=xk_im;

	  
					if(enable='1') then
						p_dir<=a_dir+1;
					   data_valid<='1';
						datamemoria_in(31 downto 16)<=xk_re;
						datamemoria_in(15 downto 0)<=xk_im;
					end if;
			


--		case a_estado is
--		      when reposo=>
--					if(enable='1') then
--						p_estado<=GuardaDato;
--						p_dir<=a_dir+1;
--					   data_valid<='1';
--					end if;
--				when GuardaDato =>  --Me activa la ifft con su dv
--						
--							
--							if(a_dir=fin and enable='0') then
--								p_estado<=Reposo;
--								p_dir<=(others=>'0');
--							elsif(a_dir=fin and enable='1') then
--								p_estado<=espera_nuevoDV;
--								p_dir<=(others=>'0');
--							else
--								datamemoria_in(31 downto 16)<=xk_re;
--								datamemoria_in(15 downto 0)<=xk_im;
--								p_dir<=a_dir+1; 
--								data_valid<='1';
--							
--							end if;
--						
--				when espera_nuevoDV =>  
--					if(enable='0') then
--						p_estado<=Reposo;
--					end if;
--		 end case;

end process;


end Behavioral;

