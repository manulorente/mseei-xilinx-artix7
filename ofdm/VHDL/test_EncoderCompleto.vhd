--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:23:26 07/01/2015
-- Design Name:   
-- Module Name:   C:/Users/Lerial/SkyDrive/GITT/TERCERO/2SEC/proyecto2/PrimerBloque/test_EncoderCompleto.vhd
-- Project Name:  PrimerBloque
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EncoderCompleto
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
--USE ieee.numeric_std.ALL;
 
ENTITY test_EncoderCompleto IS
END test_EncoderCompleto;
 
ARCHITECTURE behavior OF test_EncoderCompleto IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EncoderCompleto
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         palanca1 : IN  std_logic;
         palanca2 : IN  std_logic;
         palanca3 : IN  std_logic;
         error : OUT  std_logic;
         modulacion : OUT  std_logic_vector(2 downto 0);
         ackCodConv : OUT  std_logic;
         dataout_CodConv : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal palanca1 : std_logic := '0';
   signal palanca2 : std_logic := '0';
   signal palanca3 : std_logic := '1';

 	--Outputs
   signal error : std_logic;
   signal modulacion : std_logic_vector(2 downto 0);
   signal ackCodConv : std_logic;
   signal dataout_CodConv : std_logic;

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
   uut: EncoderCompleto PORT MAP (
          clk => clk,
          reset => reset,
          palanca1 => palanca1,
          palanca2 => palanca2,
          palanca3 => palanca3,
          error => error,
          modulacion => modulacion,
          ackCodConv => ackCodConv,
          dataout_CodConv => dataout_CodConv
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

   end process;
	
	  
	
	
-- Writing process
	write_proc: process
		file output_file: text open WRITE_MODE is "C:\SEC/salidaEncoderD8PSK.txt";--"../parte_matlab/testEncoderOutVHDL.text";--
		variable buffer_out : LINE; -- Variable LINE para escribir la salida
		variable output : std_logic;--std_logic;--integer;
		--variable output : std_ulogic;--std_logic;--integer;
	begin
	
	wait until falling_edge(clk);
	
	if(ackCodConv = '1') then
		output := dataout_CodConv;--data_out;
		write(buffer_out , output);
		writeline (output_file,buffer_out);
	end if;
	
	end process;
	


END;
