onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/clk
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/slot_nreset
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/slot_nint
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/slot_a
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/slot_d
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/slot_nsltsl
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/slot_nmerq
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/slot_nrd
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/slot_nwr
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/sw_mono
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/mem_ncs
add wave -noupdate -radix hexadecimal -childformat {{{/tb/u_wts_for_cartridge/mem_a[7]} -radix hexadecimal} {{/tb/u_wts_for_cartridge/mem_a[6]} -radix hexadecimal} {{/tb/u_wts_for_cartridge/mem_a[5]} -radix hexadecimal} {{/tb/u_wts_for_cartridge/mem_a[4]} -radix hexadecimal} {{/tb/u_wts_for_cartridge/mem_a[3]} -radix hexadecimal} {{/tb/u_wts_for_cartridge/mem_a[2]} -radix hexadecimal} {{/tb/u_wts_for_cartridge/mem_a[1]} -radix hexadecimal} {{/tb/u_wts_for_cartridge/mem_a[0]} -radix hexadecimal}} -subitemconfig {{/tb/u_wts_for_cartridge/mem_a[7]} {-radix hexadecimal} {/tb/u_wts_for_cartridge/mem_a[6]} {-radix hexadecimal} {/tb/u_wts_for_cartridge/mem_a[5]} {-radix hexadecimal} {/tb/u_wts_for_cartridge/mem_a[4]} {-radix hexadecimal} {/tb/u_wts_for_cartridge/mem_a[3]} {-radix hexadecimal} {/tb/u_wts_for_cartridge/mem_a[2]} {-radix hexadecimal} {/tb/u_wts_for_cartridge/mem_a[1]} {-radix hexadecimal} {/tb/u_wts_for_cartridge/mem_a[0]} {-radix hexadecimal}} /tb/u_wts_for_cartridge/mem_a
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/left_out
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/right_out
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/w_mono_out
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/w_left_out
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/w_right_out
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/w_nint
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/w_q
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/w_dir
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/ff_nrd
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/ff_nwr
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/w_wrreq
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/w_rdreq
add wave -noupdate -radix hexadecimal /tb/u_wts_for_cartridge/w_mem_ncs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3045 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 251
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
WaveRestoreZoom {3918879 ps} {8169994 ps}
