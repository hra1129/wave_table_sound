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
	input		[14:0]	address,
	input		[7:0]	wrdata,
	output		[7:0]	rddata,

	input		[2:0]	active,
	output reg			ext_memory_nactive,
	output		[20:13]	ext_memory_address,

	output reg			sram_ce0,				//	A0...E0
	output reg			sram_ce1,				//	A1...E1
	output reg	[2:0]	sram_id,				//	A...E
	output reg	[6:0]	sram_a,
	output reg	[7:0]	sram_d,
	output reg			sram_oe,
	output reg			sram_we,
	input		[7:0]	sram_q,
	input				sram_q_en,

	output				adsr_en,
	output reg			reg_scci_enable,

	output				ch0_key_on,
	output				ch0_key_release,
	output				ch0_key_off,

	output				ch1_key_on,
	output				ch1_key_release,
	output				ch1_key_off,

	output		[7:0]	reg_ar0,
	output		[7:0]	reg_dr0,
	output		[7:0]	reg_sr0,
	output		[7:0]	reg_rr0,
	output		[5:0]	reg_sl0,
	output		[1:0]	reg_wave_length0,
	output		[11:0]	reg_frequency_count0,
	output		[3:0]	reg_volume0,
	output		[1:0]	reg_enable0,

	output		[7:0]	reg_ar1,
	output		[7:0]	reg_dr1,
	output		[7:0]	reg_sr1,
	output		[7:0]	reg_rr1,
	output		[5:0]	reg_sl1,
	output		[1:0]	reg_wave_length1,
	output		[11:0]	reg_frequency_count1,
	output		[3:0]	reg_volume1,
	output		[1:0]	reg_enable1,

	output reg			reg_noise_enable_a0,
	output reg	[1:0]	reg_noise_sel_a0,
	output reg			reg_noise_enable_b0,
	output reg	[1:0]	reg_noise_sel_b0,
	output reg			reg_noise_enable_c0,
	output reg	[1:0]	reg_noise_sel_c0,
	output reg			reg_noise_enable_d0,
	output reg	[1:0]	reg_noise_sel_d0,
	output reg			reg_noise_enable_e0,
	output reg	[1:0]	reg_noise_sel_e0,
	output				reg_noise_enable_a1,
	output		[1:0]	reg_noise_sel_a1,
	output				reg_noise_enable_b1,
	output		[1:0]	reg_noise_sel_b1,
	output				reg_noise_enable_c1,
	output		[1:0]	reg_noise_sel_c1,
	output				reg_noise_enable_d1,
	output		[1:0]	reg_noise_sel_d1,
	output				reg_noise_enable_e1,
	output		[1:0]	reg_noise_sel_e1,

	output reg	[4:0]	reg_noise_frequency0,
	output reg	[4:0]	reg_noise_frequency1,
	output reg	[4:0]	reg_noise_frequency2,
	output reg	[4:0]	reg_noise_frequency3,

	output reg			reg_timer1_enable,
	output reg	[3:0]	reg_timer1_channel,
	output reg			reg_timer1_clear,
	input		[7:0]	timer1_status,

	output reg			reg_timer2_enable,
	output reg	[3:0]	reg_timer2_channel,
	output reg			reg_timer2_clear,
	input		[7:0]	timer2_status,

	output				reg_wave_reset,
	output				clear_counter_a0,
	output				clear_counter_b0,
	output				clear_counter_c0,
	output				clear_counter_d0,
	output				clear_counter_e0,
	output				clear_counter_a1,
	output				clear_counter_b1,
	output				clear_counter_c1,
	output				clear_counter_d1,
	output				clear_counter_e1
);
	reg		[7:0]	reg_bank0;
	reg		[7:0]	reg_bank1;
	reg		[7:0]	reg_bank2;
	reg		[7:0]	reg_bank3;

	reg				reg_timer1_oneshot;
	reg				reg_timer2_oneshot;

	reg				reg_wts_enable;
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

	reg		[2:0]	ff_ch0_key;
	reg				ff_ch0_key_on;
	reg				ff_ch0_key_release;
	reg				ff_ch0_key_off;

	reg		[2:0]	ff_ch1_key;
	reg				ff_ch1_key_on;
	reg				ff_ch1_key_release;
	reg				ff_ch1_key_off;

	wire		[7:0]	w_ar0;
	wire		[7:0]	w_dr0;
	wire		[7:0]	w_sr0;
	wire		[7:0]	w_rr0;
	wire		[5:0]	w_sl0;

	wire		[7:0]	w_ar1;
	wire		[7:0]	w_dr1;
	wire		[7:0]	w_sr1;
	wire		[7:0]	w_rr1;
	wire		[5:0]	w_sl1;

	reg		[7:0]	ff_reg_ar_a0;
	reg		[7:0]	ff_reg_dr_a0;
	reg		[7:0]	ff_reg_sr_a0;
	reg		[7:0]	ff_reg_rr_a0;
	reg		[5:0]	ff_reg_sl_a0;
	reg		[1:0]	ff_reg_wave_length_a0;
	reg		[11:0]	ff_reg_frequency_count_a0;
	reg		[3:0]	ff_reg_volume_a0;
	reg		[1:0]	ff_reg_enable_a0;

	reg		[7:0]	ff_reg_ar_b0;
	reg		[7:0]	ff_reg_dr_b0;
	reg		[7:0]	ff_reg_sr_b0;
	reg		[7:0]	ff_reg_rr_b0;
	reg		[5:0]	ff_reg_sl_b0;
	reg		[1:0]	ff_reg_wave_length_b0;
	reg		[11:0]	ff_reg_frequency_count_b0;
	reg		[3:0]	ff_reg_volume_b0;
	reg		[1:0]	ff_reg_enable_b0;

	reg		[7:0]	ff_reg_ar_c0;
	reg		[7:0]	ff_reg_dr_c0;
	reg		[7:0]	ff_reg_sr_c0;
	reg		[7:0]	ff_reg_rr_c0;
	reg		[5:0]	ff_reg_sl_c0;
	reg		[1:0]	ff_reg_wave_length_c0;
	reg		[11:0]	ff_reg_frequency_count_c0;
	reg		[3:0]	ff_reg_volume_c0;
	reg		[1:0]	ff_reg_enable_c0;

	reg		[7:0]	ff_reg_ar_d0;
	reg		[7:0]	ff_reg_dr_d0;
	reg		[7:0]	ff_reg_sr_d0;
	reg		[7:0]	ff_reg_rr_d0;
	reg		[5:0]	ff_reg_sl_d0;
	reg		[1:0]	ff_reg_wave_length_d0;
	reg		[11:0]	ff_reg_frequency_count_d0;
	reg		[3:0]	ff_reg_volume_d0;
	reg		[1:0]	ff_reg_enable_d0;

	reg		[7:0]	ff_reg_ar_e0;
	reg		[7:0]	ff_reg_dr_e0;
	reg		[7:0]	ff_reg_sr_e0;
	reg		[7:0]	ff_reg_rr_e0;
	reg		[5:0]	ff_reg_sl_e0;
	reg		[1:0]	ff_reg_wave_length_e0;
	reg		[11:0]	ff_reg_frequency_count_e0;
	reg		[3:0]	ff_reg_volume_e0;
	reg		[1:0]	ff_reg_enable_e0;

	reg		[7:0]	ff_reg_ar_a1;
	reg		[7:0]	ff_reg_dr_a1;
	reg		[7:0]	ff_reg_sr_a1;
	reg		[7:0]	ff_reg_rr_a1;
	reg		[5:0]	ff_reg_sl_a1;

	reg		[7:0]	ff_reg_ar_b1;
	reg		[7:0]	ff_reg_dr_b1;
	reg		[7:0]	ff_reg_sr_b1;
	reg		[7:0]	ff_reg_rr_b1;
	reg		[5:0]	ff_reg_sl_b1;

	reg		[7:0]	ff_reg_ar_c1;
	reg		[7:0]	ff_reg_dr_c1;
	reg		[7:0]	ff_reg_sr_c1;
	reg		[7:0]	ff_reg_rr_c1;
	reg		[5:0]	ff_reg_sl_c1;

	reg		[7:0]	ff_reg_ar_d1;
	reg		[7:0]	ff_reg_dr_d1;
	reg		[7:0]	ff_reg_sr_d1;
	reg		[7:0]	ff_reg_rr_d1;
	reg		[5:0]	ff_reg_sl_d1;

	reg		[7:0]	ff_reg_ar_e1;
	reg		[7:0]	ff_reg_dr_e1;
	reg		[7:0]	ff_reg_sr_e1;
	reg		[7:0]	ff_reg_rr_e1;
	reg		[5:0]	ff_reg_sl_e1;

	reg		[3:0]	ff_reg_volume_a1;
	reg		[1:0]	ff_reg_enable_a1;
	reg				ff_reg_noise_enable_a1;
	reg		[1:0]	ff_reg_noise_sel_a1;
	reg				ff_reg_clone_frequency_a1;
	reg				ff_reg_clone_adsr_a1;
	reg				ff_reg_clone_noise_a1;
	reg				ff_reg_clone_wave_a1;
	reg				ff_reg_clone_key_a1;
	reg		[1:0]	ff_reg_wave_length_a1;
	reg		[11:0]	ff_reg_frequency_count_a1;
	wire	[1:0]	w_reg_wave_length_a1;
	wire	[11:0]	w_reg_frequency_count_a1;
	wire			w_noise_enable_a1;
	wire 	[1:0]	w_noise_sel_a1;

	reg		[3:0]	ff_reg_volume_b1;
	reg		[1:0]	ff_reg_enable_b1;
	reg				ff_reg_noise_enable_b1;
	reg		[1:0]	ff_reg_noise_sel_b1;
	reg				ff_reg_clone_frequency_b1;
	reg				ff_reg_clone_adsr_b1;
	reg				ff_reg_clone_noise_b1;
	reg				ff_reg_clone_wave_b1;
	reg				ff_reg_clone_key_b1;
	reg		[1:0]	ff_reg_wave_length_b1;
	reg		[11:0]	ff_reg_frequency_count_b1;
	wire	[1:0]	w_reg_wave_length_b1;
	wire	[11:0]	w_reg_frequency_count_b1;
	wire			w_noise_enable_b1;
	wire 	[1:0]	w_noise_sel_b1;

	reg		[3:0]	ff_reg_volume_c1;
	reg		[1:0]	ff_reg_enable_c1;
	reg				ff_reg_noise_enable_c1;
	reg		[1:0]	ff_reg_noise_sel_c1;
	reg				ff_reg_clone_frequency_c1;
	reg				ff_reg_clone_adsr_c1;
	reg				ff_reg_clone_noise_c1;
	reg				ff_reg_clone_wave_c1;
	reg				ff_reg_clone_key_c1;
	reg		[1:0]	ff_reg_wave_length_c1;
	reg		[11:0]	ff_reg_frequency_count_c1;
	wire	[1:0]	w_reg_wave_length_c1;
	wire	[11:0]	w_reg_frequency_count_c1;
	wire			w_noise_enable_c1;
	wire 	[1:0]	w_noise_sel_c1;

	reg		[3:0]	ff_reg_volume_d1;
	reg		[1:0]	ff_reg_enable_d1;
	reg				ff_reg_noise_enable_d1;
	reg		[1:0]	ff_reg_noise_sel_d1;
	reg				ff_reg_clone_frequency_d1;
	reg				ff_reg_clone_adsr_d1;
	reg				ff_reg_clone_noise_d1;
	reg				ff_reg_clone_wave_d1;
	reg				ff_reg_clone_key_d1;
	reg		[1:0]	ff_reg_wave_length_d1;
	reg		[11:0]	ff_reg_frequency_count_d1;
	wire	[1:0]	w_reg_wave_length_d1;
	wire	[11:0]	w_reg_frequency_count_d1;
	wire			w_noise_enable_d1;
	wire 	[1:0]	w_noise_sel_d1;

	reg		[3:0]	ff_reg_volume_e1;
	reg		[1:0]	ff_reg_enable_e1;
	reg				ff_reg_noise_enable_e1;
	reg		[1:0]	ff_reg_noise_sel_e1;
	reg				ff_reg_clone_frequency_e1;
	reg				ff_reg_clone_adsr_e1;
	reg				ff_reg_clone_noise_e1;
	reg				ff_reg_clone_wave_e1;
	reg				ff_reg_clone_key_e1;
	reg		[1:0]	ff_reg_wave_length_e1;
	reg		[11:0]	ff_reg_frequency_count_e1;
	wire	[1:0]	w_reg_wave_length_e1;
	wire	[11:0]	w_reg_frequency_count_e1;
	wire			w_noise_enable_e1;
	wire 	[1:0]	w_noise_sel_e1;

	reg		[7:0]	ff_rddata;

	wire	[1:0]	w_wave_length0;
	wire	[1:0]	w_wave_length1;
	wire	[11:0]	w_frequency_count0;
	wire	[11:0]	w_frequency_count1;

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
			else if( rd_active ) begin
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
			if( rd_active ) begin
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
			if( rd_active ) begin
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
	assign w_wts_en			= reg_bank3[7] & w_dec_bank3 & ~address[12] & reg_wts_enable;

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

	assign adsr_en	= reg_wts_enable;

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
			sram_ce0 <= 1'b0;
			sram_ce1 <= 1'b0;
			sram_id	<= 3'd0;
			sram_a	<= 7'd0;
			sram_d	<= 8'd0;
			sram_oe	<= 1'b0;
			sram_we	<= 1'b0;
		end
		else if( w_scc_en && (address[12:5] == 8'b1_1000_011) ) begin
			//	9860-987Fh : {100} 1 1000 011X XXXX
			sram_ce0	<= 1'b1;					//	Channel D0
			sram_ce1	<= 1'b1;					//	Channel D1
			sram_id		<= 3'd3;					//	Channel D0, D1
			sram_a		<= { 2'b00, address[4:0] };
			sram_oe		<= rdreq;
			sram_we		<= wrreq;
			sram_d		<= wrdata;
		end
		else if( w_scc_en && (address[12:7] == 6'b1_1000_0) ) begin
			//	9800-985Fh : {100} 1 1000 0XXX XXXX
			sram_ce0	<= 1'b1;					//	Channel A0, B0 or C0
			sram_ce1	<= 1'b0;
			sram_id		<= { 1'b0, address[6:5] };
			sram_a		<= { 2'b00, address[4:0] };
			sram_oe		<= rdreq;
			sram_we		<= wrreq;
			sram_d		<= wrdata;
		end
		else if( w_scc_en && (address[12:5] == 8'b1_1000_101) ) begin
			//	98A0-98BFh : {100} 1 1000 101X XXXX ReadOnly
			sram_ce0	<= 1'b0;
			sram_ce1	<= 1'b1;					//	Channel D1
			sram_a		<= { 2'b00, address[4:0] };
			sram_oe		<= rdreq;
			sram_we		<= 1'b0;
			sram_d		<= wrdata;
		end
		else if( w_scci_en && (address[10:8] == 3'b000) && address[7:5] == 3'b100 ) begin
			//	B880-B89Fh : {101} 1 1000 100X XXXX
			sram_ce0	<= 1'b0;
			sram_ce1	<= 1'b1;					//	Channel D1
			sram_id		<= 3'd3;
			sram_a		<= { 2'b00, address[4:0] };
			sram_oe		<= rdreq;
			sram_we		<= wrreq;
			sram_d		<= wrdata;
		end
		else if( w_scci_en && (address[10:8] == 3'b000) && !address[7] ) begin
			//	B800-B87Fh : {101} 1 1000 0XXX XXXX
			sram_ce0	<= 1'b1;					//	Channel A0, B0, C0 or D0
			sram_ce1	<= 1'b0;
			sram_id		<= { 1'b0, address[6:5] };
			sram_a		<= { 2'b00, address[4:0] };
			sram_oe		<= rdreq;
			sram_we		<= wrreq;
			sram_d		<= wrdata;
		end
		else if( w_wts_en ) begin
			//	A000-A9FFh : {1010} XXXX XXXX XXXX Ch.A0-E0	SRAM_ID: 0...9
			sram_a	<= address[6:0];
			sram_d	<= wrdata;
			case( address[11:8] )
			4'h0:
				begin
					sram_ce0	<= 1'b1;
					sram_ce1	<= ff_reg_clone_wave_a1;
					sram_id		<= 3'd0;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			4'h1:
				begin
					sram_ce0	<= 1'b1;
					sram_ce1	<= ff_reg_clone_wave_b1;
					sram_id		<= 3'd1;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			4'h2:
				begin
					sram_ce0	<= 1'b1;
					sram_ce1	<= ff_reg_clone_wave_c1;
					sram_id		<= 3'd2;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			4'h3:
				begin
					sram_ce0	<= 1'b1;
					sram_ce1	<= ff_reg_clone_wave_d1;
					sram_id		<= 3'd3;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			4'h4:
				begin
					sram_ce0	<= 1'b1;
					sram_ce1	<= ff_reg_clone_wave_e1;
					sram_id		<= 3'd4;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			4'h5:
				begin
					sram_ce0	<= 1'b0;
					sram_ce1	<= 1'b1;
					sram_id		<= 3'd0;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			4'h6:
				begin
					sram_ce0	<= 1'b0;
					sram_ce1	<= 1'b1;
					sram_id		<= 3'd1;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			4'h7:
				begin
					sram_ce0	<= 1'b0;
					sram_ce1	<= 1'b1;
					sram_id		<= 3'd2;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			4'h8:
				begin
					sram_ce0	<= 1'b0;
					sram_ce1	<= 1'b1;
					sram_id		<= 3'd3;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			4'h9:
				begin
					sram_ce0	<= 1'b0;
					sram_ce1	<= 1'b1;
					sram_id		<= 3'd4;
					sram_oe		<= rdreq;
					sram_we		<= wrreq;
				end
			default:
				begin
					//	hold
				end
			endcase
		end
	end

	// Frequency reset --------------------------------------------------------
	assign clear_counter_a0 = (wrreq && w_scc_en  && (address[7:1]  == 7'b1000_000      )) ? 1'b1 :
	                          (wrreq && w_scci_en && (address[7:1]  == 7'b1010_000      )) ? 1'b1 :
	                          (wrreq && w_wts_en  && (address[11:1] == 11'b1111_0000_000)) ? 1'b1 : 1'b0;
	assign clear_counter_b0 = (wrreq && w_scc_en  && (address[7:1] == 7'b1000_001       )) ? 1'b1 :
	                          (wrreq && w_scci_en && (address[7:1] == 7'b1010_001       )) ? 1'b1 :
	                          (wrreq && w_wts_en  && (address[11:1] == 11'b1111_0001_000)) ? 1'b1 : 1'b0;
	assign clear_counter_c0 = (wrreq && w_scc_en  && (address[7:1] == 7'b1000_010       )) ? 1'b1 :
	                          (wrreq && w_scci_en && (address[7:1] == 7'b1010_010       )) ? 1'b1 :
	                          (wrreq && w_wts_en  && (address[11:1] == 11'b1111_0010_000)) ? 1'b1 : 1'b0;
	assign clear_counter_d0 = (wrreq && w_scc_en  && (address[7:1] == 7'b1000_011       )) ? 1'b1 :
	                          (wrreq && w_scci_en && (address[7:1] == 7'b1010_011       )) ? 1'b1 :
	                          (wrreq && w_wts_en  && (address[11:1] == 11'b1111_0011_000)) ? 1'b1 : 1'b0;

	assign clear_counter_e0 = (wrreq && w_wts_en  && (address[11:1] == 11'b1111_0100_000)) ? 1'b1 : 1'b0;

	assign clear_counter_a1 = (wrreq && w_wts_en  && (address[11:1] == 11'b1111_0101_000)) ? 1'b1 : 1'b0;
	assign clear_counter_b1 = (wrreq && w_wts_en  && (address[11:1] == 11'b1111_0110_000)) ? 1'b1 : 1'b0;
	assign clear_counter_c1 = (wrreq && w_wts_en  && (address[11:1] == 11'b1111_0111_000)) ? 1'b1 : 1'b0;

	assign clear_counter_d1 = (wrreq && w_scc_en  && (address[7:1] == 7'b1000_100       )) ? 1'b1 :
	                          (wrreq && w_scci_en && (address[7:1] == 7'b1010_100       )) ? 1'b1 :
	                          (wrreq && w_wts_en  && (address[11:1] == 11'b1111_1000_000)) ? 1'b1 : 1'b0;

	assign clear_counter_e1 = (wrreq && w_wts_en  && (address[11:1] == 11'b1111_1001_000)) ? 1'b1 : 1'b0;

	// Control registers ------------------------------------------------------
	always @( negedge nreset or posedge clk ) begin
		if( !nreset ) begin
			ff_ch0_key					<= 3'd0;
			ff_ch0_key_on				<= 1'b0;
			ff_ch0_key_release			<= 1'b0;
			ff_ch0_key_off				<= 1'b0;

			ff_ch1_key					<= 3'd0;
			ff_ch1_key_on				<= 1'b0;
			ff_ch1_key_release			<= 1'b0;
			ff_ch1_key_off				<= 1'b0;

			ff_reg_ar_a0				<= 'd0;
			ff_reg_dr_a0				<= 'd0;
			ff_reg_sr_a0				<= 'd0;
			ff_reg_rr_a0				<= 'd0;
			ff_reg_sl_a0				<= 'd0;

			ff_reg_ar_b0				<= 'd0;
			ff_reg_dr_b0				<= 'd0;
			ff_reg_sr_b0				<= 'd0;
			ff_reg_rr_b0				<= 'd0;
			ff_reg_sl_b0				<= 'd0;

			ff_reg_ar_c0				<= 'd0;
			ff_reg_dr_c0				<= 'd0;
			ff_reg_sr_c0				<= 'd0;
			ff_reg_rr_c0				<= 'd0;
			ff_reg_sl_c0				<= 'd0;

			ff_reg_ar_d0				<= 'd0;
			ff_reg_dr_d0				<= 'd0;
			ff_reg_sr_d0				<= 'd0;
			ff_reg_rr_d0				<= 'd0;
			ff_reg_sl_d0				<= 'd0;

			ff_reg_ar_e0				<= 'd0;
			ff_reg_dr_e0				<= 'd0;
			ff_reg_sr_e0				<= 'd0;
			ff_reg_rr_e0				<= 'd0;
			ff_reg_sl_e0				<= 'd0;

			ff_reg_ar_a1				<= 'd0;
			ff_reg_dr_a1				<= 'd0;
			ff_reg_sr_a1				<= 'd0;
			ff_reg_rr_a1				<= 'd0;
			ff_reg_sl_a1				<= 'd0;

			ff_reg_ar_b1				<= 'd0;
			ff_reg_dr_b1				<= 'd0;
			ff_reg_sr_b1				<= 'd0;
			ff_reg_rr_b1				<= 'd0;
			ff_reg_sl_b1				<= 'd0;

			ff_reg_ar_c1				<= 'd0;
			ff_reg_dr_c1				<= 'd0;
			ff_reg_sr_c1				<= 'd0;
			ff_reg_rr_c1				<= 'd0;
			ff_reg_sl_c1				<= 'd0;

			ff_reg_ar_d1				<= 'd0;
			ff_reg_dr_d1				<= 'd0;
			ff_reg_sr_d1				<= 'd0;
			ff_reg_rr_d1				<= 'd0;
			ff_reg_sl_d1				<= 'd0;

			ff_reg_ar_e1				<= 'd0;
			ff_reg_dr_e1				<= 'd0;
			ff_reg_sr_e1				<= 'd0;
			ff_reg_rr_e1				<= 'd0;
			ff_reg_sl_e1				<= 'd0;

			ff_reg_volume_a0			<= 'd0;
			ff_reg_enable_a0			<= 'd0;
			reg_noise_enable_a0			<= 'd0;
			reg_noise_sel_a0			<= 'd0;
			ff_reg_wave_length_a0		<= 'd0;
			ff_reg_frequency_count_a0	<= 'd0;

			ff_reg_volume_b0			<= 'd0;
			ff_reg_enable_b0			<= 'd0;
			reg_noise_enable_b0			<= 'd0;
			reg_noise_sel_b0			<= 'd0;
			ff_reg_wave_length_b0		<= 'd0;
			ff_reg_frequency_count_b0	<= 'd0;

			ff_reg_volume_c0			<= 'd0;
			ff_reg_enable_c0			<= 'd0;
			reg_noise_enable_c0			<= 'd0;
			reg_noise_sel_c0			<= 'd0;
			ff_reg_wave_length_c0		<= 'd0;
			ff_reg_frequency_count_c0	<= 'd0;

			ff_reg_volume_d0			<= 'd0;
			ff_reg_enable_d0			<= 'd0;
			reg_noise_enable_d0			<= 'd0;
			reg_noise_sel_d0			<= 'd0;
			ff_reg_wave_length_d0		<= 'd0;
			ff_reg_frequency_count_d0	<= 'd0;

			ff_reg_volume_e0			<= 'd0;
			ff_reg_enable_e0			<= 'd0;
			reg_noise_enable_e0			<= 'd0;
			reg_noise_sel_e0			<= 'd0;
			ff_reg_wave_length_e0		<= 'd0;
			ff_reg_frequency_count_e0	<= 'd0;

			ff_reg_volume_a1			<= 'd0;
			ff_reg_enable_a1			<= 'd0;
			ff_reg_noise_enable_a1		<= 'd0;
			ff_reg_noise_sel_a1			<= 'd0;
			ff_reg_clone_frequency_a1	<= 'd1;
			ff_reg_clone_adsr_a1		<= 'd1;
			ff_reg_clone_noise_a1		<= 'd1;
			ff_reg_clone_wave_a1		<= 'd1;
			ff_reg_clone_key_a1			<= 'd1;
			ff_reg_wave_length_a1		<= 'd0;
			ff_reg_frequency_count_a1	<= 'd0;

			ff_reg_volume_b1			<= 'd0;
			ff_reg_enable_b1			<= 'd0;
			ff_reg_noise_enable_b1		<= 'd0;
			ff_reg_noise_sel_b1			<= 'd0;
			ff_reg_clone_frequency_b1	<= 'd1;
			ff_reg_clone_adsr_b1		<= 'd1;
			ff_reg_clone_noise_b1		<= 'd1;
			ff_reg_clone_wave_b1		<= 'd1;
			ff_reg_clone_key_b1			<= 'd1;
			ff_reg_wave_length_b1		<= 'd0;
			ff_reg_frequency_count_b1	<= 'd0;

			ff_reg_volume_c1			<= 'd0;
			ff_reg_enable_c1			<= 'd0;
			ff_reg_noise_enable_c1		<= 'd0;
			ff_reg_noise_sel_c1			<= 'd0;
			ff_reg_clone_frequency_c1	<= 'd1;
			ff_reg_clone_adsr_c1		<= 'd1;
			ff_reg_clone_noise_c1		<= 'd1;
			ff_reg_clone_wave_c1		<= 'd1;
			ff_reg_clone_key_c1			<= 'd1;
			ff_reg_wave_length_c1		<= 'd0;
			ff_reg_frequency_count_c1	<= 'd0;

			ff_reg_volume_d1			<= 'd0;
			ff_reg_enable_d1			<= 'd0;
			ff_reg_noise_enable_d1		<= 'd0;
			ff_reg_noise_sel_d1			<= 'd0;
			ff_reg_clone_frequency_d1	<= 'd1;
			ff_reg_clone_adsr_d1		<= 'd1;
			ff_reg_clone_noise_d1		<= 'd1;
			ff_reg_clone_wave_d1		<= 'd1;
			ff_reg_clone_key_d1			<= 'd1;
			ff_reg_wave_length_d1		<= 'd0;
			ff_reg_frequency_count_d1	<= 'd0;

			ff_reg_volume_e1			<= 'd0;
			ff_reg_enable_e1			<= 'd0;
			ff_reg_noise_enable_e1		<= 'd0;
			ff_reg_noise_sel_e1			<= 'd0;
			ff_reg_clone_frequency_e1	<= 'd1;
			ff_reg_clone_adsr_e1		<= 'd1;
			ff_reg_clone_noise_e1		<= 'd1;
			ff_reg_clone_wave_e1		<= 'd1;
			ff_reg_clone_key_e1			<= 'd1;
			ff_reg_wave_length_e1		<= 'd0;
			ff_reg_frequency_count_e1	<= 'd0;

			reg_noise_frequency0		<= 'd0;
			reg_noise_frequency1		<= 'd0;
			reg_noise_frequency2		<= 'd0;
			reg_noise_frequency3		<= 'd0;

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
			if( w_scc_en && (address[7:4] == 4'h8) ) begin
				case( address[3:0] )
				4'h0:		ff_reg_frequency_count_a0[ 7:0]	<= wrdata;
				4'h1:		ff_reg_frequency_count_a0[11:8]	<= wrdata[3:0];
				4'h2:		ff_reg_frequency_count_b0[ 7:0]	<= wrdata;
				4'h3:		ff_reg_frequency_count_b0[11:8]	<= wrdata[3:0];
				4'h4:		ff_reg_frequency_count_c0[ 7:0]	<= wrdata;
				4'h5:		ff_reg_frequency_count_c0[11:8]	<= wrdata[3:0];
				4'h6:		ff_reg_frequency_count_d0[ 7:0]	<= wrdata;
				4'h7:		ff_reg_frequency_count_d0[11:8]	<= wrdata[3:0];
				4'h8:		ff_reg_frequency_count_d1[ 7:0]	<= wrdata;
				4'h9:		ff_reg_frequency_count_d1[11:8]	<= wrdata[3:0];
				4'hA:		ff_reg_volume_a0				<= wrdata[3:0];
				4'hB:		ff_reg_volume_b0				<= wrdata[3:0];
				4'hC:		ff_reg_volume_c0				<= wrdata[3:0];
				4'hD:		ff_reg_volume_d0				<= wrdata[3:0];
				4'hE:		ff_reg_volume_d1				<= wrdata[3:0];
				4'hF:
					begin
						ff_reg_enable_a0	<= { wrdata[0], wrdata[0] };
						ff_reg_enable_b0	<= { wrdata[1], wrdata[1] };
						ff_reg_enable_c0	<= { wrdata[2], wrdata[2] };
						ff_reg_enable_d0	<= { wrdata[3], wrdata[3] };
						ff_reg_enable_d1	<= { wrdata[4], wrdata[4] };
					end
				endcase
			end
			else if( w_scci_en && (address[7:4] == 4'hA) ) begin
				case( address[3:0] )
				4'h0:		ff_reg_frequency_count_a0[ 7:0]	<= wrdata;
				4'h1:		ff_reg_frequency_count_a0[11:8]	<= wrdata[3:0];
				4'h2:		ff_reg_frequency_count_b0[ 7:0]	<= wrdata;
				4'h3:		ff_reg_frequency_count_b0[11:8]	<= wrdata[3:0];
				4'h4:		ff_reg_frequency_count_c0[ 7:0]	<= wrdata;
				4'h5:		ff_reg_frequency_count_c0[11:8]	<= wrdata[3:0];
				4'h6:		ff_reg_frequency_count_d0[ 7:0]	<= wrdata;
				4'h7:		ff_reg_frequency_count_d0[11:8]	<= wrdata[3:0];
				4'h8:		ff_reg_frequency_count_d1[ 7:0]	<= wrdata;
				4'h9:		ff_reg_frequency_count_d1[11:8]	<= wrdata[3:0];
				4'hA:		ff_reg_volume_a0				<= wrdata[3:0];
				4'hB:		ff_reg_volume_b0				<= wrdata[3:0];
				4'hC:		ff_reg_volume_c0				<= wrdata[3:0];
				4'hD:		ff_reg_volume_d0				<= wrdata[3:0];
				4'hE:		ff_reg_volume_d1				<= wrdata[3:0];
				4'hF:
					begin
						ff_reg_enable_a0	<= { wrdata[0], wrdata[0] };
						ff_reg_enable_b0	<= { wrdata[1], wrdata[1] };
						ff_reg_enable_c0	<= { wrdata[2], wrdata[2] };
						ff_reg_enable_d0	<= { wrdata[3], wrdata[3] };
						ff_reg_enable_d1	<= { wrdata[4], wrdata[4] };
					end
				endcase
			end
			else if( w_wts_en && (address[11:8] == 4'hF) ) begin
				case( address[7:0] )
				8'h00:		ff_reg_frequency_count_a0[ 7:0]	<= wrdata;
				8'h01:		ff_reg_frequency_count_a0[11:8]	<= wrdata[3:0];
				8'h02:		ff_reg_volume_a0				<= wrdata[3:0];
				8'h03:		ff_reg_enable_a0				<= wrdata[1:0];
				8'h04:		ff_reg_ar_a0					<= wrdata;
				8'h05:		ff_reg_dr_a0					<= wrdata;
				8'h06:		ff_reg_sr_a0					<= wrdata;
				8'h07:		ff_reg_rr_a0					<= wrdata;
				8'h08:		ff_reg_sl_a0					<= wrdata[5:0];
				8'h09:
					begin
						reg_noise_enable_a0					<= wrdata[7];
						reg_noise_sel_a0					<= wrdata[1:0];
					end
				8'h0A:		ff_reg_wave_length_a0			<= wrdata[1:0];
				8'h0B:
					begin
						ff_ch0_key							<= 3'd1;
						ff_ch0_key_on						<= wrdata[0];
						ff_ch0_key_release					<= wrdata[1];
						ff_ch0_key_off						<= wrdata[2];
					end

				8'h10:		ff_reg_frequency_count_b0[ 7:0]	<= wrdata;
				8'h11:		ff_reg_frequency_count_b0[11:8]	<= wrdata[3:0];
				8'h12:		ff_reg_volume_b0				<= wrdata[3:0];
				8'h13:		ff_reg_enable_b0				<= wrdata[1:0];
				8'h14:		ff_reg_ar_b0					<= wrdata;
				8'h15:		ff_reg_dr_b0					<= wrdata;
				8'h16:		ff_reg_sr_b0					<= wrdata;
				8'h17:		ff_reg_rr_b0					<= wrdata;
				8'h18:		ff_reg_sl_b0					<= wrdata[5:0];
				8'h19:
					begin
						reg_noise_enable_b0					<= wrdata[7];
						reg_noise_sel_b0					<= wrdata[1:0];
					end
				8'h1A:		ff_reg_wave_length_b0			<= wrdata[1:0];
				8'h1B:
					begin
						ff_ch0_key							<= 3'd2;
						ff_ch0_key_on						<= wrdata[0];
						ff_ch0_key_release					<= wrdata[1];
						ff_ch0_key_off						<= wrdata[2];
					end

				8'h20:		ff_reg_frequency_count_c0[ 7:0]	<= wrdata;
				8'h21:		ff_reg_frequency_count_c0[11:8]	<= wrdata[3:0];
				8'h22:		ff_reg_volume_c0				<= wrdata[3:0];
				8'h23:		ff_reg_enable_c0				<= wrdata[1:0];
				8'h24:		ff_reg_ar_c0					<= wrdata;
				8'h25:		ff_reg_dr_c0					<= wrdata;
				8'h26:		ff_reg_sr_c0					<= wrdata;
				8'h27:		ff_reg_rr_c0					<= wrdata;
				8'h28:		ff_reg_sl_c0					<= wrdata[5:0];
				8'h29:
					begin
						reg_noise_enable_c0					<= wrdata[7];
						reg_noise_sel_c0					<= wrdata[1:0];
					end
				8'h2A:		ff_reg_wave_length_c0			<= wrdata[1:0];
				8'h2B:
					begin
						ff_ch0_key							<= 3'd3;
						ff_ch0_key_on						<= wrdata[0];
						ff_ch0_key_release					<= wrdata[1];
						ff_ch0_key_off						<= wrdata[2];
					end

				8'h30:		ff_reg_frequency_count_d0[ 7:0]	<= wrdata;
				8'h31:		ff_reg_frequency_count_d0[11:8]	<= wrdata[3:0];
				8'h32:		ff_reg_volume_d0				<= wrdata[3:0];
				8'h33:		ff_reg_enable_d0				<= wrdata[1:0];
				8'h34:		ff_reg_dr_d0					<= wrdata;
				8'h35:		ff_reg_dr_d0					<= wrdata;
				8'h36:		ff_reg_sr_d0					<= wrdata;
				8'h37:		ff_reg_rr_d0					<= wrdata;
				8'h38:		ff_reg_sl_d0					<= wrdata[5:0];
				8'h39:
					begin
						reg_noise_enable_d0					<= wrdata[7];
						reg_noise_sel_d0					<= wrdata[1:0];
					end
				8'h3A:		ff_reg_wave_length_d0			<= wrdata[1:0];
				8'h3B:
					begin
						ff_ch0_key							<= 3'd4;
						ff_ch0_key_on						<= wrdata[0];
						ff_ch0_key_release					<= wrdata[1];
						ff_ch0_key_off						<= wrdata[2];
					end

				8'h40:		ff_reg_frequency_count_e0[ 7:0]	<= wrdata;
				8'h41:		ff_reg_frequency_count_e0[11:8]	<= wrdata[3:0];
				8'h42:		ff_reg_volume_e0				<= wrdata[3:0];
				8'h43:		ff_reg_enable_e0				<= wrdata[1:0];
				8'h44:		ff_reg_ar_e0					<= wrdata;
				8'h45:		ff_reg_dr_e0					<= wrdata;
				8'h46:		ff_reg_sr_e0					<= wrdata;
				8'h47:		ff_reg_rr_e0					<= wrdata;
				8'h48:		ff_reg_sl_e0					<= wrdata[5:0];
				8'h49:
					begin
						reg_noise_enable_e0					<= wrdata[7];
						reg_noise_sel_e0					<= wrdata[1:0];
					end
				8'h4A:		ff_reg_wave_length_e0			<= wrdata[1:0];
				8'h4B:
					begin
						ff_ch0_key							<= 3'd5;
						ff_ch0_key_on						<= wrdata[0];
						ff_ch0_key_release					<= wrdata[1];
						ff_ch0_key_off						<= wrdata[2];
					end

				8'h50:		ff_reg_frequency_count_a1[ 7:0]	<= wrdata;
				8'h51:		ff_reg_frequency_count_a1[11:8]	<= wrdata[3:0];
				8'h52:		ff_reg_volume_a1				<= wrdata[3:0];
				8'h53:
					begin
						ff_reg_enable_a1					<= wrdata[1:0];
						ff_reg_clone_frequency_a1			<= wrdata[3];
						ff_reg_clone_adsr_a1				<= wrdata[4];
						ff_reg_clone_noise_a1				<= wrdata[5];
						ff_reg_clone_wave_a1				<= wrdata[6];
						ff_reg_clone_key_a1					<= wrdata[7];
					end
				8'h54:		ff_reg_ar_a1					<= wrdata;
				8'h55:		ff_reg_dr_a1					<= wrdata;
				8'h56:		ff_reg_sr_a1					<= wrdata;
				8'h57:		ff_reg_rr_a1					<= wrdata;
				8'h58:		ff_reg_sl_a1					<= wrdata[5:0];
				8'h59:
					begin
						ff_reg_noise_enable_a1				<= wrdata[7];
						ff_reg_noise_sel_a1					<= wrdata[1:0];
					end
				8'h5A:		ff_reg_wave_length_a1			<= wrdata[1:0];
				8'h5B:
					begin
						ff_ch1_key							<= 3'd1;
						ff_ch1_key_on						<= wrdata[0];
						ff_ch1_key_release					<= wrdata[1];
						ff_ch1_key_off						<= wrdata[2];
					end

				8'h60:		ff_reg_frequency_count_b1[ 7:0]	<= wrdata;
				8'h61:		ff_reg_frequency_count_b1[11:8]	<= wrdata[3:0];
				8'h62:		ff_reg_volume_b1				<= wrdata[3:0];
				8'h63:
					begin
						ff_reg_enable_b1					<= wrdata[1:0];
						ff_reg_clone_frequency_b1			<= wrdata[3];
						ff_reg_clone_adsr_b1				<= wrdata[4];
						ff_reg_clone_noise_b1				<= wrdata[5];
						ff_reg_clone_wave_b1				<= wrdata[6];
						ff_reg_clone_key_b1					<= wrdata[7];
					end
				8'h64:		ff_reg_ar_b1					<= wrdata;
				8'h65:		ff_reg_dr_b1					<= wrdata;
				8'h66:		ff_reg_sr_b1					<= wrdata;
				8'h67:		ff_reg_rr_b1					<= wrdata;
				8'h68:		ff_reg_sl_b1					<= wrdata[5:0];
				8'h69:
					begin
						ff_reg_noise_enable_b1				<= wrdata[7];
						ff_reg_noise_sel_b1					<= wrdata[1:0];
					end
				8'h6A:		ff_reg_wave_length_b1			<= wrdata[1:0];
				8'h6B:
					begin
						ff_ch1_key							<= 3'd2;
						ff_ch1_key_on						<= wrdata[0];
						ff_ch1_key_release					<= wrdata[1];
						ff_ch1_key_off						<= wrdata[2];
					end

				8'h70:		ff_reg_frequency_count_c1[ 7:0]	<= wrdata;
				8'h71:		ff_reg_frequency_count_c1[11:8]	<= wrdata[3:0];
				8'h72:		ff_reg_volume_c1				<= wrdata[3:0];
				8'h73:
					begin
						ff_reg_enable_c1					<= wrdata[1:0];
						ff_reg_clone_frequency_c1			<= wrdata[3];
						ff_reg_clone_adsr_c1				<= wrdata[4];
						ff_reg_clone_noise_c1				<= wrdata[5];
						ff_reg_clone_wave_c1				<= wrdata[6];
						ff_reg_clone_key_c1					<= wrdata[7];
					end
				8'h74:		ff_reg_ar_c1					<= wrdata;
				8'h75:		ff_reg_dr_c1					<= wrdata;
				8'h76:		ff_reg_sr_c1					<= wrdata;
				8'h77:		ff_reg_rr_c1					<= wrdata;
				8'h78:		ff_reg_sl_c1					<= wrdata[5:0];
				8'h79:
					begin
						ff_reg_noise_enable_c1				<= wrdata[7];
						ff_reg_noise_sel_c1					<= wrdata[1:0];
					end
				8'h7A:		ff_reg_wave_length_c1			<= wrdata[1:0];
				8'h7B:
					begin
						ff_ch1_key							<= 3'd3;
						ff_ch1_key_on						<= wrdata[0];
						ff_ch1_key_release					<= wrdata[1];
						ff_ch1_key_off						<= wrdata[2];
					end

				8'h80:		ff_reg_frequency_count_d1[ 7:0]	<= wrdata;
				8'h81:		ff_reg_frequency_count_d1[11:8]	<= wrdata[3:0];
				8'h82:		ff_reg_volume_d1				<= wrdata[3:0];
				8'h83:
					begin
						ff_reg_enable_d1					<= wrdata[1:0];
						ff_reg_clone_frequency_d1			<= wrdata[3];
						ff_reg_clone_adsr_d1				<= wrdata[4];
						ff_reg_clone_noise_d1				<= wrdata[5];
						ff_reg_clone_wave_d1				<= wrdata[6];
						ff_reg_clone_key_d1					<= wrdata[7];
					end
				8'h84:		ff_reg_ar_d1					<= wrdata;
				8'h85:		ff_reg_dr_d1					<= wrdata;
				8'h86:		ff_reg_sr_d1					<= wrdata;
				8'h87:		ff_reg_rr_d1					<= wrdata;
				8'h88:		ff_reg_sl_d1					<= wrdata[5:0];
				8'h89:
					begin
						ff_reg_noise_enable_d1				<= wrdata[7];
						ff_reg_noise_sel_d1					<= wrdata[1:0];
					end
				8'h8A:		ff_reg_wave_length_d1			<= wrdata[1:0];
				8'h8B:
					begin
						ff_ch1_key							<= 3'd4;
						ff_ch1_key_on						<= wrdata[0];
						ff_ch1_key_release					<= wrdata[1];
						ff_ch1_key_off						<= wrdata[2];
					end

				8'h90:		ff_reg_frequency_count_e1[ 7:0]	<= wrdata;
				8'h91:		ff_reg_frequency_count_e1[11:8]	<= wrdata[3:0];
				8'h92:		ff_reg_volume_e1				<= wrdata[3:0];
				8'h93:
					begin
						ff_reg_enable_e1					<= wrdata[1:0];
						ff_reg_clone_frequency_e1			<= wrdata[3];
						ff_reg_clone_adsr_e1				<= wrdata[4];
						ff_reg_clone_noise_e1				<= wrdata[5];
						ff_reg_clone_wave_e1				<= wrdata[6];
						ff_reg_clone_key_e1					<= wrdata[7];
					end
				8'h94:		ff_reg_ar_e1					<= wrdata;
				8'h95:		ff_reg_dr_e1					<= wrdata;
				8'h96:		ff_reg_sr_e1					<= wrdata;
				8'h97:		ff_reg_rr_e1					<= wrdata;
				8'h98:		ff_reg_sl_e1					<= wrdata[5:0];
				8'h99:
					begin
						ff_reg_noise_enable_e1				<= wrdata[7];
						ff_reg_noise_sel_e1					<= wrdata[1:0];
					end
				8'h9A:		ff_reg_wave_length_e1			<= wrdata[1:0];
				8'h9B:
					begin
						ff_ch1_key							<= 3'd5;
						ff_ch1_key_on						<= wrdata[0];
						ff_ch1_key_release					<= wrdata[1];
						ff_ch1_key_off						<= wrdata[2];
					end

				8'hF0:		reg_noise_frequency0			<= wrdata[4:0];
				8'hF1:		reg_noise_frequency1			<= wrdata[4:0];
				8'hF2:		reg_noise_frequency2			<= wrdata[4:0];
				8'hF3:		reg_noise_frequency3			<= wrdata[4:0];

				8'hF8:
					begin
						reg_timer1_channel					<= wrdata[3:0];
						reg_timer1_oneshot					<= wrdata[6];
						reg_timer1_enable					<= wrdata[7];
					end
				8'hFA:
					begin
						reg_timer2_channel					<= wrdata[3:0];
						reg_timer2_oneshot					<= wrdata[6];
						reg_timer2_enable					<= wrdata[7];
					end
				default:
					begin
						//	hold
					end
				endcase
			end
		end
		else if( rdreq ) begin
			if( w_wts_en && (address[11:8] == 4'hF) ) begin
				if( address[7:0] == 8'hF9 ) begin
					reg_timer1_clear	<= 1'b1;
					reg_timer1_enable	<= reg_timer1_oneshot ? (timer1_status[7] & reg_timer1_enable) : reg_timer1_enable;
				end
				else if( address[7:0] == 8'hFB ) begin
					reg_timer2_clear	<= 1'b1;
					reg_timer2_enable	<= reg_timer2_oneshot ? (timer2_status[7] & reg_timer2_enable) : reg_timer2_enable;
				end
			end
		end
		else begin
			reg_timer1_clear			<= 1'b0;
			reg_timer2_clear			<= 1'b0;

			if( active == ff_ch0_key ) begin
				ff_ch0_key_on						<= 1'b0;
				ff_ch0_key_release					<= 1'b0;
				ff_ch0_key_off						<= 1'b0;
			end

			if( active == ff_ch1_key ) begin
				ff_ch1_key_on						<= 1'b0;
				ff_ch1_key_release					<= 1'b0;
				ff_ch1_key_off						<= 1'b0;
			end
		end
	end

	assign reg_noise_enable_a1		= ff_reg_noise_enable_a1;
	assign w_reg_wave_length_a1		= ff_reg_clone_wave_a1 ? ff_reg_wave_length_a0 : ff_reg_wave_length_a1;
	assign w_reg_frequency_count_a1	= ff_reg_clone_frequency_a1 ? ff_reg_frequency_count_a0 : ff_reg_frequency_count_a1;
	assign reg_noise_sel_a1			= ff_reg_clone_noise_a1 ? reg_noise_sel_a0 : ff_reg_noise_sel_a1;

	assign reg_noise_enable_b1		= ff_reg_noise_enable_b1;
	assign w_reg_wave_length_b1		= ff_reg_clone_wave_b1 ? ff_reg_wave_length_b0 : ff_reg_wave_length_b1;
	assign w_reg_frequency_count_b1	= ff_reg_clone_frequency_b1 ? ff_reg_frequency_count_b0 : ff_reg_frequency_count_b1;
	assign reg_noise_sel_b1			= ff_reg_clone_noise_b1 ? reg_noise_sel_b0 : ff_reg_noise_sel_b1;

	assign reg_noise_enable_c1		= ff_reg_noise_enable_c1;
	assign w_reg_wave_length_c1		= ff_reg_clone_wave_c1 ? ff_reg_wave_length_c0 : ff_reg_wave_length_c1;
	assign w_reg_frequency_count_c1	= ff_reg_clone_frequency_c1 ? ff_reg_frequency_count_c0 : ff_reg_frequency_count_c1;
	assign reg_noise_sel_c1			= ff_reg_clone_noise_c1 ? reg_noise_sel_c0 : ff_reg_noise_sel_c1;

	assign reg_noise_enable_d1		= ff_reg_noise_enable_d1;
	assign w_reg_wave_length_d1		= ff_reg_clone_wave_d1 ? ff_reg_wave_length_d0 : ff_reg_wave_length_d1;
	assign w_reg_frequency_count_d1	= ff_reg_clone_frequency_d1 ? ff_reg_frequency_count_d0 : ff_reg_frequency_count_d1;
	assign reg_noise_sel_d1			= ff_reg_clone_noise_d1 ? reg_noise_sel_d0 : ff_reg_noise_sel_d1;

	assign reg_noise_enable_e1		= ff_reg_noise_enable_e1;
	assign w_reg_wave_length_e1		= ff_reg_clone_wave_e1 ? ff_reg_wave_length_e0 : ff_reg_wave_length_e1;
	assign w_reg_frequency_count_e1	= ff_reg_clone_frequency_e1 ? ff_reg_frequency_count_e0 : ff_reg_frequency_count_e1;
	assign reg_noise_sel_e1			= ff_reg_clone_noise_e1 ? reg_noise_sel_e0 : ff_reg_noise_sel_e1;

	// External memory address ------------------------------------------------
	assign ext_memory_address	= w_dec_bank0 ? reg_bank0 :
	                         	  w_dec_bank1 ? reg_bank1 :
	                         	  w_dec_bank2 ? reg_bank2 : reg_bank3;

	// Read registers ---------------------------------------------------------
	always @( posedge clk ) begin
		if( rdreq ) begin
			if( w_wts_en && (address[11:0] == 12'hFF9) ) begin
				ff_rddata <= timer1_status;
			end
			else if( w_wts_en && (address[11:0] == 12'hFF9) ) begin
				ff_rddata <= timer2_status;
			end
			else if( sram_q_en ) begin
				ff_rddata <= sram_q;
			end
		end
		else if( sram_q_en ) begin
			ff_rddata <= sram_q;
		end
		else begin
			//	hold
		end
	end

	assign rddata = ff_rddata;

	// ADSR Parameters --------------------------------------------------------
	wts_selector #( 8 ) u_ar_selector0 (
		.active		( active			),
		.result		( w_ar0				),
		.reg_a		( 8'd0				),
		.reg_b		( ff_reg_ar_a0		),
		.reg_c		( ff_reg_ar_b0		),
		.reg_d		( ff_reg_ar_c0		),
		.reg_e		( ff_reg_ar_d0		),
		.reg_f		( ff_reg_ar_e0		)
	);

	wts_selector #( 8 ) u_dr_selector0 (
		.active		( active			),
		.result		( w_dr0				),
		.reg_a		( 8'd0				),
		.reg_b		( ff_reg_dr_a0		),
		.reg_c		( ff_reg_dr_b0		),
		.reg_d		( ff_reg_dr_c0		),
		.reg_e		( ff_reg_dr_d0		),
		.reg_f		( ff_reg_dr_e0		)
	);

	wts_selector #( 8 ) u_sr_selector0 (
		.active		( active			),
		.result		( w_sr0				),
		.reg_a		( 8'd0				),
		.reg_b		( ff_reg_sr_a0		),
		.reg_c		( ff_reg_sr_b0		),
		.reg_d		( ff_reg_sr_c0		),
		.reg_e		( ff_reg_sr_d0		),
		.reg_f		( ff_reg_sr_e0		)
	);

	wts_selector #( 8 ) u_rr_selector0 (
		.active		( active			),
		.result		( w_rr0				),
		.reg_a		( 8'd0				),
		.reg_b		( ff_reg_rr_a0		),
		.reg_c		( ff_reg_rr_b0		),
		.reg_d		( ff_reg_rr_c0		),
		.reg_e		( ff_reg_rr_d0		),
		.reg_f		( ff_reg_rr_e0		)
	);

	wts_selector #( 6 ) u_sl_selector0 (
		.active		( active			),
		.result		( w_sl0				),
		.reg_a		( 6'd0				),
		.reg_b		( ff_reg_sl_a0		),
		.reg_c		( ff_reg_sl_b0		),
		.reg_d		( ff_reg_sl_c0		),
		.reg_e		( ff_reg_sl_d0		),
		.reg_f		( ff_reg_sl_e0		)
	);

	wts_selector #( 8 ) u_ar_selector1 (
		.active		( active			),
		.result		( w_ar1				),
		.reg_a		( 8'd0				),
		.reg_b		( ff_reg_ar_a1		),
		.reg_c		( ff_reg_ar_b1		),
		.reg_d		( ff_reg_ar_c1		),
		.reg_e		( ff_reg_ar_d1		),
		.reg_f		( ff_reg_ar_e1		)
	);

	wts_selector #( 8 ) u_dr_selector1 (
		.active		( active			),
		.result		( w_dr1				),
		.reg_a		( 8'd0				),
		.reg_b		( ff_reg_dr_a1		),
		.reg_c		( ff_reg_dr_b1		),
		.reg_d		( ff_reg_dr_c1		),
		.reg_e		( ff_reg_dr_d1		),
		.reg_f		( ff_reg_dr_e1		)
	);

	wts_selector #( 8 ) u_sr_selector1 (
		.active		( active			),
		.result		( w_sr1				),
		.reg_a		( 8'd0				),
		.reg_b		( ff_reg_sr_a1		),
		.reg_c		( ff_reg_sr_b1		),
		.reg_d		( ff_reg_sr_c1		),
		.reg_e		( ff_reg_sr_d1		),
		.reg_f		( ff_reg_sr_e1		)
	);

	wts_selector #( 8 ) u_rr_selector1 (
		.active		( active			),
		.result		( w_rr1				),
		.reg_a		( 8'd0				),
		.reg_b		( ff_reg_rr_a1		),
		.reg_c		( ff_reg_rr_b1		),
		.reg_d		( ff_reg_rr_c1		),
		.reg_e		( ff_reg_rr_d1		),
		.reg_f		( ff_reg_rr_e1		)
	);

	wts_selector #( 6 ) u_sl_selector1 (
		.active		( active			),
		.result		( w_sl1				),
		.reg_a		( 6'd0				),
		.reg_b		( ff_reg_sl_a1		),
		.reg_c		( ff_reg_sl_b1		),
		.reg_d		( ff_reg_sl_c1		),
		.reg_e		( ff_reg_sl_d1		),
		.reg_f		( ff_reg_sl_e1		)
	);

	assign reg_ar0					= w_ar0;
	assign reg_dr0					= w_dr0;
	assign reg_sr0					= w_sr0;
	assign reg_rr0					= w_rr0;
	assign reg_sl0					= w_sl0;

	assign reg_ar1					= ff_reg_clone_adsr_a1 ? w_ar0 : w_ar1;
	assign reg_dr1					= ff_reg_clone_adsr_a1 ? w_dr0 : w_dr1;
	assign reg_sr1					= ff_reg_clone_adsr_a1 ? w_sr0 : w_sr1;
	assign reg_rr1					= ff_reg_clone_adsr_a1 ? w_rr0 : w_rr1;
	assign reg_sl1					= ff_reg_clone_adsr_a1 ? w_sl0 : w_sl1;

	// Key --------------------------------------------------------------------
	wts_selector #( 1 ) u_key_clone_selector(
		.active		( active					),
		.result		( w_reg_clone_key			),
		.reg_a		( 1'd0						),
		.reg_b		( ff_reg_clone_key_a1		),
		.reg_c		( ff_reg_clone_key_b1		),
		.reg_d		( ff_reg_clone_key_c1		),
		.reg_e		( ff_reg_clone_key_d1		),
		.reg_f		( ff_reg_clone_key_e1		)
	);

	assign ch0_key_on		= (active == ff_ch0_key) ? ff_ch0_key_on      : 1'b0;
	assign ch0_key_release	= (active == ff_ch0_key) ? ff_ch0_key_release : 1'b0;
	assign ch0_key_off		= (active == ff_ch0_key) ? ff_ch0_key_off     : 1'b0;

	assign ch1_key_on		= w_reg_clone_key ? ((active == ff_ch0_key) ? ff_ch0_key_on      : 1'b0) : ((active == ff_ch1_key) ? ff_ch1_key_on      : 1'b0);
	assign ch1_key_release	= w_reg_clone_key ? ((active == ff_ch0_key) ? ff_ch0_key_release : 1'b0) : ((active == ff_ch1_key) ? ff_ch1_key_release : 1'b0);
	assign ch1_key_off		= w_reg_clone_key ? ((active == ff_ch0_key) ? ff_ch0_key_off     : 1'b0) : ((active == ff_ch1_key) ? ff_ch1_key_off     : 1'b0);

	// Tone Parameters --------------------------------------------------------
	wts_selector #( 2 ) u_wave_length_selector0 (
		.active					( active					),
		.result					( reg_wave_length0			),
		.reg_a					( ff_reg_wave_length_a0		),
		.reg_b					( ff_reg_wave_length_b0		),
		.reg_c					( ff_reg_wave_length_c0		),
		.reg_d					( ff_reg_wave_length_d0		),
		.reg_e					( ff_reg_wave_length_e0		),
		.reg_f					( 2'd0						)
	);

	wts_selector #( 12 ) u_wave_frequency_count_selector0 (
		.active					( active					),
		.result					( reg_frequency_count0		),
		.reg_a					( ff_reg_frequency_count_a0	),
		.reg_b					( ff_reg_frequency_count_b0	),
		.reg_c					( ff_reg_frequency_count_c0	),
		.reg_d					( ff_reg_frequency_count_d0	),
		.reg_e					( ff_reg_frequency_count_e0	),
		.reg_f					( 12'd0						)
	);

	wts_selector #( 2 ) u_wave_length_selector1 (
		.active					( active					),
		.result					( reg_wave_length1			),
		.reg_a					( w_reg_wave_length_a1		),
		.reg_b					( w_reg_wave_length_b1		),
		.reg_c					( w_reg_wave_length_c1		),
		.reg_d					( w_reg_wave_length_d1		),
		.reg_e					( w_reg_wave_length_e1		),
		.reg_f					( 2'd0						)
	);

	wts_selector #( 12 ) u_wave_frequency_count_selector1 (
		.active					( active					),
		.result					( reg_frequency_count1		),
		.reg_a					( w_reg_frequency_count_a1	),
		.reg_b					( w_reg_frequency_count_b1	),
		.reg_c					( w_reg_frequency_count_c1	),
		.reg_d					( w_reg_frequency_count_d1	),
		.reg_e					( w_reg_frequency_count_e1	),
		.reg_f					( 12'd0						)
	);

	// Other Parameters -------------------------------------------------------
	wts_selector #( 4 ) u_volume_selector0 (
		.active		( active				),
		.result		( reg_volume0			),		//	delay 3 clock
		.reg_a		( ff_reg_volume_d0		),
		.reg_b		( ff_reg_volume_e0		),
		.reg_c		( 4'd0					),
		.reg_d		( ff_reg_volume_a0		),
		.reg_e		( ff_reg_volume_b0		),
		.reg_f		( ff_reg_volume_c0		)
	);

	wts_selector #( 4 ) u_volume_selector1 (
		.active		( active				),
		.result		( reg_volume1			),		//	delay 3 clock
		.reg_a		( ff_reg_volume_d1		),
		.reg_b		( ff_reg_volume_e1		),
		.reg_c		( 4'd1					),
		.reg_d		( ff_reg_volume_a1		),
		.reg_e		( ff_reg_volume_b1		),
		.reg_f		( ff_reg_volume_c1		)
	);

	wts_selector #( 2 ) u_enable_selector0 (
		.active		( active				),
		.result		( reg_enable0			),		//	delay 4 clock
		.reg_a		( ff_reg_enable_c0		),
		.reg_b		( ff_reg_enable_d0		),
		.reg_c		( ff_reg_enable_e0		),
		.reg_d		( 2'd0					),
		.reg_e		( ff_reg_enable_a0		),
		.reg_f		( ff_reg_enable_b0		)
	);

	wts_selector #( 2 ) u_enable_selector1 (
		.active		( active				),
		.result		( reg_enable1			),		//	delay 4 clock
		.reg_a		( ff_reg_enable_c1		),
		.reg_b		( ff_reg_enable_d1		),
		.reg_c		( ff_reg_enable_e1		),
		.reg_d		( 2'd0					),
		.reg_e		( ff_reg_enable_a1		),
		.reg_f		( ff_reg_enable_b1		)
	);
endmodule
