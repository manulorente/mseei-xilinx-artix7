----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Manuel Lorente Alm�n - 77844874V
-- 
-- Create Date: 01/15/2020 05:39:09 PM
-- Design Name: 
-- Module Name: CD4RE - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Creaed
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity CD4RE is
    Port ( C : in STD_LOGIC;
           R : in STD_LOGIC;
           CE : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (3 downto 0);
           TC : out STD_LOGIC;
           CEO : out STD_LOGIC);
end CD4RE;

architecture Behavioral of CD4RE is
    signal Qr: unsigned(3 downto 0);   
begin
    process -- reset y actualizacion del registro
    begin
        wait until rising_edge(C);
            if R = '1' then     -- reseteo el contador
                Qr <= (others => '0');
            else  -- incremento el contador
                if Qr = 9 then
                    Qr <= (others => '0');
                else
                    -- logica de estado siguiente
                    if CE = '1' then
                        Qr  <= Qr + 1;
                    else
                        Qr <= Qr;
                    end if;
                end if;
            end if;
    end process;
	
    -- conexion hacia fuera
    Q   <= std_logic_vector(Qr); 
      
    -- logica de salida
    TC  <= '1' when Qr = 9 else '0';
    CEO <= Qr(3) and not Qr(2) and not Qr(1) and Qr(0) and CE;
    
end Behavioral;
