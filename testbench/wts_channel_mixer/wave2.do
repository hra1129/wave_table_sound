onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb/u_channel_mixer/w_sram_a_a0
add wave -noupdate -radix unsigned /tb/u_channel_mixer/w_sram_a_c0
add wave -noupdate -radix unsigned /tb/u_channel_mixer/w_sram_a_e0
add wave -noupdate -radix unsigned /tb/u_channel_mixer/w_sram_a0
add wave -noupdate -radix decimal /tb/u_channel_mixer/w_sram_q00
add wave -noupdate -radix decimal /tb/u_channel_mixer/w_sram_q0
add wave -noupdate -radix unsigned /tb/u_channel_mixer/w_envelope0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9864 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 241
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {184459655 ps} {185340641 ps}
