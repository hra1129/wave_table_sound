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

module wts_noise_generator_4ch (
	input			nreset,					//	negative logic
	input			clk,
	input	[2:0]	active,					//	0...4 : channel index, 5 : no operation
	output			noise0,
	output			noise1,

	input			reg_noise_enable_a0,
	input			reg_noise_enable_b0,
	input			reg_noise_enable_c0,
	input			reg_noise_enable_d0,
	input			reg_noise_enable_e0,

	input			reg_noise_enable_a1,
	input			reg_noise_enable_b1,
	input			reg_noise_enable_c1,
	input			reg_noise_enable_d1,
	input			reg_noise_enable_e1,

	input	[1:0]	reg_noise_sel_a0,
	input	[1:0]	reg_noise_sel_b0,
	input	[1:0]	reg_noise_sel_c0,
	input	[1:0]	reg_noise_sel_d0,
	input	[1:0]	reg_noise_sel_e0,

	input	[1:0]	reg_noise_sel_a1,
	input	[1:0]	reg_noise_sel_b1,
	input	[1:0]	reg_noise_sel_c1,
	input	[1:0]	reg_noise_sel_d1,
	input	[1:0]	reg_noise_sel_e1,

	input	[4:0]	reg_noise_frequency0,
	input	[4:0]	reg_noise_frequency1,
	input	[4:0]	reg_noise_frequency2,
	input	[4:0]	reg_noise_frequency3
);
	wire			w_noise0;
	wire			w_noise1;
	wire			w_noise2;
	wire			w_noise3;
	wire			w_cpu_timing;
	wire			w_noise_enable0;
	wire			w_noise_enable1;
	wire	[1:0]	w_noise_sel0;
	wire	[1:0]	w_noise_sel1;

	assign w_cpu_timing		= (active == 3'd5) ? 1'b1 : 1'b0;

	wts_selector #( 1 ) u_noise_enable_selector0 (
		.active		( active				),
		.result		( w_noise_enable0		),
		.reg_a		( reg_noise_enable_a0	),
		.reg_b		( reg_noise_enable_b0	),
		.reg_c		( reg_noise_enable_c0	),
		.reg_d		( reg_noise_enable_d0	),
		.reg_e		( reg_noise_enable_e0	)
	);

	wts_selector #( 1 ) u_noise_enable_selector1 (
		.active		( active				),
		.result		( w_noise_enable1		),
		.reg_a		( reg_noise_enable_a1	),
		.reg_b		( reg_noise_enable_b1	),
		.reg_c		( reg_noise_enable_c1	),
		.reg_d		( reg_noise_enable_d1	),
		.reg_e		( reg_noise_enable_e1	)
	);

	wts_selector #( 2 ) u_noise_channel_selector0 (
		.active		( active				),
		.result		( w_noise_sel0			),
		.reg_a		( reg_noise_sel_a0		),
		.reg_b		( reg_noise_sel_b0		),
		.reg_c		( reg_noise_sel_c0		),
		.reg_d		( reg_noise_sel_d0		),
		.reg_e		( reg_noise_sel_e0		)
	);

	wts_selector #( 2 ) u_noise_channel_selector1 (
		.active		( active				),
		.result		( w_noise_sel1			),
		.reg_a		( reg_noise_sel_a1		),
		.reg_b		( reg_noise_sel_b1		),
		.reg_c		( reg_noise_sel_c1		),
		.reg_d		( reg_noise_sel_d1		),
		.reg_e		( reg_noise_sel_e1		)
	);

	wts_noise_generator u_noise_generator0 (
		.nreset					( nreset					),
		.clk					( clk						),
		.active					( w_cpu_timing				),
		.noise					( w_noise0					),
		.reg_frequency_count	( reg_noise_frequency0		)
	);

	wts_noise_generator u_noise_generator1 (
		.nreset					( nreset					),
		.clk					( clk						),
		.active					( w_cpu_timing				),
		.noise					( w_noise1					),
		.reg_frequency_count	( reg_noise_frequency1		)
	);

	wts_noise_generator u_noise_generator2 (
		.nreset					( nreset					),
		.clk					( clk						),
		.active					( w_cpu_timing				),
		.noise					( w_noise2					),
		.reg_frequency_count	( reg_noise_frequency2		)
	);

	wts_noise_generator u_noise_generator3 (
		.nreset					( nreset					),
		.clk					( clk						),
		.active					( w_cpu_timing				),
		.noise					( w_noise3					),
		.reg_frequency_count	( reg_noise_frequency3		)
	);

	function func_noise_sel(
		input	[1:0]	noise_sel,
		input			noise_enable,
		input			noise0,
		input			noise1,
		input			noise2,
		input			noise3
	);
		if( noise_enable ) begin
			case( noise_sel )
			2'd0:		func_noise_sel = noise0;
			2'd1:		func_noise_sel = noise1;
			2'd2:		func_noise_sel = noise2;
			2'd3:		func_noise_sel = noise3;
			default:	func_noise_sel = 1'b1;
			endcase
		end
		else begin
			func_noise_sel = 1'b1;
		end
	endfunction

	assign noise0 = func_noise_sel( w_noise_sel0, w_noise_enable0, w_noise0, w_noise1, w_noise2, w_noise3 );
	assign noise1 = func_noise_sel( w_noise_sel1, w_noise_enable1, w_noise0, w_noise1, w_noise2, w_noise3 );
endmodule
