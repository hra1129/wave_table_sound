onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/pattern_no
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/nreset
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/clk
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/active
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/address_reset
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/wave_address
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/reg_wave_length
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/reg_frequency_count
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/ff_wave_address
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/ff_frequency_count
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/w_frequency_counter_end
add wave -noupdate -radix unsigned /tb/u_wts_tone_generator/w_address_mask
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 349
configure wave -valuecolwidth 64
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
WaveRestoreZoom {0 ps} {7308756 ps}
