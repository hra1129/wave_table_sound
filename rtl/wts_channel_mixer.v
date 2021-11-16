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

module wts_channel_mixer #(
	parameter		add_offset = 1			//	0: +0 (for OCM), 1: +128 (for cartridge)
) (
	input			nreset,
	input			clk,

	input			ch0_key_on,
	input			ch0_key_release,
	input			ch0_key_off,

	input			ch1_key_on,
	input			ch1_key_release,
	input			ch1_key_off,

	input			sram_ce0,				//	A0...E0
	input			sram_ce1,				//	A1...E1
	input	[2:0]	sram_id,				//	A...E
	input	[6:0]	sram_a,
	input	[7:0]	sram_d,
	input			sram_oe,
	input			sram_we,
	output	[7:0]	sram_q,
	output			sram_q_en,

	output	[2:0]	active,
	input			adsr_en,
	input			reg_scci_enable,

	output	[11:0]	left_out,
	output	[11:0]	right_out,

	input	[7:0]	reg_ar0,
	input	[7:0]	reg_dr0,
	input	[7:0]	reg_sr0,
	input	[7:0]	reg_rr0,
	input	[5:0]	reg_sl0,
	input	[1:0]	reg_wave_length0,
	input	[11:0]	reg_frequency_count0,
	input	[3:0]	reg_volume0,
	input	[1:0]	reg_enable0,

	input	[7:0]	reg_ar1,
	input	[7:0]	reg_dr1,
	input	[7:0]	reg_sr1,
	input	[7:0]	reg_rr1,
	input	[5:0]	reg_sl1,
	input	[1:0]	reg_wave_length1,
	input	[11:0]	reg_frequency_count1,
	input	[3:0]	reg_volume1,
	input	[1:0]	reg_enable1,

	input			reg_noise_enable_a0,
	input	[1:0]	reg_noise_sel_a0,
	input			reg_noise_enable_b0,
	input	[1:0]	reg_noise_sel_b0,
	input			reg_noise_enable_c0,
	input	[1:0]	reg_noise_sel_c0,
	input			reg_noise_enable_d0,
	input	[1:0]	reg_noise_sel_d0,
	input			reg_noise_enable_e0,
	input	[1:0]	reg_noise_sel_e0,
	input			reg_noise_enable_a1,
	input	[1:0]	reg_noise_sel_a1,
	input			reg_noise_enable_b1,
	input	[1:0]	reg_noise_sel_b1,
	input			reg_noise_enable_c1,
	input	[1:0]	reg_noise_sel_c1,
	input			reg_noise_enable_d1,
	input	[1:0]	reg_noise_sel_d1,
	input			reg_noise_enable_e1,
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
	output	[1:0]	timer2_address,

	input			reg_wave_reset,
	input			clear_counter_a0,
	input			clear_counter_b0,
	input			clear_counter_c0,
	input			clear_counter_d0,
	input			clear_counter_e0,
	input			clear_counter_a1,
	input			clear_counter_b1,
	input			clear_counter_c1,
	input			clear_counter_d1,
	input			clear_counter_e1
);

	reg		[2:0]	ff_active;
	wire	[9:0]	w_sram_a0;
	wire	[9:0]	w_sram_a1;
	wire	[7:0]	w_sram_q0;
	wire	[7:0]	w_sram_q1;
	wire	[7:0]	w_channel0;
	wire	[6:0]	w_envelope0;
	wire	[6:0]	w_envelope1;
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

	reg				ff_active_delay;
	reg				ff_sram_ce1;
	reg				ff_sram_q_en;

	wire	[6:0]	w_wave_address0;
	wire	[6:0]	w_wave_address1;
	wire			w_sram_we0;
	wire			w_sram_we1;
	wire			w_noise0;
	wire			w_noise1;
	wire			w_half_timing0;
	wire			w_half_timing1;
	wire			w_address_reset0;
	wire			w_address_reset1;

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
			ff_sram_q_en <= 1'b0;
			ff_sram_ce1 <= 1'b0;
		end
		else if( sram_oe || sram_we ) begin
			ff_sram_q_en <= sram_oe;
			ff_sram_ce1 <= sram_ce1;
		end
		else begin
			ff_sram_q_en <= 1'b0;
			ff_sram_ce1 <= 1'b0;
		end
	end

	assign sram_q_en	= ff_sram_q_en;
	assign sram_q		= ( ff_sram_ce1 ) ? w_sram_q1 : w_sram_q0;

	// ------------------------------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_active		<= 3'd0;
			ff_active_delay	<= 1'b0;
		end
		else begin
			if( ff_active == 3'd5 ) begin
				ff_active		<= 3'd0;
				ff_active_delay	<= 1'b0;
			end
			else if( (sram_oe | sram_we) == 1'b1 ) begin
				ff_active_delay	<= 1'b1;
			end
			else if( ff_active_delay && ff_active == 3'd4 ) begin
					ff_active		<= 3'd0;
					ff_active_delay	<= 1'b0;
			end
			else begin
				ff_active		<= ff_active + 3'd1;
			end
		end
	end

	assign active			= ff_active;
	assign w_address_reset0	= ch0_key_on;
	assign w_address_reset1	= ch1_key_on;

	wts_adsr_envelope_generator_5ch u_adsr_envelope_generator_5ch_0 (
		.nreset						( nreset						),
		.clk						( clk							),
		.active						( ff_active						),
		.envelope					( w_envelope0					),
		.ch_key_on					( ch0_key_on					),
		.ch_key_release				( ch0_key_release				),
		.ch_key_off					( ch0_key_off					),
		.adsr_en					( adsr_en						),
		.reg_ar						( reg_ar0						),
		.reg_dr						( reg_dr0						),
		.reg_sr						( reg_sr0						),
		.reg_rr						( reg_rr0						),
		.reg_sl						( reg_sl0						)
	);

	wts_adsr_envelope_generator_5ch u_adsr_envelope_generator_5ch_1 (
		.nreset						( nreset						),
		.clk						( clk							),
		.active						( ff_active						),
		.envelope					( w_envelope1					),
		.ch_key_on					( ch1_key_on					),
		.ch_key_release				( ch1_key_release				),
		.ch_key_off					( ch1_key_off					),
		.adsr_en					( adsr_en						),
		.reg_ar						( reg_ar1						),
		.reg_dr						( reg_dr1						),
		.reg_sr						( reg_sr1						),
		.reg_rr						( reg_rr1						),
		.reg_sl						( reg_sl1						)
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
		.address_reset				( w_address_reset0				),
		.wave_address				( w_wave_address0				),
		.half_timing				( w_half_timing0				),
		.reg_wave_length			( reg_wave_length0				),
		.reg_frequency_count		( reg_frequency_count0			),
		.reg_wave_reset				( reg_wave_reset				),
		.clear_counter_a			( clear_counter_a0				),
		.clear_counter_b			( clear_counter_b0				),
		.clear_counter_c			( clear_counter_c0				),
		.clear_counter_d			( clear_counter_d0				),
		.clear_counter_e			( clear_counter_e0				)
	);

	wts_tone_generator_5ch u_tone_generator_5ch_1 (
		.nreset						( nreset						),
		.clk						( clk							),
		.active						( ff_active						),
		.address_reset				( w_address_reset1				),
		.wave_address				( w_wave_address1				),
		.half_timing				( w_half_timing1				),
		.reg_wave_length			( reg_wave_length1				),
		.reg_frequency_count		( reg_frequency_count1			),
		.reg_wave_reset				( reg_wave_reset				),
		.clear_counter_a			( clear_counter_a1				),
		.clear_counter_b			( clear_counter_b1				),
		.clear_counter_c			( clear_counter_c1				),
		.clear_counter_d			( clear_counter_d1				),
		.clear_counter_e			( clear_counter_e1				)
	);

	assign w_sram_a0	= ( sram_oe || sram_we ) ? { sram_id, sram_a } :
		(( ff_active[2] && (reg_scci_enable == 1'b0)) ? { 3'b011, w_wave_address0 } : { ff_active, w_wave_address0 });
	assign w_sram_a1	= ( sram_oe || sram_we ) ? { sram_id, sram_a } :
		(( ff_active[2] && (reg_scci_enable == 1'b0)) ? { 3'b011, w_wave_address1 } : { ff_active, w_wave_address1 });

	assign w_sram_we0	= ( sram_oe || sram_we ) ? (sram_ce0 & sram_we) : 1'b0;
	assign w_sram_we1	= ( sram_oe || sram_we ) ? (sram_ce1 & sram_we) : 1'b0;

	wts_ram u_ram00 (
		.clk			( clk				),
		.sram_we		( w_sram_we0		),		//	delay 0 clock
		.sram_a			( w_sram_a0			),		//	delay 0 clock
		.sram_d			( sram_d			),		//	delay 0 clock
		.sram_q			( w_sram_q0			)		//	delay 1 clock
	);

	wts_ram u_ram10 (
		.clk			( clk				),
		.sram_we		( w_sram_we1		),		//	delay 0 clock
		.sram_a			( w_sram_a1			),		//	delay 0 clock
		.sram_d			( sram_d			),		//	delay 0 clock
		.sram_q			( w_sram_q1			)		//	delay 1 clock
	);

	wts_channel_volume u_channel_volume0 (
		.nreset			( nreset			),
		.clk			( clk				),
		.envelope		( w_envelope0		),		//	delay 1 clock
		.noise			( w_noise0			),		//	delay 1 clock
		.sram_q			( w_sram_q0			),		//	delay 1 clock
		.channel		( w_channel0		),		//	delay 4 clock
		.reg_volume		( reg_volume0		)		//	delay 3 clock
	);

	wts_channel_volume u_channel_volume1 (
		.nreset			( nreset			),
		.clk			( clk				),
		.envelope		( w_envelope1		),		//	delay 1 clock
		.noise			( w_noise1			),		//	delay 1 clock
		.sram_q			( w_sram_q1			),		//	delay 1 clock
		.channel		( w_channel1		),		//	delay 4 clock
		.reg_volume		( reg_volume1		)		//	delay 3 clock
	);

	//	delay 4 clock
	assign w_left_channel0		= reg_enable0[1] ? w_channel0 : 8'd0;
	assign w_right_channel0		= reg_enable0[0] ? w_channel0 : 8'd0;

	assign w_left_channel1		= reg_enable1[1] ? w_channel1 : 8'd0;
	assign w_right_channel1		= reg_enable1[0] ? w_channel1 : 8'd0;

	assign w_left_channel		= { w_left_channel0[7] , w_left_channel0  } + { w_left_channel1[7] , w_left_channel1  };
	assign w_right_channel		= { w_right_channel0[7], w_right_channel0 } + { w_right_channel1[7], w_right_channel1 };

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_left_integ		<= 12'd0;
			ff_right_integ		<= 12'd0;
		end
		else if( (sram_oe | sram_we) == 1'b1 ) begin
			//	hold
		end
		else if( ff_active == 3'd3 ) begin
			ff_left_integ		<= 12'd0;
			ff_right_integ		<= 12'd0;
		end
		else begin
			if( add_offset ) begin
				ff_left_integ		<= ff_left_integ  + { 2'd0, ~w_left_channel[8] , w_left_channel  };
				ff_right_integ		<= ff_right_integ + { 2'd0, ~w_right_channel[8], w_right_channel };
			end
			else begin
				ff_left_integ		<= ff_left_integ  + { { 3 { w_left_channel[8]  } }, w_left_channel  };
				ff_right_integ		<= ff_right_integ + { { 3 { w_right_channel[8] } }, w_right_channel };
			end
		end
	end

	//	delay 5 clock
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_left_out			<= 12'd0;
			ff_right_out		<= 12'd0;
		end
		else if( ff_active == 3'd3 ) begin
			ff_left_out			<= ff_left_integ;
			ff_right_out		<= ff_right_integ;
		end
		else begin
			//	hold
		end
	end

	assign left_out		= ff_left_out;
	assign right_out	= ff_right_out;
endmodule
