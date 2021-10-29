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

module wts_noise_generator (
	input			nreset,					//	negative logic
	input			clk,
	input			active,					//	3.579MHz timing pulse
	output			noise,
	input	[4:0]	reg_frequency_count
);
	reg		[4:0]	ff_counter;
	reg		[17:0]	ff_noise;
	wire	[4:0]	w_count_base;
	wire	[4:0]	w_count_next;
	wire			w_count_end;
	wire			w_noise_0;

	// frequency counter ------------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_counter <= 5'd0;
		end
		else if( active ) begin
			ff_counter <= w_count_next;
		end
		else begin
			//	hold
		end
	end

	assign w_count_base	= w_count_end ? reg_frequency_count : ff_counter;
	assign w_count_next	= w_count_base - 5'd1;
	assign w_count_end	= ( ff_counter == 5'd0 ) ? 1'b1 : 1'b0;

	// random signal generator ------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_noise <= { 18 { 1'b1 } };
		end
		else if( active && w_count_end ) begin
			ff_noise <= { ff_noise[16:0], w_noise_0 };
		end
		else begin
			//	hold
		end
	end

	assign w_noise_0	= (ff_noise == 18'd0) ? 1'b1 : (ff_noise[14] ^ ff_noise[17]);

	// output assignment ------------------------------------------------------
	assign noise		= ff_noise[17];
endmodule
