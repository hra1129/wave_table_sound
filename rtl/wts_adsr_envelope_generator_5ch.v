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

module wts_adsr_envelope_generator_5ch (
	input			nreset,					//	negative logic
	input			clk,
	input	[2:0]	active,					//	0...4 : channel index, 5 : no operation
	output	[6:0]	envelope,

	input			ch_key_on,
	input			ch_key_release,
	input			ch_key_off,
	input			adsr_en,

	input	[7:0]	reg_ar,
	input	[7:0]	reg_dr,
	input	[7:0]	reg_sr,
	input	[7:0]	reg_rr,
	input	[5:0]	reg_sl
);
	reg		[2:0]	ff_state_a;				//	0:idle, 1:attack, 2:decay, 3:sustain, 4:release
	reg		[19:0]	ff_counter_a;
	reg		[6:0]	ff_level_a;

	reg		[2:0]	ff_state_b;				//	0:idle, 1:attack, 2:decay, 3:sustain, 4:release
	reg		[19:0]	ff_counter_b;
	reg		[6:0]	ff_level_b;

	reg		[2:0]	ff_state_c;				//	0:idle, 1:attack, 2:decay, 3:sustain, 4:release
	reg		[19:0]	ff_counter_c;
	reg		[6:0]	ff_level_c;

	reg		[2:0]	ff_state_d;				//	0:idle, 1:attack, 2:decay, 3:sustain, 4:release
	reg		[19:0]	ff_counter_d;
	reg		[6:0]	ff_level_d;

	reg		[2:0]	ff_state_e;				//	0:idle, 1:attack, 2:decay, 3:sustain, 4:release
	reg		[19:0]	ff_counter_e;
	reg		[6:0]	ff_level_e;

	wire	[2:0]	w_state_in;
	wire	[19:0]	w_counter_in;
	wire	[6:0]	w_level_in;

	wire	[2:0]	w_state_out;
	wire	[19:0]	w_counter_out;
	wire	[6:0]	w_level_out;

	wts_selector #( 3 ) u_state_selector (
		.active		( active			),
		.result		( w_state_in		),
		.reg_a		( 3'd0				),
		.reg_b		( ff_state_a		),
		.reg_c		( ff_state_b		),
		.reg_d		( ff_state_c		),
		.reg_e		( ff_state_d		),
		.reg_f		( ff_state_e		)
	);

	wts_selector #( 20 ) u_counter_selector (
		.active		( active			),
		.result		( w_counter_in		),
		.reg_a		( 20'd0				),
		.reg_b		( ff_counter_a		),
		.reg_c		( ff_counter_b		),
		.reg_d		( ff_counter_c		),
		.reg_e		( ff_counter_d		),
		.reg_f		( ff_counter_e		)
	);

	wts_selector #( 7 ) u_level_selector (
		.active		( active			),
		.result		( w_level_in		),
		.reg_a		( 7'd0				),
		.reg_b		( ff_level_a		),
		.reg_c		( ff_level_b		),
		.reg_d		( ff_level_c		),
		.reg_e		( ff_level_d		),
		.reg_f		( ff_level_e		)
	);

	wts_adsr_envelope_generator u_adsr_envelope_generator (
		.key_on					( ch_key_on					),
		.key_release			( ch_key_release			),
		.key_off				( ch_key_off				),
		.reg_enable				( adsr_en					),
		.reg_ar					( reg_ar					),
		.reg_dr					( reg_dr					),
		.reg_sr					( reg_sr					),
		.reg_rr					( reg_rr					),
		.reg_sl					( reg_sl					),
		.counter_in				( w_counter_in				),
		.counter_out			( w_counter_out				),
		.state_in				( w_state_in				),
		.state_out				( w_state_out				),
		.level_in				( w_level_in				),
		.level_out				( w_level_out				)
	);

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_state_a		<= 3'd0;
			ff_counter_a	<= 20'd0;
			ff_level_a		<= 8'd0;

			ff_state_b		<= 3'd0;
			ff_counter_b	<= 20'd0;
			ff_level_b		<= 8'd0;

			ff_state_c		<= 3'd0;
			ff_counter_c	<= 20'd0;
			ff_level_c		<= 8'd0;

			ff_state_d		<= 3'd0;
			ff_counter_d	<= 20'd0;
			ff_level_d		<= 8'd0;

			ff_state_e		<= 3'd0;
			ff_counter_e	<= 20'd0;
			ff_level_e		<= 8'd0;
		end
		else begin
			case( active )
			3'd1:
				begin
					ff_state_a		<= w_state_out;
					ff_counter_a	<= w_counter_out;
					ff_level_a		<= w_level_out;
				end
			3'd2:
				begin
					ff_state_b		<= w_state_out;
					ff_counter_b	<= w_counter_out;
					ff_level_b		<= w_level_out;
				end
			3'd3:
				begin
					ff_state_c		<= w_state_out;
					ff_counter_c	<= w_counter_out;
					ff_level_c		<= w_level_out;
				end
			3'd4:
				begin
					ff_state_d		<= w_state_out;
					ff_counter_d	<= w_counter_out;
					ff_level_d		<= w_level_out;
				end
			3'd5:
				begin
					ff_state_e		<= w_state_out;
					ff_counter_e	<= w_counter_out;
					ff_level_e		<= w_level_out;
				end
			default:
				begin
					//	hold
				end
			endcase
		end
	end

	assign envelope		= w_level_in;
endmodule
