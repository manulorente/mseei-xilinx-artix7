-------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:30:52 24/12/2012 
-- Design Name: 
-- Module Name:    DISPLAY - BlackBox
-- Project Name: 
-- Target Devices: netlist for Spartan3e
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

--Disp_inst: entity DISPLAY(BlackBox)
--  Port map (
--    C   => CLK,    -- CLK=50MHz
--    DD  => DDi,    -- i(15:0) DD(15:12)=D3 ... DD(3:0)=D0
--    DPi => DPi,    -- i(3:0)  points DP3 izda DP0 dcha		
--    AN  => AN ,    -- o(3:0)  AN3 izda AN0 dcha
--    CAT => CAT     -- CAT(7)=DP, CAT(6)=CG, CAT(0)=CA
--  );

-------------------------------------------------------------------------------
-- MODEL ----------------------------------------------------------------------
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DISPLAY is
  Port (
    C   : in   STD_LOGIC;                      -- CLK=50MHz
    DDi : in   STD_LOGIC_VECTOR (31 downto 0);
    DPi : in   STD_LOGIC_VECTOR ( 3 downto 0);
    sel : in   STD_LOGIC;
    an  : out  STD_LOGIC_VECTOR ( 3 downto 0);
    seg : out  STD_LOGIC_VECTOR ( 6 downto 0);
    dp  : out  STD_LOGIC                          --CAT(7)=DP,CAT(6)=CG,CAT(0)=CA
  );
end DISPLAY;



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

architecture BlackBox of DISPLAY is
  signal Mcount_Q_REG_cy_10_rt_39 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_11_rt_41 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_1_rt_43 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_2_rt_45 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_3_rt_47 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_4_rt_49 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_5_rt_51 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_6_rt_53 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_7_rt_55 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_8_rt_57 : STD_LOGIC; 
  signal Mcount_Q_REG_cy_9_rt_59 : STD_LOGIC; 
  signal Mcount_Q_REG_xor_12_rt_61 : STD_LOGIC; 
  signal Mmux_CAT_7_3_62 : STD_LOGIC; 
  signal Mmux_CAT_7_4_63 : STD_LOGIC; 
  signal Mmux_HEX_3_64 : STD_LOGIC; 
  signal Mmux_HEX_31_65 : STD_LOGIC; 
  signal Mmux_HEX_32_66 : STD_LOGIC; 
  signal Mmux_HEX_33_67 : STD_LOGIC; 
  signal Mmux_HEX_4_68 : STD_LOGIC; 
  signal Mmux_HEX_41_69 : STD_LOGIC; 
  signal Mmux_HEX_42_70 : STD_LOGIC; 
  signal Mmux_HEX_43_71 : STD_LOGIC; 
  signal N0 : STD_LOGIC; 
  signal N1 : STD_LOGIC; 
  signal HEX : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal DPii  : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal Mcount_Q_REG_cy : STD_LOGIC_VECTOR ( 11 downto 0 ); 
  signal Mcount_Q_REG_lut : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Q_REG : STD_LOGIC_VECTOR ( 12 downto 0 ); 
  signal Result : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal CAT : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal DD :  STD_LOGIC_VECTOR (15 downto 0);
