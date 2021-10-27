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

module wts_channel_part (
	input			nreset,					//	negative logic
	input			clk,
	input			active,					//	3.579MHz timing pulse
	input			address_reset,
	input			key_on,					//	pulse
	input			key_release,			//	pulse
	input			key_off,				//	pulse
	output	[7:0]	envelope,
	output	[6:0]	sram_a,
	output			half_timing,
	input			reg_noise_enable,
	input	[11:0]	reg_ar,
	input	[11:0]	reg_dr,
	input	[11:0]	reg_sr,
	input	[11:0]	reg_rr,
	input	[6:0]	reg_sl,
	input	[1:0]	reg_wave_length,
	input	[11:0]	reg_frequency_count,
	input	[4:0]	reg_noise_frequency_count
);
	wire			w_noise;
	wire	[7:0]	w_envelope;

	wts_noise_generator u_noise_generator (
		.nreset					( nreset					),
		.clk					( clk						),
		.active					( active					),
		.enable					( reg_noise_enable			),
		.noise					( w_noise					),
		.reg_frequency_count	( reg_noise_frequency_count	)
	);

	wts_adsr_envelope_generator u_adsr_envelope_generator (
		.nreset					( nreset					),
		.clk					( clk						),
		.active					( active					),
		.key_on					( key_on					),
		.key_release			( key_release				),
		.key_off				( key_off					),
		.envelope				( w_envelope				),
		.reg_ar					( reg_ar					),
		.reg_dr					( reg_dr					),
		.reg_sr					( reg_sr					),
		.reg_rr					( reg_rr					),
		.reg_sl					( reg_sl					)
	);

	wts_tone_generator u_tone_generator (
		.nreset					( nreset					),
		.clk					( clk						),
		.active					( active					),
		.address_reset			( address_reset				),
		.wave_address			( sram_a					),
		.half_timing			( half_timing				),
		.reg_wave_length		( reg_wave_length			),
		.reg_frequency_count	( reg_frequency_count		)
	);

	assign envelope		= w_noise ? w_envelope : 8'd0;
endmodule
