setenv SIM_WORKING_FOLDER .
set newDesign 0
if {![file exists "E:/work/controller_cpld/bld/ctrl_sim/ctrl_sim.adf"]} { 
	design create ctrl_sim "E:/work/controller_cpld/bld"
  set newDesign 1
}
design open "E:/work/controller_cpld/bld/ctrl_sim"
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
addfile "E:/work/controller_cpld/ip/USR_MEM.v"
addfile "E:/work/controller_cpld/ip/EFB_UFM.v"
addfile "E:/work/controller_cpld/src/UFM_WB_top.v"
addfile "E:/work/controller_cpld/sim/UFM_WB_TB.v"
addfile "E:/work/controller_cpld/src/efb_define_def.v"
vlib "E:/work/controller_cpld/bld/ctrl_sim/work"
set worklib work
adel -all
vlog -dbg -work work "E:/work/controller_cpld/ip/USR_MEM.v"
vlog -dbg -work work "E:/work/controller_cpld/ip/EFB_UFM.v"
vlog -dbg -work work "E:/work/controller_cpld/src/UFM_WB_top.v"
vlog -dbg "E:/work/controller_cpld/sim/UFM_WB_TB.v"
vlog -dbg -work work "E:/work/controller_cpld/src/efb_define_def.v"
module UFM_WB_tb
vsim +access +r UFM_WB_tb   -PL pmi_work -L ovi_machxo2
add wave *
run 1000ns
