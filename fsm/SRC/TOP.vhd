----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Manuel Lorente Alman - 77844874V
-- 
-- Create Date: 12.01.2020 18:41:44
-- Design Name: Finite State Machine
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port ( 
        CLK :   in STD_LOGIC;
        BTN :   in STD_LOGIC_VECTOR (4 downto 0);
        LED :   out STD_LOGIC_VECTOR (15 downto 0);
        CAT : out STD_LOGIC_VECTOR (7 downto 0);
        AN  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end TOP;

architecture Behavioral of TOP is
    -- alias
    alias RST:  STD_LOGIC is BTN(0);
    alias A:    STD_LOGIC is BTN(4);
    alias B:    STD_LOGIC is BTN(2);
    alias Y0:   STD_LOGIC is LED(0); -- Salida Mealy
    alias Y1:   STD_LOGIC is LED(1); -- Salida Moore
    alias LED_s0: STD_LOGIC is LED(5);
    alias LED_s1: STD_LOGIC is LED(6);
    alias LED_s2: STD_LOGIC is LED(7);
    
    -- declaraciones modelo FSM
    type STATES is (s0, s1, s2);
    signal state_reg, state_next: STATES;   
         
begin
    CAT <= (others => '1');
    AN <= (others => '1');
    LED(15 downto 8) <=  (others => '0');
    LED(4 downto 2) <=  (others => '0');
   
    -- state register
    process
    begin
        wait until CLK'event and CLK='1';
        if RST='1' then 
            state_reg <= s0;
        else            
            state_reg <= state_next;
        end if;
    end process;
    
    -- next state logic
    process (state_reg, A, B)
    begin
    state_next <= state_reg;
        case state_reg is
            when s0 =>
                if (A and not B) = '1' then
                    state_next <= s1;
                elsif (A and B) = '1' then
                    state_next <= s2;
                else 
                     state_next <= s0;                                   
                end if;
            when s1 =>
                if A='1' then
                    state_next <= s0;
                end if;
            when others =>
                state_next <= s0;           
        end case;
    end process;
    
    -- Moore output logic
        -- LED(5) se encenderá cuando estamos en el estado S0.
        -- LED(6) se encenderá cuando estamos en el estado S1.
        -- LED(7) se encenderá cuando estamos en el estado S2.
        -- El resto de LED no se utilizan
    process (state_reg)
    begin
        case state_reg is
            when s0 =>
                Y1 <= '1';
                LED_s0 <=  '1';
                LED_s1 <=  '0';
                LED_s2 <=  '0';
            when s1 =>
                Y1 <= '1';
                LED_s0 <=  '0';
                LED_s1 <=  '1';
                LED_s2 <=  '0';            
            when others =>
                Y1 <= '0';
                LED_s0 <=  '0';
                LED_s1 <=  '0';
                LED_s2 <=  '1';  
        end case;
    end process;
    -- Mealy output logic
    process (state_reg, A, B)
    begin
        Y0 <= '0';
        if state_reg = s0 then
            if (A and B) = '1' then
                Y0 <= '1';
            end if;
        end if;           
    end process;

end Behavioral;
