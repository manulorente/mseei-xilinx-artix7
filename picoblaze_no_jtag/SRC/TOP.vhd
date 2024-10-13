----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Manuel Lorente Alman - 77844874V
-- 
-- Create Date: 15.01.2020 21:58:48
-- Design Name: 
-- Module Name: TOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: PicoBlaze (PB) control
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
    Port (
        CLK : in    STD_LOGIC;
        SW  : in    STD_LOGIC_VECTOR(7 downto 0);
        LED : out   STD_LOGIC_VECTOR(7 downto 0));
end TOP;

architecture BEHAVIORAL of TOP is
    -- MMCM internal signals
    signal MCLK, MRST, LOCKED	: STD_LOGIC;
    -- PB internal signals
	signal address 				: STD_LOGIC_VECTOR(11 downto 0);
	signal instruction 			: STD_LOGIC_VECTOR(17 downto 0);
	signal bram_enable 			: STD_LOGIC;
	signal in_port 				: STD_LOGIC_VECTOR(7 downto 0);
	signal out_port 			: STD_LOGIC_VECTOR(7 downto 0);
	signal port_id 				: STD_LOGIC_VECTOR(7 downto 0);
	signal write_strobe 		: STD_LOGIC;
	signal k_write_strobe 		: STD_LOGIC;
	signal read_strobe 			: STD_LOGIC;
	signal interrupt 			: STD_LOGIC;
	signal interrupt_ack 		: STD_LOGIC;
	signal kcpsm6_sleep 		: STD_LOGIC;
	signal kcpsm6_reset 		: STD_LOGIC;
	-- Internal register signals
	signal Q_reg, Q_next		: STD_LOGIC_VECTOR(7 downto 0);
begin
    -- Switches LSB connected to PB in_port
    in_port             <= 	SW(7 downto 0);
    
    -- PB out_port connected to 8 first LEDS
    LED(7 downto 0)     <=  Q_reg; 
    
    -- PB reset and sleep unconnected
    kcpsm6_reset        <= '0';
    kcpsm6_sleep        <= '0';
	
	-- Internal 8b register
	REG: process(MCLK)
	begin
        if (MCLK'event and MCLK = '1') then
            if write_strobe = '1' then
                Q_next 	<= out_port;
            else
                Q_next <= Q_reg;
            end if;
        end if;	
	end process REG;
	Q_reg <= Q_next;
      
    -- MMCM module to generate common 50MHz clock
    MMCM0: entity WORK.clk_wiz
    port map (
        clk_in      => CLK,     -- 100MHz
        reset       => MRST,    -- Master reset
        clk_out     => MCLK,    -- 50MHz
        locked      => LOCKED   -- PLL locked
    );

	-- PicoBlaze instance
    PROCESSOR: entity WORK.kcpsm6
	generic map (   
        hwbuild 				=> x"00", 
        interrupt_vector 		=> x"3FF",
        scratch_pad_memory_size => 64)
    port map(
		-- Inputs
		instruction 		=>	instruction,
		in_port 			=>	in_port,
		interrupt			=>	interrupt,
		sleep 				=>	kcpsm6_sleep,
        reset 				=>	kcpsm6_reset,
        clk					=>	MCLK,
		-- Outputs
		bram_enable 		=>	bram_enable,
        address 			=> 	address,
        out_port 			=>	out_port,
        write_strobe		=>	write_strobe,
        read_strobe 		=>	read_strobe,
        k_write_strobe		=>	k_write_strobe,
		port_id				=>	port_id,
        interrupt_ack		=>	interrupt_ack);

	-- Program rom without JTAG Loader						   
	PROGRAM_ROM: entity WORK.sio_rom  
	generic map(
	   C_FAMILY                => "7S",
	   C_RAM_SIZE_KWORDS       => 2,
	   C_JTAG_LOADER_ENABLE    => 1)                 
    port map(      
        address     => address,      
        instruction => instruction,
        enable      => bram_enable,
        rdl         => kcpsm6_reset, 
        clk         => MCLK);
                
end BEHAVIORAL;
