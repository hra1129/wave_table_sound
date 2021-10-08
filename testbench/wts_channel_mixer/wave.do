onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/u_channel_mixer/u_ch_a0/clk
add wave -noupdate /tb/u_channel_mixer/u_ch_a0/key_on
add wave -noupdate -format Analog-Step -height 74 -max 256.0 -radix unsigned -childformat {{{/tb/u_channel_mixer/u_ch_a0/envelope[8]} -radix unsigned} {{/tb/u_channel_mixer/u_ch_a0/envelope[7]} -radix unsigned} {{/tb/u_channel_mixer/u_ch_a0/envelope[6]} -radix unsigned} {{/tb/u_channel_mixer/u_ch_a0/envelope[5]} -radix unsigned} {{/tb/u_channel_mixer/u_ch_a0/envelope[4]} -radix unsigned} {{/tb/u_channel_mixer/u_ch_a0/envelope[3]} -radix unsigned} {{/tb/u_channel_mixer/u_ch_a0/envelope[2]} -radix unsigned} {{/tb/u_channel_mixer/u_ch_a0/envelope[1]} -radix unsigned} {{/tb/u_channel_mixer/u_ch_a0/envelope[0]} -radix unsigned}} -subitemconfig {{/tb/u_channel_mixer/u_ch_a0/envelope[8]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/u_ch_a0/envelope[7]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/u_ch_a0/envelope[6]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/u_ch_a0/envelope[5]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/u_ch_a0/envelope[4]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/u_ch_a0/envelope[3]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/u_ch_a0/envelope[2]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/u_ch_a0/envelope[1]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/u_ch_a0/envelope[0]} {-height 15 -radix unsigned}} /tb/u_channel_mixer/u_ch_a0/envelope
add wave -noupdate -format Analog-Step -height 74 -max 256.0 -radix unsigned -childformat {{{/tb/u_channel_mixer/w_envelope0[8]} -radix unsigned} {{/tb/u_channel_mixer/w_envelope0[7]} -radix unsigned} {{/tb/u_channel_mixer/w_envelope0[6]} -radix unsigned} {{/tb/u_channel_mixer/w_envelope0[5]} -radix unsigned} {{/tb/u_channel_mixer/w_envelope0[4]} -radix unsigned} {{/tb/u_channel_mixer/w_envelope0[3]} -radix unsigned} {{/tb/u_channel_mixer/w_envelope0[2]} -radix unsigned} {{/tb/u_channel_mixer/w_envelope0[1]} -radix unsigned} {{/tb/u_channel_mixer/w_envelope0[0]} -radix unsigned}} -subitemconfig {{/tb/u_channel_mixer/w_envelope0[8]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/w_envelope0[7]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/w_envelope0[6]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/w_envelope0[5]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/w_envelope0[4]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/w_envelope0[3]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/w_envelope0[2]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/w_envelope0[1]} {-height 15 -radix unsigned} {/tb/u_channel_mixer/w_envelope0[0]} {-height 15 -radix unsigned}} /tb/u_channel_mixer/w_envelope0
add wave -noupdate -format Analog-Step -height 74 -max 254.99999999999997 -radix unsigned /tb/u_channel_mixer/w_channel0
add wave -noupdate -format Analog-Step -height 74 -max 14.999999999999998 -radix unsigned /tb/u_channel_mixer/w_volume0
add wave -noupdate /tb/u_channel_mixer/ff_active
add wave -noupdate -format Analog-Step -height 74 -max 126.99999999999997 -min -128.0 -radix decimal -childformat {{{/tb/u_channel_mixer/w_sram_q00[7]} -radix decimal} {{/tb/u_channel_mixer/w_sram_q00[6]} -radix decimal} {{/tb/u_channel_mixer/w_sram_q00[5]} -radix decimal} {{/tb/u_channel_mixer/w_sram_q00[4]} -radix decimal} {{/tb/u_channel_mixer/w_sram_q00[3]} -radix decimal} {{/tb/u_channel_mixer/w_sram_q00[2]} -radix decimal} {{/tb/u_channel_mixer/w_sram_q00[1]} -radix decimal} {{/tb/u_channel_mixer/w_sram_q00[0]} -radix decimal}} -subitemconfig {{/tb/u_channel_mixer/w_sram_q00[7]} {-height 15 -radix decimal} {/tb/u_channel_mixer/w_sram_q00[6]} {-height 15 -radix decimal} {/tb/u_channel_mixer/w_sram_q00[5]} {-height 15 -radix decimal} {/tb/u_channel_mixer/w_sram_q00[4]} {-height 15 -radix decimal} {/tb/u_channel_mixer/w_sram_q00[3]} {-height 15 -radix decimal} {/tb/u_channel_mixer/w_sram_q00[2]} {-height 15 -radix decimal} {/tb/u_channel_mixer/w_sram_q00[1]} {-height 15 -radix decimal} {/tb/u_channel_mixer/w_sram_q00[0]} {-height 15 -radix decimal}} /tb/u_channel_mixer/w_sram_q00
add wave -noupdate -format Analog-Step -height 74 -max 117.00000000000001 -min -120.0 -radix decimal /tb/u_channel_mixer/w_left_channel
add wave -noupdate -format Analog-Step -height 74 -max 117.00000000000001 -min -120.0 -radix decimal /tb/u_channel_mixer/w_right_channel
add wave -noupdate /tb/u_channel_mixer/w_enable0
add wave -noupdate /tb/u_channel_mixer/w_enable1
add wave -noupdate -format Analog-Step -height 74 -max 2165.0 -min 1847.0 -radix unsigned /tb/left_out
add wave -noupdate -format Analog-Step -height 74 -max 2165.0 -min 1847.0 -radix unsigned /tb/right_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81364461 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 275
configure wave -valuecolwidth 92
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
WaveRestoreZoom {0 ps} {4535315316 ps}
