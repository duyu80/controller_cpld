setenv SIM_WORKING_FOLDER .
set newDesign 0
if {![file exists "E:/work/controller_cpld/bld/controller_active/controller_active.adf"]} { 
	design create controller_active "E:/work/controller_cpld/bld"
  set newDesign 1
}
design open "E:/work/controller_cpld/bld/controller_active"
cd "E:/work/controller_cpld/bld"
designverincludedir -clear
designverlibrarysim -PL -clear
designverlibrarysim -L -clear
designverlibrarysim -PL pmi_work
designverlibrarysim ovi_machxo2
designverdefinemacro -clear
if {$newDesign == 0} { 
  removefile -Y -D *
}
addfile "E:/work/controller_cpld/src/HEADER.v"
addfile "E:/work/controller_cpld/src/GPIO.v"
addfile "E:/work/controller_cpld/src/I2C.v"
addfile "E:/work/controller_cpld/ip/USR_MEM.v"
addfile "E:/work/controller_cpld/ip/EFB_UFM.v"
addfile "E:/work/controller_cpld/src/UFM_WB_top.v"
addfile "E:/work/controller_cpld/src/TOP.v"
addfile "E:/work/controller_cpld/sim/i2c_master_registers.v"
addfile "E:/work/controller_cpld/sim/i2c_master_bit_ctrl.v"
addfile "E:/work/controller_cpld/sim/i2c_master_byte_ctrl.v"
addfile "E:/work/controller_cpld/sim/i2c_master_wb_top.v"
addfile "E:/work/controller_cpld/sim/DELAY.v"
addfile "E:/work/controller_cpld/sim/wb_master.v"
addfile "E:/work/controller_cpld/sim/tb_controller.v"
addfile "E:/work/controller_cpld/src/efb_define_def.v"
addfile "E:/work/controller_cpld/sim/i2c_master_defines.v"
vlib "E:/work/controller_cpld/bld/controller_active/work"
set worklib work
adel -all
vlog -dbg -work work "E:/work/controller_cpld/src/HEADER.v"
vlog -dbg -work work "E:/work/controller_cpld/src/GPIO.v"
vlog -dbg -work work "E:/work/controller_cpld/src/I2C.v"
vlog -dbg "E:/work/controller_cpld/ip/USR_MEM.v"
vlog -dbg "E:/work/controller_cpld/ip/EFB_UFM.v"
vlog -dbg "E:/work/controller_cpld/src/UFM_WB_top.v"
vlog -dbg -work work "E:/work/controller_cpld/src/TOP.v"
vlog -dbg "E:/work/controller_cpld/sim/i2c_master_registers.v"
vlog -dbg "E:/work/controller_cpld/sim/i2c_master_bit_ctrl.v"
vlog -dbg "E:/work/controller_cpld/sim/i2c_master_byte_ctrl.v"
vlog -dbg "E:/work/controller_cpld/sim/i2c_master_wb_top.v"
vlog -dbg "E:/work/controller_cpld/sim/DELAY.v"
vlog -dbg "E:/work/controller_cpld/sim/wb_master.v"
vlog -dbg "E:/work/controller_cpld/sim/tb_controller.v"
vlog -dbg "E:/work/controller_cpld/src/efb_define_def.v"
vlog -dbg "E:/work/controller_cpld/sim/i2c_master_defines.v"
module tb_controller
vsim +access +r tb_controller   -PL pmi_work -L ovi_machxo2
add wave *
run 1000ns
