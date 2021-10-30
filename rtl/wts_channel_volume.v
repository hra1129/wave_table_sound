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

module wts_channel_volume (
	input			nreset,					//	negative logic
	input			clk,
	input	[6:0]	envelope,
	input			noise,
	input	[7:0]	sram_q,					//	signed
	output	[7:0]	channel,				//	signed
	input	[3:0]	reg_volume
);
	reg		[7:0]	ff_wave;				//	signed
	reg		[6:0]	ff_envelope;
	wire	[14:0]	w_wave_mul;				//	signed
	wire	[7:0]	w_wave_round;			//	signed
	reg		[7:0]	ff_channel_wave;		//	signed
	wire	[12:0]	w_channel_mul;
	wire	[7:0]	w_channel_round;
	reg		[7:0]	ff_channel;				//	signed

	assign w_wave_mul		= $signed( ff_wave ) * $signed( { 1'b0, ff_envelope[5:0] } );
	assign w_wave_round		= (w_wave_mul[13] && (w_wave_mul[5:0] != 6'd0)) ? ( w_wave_mul[13:6] + 8'd1 ) : w_wave_mul[13:6];
	assign w_channel_mul	= $signed( ff_channel_wave ) * $signed( { 1'b0, reg_volume } );
	assign w_channel_round	= (w_channel_mul[11] && (w_channel_mul[3:0] != 4'd0)) ? ( w_channel_mul[11:4] + 8'd1 ) : w_channel_mul[11:4];

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_wave			<= 8'd0;
			ff_envelope		<= 7'd0;
			ff_channel_wave	<= 8'd0;
			ff_channel		<= 8'd0;
		end
		else begin
			ff_wave			<= sram_q;
			ff_envelope		<= noise ? envelope : 7'd0;
			ff_channel_wave	<= ff_envelope[6] ? ff_wave : w_wave_round;
			ff_channel		<= w_channel_round;
		end
	end

	assign channel			= ff_channel;
endmodule
