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

module wts_for_ocm (
	input			clk21m,			//	21.47727MHz
	input			reset,
	input			req,
	output			ack,
	input			wrt,
	input	[15:0]	adr,
	output	[7:0]	dbi,
	input	[7:0]	dbo,
	output			nint,			//	0: intetrrupt request, 1: none
	input			sw_mono,
	output			ramreq,
	output			ramwrt,
	output	[20:0]	ramadr,
	input	[7:0]	ramdbi,
	output	[7:0]	ramdbo,
	output	[14:0]	wavl,			//	digital sound output (15 bits)
	output	[14:0]	wavr			//	digital sound output (15 bits)
);
	wire	[12:0]	w_mono_out;
	wire	[11:0]	w_left_out;
	wire	[11:0]	w_right_out;
	wire			w_wrreq;
	wire			w_rdreq;
	wire			w_mem_ncs;
	wire	[20:13]	w_mem_a;
	wire	[7:0]	w_q;
	reg				ff_wr;
	reg				ff_rd;
	reg				ff_req1;
	reg				ff_req2;

	assign w_mono_out		= { 1'b0, w_left_out } + { 1'b0, w_right_out };
	assign wavl				= sw_mono ? { w_mono_out, 2'b0 } : { w_left_out , 3'b0 };
	assign wavr				= sw_mono ? { w_mono_out, 2'b0 } : { w_right_out, 3'b0 };

	assign w_wrreq			= req &  wrt;
	assign w_rdreq			= req & ~wrt;

	assign ramwrt			= wrt;
	assign ramadr			= { w_mem_a, adr[12:0] };
	assign ramreq			= ( w_mem_ncs == 1'b0 ) ? ff_req1 : 1'b0;
	assign dbi				= ( w_mem_ncs == 1'b0 ) ? ramdbi  : w_q;
	assign ack				= ( w_mem_ncs == 1'b0 ) ? ff_req2 : ff_req1;
	assign ramdbo			= dbo;

	always @( posedge reset or posedge clk21m ) begin
		if( reset ) begin
			ff_wr	<= 1'b0;
			ff_rd	<= 1'b0;
			ff_req1	<= 1'b0;
			ff_req2	<= 1'b0;
		end
		else begin
			ff_wr	<= w_wrreq;
			ff_rd	<= w_rdreq;
			ff_req1	<= req;
			ff_req2	<= ff_req1;
		end
	end

	wts_core u_wts_core (
		.nreset				( ~reset			),
		.clk				( clk21m			),
		.wrreq				( w_wrreq			),
		.rdreq				( w_rdreq			),
		.wr_active			( ff_wr				),
		.rd_active			( ff_rd				),
		.a					( adr[14:0]			),
		.d					( dbo				),
		.q					( w_q				),
		.nint				( nint				),
		.mem_ncs			( w_mem_ncs			),
		.mem_a				( w_mem_a			),
		.left_out			( w_left_out		),
		.right_out			( w_right_out		)
	);
endmodule
