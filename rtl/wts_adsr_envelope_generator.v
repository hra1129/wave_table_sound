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
	input			nreset,					//	negative logic
	input			clk,
	input			active,					//	3.579MHz timing pulse
	input			key_on,					//	pulse
	input			key_release,			//	pulse
	input			key_off,				//	pulse
	output	[8:0]	envelope,				//	0...256
	input	[15:0]	reg_ar,
	input	[15:0]	reg_dr,
	input	[15:0]	reg_sr,
	input	[15:0]	reg_rr,
	input	[7:0]	reg_sl
);
	reg		[2:0]	ff_state;				//	0:idle, 1:attack, 2:decay, 3:sustain, 4:release
	reg		[15:0]	ff_counter;
	reg		[8:0]	ff_level;
	wire	[3:0]	w_state;
	wire			w_counter_end;
	wire			w_note_end;
	wire			w_attack_end;
	wire			w_decay_end;
	wire	[15:0]	w_rate;
	wire	[9:0]	w_add_value;
	wire	[9:0]	w_level_next;
	wire	[9:0]	w_attack;

	function [15:0] func_rate_sel(
		input	[2:0]	state,
		input	[15:0]	ar,
		input	[15:0]	dr,
		input	[15:0]	sr,
		input	[15:0]	rr
	);
		case( state )
		3'd1:		func_rate_sel = ar;
		3'd2:		func_rate_sel = dr;
		3'd3:		func_rate_sel = sr;
		3'd4:		func_rate_sel = rr;
		default:	func_rate_sel = 16'd0;
		endcase
	endfunction

	assign w_rate			= func_rate_sel( ff_state, reg_ar, reg_dr, reg_sr, reg_rr );
	assign w_add_value		= ( w_rate != 16'd0 )? 9'b1 : 9'b0;
	assign w_level_next		= w_state[0] ? (ff_level + w_add_value) : (ff_level - w_add_value);
	assign w_attack			= (reg_ar == 16'd0) ? 9'd256 : 9'd0;

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_level <= 9'd0;
		end
		else if( active ) begin
			if( key_off ) begin
				ff_level <= 9'd0;
			end
			else if( key_on ) begin
				ff_level <= w_attack;
			end
			else if( w_counter_end ) begin
				ff_level <= w_level_next;
			end
			else begin
				//	hold
			end
		end
		else begin
			//	hold
		end
	end

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_counter <= 16'd0;
		end
		else if( active ) begin
			if( key_on || w_counter_end ) begin
				ff_counter <= w_rate;
			end
			else begin
				ff_counter <= ff_counter - 16'd1;
			end
		end
		else begin
			//	hold
		end
	end

	assign w_counter_end	= (ff_counter == 16'd0        ) ? 1'b1 : 1'b0;
	assign w_note_end		=((ff_level == 9'd0           ) ? ~w_state[0] : 1'b0) | key_off;
	assign w_attack_end		= (ff_level == 9'd256         ) ?  w_state[0] : 1'b0;
	assign w_decay_end		= (ff_level == {1'b0, reg_sl} ) ?  w_state[1] : 1'b0;

	function [3:0] func_one_hot_decoder(
		input	[2:0]	state
	);
		case( state )
		3'd1:		func_one_hot_decoder = 4'b0001;
		3'd2:		func_one_hot_decoder = 4'b0010;
		3'd3:		func_one_hot_decoder = 4'b0100;
		3'd4:		func_one_hot_decoder = 4'b1000;
		default:	func_one_hot_decoder = 4'b0000;
		endcase
	endfunction

	assign w_state			= func_one_hot_decoder( ff_state );

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_state <= 3'd0;
		end
		else if( active ) begin
			if( key_on ) begin
				ff_state <= 3'd1;
			end
			else if( w_note_end ) begin
				ff_state <= 3'd0;
			end
			else if( key_release ) begin
				ff_state <= 3'd4;
			end
			else if( w_attack_end ) begin
				ff_state <= 3'd2;
			end
			else if( w_decay_end ) begin
				ff_state <= 3'd3;
			end
			else begin
				//	hold
			end
		end
	end

	assign envelope			= ff_level;
endmodule