begin
  seg <= CAT(6 downto 0);
  dp <= CAT(7);
  DD <= DDi(31 downto 16) when sel='1' else DDi(15 downto 0);
  DPii <= not DPi;
  XST_GND : GND
    port map (
      G => N0
    );
  XST_VCC : VCC
    port map (
      P => N1
    );
  Q_REG_0 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(0),
      Q => Q_REG(0)
    );
  Q_REG_1 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(1),
      Q => Q_REG(1)
    );
  Q_REG_2 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(2),
      Q => Q_REG(2)
    );
  Q_REG_3 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(3),
      Q => Q_REG(3)
    );
  Q_REG_4 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(4),
      Q => Q_REG(4)
    );
  Q_REG_5 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(5),
      Q => Q_REG(5)
    );
  Q_REG_6 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(6),
      Q => Q_REG(6)
    );
  Q_REG_7 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(7),
      Q => Q_REG(7)
    );
  Q_REG_8 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(8),
      Q => Q_REG(8)
    );
  Q_REG_9 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(9),
      Q => Q_REG(9)
    );
  Q_REG_10 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(10),
      Q => Q_REG(10)
    );
  Q_REG_11 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(11),
      Q => Q_REG(11)
    );
  Q_REG_12 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => C,
      D => Result(12),
      Q => Q_REG(12)
    );
  Mmux_CAT_7_2_f5 : MUXF5
    port map (
      I0 => Mmux_CAT_7_4_63,
      I1 => Mmux_CAT_7_3_62,
      S => Q_REG(12),
      O => CAT(7)
    );
  Mmux_CAT_7_4 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DPii(0),
      I2 => DPii(1),
      O => Mmux_CAT_7_4_63
    );
  Mmux_CAT_7_3 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DPii(2),
      I2 => DPii(3),
      O => Mmux_CAT_7_3_62
    );
  Mmux_HEX_2_f5_2 : MUXF5
    port map (
      I0 => Mmux_HEX_43_71,
      I1 => Mmux_HEX_33_67,
      S => Q_REG(12),
      O => HEX(3)
    );
  Mmux_HEX_43 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DD(3),
      I2 => DD(7),
      O => Mmux_HEX_43_71
    );
  Mmux_HEX_33 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DD(11),
      I2 => DD(15),
      O => Mmux_HEX_33_67
    );
  Mmux_HEX_2_f5_1 : MUXF5
    port map (
      I0 => Mmux_HEX_42_70,
      I1 => Mmux_HEX_32_66,
      S => Q_REG(12),
      O => HEX(2)
    );
  Mmux_HEX_42 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DD(2),
      I2 => DD(6),
      O => Mmux_HEX_42_70
    );
  Mmux_HEX_32 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DD(10),
      I2 => DD(14),
      O => Mmux_HEX_32_66
    );
  Mmux_HEX_2_f5_0 : MUXF5
    port map (
      I0 => Mmux_HEX_41_69,
      I1 => Mmux_HEX_31_65,
      S => Q_REG(12),
      O => HEX(1)
    );
  Mmux_HEX_41 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DD(1),
      I2 => DD(5),
      O => Mmux_HEX_41_69
    );
  Mmux_HEX_31 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DD(9),
      I2 => DD(13),
      O => Mmux_HEX_31_65
    );
  Mmux_HEX_2_f5 : MUXF5
    port map (
      I0 => Mmux_HEX_4_68,
      I1 => Mmux_HEX_3_64,
      S => Q_REG(12),
      O => HEX(0)
    );
  Mmux_HEX_4 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DD(0),
      I2 => DD(4),
      O => Mmux_HEX_4_68
    );
  Mmux_HEX_3 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => Q_REG(11),
      I1 => DD(8),
      I2 => DD(12),
      O => Mmux_HEX_3_64
    );
  Mcount_Q_REG_cy_0_Q : MUXCY
    port map (
      CI => N0,
      DI => N1,
      S => Mcount_Q_REG_lut(0),
      O => Mcount_Q_REG_cy(0)
    );
  Mcount_Q_REG_xor_0_Q : XORCY
    port map (
      CI => N0,
      LI => Mcount_Q_REG_lut(0),
      O => Result(0)
    );
  Mcount_Q_REG_cy_1_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(0),
      DI => N0,
      S => Mcount_Q_REG_cy_1_rt_43,
      O => Mcount_Q_REG_cy(1)
    );
  Mcount_Q_REG_xor_1_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(0),
      LI => Mcount_Q_REG_cy_1_rt_43,
      O => Result(1)
    );
  Mcount_Q_REG_cy_2_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(1),
      DI => N0,
      S => Mcount_Q_REG_cy_2_rt_45,
      O => Mcount_Q_REG_cy(2)
    );
  Mcount_Q_REG_xor_2_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(1),
      LI => Mcount_Q_REG_cy_2_rt_45,
      O => Result(2)
    );
  Mcount_Q_REG_cy_3_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(2),
      DI => N0,
      S => Mcount_Q_REG_cy_3_rt_47,
      O => Mcount_Q_REG_cy(3)
    );
  Mcount_Q_REG_xor_3_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(2),
      LI => Mcount_Q_REG_cy_3_rt_47,
      O => Result(3)
    );
  Mcount_Q_REG_cy_4_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(3),
      DI => N0,
      S => Mcount_Q_REG_cy_4_rt_49,
      O => Mcount_Q_REG_cy(4)
    );
  Mcount_Q_REG_xor_4_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(3),
      LI => Mcount_Q_REG_cy_4_rt_49,
      O => Result(4)
    );
  Mcount_Q_REG_cy_5_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(4),
      DI => N0,
      S => Mcount_Q_REG_cy_5_rt_51,
      O => Mcount_Q_REG_cy(5)
    );
  Mcount_Q_REG_xor_5_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(4),
      LI => Mcount_Q_REG_cy_5_rt_51,
      O => Result(5)
    );
  Mcount_Q_REG_cy_6_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(5),
      DI => N0,
      S => Mcount_Q_REG_cy_6_rt_53,
      O => Mcount_Q_REG_cy(6)
    );
  Mcount_Q_REG_xor_6_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(5),
      LI => Mcount_Q_REG_cy_6_rt_53,
      O => Result(6)
    );
  Mcount_Q_REG_cy_7_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(6),
      DI => N0,
      S => Mcount_Q_REG_cy_7_rt_55,
      O => Mcount_Q_REG_cy(7)
    );
  Mcount_Q_REG_xor_7_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(6),
      LI => Mcount_Q_REG_cy_7_rt_55,
      O => Result(7)
    );
  Mcount_Q_REG_cy_8_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(7),
      DI => N0,
      S => Mcount_Q_REG_cy_8_rt_57,
      O => Mcount_Q_REG_cy(8)
    );
  Mcount_Q_REG_xor_8_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(7),
      LI => Mcount_Q_REG_cy_8_rt_57,
      O => Result(8)
    );
  Mcount_Q_REG_cy_9_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(8),
      DI => N0,
      S => Mcount_Q_REG_cy_9_rt_59,
      O => Mcount_Q_REG_cy(9)
    );
  Mcount_Q_REG_xor_9_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(8),
      LI => Mcount_Q_REG_cy_9_rt_59,
      O => Result(9)
    );
  Mcount_Q_REG_cy_10_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(9),
      DI => N0,
      S => Mcount_Q_REG_cy_10_rt_39,
      O => Mcount_Q_REG_cy(10)
    );
  Mcount_Q_REG_xor_10_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(9),
      LI => Mcount_Q_REG_cy_10_rt_39,
      O => Result(10)
    );
  Mcount_Q_REG_cy_11_Q : MUXCY
    port map (
      CI => Mcount_Q_REG_cy(10),
      DI => N0,
      S => Mcount_Q_REG_cy_11_rt_41,
      O => Mcount_Q_REG_cy(11)
    );
  Mcount_Q_REG_xor_11_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(10),
      LI => Mcount_Q_REG_cy_11_rt_41,
      O => Result(11)
    );
  Mcount_Q_REG_xor_12_Q : XORCY
    port map (
      CI => Mcount_Q_REG_cy(11),
      LI => Mcount_Q_REG_xor_12_rt_61,
      O => Result(12)
    );
  Mdecod_AN31 : LUT2
    generic map(
      INIT => X"7"
    )
    port map (
      I0 => Q_REG(11),
      I1 => Q_REG(12),
      O => AN(3)
    );
  Mdecod_AN21 : LUT2
    generic map(
      INIT => X"D"
    )
    port map (
      I0 => Q_REG(12),
      I1 => Q_REG(11),
      O => AN(2)
    );
  Mdecod_AN11 : LUT2
    generic map(
      INIT => X"D"
    )
    port map (
      I0 => Q_REG(11),
      I1 => Q_REG(12),
      O => AN(1)
    );
  Mdecod_AN01 : LUT2
    generic map(
      INIT => X"E"
    )
    port map (
      I0 => Q_REG(11),
      I1 => Q_REG(12),
      O => AN(0)
    );
  Mrom_LED41 : LUT4
    generic map(
      INIT => X"445C"
    )
    port map (
      I0 => HEX(3),
      I1 => HEX(0),
      I2 => HEX(2),
      I3 => HEX(1),
      O => CAT(4)
    );
  Mrom_LED21 : LUT4
    generic map(
      INIT => X"80C2"
    )
    port map (
      I0 => HEX(1),
      I1 => HEX(3),
      I2 => HEX(2),
      I3 => HEX(0),
      O => CAT(2)
    );
  Mrom_LED61 : LUT4
    generic map(
      INIT => X"0941"
    )
    port map (
      I0 => HEX(1),
      I1 => HEX(2),
      I2 => HEX(3),
      I3 => HEX(0),
      O => CAT(6)
    );
  Mrom_LED51 : LUT4
    generic map(
      INIT => X"6032"
    )
    port map (
      I0 => HEX(1),
      I1 => HEX(3),
      I2 => HEX(0),
      I3 => HEX(2),
      O => CAT(5)
    );
  Mrom_LED111 : LUT4
    generic map(
      INIT => X"E448"
    )
    port map (
      I0 => HEX(0),
      I1 => HEX(2),
      I2 => HEX(1),
      I3 => HEX(3),
      O => CAT(1)
    );
  Mrom_LED31 : LUT4
    generic map(
      INIT => X"A118"
    )
    port map (
      I0 => HEX(1),
      I1 => HEX(3),
      I2 => HEX(0),
      I3 => HEX(2),
      O => CAT(3)
    );
  Mrom_LED11 : LUT4
    generic map(
      INIT => X"2812"
    )
    port map (
      I0 => HEX(0),
      I1 => HEX(1),
      I2 => HEX(2),
      I3 => HEX(3),
      O => CAT(0)
    );
  Mcount_Q_REG_cy_1_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(1),
      O => Mcount_Q_REG_cy_1_rt_43
    );
  Mcount_Q_REG_cy_2_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(2),
      O => Mcount_Q_REG_cy_2_rt_45
    );
  Mcount_Q_REG_cy_3_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(3),
      O => Mcount_Q_REG_cy_3_rt_47
    );
  Mcount_Q_REG_cy_4_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(4),
      O => Mcount_Q_REG_cy_4_rt_49
    );
  Mcount_Q_REG_cy_5_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(5),
      O => Mcount_Q_REG_cy_5_rt_51
    );
  Mcount_Q_REG_cy_6_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(6),
      O => Mcount_Q_REG_cy_6_rt_53
    );
  Mcount_Q_REG_cy_7_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(7),
      O => Mcount_Q_REG_cy_7_rt_55
    );
  Mcount_Q_REG_cy_8_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(8),
      O => Mcount_Q_REG_cy_8_rt_57
    );
  Mcount_Q_REG_cy_9_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(9),
      O => Mcount_Q_REG_cy_9_rt_59
    );
  Mcount_Q_REG_cy_10_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(10),
      O => Mcount_Q_REG_cy_10_rt_39
    );
  Mcount_Q_REG_cy_11_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(11),
      O => Mcount_Q_REG_cy_11_rt_41
    );
  Mcount_Q_REG_xor_12_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => Q_REG(12),
      O => Mcount_Q_REG_xor_12_rt_61
    );
  Mcount_Q_REG_lut_0_INV_0 : INV
    port map (
      I => Q_REG(0),
      O => Mcount_Q_REG_lut(0)
    );

end BlackBox;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------