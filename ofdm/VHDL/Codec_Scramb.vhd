----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:04:56 07/01/2015 
-- Design Name: 
-- Module Name:    Codec_Scramb - Behavioral 
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

entity Codec_Scramb is
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

end Codec_Scramb;

architecture Behavioral of Codec_Scramb is

component scrambler is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
		   Datoin_CodConv : in STD_LOGIC;
         enable_CodConv : in  STD_LOGIC;
		   Ack_Scram : out STD_LOGIC;
		   Datoout_scram : out STD_LOGIC
			  );
end component;


component EncoderCompleto is

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
end component;





signal dencoder_scrambler, Dvencoder_scrambler: std_logic;
begin


Scram: scrambler 
    Port map( clk =>clk,
           reset =>reset,
		     Datoin_CodConv =>Dencoder_scrambler,
           enable_CodConv =>Dvencoder_scrambler,
		     Ack_Scram =>Ack_Scram,
		     Datoout_scram=>Datoout_scram
			  );
AuxiliaryEncoder: EncoderCompleto 

	port map(
			  clk  =>clk,
           reset  => reset,
			  palanca1 =>palanca1,
			  palanca2 =>palanca2,
			  palanca3 => palanca3,
			  error  => error, --Va a encender los leds de la fpga indicando que no se puede hacer esa combinacion 
           modulacion =>modulacion, --va a darle al resto de los bloques la modulacion
																				 --que se utiliza desde lo que lea de las palancas
																				 --001 Dbpsk
																				 --010 Dqpsk
																				 --100 D8psk
			   ackCodConv =>DVencoder_scrambler,
            dataout_CodConv  =>Dencoder_scrambler
			);




end Behavioral;

