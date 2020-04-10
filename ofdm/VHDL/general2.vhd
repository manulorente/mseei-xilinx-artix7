----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:57:27 07/06/2015 
-- Design Name: 
-- Module Name:    general2 - Behavioral 
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

entity general2 is
generic(
		ancho_bus_dir:integer:=7; --Declararlo asi me permite poder hacer ifft
										  --de distinto tamaño en complicaciones posteriores
		precision:integer:=8     
										  
					);	
 Port ( clk : in  STD_LOGIC;
           reset: in std_logic;
			  button : in  STD_LOGIC;
			  modulacion: in  STD_LOGIC_VECTOR (2 downto 0);
			  block_valid: in std_logic;
			  data_re : in  STD_LOGIC_VECTOR (precision-1 downto 0);
			  data_im : in  STD_LOGIC_VECTOR (precision-1 downto 0);
           TX : out  STD_LOGIC);
end general2;

architecture Behavioral of general2 is


component FSM is
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
end component; 


component fourier is
	generic(
		ancho_bus_dir:integer:=7; --Declararlo asi me permite poder hacer ifft
										  --de distinto tamaño en complicaciones posteriores
		precision:integer:=8     
										  
					);					  
		Port ( 
			  clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           block_valid: in std_logic;
			  data_re : in  STD_LOGIC_VECTOR (precision-1 downto 0);
			  data_im : in  STD_LOGIC_VECTOR (precision-1 downto 0);
           direcc_re : out  STD_LOGIC_VECTOR (ancho_bus_dir-1 downto 0);
			  direcc_im : out  STD_LOGIC_VECTOR (ancho_bus_dir-1 downto 0);
			  direcc_out: out STD_LOGIC_VECTOR (9 downto 0);
				data_out: out  STD_LOGIC_VECTOR (31 downto 0);
				data_valid : OUT STD_LOGIC--Para que el transmisor pueda empezar a enviar desde la primera linea
				);
		
end component;
  
COMPONENT memoria_real
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clkb : IN STD_LOGIC;
    regceb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal direccfourier_memoriafinal :STD_LOGIC_VECTOR (9 downto 0);
signal dfourier_memoriafinal  :STD_LOGIC_VECTOR (31 downto 0);
signal DVfourier_fsm :STD_LOGIC;
signal direccFsm_memoriafinal  :STD_LOGIC_VECTOR (7 downto 0);

begin
bloque_ifft : fourier
	generic map(
		ancho_bus_dir=>7, --Declararlo asi me permite poder hacer ifft
										  --de distinto tamaño en complicaciones posteriores
		precision=>8     
										   
					)				  
		Port map( 
			  clk =>clk,
           reset=>rest,
           block_valid=>ack_mapped, ---------------
			  data_re =>data_re, ------------------
			  data_im =>data_in, ---------------
           direcc_re =>direcc_re, -----------------
			  direcc_im=>direcc_im, -----------
			  direcc_out=>direccfourier_memoriafinal,
				data_out=>dfourier_memoriafinal,
				data_valid =>DVfourier_fsm
				);
				
				
bloque_transmisor: FSM 
    generic map (
		ancho_bus_dir=>4,
		VAL_SAT_CONT=>5208,
		ANCHO_CONTADOR=>13)
    Port map(
	 clk=>clk,
           reset=>reset,
			  button=>DVfourier_fsm,
			  direcc_memoriafinal=>direccFsm_memoriafinal,
			  modulacion=>modulacion,
           data =>dmemoriafinal_Fsm,
           TX =>TX
			  );
			  
meReal : memoria_real
  PORT MAP (
    clka => clk,
    wea => wea,
    addra => dirreal_mappermemoria,
    dina => ddatainreal_mappermemoria,
    clkb => clk,
    regceb => regceb, ------------------------???????????????
    addrb => direcc_re,
    doutb => data_re
  );
			  
			  
end Behavioral;

