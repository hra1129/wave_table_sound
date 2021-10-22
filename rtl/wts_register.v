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
	input				wr_active,
	input				rd_active,
	input		[15:0]	address,
	input		[7:0]	wrdata,
	output		[7:0]	rddata,

	output reg			ext_memory_nactive,
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

	output				ch_a1_key_on,
	output				ch_a1_key_release,
	output				ch_a1_key_off,

	output				ch_b1_key_on,
	output				ch_b1_key_release,
	output				ch_b1_key_off,

	output				ch_c1_key_on,
	output				ch_c1_key_release,
	output				ch_c1_key_off,

	output				ch_d1_key_on,
	output				ch_d1_key_release,
	output				ch_d1_key_off,

	output				ch_e1_key_on,
	output				ch_e1_key_release,
	output				ch_e1_key_off,

	output				ch_f1_key_on,
	output				ch_f1_key_release,
	output				ch_f1_key_off,

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

	output		[3:0]	reg_volume_a1,
	output		[1:0]	reg_enable_a1,
	output				reg_noise_enable_a1,
	output		[15:0]	reg_ar_a1,
	output		[15:0]	reg_dr_a1,
	output		[15:0]	reg_sr_a1,
	output		[15:0]	reg_rr_a1,
	output		[7:0]	reg_sl_a1,
	output		[1:0]	reg_wave_length_a1,
	output		[11:0]	reg_frequency_count_a1,
	output		[4:0]	reg_noise_frequency_a1,

	output		[3:0]	reg_volume_b1,
	output		[1:0]	reg_enable_b1,
	output				reg_noise_enable_b1,
	output		[15:0]	reg_ar_b1,
	output		[15:0]	reg_dr_b1,
	output		[15:0]	reg_sr_b1,
	output		[15:0]	reg_rr_b1,
	output		[7:0]	reg_sl_b1,
	output		[1:0]	reg_wave_length_b1,
	output		[11:0]	reg_frequency_count_b1,
	output		[4:0]	reg_noise_frequency_b1,

	output		[3:0]	reg_volume_c1,
	output		[1:0]	reg_enable_c1,
	output				reg_noise_enable_c1,
	output		[15:0]	reg_ar_c1,
	output		[15:0]	reg_dr_c1,
	output		[15:0]	reg_sr_c1,
	output		[15:0]	reg_rr_c1,
	output		[7:0]	reg_sl_c1,
	output		[1:0]	reg_wave_length_c1,
	output		[11:0]	reg_frequency_count_c1,
	output		[4:0]	reg_noise_frequency_c1,

	output		[3:0]	reg_volume_d1,
	output		[1:0]	reg_enable_d1,
	output				reg_noise_enable_d1,
	output		[15:0]	reg_ar_d1,
	output		[15:0]	reg_dr_d1,
	output		[15:0]	reg_sr_d1,
	output		[15:0]	reg_rr_d1,
	output		[7:0]	reg_sl_d1,
	output		[1:0]	reg_wave_length_d1,
	output		[11:0]	reg_frequency_count_d1,
	output		[4:0]	reg_noise_frequency_d1,

	output		[3:0]	reg_volume_e1,
	output		[1:0]	reg_enable_e1,
	output				reg_noise_enable_e1,
	output		[15:0]	reg_ar_e1,
	output		[15:0]	reg_dr_e1,
	output		[15:0]	reg_sr_e1,
	output		[15:0]	reg_rr_e1,
	output		[7:0]	reg_sl_e1,
	output		[1:0]	reg_wave_length_e1,
	output		[11:0]	reg_frequency_count_e1,
	output		[4:0]	reg_noise_frequency_e1,

	output		[3:0]	reg_volume_f1,
	output		[1:0]	reg_enable_f1,
	output				reg_noise_enable_f1,
	output		[15:0]	reg_ar_f1,
	output		[15:0]	reg_dr_f1,
	output		[15:0]	reg_sr_f1,
	output		[15:0]	reg_rr_f1,
	output		[7:0]	reg_sl_f1,
	output		[1:0]	reg_wave_length_f1,
	output		[11:0]	reg_frequency_count_f1,
	output		[4:0]	reg_noise_frequency_f1,

	output reg			reg_timer1_enable,
	output reg	[3:0]	reg_timer1_channel,
	output reg			reg_timer1_clear,
	input		[7:0]	timer1_status,

	output reg			reg_timer2_enable,
	output reg	[3:0]	reg_timer2_channel,
	output reg			reg_timer2_clear,
	input		[7:0]	timer2_status
);
	reg		[7:0]	ff_sram_q;

	reg		[7:0]	reg_bank0;
	reg		[7:0]	reg_bank1;
	reg		[7:0]	reg_bank2;
	reg		[7:0]	reg_bank3;

	reg				reg_timer1_oneshot;
	reg				reg_timer2_oneshot;

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

	reg				ff_ch_a1_key_on;
	reg				ff_ch_a1_key_release;
	reg				ff_ch_a1_key_off;

	reg				ff_ch_b1_key_on;
	reg				ff_ch_b1_key_release;
	reg				ff_ch_b1_key_off;

	reg				ff_ch_c1_key_on;
	reg				ff_ch_c1_key_release;
	reg				ff_ch_c1_key_off;

	reg				ff_ch_d1_key_on;
	reg				ff_ch_d1_key_release;
	reg				ff_ch_d1_key_off;

	reg				ff_ch_e1_key_on;
	reg				ff_ch_e1_key_release;
	reg				ff_ch_e1_key_off;

	reg				ff_ch_f1_key_on;
	reg				ff_ch_f1_key_release;
	reg				ff_ch_f1_key_off;

	reg		[3:0]	ff_reg_volume_a1;
	reg		[1:0]	ff_reg_enable_a1;
	reg				ff_reg_noise_enable_a1;
	reg				ff_reg_clone_frequency_a1;
	reg				ff_reg_clone_adsr_a1;
	reg				ff_reg_clone_noise_a1;
	reg				ff_reg_clone_wave_a1;
	reg				ff_reg_clone_key_a1;
	reg		[15:0]	ff_reg_ar_a1;
	reg		[15:0]	ff_reg_dr_a1;
	reg		[15:0]	ff_reg_sr_a1;
	reg		[15:0]	ff_reg_rr_a1;
	reg		[7:0]	ff_reg_sl_a1;
	reg		[1:0]	ff_reg_wave_length_a1;
	reg		[11:0]	ff_reg_frequency_count_a1;
	reg		[4:0]	ff_reg_noise_frequency_a1;

	reg		[3:0]	ff_reg_volume_b1;
	reg		[1:0]	ff_reg_enable_b1;
	reg				ff_reg_noise_enable_b1;
	reg				ff_reg_clone_frequency_b1;
	reg				ff_reg_clone_adsr_b1;
	reg				ff_reg_clone_noise_b1;
	reg				ff_reg_clone_wave_b1;
	reg				ff_reg_clone_key_b1;
	reg		[15:0]	ff_reg_ar_b1;
	reg		[15:0]	ff_reg_dr_b1;
	reg		[15:0]	ff_reg_sr_b1;
	reg		[15:0]	ff_reg_rr_b1;
	reg		[7:0]	ff_reg_sl_b1;
	reg		[1:0]	ff_reg_wave_length_b1;
	reg		[11:0]	ff_reg_frequency_count_b1;
	reg		[4:0]	ff_reg_noise_frequency_b1;

	reg		[3:0]	ff_reg_volume_c1;
	reg		[1:0]	ff_reg_enable_c1;
	reg				ff_reg_noise_enable_c1;
	reg				ff_reg_clone_frequency_c1;
	reg				ff_reg_clone_adsr_c1;
	reg				ff_reg_clone_noise_c1;
	reg				ff_reg_clone_wave_c1;
	reg				ff_reg_clone_key_c1;
	reg		[15:0]	ff_reg_ar_c1;
	reg		[15:0]	ff_reg_dr_c1;
	reg		[15:0]	ff_reg_sr_c1;
	reg		[15:0]	ff_reg_rr_c1;
	reg		[7:0]	ff_reg_sl_c1;
	reg		[1:0]	ff_reg_wave_length_c1;
	reg		[11:0]	ff_reg_frequency_count_c1;
	reg		[4:0]	ff_reg_noise_frequency_c1;

	reg		[3:0]	ff_reg_volume_d1;
	reg		[1:0]	ff_reg_enable_d1;
	reg				ff_reg_noise_enable_d1;
	reg				ff_reg_clone_frequency_d1;
	reg				ff_reg_clone_adsr_d1;
	reg				ff_reg_clone_noise_d1;
	reg				ff_reg_clone_wave_d1;
	reg				ff_reg_clone_key_d1;
	reg		[15:0]	ff_reg_ar_d1;
	reg		[15:0]	ff_reg_dr_d1;
	reg		[15:0]	ff_reg_sr_d1;
	reg		[15:0]	ff_reg_rr_d1;
	reg		[7:0]	ff_reg_sl_d1;
	reg		[1:0]	ff_reg_wave_length_d1;
	reg		[11:0]	ff_reg_frequency_count_d1;
	reg		[4:0]	ff_reg_noise_frequency_d1;

	reg		[3:0]	ff_reg_volume_e1;
	reg		[1:0]	ff_reg_enable_e1;
	reg				ff_reg_noise_enable_e1;
	reg				ff_reg_clone_frequency_e1;
	reg				ff_reg_clone_adsr_e1;
	reg				ff_reg_clone_noise_e1;
	reg				ff_reg_clone_wave_e1;
	reg				ff_reg_clone_key_e1;
	reg		[15:0]	ff_reg_ar_e1;
	reg		[15:0]	ff_reg_dr_e1;
	reg		[15:0]	ff_reg_sr_e1;
	reg		[15:0]	ff_reg_rr_e1;
	reg		[7:0]	ff_reg_sl_e1;
	reg		[1:0]	ff_reg_wave_length_e1;
	reg		[11:0]	ff_reg_frequency_count_e1;
	reg		[4:0]	ff_reg_noise_frequency_e1;

	reg		[3:0]	ff_reg_volume_f1;
	reg		[1:0]	ff_reg_enable_f1;
	reg				ff_reg_noise_enable_f1;
	reg				ff_reg_clone_frequency_f1;
	reg				ff_reg_clone_adsr_f1;
	reg				ff_reg_clone_noise_f1;
	reg				ff_reg_clone_wave_f1;
	reg				ff_reg_clone_key_f1;
	reg		[15:0]	ff_reg_ar_f1;
	reg		[15:0]	ff_reg_dr_f1;
	reg		[15:0]	ff_reg_sr_f1;
	reg		[15:0]	ff_reg_rr_f1;
	reg		[7:0]	ff_reg_sl_f1;
	reg		[1:0]	ff_reg_wave_length_f1;
	reg		[11:0]	ff_reg_frequency_count_f1;
	reg		[4:0]	ff_reg_noise_frequency_f1;

	// Bank decoder -----------------------------------------------------------
	assign w_dec_bank0		= (address[14:13] == 2'b10) ? 1'b1 : 1'b0;
	assign w_dec_bank1		= (address[14:13] == 2'b11) ? 1'b1 : 1'b0;
	assign w_dec_bank2		= (address[14:13] == 2'b00) ? 1'b1 : 1'b0;
	assign w_dec_bank3		= (address[14:13] == 2'b01) ? 1'b1 : 1'b0;

	// External Memory Access -------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ext_memory_nactive <= 1'b1;
		end
		else if( ~rd_active && w_dec_bank3 && (address[12:1] == 12'b1_1111_1111_111) ) begin
			ext_memory_nactive <= 1'b1;
		end
		else if( w_scc_en ) begin
			if( address[7] == 1'b0 ) begin
				ext_memory_nactive <= 1'b1;
			end
			else if( rdreq ) begin
				ext_memory_nactive <= 1'b0;
			end
			else begin
				ext_memory_nactive <= 1'b1;
			end
		end
		else if( w_scci_en ) begin
			if( address[7] == 1'b0 ) begin
				ext_memory_nactive <= 1'b1;
			end
			else if( address[7:5] == 3'b100 ) begin
				ext_memory_nactive <= 1'b1;
			end
			else if( rdreq ) begin
				ext_memory_nactive <= 1'b0;
			end
			else begin
				ext_memory_nactive <= 1'b1;
			end
		end
		else if( w_wts_en ) begin
			ext_memory_nactive <= 1'b1;
		end
		else if( address[11] == 1'b0 ) begin
			//	bank register
			if( rdreq ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( w_dec_bank0 && reg_ram_mode0 ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( w_dec_bank1 && reg_ram_mode1 ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( w_dec_bank2 && reg_ram_mode2 ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( w_dec_bank3 && reg_ram_mode3 ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( ~wr_active && ~rd_active ) begin
				ext_memory_nactive <= 1'b1;
			end
			else begin
				//	hold
			end
		end
		else begin
			if( rdreq ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( w_dec_bank0 && reg_ram_mode0 ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( w_dec_bank1 && reg_ram_mode1 ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( w_dec_bank2 && reg_ram_mode2 ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( w_dec_bank3 && reg_ram_mode3 ) begin
				ext_memory_nactive <= 1'b0;
			end
			else if( ~wr_active && ~rd_active ) begin
				ext_memory_nactive <= 1'b1;
			end
			else begin
				//	hold
			end
		end
	end

	// BFFE-BFFFh Mode Register -----------------------------------------------
	assign w_scc_en			= ( (reg_bank2 == 8'h3F) && (address[12:8] == 5'b11000) ) ? (w_dec_bank2 & !reg_scci_enable) : 1'b0;
	assign w_scci_en		= reg_bank3[7] & w_dec_bank3 &  address[12] & address[11] & reg_scci_enable;
	assign w_wts_en			= reg_bank3[7] & w_dec_bank3 & ~address[12] & address[11] & reg_wts_enable;

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
		else if( wrreq && address[12] && ~address[11] ) begin
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
			sram_d	<= wrdata;
		end
		else if( w_scc_en && (address[12:5] == 8'b1_1000_101) ) begin
			//	98A0-98BFh : {100} 1 1000 101X XXXX ReadOnly
			sram_id	<= 4'd5;						// Ch.E0
			sram_a	<= { 2'b00, address[4:0] };
			sram_oe	<= rdreq;
			sram_we	<= 1'b0;
			sram_d	<= wrdata;
		end
		else if( w_scci_en && (address[10:8] == 3'b000) && (!address[7] || address[7:5] == 3'b100) ) begin
			//	B800-B87Fh : {101} 1 1000 0XXX XXXX
			//	B880-B89Fh : {101} 1 1000 100X XXXX
			sram_id	<= { 1'b0,  address[7:5] };
			sram_a	<= { 2'b00, address[4:0] };
			sram_oe	<= rdreq;
			sram_we	<= wrreq;
			sram_d	<= wrdata;
		end
		else if( w_wts_en && (!address[10] || !address[9]) ) begin
			//	A800-AAFFh : {101} 0 10XX XXXX XXXX Ch.A0-F0	SRAM_ID: 0...5
			//	AB00-ABFFh : {101} 0 1011 XXXX XXXX Ch.A1-B1	SRAM_ID: 8,9
			//	AC00-ADFFh : {101} 0 110X XXXX XXXX Ch.C1-F1	SRAM_ID: 10,11,12,13
			
			if( address[9:8] == 2'b11 ) begin
				//	AB00-ABFFh : {101} 0 1011 XXXX XXXX Ch.A1-B1 --> 8, 9
				sram_id	<= { 3'b100,  address[7] };
			end
			else if( address[10] == 1'b0 ) begin
				//	A800-AAFFh : {101} 0 10XX XXXX XXXX Ch.A0-F0 --> 0...5
				sram_id	<= { 1'b0,  address[9:7] };
			end
			else begin
				//	AC00-ADFFh : {101} 0 110X XXXX XXXX Ch.C1-F1 --> 10,11,12,13
				sram_id	<= { 1'b1,  address[8], ~address[8], address[7] };
			end
			sram_a	<= address[6:0];
			sram_oe	<= rdreq;
			sram_we	<= wrreq;
			sram_d	<= wrdata;
		end
	end

	// Control registers ------------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ch_a0_key_on				<= 1'b0;
			ch_a0_key_release			<= 1'b0;
			ch_a0_key_off				<= 1'b0;

			ch_b0_key_on				<= 1'b0;
			ch_b0_key_release			<= 1'b0;
			ch_b0_key_off				<= 1'b0;

			ch_c0_key_on				<= 1'b0;
			ch_c0_key_release			<= 1'b0;
			ch_c0_key_off				<= 1'b0;

			ch_d0_key_on				<= 1'b0;
			ch_d0_key_release			<= 1'b0;
			ch_d0_key_off				<= 1'b0;

			ch_e0_key_on				<= 1'b0;
			ch_e0_key_release			<= 1'b0;
			ch_e0_key_off				<= 1'b0;

			ch_f0_key_on				<= 1'b0;
			ch_f0_key_release			<= 1'b0;
			ch_f0_key_off				<= 1'b0;

			ff_ch_a1_key_on				<= 1'b0;
			ff_ch_a1_key_release		<= 1'b0;
			ff_ch_a1_key_off			<= 1'b0;

			ff_ch_b1_key_on				<= 1'b0;
			ff_ch_b1_key_release		<= 1'b0;
			ff_ch_b1_key_off			<= 1'b0;

			ff_ch_c1_key_on				<= 1'b0;
			ff_ch_c1_key_release		<= 1'b0;
			ff_ch_c1_key_off			<= 1'b0;

			ff_ch_d1_key_on				<= 1'b0;
			ff_ch_d1_key_release		<= 1'b0;
			ff_ch_d1_key_off			<= 1'b0;

			ff_ch_e1_key_on				<= 1'b0;
			ff_ch_e1_key_release		<= 1'b0;
			ff_ch_e1_key_off			<= 1'b0;

			ff_ch_f1_key_on				<= 1'b0;
			ff_ch_f1_key_release		<= 1'b0;
			ff_ch_f1_key_off			<= 1'b0;

			reg_volume_a0				<= 'd0;
			reg_enable_a0				<= 'd0;
			reg_noise_enable_a0			<= 'd0;
			reg_ar_a0					<= 'd0;
			reg_dr_a0					<= 'd0;
			reg_sr_a0					<= 'd0;
			reg_rr_a0					<= 'd0;
			reg_sl_a0					<= 'd0;
			reg_wave_length_a0			<= 'd0;
			reg_frequency_count_a0		<= 'd0;
			reg_noise_frequency_a0		<= 'd0;

			reg_volume_b0				<= 'd0;
			reg_enable_b0				<= 'd0;
			reg_noise_enable_b0			<= 'd0;
			reg_ar_b0					<= 'd0;
			reg_dr_b0					<= 'd0;
			reg_sr_b0					<= 'd0;
			reg_rr_b0					<= 'd0;
			reg_sl_b0					<= 'd0;
			reg_wave_length_b0			<= 'd0;
			reg_frequency_count_b0		<= 'd0;
			reg_noise_frequency_b0		<= 'd0;

			reg_volume_c0				<= 'd0;
			reg_enable_c0				<= 'd0;
			reg_noise_enable_c0			<= 'd0;
			reg_ar_c0					<= 'd0;
			reg_dr_c0					<= 'd0;
			reg_sr_c0					<= 'd0;
			reg_rr_c0					<= 'd0;
			reg_sl_c0					<= 'd0;
			reg_wave_length_c0			<= 'd0;
			reg_frequency_count_c0		<= 'd0;
			reg_noise_frequency_c0		<= 'd0;

			reg_volume_d0				<= 'd0;
			reg_enable_d0				<= 'd0;
			reg_noise_enable_d0			<= 'd0;
			reg_ar_d0					<= 'd0;
			reg_dr_d0					<= 'd0;
			reg_sr_d0					<= 'd0;
			reg_rr_d0					<= 'd0;
			reg_sl_d0					<= 'd0;
			reg_wave_length_d0			<= 'd0;
			reg_frequency_count_d0		<= 'd0;
			reg_noise_frequency_d0		<= 'd0;

			reg_volume_e0				<= 'd0;
			reg_enable_e0				<= 'd0;
			reg_noise_enable_e0			<= 'd0;
			reg_ar_e0					<= 'd0;
			reg_dr_e0					<= 'd0;
			reg_sr_e0					<= 'd0;
			reg_rr_e0					<= 'd0;
			reg_sl_e0					<= 'd0;
			reg_wave_length_e0			<= 'd0;
			reg_frequency_count_e0		<= 'd0;
			reg_noise_frequency_e0		<= 'd0;

			reg_volume_f0				<= 'd0;
			reg_enable_f0				<= 'd0;
			reg_noise_enable_f0			<= 'd0;
			reg_ar_f0					<= 'd0;
			reg_dr_f0					<= 'd0;
			reg_sr_f0					<= 'd0;
			reg_rr_f0					<= 'd0;
			reg_sl_f0					<= 'd0;
			reg_wave_length_f0			<= 'd0;
			reg_frequency_count_f0		<= 'd0;
			reg_noise_frequency_f0		<= 'd0;

			ff_reg_volume_a1			<= 'd0;
			ff_reg_enable_a1			<= 'd0;
			ff_reg_noise_enable_a1		<= 'd0;
			ff_reg_clone_frequency_a1	<= 'd1;
			ff_reg_clone_adsr_a1		<= 'd1;
			ff_reg_clone_noise_a1		<= 'd1;
			ff_reg_clone_wave_a1		<= 'd1;
			ff_reg_clone_key_a1			<= 'd1;
			ff_reg_ar_a1				<= 'd0;
			ff_reg_dr_a1				<= 'd0;
			ff_reg_sr_a1				<= 'd0;
			ff_reg_rr_a1				<= 'd0;
			ff_reg_sl_a1				<= 'd0;
			ff_reg_wave_length_a1		<= 'd0;
			ff_reg_frequency_count_a1	<= 'd0;
			ff_reg_noise_frequency_a1	<= 'd0;

			ff_reg_volume_b1			<= 'd0;
			ff_reg_enable_b1			<= 'd0;
			ff_reg_noise_enable_b1		<= 'd0;
			ff_reg_clone_frequency_b1	<= 'd1;
			ff_reg_clone_adsr_b1		<= 'd1;
			ff_reg_clone_noise_b1		<= 'd1;
			ff_reg_clone_wave_b1		<= 'd1;
			ff_reg_clone_key_b1			<= 'd1;
			ff_reg_ar_b1				<= 'd0;
			ff_reg_dr_b1				<= 'd0;
			ff_reg_sr_b1				<= 'd0;
			ff_reg_rr_b1				<= 'd0;
			ff_reg_sl_b1				<= 'd0;
			ff_reg_wave_length_b1		<= 'd0;
			ff_reg_frequency_count_b1	<= 'd0;
			ff_reg_noise_frequency_b1	<= 'd0;

			ff_reg_volume_c1			<= 'd0;
			ff_reg_enable_c1			<= 'd0;
			ff_reg_noise_enable_c1		<= 'd0;
			ff_reg_clone_frequency_c1	<= 'd1;
			ff_reg_clone_adsr_c1		<= 'd1;
			ff_reg_clone_noise_c1		<= 'd1;
			ff_reg_clone_wave_c1		<= 'd1;
			ff_reg_clone_key_c1			<= 'd1;
			ff_reg_ar_c1				<= 'd0;
			ff_reg_dr_c1				<= 'd0;
			ff_reg_sr_c1				<= 'd0;
			ff_reg_rr_c1				<= 'd0;
			ff_reg_sl_c1				<= 'd0;
			ff_reg_wave_length_c1		<= 'd0;
			ff_reg_frequency_count_c1	<= 'd0;
			ff_reg_noise_frequency_c1	<= 'd0;

			ff_reg_volume_d1			<= 'd0;
			ff_reg_enable_d1			<= 'd0;
			ff_reg_noise_enable_d1		<= 'd0;
			ff_reg_clone_frequency_d1	<= 'd1;
			ff_reg_clone_adsr_d1		<= 'd1;
			ff_reg_clone_noise_d1		<= 'd1;
			ff_reg_clone_wave_d1		<= 'd1;
			ff_reg_clone_key_d1			<= 'd1;
			ff_reg_ar_d1				<= 'd0;
			ff_reg_dr_d1				<= 'd0;
			ff_reg_sr_d1				<= 'd0;
			ff_reg_rr_d1				<= 'd0;
			ff_reg_sl_d1				<= 'd0;
			ff_reg_wave_length_d1		<= 'd0;
			ff_reg_frequency_count_d1	<= 'd0;
			ff_reg_noise_frequency_d1	<= 'd0;

			ff_reg_volume_e1			<= 'd0;
			ff_reg_enable_e1			<= 'd0;
			ff_reg_noise_enable_e1		<= 'd0;
			ff_reg_clone_frequency_e1	<= 'd1;
			ff_reg_clone_adsr_e1		<= 'd1;
			ff_reg_clone_noise_e1		<= 'd1;
			ff_reg_clone_wave_e1		<= 'd1;
			ff_reg_clone_key_e1			<= 'd1;
			ff_reg_ar_e1				<= 'd0;
			ff_reg_dr_e1				<= 'd0;
			ff_reg_sr_e1				<= 'd0;
			ff_reg_rr_e1				<= 'd0;
			ff_reg_sl_e1				<= 'd0;
			ff_reg_wave_length_e1		<= 'd0;
			ff_reg_frequency_count_e1	<= 'd0;
			ff_reg_noise_frequency_e1	<= 'd0;

			ff_reg_volume_f1			<= 'd0;
			ff_reg_enable_f1			<= 'd0;
			ff_reg_noise_enable_f1		<= 'd0;
			ff_reg_clone_frequency_f1	<= 'd1;
			ff_reg_clone_adsr_f1		<= 'd1;
			ff_reg_clone_noise_f1		<= 'd1;
			ff_reg_clone_wave_f1		<= 'd1;
			ff_reg_clone_key_f1			<= 'd1;
			ff_reg_ar_f1				<= 'd0;
			ff_reg_dr_f1				<= 'd0;
			ff_reg_sr_f1				<= 'd0;
			ff_reg_rr_f1				<= 'd0;
			ff_reg_sl_f1				<= 'd0;
			ff_reg_wave_length_f1		<= 'd0;
			ff_reg_frequency_count_f1	<= 'd0;
			ff_reg_noise_frequency_f1	<= 'd0;

			reg_timer1_channel			<= 4'd0;
			reg_timer1_oneshot			<= 1'b0;
			reg_timer1_enable			<= 1'b0;
			reg_timer1_clear			<= 1'b0;

			reg_timer2_channel			<= 4'd0;
			reg_timer2_oneshot			<= 1'b0;
			reg_timer2_enable			<= 1'b0;
			reg_timer2_clear			<= 1'b0;
		end
		else if( wrreq ) begin
			if( w_scc_en ) begin
				case( address[7:0] )
				8'h80:		reg_frequency_count_a0[ 7:0]	<= wrdata;
				8'h81:		reg_frequency_count_a0[11:8]	<= wrdata[3:0];
				8'h82:		reg_frequency_count_b0[ 7:0]	<= wrdata;
				8'h83:		reg_frequency_count_b0[11:8]	<= wrdata[3:0];
				8'h84:		reg_frequency_count_c0[ 7:0]	<= wrdata;
				8'h85:		reg_frequency_count_c0[11:8]	<= wrdata[3:0];
				8'h86:		reg_frequency_count_d0[ 7:0]	<= wrdata;
				8'h87:		reg_frequency_count_d0[11:8]	<= wrdata[3:0];
				8'h88:		ff_reg_frequency_count_d1[ 7:0]	<= wrdata;
				8'h89:		ff_reg_frequency_count_d1[11:8]	<= wrdata[3:0];
				8'h8A:		reg_volume_a0					<= wrdata[3:0];
				8'h8B:		reg_volume_b0					<= wrdata[3:0];
				8'h8C:		reg_volume_c0					<= wrdata[3:0];
				8'h8D:		reg_volume_d0					<= wrdata[3:0];
				8'h8E:		ff_reg_volume_d1				<= wrdata[3:0];
				8'h8F:
					begin
						reg_enable_a0		<= { wrdata[0], wrdata[0] };
						reg_enable_b0		<= { wrdata[1], wrdata[1] };
						reg_enable_c0		<= { wrdata[2], wrdata[2] };
						reg_enable_d0		<= { wrdata[3], wrdata[3] };
						ff_reg_enable_d1	<= { wrdata[4], wrdata[4] };
					end
				endcase
			end
			else if( w_scci_en ) begin
				case( address[7:0] )
				8'hA0:		reg_frequency_count_a0[ 7:0]	<= wrdata;
				8'hA1:		reg_frequency_count_a0[11:8]	<= wrdata[3:0];
				8'hA2:		reg_frequency_count_b0[ 7:0]	<= wrdata;
				8'hA3:		reg_frequency_count_b0[11:8]	<= wrdata[3:0];
				8'hA4:		reg_frequency_count_c0[ 7:0]	<= wrdata;
				8'hA5:		reg_frequency_count_c0[11:8]	<= wrdata[3:0];
				8'hA6:		reg_frequency_count_d0[ 7:0]	<= wrdata;
				8'hA7:		reg_frequency_count_d0[11:8]	<= wrdata[3:0];
				8'hA8:		ff_reg_frequency_count_d1[ 7:0]	<= wrdata;
				8'hA9:		ff_reg_frequency_count_d1[11:8]	<= wrdata[3:0];
				8'hAA:		reg_volume_a0					<= wrdata[3:0];
				8'hAB:		reg_volume_b0					<= wrdata[3:0];
				8'hAC:		reg_volume_c0					<= wrdata[3:0];
				8'hAD:		reg_volume_d0					<= wrdata[3:0];
				8'hAE:		ff_reg_volume_d1				<= wrdata[3:0];
				8'hAF:
					begin
						reg_enable_a0		<= { wrdata[0], wrdata[0] };
						reg_enable_b0		<= { wrdata[1], wrdata[1] };
						reg_enable_c0		<= { wrdata[2], wrdata[2] };
						reg_enable_d0		<= { wrdata[3], wrdata[3] };
						ff_reg_enable_d1	<= { wrdata[4], wrdata[4] };
					end
				endcase
			end
			else if( w_wts_en && (address[12:8] == 5'b01110) ) begin
				case( address[7:0] )
				8'h00:		reg_frequency_count_a0[ 7:0]	<= wrdata;
				8'h01:		reg_frequency_count_a0[11:8]	<= wrdata[3:0];
				8'h02:		reg_volume_a0					<= wrdata[3:0];
				8'h03:		reg_enable_a0					<= wrdata[1:0];
				8'h04:		reg_ar_a0[7:0]					<= wrdata;
				8'h05:		reg_ar_a0[15:8]					<= wrdata;
				8'h06:		reg_dr_a0[7:0]					<= wrdata;
				8'h07:		reg_dr_a0[15:8]					<= wrdata;
				8'h08:		reg_sr_a0[7:0]					<= wrdata;
				8'h09:		reg_sr_a0[15:8]					<= wrdata;
				8'h0A:		reg_rr_a0[7:0]					<= wrdata;
				8'h0B:		reg_rr_a0[15:8]					<= wrdata;
				8'h0C:		reg_sl_a0						<= wrdata;
				8'h0D:
					begin
						reg_noise_enable_a0					<= wrdata[7];
						reg_noise_frequency_a0				<= wrdata[4:0];
					end
				8'h0E:		reg_wave_length_a0				<= wrdata[1:0];
				8'h0F:
					begin
						ch_a0_key_on						<= wrdata[0];
						ch_a0_key_release					<= wrdata[1];
						ch_a0_key_off						<= wrdata[2];
					end

				8'h10:		reg_frequency_count_b0[ 7:0]	<= wrdata;
				8'h11:		reg_frequency_count_b0[11:8]	<= wrdata[3:0];
				8'h12:		reg_volume_b0					<= wrdata[3:0];
				8'h13:		reg_enable_b0					<= wrdata[1:0];
				8'h14:		reg_ar_b0[7:0]					<= wrdata;
				8'h15:		reg_ar_b0[15:8]					<= wrdata;
				8'h16:		reg_dr_b0[7:0]					<= wrdata;
				8'h17:		reg_dr_b0[15:8]					<= wrdata;
				8'h18:		reg_sr_b0[7:0]					<= wrdata;
				8'h19:		reg_sr_b0[15:8]					<= wrdata;
				8'h1A:		reg_rr_b0[7:0]					<= wrdata;
				8'h1B:		reg_rr_b0[15:8]					<= wrdata;
				8'h1C:		reg_sl_b0						<= wrdata;
				8'h1D:
					begin
						reg_noise_enable_b0					<= wrdata[7];
						reg_noise_frequency_b0				<= wrdata[4:0];
					end
				8'h1E:		reg_wave_length_b0				<= wrdata[1:0];
				8'h1F:
					begin
						ch_b0_key_on						<= wrdata[0];
						ch_b0_key_release					<= wrdata[1];
						ch_b0_key_off						<= wrdata[2];
					end

				8'h20:		reg_frequency_count_c0[ 7:0]	<= wrdata;
				8'h21:		reg_frequency_count_c0[11:8]	<= wrdata[3:0];
				8'h22:		reg_volume_c0					<= wrdata[3:0];
				8'h23:		reg_enable_c0					<= wrdata[1:0];
				8'h24:		reg_ar_c0[7:0]					<= wrdata;
				8'h25:		reg_ar_c0[15:8]					<= wrdata;
				8'h26:		reg_dr_c0[7:0]					<= wrdata;
				8'h27:		reg_dr_c0[15:8]					<= wrdata;
				8'h28:		reg_sr_c0[7:0]					<= wrdata;
				8'h29:		reg_sr_c0[15:8]					<= wrdata;
				8'h2A:		reg_rr_c0[7:0]					<= wrdata;
				8'h2B:		reg_rr_c0[15:8]					<= wrdata;
				8'h2C:		reg_sl_c0						<= wrdata;
				8'h2D:
					begin
						reg_noise_enable_c0					<= wrdata[7];
						reg_noise_frequency_c0				<= wrdata[4:0];
					end
				8'h2E:		reg_wave_length_c0				<= wrdata[1:0];
				8'h2F:
					begin
						ch_c0_key_on						<= wrdata[0];
						ch_c0_key_release					<= wrdata[1];
						ch_c0_key_off						<= wrdata[2];
					end

				8'h30:		reg_frequency_count_d0[ 7:0]	<= wrdata;
				8'h31:		reg_frequency_count_d0[11:8]	<= wrdata[3:0];
				8'h32:		reg_volume_d0					<= wrdata[3:0];
				8'h33:		reg_enable_d0					<= wrdata[1:0];
				8'h34:		reg_dr_d0[7:0]					<= wrdata;
				8'h35:		reg_dr_d0[15:8]					<= wrdata;
				8'h36:		reg_dr_d0[7:0]					<= wrdata;
				8'h37:		reg_dr_d0[15:8]					<= wrdata;
				8'h38:		reg_sr_d0[7:0]					<= wrdata;
				8'h39:		reg_sr_d0[15:8]					<= wrdata;
				8'h3A:		reg_rr_d0[7:0]					<= wrdata;
				8'h3B:		reg_rr_d0[15:8]					<= wrdata;
				8'h3C:		reg_sl_d0						<= wrdata;
				8'h3D:
					begin
						reg_noise_enable_d0					<= wrdata[7];
						reg_noise_frequency_d0				<= wrdata[4:0];
					end
				8'h3E:		reg_wave_length_d0				<= wrdata[1:0];
				8'h3F:
					begin
						ch_d0_key_on						<= wrdata[0];
						ch_d0_key_release					<= wrdata[1];
						ch_d0_key_off						<= wrdata[2];
					end

				8'h40:		reg_frequency_count_e0[ 7:0]	<= wrdata;
				8'h41:		reg_frequency_count_e0[11:8]	<= wrdata[3:0];
				8'h42:		reg_volume_e0					<= wrdata[3:0];
				8'h43:		reg_enable_e0					<= wrdata[1:0];
				8'h44:		reg_ar_e0[7:0]					<= wrdata;
				8'h45:		reg_ar_e0[15:8]					<= wrdata;
				8'h46:		reg_dr_e0[7:0]					<= wrdata;
				8'h47:		reg_dr_e0[15:8]					<= wrdata;
				8'h48:		reg_sr_e0[7:0]					<= wrdata;
				8'h49:		reg_sr_e0[15:8]					<= wrdata;
				8'h4A:		reg_rr_e0[7:0]					<= wrdata;
				8'h4B:		reg_rr_e0[15:8]					<= wrdata;
				8'h4C:		reg_sl_e0						<= wrdata;
				8'h4D:
					begin
						reg_noise_enable_e0					<= wrdata[7];
						reg_noise_frequency_e0				<= wrdata[4:0];
					end
				8'h4E:		reg_wave_length_e0				<= wrdata[1:0];
				8'h4F:
					begin
						ch_e0_key_on						<= wrdata[0];
						ch_e0_key_release					<= wrdata[1];
						ch_e0_key_off						<= wrdata[2];
					end

				8'h50:		reg_frequency_count_f0[ 7:0]	<= wrdata;
				8'h51:		reg_frequency_count_f0[11:8]	<= wrdata[3:0];
				8'h52:		reg_volume_f0					<= wrdata[3:0];
				8'h53:		reg_enable_f0					<= wrdata[1:0];
				8'h54:		reg_ar_f0[7:0]					<= wrdata;
				8'h55:		reg_ar_f0[15:8]					<= wrdata;
				8'h56:		reg_dr_f0[7:0]					<= wrdata;
				8'h57:		reg_dr_f0[15:8]					<= wrdata;
				8'h58:		reg_sr_f0[7:0]					<= wrdata;
				8'h59:		reg_sr_f0[15:8]					<= wrdata;
				8'h5A:		reg_rr_f0[7:0]					<= wrdata;
				8'h5B:		reg_rr_f0[15:8]					<= wrdata;
				8'h5C:		reg_sl_f0						<= wrdata;
				8'h5D:
					begin
						reg_noise_enable_f0					<= wrdata[7];
						reg_noise_frequency_f0				<= wrdata[4:0];
					end
				8'h5E:		reg_wave_length_f0				<= wrdata[1:0];
				8'h5F:
					begin
						ch_f0_key_on						<= wrdata[0];
						ch_f0_key_release					<= wrdata[1];
						ch_f0_key_off						<= wrdata[2];
					end

				8'h60:		ff_reg_frequency_count_a1[ 7:0]	<= wrdata;
				8'h61:		ff_reg_frequency_count_a1[11:8]	<= wrdata[3:0];
				8'h62:		ff_reg_volume_a1				<= wrdata[3:0];
				8'h63:
					begin
						ff_reg_enable_a1					<= wrdata[1:0];
						ff_reg_clone_frequency_a1			<= wrdata[3];
						ff_reg_clone_adsr_a1				<= wrdata[4];
						ff_reg_clone_noise_a1				<= wrdata[5];
						ff_reg_clone_wave_a1				<= wrdata[6];
						ff_reg_clone_key_a1					<= wrdata[7];
					end
				8'h64:		ff_reg_ar_a1[7:0]				<= wrdata;
				8'h65:		ff_reg_ar_a1[15:8]				<= wrdata;
				8'h66:		ff_reg_dr_a1[7:0]				<= wrdata;
				8'h67:		ff_reg_dr_a1[15:8]				<= wrdata;
				8'h68:		ff_reg_sr_a1[7:0]				<= wrdata;
				8'h69:		ff_reg_sr_a1[15:8]				<= wrdata;
				8'h6A:		ff_reg_rr_a1[7:0]				<= wrdata;
				8'h6B:		ff_reg_rr_a1[15:8]				<= wrdata;
				8'h6C:		ff_reg_sl_a1					<= wrdata;
				8'h6D:
					begin
						ff_reg_noise_enable_a1				<= wrdata[7];
						ff_reg_noise_frequency_a1			<= wrdata[4:0];
					end
				8'h6E:		ff_reg_wave_length_a1			<= wrdata[1:0];
				8'h6F:
					begin
						ff_ch_a1_key_on						<= wrdata[0];
						ff_ch_a1_key_release				<= wrdata[1];
						ff_ch_a1_key_off					<= wrdata[2];
					end

				8'h70:		ff_reg_frequency_count_b1[ 7:0]	<= wrdata;
				8'h71:		ff_reg_frequency_count_b1[11:8]	<= wrdata[3:0];
				8'h72:		ff_reg_volume_b1				<= wrdata[3:0];
				8'h73:
					begin
						ff_reg_enable_b1					<= wrdata[1:0];
						ff_reg_clone_frequency_b1			<= wrdata[3];
						ff_reg_clone_adsr_b1				<= wrdata[4];
						ff_reg_clone_noise_b1				<= wrdata[5];
						ff_reg_clone_wave_b1				<= wrdata[6];
						ff_reg_clone_key_b1					<= wrdata[7];
					end
				8'h74:		ff_reg_ar_b1[7:0]				<= wrdata;
				8'h75:		ff_reg_ar_b1[15:8]				<= wrdata;
				8'h76:		ff_reg_dr_b1[7:0]				<= wrdata;
				8'h77:		ff_reg_dr_b1[15:8]				<= wrdata;
				8'h78:		ff_reg_sr_b1[7:0]				<= wrdata;
				8'h79:		ff_reg_sr_b1[15:8]				<= wrdata;
				8'h7A:		ff_reg_rr_b1[7:0]				<= wrdata;
				8'h7B:		ff_reg_rr_b1[15:8]				<= wrdata;
				8'h7C:		ff_reg_sl_b1					<= wrdata;
				8'h7D:
					begin
						ff_reg_noise_enable_b1				<= wrdata[7];
						ff_reg_noise_frequency_b1			<= wrdata[4:0];
					end
				8'h7E:		ff_reg_wave_length_b1			<= wrdata[1:0];
				8'h7F:
					begin
						ff_ch_b1_key_on						<= wrdata[0];
						ff_ch_b1_key_release				<= wrdata[1];
						ff_ch_b1_key_off					<= wrdata[2];
					end

				8'h80:		ff_reg_frequency_count_c1[ 7:0]	<= wrdata;
				8'h81:		ff_reg_frequency_count_c1[11:8]	<= wrdata[3:0];
				8'h82:		ff_reg_volume_c1				<= wrdata[3:0];
				8'h83:
					begin
						ff_reg_enable_c1					<= wrdata[1:0];
						ff_reg_clone_frequency_c1			<= wrdata[3];
						ff_reg_clone_adsr_c1				<= wrdata[4];
						ff_reg_clone_noise_c1				<= wrdata[5];
						ff_reg_clone_wave_c1				<= wrdata[6];
						ff_reg_clone_key_c1					<= wrdata[7];
					end
				8'h84:		ff_reg_ar_c1[7:0]				<= wrdata;
				8'h85:		ff_reg_ar_c1[15:8]				<= wrdata;
				8'h86:		ff_reg_dr_c1[7:0]				<= wrdata;
				8'h87:		ff_reg_dr_c1[15:8]				<= wrdata;
				8'h88:		ff_reg_sr_c1[7:0]				<= wrdata;
				8'h89:		ff_reg_sr_c1[15:8]				<= wrdata;
				8'h8A:		ff_reg_rr_c1[7:0]				<= wrdata;
				8'h8B:		ff_reg_rr_c1[15:8]				<= wrdata;
				8'h8C:		ff_reg_sl_c1					<= wrdata;
				8'h8D:
					begin
						ff_reg_noise_enable_c1				<= wrdata[7];
						ff_reg_noise_frequency_c1			<= wrdata[4:0];
					end
				8'h8E:		ff_reg_wave_length_c1			<= wrdata[1:0];
				8'h8F:
					begin
						ff_ch_c1_key_on						<= wrdata[0];
						ff_ch_c1_key_release				<= wrdata[1];
						ff_ch_c1_key_off					<= wrdata[2];
					end

				8'h90:		ff_reg_frequency_count_d1[ 7:0]	<= wrdata;
				8'h91:		ff_reg_frequency_count_d1[11:8]	<= wrdata[3:0];
				8'h92:		ff_reg_volume_d1				<= wrdata[3:0];
				8'h93:
					begin
						ff_reg_enable_d1					<= wrdata[1:0];
						ff_reg_clone_frequency_d1			<= wrdata[3];
						ff_reg_clone_adsr_d1				<= wrdata[4];
						ff_reg_clone_noise_d1				<= wrdata[5];
						ff_reg_clone_wave_d1				<= wrdata[6];
						ff_reg_clone_key_d1					<= wrdata[7];
					end
				8'h94:		ff_reg_ar_d1[7:0]				<= wrdata;
				8'h95:		ff_reg_ar_d1[15:8]				<= wrdata;
				8'h96:		ff_reg_dr_d1[7:0]				<= wrdata;
				8'h97:		ff_reg_dr_d1[15:8]				<= wrdata;
				8'h98:		ff_reg_sr_d1[7:0]				<= wrdata;
				8'h99:		ff_reg_sr_d1[15:8]				<= wrdata;
				8'h9A:		ff_reg_rr_d1[7:0]				<= wrdata;
				8'h9B:		ff_reg_rr_d1[15:8]				<= wrdata;
				8'h9C:		ff_reg_sl_d1					<= wrdata;
				8'h9D:
					begin
						ff_reg_noise_enable_d1				<= wrdata[7];
						ff_reg_noise_frequency_d1			<= wrdata[4:0];
					end
				8'h9E:		ff_reg_wave_length_d1			<= wrdata[1:0];
				8'h9F:
					begin
						ff_ch_d1_key_on						<= wrdata[0];
						ff_ch_d1_key_release				<= wrdata[1];
						ff_ch_d1_key_off					<= wrdata[2];
					end

				8'hA0:		ff_reg_frequency_count_e1[ 7:0]	<= wrdata;
				8'hA1:		ff_reg_frequency_count_e1[11:8]	<= wrdata[3:0];
				8'hA2:		ff_reg_volume_e1				<= wrdata[3:0];
				8'hA3:
					begin
						ff_reg_enable_e1					<= wrdata[1:0];
						ff_reg_clone_frequency_e1			<= wrdata[3];
						ff_reg_clone_adsr_e1				<= wrdata[4];
						ff_reg_clone_noise_e1				<= wrdata[5];
						ff_reg_clone_wave_e1				<= wrdata[6];
						ff_reg_clone_key_e1					<= wrdata[7];
					end
				8'hA4:		ff_reg_ar_e1[7:0]				<= wrdata;
				8'hA5:		ff_reg_ar_e1[15:8]				<= wrdata;
				8'hA6:		ff_reg_dr_e1[7:0]				<= wrdata;
				8'hA7:		ff_reg_dr_e1[15:8]				<= wrdata;
				8'hA8:		ff_reg_sr_e1[7:0]				<= wrdata;
				8'hA9:		ff_reg_sr_e1[15:8]				<= wrdata;
				8'hAA:		ff_reg_rr_e1[7:0]				<= wrdata;
				8'hAB:		ff_reg_rr_e1[15:8]				<= wrdata;
				8'hAC:		ff_reg_sl_e1					<= wrdata;
				8'hAD:
					begin
						ff_reg_noise_enable_e1				<= wrdata[7];
						ff_reg_noise_frequency_e1			<= wrdata[4:0];
					end
				8'hAE:		ff_reg_wave_length_e1			<= wrdata[1:0];
				8'hAF:
					begin
						ff_ch_e1_key_on						<= wrdata[0];
						ff_ch_e1_key_release				<= wrdata[1];
						ff_ch_e1_key_off					<= wrdata[2];
					end

				8'hB0:		ff_reg_frequency_count_f1[ 7:0]	<= wrdata;
				8'hB1:		ff_reg_frequency_count_f1[11:8]	<= wrdata[3:0];
				8'hB2:		ff_reg_volume_f1				<= wrdata[3:0];
				8'hB3:
					begin
						ff_reg_enable_f1					<= wrdata[1:0];
						ff_reg_clone_frequency_f1			<= wrdata[3];
						ff_reg_clone_adsr_f1				<= wrdata[4];
						ff_reg_clone_noise_f1				<= wrdata[5];
						ff_reg_clone_wave_f1				<= wrdata[6];
						ff_reg_clone_key_f1					<= wrdata[7];
					end
				8'hB4:		ff_reg_ar_f1[7:0]				<= wrdata;
				8'hB5:		ff_reg_ar_f1[15:8]				<= wrdata;
				8'hB6:		ff_reg_dr_f1[7:0]				<= wrdata;
				8'hB7:		ff_reg_dr_f1[15:8]				<= wrdata;
				8'hB8:		ff_reg_sr_f1[7:0]				<= wrdata;
				8'hB9:		ff_reg_sr_f1[15:8]				<= wrdata;
				8'hBA:		ff_reg_rr_f1[7:0]				<= wrdata;
				8'hBB:		ff_reg_rr_f1[15:8]				<= wrdata;
				8'hBC:		ff_reg_sl_f1					<= wrdata;
				8'hBD:
					begin
						ff_reg_noise_enable_f1				<= wrdata[7];
						ff_reg_noise_frequency_f1			<= wrdata[4:0];
					end
				8'hBE:		ff_reg_wave_length_f1			<= wrdata[1:0];
				8'hBF:
					begin
						ff_ch_f1_key_on						<= wrdata[0];
						ff_ch_f1_key_release				<= wrdata[1];
						ff_ch_f1_key_off					<= wrdata[2];
					end

				8'hF0:
					begin
						reg_timer1_channel					<= wrdata[3:0];
						reg_timer1_oneshot					<= wrdata[6];
						reg_timer1_enable					<= wrdata[7];
					end
				8'hF2:
					begin
						reg_timer2_channel					<= wrdata[3:0];
						reg_timer2_oneshot					<= wrdata[6];
						reg_timer2_enable					<= wrdata[7];
					end
				endcase
			end
		end
		else if( rdreq ) begin
			if( w_wts_en && (address[12:8] == 5'b01110) ) begin
				if( address[7:0] == 8'hF1 ) begin
					reg_timer1_clear	<= 1'b1;
					reg_timer1_enable	<= reg_timer1_oneshot ? 1'b0 : reg_timer1_enable;
				end
				else if( address[7:0] == 8'hF3 ) begin
					reg_timer2_clear	<= 1'b1;
					reg_timer2_enable	<= reg_timer2_oneshot ? 1'b0 : reg_timer2_enable;
				end
			end
		end
		else begin
			reg_timer1_clear			<= 1'b0;
			reg_timer2_clear			<= 1'b0;

			ch_a0_key_on				<= 1'b0;
			ch_a0_key_release			<= 1'b0;
			ch_a0_key_off				<= 1'b0;

			ch_b0_key_on				<= 1'b0;
			ch_b0_key_release			<= 1'b0;
			ch_b0_key_off				<= 1'b0;

			ch_c0_key_on				<= 1'b0;
			ch_c0_key_release			<= 1'b0;
			ch_c0_key_off				<= 1'b0;

			ch_d0_key_on				<= 1'b0;
			ch_d0_key_release			<= 1'b0;
			ch_d0_key_off				<= 1'b0;

			ch_e0_key_on				<= 1'b0;
			ch_e0_key_release			<= 1'b0;
			ch_e0_key_off				<= 1'b0;

			ch_f0_key_on				<= 1'b0;
			ch_f0_key_release			<= 1'b0;
			ch_f0_key_off				<= 1'b0;

			ff_ch_a1_key_on				<= 1'b0;
			ff_ch_a1_key_release		<= 1'b0;
			ff_ch_a1_key_off			<= 1'b0;

			ff_ch_b1_key_on				<= 1'b0;
			ff_ch_b1_key_release		<= 1'b0;
			ff_ch_b1_key_off			<= 1'b0;

			ff_ch_c1_key_on				<= 1'b0;
			ff_ch_c1_key_release		<= 1'b0;
			ff_ch_c1_key_off			<= 1'b0;

			ff_ch_d1_key_on				<= 1'b0;
			ff_ch_d1_key_release		<= 1'b0;
			ff_ch_d1_key_off			<= 1'b0;

			ff_ch_e1_key_on				<= 1'b0;
			ff_ch_e1_key_release		<= 1'b0;
			ff_ch_e1_key_off			<= 1'b0;

			ff_ch_f1_key_on				<= 1'b0;
			ff_ch_f1_key_release		<= 1'b0;
			ff_ch_f1_key_off			<= 1'b0;
		end
	end

	assign ch_a1_key_on				= ff_reg_clone_key_a1 ? ch_a0_key_on : ff_ch_a1_key_on;
	assign ch_a1_key_release		= ff_reg_clone_key_a1 ? ch_a0_key_release : ff_ch_a1_key_release;
	assign ch_a1_key_off			= ff_reg_clone_key_a1 ? ch_a0_key_off : ff_ch_a1_key_off;

	assign ch_b1_key_on				= ff_reg_clone_key_b1 ? ch_b0_key_on : ff_ch_b1_key_on;
	assign ch_b1_key_release		= ff_reg_clone_key_b1 ? ch_b0_key_release : ff_ch_b1_key_release;
	assign ch_b1_key_off			= ff_reg_clone_key_b1 ? ch_b0_key_off : ff_ch_b1_key_off;

	assign ch_c1_key_on				= ff_reg_clone_key_c1 ? ch_c0_key_on : ff_ch_c1_key_on;
	assign ch_c1_key_release		= ff_reg_clone_key_c1 ? ch_c0_key_release : ff_ch_c1_key_release;
	assign ch_c1_key_off			= ff_reg_clone_key_c1 ? ch_c0_key_off : ff_ch_c1_key_off;

	assign ch_d1_key_on				= ff_reg_clone_key_d1 ? ch_d0_key_on : ff_ch_d1_key_on;
	assign ch_d1_key_release		= ff_reg_clone_key_d1 ? ch_d0_key_release : ff_ch_d1_key_release;
	assign ch_d1_key_off			= ff_reg_clone_key_d1 ? ch_d0_key_off : ff_ch_d1_key_off;

	assign ch_e1_key_on				= ff_reg_clone_key_e1 ? ch_e0_key_on : ff_ch_e1_key_on;
	assign ch_e1_key_release		= ff_reg_clone_key_e1 ? ch_e0_key_release : ff_ch_e1_key_release;
	assign ch_e1_key_off			= ff_reg_clone_key_e1 ? ch_e0_key_off : ff_ch_e1_key_off;

	assign ch_f1_key_on				= ff_reg_clone_key_f1 ? ch_f0_key_on : ff_ch_f1_key_on;
	assign ch_f1_key_release		= ff_reg_clone_key_f1 ? ch_f0_key_release : ff_ch_f1_key_release;
	assign ch_f1_key_off			= ff_reg_clone_key_f1 ? ch_f0_key_off : ff_ch_f1_key_off;

	assign reg_volume_a1			= ff_reg_volume_a1;
	assign reg_enable_a1			= ff_reg_enable_a1;
	assign reg_noise_enable_a1		= ff_reg_noise_enable_a1;
	assign reg_ar_a1				= ff_reg_clone_adsr_a1 ? reg_ar_a0 : ff_reg_ar_a1;
	assign reg_dr_a1				= ff_reg_clone_adsr_a1 ? reg_dr_a0 : ff_reg_dr_a1;
	assign reg_sr_a1				= ff_reg_clone_adsr_a1 ? reg_sr_a0 : ff_reg_sr_a1;
	assign reg_rr_a1				= ff_reg_clone_adsr_a1 ? reg_rr_a0 : ff_reg_rr_a1;
	assign reg_sl_a1				= ff_reg_clone_adsr_a1 ? reg_sl_a0 : ff_reg_sl_a1;
	assign reg_wave_length_a1		= ff_reg_clone_wave_a1 ? reg_wave_length_a0 : ff_reg_wave_length_a1;
	assign reg_frequency_count_a1	= ff_reg_clone_frequency_a1 ? reg_frequency_count_a0 : ff_reg_frequency_count_a1;
	assign reg_noise_frequency_a1	= ff_reg_clone_noise_a1 ? reg_noise_frequency_a0 : ff_reg_noise_frequency_a1;

	assign reg_volume_b1			= ff_reg_volume_b1;
	assign reg_enable_b1			= ff_reg_enable_b1;
	assign reg_noise_enable_b1		= ff_reg_noise_enable_b1;
	assign reg_ar_b1				= ff_reg_clone_adsr_b1 ? reg_ar_b0 : ff_reg_ar_b1;
	assign reg_dr_b1				= ff_reg_clone_adsr_b1 ? reg_dr_b0 : ff_reg_dr_b1;
	assign reg_sr_b1				= ff_reg_clone_adsr_b1 ? reg_sr_b0 : ff_reg_sr_b1;
	assign reg_rr_b1				= ff_reg_clone_adsr_b1 ? reg_rr_b0 : ff_reg_rr_b1;
	assign reg_sl_b1				= ff_reg_clone_adsr_b1 ? reg_sl_b0 : ff_reg_sl_b1;
	assign reg_wave_length_b1		= ff_reg_clone_wave_b1 ? reg_wave_length_b0 : ff_reg_wave_length_b1;
	assign reg_frequency_count_b1	= ff_reg_clone_frequency_b1 ? reg_frequency_count_b0 : ff_reg_frequency_count_b1;
	assign reg_noise_frequency_b1	= ff_reg_clone_noise_b1 ? reg_noise_frequency_b0 : ff_reg_noise_frequency_b1;

	assign reg_volume_c1			= ff_reg_volume_c1;
	assign reg_enable_c1			= ff_reg_enable_c1;
	assign reg_noise_enable_c1		= ff_reg_noise_enable_c1;
	assign reg_ar_c1				= ff_reg_clone_adsr_c1 ? reg_ar_c0 : ff_reg_ar_c1;
	assign reg_dr_c1				= ff_reg_clone_adsr_c1 ? reg_dr_c0 : ff_reg_dr_c1;
	assign reg_sr_c1				= ff_reg_clone_adsr_c1 ? reg_sr_c0 : ff_reg_sr_c1;
	assign reg_rr_c1				= ff_reg_clone_adsr_c1 ? reg_rr_c0 : ff_reg_rr_c1;
	assign reg_sl_c1				= ff_reg_clone_adsr_c1 ? reg_sl_c0 : ff_reg_sl_c1;
	assign reg_wave_length_c1		= ff_reg_clone_wave_c1 ? reg_wave_length_c0 : ff_reg_wave_length_c1;
	assign reg_frequency_count_c1	= ff_reg_clone_frequency_c1 ? reg_frequency_count_c0 : ff_reg_frequency_count_c1;
	assign reg_noise_frequency_c1	= ff_reg_clone_noise_c1 ? reg_noise_frequency_c0 : ff_reg_noise_frequency_c1;

	assign reg_volume_d1			= ff_reg_volume_d1;
	assign reg_enable_d1			= ff_reg_enable_d1;
	assign reg_noise_enable_d1		= ff_reg_noise_enable_d1;
	assign reg_ar_d1				= ff_reg_clone_adsr_d1 ? reg_ar_d0 : ff_reg_ar_d1;
	assign reg_dr_d1				= ff_reg_clone_adsr_d1 ? reg_dr_d0 : ff_reg_dr_d1;
	assign reg_sr_d1				= ff_reg_clone_adsr_d1 ? reg_sr_d0 : ff_reg_sr_d1;
	assign reg_rr_d1				= ff_reg_clone_adsr_d1 ? reg_rr_d0 : ff_reg_rr_d1;
	assign reg_sl_d1				= ff_reg_clone_adsr_d1 ? reg_sl_d0 : ff_reg_sl_d1;
	assign reg_wave_length_d1		= ff_reg_clone_wave_d1 ? reg_wave_length_d0 : ff_reg_wave_length_d1;
	assign reg_frequency_count_d1	= ff_reg_clone_frequency_d1 ? reg_frequency_count_d0 : ff_reg_frequency_count_d1;
	assign reg_noise_frequency_d1	= ff_reg_clone_noise_d1 ? reg_noise_frequency_d0 : ff_reg_noise_frequency_d1;

	assign reg_volume_e1			= ff_reg_volume_e1;
	assign reg_enable_e1			= ff_reg_enable_e1;
	assign reg_noise_enable_e1		= ff_reg_noise_enable_e1;
	assign reg_ar_e1				= ff_reg_clone_adsr_e1 ? reg_ar_e0 : ff_reg_ar_e1;
	assign reg_dr_e1				= ff_reg_clone_adsr_e1 ? reg_dr_e0 : ff_reg_dr_e1;
	assign reg_sr_e1				= ff_reg_clone_adsr_e1 ? reg_sr_e0 : ff_reg_sr_e1;
	assign reg_rr_e1				= ff_reg_clone_adsr_e1 ? reg_rr_e0 : ff_reg_rr_e1;
	assign reg_sl_e1				= ff_reg_clone_adsr_e1 ? reg_sl_e0 : ff_reg_sl_e1;
	assign reg_wave_length_e1		= ff_reg_clone_wave_e1 ? reg_wave_length_e0 : ff_reg_wave_length_e1;
	assign reg_frequency_count_e1	= ff_reg_clone_frequency_e1 ? reg_frequency_count_e0 : ff_reg_frequency_count_e1;
	assign reg_noise_frequency_e1	= ff_reg_clone_noise_e1 ? reg_noise_frequency_e0 : ff_reg_noise_frequency_e1;

	assign reg_volume_f1			= ff_reg_volume_f1;
	assign reg_enable_f1			= ff_reg_enable_f1;
	assign reg_noise_enable_f1		= ff_reg_noise_enable_f1;
	assign reg_ar_f1				= ff_reg_clone_adsr_f1 ? reg_ar_f0 : ff_reg_ar_f1;
	assign reg_dr_f1				= ff_reg_clone_adsr_f1 ? reg_dr_f0 : ff_reg_dr_f1;
	assign reg_sr_f1				= ff_reg_clone_adsr_f1 ? reg_sr_f0 : ff_reg_sr_f1;
	assign reg_rr_f1				= ff_reg_clone_adsr_f1 ? reg_rr_f0 : ff_reg_rr_f1;
	assign reg_sl_f1				= ff_reg_clone_adsr_f1 ? reg_sl_f0 : ff_reg_sl_f1;
	assign reg_wave_length_f1		= ff_reg_clone_wave_f1 ? reg_wave_length_f0 : ff_reg_wave_length_f1;
	assign reg_frequency_count_f1	= ff_reg_clone_frequency_f1 ? reg_frequency_count_f0 : ff_reg_frequency_count_f1;
	assign reg_noise_frequency_f1	= ff_reg_clone_noise_f1 ? reg_noise_frequency_f0 : ff_reg_noise_frequency_f1;

	// External memory address ------------------------------------------------
	assign ext_memory_address	= w_dec_bank0 ? reg_bank0 :
	                         	  w_dec_bank1 ? reg_bank1 :
	                         	  w_dec_bank2 ? reg_bank2 : reg_bank3;

	// Read registers ---------------------------------------------------------
	always @( posedge clk ) begin
		if( sram_q_en ) begin
			ff_sram_q <= sram_q;
		end
		else begin
			//	hold
		end
	end

	assign rddata				= ( w_wts_en && (address[10:0] == 11'hEF1) ) ? timer1_status :
								  ( w_wts_en && (address[10:0] == 11'hEF3) ) ? timer2_status :
								  ff_sram_q;

endmodule
