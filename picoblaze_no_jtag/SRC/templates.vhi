  --
  -- Signals for connection of KCPSM6 and Program Memory.
  --

  signal         address : std_logic_vector(11 downto 0);
  signal     instruction : std_logic_vector(17 downto 0);
  signal     bram_enable : std_logic;
  signal         in_port : std_logic_vector(7 downto 0);
  signal        out_port : std_logic_vector(7 downto 0);
  signal         port_id : std_logic_vector(7 downto 0);
  signal    write_strobe : std_logic;
  signal  k_write_strobe : std_logic;
  signal     read_strobe : std_logic;
  signal       interrupt : std_logic;
  signal   interrupt_ack : std_logic;
  signal    kcpsm6_sleep : std_logic;
  signal    kcpsm6_reset : std_logic;


  --
  -----------------------------------------------------------------------------------------
  -- Instantiate KCPSM6 and connect to Program Memory
  -----------------------------------------------------------------------------------------
  --
  -- The KCPSM6 generics can be defined as required but the default values are shown below
  -- and these would be adequate for most designs.
  --

  processor: entity work.kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
				  
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
  --
  -- Program rom with JTAG Loader
  --
  program_rom: <your_program>                    --Name to match your PSM file
    generic map(             C_FAMILY => "V6",   --Family 'S6', 'V6' or '7S'
                    C_RAM_SIZE_KWORDS => 2,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 1)      --Include JTAG Loader when set to '1' 
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);

  --
  -- Program rom without JTAG Loader
  --
					   
  program_rom: <your_program>                    --Name to match your PSM file
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       clk => clk);
