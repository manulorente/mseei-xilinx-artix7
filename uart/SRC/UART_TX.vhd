library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity UART_TX is
  generic (
    CLKS_PER_BIT : integer := 16);
  port (
    CLK       		: in  	std_logic;
	RESET			: in 	std_logic;
    S_TICK     		: in  	std_logic;
    DIN   			: in  	std_logic_vector(7 downto 0);
	TX_START		: in 	std_logic;
    TX 				: out 	std_logic;
    TX_DONE_TICK   	: out 	std_logic);
end UART_TX;
 
architecture RTL of UART_TX is
	type state_type is (idle, start, data, stop, clean);
	signal state_reg, state_next: state_type := idle;
	signal clk_count : integer range 0 to CLKS_PER_BIT-1 := 0;
	signal tx_done   : std_logic := '0';
	signal tx_data   : std_logic_vector(7 downto 0) := (others => '0');
	signal bit_index : integer range 0 to 7 := 0;  -- 8 Bits Total
begin

	-- FSMD state & data registers
	process(CLK, RESET)
	begin
	  if RESET='1' then
		 state_reg <= idle;
	  elsif (CLK'event and CLK='1') then
		 state_reg <= state_next;
	  end if;
	end process;
 
	-- next-state logic & data path functional units/routing   
	process (state_reg,S_TICK , TX_START)
	begin
		state_next <= state_reg;
		tx_done <='0';
         
		case state_reg is
			when idle =>
			  TX 		<= '1';         -- Drive Line High for Idle
			  tx_done   <= '0';
			  clk_count <= 0;
			  bit_index <= 0;
			  tx_data	<= (others =>'0');
			  if S_TICK = '1' and TX_START = '1' then
				tx_data 	<= DIN;
				state_next 	<= start;
			  else
				state_next 	<= idle;
			  end if;
			  
			-- Send out Start Bit. Start bit = 0
			when start =>
			  TX <= '0';
			  -- Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
			  if clk_count < CLKS_PER_BIT-1 then
				clk_count 	<= clk_count + 1;
				state_next  <= start;
			  else
				clk_count 	<= 0;
				state_next  <= data;
			  end if;
			   
			-- Wait CLKS_PER_BIT-1 clock cycles for data bits to finish          
			when data =>
			  TX <= tx_data(bit_index); 
			  if clk_count < CLKS_PER_BIT-1 then
				clk_count 	<= clk_count + 1;
				state_next  <= data;
			  else
				clk_count <= 0;
				-- Check if we have sent out all bits
				if bit_index < 7 then
				  bit_index 	<= bit_index + 1;
				  state_next  	<= data;
				else
				  bit_index 	<= 0;
				  state_next   	<= stop;
				end if;
			  end if;

			-- Send out Stop bit.  Stop bit = 1
			when stop =>
			  TX<= '1';
			  -- Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
			  if clk_count < CLKS_PER_BIT-1 then
				clk_count 	<= clk_count + 1;
				state_next  <= stop;
			  else
				tx_done   	<= '1';
				clk_count 	<= 0;
				state_next  <= clean;
			  end if;

			-- Stay here 1 clock   
			when others =>
			  TX <= '0';
			  tx_done   <= '1';			
			  state_next <= idle;
	 
		  end case;
	end process;
 
	TX_DONE_TICK <= tx_done;
   
end RTL;