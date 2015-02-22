lappend auto_path "D:/lscc/diamond/3.2_x64/data/script"
package require simulation_generation
set ::bali::simulation::Para(PROJECT) {ctrl_modelsim}
set ::bali::simulation::Para(PROJECTPATH) {E:/work/controller_cpld/bld}
set ::bali::simulation::Para(FILELIST) {"E:/work/controller_cpld/sim/UFM_WB_TB.v" "E:/work/controller_cpld/src/efb_define_def.v" "E:/work/controller_cpld/src/UFM_WB_top.v" "E:/work/controller_cpld/ip/EFB_UFM.v" "E:/work/controller_cpld/ip/USR_MEM.v" }
set ::bali::simulation::Para(GLBINCLIST) {}
set ::bali::simulation::Para(INCLIST) {"none" "none" "none" "none" "none"}
set ::bali::simulation::Para(WORKLIBLIST) {"" "work" "work" "work" "work" }
set ::bali::simulation::Para(COMPLIST) {"none" "VERILOG" "VERILOG" "VERILOG" "VERILOG" }
set ::bali::simulation::Para(SIMLIBLIST) {pmi_work ovi_machxo2}
set ::bali::simulation::Para(MACROLIST) {}
set ::bali::simulation::Para(SIMULATIONTOPMODULE) {}
set ::bali::simulation::Para(SIMULATIONINSTANCE) {}
set ::bali::simulation::Para(LANGUAGE) {}
set ::bali::simulation::Para(SDFPATH)  {}
set ::bali::simulation::Para(ADDTOPLEVELSIGNALSTOWAVEFORM)  {0}
set ::bali::simulation::Para(RUNSIMULATION)  {0}
set ::bali::simulation::Para(POJO2LIBREFRESH)    {}
set ::bali::simulation::Para(POJO2MODELSIMLIB)   {}
::bali::simulation::ModelSim_Run
