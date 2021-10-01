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
	
	
	
	
	
	
	
	
	
	
	
	
	
endmodule
