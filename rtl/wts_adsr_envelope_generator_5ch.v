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

	input			ch_a_key_on,
	input			ch_a_key_release,
	input			ch_a_key_off,

	input			ch_b_key_on,
	input			ch_b_key_release,
	input			ch_b_key_off,

	input			ch_c_key_on,
	input			ch_c_key_release,
	input			ch_c_key_off,

	input			ch_d_key_on,
	input			ch_d_key_release,
	input			ch_d_key_off,

	input			ch_e_key_on,
	input			ch_e_key_release,
	input			ch_e_key_off,

	input	[7:0]	reg_ar_a,
	input	[7:0]	reg_dr_a,
	input	[7:0]	reg_sr_a,
	input	[7:0]	reg_rr_a,
	input	[5:0]	reg_sl_a,
	input	[1:0]	reg_wave_length_a,
	input	[11:0]	reg_frequency_count_a,

	input	[7:0]	reg_ar_b,
	input	[7:0]	reg_dr_b,
	input	[7:0]	reg_sr_b,
	input	[7:0]	reg_rr_b,
	input	[5:0]	reg_sl_b,
	input	[1:0]	reg_wave_length_b,
	input	[11:0]	reg_frequency_count_b,

	input	[7:0]	reg_ar_c,
	input	[7:0]	reg_dr_c,
	input	[7:0]	reg_sr_c,
	input	[7:0]	reg_rr_c,
	input	[5:0]	reg_sl_c,
	input	[1:0]	reg_wave_length_c,
	input	[11:0]	reg_frequency_count_c,

	input	[7:0]	reg_ar_d,
	input	[7:0]	reg_dr_d,
	input	[7:0]	reg_sr_d,
	input	[7:0]	reg_rr_d,
	input	[5:0]	reg_sl_d,
	input	[1:0]	reg_wave_length_d,
	input	[11:0]	reg_frequency_count_d,

	input	[7:0]	reg_ar_e,
	input	[7:0]	reg_dr_e,
	input	[7:0]	reg_sr_e,
	input	[7:0]	reg_rr_e,
	input	[5:0]	reg_sl_e,
	input	[1:0]	reg_wave_length_e,
	input	[11:0]	reg_frequency_count_e
);
	wire	[7:0]	w_ar;
	wire	[7:0]	w_dr;
	wire	[7:0]	w_sr;
	wire	[7:0]	w_rr;
	wire	[5:0]	w_sl;
	wire			w_key_on;
	wire			w_key_release;
	wire			w_key_off;

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

	wts_selector #( 8 ) u_ar_selector (
		.active		( active			),
		.result		( w_ar				),
		.reg_a		( reg_ar_a			),
		.reg_b		( reg_ar_b			),
		.reg_c		( reg_ar_c			),
		.reg_d		( reg_ar_d			),
		.reg_e		( reg_ar_e			)
	);

	wts_selector #( 8 ) u_dr_selector (
		.active		( active			),
		.result		( w_dr				),
		.reg_a		( reg_dr_a			),
		.reg_b		( reg_dr_b			),
		.reg_c		( reg_dr_c			),
		.reg_d		( reg_dr_d			),
		.reg_e		( reg_dr_e			)
	);

	wts_selector #( 8 ) u_sr_selector (
		.active		( active			),
		.result		( w_sr				),
		.reg_a		( reg_sr_a			),
		.reg_b		( reg_sr_b			),
		.reg_c		( reg_sr_c			),
		.reg_d		( reg_sr_d			),
		.reg_e		( reg_sr_e			)
	);

	wts_selector #( 8 ) u_rr_selector (
		.active		( active			),
		.result		( w_rr				),
		.reg_a		( reg_rr_a			),
		.reg_b		( reg_rr_b			),
		.reg_c		( reg_rr_c			),
		.reg_d		( reg_rr_d			),
		.reg_e		( reg_rr_e			)
	);

	wts_selector #( 6 ) u_sl_selector (
		.active		( active			),
		.result		( w_sl				),
		.reg_a		( reg_sl_a			),
		.reg_b		( reg_sl_b			),
		.reg_c		( reg_sl_c			),
		.reg_d		( reg_sl_d			),
		.reg_e		( reg_sl_e			)
	);

	wts_selector #( 1 ) u_key_on_selector (
		.active		( active			),
		.result		( w_key_on			),
		.reg_a		( ch_a_key_on		),
		.reg_b		( ch_b_key_on		),
		.reg_c		( ch_c_key_on		),
		.reg_d		( ch_d_key_on		),
		.reg_e		( ch_e_key_on		)
	);

	wts_selector #( 1 ) u_key_release_selector (
		.active		( active			),
		.result		( w_key_release		),
		.reg_a		( ch_a_key_release	),
		.reg_b		( ch_b_key_release	),
		.reg_c		( ch_c_key_release	),
		.reg_d		( ch_d_key_release	),
		.reg_e		( ch_e_key_release	)
	);

	wts_selector #( 1 ) u_key_off_selector (
		.active		( active			),
		.result		( w_key_off			),
		.reg_a		( ch_a_key_off		),
		.reg_b		( ch_b_key_off		),
		.reg_c		( ch_c_key_off		),
		.reg_d		( ch_d_key_off		),
		.reg_e		( ch_e_key_off		)
	);

	wts_selector #( 3 ) u_state_selector (
		.active		( active			),
		.result		( w_state_in		),
		.reg_a		( ff_state_a		),
		.reg_b		( ff_state_b		),
		.reg_c		( ff_state_c		),
		.reg_d		( ff_state_d		),
		.reg_e		( ff_state_e		)
	);

	wts_selector #( 20 ) u_counter_selector (
		.active		( active			),
		.result		( w_counter_in		),
		.reg_a		( ff_counter_a		),
		.reg_b		( ff_counter_b		),
		.reg_c		( ff_counter_c		),
		.reg_d		( ff_counter_d		),
		.reg_e		( ff_counter_e		)
	);

	wts_selector #( 7 ) u_level_selector (
		.active		( active			),
		.result		( w_level_in		),
		.reg_a		( ff_level_a		),
		.reg_b		( ff_level_b		),
		.reg_c		( ff_level_c		),
		.reg_d		( ff_level_d		),
		.reg_e		( ff_level_e		)
	);

	wts_adsr_envelope_generator u_adsr_envelope_generator (
		.key_on					( w_key_on					),
		.key_release			( w_key_release				),
		.key_off				( w_key_off					),
		.reg_ar					( w_ar						),
		.reg_dr					( w_dr						),
		.reg_sr					( w_sr						),
		.reg_rr					( w_rr						),
		.reg_sl					( w_sl						),
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
			3'd0:
				begin
					ff_state_a		<= w_state_out;
					ff_counter_a	<= w_counter_out;
					ff_level_a		<= w_level_out;
				end
			3'd1:
				begin
					ff_state_b		<= w_state_out;
					ff_counter_b	<= w_counter_out;
					ff_level_b		<= w_level_out;
				end
			3'd2:
				begin
					ff_state_c		<= w_state_out;
					ff_counter_c	<= w_counter_out;
					ff_level_c		<= w_level_out;
				end
			3'd3:
				begin
					ff_state_d		<= w_state_out;
					ff_counter_d	<= w_counter_out;
					ff_level_d		<= w_level_out;
				end
			3'd4:
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
