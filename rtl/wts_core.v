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

	wire	[3:0]	reg_volume_a0;
	wire	[1:0]	reg_enable_a0;
	wire			reg_noise_enable_a0;
	wire	[7:0]	reg_ar_a0;
	wire	[7:0]	reg_dr_a0;
	wire	[7:0]	reg_sr_a0;
	wire	[7:0]	reg_rr_a0;
	wire	[5:0]	reg_sl_a0;
	wire	[1:0]	reg_wave_length_a0;
	wire	[11:0]	reg_frequency_count_a0;
	wire	[1:0]	reg_noise_sel_a0;

	wire	[3:0]	reg_volume_b0;
	wire	[1:0]	reg_enable_b0;
	wire			reg_noise_enable_b0;
	wire	[7:0]	reg_ar_b0;
	wire	[7:0]	reg_dr_b0;
	wire	[7:0]	reg_sr_b0;
	wire	[7:0]	reg_rr_b0;
	wire	[5:0]	reg_sl_b0;
	wire	[1:0]	reg_wave_length_b0;
	wire	[11:0]	reg_frequency_count_b0;
	wire	[1:0]	reg_noise_sel_b0;

	wire	[3:0]	reg_volume_c0;
	wire	[1:0]	reg_enable_c0;
	wire			reg_noise_enable_c0;
	wire	[7:0]	reg_ar_c0;
	wire	[7:0]	reg_dr_c0;
	wire	[7:0]	reg_sr_c0;
	wire	[7:0]	reg_rr_c0;
	wire	[5:0]	reg_sl_c0;
	wire	[1:0]	reg_wave_length_c0;
	wire	[11:0]	reg_frequency_count_c0;
	wire	[1:0]	reg_noise_sel_c0;

	wire	[3:0]	reg_volume_d0;
	wire	[1:0]	reg_enable_d0;
	wire			reg_noise_enable_d0;
	wire	[7:0]	reg_ar_d0;
	wire	[7:0]	reg_dr_d0;
	wire	[7:0]	reg_sr_d0;
	wire	[7:0]	reg_rr_d0;
	wire	[5:0]	reg_sl_d0;
	wire	[1:0]	reg_wave_length_d0;
	wire	[11:0]	reg_frequency_count_d0;
	wire	[1:0]	reg_noise_sel_d0;

	wire	[3:0]	reg_volume_e0;
	wire	[1:0]	reg_enable_e0;
	wire			reg_noise_enable_e0;
	wire	[7:0]	reg_ar_e0;
	wire	[7:0]	reg_dr_e0;
	wire	[7:0]	reg_sr_e0;
	wire	[7:0]	reg_rr_e0;
	wire	[5:0]	reg_sl_e0;
	wire	[1:0]	reg_wave_length_e0;
	wire	[11:0]	reg_frequency_count_e0;
	wire	[1:0]	reg_noise_sel_e0;

	wire	[3:0]	reg_volume_a1;
	wire	[1:0]	reg_enable_a1;
	wire			reg_noise_enable_a1;
	wire	[7:0]	reg_ar_a1;
	wire	[7:0]	reg_dr_a1;
	wire	[7:0]	reg_sr_a1;
	wire	[7:0]	reg_rr_a1;
	wire	[5:0]	reg_sl_a1;
	wire	[1:0]	reg_wave_length_a1;
	wire	[11:0]	reg_frequency_count_a1;
	wire	[1:0]	reg_noise_sel_a1;

	wire	[3:0]	reg_volume_b1;
	wire	[1:0]	reg_enable_b1;
	wire			reg_noise_enable_b1;
	wire	[7:0]	reg_ar_b1;
	wire	[7:0]	reg_dr_b1;
	wire	[7:0]	reg_sr_b1;
	wire	[7:0]	reg_rr_b1;
	wire	[5:0]	reg_sl_b1;
	wire	[1:0]	reg_wave_length_b1;
	wire	[11:0]	reg_frequency_count_b1;
	wire	[1:0]	reg_noise_sel_b1;

	wire	[3:0]	reg_volume_c1;
	wire	[1:0]	reg_enable_c1;
	wire			reg_noise_enable_c1;
	wire	[7:0]	reg_ar_c1;
	wire	[7:0]	reg_dr_c1;
	wire	[7:0]	reg_sr_c1;
	wire	[7:0]	reg_rr_c1;
	wire	[5:0]	reg_sl_c1;
	wire	[1:0]	reg_wave_length_c1;
	wire	[11:0]	reg_frequency_count_c1;
	wire	[1:0]	reg_noise_sel_c1;

	wire	[3:0]	reg_volume_d1;
	wire	[1:0]	reg_enable_d1;
	wire			reg_noise_enable_d1;
	wire	[7:0]	reg_ar_d1;
	wire	[7:0]	reg_dr_d1;
	wire	[7:0]	reg_sr_d1;
	wire	[7:0]	reg_rr_d1;
	wire	[5:0]	reg_sl_d1;
	wire	[1:0]	reg_wave_length_d1;
	wire	[11:0]	reg_frequency_count_d1;
	wire	[1:0]	reg_noise_sel_d1;

	wire	[3:0]	reg_volume_e1;
	wire	[1:0]	reg_enable_e1;
	wire			reg_noise_enable_e1;
	wire	[7:0]	reg_ar_e1;
	wire	[7:0]	reg_dr_e1;
	wire	[7:0]	reg_sr_e1;
	wire	[7:0]	reg_rr_e1;
	wire	[5:0]	reg_sl_e1;
	wire	[1:0]	reg_wave_length_e1;
	wire	[11:0]	reg_frequency_count_e1;
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
		.reg_noise_sel_a0		( reg_noise_sel_a0			),
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
		.reg_noise_sel_b0		( reg_noise_sel_b0			),
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
		.reg_noise_sel_c0		( reg_noise_sel_c0			),
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
		.reg_noise_sel_d0		( reg_noise_sel_d0			),
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
		.reg_noise_sel_e0		( reg_noise_sel_e0			),
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
		.reg_noise_sel_a1		( reg_noise_sel_a1			),
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
		.reg_noise_sel_b1		( reg_noise_sel_b1			),
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
		.reg_noise_sel_c1		( reg_noise_sel_c1			),
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
		.reg_noise_sel_d1		( reg_noise_sel_d1			),
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
		.reg_noise_sel_a0		( reg_noise_sel_a0			),
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
		.reg_noise_sel_b0		( reg_noise_sel_b0			),
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
		.reg_noise_sel_c0		( reg_noise_sel_c0			),
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
		.reg_noise_sel_d0		( reg_noise_sel_d0			),
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
		.reg_noise_sel_e0		( reg_noise_sel_e0			),
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
		.reg_noise_sel_a1		( reg_noise_sel_a1			),
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
		.reg_noise_sel_b1		( reg_noise_sel_b1			),
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
		.reg_noise_sel_c1		( reg_noise_sel_c1			),
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
		.reg_noise_sel_d1		( reg_noise_sel_d1			),
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
