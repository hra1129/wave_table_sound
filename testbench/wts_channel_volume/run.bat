vlib work
vlog ../../rtl/wts_channel_volume.v
vlog tb.sv
pause "[Please check error(s)]"
vsim -c -t 1ps -do run.do tb
move transcript log.txt
pause "[Please check error(s)]"
