----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:55:34 04/20/2015 
-- Design Name: 
-- Module Name:    scrambler - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scrambler is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   Datoin_CodConv : in STD_LOGIC;--dato recibido del codificador
           enable_CodConv : in  STD_LOGIC;--enable dado cada dato
		   Ack_Scram : out STD_LOGIC;--dato que valida la salida
		   Datoout_scram : out STD_LOGIC--*dato
			  );
end scrambler;  

	--  Este bloque recibe en serie los datos con una señal 
	--que indica que se puede utilizar.
	--  Con la habilitacion se realiza la xor de la entrada 
	--con el resultado de la xor del registro interno para obtener su nuevo valor
	--y lo enviamos al entrelazador.
	--  En el siguiente estado desplazamos el registro y  
	--esperamos a que la habilitacion del cod.conv valga 0 indicando que vamos a 
	--recibir un nuevo dato.






architecture Behavioral of scrambler is
signal des_actual: std_logic_vector(6 downto 0);--biestable de los que se lee para las xor
signal des_nuevo: std_logic_vector(6 downto 0);
signal a_exor, p_exor, a_rxor,p_rxor, a_salida_ack,p_salida_ack: std_logic;
type estado is (S0, S1);
signal estado_actual: estado;
signal estado_nuevo: estado; 

begin


Ack_Scram<=a_salida_ack;--conectamos las entradas a señales
Datoout_scram<=a_exor;

sinc:process(reset,clk)
 begin
	if(reset='1') then
		estado_actual <= S0;--inicializo las señales
		des_actual<=(others=>'1');
	   a_rxor<='0';
		a_salida_ack<='0';
		a_exor<='0';
 
	elsif (clk='1' and clk'event) then
		estado_actual<= estado_nuevo;
		des_actual<=des_nuevo;
		a_rxor<=p_rxor;
		a_salida_ack<=p_salida_ack;
		a_exor<=p_exor;
 
	end if;
 end process; 

--Se ha realizado una maquina de estados bastante sencillita con dos estados


maquina:process(enable_CodConv, a_exor, a_rxor, des_actual, Datoin_CodConv, estado_actual)
 begin
 p_exor<=a_exor;
 p_rxor<=a_rxor;
 p_salida_ack<='0';
 estado_nuevo<=estado_actual;
 des_nuevo<=des_actual;-----------
 
 case estado_actual is
	when S0 =>
		p_salida_ack<='0';
		des_nuevo<=des_actual;
		if(enable_CodConv='1')then
		des_nuevo<=des_actual;
		p_rxor<=des_actual(3) xor des_actual(6);--realizamos la primera xor y guardamos en un aux
		estado_nuevo<=S1;

		end if;
	when S1 => 
		p_salida_ack<='1';
		p_exor<=a_rxor xor Datoin_CodConv;
		des_nuevo(0)<=a_rxor;--vuelve a entrar en la serie de biestables
		des_nuevo(1)<=des_actual(0);
		des_nuevo(2)<=des_actual(1);
		des_nuevo(3)<=des_actual(2);
		des_nuevo(4)<=des_actual(3);
		des_nuevo(5)<=des_actual(4);
		des_nuevo(6)<=des_actual(5);
		estado_nuevo<=S0;
--	when S4 =>
--		if(enable_CodConv='0')then
--		des_nuevo<=des_actual;
--		estado_nuevo<=S0;		
--		end if;
 end case;
 
 end process;



end Behavioral;


