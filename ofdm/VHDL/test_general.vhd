--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:05:28 07/06/2015
-- Design Name:   
-- Module Name:   C:/Users/Lerial/SkyDrive/GITT/TERCERO/2SEC/proyecto2/PrimerBloque/test_general.vhd
-- Project Name:  PrimerBloque
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: general
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY test_general IS
END test_general;
 
ARCHITECTURE behavior OF test_general IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT general
    PORT(
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
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal palanca1 : std_logic := '1';
   signal palanca2 : std_logic := '0';
   signal palanca3 : std_logic := '0';

 	--Outputs
   signal error : std_logic;
--	signal modulacion:  STD_LOGIC_VECTOR (2 downto 0);	

			 signal enable_process:  std_logic;
			  signal simboloin : std_logic_vector(2 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
	 
	function char2logic (char : character) return std_logic is
		variable ret : std_logic :='X';
	begin
		if(char='0')then
		 ret:='0';
		elsif(char='1')then
		 ret:='1';
		else
		 ret:='X';
		end if;
		return ret;
	end function char2logic;
	
	function logic2char (logic: std_logic) return character is
		variable ret: character := 'X';
	begin
		if(logic='0')then
		 ret:='0';
		elsif(logic='1')then
		 ret:='1';
		else
		 ret:='X';
		end if;
		return ret;
	end function logic2char;	
 
 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: general PORT MAP (
          clk => clk,
          reset => reset,
          palanca1 => palanca1,
          palanca2 => palanca2,
          palanca3 => palanca3,
          error => error
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		reset<='0';

      -- insert stimulus here 

      wait;
   end process;
	
-- Writing process
	write_proc: process
		file output_file: text open WRITE_MODE is "C:\SEC/salidalecturamapperDBPSK.txt";--"../parte_matlab/testEncoderOutVHDL.text";--
		variable buffer_out : LINE; -- Variable LINE para escribir la salida
		variable output : std_logic_vector(2 downto 0);--std_logic;--integer;_vector(8 downto 0)
		--variable dir_anterior : std_logic_vector(8 downto 0);
		--variable output : std_ulogic;--std_logic;--integer;
	begin
	
	wait until rising_edge(clk);
	--dir_anterior:= "010000000";   and dir_anterior/=DIR_RAM
	if( enable_process='1' ) then
		output := simboloin;--DIR_RAM;
		write(buffer_out , output);
		writeline (output_file,buffer_out);
		--dir_anterior:=DIR_RAM;
	end if;
	
	end process;


END;
