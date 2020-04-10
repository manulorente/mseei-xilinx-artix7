----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Manuel Lorente Almán - 77844874V
-- 
-- Create Date: 25.01.2020 19:28:28
-- Design Name: 
-- Module Name: FT245_IF - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity FT245_IF is
    Port ( CLK      : in STD_LOGIC;
           RESET    : in STD_LOGIC;
           WREN     : in STD_LOGIC;
           TXEN     : in STD_LOGIC;
           DIN      : in STD_LOGIC_VECTOR (7 downto 0);
           READY    : out STD_LOGIC;
           WR       : out STD_LOGIC;
           DATA     : out STD_LOGIC_VECTOR (7 downto 0));
end FT245_IF;

--    FT245_IF : entity WORK.FT245_IF
--    port map (
--      CLK     => MCLK,
--      RESET   => MRST,
--      -- User IO  
--      DIN     => UserDataIn         -- i[7:0]
--      WREN    => User_wr_en         -- i
--      READY   => User_rdy_flag      -- o
--      -- FT245-like interface 
--      TXEn    => FT245_TXEn          -- i
--      WR      => FT245_WRn           -- o
--      DATA    => FT245_D             -- o
--       );
  
architecture Behavioral of FT245_IF is
-- States definition
type state_type is (idle, wait_for_TXE, output_data, write_1, write_2, write_3); 
signal state_reg, state_next    : state_type;
-- Signals to sync asynchronous input
signal synchronizer             : STD_LOGIC_VECTOR(1 downto 0);
signal txen_sync                : STD_LOGIC;
-- Internal signals to handle outputs
signal ready_reg, ready_next    : STD_LOGIC;
signal wr_reg, wr_next          : STD_LOGIC;
signal data_reg, data_next      : STD_LOGIC_VECTOR(7 downto 0);
begin 
    -- Output logic
    WR      <= wr_reg;
    READY   <= ready_reg;
    DATA    <= data_reg;

    -- 2FF Input synchronization
    SYNC: process
    begin
        wait until CLK'EVENT and CLK = '1';
            synchronizer <= TXEn & synchronizer(1);
    end process SYNC;
    txen_sync <= synchronizer(0);
    
    -- State register
    REG: process(CLK, RESET)
    begin
        if RESET = '1' then
           state_reg    <= idle;
           wr_reg       <= '1';
           ready_reg    <= '1';
           data_reg     <= (others => '0');
        elsif (CLK'EVENT and CLK = '1') then
           state_reg    <= state_next;
           wr_reg       <= wr_next;
           ready_reg    <= ready_next;
           data_reg     <= data_next;
    end if;
    end process REG;
    
    -- Next state logic
    COMB: process(state_reg, wr_reg, ready_reg, data_reg, DIN, WREN, txen_sync)
    begin
        state_next  <= state_reg;
        wr_next     <= wr_reg;
        ready_next  <= ready_reg;
        data_next   <= data_reg;
        case state_reg is
            when idle =>  
                ready_next   <= '1';
                wr_next      <= '1';
                if WREN = '1' then
                    state_next <= wait_for_TXE;    
                end if;
            when wait_for_TXE =>  
                ready_next   <= '0';
                wr_next      <= '1';
                if txen_sync = '0' then
                    state_next <= output_data;    
                end if; 
           when output_data =>  
                ready_next  <= '0';
                wr_next     <= '1';
                data_next   <= DIN;
                state_next  <= write_1;    
           when write_1 =>  
                ready_next  <= '0';
                wr_next     <= '0';
                state_next  <= write_2;    
           when write_2 =>  
                ready_next  <= '0';
                wr_next     <= '0';
                state_next  <= write_3;   
           when write_3 =>  
                ready_next   <= '0';
                wr_next      <= '0';
                if WREN = '1' then
                    state_next <=   wait_for_TXE;  
                else
                    state_next <=   idle;
                end if;    
        end case; 
    end process COMB;
   
end Behavioral;
