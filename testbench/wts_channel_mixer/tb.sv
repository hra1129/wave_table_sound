module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				nreset;
	reg				clk;

	reg				ch0_key_on;
	reg				ch0_key_release;
	reg				ch0_key_off;

	reg				ch1_key_on;
	reg				ch1_key_release;
	reg				ch1_key_off;

	reg				sram_ce0;
	reg				sram_ce1;
	reg		[2:0]	sram_id;
	reg		[6:0]	sram_a;
	reg		[7:0]	sram_d;
	reg				sram_oe;
	reg				sram_we;
	wire	[7:0]	sram_q;
	wire			sram_q_en;

	wire	[2:0]	active;
	reg				adsr_en;
	reg				reg_scci_enable;

	wire	[11:0]	left_out;
	wire	[11:0]	right_out;

	reg		[7:0]	reg_ar0;
	reg		[7:0]	reg_dr0;
	reg		[7:0]	reg_sr0;
	reg		[7:0]	reg_rr0;
	reg		[5:0]	reg_sl0;
	reg		[1:0]	reg_wave_length0;
	reg		[11:0]	reg_frequency_count0;
	reg		[3:0]	reg_volume0;
	reg		[1:0]	reg_enable0;

	reg		[7:0]	reg_ar1;
	reg		[7:0]	reg_dr1;
	reg		[7:0]	reg_sr1;
	reg		[7:0]	reg_rr1;
	reg		[5:0]	reg_sl1;
	reg		[1:0]	reg_wave_length1;
	reg		[11:0]	reg_frequency_count1;
	reg		[3:0]	reg_volume1;
	reg		[1:0]	reg_enable1;

	reg				reg_noise_enable_a0;
	reg		[1:0]	reg_noise_sel_a0;
	reg				reg_noise_enable_b0;
	reg		[1:0]	reg_noise_sel_b0;
	reg				reg_noise_enable_c0;
	reg		[1:0]	reg_noise_sel_c0;
	reg				reg_noise_enable_d0;
	reg		[1:0]	reg_noise_sel_d0;
	reg				reg_noise_enable_e0;
	reg		[1:0]	reg_noise_sel_e0;
	reg				reg_noise_enable_a1;
	reg		[1:0]	reg_noise_sel_a1;
	reg				reg_noise_enable_b1;
	reg		[1:0]	reg_noise_sel_b1;
	reg				reg_noise_enable_c1;
	reg		[1:0]	reg_noise_sel_c1;
	reg				reg_noise_enable_d1;
	reg		[1:0]	reg_noise_sel_d1;
	reg				reg_noise_enable_e1;
	reg		[1:0]	reg_noise_sel_e1;

	reg		[4:0]	reg_noise_frequency0;
	reg		[4:0]	reg_noise_frequency1;
	reg		[4:0]	reg_noise_frequency2;
	reg		[4:0]	reg_noise_frequency3;

	reg		[3:0]	reg_timer1_channel;
	wire			timer1_trigger;
	wire	[1:0]	timer1_address;
	reg		[3:0]	reg_timer2_channel;
	wire			timer2_trigger;
	wire	[1:0]	timer2_address;

	reg				reg_wave_reset;
	reg				clear_counter_a0;
	reg				clear_counter_b0;
	reg				clear_counter_c0;
	reg				clear_counter_d0;
	reg				clear_counter_e0;
	reg				clear_counter_a1;
	reg				clear_counter_b1;
	reg				clear_counter_c1;
	reg				clear_counter_d1;
	reg				clear_counter_e1;

	int				i, j;
	int				pattern_no = 0;
	int				error_count = 0;

	// -------------------------------------------------------------
	//	clock generator
	// -------------------------------------------------------------
	always #(CLK_BASE/2) begin
		clk	<= ~clk;
	end

	// -------------------------------------------------------------
	//	DUT
	// -------------------------------------------------------------
	wts_channel_mixer u_channel_mixer (
		.nreset						( nreset					),
		.clk						( clk						),
		.ch0_key_on					( ch0_key_on				),
		.ch0_key_release			( ch0_key_release			),
		.ch0_key_off				( ch0_key_off				),
		.ch1_key_on					( ch1_key_on				),
		.ch1_key_release			( ch1_key_release			),
		.ch1_key_off				( ch1_key_off				),
		.sram_ce0					( sram_ce0					),
		.sram_ce1					( sram_ce1					),
		.sram_id					( sram_id					),
		.sram_a						( sram_a					),
		.sram_d						( sram_d					),
		.sram_oe					( sram_oe					),
		.sram_we					( sram_we					),
		.sram_q						( sram_q					),
		.sram_q_en					( sram_q_en					),
		.active						( active					),
		.adsr_en					( adsr_en					),
		.reg_scci_enable			( reg_scci_enable			),
		.left_out					( left_out					),
		.right_out					( right_out					),
		.reg_ar0					( reg_ar0					),
		.reg_dr0					( reg_dr0					),
		.reg_sr0					( reg_sr0					),
		.reg_rr0					( reg_rr0					),
		.reg_sl0					( reg_sl0					),
		.reg_wave_length0			( reg_wave_length0			),
		.reg_frequency_count0		( reg_frequency_count0		),
		.reg_volume0				( reg_volume0				),
		.reg_enable0				( reg_enable0				),
		.reg_ar1					( reg_ar1					),
		.reg_dr1					( reg_dr1					),
		.reg_sr1					( reg_sr1					),
		.reg_rr1					( reg_rr1					),
		.reg_sl1					( reg_sl1					),
		.reg_wave_length1			( reg_wave_length1			),
		.reg_frequency_count1		( reg_frequency_count1		),
		.reg_volume1				( reg_volume1				),
		.reg_enable1				( reg_enable1				),
		.reg_noise_enable_a0		( reg_noise_enable_a0		),
		.reg_noise_sel_a0			( reg_noise_sel_a0			),
		.reg_noise_enable_b0		( reg_noise_enable_b0		),
		.reg_noise_sel_b0			( reg_noise_sel_b0			),
		.reg_noise_enable_c0		( reg_noise_enable_c0		),
		.reg_noise_sel_c0			( reg_noise_sel_c0			),
		.reg_noise_enable_d0		( reg_noise_enable_d0		),
		.reg_noise_sel_d0			( reg_noise_sel_d0			),
		.reg_noise_enable_e0		( reg_noise_enable_e0		),
		.reg_noise_sel_e0			( reg_noise_sel_e0			),
		.reg_noise_enable_a1		( reg_noise_enable_a1		),
		.reg_noise_sel_a1			( reg_noise_sel_a1			),
		.reg_noise_enable_b1		( reg_noise_enable_b1		),
		.reg_noise_sel_b1			( reg_noise_sel_b1			),
		.reg_noise_enable_c1		( reg_noise_enable_c1		),
		.reg_noise_sel_c1			( reg_noise_sel_c1			),
		.reg_noise_enable_d1		( reg_noise_enable_d1		),
		.reg_noise_sel_d1			( reg_noise_sel_d1			),
		.reg_noise_enable_e1		( reg_noise_enable_e1		),
		.reg_noise_sel_e1			( reg_noise_sel_e1			),
		.reg_noise_frequency0		( reg_noise_frequency0		),
		.reg_noise_frequency1		( reg_noise_frequency1		),
		.reg_noise_frequency2		( reg_noise_frequency2		),
		.reg_noise_frequency3		( reg_noise_frequency3		),
		.reg_timer1_channel			( reg_timer1_channel		),
		.timer1_trigger				( timer1_trigger			),
		.timer1_address				( timer1_address			),
		.reg_timer2_channel			( reg_timer2_channel		),
		.timer2_trigger				( timer2_trigger			),
		.timer2_address				( timer2_address			),
		.reg_wave_reset				( reg_wave_reset			),
		.clear_counter_a0			( clear_counter_a0			),
		.clear_counter_b0			( clear_counter_b0			),
		.clear_counter_c0			( clear_counter_c0			),
		.clear_counter_d0			( clear_counter_d0			),
		.clear_counter_e0			( clear_counter_e0			),
		.clear_counter_a1			( clear_counter_a1			),
		.clear_counter_b1			( clear_counter_b1			),
		.clear_counter_c1			( clear_counter_c1			),
		.clear_counter_d1			( clear_counter_d1			),
		.clear_counter_e1			( clear_counter_e1			)
	);

	// -------------------------------------------------------------
	task set_test_pattern_no(
		input int		_pattern_no,
		input string	s_pattern_description
	);
		pattern_no		= _pattern_no;
		$display( "------------------------------------------------------------" );
		$display( "[%t] %3d: %s", $realtime, pattern_no, s_pattern_description );
	endtask

	// -------------------------------------------------------------
	task success_condition_is(
		input int		condition,
		input string	s_error_message
	);
		if( !condition ) begin
			$display( "[%t] %s", $realtime, s_error_message );
			error_count++;
		end
	endtask

	// -------------------------------------------------------------
	task end_of_test();
		if( error_count ) begin
			$display( "#####################################" );
			$display( "#                                   #" );
			$display( "   Found %d error(s)", error_count );
			$display( "#                                   #" );
			$display( "#####################################" );
		end
		else begin
			$display( "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" );
			$display( "$                                   $" );
			$display( "$        Success of all!!           $" );
			$display( "$                                   $" );
			$display( "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" );
		end
		$finish;
	endtask

	// -------------------------------------------------------------
	task write_sram(
		input	[2:0]	_sram_id,
		input	[6:0]	_sram_a,
		input	[7:0]	_sram_d
	);
		sram_id	<= _sram_id;
		sram_a	<= _sram_a;
		sram_d	<= _sram_d;
		sram_oe	<= 1'b0;
		sram_we	<= 1'b1;
		@( posedge clk );

		sram_id	<= 0;
		sram_a	<= 0;
		sram_d	<= 0;
		sram_oe	<= 1'b0;
		sram_we	<= 1'b0;
		@( posedge clk );
		@( posedge clk );
	endtask

	// -------------------------------------------------------------
	//	test scenario
	// -------------------------------------------------------------
	initial begin

		//	initialization
		nreset = 0;
		clk = 0;

		ch0_key_on = 0;
		ch0_key_release = 0;
		ch0_key_off = 0;

		ch1_key_on = 0;
		ch1_key_release = 0;
		ch1_key_off = 0;

		sram_ce0 = 0;
		sram_ce1 = 0;
		sram_id = 0;
		sram_a = 0;
		sram_d = 0;
		sram_oe = 0;
		sram_we = 0;

		reg_ar0 = 0;
		reg_dr0 = 0;
		reg_sr0 = 0;
		reg_rr0 = 0;
		reg_sl0 = 0;
		reg_wave_length0 = 0;
		reg_frequency_count0 = 0;
		reg_volume0 = 0;
		reg_enable0 = 0;

		reg_ar1 = 0;
		reg_dr1 = 0;
		reg_sr1 = 0;
		reg_rr1 = 0;
		reg_sl1 = 0;
		reg_wave_length1 = 0;
		reg_frequency_count1 = 0;
		reg_volume1 = 0;
		reg_enable1 = 0;

		reg_noise_enable_a0 = 0;
		reg_noise_sel_a0 = 0;
		reg_noise_enable_b0 = 0;
		reg_noise_sel_b0 = 0;
		reg_noise_enable_c0 = 0;
		reg_noise_sel_c0 = 0;
		reg_noise_enable_d0 = 0;
		reg_noise_sel_d0 = 0;
		reg_noise_enable_e0 = 0;
		reg_noise_sel_e0 = 0;
		reg_noise_enable_a1 = 0;
		reg_noise_sel_a1 = 0;
		reg_noise_enable_b1 = 0;
		reg_noise_sel_b1 = 0;
		reg_noise_enable_c1 = 0;
		reg_noise_sel_c1 = 0;
		reg_noise_enable_d1 = 0;
		reg_noise_sel_d1 = 0;
		reg_noise_enable_e1 = 0;
		reg_noise_sel_e1 = 0;

		reg_wave_reset = 0;
		clear_counter_a0 = 0;
		clear_counter_b0 = 0;
		clear_counter_c0 = 0;
		clear_counter_d0 = 0;
		clear_counter_e0 = 0;
		clear_counter_a1 = 0;
		clear_counter_b1 = 0;
		clear_counter_c1 = 0;
		clear_counter_d1 = 0;
		clear_counter_e1 = 0;

		reg_noise_frequency0 = 0;
		reg_noise_frequency1 = 0;
		reg_noise_frequency2 = 0;
		reg_noise_frequency3 = 0;

		reg_timer1_channel = 0;
		reg_timer2_channel = 0;

		repeat( 50 ) @( negedge clk );

		nreset = 1;
		repeat( 50 ) @( posedge clk );

		// -------------------------------------------------------------
		set_test_pattern_no( 1, "Initialize wave memory." );

		for( i = 0; i < 6; i++ ) begin
			for( j = 0; j < 128; j++ ) begin
				if( j < 64 ) begin
					write_sram( i, j, -128 );
				end
				else begin
					write_sram( i, j, 127 );
				end
			end
		end

		for( i = 0; i < 6; i++ ) begin
				if( j < 64 ) begin
					write_sram( i + 8, j, -128 );
				end
				else begin
					write_sram( i + 8, j, 127 );
				end
		end

		repeat( 50 ) @( posedge clk );

		// -------------------------------------------------------------
		set_test_pattern_no( 2, "Sound Ch.A." );

		reg_volume0 = 15;
		reg_enable0 = 3;
		reg_ar0 = 2;
		reg_dr0 = 20;
		reg_sr0 = 5000;
		reg_rr0 = 100;
		reg_sl0 = 220;
		reg_wave_length0 = 3;
		reg_frequency_count0 = 12;

		ch0_key_on = 1;
		ch0_key_release = 0;
		ch0_key_off = 0;
		repeat( 6 ) @( posedge clk );

		ch0_key_on = 0;
		ch0_key_release = 0;
		ch0_key_off = 0;
		repeat( 8000 ) @( posedge clk );

		ch0_key_on = 0;
		ch0_key_release = 1;
		ch0_key_off = 0;
		repeat( 6 ) @( posedge clk );

		ch0_key_on = 0;
		ch0_key_release = 0;
		ch0_key_off = 0;
		repeat( 30000 ) @( posedge clk );

		end_of_test();
	end
endmodule
