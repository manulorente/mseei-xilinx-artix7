----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Manuel Lorente Alman - 77844874V
-- 
-- Create Date: 01/22/2020 12:18:55 PM
-- Design Name: 
-- Module Name: FIFO - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;    -- Síntesis.   [Xilinx]. Operador de suma '+'

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is
    Generic (
        -- Internal RAM address bus width
        B: NATURAL := 6;
        -- DIN y DOUT data bus width
        W: NATURAL := 8 );
    Port ( CLK      : in STD_LOGIC;
           RST      : in STD_LOGIC;
           DIN      : in STD_LOGIC_VECTOR (W-1 downto 0);
           PUSH     : in STD_LOGIC;
           POP      : in STD_LOGIC;
           FULL     : out STD_LOGIC;
           DOUT     : out STD_LOGIC_VECTOR (W-1 downto 0);
           EMPTY    : out STD_LOGIC);
end FIFO;

architecture Behavioral of FIFO is
    -- RAM memory component inernal signals
	type memory is array((2**B)-1 downto 0) of STD_LOGIC_VECTOR(W-1 DOWNTO 0);  -- RAM memory data type
    signal ram          :   memory;	                                            -- RAM memory instance
    signal rptr         :   INTEGER range 0 to (2**B)-1 := 0;  	                -- RAM read address pointer
    signal wptr         :   INTEGER range 0 to (2**B)-1 := 0;  	                -- RAM write address pointer
    signal wr_en        :   STD_LOGIC;                                          -- RAM memory write enable
    signal rd_en        :   STD_LOGIC;                                          -- RAM memory read enable
    -- Control logic internal signals
    signal fifo_full    :   STD_LOGIC;                                          -- FIFO full flag
    signal fifo_empty   :   STD_LOGIC;                                          -- FIFO empty flag
    signal nopush, nopop:   STD_LOGIC;                                          -- PUSH/POP concurrence control
    -- Status logic internal signals
    signal words        :   INTEGER range 0 to (2**B) := 0;                     -- Number of housed words 
begin
    ----------------------------------------------------------------------
    -- RAM memory block
    ----------------------------------------------------------------------
    DOUT <= ram(rptr);                -- Read port at once    
	LUTRAM:process
    begin
        wait until rising_edge(CLK);
        if(wr_en = '1') then            -- Write port at 1xTclk
            ram(wptr) <= DIN; 
        end if;        
    end process;
    
    ----------------------------------------------------------------------
    -- Control logic block
    ----------------------------------------------------------------------
    -- Read/write enable control - Readout prority
    wr_en <= '1' when (nopush = '0') else '0';  
    rd_en <= '1' when (nopop = '0') else '0';  
    CONTROL:process
    begin
        wait until rising_edge(CLK);
        -- Synchronous reset
        if (RST = '1') then
            rptr <= 0;
            wptr <= 0;
            nopush <= '1';
            nopop <= '1';
        else
            -- Write/read pointers update 
            if rd_en ='1' then rptr <= rptr + 1; end if;
            if wr_en ='1' then wptr <= wptr + 1; end if;
            
            -- Close circular buffer
            if rptr = (2**B)-1 then rptr <= 0; end if;
            if wptr = (2**B)-1 then wptr <= 0; end if;
            
            -- Set and test control
            if (POP = '0' and PUSH = '0') then -- no operation
                nopush <= '1';
                nopop <= '1';
            elsif (POP = '0' and PUSH = '1') then -- push only --
                nopop <= '1';
                if (fifo_full = '0') then   -- valid write condition
                    nopush <= '0';
                else                        -- no write condition
                    nopush <= '1';
                end if;
             elsif (POP = '1' and PUSH = '0') then -- pop only
                nopush <= '1';
                if (fifo_empty = '0') then  -- valid read condition
                    nopop <= '0';
                else
                    nopop <= '1';           -- no read condition
                end if;
             else -- push and pop at same time –
                if (fifo_empty = '0') then  -- valid read condition
                    nopush <= '1';
                    nopop <= '0';               
                else                        -- valid write condition
                    nopush <= '0';
                    nopop <= '1';
                end if;
             end if;
         end if;       
    end process;
            
    ----------------------------------------------------------------------
    -- Logic state block
    ----------------------------------------------------------------------
    -- Update FIFO status pending on number of stored words
    fifo_empty <= '1' when (words = 0) else '0';  
    fifo_full <= '1' when (words = (2**B)) else '0';
    STATUS:process
    begin
        wait until rising_edge(CLK);
        -- Synchronous reset
        if (RST = '1') then
            words <= 0;
        else
            -- UP/DOWN counter
            if (wr_en = '1') and (rd_en = '0') and (words /= (2**B)) then
                words <= words + 1;
            elsif (rd_en = '1') and (wr_en = '0') and (words /= 0) then
                words <= words - 1;        
            else
                words <= words;
            end if;
        end if;
    end process;
    -- Connect ouput signals
    FULL <= fifo_full;
    EMPTY <= fifo_empty;   
    
end Behavioral;
