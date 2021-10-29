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

module wts_tone_generator (
	input			address_reset,
	output	[6:0]	wave_address,
	output			half_timing,
	input	[1:0]	reg_wave_length,
	input	[11:0]	reg_frequency_count,
	input	[6:0]	wave_address_in,
	output	[6:0]	wave_address_out,
	input	[11:0]	frequency_count_in,
	output	[11:0]	frequency_count_out
);
	wire			w_frequency_counter_end;
	wire	[1:0]	w_address_mask;

	// frequency counter ------------------------------------------------------
	assign w_frequency_counter_end	= (frequency_count_in == 12'd0) ? 1'b1 : 1'b0;
	assign frequency_count_out		= (w_frequency_counter_end || address_reset) ? reg_frequency_count : (frequency_count_in - 12'd1);

	// wave memory address ----------------------------------------------------
	assign wave_address_out			= address_reset ? 7'd0 : 
									  w_frequency_counter_end ? (wave_address_in + 7'd1) : wave_address_in;

	assign w_address_mask			= ( reg_wave_length == 2'b00 ) ? 2'b00 : 
									  ( reg_wave_length == 2'b01 ) ? { 1'b0, wave_address_in[5] } : wave_address_in[6:5];

	// output assignment ------------------------------------------------------
	assign wave_address				= { w_address_mask, wave_address_in[4:0] };
	assign half_timing				= ( (reg_wave_length == 2'b00) && wave_address_in[3:0] == 4'b1111    ) ? w_frequency_counter_end : 
									  ( (reg_wave_length == 2'b01) && wave_address_in[4:0] == 5'b11111   ) ? w_frequency_counter_end : 
									  ( (reg_wave_length == 2'b10) && wave_address_in[5:0] == 6'b111111  ) ? w_frequency_counter_end : 1'b0;
endmodule
