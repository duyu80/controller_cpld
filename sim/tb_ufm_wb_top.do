#vdel -all -lib work
vlib work

vlog  -work work UFM_WB_TB.v
vlog  -work work ../src/UFM_WB_top.v
vlog  -work work ../src/efb_define_def.v
vlog  -work work ../ip/EFB_UFM.v
vlog  -work work ../ip/USR_MEM.v



vsim -t ns -novopt -voptargs="+acc" -L machxo2 -L lattice_blackbox1 -L lattice_blackbox2 -lib work work.UFM_WB_tb

do {tb_ufm_wb_top_wave.do}
run -all
