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

module scc_channel_mixer #(
	parameter		add_offset = 1			//	0: +0 (for OCM), 1: +128 (for cartridge)
) (
	input			nreset,
	input			clk,

	input	[2:0]	sram_id,				//	A...E
	input	[4:0]	sram_a,
	input	[7:0]	sram_d,
	input			sram_oe,
	input			sram_we,
	output	[7:0]	sram_q,
	output			sram_q_en,

	output	[2:0]	active,

	output	[10:0]	left_out,

	input			reg_scci_enable,
	input	[11:0]	reg_frequency_count0,
	input	[3:0]	reg_volume0,
	input			reg_enable0
);

	reg		[2:0]	ff_active;
	wire	[7:0]	w_sram_a0;
	wire	[7:0]	w_sram_q0;
	wire	[7:0]	w_channel0;
	wire	[7:0]	w_left_channel0;
	reg		[10:0]	ff_left_integ;
	reg		[10:0]	ff_left_out;

	reg				ff_active_delay;
	reg				ff_sram_q_en;

	wire	[4:0]	w_wave_address0;
	wire			w_sram_we0;
	wire			w_address_reset0;

	// ------------------------------------------------------------------------
	//	CPU SRAM ACCESS INTERFACE
	// ------------------------------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_sram_q_en <= 1'b0;
		end
		else if( sram_oe || sram_we ) begin
			ff_sram_q_en <= sram_oe;
		end
		else begin
			ff_sram_q_en <= 1'b0;
		end
	end

	assign sram_q_en	= ff_sram_q_en;
	assign sram_q		= w_sram_q0;

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

	scc_tone_generator_5ch u_tone_generator_5ch_0 (
		.nreset						( nreset						),
		.clk						( clk							),
		.active						( ff_active						),
		.address_reset				( 1'b0							),
		.wave_address				( w_wave_address0				),
		.reg_frequency_count		( reg_frequency_count0			)
	);

	assign w_sram_a0	= ( sram_oe || sram_we ) ? { sram_id, sram_a } : 
						  (( ff_active[2] && (reg_scci_enable == 1'b0)) ? { 3'b011, w_wave_address0 } : { ff_active, w_wave_address0 });
	assign w_sram_we0	= ( sram_oe || sram_we ) ? sram_we : 1'b0;

	scc_ram u_ram00 (
		.clk			( clk				),
		.sram_we		( w_sram_we0		),		//	delay 0 clock
		.sram_a			( w_sram_a0			),		//	delay 0 clock
		.sram_d			( sram_d			),		//	delay 0 clock
		.sram_q			( w_sram_q0			)		//	delay 1 clock
	);

	scc_channel_volume u_channel_volume0 (
		.clk			( clk				),
		.sram_q			( w_sram_q0			),		//	delay 1 clock
		.channel		( w_channel0		),		//	delay 2 clock
		.reg_volume		( reg_volume0		)		//	delay 1 clock
	);

	//	delay 4 clock
	assign w_left_channel0		= reg_enable0 ? w_channel0 : 8'd0;

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_left_integ		<= 11'd0;
		end
		else if( ff_active == 3'd3 ) begin
			ff_left_integ		<= 11'd0;
		end
		else begin
			if( add_offset ) begin
				ff_left_integ		<= ff_left_integ  + { 3'd0, ~w_left_channel0[7], w_left_channel0[6:0]  };
			end
			else begin
				ff_left_integ		<= ff_left_integ  + { { 3 { w_left_channel0[7]  } }, w_left_channel0  };
			end
		end
	end

	//	delay 5 clock
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_left_out			<= 11'b100_0000_0000;
		end
		else if( ff_active == 3'd3 ) begin
			ff_left_out			<= ff_left_integ;
		end
		else begin
			//	hold
		end
	end

	assign left_out		= ff_left_out;
endmodule
