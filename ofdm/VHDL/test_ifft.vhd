--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:06:15 06/30/2015
-- Design Name:   
-- Module Name:   C:/Users/Lerial/SkyDrive/GITT/TERCERO/2SEC/proyecto2/BloqueIFFT/test_ifft.vhd
-- Project Name:  BloqueIFFT
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fourier
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
--use std.textio.all;
--use ieee.std_logic_textio.all;
--use ieee.numeric_std.all; 
--use ieee.std_logic_textio.all;
--use std.textio.all;
-- 
-- 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_ifft IS
END test_ifft;
 
ARCHITECTURE behavior OF test_ifft IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fourier
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic_vector(2 downto 0);
         numsimbolos : IN  std_logic;
         block_valid : IN  std_logic;
         data_re : IN  std_logic_vector(7 downto 0);
         data_im : IN  std_logic_vector(7 downto 0);
         direcc_re : OUT  std_logic_vector(6 downto 0);
         direcc_im : OUT  std_logic_vector(6 downto 0);
         busy : OUT  std_logic;
         edone : OUT  std_logic;
         done : OUT  std_logic;
         dv : OUT  std_logic;
         xk_index : OUT  std_logic_vector(6 downto 0);
         cpv : OUT  std_logic;
         xk_re : OUT  std_logic_vector(15 downto 0);
         xk_im : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal numsimbolos : std_logic_vector(2 downto 0) := "010";
   signal block_valid : std_logic := '0';
   signal data_re : std_logic_vector(7 downto 0) := (others => '0');
   signal data_im : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal direcc_re : std_logic_vector(6 downto 0);
   signal direcc_im : std_logic_vector(6 downto 0);
   signal busy : std_logic;
   signal edone : std_logic;
   signal done : std_logic;
   signal dv : std_logic;
   signal xk_index : std_logic_vector(6 downto 0);
   signal cpv : std_logic;
   signal xk_re : std_logic_vector(15 downto 0);
   signal xk_im : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fourier PORT MAP (
          clk => clk,
          reset => reset,
          numsimbolos => numsimbolos,
          block_valid => block_valid,
          data_re => data_re,
          data_im => data_im,
          direcc_re => direcc_re,
          direcc_im => direcc_im,
          busy => busy,
          edone => edone,
          done => done,
          dv => dv,
          xk_index => xk_index,
          cpv => cpv,
          xk_re => xk_re,
          xk_im => xk_im
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 ---------------------------------
--  signal numsimbolos : std_logic := '0';
--   signal block_valid : std_logic := '0';
--   signal data_re : std_logic_vector(7 downto 0) := (others => '0');
--   signal data_im : std_logic_vector(7 downto 0) := (others => '0');

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		wait for 100 ns;	
		reset<='0';
		block_valid<='1';
		data_re<="10000000";
		data_im<="00000001";
     

      -- insert stimulus here 

      wait;
   end process;
 
 --------------------------------------------------------------------------------
--
----Read process
--read_proc_real: process
--	file input_file: text open READ_MODE is "dbpsk.mat"; -- tiene que estar en el mismo direcotrio de trabajo 
--	variable buffer_in : LINE; -- Variable LINE para escribir la salida
--	variable input : std_logic_vector(7 downto 0);--std_logic;--integer;
--begin	
--	wait until reset = '0';
--	while not endfile(input_file) loop
--		wait until rising_edge(clk);
--		if (entrada_valida = '1'and reset = '0' ) then -- 
--		readline(input_file,buffer_in); -- Se Lee una Linea del fichero
--		read(buffer_in,input);          -- Se guarda el dato en la variable, si la linea fuera mas larga habría que seguir 
--		--contador <= contador + 1 ; 										  -- leyendo
--		data_real_int <= input ; -- MI VARIABLE ES READATA_int tu pon la tuya donde quieres guardar la entrada 
--		end if;		  
--	end loop;
--	file_close(input_file);
--	wait;
--end process;



 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 -----------------

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
