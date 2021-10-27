module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				nreset;
	reg				clk;

	reg				ch_a0_key_on;
	reg				ch_a0_key_release;
	reg				ch_a0_key_off;

	reg				ch_b0_key_on;
	reg				ch_b0_key_release;
	reg				ch_b0_key_off;

	reg				ch_c0_key_on;
	reg				ch_c0_key_release;
	reg				ch_c0_key_off;

	reg				ch_d0_key_on;
	reg				ch_d0_key_release;
	reg				ch_d0_key_off;

	reg				ch_e0_key_on;
	reg				ch_e0_key_release;
	reg				ch_e0_key_off;

	reg				ch_a1_key_on;
	reg				ch_a1_key_release;
	reg				ch_a1_key_off;

	reg				ch_b1_key_on;
	reg				ch_b1_key_release;
	reg				ch_b1_key_off;

	reg				ch_c1_key_on;
	reg				ch_c1_key_release;
	reg				ch_c1_key_off;

	reg				ch_d1_key_on;
	reg				ch_d1_key_release;
	reg				ch_d1_key_off;

	reg				ch_e1_key_on;
	reg				ch_e1_key_release;
	reg				ch_e1_key_off;

	reg		[3:0]	sram_id;
	reg		[6:0]	sram_a;
	reg		[7:0]	sram_d;
	reg				sram_oe;
	reg				sram_we;
	wire	[7:0]	sram_q;
	wire			sram_q_en;

	wire	[11:0]	left_out;
	wire	[11:0]	right_out;

	reg		[3:0]	reg_volume_a0;
	reg		[1:0]	reg_enable_a0;
	reg				reg_noise_enable_a0;
	reg		[15:0]	reg_ar_a0;
	reg		[15:0]	reg_dr_a0;
	reg		[15:0]	reg_sr_a0;
	reg		[15:0]	reg_rr_a0;
	reg		[7:0]	reg_sl_a0;
	reg		[1:0]	reg_wave_length_a0;
	reg		[11:0]	reg_frequency_count_a0;
	reg		[4:0]	reg_noise_frequency_a0;

	reg		[3:0]	reg_volume_b0;
	reg		[1:0]	reg_enable_b0;
	reg				reg_noise_enable_b0;
	reg		[15:0]	reg_ar_b0;
	reg		[15:0]	reg_dr_b0;
	reg		[15:0]	reg_sr_b0;
	reg		[15:0]	reg_rr_b0;
	reg		[7:0]	reg_sl_b0;
	reg		[1:0]	reg_wave_length_b0;
	reg		[11:0]	reg_frequency_count_b0;
	reg		[4:0]	reg_noise_frequency_b0;

	reg		[3:0]	reg_volume_c0;
	reg		[1:0]	reg_enable_c0;
	reg				reg_noise_enable_c0;
	reg		[15:0]	reg_ar_c0;
	reg		[15:0]	reg_dr_c0;
	reg		[15:0]	reg_sr_c0;
	reg		[15:0]	reg_rr_c0;
	reg		[7:0]	reg_sl_c0;
	reg		[1:0]	reg_wave_length_c0;
	reg		[11:0]	reg_frequency_count_c0;
	reg		[4:0]	reg_noise_frequency_c0;

	reg		[3:0]	reg_volume_d0;
	reg		[1:0]	reg_enable_d0;
	reg				reg_noise_enable_d0;
	reg		[15:0]	reg_ar_d0;
	reg		[15:0]	reg_dr_d0;
	reg		[15:0]	reg_sr_d0;
	reg		[15:0]	reg_rr_d0;
	reg		[7:0]	reg_sl_d0;
	reg		[1:0]	reg_wave_length_d0;
	reg		[11:0]	reg_frequency_count_d0;
	reg		[4:0]	reg_noise_frequency_d0;

	reg		[3:0]	reg_volume_e0;
	reg		[1:0]	reg_enable_e0;
	reg				reg_noise_enable_e0;
	reg		[15:0]	reg_ar_e0;
	reg		[15:0]	reg_dr_e0;
	reg		[15:0]	reg_sr_e0;
	reg		[15:0]	reg_rr_e0;
	reg		[7:0]	reg_sl_e0;
	reg		[1:0]	reg_wave_length_e0;
	reg		[11:0]	reg_frequency_count_e0;
	reg		[4:0]	reg_noise_frequency_e0;

	reg		[3:0]	reg_volume_a1;
	reg		[1:0]	reg_enable_a1;
	reg				reg_noise_enable_a1;
	reg		[15:0]	reg_ar_a1;
	reg		[15:0]	reg_dr_a1;
	reg		[15:0]	reg_sr_a1;
	reg		[15:0]	reg_rr_a1;
	reg		[7:0]	reg_sl_a1;
	reg		[1:0]	reg_wave_length_a1;
	reg		[11:0]	reg_frequency_count_a1;
	reg		[4:0]	reg_noise_frequency_a1;

	reg		[3:0]	reg_volume_b1;
	reg		[1:0]	reg_enable_b1;
	reg				reg_noise_enable_b1;
	reg		[15:0]	reg_ar_b1;
	reg		[15:0]	reg_dr_b1;
	reg		[15:0]	reg_sr_b1;
	reg		[15:0]	reg_rr_b1;
	reg		[7:0]	reg_sl_b1;
	reg		[1:0]	reg_wave_length_b1;
	reg		[11:0]	reg_frequency_count_b1;
	reg		[4:0]	reg_noise_frequency_b1;

	reg		[3:0]	reg_volume_c1;
	reg		[1:0]	reg_enable_c1;
	reg				reg_noise_enable_c1;
	reg		[15:0]	reg_ar_c1;
	reg		[15:0]	reg_dr_c1;
	reg		[15:0]	reg_sr_c1;
	reg		[15:0]	reg_rr_c1;
	reg		[7:0]	reg_sl_c1;
	reg		[1:0]	reg_wave_length_c1;
	reg		[11:0]	reg_frequency_count_c1;
	reg		[4:0]	reg_noise_frequency_c1;

	reg		[3:0]	reg_volume_d1;
	reg		[1:0]	reg_enable_d1;
	reg				reg_noise_enable_d1;
	reg		[15:0]	reg_ar_d1;
	reg		[15:0]	reg_dr_d1;
	reg		[15:0]	reg_sr_d1;
	reg		[15:0]	reg_rr_d1;
	reg		[7:0]	reg_sl_d1;
	reg		[1:0]	reg_wave_length_d1;
	reg		[11:0]	reg_frequency_count_d1;
	reg		[4:0]	reg_noise_frequency_d1;

	reg		[3:0]	reg_volume_e1;
	reg		[1:0]	reg_enable_e1;
	reg				reg_noise_enable_e1;
	reg		[15:0]	reg_ar_e1;
	reg		[15:0]	reg_dr_e1;
	reg		[15:0]	reg_sr_e1;
	reg		[15:0]	reg_rr_e1;
	reg		[7:0]	reg_sl_e1;
	reg		[1:0]	reg_wave_length_e1;
	reg		[11:0]	reg_frequency_count_e1;
	reg		[4:0]	reg_noise_frequency_e1;

	reg		[3:0]	reg_timer1_channel;
	wire			timer1_trigger;
	wire	[6:0]	timer1_address;
	reg		[3:0]	reg_timer2_channel;
	wire			timer2_trigger;
	wire	[6:0]	timer2_address;

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
		.ch_a0_key_on				( ch_a0_key_on				),
		.ch_a0_key_release			( ch_a0_key_release			),
		.ch_a0_key_off				( ch_a0_key_off				),
		.ch_b0_key_on				( ch_b0_key_on				),
		.ch_b0_key_release			( ch_b0_key_release			),
		.ch_b0_key_off				( ch_b0_key_off				),
		.ch_c0_key_on				( ch_c0_key_on				),
		.ch_c0_key_release			( ch_c0_key_release			),
		.ch_c0_key_off				( ch_c0_key_off				),
		.ch_d0_key_on				( ch_d0_key_on				),
		.ch_d0_key_release			( ch_d0_key_release			),
		.ch_d0_key_off				( ch_d0_key_off				),
		.ch_e0_key_on				( ch_e0_key_on				),
		.ch_e0_key_release			( ch_e0_key_release			),
		.ch_e0_key_off				( ch_e0_key_off				),
		.ch_a1_key_on				( ch_a1_key_on				),
		.ch_a1_key_release			( ch_a1_key_release			),
		.ch_a1_key_off				( ch_a1_key_off				),
		.ch_b1_key_on				( ch_b1_key_on				),
		.ch_b1_key_release			( ch_b1_key_release			),
		.ch_b1_key_off				( ch_b1_key_off				),
		.ch_c1_key_on				( ch_c1_key_on				),
		.ch_c1_key_release			( ch_c1_key_release			),
		.ch_c1_key_off				( ch_c1_key_off				),
		.ch_d1_key_on				( ch_d1_key_on				),
		.ch_d1_key_release			( ch_d1_key_release			),
		.ch_d1_key_off				( ch_d1_key_off				),
		.ch_e1_key_on				( ch_e1_key_on				),
		.ch_e1_key_release			( ch_e1_key_release			),
		.ch_e1_key_off				( ch_e1_key_off				),
		.sram_id					( sram_id					),
		.sram_a						( sram_a					),
		.sram_d						( sram_d					),
		.sram_oe					( sram_oe					),
		.sram_we					( sram_we					),
		.sram_q						( sram_q					),
		.sram_q_en					( sram_q_en					),
		.left_out					( left_out					),
		.right_out					( right_out					),
		.reg_volume_a0				( reg_volume_a0				),
		.reg_enable_a0				( reg_enable_a0				),
		.reg_noise_enable_a0		( reg_noise_enable_a0		),
		.reg_ar_a0					( reg_ar_a0					),
		.reg_dr_a0					( reg_dr_a0					),
		.reg_sr_a0					( reg_sr_a0					),
		.reg_rr_a0					( reg_rr_a0					),
		.reg_sl_a0					( reg_sl_a0					),
		.reg_wave_length_a0			( reg_wave_length_a0		),
		.reg_frequency_count_a0		( reg_frequency_count_a0	),
		.reg_noise_frequency_a0		( reg_noise_frequency_a0	),
		.reg_volume_b0				( reg_volume_b0				),
		.reg_enable_b0				( reg_enable_b0				),
		.reg_noise_enable_b0		( reg_noise_enable_b0		),
		.reg_ar_b0					( reg_ar_b0					),
		.reg_dr_b0					( reg_dr_b0					),
		.reg_sr_b0					( reg_sr_b0					),
		.reg_rr_b0					( reg_rr_b0					),
		.reg_sl_b0					( reg_sl_b0					),
		.reg_wave_length_b0			( reg_wave_length_b0		),
		.reg_frequency_count_b0		( reg_frequency_count_b0	),
		.reg_noise_frequency_b0		( reg_noise_frequency_b0	),
		.reg_volume_c0				( reg_volume_c0				),
		.reg_enable_c0				( reg_enable_c0				),
		.reg_noise_enable_c0		( reg_noise_enable_c0		),
		.reg_ar_c0					( reg_ar_c0					),
		.reg_dr_c0					( reg_dr_c0					),
		.reg_sr_c0					( reg_sr_c0					),
		.reg_rr_c0					( reg_rr_c0					),
		.reg_sl_c0					( reg_sl_c0					),
		.reg_wave_length_c0			( reg_wave_length_c0		),
		.reg_frequency_count_c0		( reg_frequency_count_c0	),
		.reg_noise_frequency_c0		( reg_noise_frequency_c0	),
		.reg_volume_d0				( reg_volume_d0				),
		.reg_enable_d0				( reg_enable_d0				),
		.reg_noise_enable_d0		( reg_noise_enable_d0		),
		.reg_ar_d0					( reg_ar_d0					),
		.reg_dr_d0					( reg_dr_d0					),
		.reg_sr_d0					( reg_sr_d0					),
		.reg_rr_d0					( reg_rr_d0					),
		.reg_sl_d0					( reg_sl_d0					),
		.reg_wave_length_d0			( reg_wave_length_d0		),
		.reg_frequency_count_d0		( reg_frequency_count_d0	),
		.reg_noise_frequency_d0		( reg_noise_frequency_d0	),
		.reg_volume_e0				( reg_volume_e0				),
		.reg_enable_e0				( reg_enable_e0				),
		.reg_noise_enable_e0		( reg_noise_enable_e0		),
		.reg_ar_e0					( reg_ar_e0					),
		.reg_dr_e0					( reg_dr_e0					),
		.reg_sr_e0					( reg_sr_e0					),
		.reg_rr_e0					( reg_rr_e0					),
		.reg_sl_e0					( reg_sl_e0					),
		.reg_wave_length_e0			( reg_wave_length_e0		),
		.reg_frequency_count_e0		( reg_frequency_count_e0	),
		.reg_noise_frequency_e0		( reg_noise_frequency_e0	),
		.reg_volume_a1				( reg_volume_a1				),
		.reg_enable_a1				( reg_enable_a1				),
		.reg_noise_enable_a1		( reg_noise_enable_a1		),
		.reg_ar_a1					( reg_ar_a1					),
		.reg_dr_a1					( reg_dr_a1					),
		.reg_sr_a1					( reg_sr_a1					),
		.reg_rr_a1					( reg_rr_a1					),
		.reg_sl_a1					( reg_sl_a1					),
		.reg_wave_length_a1			( reg_wave_length_a1		),
		.reg_frequency_count_a1		( reg_frequency_count_a1	),
		.reg_noise_frequency_a1		( reg_noise_frequency_a1	),
		.reg_volume_b1				( reg_volume_b1				),
		.reg_enable_b1				( reg_enable_b1				),
		.reg_noise_enable_b1		( reg_noise_enable_b1		),
		.reg_ar_b1					( reg_ar_b1					),
		.reg_dr_b1					( reg_dr_b1					),
		.reg_sr_b1					( reg_sr_b1					),
		.reg_rr_b1					( reg_rr_b1					),
		.reg_sl_b1					( reg_sl_b1					),
		.reg_wave_length_b1			( reg_wave_length_b1		),
		.reg_frequency_count_b1		( reg_frequency_count_b1	),
		.reg_noise_frequency_b1		( reg_noise_frequency_b1	),
		.reg_volume_c1				( reg_volume_c1				),
		.reg_enable_c1				( reg_enable_c1				),
		.reg_noise_enable_c1		( reg_noise_enable_c1		),
		.reg_ar_c1					( reg_ar_c1					),
		.reg_dr_c1					( reg_dr_c1					),
		.reg_sr_c1					( reg_sr_c1					),
		.reg_rr_c1					( reg_rr_c1					),
		.reg_sl_c1					( reg_sl_c1					),
		.reg_wave_length_c1			( reg_wave_length_c1		),
		.reg_frequency_count_c1		( reg_frequency_count_c1	),
		.reg_noise_frequency_c1		( reg_noise_frequency_c1	),
		.reg_volume_d1				( reg_volume_d1				),
		.reg_enable_d1				( reg_enable_d1				),
		.reg_noise_enable_d1		( reg_noise_enable_d1		),
		.reg_ar_d1					( reg_ar_d1					),
		.reg_dr_d1					( reg_dr_d1					),
		.reg_sr_d1					( reg_sr_d1					),
		.reg_rr_d1					( reg_rr_d1					),
		.reg_sl_d1					( reg_sl_d1					),
		.reg_wave_length_d1			( reg_wave_length_d1		),
		.reg_frequency_count_d1		( reg_frequency_count_d1	),
		.reg_noise_frequency_d1		( reg_noise_frequency_d1	),
		.reg_volume_e1				( reg_volume_e1				),
		.reg_enable_e1				( reg_enable_e1				),
		.reg_noise_enable_e1		( reg_noise_enable_e1		),
		.reg_ar_e1					( reg_ar_e1					),
		.reg_dr_e1					( reg_dr_e1					),
		.reg_sr_e1					( reg_sr_e1					),
		.reg_rr_e1					( reg_rr_e1					),
		.reg_sl_e1					( reg_sl_e1					),
		.reg_wave_length_e1			( reg_wave_length_e1		),
		.reg_frequency_count_e1		( reg_frequency_count_e1	),
		.reg_noise_frequency_e1		( reg_noise_frequency_e1	),
		.reg_timer1_channel			( reg_timer1_channel		),
		.timer1_trigger				( timer1_trigger			),
		.timer1_address				( timer1_address			),
		.reg_timer2_channel			( reg_timer2_channel		),
		.timer2_trigger				( timer2_trigger			),
		.timer2_address				( timer2_address			)
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
		input	[3:0]	_sram_id,
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

		ch_a0_key_on = 0;
		ch_a0_key_release = 0;
		ch_a0_key_off = 0;

		ch_b0_key_on = 0;
		ch_b0_key_release = 0;
		ch_b0_key_off = 0;

		ch_c0_key_on = 0;
		ch_c0_key_release = 0;
		ch_c0_key_off = 0;

		ch_d0_key_on = 0;
		ch_d0_key_release = 0;
		ch_d0_key_off = 0;

		ch_e0_key_on = 0;
		ch_e0_key_release = 0;
		ch_e0_key_off = 0;

		ch_a1_key_on = 0;
		ch_a1_key_release = 0;
		ch_a1_key_off = 0;

		ch_b1_key_on = 0;
		ch_b1_key_release = 0;
		ch_b1_key_off = 0;

		ch_c1_key_on = 0;
		ch_c1_key_release = 0;
		ch_c1_key_off = 0;

		ch_d1_key_on = 0;
		ch_d1_key_release = 0;
		ch_d1_key_off = 0;

		ch_e1_key_on = 0;
		ch_e1_key_release = 0;
		ch_e1_key_off = 0;

		sram_id = 0;
		sram_a = 0;
		sram_d = 0;
		sram_oe = 0;
		sram_we = 0;

		reg_volume_a0 = 0;
		reg_enable_a0 = 0;
		reg_noise_enable_a0 = 0;
		reg_ar_a0 = 0;
		reg_dr_a0 = 0;
		reg_sr_a0 = 0;
		reg_rr_a0 = 0;
		reg_sl_a0 = 0;
		reg_wave_length_a0 = 0;
		reg_frequency_count_a0 = 0;
		reg_noise_frequency_a0 = 0;

		reg_volume_b0 = 0;
		reg_enable_b0 = 0;
		reg_noise_enable_b0 = 0;
		reg_ar_b0 = 0;
		reg_dr_b0 = 0;
		reg_sr_b0 = 0;
		reg_rr_b0 = 0;
		reg_sl_b0 = 0;
		reg_wave_length_b0 = 0;
		reg_frequency_count_b0 = 0;
		reg_noise_frequency_b0 = 0;

		reg_volume_c0 = 0;
		reg_enable_c0 = 0;
		reg_noise_enable_c0 = 0;
		reg_ar_c0 = 0;
		reg_dr_c0 = 0;
		reg_sr_c0 = 0;
		reg_rr_c0 = 0;
		reg_sl_c0 = 0;
		reg_wave_length_c0 = 0;
		reg_frequency_count_c0 = 0;
		reg_noise_frequency_c0 = 0;

		reg_volume_d0 = 0;
		reg_enable_d0 = 0;
		reg_noise_enable_d0 = 0;
		reg_ar_d0 = 0;
		reg_dr_d0 = 0;
		reg_sr_d0 = 0;
		reg_rr_d0 = 0;
		reg_sl_d0 = 0;
		reg_wave_length_d0 = 0;
		reg_frequency_count_d0 = 0;
		reg_noise_frequency_d0 = 0;

		reg_volume_e0 = 0;
		reg_enable_e0 = 0;
		reg_noise_enable_e0 = 0;
		reg_ar_e0 = 0;
		reg_dr_e0 = 0;
		reg_sr_e0 = 0;
		reg_rr_e0 = 0;
		reg_sl_e0 = 0;
		reg_wave_length_e0 = 0;
		reg_frequency_count_e0 = 0;
		reg_noise_frequency_e0 = 0;

		reg_volume_a1 = 0;
		reg_enable_a1 = 0;
		reg_noise_enable_a1 = 0;
		reg_ar_a1 = 0;
		reg_dr_a1 = 0;
		reg_sr_a1 = 0;
		reg_rr_a1 = 0;
		reg_sl_a1 = 0;
		reg_wave_length_a1 = 0;
		reg_frequency_count_a1 = 0;
		reg_noise_frequency_a1 = 0;

		reg_volume_b1 = 0;
		reg_enable_b1 = 0;
		reg_noise_enable_b1 = 0;
		reg_ar_b1 = 0;
		reg_dr_b1 = 0;
		reg_sr_b1 = 0;
		reg_rr_b1 = 0;
		reg_sl_b1 = 0;
		reg_wave_length_b1 = 0;
		reg_frequency_count_b1 = 0;
		reg_noise_frequency_b1 = 0;

		reg_volume_c1 = 0;
		reg_enable_c1 = 0;
		reg_noise_enable_c1 = 0;
		reg_ar_c1 = 0;
		reg_dr_c1 = 0;
		reg_sr_c1 = 0;
		reg_rr_c1 = 0;
		reg_sl_c1 = 0;
		reg_wave_length_c1 = 0;
		reg_frequency_count_c1 = 0;
		reg_noise_frequency_c1 = 0;

		reg_volume_d1 = 0;
		reg_enable_d1 = 0;
		reg_noise_enable_d1 = 0;
		reg_ar_d1 = 0;
		reg_dr_d1 = 0;
		reg_sr_d1 = 0;
		reg_rr_d1 = 0;
		reg_sl_d1 = 0;
		reg_wave_length_d1 = 0;
		reg_frequency_count_d1 = 0;
		reg_noise_frequency_d1 = 0;

		reg_volume_e1 = 0;
		reg_enable_e1 = 0;
		reg_noise_enable_e1 = 0;
		reg_ar_e1 = 0;
		reg_dr_e1 = 0;
		reg_sr_e1 = 0;
		reg_rr_e1 = 0;
		reg_sl_e1 = 0;
		reg_wave_length_e1 = 0;
		reg_frequency_count_e1 = 0;
		reg_noise_frequency_e1 = 0;

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

		reg_volume_a0 = 15;
		reg_enable_a0 = 3;
		reg_noise_enable_a0 = 0;
		reg_ar_a0 = 2;
		reg_dr_a0 = 20;
		reg_sr_a0 = 5000;
		reg_rr_a0 = 100;
		reg_sl_a0 = 220;
		reg_wave_length_a0 = 3;
		reg_frequency_count_a0 = 12;
		reg_noise_frequency_a0 = 0;

		ch_a0_key_on = 1;
		ch_a0_key_release = 0;
		ch_a0_key_off = 0;
		repeat( 6 ) @( posedge clk );

		ch_a0_key_on = 0;
		ch_a0_key_release = 0;
		ch_a0_key_off = 0;
		repeat( 8000 ) @( posedge clk );

		ch_a0_key_on = 0;
		ch_a0_key_release = 1;
		ch_a0_key_off = 0;
		repeat( 6 ) @( posedge clk );

		ch_a0_key_on = 0;
		ch_a0_key_release = 0;
		ch_a0_key_off = 0;
		repeat( 30000 ) @( posedge clk );

		reg_volume_b0 = 15;
		reg_enable_b0 = 3;
		reg_noise_enable_b0 = 0;
		reg_ar_b0 = 1;
		reg_dr_b0 = 10;
		reg_sr_b0 = 500;
		reg_rr_b0 = 50;
		reg_sl_b0 = 120;
		reg_wave_length_b0 = 3;
		reg_frequency_count_b0 = 80;
		reg_noise_frequency_b0 = 0;

		ch_b0_key_on = 1;
		ch_b0_key_release = 0;
		ch_b0_key_off = 0;
		repeat( 6 ) @( posedge clk );

		ch_b0_key_on = 0;
		ch_b0_key_release = 0;
		ch_b0_key_off = 0;
		repeat( 8000 ) @( posedge clk );

		ch_b0_key_on = 0;
		ch_b0_key_release = 1;
		ch_b0_key_off = 0;
		repeat( 6 ) @( posedge clk );

		ch_b0_key_on = 0;
		ch_b0_key_release = 0;
		ch_b0_key_off = 0;
		repeat( 30000 ) @( posedge clk );

		end_of_test();
	end
endmodule
