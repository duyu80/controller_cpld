-- simulate the design
-- !!CHANGE THE PATH POINTING TO YOUR SDF FILE!!
vsim -L ovi_machxo2 -PL pmi_work +access +r UFM_WB_TB -noglitch +no_tchk_msg -sdfmax UUT=".\UFM_WB_UFM_WB_vo.sdf"
add wave *
run 1000 us
-- to verify "erase " command the  simulation can be extended upto 110 ms
