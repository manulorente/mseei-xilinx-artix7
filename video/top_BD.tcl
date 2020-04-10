
################################################################
# This is a generated script based on design: top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source top_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a35tcpg236-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_0 "clk_out1 = 100MHz
clk_out2 =   50MHz
clk_out3 =   25MHz" [get_bd_designs $design_name]
  set_property USER_COMMENTS.comment_1 "mode_sel
1000   embedded image
0000   color bar pattern
0001   split color bar pattern
0010   tartan bar pattern" [get_bd_designs $design_name]

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:hls:BLNK:1.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:user:DISPLAY:1.0\
xilinx.com:user:DebEdge:1.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:user:TPG:1.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:user:interval_counter:1.0\
xilinx.com:ip:v_axi4s_vid_out:4.0\
xilinx.com:ip:v_tc:6.1\
xilinx.com:ip:v_vid_in_axi4s:4.0\
xilinx.com:user:vgamux:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set Hsync [ create_bd_port -dir O Hsync ]
  set Vsync [ create_bd_port -dir O Vsync ]
  set an [ create_bd_port -dir O -from 3 -to 0 an ]
  set btnC [ create_bd_port -dir I -type rst btnC ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $btnC
  set btnD [ create_bd_port -dir I btnD ]
  set btnL [ create_bd_port -dir I btnL ]
  set btnR [ create_bd_port -dir I btnR ]
  set clk [ create_bd_port -dir I -type clk clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   CONFIG.PHASE {0.000} \
 ] $clk
  set dp [ create_bd_port -dir O dp ]
  set led0 [ create_bd_port -dir O led0 ]
  set led1 [ create_bd_port -dir O led1 ]
  set led2 [ create_bd_port -dir O led2 ]
  set seg [ create_bd_port -dir O -from 6 -to 0 seg ]
  set sw [ create_bd_port -dir I -from 15 -to 0 sw ]
  set vgaBlue [ create_bd_port -dir O -from 3 -to 0 vgaBlue ]
  set vgaGreen [ create_bd_port -dir O -from 3 -to 0 vgaGreen ]
  set vgaRed [ create_bd_port -dir O -from 3 -to 0 vgaRed ]

  # Create instance: BLNK_0, and set properties
  set BLNK_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:BLNK:1.0 BLNK_0 ]

  # Create instance: Blue, and set properties
  set Blue [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Blue ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {4} \
 ] $Blue

  # Create instance: CERO, and set properties
  set CERO [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 CERO ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $CERO

  # Create instance: DISPLAY_0, and set properties
  set DISPLAY_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:DISPLAY:1.0 DISPLAY_0 ]

  # Create instance: DebEdge_0, and set properties
  set DebEdge_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:DebEdge:1.0 DebEdge_0 ]

  # Create instance: Green, and set properties
  set Green [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Green ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {4} \
 ] $Green

  # Create instance: IMAGE, and set properties
  set IMAGE [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 IMAGE ]
  set_property -dict [ list \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../images/lena_320x240_565.coe} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Fill_Remaining_Memory_Locations {true} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Memory_Type {Single_Port_ROM} \
   CONFIG.Port_A_Write_Rate {0} \
   CONFIG.Read_Width_A {16} \
   CONFIG.Read_Width_B {16} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
   CONFIG.Remaining_Memory_Locations {5a5a} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {76801} \
   CONFIG.Write_Width_A {16} \
   CONFIG.Write_Width_B {16} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $IMAGE

  # Create instance: Red, and set properties
  set Red [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 Red ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {8} \
   CONFIG.DOUT_WIDTH {4} \
 ] $Red

  # Create instance: TPG_0, and set properties
  set TPG_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:TPG:1.0 TPG_0 ]

  # Create instance: UNO, and set properties
  set UNO [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 UNO ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT2_JITTER {151.636} \
   CONFIG.CLKOUT2_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {175.402} \
   CONFIG.CLKOUT3_PHASE_ERROR {98.575} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {25} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {Custom} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {20} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {40} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {3} \
   CONFIG.RESET_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {false} \
 ] $clk_wiz_0

  # Create instance: interval_counter_0, and set properties
  set interval_counter_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:interval_counter:1.0 interval_counter_0 ]

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0 ]
  set_property -dict [ list \
   CONFIG.C_HAS_ASYNC_CLK {1} \
 ] $v_axi4s_vid_out_0

  # Create instance: v_tc_0, and set properties
  set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 v_tc_0 ]
  set_property -dict [ list \
   CONFIG.GEN_F0_VBLANK_HEND {640} \
   CONFIG.GEN_F0_VBLANK_HSTART {640} \
   CONFIG.GEN_F0_VFRAME_SIZE {525} \
   CONFIG.GEN_F0_VSYNC_HEND {640} \
   CONFIG.GEN_F0_VSYNC_HSTART {640} \
   CONFIG.GEN_F0_VSYNC_VEND {491} \
   CONFIG.GEN_F0_VSYNC_VSTART {489} \
   CONFIG.GEN_F1_VBLANK_HEND {640} \
   CONFIG.GEN_F1_VBLANK_HSTART {640} \
   CONFIG.GEN_F1_VFRAME_SIZE {525} \
   CONFIG.GEN_F1_VSYNC_HEND {640} \
   CONFIG.GEN_F1_VSYNC_HSTART {640} \
   CONFIG.GEN_F1_VSYNC_VEND {491} \
   CONFIG.GEN_F1_VSYNC_VSTART {489} \
   CONFIG.GEN_HACTIVE_SIZE {640} \
   CONFIG.GEN_HFRAME_SIZE {800} \
   CONFIG.GEN_HSYNC_END {752} \
   CONFIG.GEN_HSYNC_POLARITY {Low} \
   CONFIG.GEN_HSYNC_START {656} \
   CONFIG.GEN_VACTIVE_SIZE {480} \
   CONFIG.GEN_VSYNC_POLARITY {Low} \
   CONFIG.HAS_AXI4_LITE {false} \
   CONFIG.VIDEO_MODE {640x480p} \
   CONFIG.enable_detection {false} \
 ] $v_tc_0

  # Create instance: v_vid_in_axi4s_0, and set properties
  set v_vid_in_axi4s_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 v_vid_in_axi4s_0 ]
  set_property -dict [ list \
   CONFIG.C_HAS_ASYNC_CLK {1} \
 ] $v_vid_in_axi4s_0

  # Create instance: vgamux_0, and set properties
  set vgamux_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:vgamux:1.0 vgamux_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {12} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {3} \
   CONFIG.DIN_TO {0} \
   CONFIG.DIN_WIDTH {16} \
   CONFIG.DOUT_WIDTH {4} \
 ] $xlslice_1

  # Create interface connections
  connect_bd_intf_net -intf_net BLNK_0_OUTPUT_STREAM [get_bd_intf_pins BLNK_0/OutS] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
  connect_bd_intf_net -intf_net TPG_0_vid_out [get_bd_intf_pins TPG_0/vid_out] [get_bd_intf_pins v_vid_in_axi4s_0/vid_io_in]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out] [get_bd_intf_pins vgamux_0/vid_in]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_0_video_out [get_bd_intf_pins BLNK_0/InS] [get_bd_intf_pins v_vid_in_axi4s_0/video_out]

  # Create port connections
  connect_bd_net -net Blue_Dout [get_bd_ports vgaBlue] [get_bd_pins Blue/Dout]
  connect_bd_net -net CERO_dout [get_bd_pins CERO/dout] [get_bd_pins interval_counter_0/t1] [get_bd_pins interval_counter_0/t2] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_reset] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_reset]
  connect_bd_net -net DISPLAY_0_an [get_bd_ports an] [get_bd_pins DISPLAY_0/an]
  connect_bd_net -net DISPLAY_0_dp [get_bd_ports dp] [get_bd_pins DISPLAY_0/dp]
  connect_bd_net -net DISPLAY_0_seg [get_bd_ports seg] [get_bd_pins DISPLAY_0/seg]
  connect_bd_net -net DebEdge_0_posedge [get_bd_pins DebEdge_0/tick] [get_bd_pins interval_counter_0/start]
  connect_bd_net -net Din_1 [get_bd_ports sw] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net Green_Dout [get_bd_ports vgaGreen] [get_bd_pins Green/Dout]
  connect_bd_net -net TPG_0_Hsync [get_bd_pins TPG_0/Hsync] [get_bd_pins vgamux_0/hsin]
  connect_bd_net -net TPG_0_RGB_data [get_bd_pins TPG_0/RGB_data] [get_bd_pins vgamux_0/rgb_data]
  connect_bd_net -net TPG_0_Vsync [get_bd_pins TPG_0/Vsync] [get_bd_pins vgamux_0/vsin]
  connect_bd_net -net TPG_0_rom_adr [get_bd_pins IMAGE/addra] [get_bd_pins TPG_0/rom_adr]
  connect_bd_net -net UNO_dout [get_bd_pins BLNK_0/ap_rst_n] [get_bd_pins UNO/dout] [get_bd_pins v_axi4s_vid_out_0/aclken] [get_bd_pins v_axi4s_vid_out_0/aresetn] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_ce] [get_bd_pins v_tc_0/clken] [get_bd_pins v_tc_0/resetn] [get_bd_pins v_vid_in_axi4s_0/aclken] [get_bd_pins v_vid_in_axi4s_0/aresetn] [get_bd_pins v_vid_in_axi4s_0/axis_enable] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_ce]
  connect_bd_net -net blk_mem_gen_0_douta [get_bd_pins IMAGE/douta] [get_bd_pins TPG_0/rom_dat]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins TPG_0/clk_in_100] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins BLNK_0/ap_clk] [get_bd_pins DISPLAY_0/C] [get_bd_pins DebEdge_0/c] [get_bd_pins IMAGE/clka] [get_bd_pins TPG_0/clk_in_50] [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins interval_counter_0/clk] [get_bd_pins v_axi4s_vid_out_0/aclk] [get_bd_pins v_vid_in_axi4s_0/aclk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_clk] [get_bd_pins vgamux_0/clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_ports led1] [get_bd_pins TPG_0/locked_in] [get_bd_pins clk_wiz_0/locked] [get_bd_pins interval_counter_0/resetn]
  connect_bd_net -net interval_counter_0_STATE [get_bd_pins DISPLAY_0/DPi] [get_bd_pins interval_counter_0/STATE]
  connect_bd_net -net interval_counter_0_prd [get_bd_pins DISPLAY_0/DDi] [get_bd_pins interval_counter_0/prd]
  connect_bd_net -net interval_counter_0_ready [get_bd_ports led2] [get_bd_pins interval_counter_0/ready]
  connect_bd_net -net reset_1 [get_bd_ports btnC] [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net sel_1 [get_bd_ports btnD] [get_bd_pins vgamux_0/sel]
  connect_bd_net -net sel_2 [get_bd_ports btnR] [get_bd_pins DISPLAY_0/sel]
  connect_bd_net -net sw_1_1 [get_bd_ports btnL] [get_bd_pins DebEdge_0/sw]
  connect_bd_net -net sys_clock_1 [get_bd_ports clk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net v_axi4s_vid_out_0_locked [get_bd_ports led0] [get_bd_pins v_axi4s_vid_out_0/locked]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins v_tc_0/gen_clken]
  connect_bd_net -net v_vid_in_axi4s_0_fid [get_bd_pins v_axi4s_vid_out_0/fid] [get_bd_pins v_vid_in_axi4s_0/fid]
  connect_bd_net -net vgamux_0_Hsync [get_bd_ports Hsync] [get_bd_pins vgamux_0/Hsync]
  connect_bd_net -net vgamux_0_Vsync [get_bd_ports Vsync] [get_bd_pins vgamux_0/Vsync]
  connect_bd_net -net vgamux_0_vgaBlue [get_bd_pins Blue/Din] [get_bd_pins vgamux_0/vgaBlue]
  connect_bd_net -net vgamux_0_vgaGreen [get_bd_pins Green/Din] [get_bd_pins vgamux_0/vgaGreen]
  connect_bd_net -net vgamux_0_vgaRed [get_bd_pins Red/Din] [get_bd_pins vgamux_0/vgaRed]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins TPG_0/test_data] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins TPG_0/mode_sel] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_ports vgaRed] [get_bd_pins Red/Dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

# ###############################################################
# ###############################################################
# ###############################################################
# ###############################################################
make_wrapper -files [get_files ./CanalVideo/CanalVideo.srcs/sources_1/bd/top/top.bd] -top
add_files -norecurse ./CanalVideo/CanalVideo.srcs/sources_1/bd/top/hdl/top_wrapper.vhd
add_files -fileset constrs_1 -norecurse ./Basys3_Master.xdc
update_compile_order -fileset sources_1
update_ip_catalog -rebuild -scan_changes
report_ip_status -name ip_status
regenerate_bd_layout
# ###############################################################
# ###############################################################
# ###############################################################
# ###############################################################
