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
-- Description: HEX7SEG conversor with comb processes
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

entity BAUDGENERATOR is
    Generic (
    -- Valor maximo de la cuenta del contador FREE-RUNNING
    N : integer := 9600);
    Port (
    -- Clock Input
	CLK			: in STD_LOGIC;
	RESET		: in STD_LOGIC;
    COUNT     	: out INTEGER range 0 to N-1;
    SAT      	: out STD_LOGIC);
end BAUDGENERATOR;

architecture RTL of BAUDGENERATOR is
    -- Señales internas auxiliares para contador free running
    signal Q_reg, Q_next            : INTEGER range 0 to N-1;
begin
    process(CLK)
    begin
        if (CLK'event and CLK='1') then
            if Q_reg = N-1 or RESET = '1' then
                Q_next <= 0;
            else
                Q_next <= Q_next + 1;
            end if;
        end if;
    end process;
    Q_reg <= Q_next;
	
	COUNT <= Q_reg;
    SAT   <= '1' when Q_reg = N-1 else '0'; 
  
end RTL;
