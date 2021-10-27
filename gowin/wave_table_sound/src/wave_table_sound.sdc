//Copyright (C)2014-2021 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.2.01 Beta
//Created Time: 2021-10-27 21:44:11
create_clock -name clk -period 44 -waveform {0 22} [get_ports {clk}]
