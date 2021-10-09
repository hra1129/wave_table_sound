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

module wts_register (
	input				nreset,					//	negative logic
	input				clk,
	input				wrreq,
	input				rdreq,
	input		[15:0]	address,
	input		[7:0]	wrdata,
	output		[7:0]	rddata,

	output		[20:13]	ext_memory_address,

	output reg	[3:0]	sram_id,				//	[2:0]: A...F, [3]: 0 or 1   ex.) A0 = 0000, B1 = 1001, C1 = 1010
	output reg	[6:0]	sram_a,
	output reg	[7:0]	sram_d,
	output reg			sram_oe,
	output reg			sram_we,
	input		[7:0]	sram_q,
	input				sram_q_en,

	output reg			ch_a0_key_on,
	output reg			ch_a0_key_release,
	output reg			ch_a0_key_off,

	output reg			ch_b0_key_on,
	output reg			ch_b0_key_release,
	output reg			ch_b0_key_off,

	output reg			ch_c0_key_on,
	output reg			ch_c0_key_release,
	output reg			ch_c0_key_off,

	output reg			ch_d0_key_on,
	output reg			ch_d0_key_release,
	output reg			ch_d0_key_off,

	output reg			ch_e0_key_on,
	output reg			ch_e0_key_release,
	output reg			ch_e0_key_off,

	output reg			ch_f0_key_on,
	output reg			ch_f0_key_release,
	output reg			ch_f0_key_off,

	output reg			ch_a1_key_on,
	output reg			ch_a1_key_release,
	output reg			ch_a1_key_off,

	output reg			ch_b1_key_on,
	output reg			ch_b1_key_release,
	output reg			ch_b1_key_off,

	output reg			ch_c1_key_on,
	output reg			ch_c1_key_release,
	output reg			ch_c1_key_off,

	output reg			ch_d1_key_on,
	output reg			ch_d1_key_release,
	output reg			ch_d1_key_off,

	output reg			ch_e1_key_on,
	output reg			ch_e1_key_release,
	output reg			ch_e1_key_off,

	output reg			ch_f1_key_on,
	output reg			ch_f1_key_release,
	output reg			ch_f1_key_off,

	output reg	[3:0]	reg_volume_a0,
	output reg	[1:0]	reg_enable_a0,
	output reg			reg_noise_enable_a0,
	output reg	[15:0]	reg_ar_a0,
	output reg	[15:0]	reg_dr_a0,
	output reg	[15:0]	reg_sr_a0,
	output reg	[15:0]	reg_rr_a0,
	output reg	[7:0]	reg_sl_a0,
	output reg	[1:0]	reg_wave_length_a0,
	output reg	[11:0]	reg_frequency_count_a0,
	output reg	[4:0]	reg_noise_frequency_a0,

	output reg	[3:0]	reg_volume_b0,
	output reg	[1:0]	reg_enable_b0,
	output reg			reg_noise_enable_b0,
	output reg	[15:0]	reg_ar_b0,
	output reg	[15:0]	reg_dr_b0,
	output reg	[15:0]	reg_sr_b0,
	output reg	[15:0]	reg_rr_b0,
	output reg	[7:0]	reg_sl_b0,
	output reg	[1:0]	reg_wave_length_b0,
	output reg	[11:0]	reg_frequency_count_b0,
	output reg	[4:0]	reg_noise_frequency_b0,

	output reg	[3:0]	reg_volume_c0,
	output reg	[1:0]	reg_enable_c0,
	output reg			reg_noise_enable_c0,
	output reg	[15:0]	reg_ar_c0,
	output reg	[15:0]	reg_dr_c0,
	output reg	[15:0]	reg_sr_c0,
	output reg	[15:0]	reg_rr_c0,
	output reg	[7:0]	reg_sl_c0,
	output reg	[1:0]	reg_wave_length_c0,
	output reg	[11:0]	reg_frequency_count_c0,
	output reg	[4:0]	reg_noise_frequency_c0,

	output reg	[3:0]	reg_volume_d0,
	output reg	[1:0]	reg_enable_d0,
	output reg			reg_noise_enable_d0,
	output reg	[15:0]	reg_ar_d0,
	output reg	[15:0]	reg_dr_d0,
	output reg	[15:0]	reg_sr_d0,
	output reg	[15:0]	reg_rr_d0,
	output reg	[7:0]	reg_sl_d0,
	output reg	[1:0]	reg_wave_length_d0,
	output reg	[11:0]	reg_frequency_count_d0,
	output reg	[4:0]	reg_noise_frequency_d0,

	output reg	[3:0]	reg_volume_e0,
	output reg	[1:0]	reg_enable_e0,
	output reg			reg_noise_enable_e0,
	output reg	[15:0]	reg_ar_e0,
	output reg	[15:0]	reg_dr_e0,
	output reg	[15:0]	reg_sr_e0,
	output reg	[15:0]	reg_rr_e0,
	output reg	[7:0]	reg_sl_e0,
	output reg	[1:0]	reg_wave_length_e0,
	output reg	[11:0]	reg_frequency_count_e0,
	output reg	[4:0]	reg_noise_frequency_e0,

	output reg	[3:0]	reg_volume_f0,
	output reg	[1:0]	reg_enable_f0,
	output reg			reg_noise_enable_f0,
	output reg	[15:0]	reg_ar_f0,
	output reg	[15:0]	reg_dr_f0,
	output reg	[15:0]	reg_sr_f0,
	output reg	[15:0]	reg_rr_f0,
	output reg	[7:0]	reg_sl_f0,
	output reg	[1:0]	reg_wave_length_f0,
	output reg	[11:0]	reg_frequency_count_f0,
	output reg	[4:0]	reg_noise_frequency_f0,

	output reg	[3:0]	reg_volume_a1,
	output reg	[1:0]	reg_enable_a1,
	output reg			reg_noise_enable_a1,
	output reg	[15:0]	reg_ar_a1,
	output reg	[15:0]	reg_dr_a1,
	output reg	[15:0]	reg_sr_a1,
	output reg	[15:0]	reg_rr_a1,
	output reg	[7:0]	reg_sl_a1,
	output reg	[1:0]	reg_wave_length_a1,
	output reg	[11:0]	reg_frequency_count_a1,
	output reg	[4:0]	reg_noise_frequency_a1,

	output reg	[3:0]	reg_volume_b1,
	output reg	[1:0]	reg_enable_b1,
	output reg			reg_noise_enable_b1,
	output reg	[15:0]	reg_ar_b1,
	output reg	[15:0]	reg_dr_b1,
	output reg	[15:0]	reg_sr_b1,
	output reg	[15:0]	reg_rr_b1,
	output reg	[7:0]	reg_sl_b1,
	output reg	[1:0]	reg_wave_length_b1,
	output reg	[11:0]	reg_frequency_count_b1,
	output reg	[4:0]	reg_noise_frequency_b1,

	output reg	[3:0]	reg_volume_c1,
	output reg	[1:0]	reg_enable_c1,
	output reg			reg_noise_enable_c1,
	output reg	[15:0]	reg_ar_c1,
	output reg	[15:0]	reg_dr_c1,
	output reg	[15:0]	reg_sr_c1,
	output reg	[15:0]	reg_rr_c1,
	output reg	[7:0]	reg_sl_c1,
	output reg	[1:0]	reg_wave_length_c1,
	output reg	[11:0]	reg_frequency_count_c1,
	output reg	[4:0]	reg_noise_frequency_c1,

	output reg	[3:0]	reg_volume_d1,
	output reg	[1:0]	reg_enable_d1,
	output reg			reg_noise_enable_d1,
	output reg	[15:0]	reg_ar_d1,
	output reg	[15:0]	reg_dr_d1,
	output reg	[15:0]	reg_sr_d1,
	output reg	[15:0]	reg_rr_d1,
	output reg	[7:0]	reg_sl_d1,
	output reg	[1:0]	reg_wave_length_d1,
	output reg	[11:0]	reg_frequency_count_d1,
	output reg	[4:0]	reg_noise_frequency_d1,

	output reg	[3:0]	reg_volume_e1,
	output reg	[1:0]	reg_enable_e1,
	output reg			reg_noise_enable_e1,
	output reg	[15:0]	reg_ar_e1,
	output reg	[15:0]	reg_dr_e1,
	output reg	[15:0]	reg_sr_e1,
	output reg	[15:0]	reg_rr_e1,
	output reg	[7:0]	reg_sl_e1,
	output reg	[1:0]	reg_wave_length_e1,
	output reg	[11:0]	reg_frequency_count_e1,
	output reg	[4:0]	reg_noise_frequency_e1,

	output reg	[3:0]	reg_volume_f1,
	output reg	[1:0]	reg_enable_f1,
	output reg			reg_noise_enable_f1,
	output reg	[15:0]	reg_ar_f1,
	output reg	[15:0]	reg_dr_f1,
	output reg	[15:0]	reg_sr_f1,
	output reg	[15:0]	reg_rr_f1,
	output reg	[7:0]	reg_sl_f1,
	output reg	[1:0]	reg_wave_length_f1,
	output reg	[11:0]	reg_frequency_count_f1,
	output reg	[4:0]	reg_noise_frequency_f1
);
	reg		[7:0]	reg_bank0;
	reg		[7:0]	reg_bank1;
	reg		[7:0]	reg_bank2;
	reg		[7:0]	reg_bank3;

	reg				reg_wts_enable;
	reg				reg_scci_enable;
	reg				reg_ram_mode0;
	reg				reg_ram_mode1;
	reg				reg_ram_mode2;
	reg				reg_ram_mode3;

	wire			w_dec_bank0;
	wire			w_dec_bank1;
	wire			w_dec_bank2;
	wire			w_dec_bank3;

	wire			w_scc_en;
	wire			w_scci_en;
	wire			w_wts_en;

	// Bank decoder -----------------------------------------------------------
	assign w_dec_bank0		= (address[14:13] == 2'b10) ? 1'b1 : 1'b0;
	assign w_dec_bank1		= (address[14:13] == 2'b11) ? 1'b1 : 1'b0;
	assign w_dec_bank2		= (address[14:13] == 2'b00) ? 1'b1 : 1'b0;
	assign w_dec_bank3		= (address[14:13] == 2'b01) ? 1'b1 : 1'b0;

	// BFFE-BFFFh Mode Register -----------------------------------------------
	assign w_scc_en			= (reg_bank2 == 8'h3F) ? (w_dec_bank2 & !reg_scci_enable) : 1'b0;
	assign w_scci_en		= reg_bank3[7] & w_dec_bank3 & reg_scci_enable;
	assign w_wts_en			= reg_bank3[7] & w_dec_bank3 & reg_scci_enable & reg_wts_enable;

	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			reg_wts_enable	<= 1'b0;
			reg_scci_enable	<= 1'b0;
			reg_ram_mode0	<= 1'b0;
			reg_ram_mode1	<= 1'b0;
			reg_ram_mode2	<= 1'b0;
			reg_ram_mode3	<= 1'b0;
		end
		else if( wrreq && w_dec_bank3 && (address[12:1] == 12'b1_1111_1111_111) ) begin
			reg_wts_enable	<= wrdata[6];
			reg_scci_enable	<= wrdata[5];
			reg_ram_mode0	<= wrdata[4] | wrdata[0];
			reg_ram_mode1	<= wrdata[4] | wrdata[1];
			reg_ram_mode2	<= wrdata[4] | wrdata[2];
			reg_ram_mode3	<= wrdata[4];
		end
	end

	// x000-x7FFh Bank Registers ----------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			reg_bank0		<= 8'd0;
			reg_bank1		<= 8'd1;
			reg_bank2		<= 8'd2;
			reg_bank3		<= 8'd3;
		end
		else if( wrreq && address[12] ) begin
			if(      w_dec_bank0 && !reg_ram_mode0 ) begin
				reg_bank0		<= wrdata;
			end
			else if( w_dec_bank1 && !reg_ram_mode1 ) begin
				reg_bank1		<= wrdata;
			end
			else if( w_dec_bank2 && !reg_ram_mode2 ) begin
				reg_bank2		<= wrdata;
			end
			else if( w_dec_bank3 && !reg_ram_mode3 ) begin
				reg_bank3		<= wrdata;
			end
			else begin
				//	hold
			end
		end
	end

	// Wave memory ------------------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			sram_id	<= 4'd0;
			sram_a	<= 7'd0;
			sram_d	<= 8'd0;
			sram_oe	<= 1'b0;
			sram_we	<= 1'b0;
		end
		else if( w_scc_en && (address[12:7] == 6'b1_1000_0) ) begin
			//	9800-987Fh : {100} 1 1000 0XXX XXXX
			sram_id	<= { 2'b00, address[6:5] };
			sram_a	<= { 2'b00, address[4:0] };
			sram_oe	<= rdreq;
			sram_we	<= wrreq;
		end
		else if( w_scc_en && (address[12:5] == 8'b1_1000_101) ) begin
			//	98A0-98BFh : {100} 1 1000 101X XXXX ReadOnly
			sram_id	<= 4'd5;						// Ch.E0
			sram_a	<= { 2'b00, address[4:0] };
			sram_oe	<= rdreq;
			sram_we	<= 1'b0;
		end
		else if( w_scci_en && (address[12:8] == 5'b1_1000) && (!address[7] || address[7:5] == 3'b100) ) begin
			//	B800-B87Fh : {101} 1 1000 0XXX XXXX
			//	B880-B89Fh : {101} 1 1000 100X XXXX
			sram_id	<= { 1'b0,  address[7:5] };
			sram_a	<= { 2'b00, address[4:0] };
			sram_oe	<= rdreq;
			sram_we	<= wrreq;
		end
		else if( w_wts_en && (address[12:11] == 2'b00) && (!address[10] || !address[10:9] == 2'b10) ) begin
			//	A000-A2FFh : {101} 0 00XX XXXX XXXX Ch.A0-F0
			//	A300-A3FFh : {101} 0 0011 XXXX XXXX Ch.A1-B1
			//	A400-A5FFh : {101} 0 010X XXXX XXXX Ch.C1-F1
			
			if( address[9:8] == 2'b11 ) begin
				//	A300-A3FFh : {101} 0 0011 XXXX XXXX Ch.A1-B1 --> 8, 9
				sram_id	<= { 3'b100,  address[7] };
			end
			else if( address[10] == 1'b0 ) begin
				//	A000-A2FFh : {101} 0 00XX XXXX XXXX Ch.A0-F0 --> 0...5
				sram_id	<= { 1'b0,  address[9:7] };
			end
			else begin
				//	A400-A5FFh : {101} 0 010X XXXX XXXX Ch.C1-F1 --> 10,11,12,13
				sram_id	<= { 1'b1,  address[8], ~address[8], address[7] };
			end
			sram_a	<= address[6:0];
			sram_oe	<= rdreq;
			sram_we	<= wrreq;
		end
	end

	// External memory address ------------------------------------------------
	assign ext_memory_address	= w_dec_bank0 ? reg_bank0 :
	                         	  w_dec_bank1 ? reg_bank1 :
	                         	  w_dec_bank2 ? reg_bank2 : reg_bank3;
endmodule
