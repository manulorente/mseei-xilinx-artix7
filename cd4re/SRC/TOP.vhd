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

entity TOP is
    Generic (
    -- Valor maximo de la cuenta del contador FREE-RUNNING = 2^23 a 50MHz (MCLK) para que el digito cambie cada 1/10 segundo
    N : NATURAL := 5000000);
    Port (
    -- Clock Input 100MHz
    CLK     : in STD_LOGIC;
    SW      : in STD_LOGIC_VECTOR (15 downto 0);
    BTN     : in STD_LOGIC_VECTOR (4 downto 0);
    CAT     : out STD_LOGIC_VECTOR (7 downto 0);
    AN      : out STD_LOGIC_VECTOR (3 downto 0));
end TOP;

architecture BEHAVIORAL of TOP is
    -- Señales internas auxiliares para conectar bloques
    signal DDi                      : STD_LOGIC_VECTOR (15 downto 0);
    signal r_reg, r_next            : NATURAL range 0 to N-1;
    signal Q0, Q1, Q2, Q3           : STD_LOGIC_VECTOR(3 downto 0);
    signal BTN1_debounced          	: STD_LOGIC;
    signal CEN, MCLK, LOCKED, GRST  : STD_LOGIC;
    signal Q0_Q1_en, CONT_en        : STD_LOGIC;
begin
    -- Módulo MMCM para generar señal de reloj a 50MHz
    MMCM0: entity WORK.clk_wiz
    port map (
        clk_in      => CLK,
        reset       => BTN(0),
        clk_out     => MCLK,    -- 50MHz
        locked      => LOCKED
    );
    
    -- Contador binario para decimas de segundo
    BCD0: entity WORK.CD4RE
    port map (
    	-- Señal de reloj viene a 50MHz del bloque MMCM
        C   => MCLK,
        R   => GRST,
        CE  => CEN,
        Q   => Q0,
        TC  => open,
        CEO => Q0_Q1_en
    );
    
    -- Contador binario para unidades de segundo
    BCD1: entity WORK.CD4RE
    port map (
        -- Señal de reloj viene a 50MHz del bloque MMCM
        C   => MCLK,
        R   => GRST,
        CE  => Q0_Q1_en,
        Q   => Q1,
        TC  => open,
        CEO => open
    );    

    -- Contador binario digito 3
    BCD2: entity WORK.CD4RE
    port map (
    	-- Señal de reloj viene a 50MHz del bloque MMCM
        C   => MCLK,
        R   => BTN1_debounced,
        CE  => CONT_en,
        Q   => Q2,
        TC  => open,
        CEO => open
    );
    
    -- Contador binario digito 4
    BCD3: entity WORK.CD4RE
    port map (
        -- Señal de reloj viene a 50MHz del bloque MMCM
        C   => MCLK,
        R   => BTN1_debounced,
        CE  => CONT_en,
        Q   => Q3,
        TC  => open,
        CEO => open
    );
    
    EDGE :entity WORK.EDGE_DETECT
      port map (
       C        => MCLK,
       level    => SW(0),       --in
       tick     => CONT_en      --out
      );
    

    DEBOUNCE1 : entity WORK.DEBOUNCE
    port map (
        C  => MCLK,
        R  => GRST,
        SW => BTN(1),               --input
        DB => BTN1_debounced         --debounced output
       );
                        
    -- Proceso síncrono para la cuenta Free running
    FREERUN: process(MCLK)
    begin
        if (MCLK'event and MCLK='1') then
            if r_reg = N-1 then
                r_next <= 0;
            else
                r_next <= r_next + 1;
            end if;
        end if;
    end process;
    r_reg   <=  r_next;
    
    DISPLAY: entity WORK.DISPLAY
        Port Map(
            C   => MCLK,        -- CLK=50MHz
            DD  => DDi,         -- i(15:0)  DD(15:12)=D3 ... DD(3:0)=D0
            DP  => "1101",      -- i(3:0)   DotPoint DP3=izda ... DP0=dcha        
            CAT => CAT,         -- o(7:0)   CAT(7)=DP, CAT(6)=CG, CAT(0)=CA
            AN  => AN           -- o(3:0)   AN3=izda ... AN00dcha
         );

    -- Conectamos todas las salidas de los contadores a la entrada del display
    DDi <= Q3 & Q2 & Q1 & Q0;

    -- Reset del contador BCD controlado por locked del MMCM
    GRST <= not LOCKED;
	
	-- Señal que se activa durante un ciclo cada vez que el free running satura
	CEN <= '1' when r_reg = N-1 else '0';

end BEHAVIORAL;
