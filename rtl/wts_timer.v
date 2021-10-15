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
	input			timer2_trigger,
	input			reg_timer1_enable,
	input			reg_timer1_clear,
	output			interrupt1,
	input			reg_timer2_enable,
	input			reg_timer2_clear,
	output			interrupt2,
	output			nint
);
	reg				ff_interrupt1;
	reg				ff_interrupt2;

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_interrupt1 <= 1'b0;
		end
		else if( reg_timer1_clear ) begin
			ff_interrupt1 <= 1'b0;
		end
		else if( reg_timer1_enable && timer1_trigger ) begin
			ff_interrupt1 <= 1'b1;
		end
		else begin
			//	hold
		end
	end

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_interrupt2 <= 1'b0;
		end
		else if( reg_timer1_clear ) begin
			ff_interrupt2 <= 1'b0;
		end
		else if( reg_timer2_enable && timer2_trigger ) begin
			ff_interrupt2 <= 1'b1;
		end
		else begin
			//	hold
		end
	end

	assign interrupt1	= ff_interrupt1;
	assign interrupt2	= ff_interrupt2;
	assign nint			= ~(ff_interrupt1 | ff_interrupt2);
endmodule
