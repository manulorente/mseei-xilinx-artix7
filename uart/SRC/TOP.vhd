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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
    Generic (
    BAUD_COUNT    : INTEGER		:= 325;	       -- Fsys/baud_rate/os_rate
	OS_RATE		  :	INTEGER		:= 16			--oversampling rate to find center of receive bits (in samples per baud period)     
     );
    Port (
    CLK     : in STD_LOGIC;
    RESET   : in STD_LOGIC;
    RX      : in STD_LOGIC;
    RD_UART : in STD_LOGIC;
    WR_UART : in STD_LOGIC;
    W_DATA  : in STD_LOGIC_VECTOR(7 downto 0);
    TX      : out STD_LOGIC;
    TX_FULL : out STD_LOGIC;
    RX_EMPTY: out STD_LOGIC;
    R_DATA  : out STD_LOGIC_VECTOR(7 downto 0)    
    );
end TOP;

architecture BEHAVIORAL of TOP is
    -- MMCM internal signals
    signal MCLK, GRST, LOCKED   : STD_LOGIC := '0';
    signal wire                 : STD_LOGIC;
begin

    -- MMCM module to generate common 50MHz clock
    MMCM0: entity WORK.clk_wiz
    port map (
        clk_in      => CLK,
        reset       => RESET,
        clk_out     => MCLK,    -- 50MHz
        locked      => LOCKED
    );
    GRST <= not LOCKED;
       
    -- UART instance
    UART: entity WORK.UART
    generic map(
        BAUD_COUNT => BAUD_COUNT,
        OS_RATE => OS_RATE)
    port map(
        CLK         => MCLK,  
        RESET       => GRST,
        RX          => wire,
        RD_UART     => RD_UART,
        WR_UART     => WR_UART,
        W_DATA      => W_DATA,
        TX          => wire,
        TX_FULL     => TX_FULL,
        RX_EMPTY    => RX_EMPTY,
        R_DATA      => R_DATA
    );
   
end BEHAVIORAL;
