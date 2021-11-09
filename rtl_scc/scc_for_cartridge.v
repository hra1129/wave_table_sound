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

module scc_for_cartridge (
	input			clk,			//	21.47727MHz
	input			slot_nreset,	//	negative logic
	input	[14:0]	slot_a,
	inout	[7:0]	slot_d,
	input			slot_nsltsl,	//	negative logic
	input			slot_nmerq,		//	negative logic
	input			slot_nrd,		//	negative logic
	input			slot_nwr,		//	negative logic
	output			mem_ncs,		//	negative logic
	output	[7:0]	mem_a,			//	external memory address [20:13] Up to 2MB (8KB x 256banks)
	output	[10:0]	sound_out		//	digital sound output (11 bits)
);
	wire	[7:0]	w_q;
	reg				ff_nrd1;
	reg				ff_nwr1;
	reg				ff_nrd2;
	reg				ff_nwr2;
	wire			w_wrreq;
	wire			w_rdreq;
	wire			w_mem_ncs;

	assign slot_d			= (!slot_nsltsl && ~slot_nrd && w_mem_ncs) ? w_q : 8'dz;

	always @( negedge slot_nreset or posedge clk ) begin
		if( !slot_nreset ) begin
			ff_nrd1 <= 1'b1;
			ff_nwr1 <= 1'b1;
			ff_nrd2 <= 1'b1;
			ff_nwr2 <= 1'b1;
		end
		else begin
			ff_nrd1 <= slot_nrd;
			ff_nwr1 <= slot_nwr;
			ff_nrd2 <= ff_nrd1;
			ff_nwr2 <= ff_nwr1;
		end
	end

	assign w_wrreq			= ~ff_nwr1 & ff_nwr2 & ~slot_nsltsl & ~slot_nmerq;
	assign w_rdreq			= ~ff_nrd1 & ff_nrd2 & ~slot_nsltsl & ~slot_nmerq;
	assign mem_ncs			= w_mem_ncs | slot_nsltsl;

	scc_core #(
		.add_offset			( 1					)
	) u_scc_core (
		.nreset				( slot_nreset		),
		.clk				( clk				),
		.wrreq				( w_wrreq			),
		.rdreq				( w_rdreq			),
		.wr_active			( ~ff_nwr2			),
		.rd_active			( ~ff_nrd2			),
		.a					( slot_a			),
		.d					( slot_d			),
		.q					( w_q				),
		.mem_ncs			( w_mem_ncs			),
		.mem_a				( mem_a				),
		.left_out			( sound_out			)
	);
endmodule
