# Active-HDL design settings
-- Simulate the design
vsim -L ovi_machxo2 -PL pmi_work +access +r UFM_WB_tb
add wave *
run 1000 us
-- to verify "erase " command the  simulation can be extended upto 110 ms