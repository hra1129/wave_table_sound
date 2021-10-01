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
	input			nreset,					//	negative logic
	input			clk,
	input			active,					//	3.579MHz timing pulse
	input			address_reset,
	output	[6:0]	wave_address,
	input	[1:0]	reg_wave_length,
	input	[11:0]	reg_frequency_count
);
	reg		[6:0]	ff_wave_address;
	reg		[11:0]	ff_frequency_count;
	wire			w_frequency_counter_end;
	wire	[1:0]	w_address_mask;

	// frequency counter ------------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_frequency_count <= 12'd0;
		end
		else if( active ) begin
			if( w_frequency_counter_end || address_reset ) begin
				ff_frequency_count <= reg_frequency_count;
			end
			else begin
				ff_frequency_count <= ff_frequency_count - 12'd1;
			end
		end
		else begin
			//	hold
		end
	end

	assign w_frequency_counter_end	= (ff_frequency_count == 12'd0) ? 1'b1 : 1'b0;

	// wave memory address ----------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_wave_address <= 7'd0;
		end
		else if( active ) begin
			if( address_reset ) begin
				ff_wave_address <= 7'd0;
			end
			else if( w_frequency_counter_end ) begin
				ff_wave_address <= ff_wave_address + 7'd1;
			end
			else begin
				//	hold
			end
		end
		else begin
			//	hold
		end
	end

	assign w_address_mask			= reg_wave_length & ff_wave_address[6:5];

	// output assignment ------------------------------------------------------
	assign wave_address				= { w_address_mask, ff_wave_address[4:0] };

endmodule