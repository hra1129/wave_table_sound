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

module wts_adsr_envelope_generator (
	input			key_on,					//	pulse
	input			key_release,			//	pulse
	input			key_off,				//	pulse
	input			reg_enable,
	input	[7:0]	reg_ar,
	input	[7:0]	reg_dr,
	input	[7:0]	reg_sr,
	input	[7:0]	reg_rr,
	input	[5:0]	reg_sl,
	input	[19:0]	counter_in,
	output	[19:0]	counter_out,
	input	[2:0]	state_in,
	output	[2:0]	state_out,
	input	[6:0]	level_in,
	output	[6:0]	level_out				//	0...64
);
	wire	[2:0]	w_state_out;
	wire			w_counter_end;
	wire			w_note_end;
	wire			w_attack_end;
	wire			w_decay_end;
	wire	[7:0]	w_rate;
	wire			w_add_value;
	wire	[6:0]	w_add_value_ext;
	wire	[6:0]	w_level_next;
	wire	[6:0]	w_attack;

	function [7:0] func_rate_sel(
		input	[2:0]	state,
		input	[7:0]	ar,
		input	[7:0]	dr,
		input	[7:0]	sr,
		input	[7:0]	rr
	);
		case( state )
		3'd1:		func_rate_sel = ar;
		3'd2:		func_rate_sel = dr;
		3'd3:		func_rate_sel = sr;
		3'd4:		func_rate_sel = rr;
		default:	func_rate_sel = 8'd0;
		endcase
	endfunction

	assign w_state_out		= func_state( state_in, key_on, key_release, w_note_end, w_attack_end, w_decay_end );
	assign w_rate			= func_rate_sel( w_state_out, reg_ar, reg_dr, reg_sr, reg_rr );
	assign w_add_value		= ( w_rate != 8'd0 )? 1'b1 : 1'b0;
	assign w_add_value_ext	= (w_state_out == 3'd1) ? { 6'd0, w_add_value } : { 7 { w_add_value } };
	assign w_level_next		= level_in + w_add_value_ext;
	assign w_attack			= (reg_ar == 8'd0) ? 7'd64 : 7'd0;

	assign w_counter_end	= (counter_in == 16'd0        ) ? 1'b1 : 1'b0;
	assign w_note_end		=((level_in == 7'd0           ) ? (state_in != 3'd1) : 1'b0) | key_off;
	assign w_attack_end		= (level_in == 7'd64          ) ? (state_in == 3'd1) : 1'b0;
	assign w_decay_end		= (level_in == {1'b0, reg_sl} ) ? (state_in == 3'd2) : 1'b0;

	function [2:0] func_state(
		input	[2:0]	state_in,
		input			key_on,
		input			key_release,
		input			note_end,
		input			attack_end,
		input			decay_end
	);
		if( key_on ) begin
			func_state = 3'd1;
		end
		else if( note_end ) begin
			func_state = 3'd0;
		end
		else if( key_release ) begin
			func_state = 3'd4;
		end
		else if( attack_end ) begin
			func_state = 3'd2;
		end
		else if( decay_end ) begin
			func_state = 3'd3;
		end
		else begin
			func_state = state_in;
		end
	endfunction

	function [6:0] func_level(
		input	[6:0]	level_in,
		input			enable,
		input			key_on,
		input			key_off,
		input			counter_end,
		input	[6:0]	attack,
		input	[6:0]	level_next
	);
		if( !enable ) begin
			func_level = 7'd64;
		end
		else if( key_off ) begin
			func_level = 7'd0;
		end
		else if( key_on ) begin
			func_level = attack;
		end
		else if( counter_end ) begin
			func_level = level_next;
		end
		else begin
			func_level = level_in;
		end
	endfunction

	assign state_out	= w_state_out;
	assign level_out	= func_level( level_in, reg_enable, key_on, key_off, w_counter_end, w_attack, w_level_next );
	assign counter_out	= (key_on || w_counter_end) ? ((w_state_out == 3'd1) ? { 6'd0, w_rate, 6'b111111 } : { w_rate, 12'b1111111111 } ) : (counter_in - 20'd1);
endmodule
