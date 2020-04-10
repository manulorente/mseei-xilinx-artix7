-------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    FIFO - BlackBox
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- INSTANCE TEMPLATE ----------------------------------------------------------
-------------------------------------------------------------------------------

--your_instance_name : entity FIFO(BlackBox)  --16x8
--port map (
--  CLK   => clk_,
--  SRST  => RST_,
--  DIN   => din_,    --in  (7:0)
--  RD_EN => POP_,
--  WR_EN => PUSH_,
--  DOUT  => dout_,   --out (7:0)
--  EMPTY => empty_,
--  FULL  => full_,
--  WORDS => 
--);
--

-------------------------------------------------------------------------------
-- MODEL ----------------------------------------------------------------------
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FIFO is
  port(
    CLK   : in  STD_LOGIC;
    SRST  : in  STD_LOGIC;
    DIN   : in  STD_LOGIC_VECTOR (7 downto 0); 
    WR_EN : in  STD_LOGIC;
    RD_EN : in  STD_LOGIC;
    DOUT  : out STD_LOGIC_VECTOR (7 downto 0); 
    EMPTY : out STD_LOGIC;
    FULL  : out STD_LOGIC;
    WORDS : out STD_LOGIC_VECTOR (4 DOWNTO 0) 
  );
end FIFO;



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- NO MODIFICAR ---------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

architecture BlackBox of FIFO is
  signal CONT_and0000 : STD_LOGIC; 
  signal CONT_not0001 : STD_LOGIC; 
  signal NlwRenamedSig_OI_E : STD_LOGIC; 
  signal E_mux0000 : STD_LOGIC; 
  signal E_not0001 : STD_LOGIC; 
  signal E_not000112_31 : STD_LOGIC; 
  signal N12 : STD_LOGIC; 
  signal N14 : STD_LOGIC; 
  signal N15 : STD_LOGIC; 
  signal N16 : STD_LOGIC; 
  signal N17 : STD_LOGIC; 
  signal N18 : STD_LOGIC; 
  signal N5 : STD_LOGIC; 
  signal POPe : STD_LOGIC; 
  signal PUSHe : STD_LOGIC; 
  signal Result_0_1 : STD_LOGIC; 
  signal Result_0_2 : STD_LOGIC; 
  signal Result_1_1 : STD_LOGIC; 
  signal Result_1_2 : STD_LOGIC; 
  signal Result_2_1 : STD_LOGIC; 
  signal Result_2_2 : STD_LOGIC; 
  signal Result_3_1 : STD_LOGIC; 
  signal Result_3_2 : STD_LOGIC; 
  signal NLW_Mram_RAM1_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mram_RAM2_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mram_RAM3_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mram_RAM4_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mram_RAM5_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mram_RAM8_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mram_RAM6_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mram_RAM7_SPO_UNCONNECTED : STD_LOGIC; 
  signal NlwRenamedSig_OI_CONT : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal ESC : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal LEC : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal Mcount_CONT_cy : STD_LOGIC_VECTOR ( 1 downto 1 ); 
  signal Mcount_CONT_lut : STD_LOGIC_VECTOR ( 3 downto 2 ); 
  signal Result : STD_LOGIC_VECTOR ( 4 downto 0 ); 
