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

	input			ch_f0_key_on,
	input			ch_f0_key_release,
	input			ch_f0_key_off,

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

	input			ch_f1_key_on,
	input			ch_f1_key_release,
	input			ch_f1_key_off,

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
	input	[15:0]	reg_ar_a0,
	input	[15:0]	reg_dr_a0,
	input	[15:0]	reg_sr_a0,
	input	[15:0]	reg_rr_a0,
	input	[7:0]	reg_sl_a0,
	input	[1:0]	reg_wave_length_a0,
	input	[11:0]	reg_frequency_count_a0,
	input	[4:0]	reg_noise_frequency_a0,

	input	[3:0]	reg_volume_b0,
	input	[1:0]	reg_enable_b0,
	input			reg_noise_enable_b0,
	input	[15:0]	reg_ar_b0,
	input	[15:0]	reg_dr_b0,
	input	[15:0]	reg_sr_b0,
	input	[15:0]	reg_rr_b0,
	input	[7:0]	reg_sl_b0,
	input	[1:0]	reg_wave_length_b0,
	input	[11:0]	reg_frequency_count_b0,
	input	[4:0]	reg_noise_frequency_b0,

	input	[3:0]	reg_volume_c0,
	input	[1:0]	reg_enable_c0,
	input			reg_noise_enable_c0,
	input	[15:0]	reg_ar_c0,
	input	[15:0]	reg_dr_c0,
	input	[15:0]	reg_sr_c0,
	input	[15:0]	reg_rr_c0,
	input	[7:0]	reg_sl_c0,
	input	[1:0]	reg_wave_length_c0,
	input	[11:0]	reg_frequency_count_c0,
	input	[4:0]	reg_noise_frequency_c0,

	input	[3:0]	reg_volume_d0,
	input	[1:0]	reg_enable_d0,
	input			reg_noise_enable_d0,
	input	[15:0]	reg_ar_d0,
	input	[15:0]	reg_dr_d0,
	input	[15:0]	reg_sr_d0,
	input	[15:0]	reg_rr_d0,
	input	[7:0]	reg_sl_d0,
	input	[1:0]	reg_wave_length_d0,
	input	[11:0]	reg_frequency_count_d0,
	input	[4:0]	reg_noise_frequency_d0,

	input	[3:0]	reg_volume_e0,
	input	[1:0]	reg_enable_e0,
	input			reg_noise_enable_e0,
	input	[15:0]	reg_ar_e0,
	input	[15:0]	reg_dr_e0,
	input	[15:0]	reg_sr_e0,
	input	[15:0]	reg_rr_e0,
	input	[7:0]	reg_sl_e0,
	input	[1:0]	reg_wave_length_e0,
	input	[11:0]	reg_frequency_count_e0,
	input	[4:0]	reg_noise_frequency_e0,

	input	[3:0]	reg_volume_f0,
	input	[1:0]	reg_enable_f0,
	input			reg_noise_enable_f0,
	input	[15:0]	reg_ar_f0,
	input	[15:0]	reg_dr_f0,
	input	[15:0]	reg_sr_f0,
	input	[15:0]	reg_rr_f0,
	input	[7:0]	reg_sl_f0,
	input	[1:0]	reg_wave_length_f0,
	input	[11:0]	reg_frequency_count_f0,
	input	[4:0]	reg_noise_frequency_f0,

	input	[3:0]	reg_volume_a1,
	input	[1:0]	reg_enable_a1,
	input			reg_noise_enable_a1,
	input	[15:0]	reg_ar_a1,
	input	[15:0]	reg_dr_a1,
	input	[15:0]	reg_sr_a1,
	input	[15:0]	reg_rr_a1,
	input	[7:0]	reg_sl_a1,
	input	[1:0]	reg_wave_length_a1,
	input	[11:0]	reg_frequency_count_a1,
	input	[4:0]	reg_noise_frequency_a1,

	input	[3:0]	reg_volume_b1,
	input	[1:0]	reg_enable_b1,
	input			reg_noise_enable_b1,
	input	[15:0]	reg_ar_b1,
	input	[15:0]	reg_dr_b1,
	input	[15:0]	reg_sr_b1,
	input	[15:0]	reg_rr_b1,
	input	[7:0]	reg_sl_b1,
	input	[1:0]	reg_wave_length_b1,
	input	[11:0]	reg_frequency_count_b1,
	input	[4:0]	reg_noise_frequency_b1,

	input	[3:0]	reg_volume_c1,
	input	[1:0]	reg_enable_c1,
	input			reg_noise_enable_c1,
	input	[15:0]	reg_ar_c1,
	input	[15:0]	reg_dr_c1,
	input	[15:0]	reg_sr_c1,
	input	[15:0]	reg_rr_c1,
	input	[7:0]	reg_sl_c1,
	input	[1:0]	reg_wave_length_c1,
	input	[11:0]	reg_frequency_count_c1,
	input	[4:0]	reg_noise_frequency_c1,

	input	[3:0]	reg_volume_d1,
	input	[1:0]	reg_enable_d1,
	input			reg_noise_enable_d1,
	input	[15:0]	reg_ar_d1,
	input	[15:0]	reg_dr_d1,
	input	[15:0]	reg_sr_d1,
	input	[15:0]	reg_rr_d1,
	input	[7:0]	reg_sl_d1,
	input	[1:0]	reg_wave_length_d1,
	input	[11:0]	reg_frequency_count_d1,
	input	[4:0]	reg_noise_frequency_d1,

	input	[3:0]	reg_volume_e1,
	input	[1:0]	reg_enable_e1,
	input			reg_noise_enable_e1,
	input	[15:0]	reg_ar_e1,
	input	[15:0]	reg_dr_e1,
	input	[15:0]	reg_sr_e1,
	input	[15:0]	reg_rr_e1,
	input	[7:0]	reg_sl_e1,
	input	[1:0]	reg_wave_length_e1,
	input	[11:0]	reg_frequency_count_e1,
	input	[4:0]	reg_noise_frequency_e1,

	input	[3:0]	reg_volume_f1,
	input	[1:0]	reg_enable_f1,
	input			reg_noise_enable_f1,
	input	[15:0]	reg_ar_f1,
	input	[15:0]	reg_dr_f1,
	input	[15:0]	reg_sr_f1,
	input	[15:0]	reg_rr_f1,
	input	[7:0]	reg_sl_f1,
	input	[1:0]	reg_wave_length_f1,
	input	[11:0]	reg_frequency_count_f1,
	input	[4:0]	reg_noise_frequency_f1
);

	reg		[5:0]	ff_active;
	wire	[6:0]	w_sram_a_a0;
	wire	[6:0]	w_sram_a_b0;
	wire	[6:0]	w_sram_a_c0;
	wire	[6:0]	w_sram_a_d0;
	wire	[6:0]	w_sram_a_e0;
	wire	[6:0]	w_sram_a_f0;
	wire	[6:0]	w_sram_a_a1;
	wire	[6:0]	w_sram_a_b1;
	wire	[6:0]	w_sram_a_c1;
	wire	[6:0]	w_sram_a_d1;
	wire	[6:0]	w_sram_a_e1;
	wire	[6:0]	w_sram_a_f1;
	wire	[3:0]	w_volume0;
	wire	[3:0]	w_volume1;
	wire	[1:0]	w_enable0;
	wire	[1:0]	w_enable1;
	wire	[8:0]	w_sram_a0;
	wire	[8:0]	w_sram_a1;
	wire	[7:0]	w_sram_q0;
	wire	[7:0]	w_sram_q00;
	wire	[7:0]	w_sram_q01;
	wire	[7:0]	w_sram_q1;
	wire	[7:0]	w_sram_q10;
	wire	[7:0]	w_sram_q11;
	wire	[7:0]	w_channel0;
	wire	[8:0]	w_envelope0;
	wire	[8:0]	w_envelope1;
	wire	[8:0]	w_envelope_a0;
	wire	[8:0]	w_envelope_b0;
	wire	[8:0]	w_envelope_c0;
	wire	[8:0]	w_envelope_d0;
	wire	[8:0]	w_envelope_e0;
	wire	[8:0]	w_envelope_f0;
	wire	[8:0]	w_envelope_a1;
	wire	[8:0]	w_envelope_b1;
	wire	[8:0]	w_envelope_c1;
	wire	[8:0]	w_envelope_d1;
	wire	[8:0]	w_envelope_e1;
	wire	[8:0]	w_envelope_f1;
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
	reg		[7:0]	ff_sram_q;
	reg				ff_sram_q_en;
	reg				ff_sram_id_d;
	wire			w_sram_done;

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
			ff_sram_q <= 8'd0;
			ff_sram_id_d <= 1'b0;
		end
		else if( w_sram_done && ff_sram_we ) begin
			ff_sram_q <= ff_sram_oe;
			ff_sram_id_d <= ff_sram_id[3];
		end
	end

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_sram_q <= 8'd0;
		end
		else if( sram_oe || sram_we ) begin
			if( !ff_sram_id_d ) begin
				if( ff_active[1] || ff_active[3] || ff_active[5] ) begin
					ff_sram_q <= w_sram_q00;
				end
				else begin
					ff_sram_q <= w_sram_q01;
				end
			end
			else begin
				if( ff_active[1] || ff_active[3] || ff_active[5] ) begin
					ff_sram_q <= w_sram_q10;
				end
				else begin
					ff_sram_q <= w_sram_q11;
				end
			end
		end
		else begin
			//	hold
		end
	end

	assign w_sram_done	= (ff_sram_we | ff_sram_oe) & (
	                      ( ff_sram_id[0] & (ff_active[1] | ff_active[3] | ff_active[5])) |
	                      (~ff_sram_id[0] & (ff_active[0] | ff_active[2] | ff_active[4])) );
	assign sram_q_en	= ff_sram_q_en;
	assign sram_q		= (!ff_sram_id[3] && !ff_sram_id[0]) ? w_sram_q00 :
	                      (!ff_sram_id[3] &&  ff_sram_id[0]) ? w_sram_q01 :
	                      ( ff_sram_id[3] && !ff_sram_id[0]) ? w_sram_q10 : w_sram_q11;

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
			ff_active <= 6'b000001;
		end
		else begin
			ff_active <= { ff_active[4:0], ff_active[5] };
		end
	end

	wts_channel_part u_ch_a0 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[0]				),
		.key_on						( ch_a0_key_on				),
		.key_release				( ch_a0_key_release			),
		.key_off					( ch_a0_key_off				),
		.envelope					( w_envelope_a0				),
		.sram_a						( w_sram_a_a0				),
		.reg_noise_enable			( reg_noise_enable_a0		),
		.reg_ar						( reg_ar_a0					),
		.reg_dr						( reg_dr_a0					),
		.reg_sr						( reg_sr_a0					),
		.reg_rr						( reg_rr_a0					),
		.reg_sl						( reg_sl_a0					),
		.reg_wave_length			( reg_wave_length_a0		),
		.reg_frequency_count		( reg_frequency_count_a0	),
		.reg_noise_frequency_count	( reg_noise_frequency_a0	)
	);

	wts_channel_part u_ch_b0 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[1]				),
		.key_on						( ch_b0_key_on				),
		.key_release				( ch_b0_key_release			),
		.key_off					( ch_b0_key_off				),
		.envelope					( w_envelope_b0				),
		.sram_a						( w_sram_a_b0				),
		.reg_noise_enable			( reg_noise_enable_b0		),
		.reg_ar						( reg_ar_b0					),
		.reg_dr						( reg_dr_b0					),
		.reg_sr						( reg_sr_b0					),
		.reg_rr						( reg_rr_b0					),
		.reg_sl						( reg_sl_b0					),
		.reg_wave_length			( reg_wave_length_b0		),
		.reg_frequency_count		( reg_frequency_count_b0	),
		.reg_noise_frequency_count	( reg_noise_frequency_b0	)
	);

	wts_channel_part u_ch_c0 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[2]				),
		.key_on						( ch_c0_key_on				),
		.key_release				( ch_c0_key_release			),
		.key_off					( ch_c0_key_off				),
		.envelope					( w_envelope_c0				),
		.sram_a						( w_sram_a_c0				),
		.reg_noise_enable			( reg_noise_enable_c0		),
		.reg_ar						( reg_ar_c0					),
		.reg_dr						( reg_dr_c0					),
		.reg_sr						( reg_sr_c0					),
		.reg_rr						( reg_rr_c0					),
		.reg_sl						( reg_sl_c0					),
		.reg_wave_length			( reg_wave_length_c0		),
		.reg_frequency_count		( reg_frequency_count_c0	),
		.reg_noise_frequency_count	( reg_noise_frequency_c0	)
	);

	wts_channel_part u_ch_d0 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[3]				),
		.key_on						( ch_d0_key_on				),
		.key_release				( ch_d0_key_release			),
		.key_off					( ch_d0_key_off				),
		.envelope					( w_envelope_d0				),
		.sram_a						( w_sram_a_d0				),
		.reg_noise_enable			( reg_noise_enable_d0		),
		.reg_ar						( reg_ar_d0					),
		.reg_dr						( reg_dr_d0					),
		.reg_sr						( reg_sr_d0					),
		.reg_rr						( reg_rr_d0					),
		.reg_sl						( reg_sl_d0					),
		.reg_wave_length			( reg_wave_length_d0		),
		.reg_frequency_count		( reg_frequency_count_d0	),
		.reg_noise_frequency_count	( reg_noise_frequency_d0	)
	);

	wts_channel_part u_ch_e0 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[4]				),
		.key_on						( ch_e0_key_on				),
		.key_release				( ch_e0_key_release			),
		.key_off					( ch_e0_key_off				),
		.envelope					( w_envelope_e0				),
		.sram_a						( w_sram_a_e0				),
		.reg_noise_enable			( reg_noise_enable_e0		),
		.reg_ar						( reg_ar_e0					),
		.reg_dr						( reg_dr_e0					),
		.reg_sr						( reg_sr_e0					),
		.reg_rr						( reg_rr_e0					),
		.reg_sl						( reg_sl_e0					),
		.reg_wave_length			( reg_wave_length_e0		),
		.reg_frequency_count		( reg_frequency_count_e0	),
		.reg_noise_frequency_count	( reg_noise_frequency_e0	)
	);

	wts_channel_part u_ch_f0 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[5]				),
		.key_on						( ch_f0_key_on				),
		.key_release				( ch_f0_key_release			),
		.key_off					( ch_f0_key_off				),
		.envelope					( w_envelope_f0				),
		.sram_a						( w_sram_a_f0				),
		.reg_noise_enable			( reg_noise_enable_f0		),
		.reg_ar						( reg_ar_f0					),
		.reg_dr						( reg_dr_f0					),
		.reg_sr						( reg_sr_f0					),
		.reg_rr						( reg_rr_f0					),
		.reg_sl						( reg_sl_f0					),
		.reg_wave_length			( reg_wave_length_f0		),
		.reg_frequency_count		( reg_frequency_count_f0	),
		.reg_noise_frequency_count	( reg_noise_frequency_f0	)
	);

	wts_channel_part u_ch_a1 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[0]				),
		.key_on						( ch_a1_key_on				),
		.key_release				( ch_a1_key_release			),
		.key_off					( ch_a1_key_off				),
		.envelope					( w_envelope_a1				),
		.sram_a						( w_sram_a_a1				),
		.reg_noise_enable			( reg_noise_enable_a1		),
		.reg_ar						( reg_ar_a1					),
		.reg_dr						( reg_dr_a1					),
		.reg_sr						( reg_sr_a1					),
		.reg_rr						( reg_rr_a1					),
		.reg_sl						( reg_sl_a1					),
		.reg_wave_length			( reg_wave_length_a1		),
		.reg_frequency_count		( reg_frequency_count_a1	),
		.reg_noise_frequency_count	( reg_noise_frequency_a1	)
	);

	wts_channel_part u_ch_b1 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[1]				),
		.key_on						( ch_b1_key_on				),
		.key_release				( ch_b1_key_release			),
		.key_off					( ch_b1_key_off				),
		.envelope					( w_envelope_b1				),
		.sram_a						( w_sram_a_b1				),
		.reg_noise_enable			( reg_noise_enable_b1		),
		.reg_ar						( reg_ar_b1					),
		.reg_dr						( reg_dr_b1					),
		.reg_sr						( reg_sr_b1					),
		.reg_rr						( reg_rr_b1					),
		.reg_sl						( reg_sl_b1					),
		.reg_wave_length			( reg_wave_length_b1		),
		.reg_frequency_count		( reg_frequency_count_b1	),
		.reg_noise_frequency_count	( reg_noise_frequency_b1	)
	);

	wts_channel_part u_ch_c1 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[2]				),
		.key_on						( ch_c1_key_on				),
		.key_release				( ch_c1_key_release			),
		.key_off					( ch_c1_key_off				),
		.envelope					( w_envelope_c1				),
		.sram_a						( w_sram_a_c1				),
		.reg_noise_enable			( reg_noise_enable_c1		),
		.reg_ar						( reg_ar_c1					),
		.reg_dr						( reg_dr_c1					),
		.reg_sr						( reg_sr_c1					),
		.reg_rr						( reg_rr_c1					),
		.reg_sl						( reg_sl_c1					),
		.reg_wave_length			( reg_wave_length_c1		),
		.reg_frequency_count		( reg_frequency_count_c1	),
		.reg_noise_frequency_count	( reg_noise_frequency_c1	)
	);

	wts_channel_part u_ch_d1 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[3]				),
		.key_on						( ch_d1_key_on				),
		.key_release				( ch_d1_key_release			),
		.key_off					( ch_d1_key_off				),
		.envelope					( w_envelope_d1				),
		.sram_a						( w_sram_a_d1				),
		.reg_noise_enable			( reg_noise_enable_d1		),
		.reg_ar						( reg_ar_d1					),
		.reg_dr						( reg_dr_d1					),
		.reg_sr						( reg_sr_d1					),
		.reg_rr						( reg_rr_d1					),
		.reg_sl						( reg_sl_d1					),
		.reg_wave_length			( reg_wave_length_d1		),
		.reg_frequency_count		( reg_frequency_count_d1	),
		.reg_noise_frequency_count	( reg_noise_frequency_d1	)
	);

	wts_channel_part u_ch_e1 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[4]				),
		.key_on						( ch_e1_key_on				),
		.key_release				( ch_e1_key_release			),
		.key_off					( ch_e1_key_off				),
		.envelope					( w_envelope_e1				),
		.sram_a						( w_sram_a_e1				),
		.reg_noise_enable			( reg_noise_enable_e1		),
		.reg_ar						( reg_ar_e1					),
		.reg_dr						( reg_dr_e1					),
		.reg_sr						( reg_sr_e1					),
		.reg_rr						( reg_rr_e1					),
		.reg_sl						( reg_sl_e1					),
		.reg_wave_length			( reg_wave_length_e1		),
		.reg_frequency_count		( reg_frequency_count_e1	),
		.reg_noise_frequency_count	( reg_noise_frequency_e1	)
	);

	wts_channel_part u_ch_f1 (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( ff_active[5]				),
		.key_on						( ch_f1_key_on				),
		.key_release				( ch_f1_key_release			),
		.key_off					( ch_f1_key_off				),
		.envelope					( w_envelope_f1				),
		.sram_a						( w_sram_a_f1				),
		.reg_noise_enable			( reg_noise_enable_f1		),
		.reg_ar						( reg_ar_f1					),
		.reg_dr						( reg_dr_f1					),
		.reg_sr						( reg_sr_f1					),
		.reg_rr						( reg_rr_f1					),
		.reg_sl						( reg_sl_f1					),
		.reg_wave_length			( reg_wave_length_f1		),
		.reg_frequency_count		( reg_frequency_count_f1	),
		.reg_noise_frequency_count	( reg_noise_frequency_f1	)
	);

	function [3:0] func_volume_sel(
		input	[5:0]	phase,
		input	[3:0]	reg_volume_a,
		input	[3:0]	reg_volume_b,
		input	[3:0]	reg_volume_c,
		input	[3:0]	reg_volume_d,
		input	[3:0]	reg_volume_e,
		input	[3:0]	reg_volume_f
	);
		case( phase )
			6'b000001:	func_volume_sel = reg_volume_a;
			6'b000010:	func_volume_sel = reg_volume_b;
			6'b000100:	func_volume_sel = reg_volume_c;
			6'b001000:	func_volume_sel = reg_volume_d;
			6'b010000:	func_volume_sel = reg_volume_e;
			6'b100000:	func_volume_sel = reg_volume_f;
			default:	func_volume_sel = 4'dx;
		endcase
	endfunction

	function [1:0] func_enable_sel(
		input	[5:0]	phase,
		input	[1:0]	reg_enable_a,
		input	[1:0]	reg_enable_b,
		input	[1:0]	reg_enable_c,
		input	[1:0]	reg_enable_d,
		input	[1:0]	reg_enable_e,
		input	[1:0]	reg_enable_f
	);
		case( phase )
			6'b000001:	func_enable_sel = reg_enable_a;
			6'b000010:	func_enable_sel = reg_enable_b;
			6'b000100:	func_enable_sel = reg_enable_c;
			6'b001000:	func_enable_sel = reg_enable_d;
			6'b010000:	func_enable_sel = reg_enable_e;
			6'b100000:	func_enable_sel = reg_enable_f;
			default:	func_enable_sel = 2'dx;
		endcase
	endfunction

	function [1:0] func_envelope_sel(
		input	[5:0]	phase,
		input	[8:0]	envelope_a,
		input	[8:0]	envelope_b,
		input	[8:0]	envelope_c,
		input	[8:0]	envelope_d,
		input	[8:0]	envelope_e,
		input	[8:0]	envelope_f
	);
		case( phase )
			6'b000001:	func_envelope_sel = envelope_a;
			6'b000010:	func_envelope_sel = envelope_b;
			6'b000100:	func_envelope_sel = envelope_c;
			6'b001000:	func_envelope_sel = envelope_d;
			6'b010000:	func_envelope_sel = envelope_e;
			6'b100000:	func_envelope_sel = envelope_f;
			default:	func_envelope_sel = 9'dx;
		endcase
	endfunction

	assign w_volume0	= func_volume_sel( ff_active, reg_volume_a0, reg_volume_b0, reg_volume_c0, reg_volume_d0, reg_volume_e0, reg_volume_f0 );
	assign w_volume1	= func_volume_sel( ff_active, reg_volume_a1, reg_volume_b1, reg_volume_c1, reg_volume_d1, reg_volume_e1, reg_volume_f1 );
	assign w_enable0	= func_enable_sel( ff_active, reg_enable_a0, reg_enable_b0, reg_enable_c0, reg_enable_d0, reg_enable_e0, reg_enable_f0 );
	assign w_enable1	= func_enable_sel( ff_active, reg_enable_a1, reg_enable_b1, reg_enable_c1, reg_enable_d1, reg_enable_e1, reg_enable_f1 );
	assign w_envelope0	= func_envelope_sel( ff_active, w_envelope_a0, w_envelope_b0, w_envelope_c0, w_envelope_d0, w_envelope_e0, w_envelope_f0 );
	assign w_envelope1	= func_envelope_sel( ff_active, w_envelope_a1, w_envelope_b1, w_envelope_c1, w_envelope_d1, w_envelope_e1, w_envelope_f1 );

	assign w_sram_a0	= ff_active[1] ? w_sram_a_a0 :
						  ff_active[3] ? w_sram_a_c0 :
						  ff_active[5] ? w_sram_a_e0 : { ff_sram_id[2:1], ff_sram_a };
	assign w_sram_a1	= ff_active[0] ? w_sram_a_b0 :
						  ff_active[2] ? w_sram_a_d0 :
						  ff_active[4] ? w_sram_a_f0 : { ff_sram_id[2:1], ff_sram_a };

	assign w_sram_we00	= ~ff_sram_id[3] & (ff_active[1] | ff_active[3] | ff_active[5]) & ff_sram_we;
	assign w_sram_we01	= ~ff_sram_id[3] & (ff_active[0] | ff_active[2] | ff_active[4]) & ff_sram_we;
	assign w_sram_we10	=  ff_sram_id[3] & (ff_active[1] | ff_active[3] | ff_active[5]) & ff_sram_we;
	assign w_sram_we11	=  ff_sram_id[3] & (ff_active[0] | ff_active[3] | ff_active[4]) & ff_sram_we;

	wts_ram u_ram00 (
		.clk			( clk				),
		.sram_we		( w_sram_we00		),
		.sram_a			( w_sram_a0			),
		.sram_d			( ff_sram_d			),
		.sram_q			( w_sram_q00		)
	);

	wts_ram u_ram01 (
		.clk			( clk				),
		.sram_we		( w_sram_we01		),
		.sram_a			( w_sram_a1			),
		.sram_d			( ff_sram_d			),
		.sram_q			( w_sram_q01		)
	);

	wts_ram u_ram10 (
		.clk			( clk				),
		.sram_we		( w_sram_we10		),
		.sram_a			( w_sram_a0			),
		.sram_d			( ff_sram_d			),
		.sram_q			( w_sram_q10		)
	);

	wts_ram u_ram11 (
		.clk			( clk				),
		.sram_we		( w_sram_we11		),
		.sram_a			( w_sram_a1			),
		.sram_d			( ff_sram_d			),
		.sram_q			( w_sram_q11		)
	);

	assign w_sram_q0	= ( ff_active[5] || ff_active[3] || ff_active[1] ) ? w_sram_q00 : w_sram_q01;
	assign w_sram_q1	= ( ff_active[5] || ff_active[3] || ff_active[1] ) ? w_sram_q10 : w_sram_q11;

	wts_channel_volume u_channel_volume0 (
		.nreset			( nreset			),
		.clk			( clk				),
		.envelope		( w_envelope0		),
		.sram_q			( w_sram_q0			),
		.channel		( w_channel0		),
		.reg_volume		( w_volume0			)
	);

	wts_channel_volume u_channel_volume1 (
		.nreset			( nreset			),
		.clk			( clk				),
		.envelope		( w_envelope1		),
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
		else if( ff_active[5] ) begin
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
		else if( ff_active[5] ) begin
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
