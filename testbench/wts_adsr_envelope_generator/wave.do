onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/nreset
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/clk
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/active
add wave -noupdate -format Analog-Step -height 74 -max 64.0 -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/envelope
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/ch_a_key_on
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/ch_a_key_release
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/ch_a_key_off
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/ff_state_a
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/ff_counter_a
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/ff_level_a
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/key_on
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/key_release
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/key_off
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/reg_ar
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/reg_dr
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/reg_sr
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/reg_rr
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/reg_sl
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/counter_in
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/counter_out
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/state_in
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/state_out
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/level_in
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/level_out
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_state_out
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_counter_end
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_note_end
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_attack_end
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_decay_end
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_rate
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_add_value
add wave -noupdate -radix decimal /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_add_value_ext
add wave -noupdate -radix decimal /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_level_next
add wave -noupdate -radix unsigned /tb/u_wts_adsr_envelope_generator_5ch/u_adsr_envelope_generator/w_attack
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 325
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 2
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
WaveRestoreZoom {16334180 ps} {17642294 ps}
