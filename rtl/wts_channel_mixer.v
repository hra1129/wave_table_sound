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

module wts_channel_mixer (
	input			nreset,
	input			clk,

	input			ch_a0_key_on,
	input			ch_a0_key_release,
	input			ch_a0_key_off,

	input			ch_b0_key_on,
	input			ch_b0_key_release,
	input			ch_b0_key_off,

	input			ch_c0_key_on,
	input			ch_c0_key_release,
	input			ch_c0_key_off,

	input			ch_d0_key_on,
	input			ch_d0_key_release,
	input			ch_d0_key_off,

	input			ch_e0_key_on,
	input			ch_e0_key_release,
	input			ch_e0_key_off,

	input			ch_a1_key_on,
	input			ch_a1_key_release,
	input			ch_a1_key_off,

	input			ch_b1_key_on,
	input			ch_b1_key_release,
	input			ch_b1_key_off,

	input			ch_c1_key_on,
	input			ch_c1_key_release,
	input			ch_c1_key_off,

	input			ch_d1_key_on,
	input			ch_d1_key_release,
	input			ch_d1_key_off,

	input			ch_e1_key_on,
	input			ch_e1_key_release,
	input			ch_e1_key_off,

	input	[3:0]	sram_id,				//	[2:0]: A...F, [3]: 0 or 1   ex.) A0 = 0000, B1 = 1001, C1 = 1010
	input	[6:0]	sram_a,
	input	[7:0]	sram_d,
	input			sram_oe,
	input			sram_we,
	output	[7:0]	sram_q,
	output			sram_q_en,

	output	[11:0]	left_out,
	output	[11:0]	right_out,

	input	[3:0]	reg_volume_a0,
	input	[1:0]	reg_enable_a0,
	input			reg_noise_enable_a0,
	input	[7:0]	reg_ar_a0,
	input	[7:0]	reg_dr_a0,
	input	[7:0]	reg_sr_a0,
	input	[7:0]	reg_rr_a0,
	input	[3:0]	reg_sl_a0,
	input	[1:0]	reg_wave_length_a0,
	input	[11:0]	reg_frequency_count_a0,
	input	[1:0]	reg_noise_sel_a0,

	input	[3:0]	reg_volume_b0,
	input	[1:0]	reg_enable_b0,
	input			reg_noise_enable_b0,
	input	[7:0]	reg_ar_b0,
	input	[7:0]	reg_dr_b0,
	input	[7:0]	reg_sr_b0,
	input	[7:0]	reg_rr_b0,
	input	[3:0]	reg_sl_b0,
	input	[1:0]	reg_wave_length_b0,
	input	[11:0]	reg_frequency_count_b0,
	input	[1:0]	reg_noise_sel_b0,

	input	[3:0]	reg_volume_c0,
	input	[1:0]	reg_enable_c0,
	input			reg_noise_enable_c0,
	input	[7:0]	reg_ar_c0,
	input	[7:0]	reg_dr_c0,
	input	[7:0]	reg_sr_c0,
	input	[7:0]	reg_rr_c0,
	input	[3:0]	reg_sl_c0,
	input	[1:0]	reg_wave_length_c0,
	input	[11:0]	reg_frequency_count_c0,
	input	[1:0]	reg_noise_sel_c0,

	input	[3:0]	reg_volume_d0,
	input	[1:0]	reg_enable_d0,
	input			reg_noise_enable_d0,
	input	[7:0]	reg_ar_d0,
	input	[7:0]	reg_dr_d0,
	input	[7:0]	reg_sr_d0,
	input	[7:0]	reg_rr_d0,
	input	[3:0]	reg_sl_d0,
	input	[1:0]	reg_wave_length_d0,
	input	[11:0]	reg_frequency_count_d0,
	input	[1:0]	reg_noise_sel_d0,

	input	[3:0]	reg_volume_e0,
	input	[1:0]	reg_enable_e0,
	input			reg_noise_enable_e0,
	input	[7:0]	reg_ar_e0,
	input	[7:0]	reg_dr_e0,
	input	[7:0]	reg_sr_e0,
	input	[7:0]	reg_rr_e0,
	input	[3:0]	reg_sl_e0,
	input	[1:0]	reg_wave_length_e0,
	input	[11:0]	reg_frequency_count_e0,
	input	[1:0]	reg_noise_sel_e0,

	input	[3:0]	reg_volume_a1,
	input	[1:0]	reg_enable_a1,
	input			reg_noise_enable_a1,
	input	[7:0]	reg_ar_a1,
	input	[7:0]	reg_dr_a1,
	input	[7:0]	reg_sr_a1,
	input	[7:0]	reg_rr_a1,
	input	[3:0]	reg_sl_a1,
	input	[1:0]	reg_wave_length_a1,
	input	[11:0]	reg_frequency_count_a1,
	input	[1:0]	reg_noise_sel_a1,

	input	[3:0]	reg_volume_b1,
	input	[1:0]	reg_enable_b1,
	input			reg_noise_enable_b1,
	input	[7:0]	reg_ar_b1,
	input	[7:0]	reg_dr_b1,
	input	[7:0]	reg_sr_b1,
	input	[7:0]	reg_rr_b1,
	input	[3:0]	reg_sl_b1,
	input	[1:0]	reg_wave_length_b1,
	input	[11:0]	reg_frequency_count_b1,
	input	[1:0]	reg_noise_sel_b1,

	input	[3:0]	reg_volume_c1,
	input	[1:0]	reg_enable_c1,
	input			reg_noise_enable_c1,
	input	[7:0]	reg_ar_c1,
	input	[7:0]	reg_dr_c1,
	input	[7:0]	reg_sr_c1,
	input	[7:0]	reg_rr_c1,
	input	[3:0]	reg_sl_c1,
	input	[1:0]	reg_wave_length_c1,
	input	[11:0]	reg_frequency_count_c1,
	input	[1:0]	reg_noise_sel_c1,

	input	[3:0]	reg_volume_d1,
	input	[1:0]	reg_enable_d1,
	input			reg_noise_enable_d1,
	input	[7:0]	reg_ar_d1,
	input	[7:0]	reg_dr_d1,
	input	[7:0]	reg_sr_d1,
	input	[7:0]	reg_rr_d1,
	input	[3:0]	reg_sl_d1,
	input	[1:0]	reg_wave_length_d1,
	input	[11:0]	reg_frequency_count_d1,
	input	[1:0]	reg_noise_sel_d1,

	input	[3:0]	reg_volume_e1,
	input	[1:0]	reg_enable_e1,
	input			reg_noise_enable_e1,
	input	[7:0]	reg_ar_e1,
	input	[7:0]	reg_dr_e1,
	input	[7:0]	reg_sr_e1,
	input	[7:0]	reg_rr_e1,
	input	[3:0]	reg_sl_e1,
	input	[1:0]	reg_wave_length_e1,
	input	[11:0]	reg_frequency_count_e1,
	input	[1:0]	reg_noise_sel_e1,

	input	[4:0]	reg_noise_frequency0,
	input	[4:0]	reg_noise_frequency1,
	input	[4:0]	reg_noise_frequency2,
	input	[4:0]	reg_noise_frequency3,

	input	[3:0]	reg_timer1_channel,
	output			timer1_trigger,
	output	[1:0]	timer1_address,
	input	[3:0]	reg_timer2_channel,
	output			timer2_trigger,
	output	[1:0]	timer2_address
);

	reg		[2:0]	ff_active;
	wire	[6:0]	w_sram_a_a0;
	wire	[6:0]	w_sram_a_b0;
	wire	[6:0]	w_sram_a_c0;
	wire	[6:0]	w_sram_a_d0;
	wire	[6:0]	w_sram_a_e0;
	wire	[6:0]	w_sram_a_a1;
	wire	[6:0]	w_sram_a_b1;
	wire	[6:0]	w_sram_a_c1;
	wire	[6:0]	w_sram_a_d1;
	wire	[6:0]	w_sram_a_e1;
	wire	[3:0]	w_volume0;
	wire	[3:0]	w_volume1;
	wire	[1:0]	w_enable0;
	wire	[1:0]	w_enable1;
	wire	[9:0]	w_sram_a0;
	wire	[9:0]	w_sram_a1;
	wire	[7:0]	w_sram_q0;
	wire	[7:0]	w_sram_q1;
	wire	[7:0]	w_channel0;
	wire	[4:0]	w_envelope0;
	wire	[4:0]	w_envelope1;
	wire	[7:0]	w_left_channel0;
	wire	[7:0]	w_right_channel0;
	wire	[7:0]	w_channel1;
	wire	[7:0]	w_left_channel1;
	wire	[7:0]	w_right_channel1;
	wire	[8:0]	w_left_channel;
	wire	[8:0]	w_right_channel;
	reg		[11:0]	ff_left_integ;
	reg		[11:0]	ff_right_integ;
	reg		[11:0]	ff_left_out;
	reg		[11:0]	ff_right_out;

	reg		[3:0]	ff_sram_id;
	reg		[6:0]	ff_sram_a;
	reg		[7:0]	ff_sram_d;
	reg				ff_sram_oe;
	reg				ff_sram_we;
	reg				ff_sram_q_en;
	reg				ff_sram_id_d;
	wire			w_sram_done;

	wire	[6:0]	w_wave_address0;
	wire	[6:0]	w_wave_address1;
	wire			w_sram_we0;
	wire			w_sram_we1;
	wire			w_noise0;
	wire			w_noise1;
	wire			w_half_timing0;
	wire			w_half_timing1;

	function func_trigger_sel (
		input	[3:0]	reg_timer_sel,
		input			half_timing_a0,
		input			half_timing_b0,
		input			half_timing_c0,
		input			half_timing_d0,
		input			half_timing_e0,
		input			half_timing_a1,
		input			half_timing_b1,
		input			half_timing_c1,
		input			half_timing_d1,
		input			half_timing_e1
	);
		case( reg_timer_sel )
		4'd0:		func_trigger_sel = half_timing_a0;
		4'd1:		func_trigger_sel = half_timing_b0;
		4'd2:		func_trigger_sel = half_timing_c0;
		4'd3:		func_trigger_sel = half_timing_d0;
		4'd4:		func_trigger_sel = half_timing_e0;
		4'd5:		func_trigger_sel = half_timing_a1;
		4'd6:		func_trigger_sel = half_timing_b1;
		4'd7:		func_trigger_sel = half_timing_c1;
		4'd8:		func_trigger_sel = half_timing_d1;
		4'd9:		func_trigger_sel = half_timing_e1;
		default:	func_trigger_sel = 1'b0;
		endcase
	endfunction

	function [1:0] func_address_sel (
		input	[3:0]	reg_timer_sel,
		input	[1:0]	half_address_a0,
		input	[1:0]	half_address_b0,
		input	[1:0]	half_address_c0,
		input	[1:0]	half_address_d0,
		input	[1:0]	half_address_e0,
		input	[1:0]	half_address_a1,
		input	[1:0]	half_address_b1,
		input	[1:0]	half_address_c1,
		input	[1:0]	half_address_d1,
		input	[1:0]	half_address_e1
	);
		case( reg_timer_sel )
		4'd0:		func_address_sel = half_address_a0;
		4'd1:		func_address_sel = half_address_b0;
		4'd2:		func_address_sel = half_address_c0;
		4'd3:		func_address_sel = half_address_d0;
		4'd4:		func_address_sel = half_address_e0;
		4'd5:		func_address_sel = half_address_a1;
		4'd6:		func_address_sel = half_address_b1;
		4'd7:		func_address_sel = half_address_c1;
		4'd8:		func_address_sel = half_address_d1;
		4'd9:		func_address_sel = half_address_e1;
		default:	func_address_sel = 3'b0;
		endcase
	endfunction

	function [1:0] func_wave_length_sel (
		input	[3:0]	reg_timer_sel,
		input	[1:0]	wave_length_a0,
		input	[1:0]	wave_length_b0,
		input	[1:0]	wave_length_c0,
		input	[1:0]	wave_length_d0,
		input	[1:0]	wave_length_e0,
		input	[1:0]	wave_length_a1,
		input	[1:0]	wave_length_b1,
		input	[1:0]	wave_length_c1,
		input	[1:0]	wave_length_d1,
		input	[1:0]	wave_length_e1
	);
		case( reg_timer_sel )
		4'd0:		func_wave_length_sel = wave_length_a0;
		4'd1:		func_wave_length_sel = wave_length_b0;
		4'd2:		func_wave_length_sel = wave_length_c0;
		4'd3:		func_wave_length_sel = wave_length_d0;
		4'd4:		func_wave_length_sel = wave_length_e0;
		4'd5:		func_wave_length_sel = wave_length_a1;
		4'd6:		func_wave_length_sel = wave_length_b1;
		4'd7:		func_wave_length_sel = wave_length_c1;
		4'd8:		func_wave_length_sel = wave_length_d1;
		4'd9:		func_wave_length_sel = wave_length_e1;
		default:	func_wave_length_sel = 2'b0;
		endcase
	endfunction

	// ------------------------------------------------------------------------
	//	TIMER1
	// ------------------------------------------------------------------------
	assign timer1_trigger	= (ff_active == reg_timer1_channel[2:0]) ? ( (reg_timer1_channel[3] == 1'b0) ? w_half_timing0 : w_half_timing1 ) : 1'b0;
	assign timer1_address	= (reg_timer1_channel[3] == 1'b0) ? w_wave_address0[6:5] : w_wave_address1[6:5];

	// ------------------------------------------------------------------------
	//	TIMER2
	// ------------------------------------------------------------------------
	assign timer2_trigger	= (ff_active == reg_timer2_channel[2:0]) ? ( (reg_timer2_channel[3] == 1'b0) ? w_half_timing0 : w_half_timing1 ) : 1'b0;
	assign timer2_address	= (reg_timer2_channel[3] == 1'b0) ? w_wave_address0[6:5] : w_wave_address1[6:5];

	// ------------------------------------------------------------------------
	//	CPU SRAM ACCESS INTERFACE
	// ------------------------------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_sram_oe <= 1'b0;
		end
		else if( sram_oe ) begin
			ff_sram_oe <= 1'b1;
		end
		else if( w_sram_done ) begin
			ff_sram_oe <= 1'b0;
		end
		else begin
			//	hold
		end
	end

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_sram_we <= 1'b0;
		end
		else if( sram_we ) begin
			ff_sram_we <= 1'b1;
		end
		else if( w_sram_done ) begin
			ff_sram_we <= 1'b0;
		end
		else begin
			//	hold
		end
	end

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_sram_id <= 4'b0;
		end
		else if( sram_oe | sram_we ) begin
			ff_sram_id <= sram_id;
		end
		else begin
			//	hold
		end
	end

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_sram_q_en <= 1'b0;
		end
		else if( w_sram_done ) begin
			ff_sram_q_en <= ff_sram_oe;
		end
		else begin
			ff_sram_q_en <= 1'b0;
		end
	end

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_sram_id_d <= 1'b0;
		end
		else if( w_sram_done && ff_sram_we ) begin
			ff_sram_id_d <= ff_sram_id[3];
		end
	end

	assign w_sram_done	= (ff_active == 3'd5) ? 1'b1 : 1'b0;
	assign sram_q_en	= ff_sram_q_en;
	assign sram_q		= ( ff_sram_id[3] ) ? w_sram_q1 : w_sram_q0;

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_sram_a <= 7'd0;
			ff_sram_d <= 8'd0;
		end
		else if( sram_oe || sram_we ) begin
			ff_sram_a <= sram_a;
			ff_sram_d <= sram_d;
		end
		else begin
			//	hold
		end
	end

	// ------------------------------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_active <= 3'd0;
		end
		else begin
			ff_active <= ff_active + 3'd1;
		end
	end

	wts_adsr_envelope_generator_5ch u_adsr_envelope_generator_5ch_0 (
		.nreset						( nreset						),
		.clk						( clk							),
		.active						( ff_active						),
		.envelope					( w_envelope0					),
		.ch_a_key_on				( ch_a0_key_on					),
		.ch_a_key_release			( ch_a0_key_release				),
		.ch_a_key_off				( ch_a0_key_off					),
		.ch_b_key_on				( ch_b0_key_on					),
		.ch_b_key_release			( ch_b0_key_release				),
		.ch_b_key_off				( ch_b0_key_off					),
		.ch_c_key_on				( ch_c0_key_on					),
		.ch_c_key_release			( ch_c0_key_release				),
		.ch_c_key_off				( ch_c0_key_off					),
		.ch_d_key_on				( ch_d0_key_on					),
		.ch_d_key_release			( ch_d0_key_release				),
		.ch_d_key_off				( ch_d0_key_off					),
		.ch_e_key_on				( ch_e0_key_on					),
		.ch_e_key_release			( ch_e0_key_release				),
		.ch_e_key_off				( ch_e0_key_off					),
		.reg_ar_a					( reg_ar_a0						),
		.reg_dr_a					( reg_dr_a0						),
		.reg_sr_a					( reg_sr_a0						),
		.reg_rr_a					( reg_rr_a0						),
		.reg_sl_a					( reg_sl_a0						),
		.reg_wave_length_a			( reg_wave_length_a0			),
		.reg_frequency_count_a		( reg_frequency_count_a0		),
		.reg_ar_b					( reg_ar_b0						),
		.reg_dr_b					( reg_dr_b0						),
		.reg_sr_b					( reg_sr_b0						),
		.reg_rr_b					( reg_rr_b0						),
		.reg_sl_b					( reg_sl_b0						),
		.reg_wave_length_b			( reg_wave_length_b0			),
		.reg_frequency_count_b		( reg_frequency_count_b0		),
		.reg_ar_c					( reg_ar_c0						),
		.reg_dr_c					( reg_dr_c0						),
		.reg_sr_c					( reg_sr_c0						),
		.reg_rr_c					( reg_rr_c0						),
		.reg_sl_c					( reg_sl_c0						),
		.reg_wave_length_c			( reg_wave_length_c0			),
		.reg_frequency_count_c		( reg_frequency_count_c0		),
		.reg_ar_d					( reg_ar_d0						),
		.reg_dr_d					( reg_dr_d0						),
		.reg_sr_d					( reg_sr_d0						),
		.reg_rr_d					( reg_rr_d0						),
		.reg_sl_d					( reg_sl_d0						),
		.reg_wave_length_d			( reg_wave_length_d0			),
		.reg_frequency_count_d		( reg_frequency_count_d0		),
		.reg_ar_e					( reg_ar_e0						),
		.reg_dr_e					( reg_dr_e0						),
		.reg_sr_e					( reg_sr_e0						),
		.reg_rr_e					( reg_rr_e0						),
		.reg_sl_e					( reg_sl_e0						),
		.reg_wave_length_e			( reg_wave_length_e0			),
		.reg_frequency_count_e		( reg_frequency_count_e0		)
	);

	wts_adsr_envelope_generator_5ch u_adsr_envelope_generator_5ch_1 (
		.nreset						( nreset						),
		.clk						( clk							),
		.active						( ff_active						),
		.envelope					( w_envelope1					),
		.ch_a_key_on				( ch_a1_key_on					),
		.ch_a_key_release			( ch_a1_key_release				),
		.ch_a_key_off				( ch_a1_key_off					),
		.ch_b_key_on				( ch_b1_key_on					),
		.ch_b_key_release			( ch_b1_key_release				),
		.ch_b_key_off				( ch_b1_key_off					),
		.ch_c_key_on				( ch_c1_key_on					),
		.ch_c_key_release			( ch_c1_key_release				),
		.ch_c_key_off				( ch_c1_key_off					),
		.ch_d_key_on				( ch_d1_key_on					),
		.ch_d_key_release			( ch_d1_key_release				),
		.ch_d_key_off				( ch_d1_key_off					),
		.ch_e_key_on				( ch_e1_key_on					),
		.ch_e_key_release			( ch_e1_key_release				),
		.ch_e_key_off				( ch_e1_key_off					),
		.reg_ar_a					( reg_ar_a1						),
		.reg_dr_a					( reg_dr_a1						),
		.reg_sr_a					( reg_sr_a1						),
		.reg_rr_a					( reg_rr_a1						),
		.reg_sl_a					( reg_sl_a1						),
		.reg_wave_length_a			( reg_wave_length_a1			),
		.reg_frequency_count_a		( reg_frequency_count_a1		),
		.reg_ar_b					( reg_ar_b1						),
		.reg_dr_b					( reg_dr_b1						),
		.reg_sr_b					( reg_sr_b1						),
		.reg_rr_b					( reg_rr_b1						),
		.reg_sl_b					( reg_sl_b1						),
		.reg_wave_length_b			( reg_wave_length_b1			),
		.reg_frequency_count_b		( reg_frequency_count_b1		),
		.reg_ar_c					( reg_ar_c1						),
		.reg_dr_c					( reg_dr_c1						),
		.reg_sr_c					( reg_sr_c1						),
		.reg_rr_c					( reg_rr_c1						),
		.reg_sl_c					( reg_sl_c1						),
		.reg_wave_length_c			( reg_wave_length_c1			),
		.reg_frequency_count_c		( reg_frequency_count_c1		),
		.reg_ar_d					( reg_ar_d1						),
		.reg_dr_d					( reg_dr_d1						),
		.reg_sr_d					( reg_sr_d1						),
		.reg_rr_d					( reg_rr_d1						),
		.reg_sl_d					( reg_sl_d1						),
		.reg_wave_length_d			( reg_wave_length_d1			),
		.reg_frequency_count_d		( reg_frequency_count_d1		),
		.reg_ar_e					( reg_ar_e1						),
		.reg_dr_e					( reg_dr_e1						),
		.reg_sr_e					( reg_sr_e1						),
		.reg_rr_e					( reg_rr_e1						),
		.reg_sl_e					( reg_sl_e1						),
		.reg_wave_length_e			( reg_wave_length_e1			),
		.reg_frequency_count_e		( reg_frequency_count_e1		)
	);

	wts_noise_generator_4ch u_wts_noise_generator_4ch (
		.nreset						( nreset						),
		.clk						( clk							),
		.active						( ff_active						),
		.noise0						( w_noise0						),
		.noise1						( w_noise1						),
		.reg_noise_enable_a0		( reg_noise_enable_a0			),
		.reg_noise_enable_b0		( reg_noise_enable_b0			),
		.reg_noise_enable_c0		( reg_noise_enable_c0			),
		.reg_noise_enable_d0		( reg_noise_enable_d0			),
		.reg_noise_enable_e0		( reg_noise_enable_e0			),
		.reg_noise_enable_a1		( reg_noise_enable_a1			),
		.reg_noise_enable_b1		( reg_noise_enable_b1			),
		.reg_noise_enable_c1		( reg_noise_enable_c1			),
		.reg_noise_enable_d1		( reg_noise_enable_d1			),
		.reg_noise_enable_e1		( reg_noise_enable_e1			),
		.reg_noise_sel_a0			( reg_noise_sel_a0				),
		.reg_noise_sel_b0			( reg_noise_sel_b0				),
		.reg_noise_sel_c0			( reg_noise_sel_c0				),
		.reg_noise_sel_d0			( reg_noise_sel_d0				),
		.reg_noise_sel_e0			( reg_noise_sel_e0				),
		.reg_noise_sel_a1			( reg_noise_sel_a1				),
		.reg_noise_sel_b1			( reg_noise_sel_b1				),
		.reg_noise_sel_c1			( reg_noise_sel_c1				),
		.reg_noise_sel_d1			( reg_noise_sel_d1				),
		.reg_noise_sel_e1			( reg_noise_sel_e1				),
		.reg_noise_frequency0		( reg_noise_frequency0			),
		.reg_noise_frequency1		( reg_noise_frequency1			),
		.reg_noise_frequency2		( reg_noise_frequency2			),
		.reg_noise_frequency3		( reg_noise_frequency3			)
	);

	wts_tone_generator_5ch u_tone_generator_5ch_0 (
		.nreset						( nreset						),
		.clk						( clk							),
		.active						( ff_active						),
		.address_reset				( address_reset					),
		.wave_address				( w_wave_address0				),
		.half_timing				( w_half_timing0				),
		.reg_wave_length_a			( reg_wave_length_a0			),
		.reg_wave_length_b			( reg_wave_length_b0			),
		.reg_wave_length_c			( reg_wave_length_c0			),
		.reg_wave_length_d			( reg_wave_length_d0			),
		.reg_wave_length_e			( reg_wave_length_e0			),
		.reg_frequency_count_a		( reg_frequency_count_a0		),
		.reg_frequency_count_b		( reg_frequency_count_b0		),
		.reg_frequency_count_c		( reg_frequency_count_c0		),
		.reg_frequency_count_d		( reg_frequency_count_d0		),
		.reg_frequency_count_e		( reg_frequency_count_e0		)
	);

	wts_tone_generator_5ch u_tone_generator_5ch_1 (
		.nreset						( nreset						),
		.clk						( clk							),
		.active						( ff_active						),
		.address_reset				( address_reset					),
		.wave_address				( w_wave_address1				),
		.half_timing				( w_half_timing1				),
		.reg_wave_length_a			( reg_wave_length_a1			),
		.reg_wave_length_b			( reg_wave_length_b1			),
		.reg_wave_length_c			( reg_wave_length_c1			),
		.reg_wave_length_d			( reg_wave_length_d1			),
		.reg_wave_length_e			( reg_wave_length_e1			),
		.reg_frequency_count_a		( reg_frequency_count_a1		),
		.reg_frequency_count_b		( reg_frequency_count_b1		),
		.reg_frequency_count_c		( reg_frequency_count_c1		),
		.reg_frequency_count_d		( reg_frequency_count_d1		),
		.reg_frequency_count_e		( reg_frequency_count_e1		)
	);

	wts_selector #( 4 ) u_volume_selector0 (
		.active		( ff_active				),
		.result		( w_volume0				),
		.reg_a		( reg_volume_a0			),
		.reg_b		( reg_volume_b0			),
		.reg_c		( reg_volume_c0			),
		.reg_d		( reg_volume_d0			),
		.reg_e		( reg_volume_e0			)
	);

	wts_selector #( 4 ) u_volume_selector1 (
		.active		( ff_active				),
		.result		( w_volume1				),
		.reg_a		( reg_volume_a1			),
		.reg_b		( reg_volume_b1			),
		.reg_c		( reg_volume_c1			),
		.reg_d		( reg_volume_d1			),
		.reg_e		( reg_volume_e1			)
	);

	wts_selector #( 2 ) u_enable_selector0 (
		.active		( ff_active				),
		.result		( w_enable0				),
		.reg_a		( reg_enable_a0			),
		.reg_b		( reg_enable_b0			),
		.reg_c		( reg_enable_c0			),
		.reg_d		( reg_enable_d0			),
		.reg_e		( reg_enable_e0			)
	);

	wts_selector #( 2 ) u_enable_selector1 (
		.active		( ff_active				),
		.result		( w_enable1				),
		.reg_a		( reg_enable_a1			),
		.reg_b		( reg_enable_b1			),
		.reg_c		( reg_enable_c1			),
		.reg_d		( reg_enable_d1			),
		.reg_e		( reg_enable_e1			)
	);

	assign w_sram_a0	= ( ff_active == 3'd5 ) ? { ff_sram_id[2:0], ff_sram_a } : { ff_active, w_wave_address0 };
	assign w_sram_a1	= ( ff_active == 3'd5 ) ? { ff_sram_id[2:0], ff_sram_a } : { ff_active, w_wave_address1 };

	assign w_sram_we0	= ((ff_active == 3'd5) && (ff_sram_id[3] == 1'b0)) ? ff_sram_we : 1'b0;
	assign w_sram_we1	= ((ff_active == 3'd5) && (ff_sram_id[3] == 1'b1)) ? ff_sram_we : 1'b0;

	wts_ram u_ram00 (
		.clk			( clk				),
		.sram_we		( w_sram_we0		),
		.sram_a			( w_sram_a0			),
		.sram_d			( ff_sram_d			),
		.sram_q			( w_sram_q0			)
	);

	wts_ram u_ram10 (
		.clk			( clk				),
		.sram_we		( w_sram_we1		),
		.sram_a			( w_sram_a1			),
		.sram_d			( ff_sram_d			),
		.sram_q			( w_sram_q1			)
	);

	wts_channel_volume u_channel_volume0 (
		.nreset			( nreset			),
		.clk			( clk				),
		.envelope		( w_envelope0		),
		.noise			( w_noise0			),
		.sram_q			( w_sram_q0			),
		.channel		( w_channel0		),
		.reg_volume		( w_volume0			)
	);

	wts_channel_volume u_channel_volume1 (
		.nreset			( nreset			),
		.clk			( clk				),
		.envelope		( w_envelope1		),
		.noise			( w_noise1			),
		.sram_q			( w_sram_q1			),
		.channel		( w_channel1		),
		.reg_volume		( w_volume1			)
	);

	assign w_left_channel0		= w_enable0[1] ? w_channel0 : 8'd0;
	assign w_right_channel0		= w_enable0[0] ? w_channel0 : 8'd0;

	assign w_left_channel1		= w_enable1[1] ? w_channel1 : 8'd0;
	assign w_right_channel1		= w_enable1[0] ? w_channel1 : 8'd0;

	assign w_left_channel		= { w_left_channel0[7] , w_left_channel0  } + { w_left_channel1[7] , w_left_channel1  };
	assign w_right_channel		= { w_right_channel0[7], w_right_channel0 } + { w_right_channel1[7], w_right_channel1 };

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_left_integ		<= 12'd0;
			ff_right_integ		<= 12'd0;
		end
		else if( ff_active == 3'd5 ) begin
			ff_left_integ		<= { { 3 { w_left_channel[8]  } }, w_left_channel  };
			ff_right_integ		<= { { 3 { w_right_channel[8] } }, w_right_channel };
		end
		else begin
			ff_left_integ		<= ff_left_integ  + { { 3 { w_left_channel[8]  } }, w_left_channel  };
			ff_right_integ		<= ff_right_integ + { { 3 { w_right_channel[8] } }, w_right_channel };
		end
	end

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_left_out			<= 12'b1000_0000_0000;
			ff_right_out		<= 12'b1000_0000_0000;
		end
		else if( ff_active == 3'd5 ) begin
			ff_left_out			<= { ~ff_left_integ[11] , ff_left_integ[10:0]  };
			ff_right_out		<= { ~ff_right_integ[11], ff_right_integ[10:0] };
		end
		else begin
			//	hold
		end
	end

	assign left_out		= ff_left_out;
	assign right_out	= ff_right_out;
endmodule
