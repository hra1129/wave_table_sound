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
	input	[15:0]	a,
	output			dir,
	input	[7:0]	d,
	output	[7:0]	q,
	output			nint,
	output			mem_ncs,
	output	[7:0]	mem_a,
	output	[11:0]	left_out,
	output	[11:0]	right_out
);
	wire			ch_a0_key_on;
	wire			ch_a0_key_release;
	wire			ch_a0_key_off;

	wire			ch_b0_key_on;
	wire			ch_b0_key_release;
	wire			ch_b0_key_off;

	wire			ch_c0_key_on;
	wire			ch_c0_key_release;
	wire			ch_c0_key_off;

	wire			ch_d0_key_on;
	wire			ch_d0_key_release;
	wire			ch_d0_key_off;

	wire			ch_e0_key_on;
	wire			ch_e0_key_release;
	wire			ch_e0_key_off;

	wire			ch_f0_key_on;
	wire			ch_f0_key_release;
	wire			ch_f0_key_off;

	wire			ch_a1_key_on;
	wire			ch_a1_key_release;
	wire			ch_a1_key_off;

	wire			ch_b1_key_on;
	wire			ch_b1_key_release;
	wire			ch_b1_key_off;

	wire			ch_c1_key_on;
	wire			ch_c1_key_release;
	wire			ch_c1_key_off;

	wire			ch_d1_key_on;
	wire			ch_d1_key_release;
	wire			ch_d1_key_off;

	wire			ch_e1_key_on;
	wire			ch_e1_key_release;
	wire			ch_e1_key_off;

	wire			ch_f1_key_on;
	wire			ch_f1_key_release;
	wire			ch_f1_key_off;

	wire	[3:0]	sram_id;				//	[2:0]: A...F; [3]: 0 or 1   ex.) A0 = 0000; B1 = 1001; C1 = 1010
	wire	[6:0]	sram_a;
	wire	[7:0]	sram_d;
	wire			sram_oe;
	wire			sram_we;
	wire	[7:0]	sram_q;
	wire			sram_q_en;

	wire	[3:0]	reg_volume_a0;
	wire	[1:0]	reg_enable_a0;
	wire			reg_noise_enable_a0;
	wire	[15:0]	reg_ar_a0;
	wire	[15:0]	reg_dr_a0;
	wire	[15:0]	reg_sr_a0;
	wire	[15:0]	reg_rr_a0;
	wire	[7:0]	reg_sl_a0;
	wire	[1:0]	reg_wave_length_a0;
	wire	[11:0]	reg_frequency_count_a0;
	wire	[4:0]	reg_noise_frequency_a0;

	wire	[3:0]	reg_volume_b0;
	wire	[1:0]	reg_enable_b0;
	wire			reg_noise_enable_b0;
	wire	[15:0]	reg_ar_b0;
	wire	[15:0]	reg_dr_b0;
	wire	[15:0]	reg_sr_b0;
	wire	[15:0]	reg_rr_b0;
	wire	[7:0]	reg_sl_b0;
	wire	[1:0]	reg_wave_length_b0;
	wire	[11:0]	reg_frequency_count_b0;
	wire	[4:0]	reg_noise_frequency_b0;

	wire	[3:0]	reg_volume_c0;
	wire	[1:0]	reg_enable_c0;
	wire			reg_noise_enable_c0;
	wire	[15:0]	reg_ar_c0;
	wire	[15:0]	reg_dr_c0;
	wire	[15:0]	reg_sr_c0;
	wire	[15:0]	reg_rr_c0;
	wire	[7:0]	reg_sl_c0;
	wire	[1:0]	reg_wave_length_c0;
	wire	[11:0]	reg_frequency_count_c0;
	wire	[4:0]	reg_noise_frequency_c0;

	wire	[3:0]	reg_volume_d0;
	wire	[1:0]	reg_enable_d0;
	wire			reg_noise_enable_d0;
	wire	[15:0]	reg_ar_d0;
	wire	[15:0]	reg_dr_d0;
	wire	[15:0]	reg_sr_d0;
	wire	[15:0]	reg_rr_d0;
	wire	[7:0]	reg_sl_d0;
	wire	[1:0]	reg_wave_length_d0;
	wire	[11:0]	reg_frequency_count_d0;
	wire	[4:0]	reg_noise_frequency_d0;

	wire	[3:0]	reg_volume_e0;
	wire	[1:0]	reg_enable_e0;
	wire			reg_noise_enable_e0;
	wire	[15:0]	reg_ar_e0;
	wire	[15:0]	reg_dr_e0;
	wire	[15:0]	reg_sr_e0;
	wire	[15:0]	reg_rr_e0;
	wire	[7:0]	reg_sl_e0;
	wire	[1:0]	reg_wave_length_e0;
	wire	[11:0]	reg_frequency_count_e0;
	wire	[4:0]	reg_noise_frequency_e0;

	wire	[3:0]	reg_volume_f0;
	wire	[1:0]	reg_enable_f0;
	wire			reg_noise_enable_f0;
	wire	[15:0]	reg_ar_f0;
	wire	[15:0]	reg_dr_f0;
	wire	[15:0]	reg_sr_f0;
	wire	[15:0]	reg_rr_f0;
	wire	[7:0]	reg_sl_f0;
	wire	[1:0]	reg_wave_length_f0;
	wire	[11:0]	reg_frequency_count_f0;
	wire	[4:0]	reg_noise_frequency_f0;

	wire	[3:0]	reg_volume_a1;
	wire	[1:0]	reg_enable_a1;
	wire			reg_noise_enable_a1;
	wire	[15:0]	reg_ar_a1;
	wire	[15:0]	reg_dr_a1;
	wire	[15:0]	reg_sr_a1;
	wire	[15:0]	reg_rr_a1;
	wire	[7:0]	reg_sl_a1;
	wire	[1:0]	reg_wave_length_a1;
	wire	[11:0]	reg_frequency_count_a1;
	wire	[4:0]	reg_noise_frequency_a1;

	wire	[3:0]	reg_volume_b1;
	wire	[1:0]	reg_enable_b1;
	wire			reg_noise_enable_b1;
	wire	[15:0]	reg_ar_b1;
	wire	[15:0]	reg_dr_b1;
	wire	[15:0]	reg_sr_b1;
	wire	[15:0]	reg_rr_b1;
	wire	[7:0]	reg_sl_b1;
	wire	[1:0]	reg_wave_length_b1;
	wire	[11:0]	reg_frequency_count_b1;
	wire	[4:0]	reg_noise_frequency_b1;

	wire	[3:0]	reg_volume_c1;
	wire	[1:0]	reg_enable_c1;
	wire			reg_noise_enable_c1;
	wire	[15:0]	reg_ar_c1;
	wire	[15:0]	reg_dr_c1;
	wire	[15:0]	reg_sr_c1;
	wire	[15:0]	reg_rr_c1;
	wire	[7:0]	reg_sl_c1;
	wire	[1:0]	reg_wave_length_c1;
	wire	[11:0]	reg_frequency_count_c1;
	wire	[4:0]	reg_noise_frequency_c1;

	wire	[3:0]	reg_volume_d1;
	wire	[1:0]	reg_enable_d1;
	wire			reg_noise_enable_d1;
	wire	[15:0]	reg_ar_d1;
	wire	[15:0]	reg_dr_d1;
	wire	[15:0]	reg_sr_d1;
	wire	[15:0]	reg_rr_d1;
	wire	[7:0]	reg_sl_d1;
	wire	[1:0]	reg_wave_length_d1;
	wire	[11:0]	reg_frequency_count_d1;
	wire	[4:0]	reg_noise_frequency_d1;

	wire	[3:0]	reg_volume_e1;
	wire	[1:0]	reg_enable_e1;
	wire			reg_noise_enable_e1;
	wire	[15:0]	reg_ar_e1;
	wire	[15:0]	reg_dr_e1;
	wire	[15:0]	reg_sr_e1;
	wire	[15:0]	reg_rr_e1;
	wire	[7:0]	reg_sl_e1;
	wire	[1:0]	reg_wave_length_e1;
	wire	[11:0]	reg_frequency_count_e1;
	wire	[4:0]	reg_noise_frequency_e1;

	wire	[3:0]	reg_volume_f1;
	wire	[1:0]	reg_enable_f1;
	wire			reg_noise_enable_f1;
	wire	[15:0]	reg_ar_f1;
	wire	[15:0]	reg_dr_f1;
	wire	[15:0]	reg_sr_f1;
	wire	[15:0]	reg_rr_f1;
	wire	[7:0]	reg_sl_f1;
	wire	[1:0]	reg_wave_length_f1;
	wire	[11:0]	reg_frequency_count_f1;
	wire	[4:0]	reg_noise_frequency_f1;

	wire	[3:0]	reg_timer1_sel;
	wire	[3:0]	reg_timer2_sel;

	wts_channel_mixer u_wts_channel_mixer (
		.nreset					( nreset					),
		.clk					( clk						),
		.ch_a0_key_on			( ch_a0_key_on				),
		.ch_a0_key_release		( ch_a0_key_release			),
		.ch_a0_key_off			( ch_a0_key_off				),
		.ch_b0_key_on			( ch_b0_key_on				),
		.ch_b0_key_release		( ch_b0_key_release			),
		.ch_b0_key_off			( ch_b0_key_off				),
		.ch_c0_key_on			( ch_c0_key_on				),
		.ch_c0_key_release		( ch_c0_key_release			),
		.ch_c0_key_off			( ch_c0_key_off				),
		.ch_d0_key_on			( ch_d0_key_on				),
		.ch_d0_key_release		( ch_d0_key_release			),
		.ch_d0_key_off			( ch_d0_key_off				),
		.ch_e0_key_on			( ch_e0_key_on				),
		.ch_e0_key_release		( ch_e0_key_release			),
		.ch_e0_key_off			( ch_e0_key_off				),
		.ch_f0_key_on			( ch_f0_key_on				),
		.ch_f0_key_release		( ch_f0_key_release			),
		.ch_f0_key_off			( ch_f0_key_off				),
		.ch_a1_key_on			( ch_a1_key_on				),
		.ch_a1_key_release		( ch_a1_key_release			),
		.ch_a1_key_off			( ch_a1_key_off				),
		.ch_b1_key_on			( ch_b1_key_on				),
		.ch_b1_key_release		( ch_b1_key_release			),
		.ch_b1_key_off			( ch_b1_key_off				),
		.ch_c1_key_on			( ch_c1_key_on				),
		.ch_c1_key_release		( ch_c1_key_release			),
		.ch_c1_key_off			( ch_c1_key_off				),
		.ch_d1_key_on			( ch_d1_key_on				),
		.ch_d1_key_release		( ch_d1_key_release			),
		.ch_d1_key_off			( ch_d1_key_off				),
		.ch_e1_key_on			( ch_e1_key_on				),
		.ch_e1_key_release		( ch_e1_key_release			),
		.ch_e1_key_off			( ch_e1_key_off				),
		.ch_f1_key_on			( ch_f1_key_on				),
		.ch_f1_key_release		( ch_f1_key_release			),
		.ch_f1_key_off			( ch_f1_key_off				),
		.sram_id				( sram_id					),
		.sram_a					( sram_a					),
		.sram_d					( sram_d					),
		.sram_oe				( sram_oe					),
		.sram_we				( sram_we					),
		.sram_q					( sram_q					),
		.sram_q_en				( sram_q_en					),
		.left_out				( left_out					),
		.right_out				( right_out					),
		.reg_volume_a0			( reg_volume_a0				),
		.reg_enable_a0			( reg_enable_a0				),
		.reg_noise_enable_a0	( reg_noise_enable_a0		),
		.reg_ar_a0				( reg_ar_a0					),
		.reg_dr_a0				( reg_dr_a0					),
		.reg_sr_a0				( reg_sr_a0					),
		.reg_rr_a0				( reg_rr_a0					),
		.reg_sl_a0				( reg_sl_a0					),
		.reg_wave_length_a0		( reg_wave_length_a0		),
		.reg_frequency_count_a0	( reg_frequency_count_a0	),
		.reg_noise_frequency_a0	( reg_noise_frequency_a0	),
		.reg_volume_b0			( reg_volume_b0				),
		.reg_enable_b0			( reg_enable_b0				),
		.reg_noise_enable_b0	( reg_noise_enable_b0		),
		.reg_ar_b0				( reg_ar_b0					),
		.reg_dr_b0				( reg_dr_b0					),
		.reg_sr_b0				( reg_sr_b0					),
		.reg_rr_b0				( reg_rr_b0					),
		.reg_sl_b0				( reg_sl_b0					),
		.reg_wave_length_b0		( reg_wave_length_b0		),
		.reg_frequency_count_b0	( reg_frequency_count_b0	),
		.reg_noise_frequency_b0	( reg_noise_frequency_b0	),
		.reg_volume_c0			( reg_volume_c0				),
		.reg_enable_c0			( reg_enable_c0				),
		.reg_noise_enable_c0	( reg_noise_enable_c0		),
		.reg_ar_c0				( reg_ar_c0					),
		.reg_dr_c0				( reg_dr_c0					),
		.reg_sr_c0				( reg_sr_c0					),
		.reg_rr_c0				( reg_rr_c0					),
		.reg_sl_c0				( reg_sl_c0					),
		.reg_wave_length_c0		( reg_wave_length_c0		),
		.reg_frequency_count_c0	( reg_frequency_count_c0	),
		.reg_noise_frequency_c0	( reg_noise_frequency_c0	),
		.reg_volume_d0			( reg_volume_d0				),
		.reg_enable_d0			( reg_enable_d0				),
		.reg_noise_enable_d0	( reg_noise_enable_d0		),
		.reg_ar_d0				( reg_ar_d0					),
		.reg_dr_d0				( reg_dr_d0					),
		.reg_sr_d0				( reg_sr_d0					),
		.reg_rr_d0				( reg_rr_d0					),
		.reg_sl_d0				( reg_sl_d0					),
		.reg_wave_length_d0		( reg_wave_length_d0		),
		.reg_frequency_count_d0	( reg_frequency_count_d0	),
		.reg_noise_frequency_d0	( reg_noise_frequency_d0	),
		.reg_volume_e0			( reg_volume_e0				),
		.reg_enable_e0			( reg_enable_e0				),
		.reg_noise_enable_e0	( reg_noise_enable_e0		),
		.reg_ar_e0				( reg_ar_e0					),
		.reg_dr_e0				( reg_dr_e0					),
		.reg_sr_e0				( reg_sr_e0					),
		.reg_rr_e0				( reg_rr_e0					),
		.reg_sl_e0				( reg_sl_e0					),
		.reg_wave_length_e0		( reg_wave_length_e0		),
		.reg_frequency_count_e0	( reg_frequency_count_e0	),
		.reg_noise_frequency_e0	( reg_noise_frequency_e0	),
		.reg_volume_f0			( reg_volume_f0				),
		.reg_enable_f0			( reg_enable_f0				),
		.reg_noise_enable_f0	( reg_noise_enable_f0		),
		.reg_ar_f0				( reg_ar_f0					),
		.reg_dr_f0				( reg_dr_f0					),
		.reg_sr_f0				( reg_sr_f0					),
		.reg_rr_f0				( reg_rr_f0					),
		.reg_sl_f0				( reg_sl_f0					),
		.reg_wave_length_f0		( reg_wave_length_f0		),
		.reg_frequency_count_f0	( reg_frequency_count_f0	),
		.reg_noise_frequency_f0	( reg_noise_frequency_f0	),
		.reg_volume_a1			( reg_volume_a1				),
		.reg_enable_a1			( reg_enable_a1				),
		.reg_noise_enable_a1	( reg_noise_enable_a1		),
		.reg_ar_a1				( reg_ar_a1					),
		.reg_dr_a1				( reg_dr_a1					),
		.reg_sr_a1				( reg_sr_a1					),
		.reg_rr_a1				( reg_rr_a1					),
		.reg_sl_a1				( reg_sl_a1					),
		.reg_wave_length_a1		( reg_wave_length_a1		),
		.reg_frequency_count_a1	( reg_frequency_count_a1	),
		.reg_noise_frequency_a1	( reg_noise_frequency_a1	),
		.reg_volume_b1			( reg_volume_b1				),
		.reg_enable_b1			( reg_enable_b1				),
		.reg_noise_enable_b1	( reg_noise_enable_b1		),
		.reg_ar_b1				( reg_ar_b1					),
		.reg_dr_b1				( reg_dr_b1					),
		.reg_sr_b1				( reg_sr_b1					),
		.reg_rr_b1				( reg_rr_b1					),
		.reg_sl_b1				( reg_sl_b1					),
		.reg_wave_length_b1		( reg_wave_length_b1		),
		.reg_frequency_count_b1	( reg_frequency_count_b1	),
		.reg_noise_frequency_b1	( reg_noise_frequency_b1	),
		.reg_volume_c1			( reg_volume_c1				),
		.reg_enable_c1			( reg_enable_c1				),
		.reg_noise_enable_c1	( reg_noise_enable_c1		),
		.reg_ar_c1				( reg_ar_c1					),
		.reg_dr_c1				( reg_dr_c1					),
		.reg_sr_c1				( reg_sr_c1					),
		.reg_rr_c1				( reg_rr_c1					),
		.reg_sl_c1				( reg_sl_c1					),
		.reg_wave_length_c1		( reg_wave_length_c1		),
		.reg_frequency_count_c1	( reg_frequency_count_c1	),
		.reg_noise_frequency_c1	( reg_noise_frequency_c1	),
		.reg_volume_d1			( reg_volume_d1				),
		.reg_enable_d1			( reg_enable_d1				),
		.reg_noise_enable_d1	( reg_noise_enable_d1		),
		.reg_ar_d1				( reg_ar_d1					),
		.reg_dr_d1				( reg_dr_d1					),
		.reg_sr_d1				( reg_sr_d1					),
		.reg_rr_d1				( reg_rr_d1					),
		.reg_sl_d1				( reg_sl_d1					),
		.reg_wave_length_d1		( reg_wave_length_d1		),
		.reg_frequency_count_d1	( reg_frequency_count_d1	),
		.reg_noise_frequency_d1	( reg_noise_frequency_d1	),
		.reg_volume_e1			( reg_volume_e1				),
		.reg_enable_e1			( reg_enable_e1				),
		.reg_noise_enable_e1	( reg_noise_enable_e1		),
		.reg_ar_e1				( reg_ar_e1					),
		.reg_dr_e1				( reg_dr_e1					),
		.reg_sr_e1				( reg_sr_e1					),
		.reg_rr_e1				( reg_rr_e1					),
		.reg_sl_e1				( reg_sl_e1					),
		.reg_wave_length_e1		( reg_wave_length_e1		),
		.reg_frequency_count_e1	( reg_frequency_count_e1	),
		.reg_noise_frequency_e1	( reg_noise_frequency_e1	),
		.reg_volume_f1			( reg_volume_f1				),
		.reg_enable_f1			( reg_enable_f1				),
		.reg_noise_enable_f1	( reg_noise_enable_f1		),
		.reg_ar_f1				( reg_ar_f1					),
		.reg_dr_f1				( reg_dr_f1					),
		.reg_sr_f1				( reg_sr_f1					),
		.reg_rr_f1				( reg_rr_f1					),
		.reg_sl_f1				( reg_sl_f1					),
		.reg_wave_length_f1		( reg_wave_length_f1		),
		.reg_frequency_count_f1	( reg_frequency_count_f1	),
		.reg_noise_frequency_f1	( reg_noise_frequency_f1	),
		.reg_timer1_sel			( reg_timer1_sel			),
		.reg_timer2_sel			( reg_timer2_sel			)
	);

	wts_timer u_wts_timer (
		.nreset					( nreset					),
		.clk					( clk						),
		.timer1_trigger			( timer1_trigger			),
		.timer2_trigger			( timer2_trigger			),
		.reg_timer1_enable		( reg_timer1_enable			),
		.reg_timer1_clear		( reg_timer1_clear			),
		.interrupt1				( interrupt1				),
		.reg_timer2_enable		( reg_timer2_enable			),
		.reg_timer2_clear		( reg_timer2_clear			),
		.interrupt2				( interrupt2				),
		.nint					( nint						)
	);

	wts_register u_wts_register (
		.nreset					( nreset					),
		.clk					( clk						),
		.wrreq					( wrreq						),
		.rdreq					( rdreq						),
		.address				( a							),
		.wrdata					( d							),
		.rddata					( q							),
		.ext_memory_address		( mem_a						),
		.sram_id				( sram_id					),
		.sram_a					( sram_a					),
		.sram_d					( sram_d					),
		.sram_oe				( sram_oe					),
		.sram_we				( sram_we					),
		.sram_q					( sram_q					),
		.sram_q_en				( sram_q_en					),
		.ch_a0_key_on			( ch_a0_key_on				),
		.ch_a0_key_release		( ch_a0_key_release			),
		.ch_a0_key_off			( ch_a0_key_off				),
		.ch_b0_key_on			( ch_b0_key_on				),
		.ch_b0_key_release		( ch_b0_key_release			),
		.ch_b0_key_off			( ch_b0_key_off				),
		.ch_c0_key_on			( ch_c0_key_on				),
		.ch_c0_key_release		( ch_c0_key_release			),
		.ch_c0_key_off			( ch_c0_key_off				),
		.ch_d0_key_on			( ch_d0_key_on				),
		.ch_d0_key_release		( ch_d0_key_release			),
		.ch_d0_key_off			( ch_d0_key_off				),
		.ch_e0_key_on			( ch_e0_key_on				),
		.ch_e0_key_release		( ch_e0_key_release			),
		.ch_e0_key_off			( ch_e0_key_off				),
		.ch_f0_key_on			( ch_f0_key_on				),
		.ch_f0_key_release		( ch_f0_key_release			),
		.ch_f0_key_off			( ch_f0_key_off				),
		.ch_a1_key_on			( ch_a1_key_on				),
		.ch_a1_key_release		( ch_a1_key_release			),
		.ch_a1_key_off			( ch_a1_key_off				),
		.ch_b1_key_on			( ch_b1_key_on				),
		.ch_b1_key_release		( ch_b1_key_release			),
		.ch_b1_key_off			( ch_b1_key_off				),
		.ch_c1_key_on			( ch_c1_key_on				),
		.ch_c1_key_release		( ch_c1_key_release			),
		.ch_c1_key_off			( ch_c1_key_off				),
		.ch_d1_key_on			( ch_d1_key_on				),
		.ch_d1_key_release		( ch_d1_key_release			),
		.ch_d1_key_off			( ch_d1_key_off				),
		.ch_e1_key_on			( ch_e1_key_on				),
		.ch_e1_key_release		( ch_e1_key_release			),
		.ch_e1_key_off			( ch_e1_key_off				),
		.ch_f1_key_on			( ch_f1_key_on				),
		.ch_f1_key_release		( ch_f1_key_release			),
		.ch_f1_key_off			( ch_f1_key_off				),
		.reg_volume_a0			( reg_volume_a0				),
		.reg_enable_a0			( reg_enable_a0				),
		.reg_noise_enable_a0	( reg_noise_enable_a0		),
		.reg_ar_a0				( reg_ar_a0					),
		.reg_dr_a0				( reg_dr_a0					),
		.reg_sr_a0				( reg_sr_a0					),
		.reg_rr_a0				( reg_rr_a0					),
		.reg_sl_a0				( reg_sl_a0					),
		.reg_wave_length_a0		( reg_wave_length_a0		),
		.reg_frequency_count_a0	( reg_frequency_count_a0	),
		.reg_noise_frequency_a0	( reg_noise_frequency_a0	),
		.reg_volume_b0			( reg_volume_b0				),
		.reg_enable_b0			( reg_enable_b0				),
		.reg_noise_enable_b0	( reg_noise_enable_b0		),
		.reg_ar_b0				( reg_ar_b0					),
		.reg_dr_b0				( reg_dr_b0					),
		.reg_sr_b0				( reg_sr_b0					),
		.reg_rr_b0				( reg_rr_b0					),
		.reg_sl_b0				( reg_sl_b0					),
		.reg_wave_length_b0		( reg_wave_length_b0		),
		.reg_frequency_count_b0	( reg_frequency_count_b0	),
		.reg_noise_frequency_b0	( reg_noise_frequency_b0	),
		.reg_volume_c0			( reg_volume_c0				),
		.reg_enable_c0			( reg_enable_c0				),
		.reg_noise_enable_c0	( reg_noise_enable_c0		),
		.reg_ar_c0				( reg_ar_c0					),
		.reg_dr_c0				( reg_dr_c0					),
		.reg_sr_c0				( reg_sr_c0					),
		.reg_rr_c0				( reg_rr_c0					),
		.reg_sl_c0				( reg_sl_c0					),
		.reg_wave_length_c0		( reg_wave_length_c0		),
		.reg_frequency_count_c0	( reg_frequency_count_c0	),
		.reg_noise_frequency_c0	( reg_noise_frequency_c0	),
		.reg_volume_d0			( reg_volume_d0				),
		.reg_enable_d0			( reg_enable_d0				),
		.reg_noise_enable_d0	( reg_noise_enable_d0		),
		.reg_ar_d0				( reg_ar_d0					),
		.reg_dr_d0				( reg_dr_d0					),
		.reg_sr_d0				( reg_sr_d0					),
		.reg_rr_d0				( reg_rr_d0					),
		.reg_sl_d0				( reg_sl_d0					),
		.reg_wave_length_d0		( reg_wave_length_d0		),
		.reg_frequency_count_d0	( reg_frequency_count_d0	),
		.reg_noise_frequency_d0	( reg_noise_frequency_d0	),
		.reg_volume_e0			( reg_volume_e0				),
		.reg_enable_e0			( reg_enable_e0				),
		.reg_noise_enable_e0	( reg_noise_enable_e0		),
		.reg_ar_e0				( reg_ar_e0					),
		.reg_dr_e0				( reg_dr_e0					),
		.reg_sr_e0				( reg_sr_e0					),
		.reg_rr_e0				( reg_rr_e0					),
		.reg_sl_e0				( reg_sl_e0					),
		.reg_wave_length_e0		( reg_wave_length_e0		),
		.reg_frequency_count_e0	( reg_frequency_count_e0	),
		.reg_noise_frequency_e0	( reg_noise_frequency_e0	),
		.reg_volume_f0			( reg_volume_f0				),
		.reg_enable_f0			( reg_enable_f0				),
		.reg_noise_enable_f0	( reg_noise_enable_f0		),
		.reg_ar_f0				( reg_ar_f0					),
		.reg_dr_f0				( reg_dr_f0					),
		.reg_sr_f0				( reg_sr_f0					),
		.reg_rr_f0				( reg_rr_f0					),
		.reg_sl_f0				( reg_sl_f0					),
		.reg_wave_length_f0		( reg_wave_length_f0		),
		.reg_frequency_count_f0	( reg_frequency_count_f0	),
		.reg_noise_frequency_f0	( reg_noise_frequency_f0	),
		.reg_volume_a1			( reg_volume_a1				),
		.reg_enable_a1			( reg_enable_a1				),
		.reg_noise_enable_a1	( reg_noise_enable_a1		),
		.reg_ar_a1				( reg_ar_a1					),
		.reg_dr_a1				( reg_dr_a1					),
		.reg_sr_a1				( reg_sr_a1					),
		.reg_rr_a1				( reg_rr_a1					),
		.reg_sl_a1				( reg_sl_a1					),
		.reg_wave_length_a1		( reg_wave_length_a1		),
		.reg_frequency_count_a1	( reg_frequency_count_a1	),
		.reg_noise_frequency_a1	( reg_noise_frequency_a1	),
		.reg_volume_b1			( reg_volume_b1				),
		.reg_enable_b1			( reg_enable_b1				),
		.reg_noise_enable_b1	( reg_noise_enable_b1		),
		.reg_ar_b1				( reg_ar_b1					),
		.reg_dr_b1				( reg_dr_b1					),
		.reg_sr_b1				( reg_sr_b1					),
		.reg_rr_b1				( reg_rr_b1					),
		.reg_sl_b1				( reg_sl_b1					),
		.reg_wave_length_b1		( reg_wave_length_b1		),
		.reg_frequency_count_b1	( reg_frequency_count_b1	),
		.reg_noise_frequency_b1	( reg_noise_frequency_b1	),
		.reg_volume_c1			( reg_volume_c1				),
		.reg_enable_c1			( reg_enable_c1				),
		.reg_noise_enable_c1	( reg_noise_enable_c1		),
		.reg_ar_c1				( reg_ar_c1					),
		.reg_dr_c1				( reg_dr_c1					),
		.reg_sr_c1				( reg_sr_c1					),
		.reg_rr_c1				( reg_rr_c1					),
		.reg_sl_c1				( reg_sl_c1					),
		.reg_wave_length_c1		( reg_wave_length_c1		),
		.reg_frequency_count_c1	( reg_frequency_count_c1	),
		.reg_noise_frequency_c1	( reg_noise_frequency_c1	),
		.reg_volume_d1			( reg_volume_d1				),
		.reg_enable_d1			( reg_enable_d1				),
		.reg_noise_enable_d1	( reg_noise_enable_d1		),
		.reg_ar_d1				( reg_ar_d1					),
		.reg_dr_d1				( reg_dr_d1					),
		.reg_sr_d1				( reg_sr_d1					),
		.reg_rr_d1				( reg_rr_d1					),
		.reg_sl_d1				( reg_sl_d1					),
		.reg_wave_length_d1		( reg_wave_length_d1		),
		.reg_frequency_count_d1	( reg_frequency_count_d1	),
		.reg_noise_frequency_d1	( reg_noise_frequency_d1	),
		.reg_volume_e1			( reg_volume_e1				),
		.reg_enable_e1			( reg_enable_e1				),
		.reg_noise_enable_e1	( reg_noise_enable_e1		),
		.reg_ar_e1				( reg_ar_e1					),
		.reg_dr_e1				( reg_dr_e1					),
		.reg_sr_e1				( reg_sr_e1					),
		.reg_rr_e1				( reg_rr_e1					),
		.reg_sl_e1				( reg_sl_e1					),
		.reg_wave_length_e1		( reg_wave_length_e1		),
		.reg_frequency_count_e1	( reg_frequency_count_e1	),
		.reg_noise_frequency_e1	( reg_noise_frequency_e1	),
		.reg_volume_f1			( reg_volume_f1				),
		.reg_enable_f1			( reg_enable_f1				),
		.reg_noise_enable_f1	( reg_noise_enable_f1		),
		.reg_ar_f1				( reg_ar_f1					),
		.reg_dr_f1				( reg_dr_f1					),
		.reg_sr_f1				( reg_sr_f1					),
		.reg_rr_f1				( reg_rr_f1					),
		.reg_sl_f1				( reg_sl_f1					),
		.reg_wave_length_f1		( reg_wave_length_f1		),
		.reg_frequency_count_f1	( reg_frequency_count_f1	),
		.reg_noise_frequency_f1	( reg_noise_frequency_f1	)
	);
endmodule
