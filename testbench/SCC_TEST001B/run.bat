vlib work
echo "******** For OCM ********"
vlog ../../rtl_scc/*.v
vlog +define+TARGET="`""../register_access_for_ocm.sv`""" tb.sv
pause "[Please check error(s)]"
vsim -c -t 1ps -do run.do tb
move transcript log.txt
move vsim.wlf ocm.wlf
pause "[Please check error(s)]"

echo "******** For CARTRIDGE ********"
vlog ../../rtl_scc/*.v
vlog +define+TARGET="`""../register_access_for_cartridge.sv`""" tb.sv
pause "[Please check error(s)]"
vsim -c -t 1ps -do run.do tb
move transcript log.txt
move vsim.wlf cartridge.wlf
pause "[Please check error(s)]"
