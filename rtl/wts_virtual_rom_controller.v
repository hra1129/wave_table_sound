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

module wts_virtual_rom_controller (
	input			nreset,					//	negative logic
	input			clk,
	input			ce,
	input			wr_req,					//	pulse
	input			rd,
	input	[15:0]	address,
	input	[7:0]	data,
	input			reg_b0_rom_mode,
	input			reg_b1_rom_mode,
	input			reg_b2_rom_mode,
	input			reg_b3_rom_mode,
	input			wts_mode,
	output			scc_bank_en,
	output			scc_i_bank_en,
	output			sram_ncs,				//	negative logic
	output	[18:13]	sram_a
);
	reg		[5:0]	reg_br0;
	reg		[5:0]	reg_br1;
	reg		[5:0]	reg_br2;
	reg		[5:0]	reg_br3;
	wire	[1:0]	w_bank;
	reg				ff_scc_bank_en;
	reg				ff_scc_i_bank_en;
	wire			w_sram_en;

	assign w_bank	= address[14:13];

	// BANK REGISTER 0 ---------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			reg_br0 <= 6'd0;
		end
		else if( wr_req && reg_b0_rom_mode && address[15:11] == 4'b1010 ) begin
			reg_br0 <= data[5:0];
		end
		else begin
			//	hold
		end
	end

	// BANK REGISTER 1 ---------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			reg_br1 <= 6'd0;
		end
		else if( wr_req && reg_b1_rom_mode  && address[14:11] == 4'b1110 ) begin
			reg_br1 <= data[5:0];
		end
		else begin
			//	hold
		end
	end

	// BANK REGISTER 2 ---------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			reg_br2 <= 6'd0;
			ff_scc_bank_en <= 1'b0;
		end
		else if( wr_req && reg_b2_rom_mode  && address[14:11] == 4'b0010 ) begin
			reg_br2 <= data[5:0];
			ff_scc_bank_en <= (data[5:0] == 6'b11_1111) ? 1'b1 : 1'b0;
		end
		else begin
			//	hold
		end
	end

	// BANK REGISTER 3 ---------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			reg_br3 <= 6'd0;
			ff_scc_i_bank_en <= 1'b0;
		end
		else if( wr_req && reg_b3_rom_mode  && address[14:11] == 4'b0110 ) begin
			reg_br3 <= data[5:0];
			ff_scc_i_bank_en <= data[7];
		end
		else begin
			//	hold
		end
	end

	assign w_bank_en		= (w_bank == 2'b00) ? ~(ff_scc_bank_en & address[12]) :					//	BANK2
							  (w_bank == 2'b01) ? ~(ff_scc_i_bank_en & (address[12] | wts_mode)) :	//	BANK3
							  1'b1;																	//	BANK0, BANK1

	assign w_rom_mode		= (w_bank == 2'b00) ? reg_b2_rom_mode :
							  (w_bank == 2'b01) ? reg_b3_rom_mode :
							  (w_bank == 2'b10) ? reg_b0_rom_mode : reg_b1_rom_mode;

	assign w_sram_en		= (w_rom_mode & ~rd) | rd;

	// OUTPUT ASSIGNMENT -------------------------------------
	assign scc_bank_en		= ff_scc_bank_en;
	assign scc_i_bank_en	= ff_scc_i_bank_en;
	assign sram_a[18:13]	= (w_bank == 2'b10) ? reg_br0 :
							  (w_bank == 2'b11) ? reg_br1 :
							  (w_bank == 2'b00) ? reg_br2 : reg_br3;
	assign sram_ncs			= ~(ce & w_sram_en);
endmodule
