#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology MACHXO2
set_option -part LCMXO2_1200ZE
set_option -package MG132C
set_option -speed_grade -2

#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog 2001 standard option
set_option -vlog_std v2001

#map options
set_option -frequency auto
set_option -maxfan 1000
set_option -auto_constrain_io 0
set_option -disable_io_insertion false
set_option -retiming false; set_option -pipe true
set_option -force_gsr false
set_option -compiler_compatible 0
set_option -dup false
set_option -frequency 1
set_option -default_enum_encoding default

#simulation options


#timing analysis options



#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 1
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0


#-- add_file options
set_option -include_path {E:/work/controller_cpld/bld}
add_file -verilog {E:/work/controller_cpld/bld/../src/efb_define_def.v}
add_file -verilog {E:/work/controller_cpld/bld/../src/UFM_WB_top.v}
add_file -verilog {E:/work/controller_cpld/bld/../ip/EFB_UFM.v}
add_file -verilog {E:/work/controller_cpld/bld/../ip/USR_MEM.v}
add_file -verilog {E:/work/controller_cpld/bld/../src/GPIO.v}
add_file -verilog {E:/work/controller_cpld/bld/../src/I2C.v}
add_file -verilog {E:/work/controller_cpld/bld/../src/TOP.v}
add_file -verilog {E:/work/controller_cpld/bld/../src/HEADER.v}
add_file -verilog {E:/work/controller_cpld/bld/../src/efb_top.v}

#-- top module name
set_option -top_module TOP

#-- set result format/file last
project -result_file {E:/work/controller_cpld/bld/controller_cpld/controller_cpld_controller_cpld.edi}

#-- error message log file
project -log_file {controller_cpld_controller_cpld.srf}

#-- set any command lines input by customer


#-- run Synplify with 'arrange HDL file'
project -run
