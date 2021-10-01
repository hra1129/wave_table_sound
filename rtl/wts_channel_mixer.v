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
	output	[11:0]	left_out,
	output	[11:0]	right_out,
	input	[3:0]	reg_volume_a0,
	input	[3:0]	reg_volume_b0,
	input	[3:0]	reg_volume_c0,
	input	[3:0]	reg_volume_d0,
	input	[3:0]	reg_volume_e0,
	input	[3:0]	reg_volume_f0,
	input	[3:0]	reg_volume_a1,
	input	[3:0]	reg_volume_b1,
	input	[3:0]	reg_volume_c1,
	input	[3:0]	reg_volume_d1,
	input	[3:0]	reg_volume_e1,
	input	[3:0]	reg_volume_f1,
	input	[1:0]	reg_enable_a0,
	input	[1:0]	reg_enable_b0,
	input	[1:0]	reg_enable_c0,
	input	[1:0]	reg_enable_d0,
	input	[1:0]	reg_enable_e0,
	input	[1:0]	reg_enable_f0,
	input	[1:0]	reg_enable_a1,
	input	[1:0]	reg_enable_b1,
	input	[1:0]	reg_enable_c1,
	input	[1:0]	reg_enable_d1,
	input	[1:0]	reg_enable_e1,
	input	[1:0]	reg_enable_f1,
);
	reg		[5:0]	ff_active;
	wire	[3:0]	w_volume0;
	wire	[3:0]	w_volume1;
	wire	[1:0]	w_enable0;
	wire	[1:0]	w_enable1;
	wire	[8:0]	w_sram_a;
	wire	[7:0]	w_sram_q0;
	wire	[7:0]	w_sram_q00;
	wire	[7:0]	w_sram_q01;
	wire	[7:0]	w_sram_q1;
	wire	[7:0]	w_sram_q10;
	wire	[7:0]	w_sram_q11;
	reg		[11:0]	ff_left_integ;
	reg		[11:0]	ff_right_integ;
	reg		[11:0]	ff_left_out;
	reg		[11:0]	ff_right_out;

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_active <= 6'd0;
		end
		else begin
			ff_active <= { ff_active[4:0], ff_active[5] };
		end
	end

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

	assign w_volume0 = func_volume_sel( ff_active, reg_volume_a0, reg_volume_b0, reg_volume_c0, reg_volume_d0, reg_volume_e0, reg_volume_f0 );
	assign w_volume1 = func_volume_sel( ff_active, reg_volume_a1, reg_volume_b1, reg_volume_c1, reg_volume_d1, reg_volume_e1, reg_volume_f1 );
	assign w_enable0 = func_enable_sel( ff_active, reg_enable_a0, reg_enable_b0, reg_enable_c0, reg_enable_d0, reg_enable_e0, reg_enable_f0 );
	assign w_enable1 = func_enable_sel( ff_active, reg_enable_a1, reg_enable_b1, reg_enable_c1, reg_enable_d1, reg_enable_e1, reg_enable_f1 );

	wts_ram u_ram00 (
		.clk			( clk				),
		.sram_we		( w_sram_we00		),
		.sram_a			( w_sram_a			),
		.sram_d			( w_sram_d			),
		.sram_q			( w_sram_q00		)
	);

	wts_ram u_ram01 (
		.clk			( clk				),
		.sram_we		( w_sram_we01		),
		.sram_a			( w_sram_a			),
		.sram_d			( w_sram_d			),
		.sram_q			( w_sram_q01		)
	);

	wts_ram u_ram10 (
		.clk			( clk				),
		.sram_we		( w_sram_we10		),
		.sram_a			( w_sram_a			),
		.sram_d			( w_sram_d			),
		.sram_q			( w_sram_q10		)
	);

	wts_ram u_ram11 (
		.clk			( clk				),
		.sram_we		( w_sram_we11		),
		.sram_a			( w_sram_a			),
		.sram_d			( w_sram_d			),
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

	assign w_left_channel		= { w_left_channel0[7] , w_left_channel0  } + { w_left_channel1[7] , w_left_channel1  };
	assign w_right_channel		= { w_right_channel0[7], w_right_channel0 } + { w_right_channel1[7], w_right_channel1 };

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_left_integ		<= 12'd0;
			ff_right_integ		<= 12'd0;
		end
		else if( ff_active[5] ) begin
			ff_left_integ		<= { 3 { w_left_channel[8]  }, w_left_channel  };
			ff_right_integ		<= { 3 { w_right_channel[8] }, w_right_channel };
		end
		else begin
			ff_left_integ		<= ff_left_integ  + { 3 { w_left_channel[8]  }, w_left_channel  };
			ff_right_integ		<= ff_right_integ + { 3 { w_right_channel[8] }, w_right_channel };
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
