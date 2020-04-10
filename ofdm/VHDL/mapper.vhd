----------------------------------------------------------------------------------
-- Company: Sistemas electrónicos de comunicaciones
-- Engineer: Manuel Lorente Almán
-- 
-- Create Date:    10:55 03/07/2015 
-- Design Name: 
-- Module Name:    MAPPER - Behavioral 
-- Project Name: Project
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Mapper for DBPSK, DQPSK and D8PSK modulations.
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

entity mapper is
   generic(
		width_bus_dir_out:integer:=8;
		length_bus_dir_out: integer:=8);
    Port (  clk : in  std_logic;
				reset : in  std_logic;
				enable_interl : in  std_logic; 
				modulacion : in  std_logic_vector (2 downto 0);
				dataInterl : in  std_logic_vector (0 downto 0);
				pulso_interl: out std_logic;
				dir_RamIFFT: out std_logic_vector (length_bus_dir_out-1 downto 0);
				reals : out  std_logic_vector (width_bus_dir_out-1 downto 0); 
				imags : out  std_logic_vector (width_bus_dir_out-1 downto 0)
				  );
end mapper;   

architecture Behavioral of mapper is

-- This signal links catch&process block and modulation block
signal simb_diff,psimb_simboloin: std_logic_vector(2 downto 0);
signal ack_cont, stop12: std_logic;
signal pulso_pulse: std_logic;
signal stat_Q: std_logic_vector (length_bus_dir_out-1 downto 0);

signal dir_ram: std_logic_vector(8 downto 0);
signal data_ram: std_logic_vector(0 downto 0);

-- This block separates vector register input into 1,2 or 3 bits for the right constellation

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
component simbolo_process is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  enable: in std_logic;
           modulacion : in  STD_LOGIC_VECTOR (2 downto 0);
           psimb : in  STD_LOGIC_VECTOR (2 downto 0);
           simb : out  STD_LOGIC_VECTOR (2 downto 0));
end component;

-- Symbol output is the difference between data input phase and the last symbol phase sent
-- Dir_RamIFFT is a pointer to IFFT memory and it will start with the reference at 16th position
	component simbolo_out is
	   generic(	width_bus_dir_out:integer:=8;
					length_bus_dir_out: integer:=8);
		 Port ( 	clk : in  std_logic;
					reset : in std_logic;
					diff: in std_logic_vector(2 downto 0);
					modulacion : in  std_logic_vector(2 downto 0);
					enable : in std_logic;
					ack_mapper: out std_logic;
					reals: out std_logic_vector (width_bus_dir_out-1 downto 0);
					imags: out std_logic_vector(width_bus_dir_out-1 downto 0));
	end component;

	component contador is
		generic (Nbit: INTEGER :=8;
					inicio: std_logic_vector:="00010000");   
		 Port ( clk : in  STD_LOGIC;
				  reset : in  STD_LOGIC;
				  enable : in  STD_LOGIC;
				  resets : in  STD_LOGIC;
				  Q : out  STD_LOGIC_vector (Nbit-1 downto 0) );
	end component;
	
	COMPONENT entrada_mapper
	  PORT (
		 clka : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
	  );
	END COMPONENT;
	
begin

	memoria : entrada_mapper
	PORT MAP (
    clka => clk,
    wea => "0",
    addra => dir_ram,
    dina => open,
    douta => data_ram
	);


	captura: simbolo_in
		Generic map( length_bus_dir_out => 8)		
		 Port map(	clk => clk,
						reset => reset,
						dataInterl => data_ram,
						modulacion => modulacion,
						direcc=>dir_ram,
						enable_interl=> enable_interl,
						simboloin => psimb_simboloin);
						
	procesa: simbolo_process
		Port map(  clk => clk,
					  reset => reset,
					  enable => pulso_pulse,
					  modulacion => modulacion,
					  psimb =>psimb_simboloin,
					  simb => simb_diff);

	modulation: simbolo_out
	-- 4 bits to codificate constellation points
		 Generic map(width_bus_dir_out => 8,
						 length_bus_dir_out => 8)	
		 Port map( 	clk => clk,
						reset => reset,
						diff => simb_diff,
						modulacion => modulacion,
						enable => enable_interl,
						ack_mapper => ack_cont,
						reals => reals,
						imags=> imags);
						
	ifftAddr: contador
		Generic map (	Nbit =>length_bus_dir_out,
							inicio => "00010001")
		Port map (	clk =>clk,
						reset =>reset,
						enable => ack_cont,
						resets=> '0',
						Q=>stat_Q);

 dir_RamIFFT<=stat_Q;
 pulso_interl<=pulso_pulse;
 
end Behavioral;