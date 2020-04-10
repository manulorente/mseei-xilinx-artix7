----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:18:22 07/06/2015 
-- Design Name: 
-- Module Name:    Hasta_interleaver - Behavioral 
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

entity Hasta_interleaver is
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
			  DIR_RAM : out  STD_LOGIC_VECTOR (8 downto 0); --Para que llegue a todos los tipos de modulaciones
			  W_R : out STD_LOGIC_VECTOR (0 downto 0);
			  DATO_VALIDO : out STD_LOGIC;
			  DATOS_RAM : out STD_LOGIC);


end Hasta_interleaver;

architecture Behavioral of Hasta_interleaver is



component Interleaver is
    Port ( CLK : in  STD_LOGIC;
           RESET: in STD_LOGIC;
			  DATO_SC : in  STD_LOGIC;
           modulacion : in  STD_LOGIC_VECTOR (2 downto 0);
           ENABLE : in  STD_LOGIC;
	        DIR_RAM : out  STD_LOGIC_VECTOR (8 downto 0); --Para que llegue a todos los tipos de modulaciones
			  W_R : out STD_LOGIC_VECTOR (0 downto 0);
			  DATO_VALIDO : out STD_LOGIC;
			  DATOS_RAM : out STD_LOGIC);
end component;


component Codec_Scramb is
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
				Ack_Scram : out STD_LOGIC;
				Datoout_scram : out STD_LOGIC);

end component;


signal DVscramb_inter, Dscramb_inter: STD_LOGIC;

signal modu: STD_LOGIC_vector(2 downto 0);

begin
modulacion<=modu;


hastaScrambler: Codec_Scramb 
		port map(
			  clk=>clk,
           reset=>reset,
			  palanca1=>palanca1, --Dbpsk
			  palanca2=>palanca2, --Dqpsk
			  palanca3=>palanca3, --D8psk      
			  error =>error,  --Va a encender los leds de la fpga indicando que no se puede hacer esa combinacion 
           modulacion =>modu, --va a darle al resto de los bloques la modulacion
																				 --que se utiliza desde lo que lea de las palancas
																				 --001 Dbpsk
																				 --010 Dqpsk
																				 --100 D8psk
				Ack_Scram =>DVscramb_inter,
				Datoout_scram=>Dscramb_inter  
				);
				

ilv: Interleaver 
    Port map ( 
	        CLK  =>clk,
           RESET=>reset,
			  DATO_SC =>Dscramb_inter,
           Modulacion =>modu,
           ENABLE =>DVscramb_inter,
	        DIR_RAM => dir_ram,--Para que llegue a todos los tipos de modulaciones
			  W_R =>w_r,
			  DATO_VALIDO =>dato_valido,
			  DATOS_RAM=>datos_ram
			  
			  );


end Behavioral;

