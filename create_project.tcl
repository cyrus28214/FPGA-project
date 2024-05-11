# Typical usage: vivado -mode tcl -source create_project.tcl

set target_dir "./vivado"
set project_name "FPGA-project"

create_project -force $project_name $target_dir -part xc7k160tffg676-2L

# Add sources
add_files -fileset sources_1 ./rtl
add_files -fileset sim_1 ./sim
add_files -fileset constrs_1 ./constraints
import_files -force
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Add IPs
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_0
set_property -dict [list \
  CONFIG.CLKIN1_JITTER_PS {50.0} \
  CONFIG.CLKOUT1_JITTER {238.195} \
  CONFIG.CLKOUT1_PHASE_ERROR {205.969} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.175} \
  CONFIG.CLK_OUT1_PORT {clk_out} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {38.000} \
  CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
  CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {43.125} \
  CONFIG.MMCM_DIVCLK_DIVIDE {7} \
  CONFIG.PRIMARY_PORT {clk_in} \
  CONFIG.PRIM_IN_FREQ {200.000} \
  CONFIG.USE_LOCKED {false} \
  CONFIG.USE_RESET {false} \
] [get_ips clk_wiz_0]

start_gui