begin
  EMPTY <= NlwRenamedSig_OI_E;
  FULL <= NlwRenamedSig_OI_CONT(4);
  WORDS(4) <= NlwRenamedSig_OI_CONT(4);
  WORDS(3) <= NlwRenamedSig_OI_CONT(3);
  WORDS(2) <= NlwRenamedSig_OI_CONT(2);
  WORDS(1) <= NlwRenamedSig_OI_CONT(1);
  WORDS(0) <= NlwRenamedSig_OI_CONT(0);
  E : FDSE
    port map (
      C => CLK,
      CE => E_not0001,
      D => E_mux0000,
      S => SRST,
      Q => NlwRenamedSig_OI_E
    );
  Mram_RAM1 : RAM16X1D
    port map (
      A0 => ESC(0),
      A1 => ESC(1),
      A2 => ESC(2),
      A3 => ESC(3),
      D => DIN(0),
      DPRA0 => LEC(0),
      DPRA1 => LEC(1),
      DPRA2 => LEC(2),
      DPRA3 => LEC(3),
      WCLK => CLK,
      WE => PUSHe,
      SPO => NLW_Mram_RAM1_SPO_UNCONNECTED,
      DPO => DOUT(0)
    );
  Mram_RAM2 : RAM16X1D
    port map (
      A0 => ESC(0),
      A1 => ESC(1),
      A2 => ESC(2),
      A3 => ESC(3),
      D => DIN(1),
      DPRA0 => LEC(0),
      DPRA1 => LEC(1),
      DPRA2 => LEC(2),
      DPRA3 => LEC(3),
      WCLK => CLK,
      WE => PUSHe,
      SPO => NLW_Mram_RAM2_SPO_UNCONNECTED,
      DPO => DOUT(1)
    );
  Mram_RAM3 : RAM16X1D
    port map (
      A0 => ESC(0),
      A1 => ESC(1),
      A2 => ESC(2),
      A3 => ESC(3),
      D => DIN(2),
      DPRA0 => LEC(0),
      DPRA1 => LEC(1),
      DPRA2 => LEC(2),
      DPRA3 => LEC(3),
      WCLK => CLK,
      WE => PUSHe,
      SPO => NLW_Mram_RAM3_SPO_UNCONNECTED,
      DPO => DOUT(2)
    );
  Mram_RAM4 : RAM16X1D
    port map (
      A0 => ESC(0),
      A1 => ESC(1),
      A2 => ESC(2),
      A3 => ESC(3),
      D => DIN(3),
      DPRA0 => LEC(0),
      DPRA1 => LEC(1),
      DPRA2 => LEC(2),
      DPRA3 => LEC(3),
      WCLK => CLK,
      WE => PUSHe,
      SPO => NLW_Mram_RAM4_SPO_UNCONNECTED,
      DPO => DOUT(3)
    );
  Mram_RAM5 : RAM16X1D
    port map (
      A0 => ESC(0),
      A1 => ESC(1),
      A2 => ESC(2),
      A3 => ESC(3),
      D => DIN(4),
      DPRA0 => LEC(0),
      DPRA1 => LEC(1),
      DPRA2 => LEC(2),
      DPRA3 => LEC(3),
      WCLK => CLK,
      WE => PUSHe,
      SPO => NLW_Mram_RAM5_SPO_UNCONNECTED,
      DPO => DOUT(4)
    );
  Mram_RAM8 : RAM16X1D
    port map (
      A0 => ESC(0),
      A1 => ESC(1),
      A2 => ESC(2),
      A3 => ESC(3),
      D => DIN(7),
      DPRA0 => LEC(0),
      DPRA1 => LEC(1),
      DPRA2 => LEC(2),
      DPRA3 => LEC(3),
      WCLK => CLK,
      WE => PUSHe,
      SPO => NLW_Mram_RAM8_SPO_UNCONNECTED,
      DPO => DOUT(7)
    );
  Mram_RAM6 : RAM16X1D
    port map (
      A0 => ESC(0),
      A1 => ESC(1),
      A2 => ESC(2),
      A3 => ESC(3),
      D => DIN(5),
      DPRA0 => LEC(0),
      DPRA1 => LEC(1),
      DPRA2 => LEC(2),
      DPRA3 => LEC(3),
      WCLK => CLK,
      WE => PUSHe,
      SPO => NLW_Mram_RAM6_SPO_UNCONNECTED,
      DPO => DOUT(5)
    );
  Mram_RAM7 : RAM16X1D
    port map (
      A0 => ESC(0),
      A1 => ESC(1),
      A2 => ESC(2),
      A3 => ESC(3),
      D => DIN(6),
      DPRA0 => LEC(0),
      DPRA1 => LEC(1),
      DPRA2 => LEC(2),
      DPRA3 => LEC(3),
      WCLK => CLK,
      WE => PUSHe,
      SPO => NLW_Mram_RAM7_SPO_UNCONNECTED,
      DPO => DOUT(6)
    );
  CONT_0 : FDRE
    port map (
      C => CLK,
      CE => CONT_not0001,
      D => Result(0),
      R => SRST,
      Q => NlwRenamedSig_OI_CONT(0)
    );
  CONT_1 : FDRE
    port map (
      C => CLK,
      CE => CONT_not0001,
      D => Result(1),
      R => SRST,
      Q => NlwRenamedSig_OI_CONT(1)
    );
  CONT_2 : FDRE
    port map (
      C => CLK,
      CE => CONT_not0001,
      D => Result(2),
      R => SRST,
      Q => NlwRenamedSig_OI_CONT(2)
    );
  CONT_3 : FDRE
    port map (
      C => CLK,
      CE => CONT_not0001,
      D => Result(3),
      R => SRST,
      Q => NlwRenamedSig_OI_CONT(3)
    );
  CONT_4 : FDRE
    port map (
      C => CLK,
      CE => CONT_not0001,
      D => Result(4),
      R => SRST,
      Q => NlwRenamedSig_OI_CONT(4)
    );
  LEC_0 : FDRE
    port map (
      C => CLK,
      CE => POPe,
      D => Result_0_2,
      R => SRST,
      Q => LEC(0)
    );
  LEC_1 : FDRE
    port map (
      C => CLK,
      CE => POPe,
      D => Result_1_2,
      R => SRST,
      Q => LEC(1)
    );
  LEC_2 : FDRE
    port map (
      C => CLK,
      CE => POPe,
      D => Result_2_2,
      R => SRST,
      Q => LEC(2)
    );
  LEC_3 : FDRE
    port map (
      C => CLK,
      CE => POPe,
      D => Result_3_2,
      R => SRST,
      Q => LEC(3)
    );
  ESC_0 : FDRE
    port map (
      C => CLK,
      CE => PUSHe,
      D => Result_0_1,
      R => SRST,
      Q => ESC(0)
    );
  ESC_1 : FDRE
    port map (
      C => CLK,
      CE => PUSHe,
      D => Result_1_1,
      R => SRST,
      Q => ESC(1)
    );
  ESC_2 : FDRE
    port map (
      C => CLK,
      CE => PUSHe,
      D => Result_2_1,
      R => SRST,
      Q => ESC(2)
    );
  ESC_3 : FDRE
    port map (
      C => CLK,
      CE => PUSHe,
      D => Result_3_1,
      R => SRST,
      Q => ESC(3)
    );
  Mcount_LEC_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => LEC(1),
      I1 => LEC(0),
      O => Result_1_2
    );
  Mcount_ESC_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => ESC(1),
      I1 => ESC(0),
      O => Result_1_1
    );
  Mcount_LEC_xor_2_11 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => LEC(2),
      I1 => LEC(1),
      I2 => LEC(0),
      O => Result_2_2
    );
  Mcount_ESC_xor_2_11 : LUT3
    generic map(
      INIT => X"6A"
    )
    port map (
      I0 => ESC(2),
      I1 => ESC(1),
      I2 => ESC(0),
      O => Result_2_1
    );
  Mcount_LEC_xor_3_11 : LUT4
    generic map(
      INIT => X"6AAA"
    )
    port map (
      I0 => LEC(3),
      I1 => LEC(1),
      I2 => LEC(0),
      I3 => LEC(2),
      O => Result_3_2
    );
  Mcount_ESC_xor_3_11 : LUT4
    generic map(
      INIT => X"6AAA"
    )
    port map (
      I0 => ESC(3),
      I1 => ESC(1),
      I2 => ESC(0),
      I3 => ESC(2),
      O => Result_3_1
    );
  E_not000112 : LUT4
    generic map(
      INIT => X"0002"
    )
    port map (
      I0 => NlwRenamedSig_OI_CONT(0),
      I1 => NlwRenamedSig_OI_CONT(1),
      I2 => NlwRenamedSig_OI_CONT(3),
      I3 => NlwRenamedSig_OI_CONT(2),
      O => E_not000112_31
    );
  Mcount_CONT_xor_3_11 : LUT4
    generic map(
      INIT => X"3C5A"
    )
    port map (
      I0 => NlwRenamedSig_OI_CONT(2),
      I1 => Mcount_CONT_cy(1),
      I2 => Mcount_CONT_lut(3),
      I3 => Mcount_CONT_lut(2),
      O => Result(3)
    );
  POPe1 : LUT2
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => RD_EN,
      I1 => NlwRenamedSig_OI_E,
      O => POPe
    );
  PUSHe1 : LUT3
    generic map(
      INIT => X"8C"
    )
    port map (
      I0 => RD_EN,
      I1 => WR_EN,
      I2 => NlwRenamedSig_OI_CONT(4),
      O => PUSHe
    );
  Mcount_CONT_cy_1_1 : LUT3
    generic map(
      INIT => X"8E"
    )
    port map (
      I0 => NlwRenamedSig_OI_CONT(1),
      I1 => NlwRenamedSig_OI_CONT(0),
      I2 => N16,
      O => Mcount_CONT_cy(1)
    );
  Mcount_CONT_xor_4_11_SW1 : LUT3
    generic map(
      INIT => X"35"
    )
    port map (
      I0 => NlwRenamedSig_OI_CONT(2),
      I1 => Mcount_CONT_cy(1),
      I2 => N18,
      O => N12
    );
  Mcount_CONT_xor_4_11 : LUT4
    generic map(
      INIT => X"9A56"
    )
    port map (
      I0 => N5,
      I1 => N17,
      I2 => NlwRenamedSig_OI_CONT(3),
      I3 => N12,
      O => Result(4)
    );
  Mcount_CONT_xor_4_11_SW0 : LUT4
    generic map(
      INIT => X"9511"
    )
    port map (
      I0 => NlwRenamedSig_OI_CONT(4),
      I1 => WR_EN,
      I2 => NlwRenamedSig_OI_E,
      I3 => RD_EN,
      O => N5
    );
  Mcount_CONT_xor_2_11 : LUT4
    generic map(
      INIT => X"718E"
    )
    port map (
      I0 => NlwRenamedSig_OI_CONT(1),
      I1 => NlwRenamedSig_OI_CONT(0),
      I2 => CONT_and0000,
      I3 => Mcount_CONT_lut(2),
      O => Result(2)
    );
  Mcount_CONT_xor_1_11 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => NlwRenamedSig_OI_CONT(1),
      I1 => CONT_and0000,
      I2 => NlwRenamedSig_OI_CONT(0),
      O => Result(1)
    );
  CONT_not00011 : LUT4
    generic map(
      INIT => X"82C6"
    )
    port map (
      I0 => RD_EN,
      I1 => WR_EN,
      I2 => NlwRenamedSig_OI_E,
      I3 => NlwRenamedSig_OI_CONT(4),
      O => CONT_not0001
    );
  E_mux00001 : LUT4
    generic map(
      INIT => X"2EFF"
    )
    port map (
      I0 => NlwRenamedSig_OI_CONT(4),
      I1 => RD_EN,
      I2 => NlwRenamedSig_OI_E,
      I3 => WR_EN,
      O => E_mux0000
    );
  E_not000144 : MUXF5
    port map (
      I0 => N14,
      I1 => N15,
      S => E_not000112_31,
      O => E_not0001
    );
  E_not000144_F : LUT4
    generic map(
      INIT => X"8088"
    )
    port map (
      I0 => NlwRenamedSig_OI_E,
      I1 => WR_EN,
      I2 => RD_EN,
      I3 => NlwRenamedSig_OI_CONT(4),
      O => N14
    );
  E_not000144_G : LUT4
    generic map(
      INIT => X"A120"
    )
    port map (
      I0 => NlwRenamedSig_OI_E,
      I1 => NlwRenamedSig_OI_CONT(4),
      I2 => WR_EN,
      I3 => RD_EN,
      O => N15
    );
  Mcount_LEC_xor_0_11_INV_0 : INV
    port map (
      I => LEC(0),
      O => Result_0_2
    );
  Mcount_ESC_xor_0_11_INV_0 : INV
    port map (
      I => ESC(0),
      O => Result_0_1
    );
  Mcount_CONT_xor_0_11_INV_0 : INV
    port map (
      I => NlwRenamedSig_OI_CONT(0),
      O => Result(0)
    );
  CONT_and00001 : LUT4_D
    generic map(
      INIT => X"8C04"
    )
    port map (
      I0 => RD_EN,
      I1 => WR_EN,
      I2 => NlwRenamedSig_OI_CONT(4),
      I3 => NlwRenamedSig_OI_E,
      LO => N16,
      O => CONT_and0000
    );
  Mcount_CONT_lut_3_1 : LUT4_D
    generic map(
      INIT => X"C633"
    )
    port map (
      I0 => RD_EN,
      I1 => NlwRenamedSig_OI_CONT(3),
      I2 => NlwRenamedSig_OI_E,
      I3 => PUSHe,
      LO => N17,
      O => Mcount_CONT_lut(3)
    );
  Mcount_CONT_lut_2_1 : LUT4_D
    generic map(
      INIT => X"C633"
    )
    port map (
      I0 => RD_EN,
      I1 => NlwRenamedSig_OI_CONT(2),
      I2 => NlwRenamedSig_OI_E,
      I3 => PUSHe,
      LO => N18,
      O => Mcount_CONT_lut(2)
    );

end BlackBox;

