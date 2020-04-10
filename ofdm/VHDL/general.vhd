----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:23:56 07/06/2015 
-- Design Name: 
-- Module Name:    InterleaverMemoria - Behavioral 
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

entity general is
 port(
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  palanca1: in  STD_LOGIC; --Dbpsk
			  palanca2: in  STD_LOGIC; --Dqpsk
			  palanca3: in  STD_LOGIC; --D8psk 
--			  modulacion: out STD_LOGIC_VECTOR (2 downto 0);	

			  enable_process: out std_logic;
			  simboloin : out std_logic_vector(2 downto 0);			  
			  error : out  STD_LOGIC
			  ); 


end general;

architecture Behavioral of general is

component Hasta_interleaver is
   port(
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  palanca1: in  STD_LOGIC; --Dbpsk
			  palanca2: in  STD_LOGIC; --Dqpsk
			  palanca3: in  STD_LOGIC; --D8psk 
			  modulacion : out  STD_LOGIC_VECTOR (2 downto 0);
			  error : out  STD_LOGIC;  --Va a encender los leds de la fpga indicando que no se puede hacer esa combinacion 
			  DIR_RAM : out  STD_LOGIC_VECTOR (8 downto 0); --Para que llegue a todos los tipos de modulaciones
			  W_R : out STD_LOGIC_VECTOR (0 downto 0);
			  DATO_VALIDO : out STD_LOGIC;
			  DATOS_RAM : out STD_LOGIC);


end component;


COMPONENT memoriadoble
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;

component simbolo_in is
     generic(	length_bus_dir_out: integer:=8);
		 Port ( 	clk : in  std_logic;
					reset : in std_logic;
					dataInterl : in  std_logic_vector(0 downto 0);
					modulacion : in  std_logic_vector(2 downto 0);
					enable_interl : in std_logic;
					enable_process: out std_logic;
					direcc: out std_logic_vector(length_bus_dir_out downto 0);
					simboloin : out std_logic_vector(2 downto 0));
end component;






signal  dirbloque_ram, dirRam_mapper  : STD_LOGIC_VECTOR (8 downto 0);
 signaL block_valid: STD_LOGIC;
signal dataRam_mapper, dbloque_ram :STD_LOGIC_VECTOR (0 downto 0);
-- weabloque_ram ,
signal modu :STD_LOGIC_VECTOR (2 downto 0);




begin 
--modulacion<=modu;

bloque_entero: Hasta_interleaver 
   port map(
           clk=>clk,
           reset=>reset,
			  palanca1=>palanca1, --Dbpsk
			  palanca2=>palanca2, --Dqpsk
			  palanca3=>palanca3, --D8psk      
			  error =>error,  --Va a encender los leds de la fpga indicando que no se puede hacer esa combinacion 
			  modulacion=>modu,
			  DIR_RAM =>dirbloque_ram, 
			  W_R =>open,
			  DATO_VALIDO =>block_valid ,
			  DATOS_RAM =>dbloque_ram(0)
			  );
			  
			  
your_instance_name : memoriadoble
  PORT MAP (
    clka => clk,
    wea =>"1" ,   --weabloque_ram
    addra => dirbloque_ram,
    dina => dbloque_ram,
    clkb => clk,
    addrb => dirRam_mapper ,
    doutb =>dataRam_mapper
  );
--			  
--
--memoriaInterleaver : memoria_Interleaver
--  PORT MAP (
--    clka => clk,
--    wea => weabloque_ram,
--    addra => dirbloque_ram, 
--    dina => dbloque_ram,
--    douta => dataRam_mapper
--  );
--  
  
capturaSimbolo : simbolo_in 
     generic map(	length_bus_dir_out=>8)
		 Port map ( 	
					clk =>clk,
					reset =>reset,
					dataInterl =>dataRam_mapper,
					modulacion =>modu,
					enable_interl =>block_valid,
					enable_process=>enable_process,
					direcc=>dirRam_mapper,
					simboloin=>simboloIn
					);


end Behavioral;
