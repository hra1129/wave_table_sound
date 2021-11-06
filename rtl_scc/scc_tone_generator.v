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

module scc_tone_generator (
	input			address_reset,
	output	[4:0]	wave_address,
	input	[11:0]	reg_frequency_count,
	input	[4:0]	wave_address_in,
	output	[4:0]	wave_address_out,
	input	[11:0]	frequency_count_in,
	output	[11:0]	frequency_count_out
);
	wire			w_frequency_counter_end;

	// frequency counter ------------------------------------------------------
	assign w_frequency_counter_end	= (frequency_count_in == 12'd0) ? 1'b1 : 1'b0;
	assign frequency_count_out		= (w_frequency_counter_end || address_reset) ? reg_frequency_count : (frequency_count_in - 12'd1);

	// wave memory address ----------------------------------------------------
	assign wave_address_out			= address_reset ? 5'd0 : 
									  w_frequency_counter_end ? (wave_address_in + 5'd1) : wave_address_in;

	// output assignment ------------------------------------------------------
	assign wave_address				= wave_address_in;
endmodule
