vlib work
vlog ../../rtl/wts_adsr_envelope_generator.v
vlog tb.sv
pause "[Please check error(s)]"
vsim -c -t 1ps -do run.do tb
move transcript log.txt
