module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				nreset;					//	negative logic
	reg				clk;
	reg		[2:0]	active;					//	0...4 : channel index; 5 : no operation
	wire	[6:0]	envelope;

	reg				ch_a_key_on;
	reg				ch_a_key_release;
	reg				ch_a_key_off;

	reg				ch_b_key_on;
	reg				ch_b_key_release;
	reg				ch_b_key_off;

	reg				ch_c_key_on;
	reg				ch_c_key_release;
	reg				ch_c_key_off;

	reg				ch_d_key_on;
	reg				ch_d_key_release;
	reg				ch_d_key_off;

	reg				ch_e_key_on;
	reg				ch_e_key_release;
	reg				ch_e_key_off;

	reg		[7:0]	reg_ar_a;
	reg		[7:0]	reg_dr_a;
	reg		[7:0]	reg_sr_a;
	reg		[7:0]	reg_rr_a;
	reg		[5:0]	reg_sl_a;
	reg		[1:0]	reg_wave_length_a;
	reg		[11:0]	reg_frequency_count_a;

	reg		[7:0]	reg_ar_b;
	reg		[7:0]	reg_dr_b;
	reg		[7:0]	reg_sr_b;
	reg		[7:0]	reg_rr_b;
	reg		[5:0]	reg_sl_b;
	reg		[1:0]	reg_wave_length_b;
	reg		[11:0]	reg_frequency_count_b;

	reg		[7:0]	reg_ar_c;
	reg		[7:0]	reg_dr_c;
	reg		[7:0]	reg_sr_c;
	reg		[7:0]	reg_rr_c;
	reg		[5:0]	reg_sl_c;
	reg		[1:0]	reg_wave_length_c;
	reg		[11:0]	reg_frequency_count_c;

	reg		[7:0]	reg_ar_d;
	reg		[7:0]	reg_dr_d;
	reg		[7:0]	reg_sr_d;
	reg		[7:0]	reg_rr_d;
	reg		[5:0]	reg_sl_d;
	reg		[1:0]	reg_wave_length_d;
	reg		[11:0]	reg_frequency_count_d;

	reg		[7:0]	reg_ar_e;
	reg		[7:0]	reg_dr_e;
	reg		[7:0]	reg_sr_e;
	reg		[7:0]	reg_rr_e;
	reg		[5:0]	reg_sl_e;
	reg		[1:0]	reg_wave_length_e;
	reg		[11:0]	reg_frequency_count_e;

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
	wts_adsr_envelope_generator_5ch u_wts_adsr_envelope_generator_5ch (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( active					),
		.envelope					( envelope					),
		.ch_a_key_on				( ch_a_key_on				),
		.ch_a_key_release			( ch_a_key_release			),
		.ch_a_key_off				( ch_a_key_off				),
		.ch_b_key_on				( ch_b_key_on				),
		.ch_b_key_release			( ch_b_key_release			),
		.ch_b_key_off				( ch_b_key_off				),
		.ch_c_key_on				( ch_c_key_on				),
		.ch_c_key_release			( ch_c_key_release			),
		.ch_c_key_off				( ch_c_key_off				),
		.ch_d_key_on				( ch_d_key_on				),
		.ch_d_key_release			( ch_d_key_release			),
		.ch_d_key_off				( ch_d_key_off				),
		.ch_e_key_on				( ch_e_key_on				),
		.ch_e_key_release			( ch_e_key_release			),
		.ch_e_key_off				( ch_e_key_off				),
		.reg_ar_a					( reg_ar_a					),
		.reg_dr_a					( reg_dr_a					),
		.reg_sr_a					( reg_sr_a					),
		.reg_rr_a					( reg_rr_a					),
		.reg_sl_a					( reg_sl_a					),
		.reg_wave_length_a			( reg_wave_length_a			),
		.reg_frequency_count_a		( reg_frequency_count_a		),
		.reg_ar_b					( reg_ar_b					),
		.reg_dr_b					( reg_dr_b					),
		.reg_sr_b					( reg_sr_b					),
		.reg_rr_b					( reg_rr_b					),
		.reg_sl_b					( reg_sl_b					),
		.reg_wave_length_b			( reg_wave_length_b			),
		.reg_frequency_count_b		( reg_frequency_count_b		),
		.reg_ar_c					( reg_ar_c					),
		.reg_dr_c					( reg_dr_c					),
		.reg_sr_c					( reg_sr_c					),
		.reg_rr_c					( reg_rr_c					),
		.reg_sl_c					( reg_sl_c					),
		.reg_wave_length_c			( reg_wave_length_c			),
		.reg_frequency_count_c		( reg_frequency_count_c		),
		.reg_ar_d					( reg_ar_d					),
		.reg_dr_d					( reg_dr_d					),
		.reg_sr_d					( reg_sr_d					),
		.reg_rr_d					( reg_rr_d					),
		.reg_sl_d					( reg_sl_d					),
		.reg_wave_length_d			( reg_wave_length_d			),
		.reg_frequency_count_d		( reg_frequency_count_d		),
		.reg_ar_e					( reg_ar_e					),
		.reg_dr_e					( reg_dr_e					),
		.reg_sr_e					( reg_sr_e					),
		.reg_rr_e					( reg_rr_e					),
		.reg_sl_e					( reg_sl_e					),
		.reg_wave_length_e			( reg_wave_length_e			),
		.reg_frequency_count_e		( reg_frequency_count_e		)
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
	//	test scenario
	// -------------------------------------------------------------
	initial begin

		//	initialization
		clk						= 0;
		nreset					= 0;
		active					= 0;
		ch_a_key_on				= 0;
		ch_a_key_release		= 0;
		ch_a_key_off			= 0;
		ch_b_key_on				= 0;
		ch_b_key_release		= 0;
		ch_b_key_off			= 0;
		ch_c_key_on				= 0;
		ch_c_key_release		= 0;
		ch_c_key_off			= 0;
		ch_d_key_on				= 0;
		ch_d_key_release		= 0;
		ch_d_key_off			= 0;
		ch_e_key_on				= 0;
		ch_e_key_release		= 0;
		ch_e_key_off			= 0;
		reg_ar_a				= 0;
		reg_dr_a				= 0;
		reg_sr_a				= 0;
		reg_rr_a				= 0;
		reg_sl_a				= 0;
		reg_wave_length_a		= 0;
		reg_frequency_count_a	= 0;
		reg_ar_b				= 0;
		reg_dr_b				= 0;
		reg_sr_b				= 0;
		reg_rr_b				= 0;
		reg_sl_b				= 0;
		reg_wave_length_b		= 0;
		reg_frequency_count_b	= 0;
		reg_ar_c				= 0;
		reg_dr_c				= 0;
		reg_sr_c				= 0;
		reg_rr_c				= 0;
		reg_sl_c				= 0;
		reg_wave_length_c		= 0;
		reg_frequency_count_c	= 0;
		reg_ar_d				= 0;
		reg_dr_d				= 0;
		reg_sr_d				= 0;
		reg_rr_d				= 0;
		reg_sl_d				= 0;
		reg_wave_length_d		= 0;
		reg_frequency_count_d	= 0;
		reg_ar_e				= 0;
		reg_dr_e				= 0;
		reg_sr_e				= 0;
		reg_rr_e				= 0;
		reg_sl_e				= 0;
		reg_wave_length_e		= 0;
		reg_frequency_count_e	= 0;
		repeat( 50 ) @( negedge clk );

		nreset				= 1;
		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 1, "In the steady state, envelope does not change." );
		repeat( 50 ) begin
			success_condition_is( envelope == 0, "Envelope is ZERO." );
			@( posedge clk );
		end

		// ---------------------------------------------------------
		set_test_pattern_no( 2, "If key_on is entered when reg_ar is 0, it suddenly rises to the maximum." );
		ch_a_key_on				= 1;
		@( posedge clk );
		ch_a_key_on				= 0;
		@( posedge clk );
		repeat( 50 ) begin
			success_condition_is( envelope == 16, "Envelope is MAXIMUM." );
			@( posedge clk );
		end

		// ---------------------------------------------------------
		set_test_pattern_no( 3, "When reg_rr is 0, it will not start decaying even if key_release is entered." );
		ch_a_key_release			= 1;
		@( posedge clk );
		ch_a_key_release			= 0;
		@( posedge clk );
		repeat( 50 ) begin
			success_condition_is( envelope == 16, "Envelope is MAXIMUM." );
			@( posedge clk );
		end

		// ---------------------------------------------------------
		set_test_pattern_no( 3, "When key_off is entered, envelope returns to 0." );
		ch_a_key_off				= 1;
		@( posedge clk );
		ch_a_key_off				= 0;
		@( posedge clk );
		repeat( 50 ) begin
			success_condition_is( envelope == 0, "Envelope is ZERO." );
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 4, "If you put values in AR, DR, SR, SL, and RR. (1)" );
		reg_ar_a				= 2;
		reg_dr_a				= 3;
		reg_sl_a				= 60;
		reg_sr_a				= 100;
		reg_rr_a				= 4;
		@( posedge clk );
		ch_a_key_on				= 1;
		@( posedge clk );
		ch_a_key_on				= 0;
		@( posedge clk );
		repeat( 2500 ) begin
			@( posedge clk );
		end
		ch_a_key_release			= 1;
		@( posedge clk );
		ch_a_key_release			= 0;
		@( posedge clk );
		repeat( 1500 ) begin
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 5, "If you put values in AR, DR, SR, SL, and RR. (2)" );
		reg_ar_a				= 0;
		reg_dr_a				= 3;
		reg_sl_a				= 0;
		reg_sr_a				= 0;
		reg_rr_a				= 3;
		@( posedge clk );
		ch_a_key_on				= 1;
		@( posedge clk );
		ch_a_key_on				= 0;
		@( posedge clk );
		repeat( 2500 ) begin
			@( posedge clk );
		end
		ch_a_key_release			= 1;
		@( posedge clk );
		ch_a_key_release			= 0;
		@( posedge clk );
		repeat( 1500 ) begin
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 6, "If you put values in AR, DR, SR, SL, and RR. (3)" );
		reg_ar_a				= 1;
		reg_dr_a				= 3;
		reg_sl_a				= 100;
		reg_sr_a				= 0;
		reg_rr_a				= 3;
		@( posedge clk );
		ch_a_key_on				= 1;
		@( posedge clk );
		ch_a_key_on				= 0;
		@( posedge clk );
		repeat( 2500 ) begin
			@( posedge clk );
		end
		ch_a_key_release			= 1;
		@( posedge clk );
		ch_a_key_release			= 0;
		@( posedge clk );
		repeat( 1500 ) begin
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		$finish;
	end
endmodule
