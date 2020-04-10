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

entity UART is
    Generic (
    BAUD_COUNT    : INTEGER		:=27;--:= 325;	       -- Fsys/baud_rate/os_rate
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
end UART;

architecture RTL of UART is
   -- Transmitter internal signals
    signal iTX, iTX_DONE_TICK   : STD_LOGIC := '0';
    signal iTX_START, TX_START  : STD_LOGIC := '0';
    signal iDIN                 : STD_LOGIC_VECTOR(7 downto 0)  := (others =>'0');    
    -- Receiver internal signals
    signal iRX, iRX_DONE_TICK   : STD_LOGIC := '0';
    signal iDOUT                : STD_LOGIC_VECTOR(7 downto 0)  := (others =>'0');
    -- Baud rate generator internal signals
    signal S_TICK              : STD_LOGIC := '0';
begin
       
    -- Baud rate generator
    BAUDGEN: entity WORK.BAUDGENERATOR
    generic map(N => BAUD_COUNT)
    port map(
        clk     => CLK,
        reset   => RESET,
        count   => open,
        sat     => S_TICK 
    );
     
    -- Receiver block
    UART_RX: entity WORK.UART_RX
    generic map(CLKS_PER_BIT =>  OS_RATE)
    port map (
        clk             => CLK,
        reset           => RESET,
        rx              => RX,
        s_tick          => S_TICK,
        rx_done_tick    => iRX_DONE_TICK,
        dout            => iDOUT
    );
    
    -- Transmitter block
    UART_TX: entity WORK.UART_TX
    generic map(CLKS_PER_BIT =>  OS_RATE)
    port map (
        clk             => CLK,
        reset           => RESET,
        tx              => TX,
        tx_start        => TX_START,
        s_tick          => S_TICK,
        tx_done_tick    => iTX_DONE_TICK,
        din             => iDIN
    ); 
    
    FIFO_RX: entity WORK.FIFO  --16x8
    generic map(
        B   =>  4,
        W   =>  8)     
    port map (
        CLK     => CLK,
        RST     => RESET,
        DIN     => iDOUT,  
        POP     => RD_UART,
        PUSH    => iRX_DONE_TICK,
        DOUT    => R_DATA, 
        EMPTY   => RX_EMPTY,
        FULL    => open
    ); 
    
    FIFO_TX: entity WORK.FIFO   --16x8
    generic map(
        B   =>  4,
        W   =>  8)   
    port map (
        CLK     => CLK,
        RST     => RESET,
        DIN     => W_DATA,  
        POP     => iTX_DONE_TICK,
        PUSH    => WR_UART,
        DOUT    => iDIN, 
        EMPTY   => iTX_START,
        FULL    => TX_FULL
    );   
    TX_START <= not iTX_START;
    
end RTL;
