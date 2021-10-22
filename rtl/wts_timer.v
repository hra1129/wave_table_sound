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

module wts_timer (
	input			nreset,
	input			clk,
	input			timer1_trigger,
	input	[6:0]	timer1_address,
	input			reg_timer1_enable,
	input			reg_timer1_clear,
	output	[7:0]	timer1_status,
	input			timer2_trigger,
	input	[6:0]	timer2_address,
	input			reg_timer2_enable,
	input			reg_timer2_clear,
	output	[7:0]	timer2_status,
	output			nint
);
	reg				ff_nint1;
	reg				ff_nint2;
	reg				ff_nint1_rd;
	reg				ff_nint2_rd;
	reg		[6:0]	ff_timer1_address;
	reg		[6:0]	ff_timer2_address;

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_nint1 <= 1'b1;
			ff_timer1_address <= 7'd0;
			ff_nint1_rd <= 1'b1;
		end
		else if( reg_timer1_clear ) begin
			ff_nint1 <= 1'b1;
			ff_nint1_rd <= ff_nint1;
		end
		else if( reg_timer1_enable && timer1_trigger ) begin
			ff_nint1 <= 1'b0;
			ff_nint1_rd <= ff_nint1;
			ff_timer1_address <= timer1_address;
		end
		else begin
			//	hold
		end
	end

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_nint2 <= 1'b1;
			ff_timer2_address <= 7'd0;
			ff_nint2_rd <= 1'b1;
		end
		else if( reg_timer2_clear ) begin
			ff_nint2 <= 1'b1;
			ff_nint2_rd <= ff_nint2;
		end
		else if( reg_timer2_enable && timer2_trigger ) begin
			ff_nint2 <= 1'b0;
			ff_nint2_rd <= 1'b1;
			ff_timer2_address <= timer2_address;
		end
		else begin
			//	hold
		end
	end

	assign timer1_status	= { ff_nint1_rd, ff_timer1_address };
	assign timer2_status	= { ff_nint2_rd, ff_timer2_address };
	assign nint				= ff_nint1 & ff_nint2;
endmodule
