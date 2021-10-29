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

module wts_tone_generator_5ch (
	input			nreset,					//	negative logic
	input			clk,
	input	[2:0]	active,
	input			address_reset,
	output	[6:0]	wave_address,
	output			half_timing,
	input	[1:0]	reg_wave_length_a,
	input	[1:0]	reg_wave_length_b,
	input	[1:0]	reg_wave_length_c,
	input	[1:0]	reg_wave_length_d,
	input	[1:0]	reg_wave_length_e,
	input	[11:0]	reg_frequency_count_a,
	input	[11:0]	reg_frequency_count_b,
	input	[11:0]	reg_frequency_count_c,
	input	[11:0]	reg_frequency_count_d,
	input	[11:0]	reg_frequency_count_e
);
	wire	[1:0]	w_wave_length;
	wire	[11:0]	w_frequency_count;
	wire	[6:0]	w_wave_address_in;
	wire	[6:0]	w_wave_address_out;
	reg		[6:0]	ff_wave_address_a;
	reg		[6:0]	ff_wave_address_b;
	reg		[6:0]	ff_wave_address_c;
	reg		[6:0]	ff_wave_address_d;
	reg		[6:0]	ff_wave_address_e;
	wire	[11:0]	w_frequency_count_in;
	wire	[11:0]	w_frequency_count_out;
	reg		[11:0]	ff_frequency_count_a;
	reg		[11:0]	ff_frequency_count_b;
	reg		[11:0]	ff_frequency_count_c;
	reg		[11:0]	ff_frequency_count_d;
	reg		[11:0]	ff_frequency_count_e;

	wts_selector #( 2 ) u_wave_length_selector (
		.active					( active					),
		.result					( w_wave_length				),
		.reg_a					( reg_wave_length_a			),
		.reg_b					( reg_wave_length_b			),
		.reg_c					( reg_wave_length_c			),
		.reg_d					( reg_wave_length_d			),
		.reg_e					( reg_wave_length_e			)
	);

	wts_selector #( 7 ) u_wave_address_selector (
		.active					( active					),
		.result					( w_wave_address_in			),
		.reg_a					( ff_wave_address_a			),
		.reg_b					( ff_wave_address_b			),
		.reg_c					( ff_wave_address_c			),
		.reg_d					( ff_wave_address_d			),
		.reg_e					( ff_wave_address_e			)
	);

	wts_selector #( 12 ) u_wave_frequency_count_selector (
		.active					( active					),
		.result					( w_frequency_count			),
		.reg_a					( reg_frequency_count_a		),
		.reg_b					( reg_frequency_count_b		),
		.reg_c					( reg_frequency_count_c		),
		.reg_d					( reg_frequency_count_d		),
		.reg_e					( reg_frequency_count_e		)
	);

	wts_selector #( 12 ) u_wave_frequency_counter_selector (
		.active					( active					),
		.result					( w_frequency_count_in		),
		.reg_a					( ff_frequency_count_a		),
		.reg_b					( ff_frequency_count_b		),
		.reg_c					( ff_frequency_count_c		),
		.reg_d					( ff_frequency_count_d		),
		.reg_e					( ff_frequency_count_e		)
	);

	wts_tone_generator u_tone_generator (
		.address_reset			( address_reset				),
		.half_timing			( half_timing				),
		.wave_address			( wave_address				),
		.reg_wave_length		( w_wave_length				),
		.reg_frequency_count	( w_frequency_count			),
		.wave_address_in		( w_wave_address_in			),
		.wave_address_out		( w_wave_address_out		),
		.frequency_count_in		( w_frequency_count_in		),
		.frequency_count_out	( w_frequency_count_out		)
	);

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_wave_address_a		<= 'd0;
			ff_wave_address_b		<= 'd0;
			ff_wave_address_c		<= 'd0;
			ff_wave_address_d		<= 'd0;
			ff_wave_address_e		<= 'd0;
			ff_frequency_count_a	<= 'd0;
			ff_frequency_count_b	<= 'd0;
			ff_frequency_count_c	<= 'd0;
			ff_frequency_count_d	<= 'd0;
			ff_frequency_count_e	<= 'd0;
		end
		else begin
			case( active )
			3'd0:
				begin
					ff_wave_address_a		<= w_wave_address_out;
					ff_frequency_count_a	<= w_frequency_count_out;
				end
			3'd1:
				begin
					ff_wave_address_b		<= w_wave_address_out;
					ff_frequency_count_b	<= w_frequency_count_out;
				end
			3'd2:
				begin
					ff_wave_address_c		<= w_wave_address_out;
					ff_frequency_count_c	<= w_frequency_count_out;
				end
			3'd3:
				begin
					ff_wave_address_d		<= w_wave_address_out;
					ff_frequency_count_d	<= w_frequency_count_out;
				end
			3'd4:
				begin
					ff_wave_address_e		<= w_wave_address_out;
					ff_frequency_count_e	<= w_frequency_count_out;
				end
			default:
				begin
					//	hold
				end
			endcase
		end
	end
endmodule
