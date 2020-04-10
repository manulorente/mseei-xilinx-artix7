library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXIS_probe is
	port (
		-- Users to add ports here
		SOF : out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line
		aclk	: in std_logic;
		aresetn	: in std_logic;
		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_tready	: out std_logic;
		s00_axis_tdata	: in std_logic_vector(23 downto 0);
		s00_axis_tuser	: in std_logic;
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic;
		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(23 downto 0);
		m00_axis_tuser	: out std_logic;
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic
	);
end AXIS_probe;

architecture arch_imp of AXIS_probe is

signal SOFi: std_logic := '0' ;
signal tuser: std_logic;

begin

	tuser <= s00_axis_tuser;
	
	m00_axis_tvalid <= s00_axis_tvalid;
	m00_axis_tuser  <= tuser;
	m00_axis_tlast  <= s00_axis_tlast;
	m00_axis_tdata  <= s00_axis_tdata;
    s00_axis_tready <= m00_axis_tready;

	-- User logic ends
	process 
	begin
		wait until rising_edge(aclk);
		if m00_axis_tready='1' and s00_axis_tvalid='1' and s00_axis_tuser='1' then
		SOFi <= '1';
		else 
		SOFi <= '0';
		end if;
	end process;
	SOF <= SOFi;
	

end arch_imp;
