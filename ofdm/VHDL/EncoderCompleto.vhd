----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:25:28 07/01/2015 
-- Design Name: 
-- Module Name:    EncoderCompleto - Behavioral 
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

entity EncoderCompleto is

	port(
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  palanca1: in  STD_LOGIC; --Dbpsk
			  palanca2: in  STD_LOGIC; --Dqpsk
			  palanca3: in  STD_LOGIC; --D8psk      
			  error : out  STD_LOGIC;  --Va a encender los leds de la fpga indicando que no se puede hacer esa combinacion 
           modulacion : out  STD_LOGIC_VECTOR (2 downto 0); --va a darle al resto de los bloques la modulacion
																				 --que se utiliza desde lo que lea de las palancas
																				 --001 Dbpsk
																				 --010 Dqpsk
																				 --100 D8psk
			   ackCodConv : out STD_LOGIC;
            dataout_CodConv : out  STD_LOGIC);
end EncoderCompleto;

architecture Behavioral of EncoderCompleto is


component Codificador_Convolucional is
generic(
	val_sat_cont3:integer:=300   --Hay que poner 300 para que no sobreescriba en el interleaver
		);
    Port ( clk : in  STD_LOGIC;
           reset: in std_logic;
           data : in  STD_LOGIC;
			  enable: in std_logic;
		     ackCodConv : out STD_LOGIC;
--           direcc : out  STD_LOGIC_VECTOR (ancho_bus_dir-1 downto 0);
           dataout_CodConv : out  STD_LOGIC);
end component;



component CompletaMensaje is
	generic(
		ancho_byte:integer:=8;
		ancho_bus_dir:integer:=6; --Hasta 64 caracteres, nuestros nombres ocupan unos 39
		val_sat_cont3:integer:=600  --Hay que poner 600 para que no sobreescriba en el interleaver
		);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  palanca1: in  STD_LOGIC; --Dbpsk
			  palanca2: in  STD_LOGIC; --Dqpsk
			  palanca3: in  STD_LOGIC; --D8psk          
           data_out : out  STD_LOGIC;
			  data_valid: out  STD_LOGIC;
			  error : out  STD_LOGIC;  --Va a encender los leds de la fpga indicando que no se puede hacer esa combinacion 
           modulacion : out  STD_LOGIC_VECTOR (2 downto 0)); --va a darle al resto de los bloques la modulacion
																				 --que se utiliza desde lo que lea de las palancas
																				 --001 Dbpsk
						 														 --010 Dqpsk
																				 --100 D8psk
end component;


signal daux_encoder, dvaux_encoder: std_logic;

begin




bloque_auxiliar: CompletaMensaje 
	generic map (
		ancho_byte=>8,
		ancho_bus_dir=>6, --Hasta 64 caracteres, nuestros nombres ocupan unos 39
		val_sat_cont3=>600   --Hay que poner 600 para que no sobreescriba en el interleaver
		)
    Port map( clk=>clk,
           reset=>reset,
			  palanca1=>palanca1,
			  palanca2=>palanca2,
			  palanca3=>palanca3,
           data_out=>daux_encoder,
			  data_valid=>dvaux_encoder,
			  error =>error,
           modulacion =>modulacion
		);

convolu_encoder: Codificador_Convolucional 
	generic map (
	  val_sat_cont3=>300   --Hay que poner 300 para que no sobreescriba en el interleaver
		)
    Port map ( clk=>clk,
           reset=>reset,
           data=>daux_encoder, 
			  enable=>dvaux_encoder,
		     ackCodConv=>ackCodConv,
           dataout_CodConv => dataout_CodConv
			  );

  

end Behavioral;

