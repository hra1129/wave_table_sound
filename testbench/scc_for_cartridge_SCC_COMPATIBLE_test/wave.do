onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_ram00/clk
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/nreset
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/clk
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/envelope
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/noise
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/sram_q
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/reg_volume
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/ff_wave
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/ff_envelope
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/w_wave_mul
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/w_wave_round
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/ff_channel_wave
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/w_channel_mul
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/w_channel_round
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/ff_channel
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/u_channel_volume0/channel
add wave -noupdate /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/w_enable0
add wave -noupdate /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/w_enable1
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/w_left_channel0
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/w_right_channel0
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/w_left_channel1
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/w_right_channel1
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/w_left_channel
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/w_right_channel
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/ff_active
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/ff_left_integ
add wave -noupdate -radix unsigned /tb/u_wts_for_cartridge/u_wts_core/u_wts_channel_mixer/ff_right_integ
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {1254401234 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 339
configure wave -valuecolwidth 40
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
WaveRestoreZoom {1253489060 ps} {1255597226 ps}
