-- Listing 6.7
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interval_counter is
--  generic (CLK_MS_COUNT: integer := 50000 ); -- 50000 = 1 ms para clk=50MHz
  port(
    clk, resetn: in std_logic;
    start, t1, t2: in std_logic;

--    done_tick: out std_logic;
    prd: out std_logic_vector(31 downto 0);
    STATE : out std_logic_vector(3 downto 0);
    ready: out std_logic
  );
end interval_counter;

architecture arch of interval_counter is
  constant CLK_MS_COUNT : NATURAL := 1;
   type state_type is (idle, waite, count, done);
   signal state_reg, state_next: state_type;
   signal t_reg, t_next: unsigned(31 downto 0); -- up to 50000
   signal p_reg, p_next: unsigned(31 downto 0);  -- up to 1 sec
begin
   -- state and data register
   process(clk,resetn)
   begin
      if resetn='0' then
         state_reg <= idle;
         t_reg <= (others=>'0');
         p_reg <= (others=>'0');
      elsif (clk'event and clk='1') then
         state_reg <= state_next;
         t_reg <= t_next;
         p_reg <= p_next;
      end if;
   end process;

   process(start,t1,t2,state_reg,t_reg,p_reg)
   begin
      ready <= '0';
--      done_tick <= '0';
      state_next <= state_reg;
      p_next <= p_reg;
      t_next <= t_reg;
      case state_reg is
         when idle =>
            ready <= '1';
            if (start='1') then
               state_next <= waite;
            end if;
         when waite => -- wait for the first edge
            if (t1='1') then
               state_next <= count;
               t_next <= (others=>'0');
               p_next <= (others=>'0');
            end if;
         when count =>
            if (t2='1') then   -- 2nd edge arrived
               state_next <= done;
               p_next <= p_reg + 1;

            else -- otherwise count
               if t_reg = CLK_MS_COUNT-1 then -- 1ms tick
                  t_next <= (others=>'0');
                  p_next <= p_reg + 1;
               else
                  t_next <= t_reg + 1;
               end if;
            end if;
         when done =>
--            done_tick <= '1';
            state_next <= idle;
      end case;
   end process;

--   prd <= std_logic_vector(p_reg(7 downto 0)& t_reg(15 downto 8));
   
   prd <= std_logic_vector(p_reg(31 downto 0));
   
   with state_reg select
   STATE <= "0001" when idle,
            "0010" when waite,
            "0100" when count,
            "1000" when others;
   
   
end arch;


--  Int_count_inst_0 : entity interval_counter 
--    generic map (CLK_MS_COUNT => 50000 ) -- 50000 = 1 ms para clk=50MHz
--    port map(
--      clk       => ,
--      reset     => ,
--      start     => ,
--      t1        => ,
--      t2        => ,
--      STATE     => ,
--      ready     => , 
--      done_tick => ,
--      prd       =>
--   );
