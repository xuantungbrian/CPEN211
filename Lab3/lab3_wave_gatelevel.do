onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab3_top_tb_3/KEY
add wave -noupdate /lab3_top_tb_3/SW
add wave -noupdate /lab3_top_tb_3/err
add wave -noupdate /lab3_top_tb_3/HEX0
add wave -noupdate /lab3_top_tb_3/HEX1
add wave -noupdate /lab3_top_tb_3/HEX2
add wave -noupdate /lab3_top_tb_3/HEX3
add wave -noupdate /lab3_top_tb_3/HEX4
add wave -noupdate /lab3_top_tb_3/HEX5
add wave -noupdate /lab3_top_tb_3/LEDR
add wave -noupdate /lab3_top_tb_3/state
add wave -noupdate /lab3_top_tb_3/binary
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {70 ps}
