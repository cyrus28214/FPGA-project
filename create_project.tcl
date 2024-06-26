# Typical usage: vivado -mode tcl -source create_project.tcl

# 使用[file normalize <相对路径>]可以将路径转换为绝对路径，这样你就可以在脚本里使用相对路径，方便其他人也能运行脚本

set target_dir "../vivado"
set project_name "FPGA-project"

# 设置最大线程数，加快vivado的速度
set_param general.maxThreads 32 

create_project -force $project_name $target_dir -part xc7k160tffg676-2L

# Add sources
add_files -scan_for_includes -fileset sources_1 ./rtl
add_files -scan_for_includes -fileset sim_1 ./sim
add_files -scan_for_includes -fileset constrs_1 ./constraints
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Add IPs
# Clock wizard: 100MHz to 25.175MHz
# module clk_div_vga 
#  (
#   // Clock out ports
#   output        clk_out,
#   // Clock in ports
#   input         clk_in
#  );
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_div_vga
set_property -dict [list \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.175} \
  CONFIG.CLK_OUT1_PORT {clk_out} \
  CONFIG.PRIMARY_PORT {clk_in} \
  CONFIG.PRIM_IN_FREQ {100.000} \
  CONFIG.USE_LOCKED {false} \
  CONFIG.USE_RESET {false} \
] [get_ips clk_div_vga]

# Single Port ROM
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bROM_tile
set_property -dict [list \
  CONFIG.Enable_A {Always_Enabled} \
  CONFIG.Memory_Type {Single_Port_ROM} \
  CONFIG.Write_Depth_A {131072} \
  CONFIG.Coe_File [file normalize ./resources/resources.coe] \
  CONFIG.Load_Init_File {true} \
] [get_ips bROM_tile]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bROM_num
set_property -dict [list \
  CONFIG.Enable_A {Always_Enabled} \
  CONFIG.Memory_Type {Single_Port_ROM} \
  CONFIG.Write_Depth_A {4096} \
  CONFIG.Coe_File [file normalize ./resources/number.coe] \
  CONFIG.Load_Init_File {true} \
] [get_ips bROM_num]

# True Dual Port RAM
# 读延迟：两个时钟周期，第一拍设置addr，第三拍才能获得输出。
# 写延迟：一个时钟周期。
# 307200 = 640 * 480
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bRAM
set_property -dict [list \
  CONFIG.Write_Width_A {16} \
  CONFIG.Write_Depth_A {307200} \
  CONFIG.Enable_A {Always_Enabled} \
  CONFIG.Enable_B {Always_Enabled} \
  CONFIG.Memory_Type {True_Dual_Port_RAM} \
  CONFIG.Coe_File [file normalize ./resources/bg.jpg.coe] \
  CONFIG.Load_Init_File {true} \
] [get_ips bRAM]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bRAM_map
set_property -dict [list \
  CONFIG.Write_Width_A {16} \
  CONFIG.Write_Depth_A {16384} \
  CONFIG.Enable_A {Always_Enabled} \
  CONFIG.Enable_B {Always_Enabled} \
  CONFIG.Memory_Type {True_Dual_Port_RAM} \
  CONFIG.Coe_File [file normalize ./resources/map.coe] \
  CONFIG.Load_Init_File {true} \
] [get_ips bRAM_map]


start_gui