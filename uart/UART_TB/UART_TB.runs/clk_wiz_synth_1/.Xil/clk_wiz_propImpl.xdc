set_property SRC_FILE_INFO {cfile:e:/FPGA/ejercicios/EF31/UART_TB/UART_TB.srcs/sources_1/ip/clk_wiz_1/clk_wiz.xdc rfile:../../../UART_TB.srcs/sources_1/ip/clk_wiz_1/clk_wiz.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in]] 0.1
