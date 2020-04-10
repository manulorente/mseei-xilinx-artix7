-makelib ies_lib/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2018.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2018.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../UART_TB.srcs/sources_1/ip/clk_wiz_1/clk_wiz_clk_wiz.v" \
  "../../../../UART_TB.srcs/sources_1/ip/clk_wiz_1/clk_wiz.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

