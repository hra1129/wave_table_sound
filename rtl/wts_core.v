// ------------------------------------------------------------------------------------------------
// Wave Table Sound
// Copyright 2021 t.hara
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH 
// THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// ------------------------------------------------------------------------------------------------

module wts_core (
	input			nreset,
	input			clk,
	input			wrreq,
	input			rdreq,
	input			wr_active,
	input			rd_active,
	input	[14:0]	a,
	input	[7:0]	d,
	output	[7:0]	q,
	output			nint,
	output			mem_ncs,
	output	[7:0]	mem_a,
	output	[11:0]	left_out,
	output	[11:0]	right_out
);
	wire	[2:0]	active;

	wire			ch0_key_on;
	wire			ch0_key_release;
	wire			ch0_key_off;

	wire			ch1_key_on;
	wire			ch1_key_release;
	wire			ch1_key_off;

	wire			sram_ce0;				//	A0...E0
	wire			sram_ce1;				//	A1...E1
	wire	[2:0]	sram_id;				//	A...E
	wire	[6:0]	sram_a;
	wire	[7:0]	sram_d;
	wire			sram_oe;
	wire			sram_we;
	wire	[7:0]	sram_q;
	wire			sram_q_en;

	wire			adsr_en;

	wire	[7:0]	reg_ar0;
	wire	[7:0]	reg_dr0;
	wire	[7:0]	reg_sr0;
	wire	[7:0]	reg_rr0;
	wire	[5:0]	reg_sl0;
	wire	[1:0]	reg_wave_length0;
	wire	[11:0]	reg_frequency_count0;
	wire	[3:0]	reg_volume0;
	wire	[1:0]	reg_enable0;

	wire	[7:0]	reg_ar1;
	wire	[7:0]	reg_dr1;
	wire	[7:0]	reg_sr1;
	wire	[7:0]	reg_rr1;
	wire	[5:0]	reg_sl1;
	wire	[1:0]	reg_wave_length1;
	wire	[11:0]	reg_frequency_count1;
	wire	[3:0]	reg_volume1;
	wire	[1:0]	reg_enable1;

	wire			reg_noise_enable_a0;
	wire	[1:0]	reg_noise_sel_a0;
	wire			reg_noise_enable_b0;
	wire	[1:0]	reg_noise_sel_b0;
	wire			reg_noise_enable_c0;
	wire	[1:0]	reg_noise_sel_c0;
	wire			reg_noise_enable_d0;
	wire	[1:0]	reg_noise_sel_d0;
	wire			reg_noise_enable_e0;
	wire	[1:0]	reg_noise_sel_e0;
	wire			reg_noise_enable_a1;
	wire	[1:0]	reg_noise_sel_a1;
	wire			reg_noise_enable_b1;
	wire	[1:0]	reg_noise_sel_b1;
	wire			reg_noise_enable_c1;
	wire	[1:0]	reg_noise_sel_c1;
	wire			reg_noise_enable_d1;
	wire	[1:0]	reg_noise_sel_d1;
	wire			reg_noise_enable_e1;
	wire	[1:0]	reg_noise_sel_e1;

	wire	[4:0]	reg_noise_frequency0;
	wire	[4:0]	reg_noise_frequency1;
	wire	[4:0]	reg_noise_frequency2;
	wire	[4:0]	reg_noise_frequency3;

	wire			w_timer1_trigger;
	wire	[1:0]	w_timer1_address;
	wire			reg_timer1_enable;
	wire			reg_timer1_oneshot;
	wire	[3:0]	reg_timer1_channel;
	wire			reg_timer1_clear;
	wire	[7:0]	w_timer1_status;

	wire			w_timer2_trigger;
	wire	[1:0]	w_timer2_address;
	wire			reg_timer2_enable;
	wire			reg_timer2_oneshot;
	wire	[3:0]	reg_timer2_channel;
	wire			reg_timer2_clear;
	wire	[7:0]	w_timer2_status;

	wts_channel_mixer u_wts_channel_mixer (
		.nreset					( nreset					),
		.clk					( clk						),
		.ch0_key_on				( ch0_key_on				),
		.ch0_key_release		( ch0_key_release			),
		.ch0_key_off			( ch0_key_off				),
		.ch1_key_on				( ch1_key_on				),
		.ch1_key_release		( ch1_key_release			),
		.ch1_key_off			( ch1_key_off				),
		.sram_ce0				( sram_ce0					),
		.sram_ce1				( sram_ce1					),
		.sram_id				( sram_id					),
		.sram_a					( sram_a					),
		.sram_d					( sram_d					),
		.sram_oe				( sram_oe					),
		.sram_we				( sram_we					),
		.sram_q					( sram_q					),
		.sram_q_en				( sram_q_en					),
		.active					( active					),
		.adsr_en				( adsr_en					),
		.left_out				( left_out					),
		.right_out				( right_out					),
		.reg_ar0				( reg_ar0					),
		.reg_dr0				( reg_dr0					),
		.reg_sr0				( reg_sr0					),
		.reg_rr0				( reg_rr0					),
		.reg_sl0				( reg_sl0					),
		.reg_wave_length0		( reg_wave_length0			),
		.reg_frequency_count0	( reg_frequency_count0		),
		.reg_volume0			( reg_volume0				),
		.reg_enable0			( reg_enable0				),
		.reg_ar1				( reg_ar1					),
		.reg_dr1				( reg_dr1					),
		.reg_sr1				( reg_sr1					),
		.reg_rr1				( reg_rr1					),
		.reg_sl1				( reg_sl1					),
		.reg_wave_length1		( reg_wave_length1			),
		.reg_frequency_count1	( reg_frequency_count1		),
		.reg_volume1			( reg_volume1				),
		.reg_enable1			( reg_enable1				),
		.reg_noise_enable_a0	( reg_noise_enable_a0		),
		.reg_noise_sel_a0		( reg_noise_sel_a0			),
		.reg_noise_enable_b0	( reg_noise_enable_b0		),
		.reg_noise_sel_b0		( reg_noise_sel_b0			),
		.reg_noise_enable_c0	( reg_noise_enable_c0		),
		.reg_noise_sel_c0		( reg_noise_sel_c0			),
		.reg_noise_enable_d0	( reg_noise_enable_d0		),
		.reg_noise_sel_d0		( reg_noise_sel_d0			),
		.reg_noise_enable_e0	( reg_noise_enable_e0		),
		.reg_noise_sel_e0		( reg_noise_sel_e0			),
		.reg_noise_enable_a1	( reg_noise_enable_a1		),
		.reg_noise_sel_a1		( reg_noise_sel_a1			),
		.reg_noise_enable_b1	( reg_noise_enable_b1		),
		.reg_noise_sel_b1		( reg_noise_sel_b1			),
		.reg_noise_enable_c1	( reg_noise_enable_c1		),
		.reg_noise_sel_c1		( reg_noise_sel_c1			),
		.reg_noise_enable_d1	( reg_noise_enable_d1		),
		.reg_noise_sel_d1		( reg_noise_sel_d1			),
		.reg_noise_enable_e1	( reg_noise_enable_e1		),
		.reg_noise_sel_e1		( reg_noise_sel_e1			),
		.reg_noise_frequency0	( reg_noise_frequency0		),
		.reg_noise_frequency1	( reg_noise_frequency1		),
		.reg_noise_frequency2	( reg_noise_frequency2		),
		.reg_noise_frequency3	( reg_noise_frequency3		),
		.reg_timer1_channel		( reg_timer1_channel		),
		.timer1_trigger			( w_timer1_trigger			),
		.timer1_address			( w_timer1_address			),
		.reg_timer2_channel		( reg_timer2_channel		),
		.timer2_trigger			( w_timer2_trigger			),
		.timer2_address			( w_timer2_address			)
	);

	wts_timer u_wts_timer (
		.nreset					( nreset					),
		.clk					( clk						),
		.timer1_trigger			( w_timer1_trigger			),
		.timer1_address			( w_timer1_address			),
		.reg_timer1_enable		( reg_timer1_enable			),
		.reg_timer1_clear		( reg_timer1_clear			),
		.timer1_status			( w_timer1_status			),
		.timer2_trigger			( w_timer2_trigger			),
		.timer2_address			( w_timer2_address			),
		.reg_timer2_enable		( reg_timer2_enable			),
		.reg_timer2_clear		( reg_timer2_clear			),
		.timer2_status			( w_timer2_status			),
		.nint					( nint						)
	);

	wts_register u_wts_register (
		.nreset					( nreset					),
		.clk					( clk						),
		.wrreq					( wrreq						),
		.rdreq					( rdreq						),
		.wr_active				( wr_active					),
		.rd_active				( rd_active					),
		.address				( a							),
		.wrdata					( d							),
		.rddata					( q							),
		.active					( active					),
		.ext_memory_nactive		( mem_ncs					),
		.ext_memory_address		( mem_a						),
		.sram_ce0				( sram_ce0					),
		.sram_ce1				( sram_ce1					),
		.sram_id				( sram_id					),
		.sram_a					( sram_a					),
		.sram_d					( sram_d					),
		.sram_oe				( sram_oe					),
		.sram_we				( sram_we					),
		.sram_q					( sram_q					),
		.sram_q_en				( sram_q_en					),
		.adsr_en				( adsr_en					),
		.ch0_key_on				( ch0_key_on				),
		.ch0_key_release		( ch0_key_release			),
		.ch0_key_off			( ch0_key_off				),
		.ch1_key_on				( ch1_key_on				),
		.ch1_key_release		( ch1_key_release			),
		.ch1_key_off			( ch1_key_off				),
		.reg_ar0				( reg_ar0					),
		.reg_dr0				( reg_dr0					),
		.reg_sr0				( reg_sr0					),
		.reg_rr0				( reg_rr0					),
		.reg_sl0				( reg_sl0					),
		.reg_wave_length0		( reg_wave_length0			),
		.reg_frequency_count0	( reg_frequency_count0		),
		.reg_volume0			( reg_volume0				),
		.reg_enable0			( reg_enable0				),
		.reg_ar1				( reg_ar1					),
		.reg_dr1				( reg_dr1					),
		.reg_sr1				( reg_sr1					),
		.reg_rr1				( reg_rr1					),
		.reg_sl1				( reg_sl1					),
		.reg_wave_length1		( reg_wave_length1			),
		.reg_frequency_count1	( reg_frequency_count1		),
		.reg_volume1			( reg_volume1				),
		.reg_enable1			( reg_enable1				),
		.reg_noise_enable_a0	( reg_noise_enable_a0		),
		.reg_noise_sel_a0		( reg_noise_sel_a0			),
		.reg_noise_enable_b0	( reg_noise_enable_b0		),
		.reg_noise_sel_b0		( reg_noise_sel_b0			),
		.reg_noise_enable_c0	( reg_noise_enable_c0		),
		.reg_noise_sel_c0		( reg_noise_sel_c0			),
		.reg_noise_enable_d0	( reg_noise_enable_d0		),
		.reg_noise_sel_d0		( reg_noise_sel_d0			),
		.reg_noise_enable_e0	( reg_noise_enable_e0		),
		.reg_noise_sel_e0		( reg_noise_sel_e0			),
		.reg_noise_enable_a1	( reg_noise_enable_a1		),
		.reg_noise_sel_a1		( reg_noise_sel_a1			),
		.reg_noise_enable_b1	( reg_noise_enable_b1		),
		.reg_noise_sel_b1		( reg_noise_sel_b1			),
		.reg_noise_enable_c1	( reg_noise_enable_c1		),
		.reg_noise_sel_c1		( reg_noise_sel_c1			),
		.reg_noise_enable_d1	( reg_noise_enable_d1		),
		.reg_noise_sel_d1		( reg_noise_sel_d1			),
		.reg_noise_enable_e1	( reg_noise_enable_e1		),
		.reg_noise_sel_e1		( reg_noise_sel_e1			),
		.reg_noise_frequency0	( reg_noise_frequency0		),
		.reg_noise_frequency1	( reg_noise_frequency1		),
		.reg_noise_frequency2	( reg_noise_frequency2		),
		.reg_noise_frequency3	( reg_noise_frequency3		),
		.reg_timer1_enable		( reg_timer1_enable			),
		.reg_timer1_channel		( reg_timer1_channel		),
		.reg_timer1_clear		( reg_timer1_clear			),
		.timer1_status			( w_timer1_status			),
		.reg_timer2_enable		( reg_timer2_enable			),
		.reg_timer2_channel		( reg_timer2_channel		),
		.reg_timer2_clear		( reg_timer2_clear			),
		.timer2_status			( w_timer2_status			)
	);
endmodule
