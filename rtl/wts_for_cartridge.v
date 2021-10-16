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

module wts_for_cartridge (
	input			clk,			//	21.47727MHz
	input			slot_nreset,	//	negative logic
	output			slot_nint,		//	negative logic, open collector
	input	[15:0]	slot_a,
	inout	[7:0]	slot_d,
	input			slot_nsltsl,	//	negative logic
	input			slot_nmerq,		//	negative logic
	input			slot_nrd,		//	negative logic
	input			slot_nwr,		//	negative logic
	input			sw_mono,
	output			mem_ncs,		//	negative logic
	output	[7:0]	mem_a,			//	external memory address [20:13] Up to 2MB (8KB x 256banks)
	output	[11:0]	left_out,		//	digital sound output (12 bits)
	output	[11:0]	right_out		//	digital sound output (12 bits)
);
	wire	[12:0]	w_mono_out;
	wire	[11:0]	w_left_out;
	wire	[11:0]	w_right_out;
	wire			w_nint;
	wire	[7:0]	w_q;
	wire			w_dir;
	reg				ff_nrd;
	reg				ff_nwr;
	wire			w_wrreq;
	wire			w_rdreq;
	wire			w_mem_ncs;

	assign w_mono_out		= { 1'b0, w_left_out } + { 1'b0, w_right_out };
	assign left_out			= sw_mono ? w_mono_out[12:1] : w_left_out;
	assign right_out		= sw_mono ? w_mono_out[12:1] : w_right_out;

	assign slot_nint		= (w_nint == 1'b0) ? 1'b0 : 1'bz;

	assign w_dir			= ~slot_nrd;
	assign slot_d			= (!slot_nsltsl && w_dir) ? w_q : 8'dz;

	always @( negedge slot_nreset or posedge clk ) begin
		if( !slot_nreset ) begin
			ff_nrd <= 1'b1;
			ff_nwr <= 1'b1;
		end
		else begin
			ff_nrd <= slot_nrd;
			ff_nwr <= slot_nwr;
		end
	end

	assign w_wrreq			= ~slot_nwr & ff_nwr & ~slot_nsltsl;
	assign w_rdreq			= ~slot_nrd & ff_nrd & ~slot_nsltsl;
	assign mem_ncs			= w_mem_ncs | slot_nsltsl;

	wts_core u_wts_core (
		.nreset				( slot_nreset		),
		.clk				( clk				),
		.wrreq				( w_wrreq			),
		.rdreq				( w_rdreq			),
		.a					( slot_a			),
		.d					( slot_d			),
		.q					( w_q				),
		.nint				( w_nint			),
		.mem_ncs			( w_mem_ncs			),
		.mem_a				( mem_a				),
		.left_out			( w_left_out		),
		.right_out			( w_right_out		)
	);
endmodule
