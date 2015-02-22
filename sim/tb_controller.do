vdel -all -lib work
vlib work

	vlog -work work "E:/work/controller_cpld/src/efb_define_def.v"
	vlog -work work "E:/work/controller_cpld/src/UFM_WB_top.v"
	vlog -work work "E:/work/controller_cpld/ip/EFB_UFM.v"
	vlog -work work "E:/work/controller_cpld/ip/USR_MEM.v"
	vlog -work work "E:/work/controller_cpld/src/GPIO.v"
	vlog -work work "E:/work/controller_cpld/src/I2C.v"
	vlog -work work "E:/work/controller_cpld/src/efb_top.v"
	vlog -work work "E:/work/controller_cpld/src/TOP.v"
	vlog -work work "E:/work/controller_cpld/src/HEADER.v"
	vlog -work work "E:/work/controller_cpld/sim/i2c_master_bit_ctrl.v"
	vlog -work work "E:/work/controller_cpld/sim/i2c_master_byte_ctrl.v"
	vlog -work work "E:/work/controller_cpld/sim/i2c_master_defines.v"
	vlog -work work "E:/work/controller_cpld/sim/i2c_master_registers.v"
	vlog -work work "E:/work/controller_cpld/sim/i2c_master_wb_top.v"
	vlog -work work "E:/work/controller_cpld/sim/tb_controller.v"
	vlog -work work "E:/work/controller_cpld/sim/wb_master.v"
	vlog -work work "E:/work/controller_cpld/sim/DELAY.v"


vsim -t ns -novopt -voptargs="+acc" -L machxo2 -L lattice_blackbox1 -lib work work.tb_controller

add wave -noupdate -group tb_controller /tb_controller/*
add wave -noupdate -group TOP_INST /tb_controller/TOP_INST/*
run -all
