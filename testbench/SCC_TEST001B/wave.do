onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/clk21m
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/reset
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/req
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ack
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/wrt
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/adr
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/dbi
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/dbo
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ramreq
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ramwrt
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ramadr
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ramdbi
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ramdbo
add wave -noupdate -format Analog-Step -height 74 -max 247.99999999999997 -radix unsigned /tb/u_scc_for_ocm/wavl
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/w_mono_out
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/w_wrreq
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/w_rdreq
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/w_mem_ncs
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/w_mem_a
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/w_q
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ff_wr
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ff_rd
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ff_req1
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/ff_req2
add wave -noupdate -radix unsigned /tb/u_scc_for_ocm/w_ack
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1432 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 262
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
WaveRestoreZoom {0 ps} {2467352916 ps}
