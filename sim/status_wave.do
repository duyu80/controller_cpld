onerror {resume}
quietly WaveActivateNextPane {} 0
#add wave -noupdate -expand -group tb_status /tb_status/*
add wave -noupdate -group tb_status /tb_status/*
add wave -noupdate -group TOP_INST /tb_status/TOP_INST/*
add wave -noupdate -group I2C_INST /tb_status/TOP_INST/I2C_INST/*
add wave -noupdate -group GPIO_INST /tb_status/TOP_INST/GPIO_INST/*
add wave -noupdate -group LED_INST /tb_status/TOP_INST/LED_INST/*
add wave -noupdate -group SGPIO_INST1 /tb_status/TOP_INST/SGPIO_INST1/*

TreeUpdate [SetDefaultTree]
#WaveRestoreCursors {{Cursor 5} {118370401 ps} 0}
#quietly wave cursor active 1
#configure wave -namecolwidth 290
#configure wave -valuecolwidth 309
#configure wave -justifyvalue left
#configure wave -signalnamewidth 1
#configure wave -snapdistance 10
#configure wave -datasetprefix 0
#configure wave -rowmargin 4
#configure wave -childrowmargin 2
#configure wave -gridoffset 0
#configure wave -gridperiod 1
#configure wave -griddelta 40
#configure wave -timeline 0
#configure wave -timelineunits ps
#update
#WaveRestoreZoom {627340283 ps} {627703144 ps}
