module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				nreset;					//	negative logic
	reg				clk;
	reg		[2:0]	active;					//	0...4 : channel index; 5 : no operation
	wire	[6:0]	envelope;

	reg				ch_key_on;
	reg				ch_key_release;
	reg				ch_key_off;
	reg				adsr_en;

	reg		[7:0]	reg_ar;
	reg		[7:0]	reg_dr;
	reg		[7:0]	reg_sr;
	reg		[7:0]	reg_rr;
	reg		[5:0]	reg_sl;

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
		.ch_key_on					( ch_key_on					),
		.ch_key_release				( ch_key_release			),
		.ch_key_off					( ch_key_off				),
		.adsr_en					( adsr_en					),
		.reg_ar						( reg_ar					),
		.reg_dr						( reg_dr					),
		.reg_sr						( reg_sr					),
		.reg_rr						( reg_rr					),
		.reg_sl						( reg_sl					)
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
		active					= 1;	//	Ch.A
		ch_key_on				= 0;
		ch_key_release			= 0;
		ch_key_off				= 0;
		adsr_en					= 1;
		reg_ar					= 0;
		reg_dr					= 0;
		reg_sr					= 0;
		reg_rr					= 0;
		reg_sl					= 0;
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
		ch_key_on				= 1;
		@( posedge clk );
		ch_key_on				= 0;
		@( posedge clk );
		repeat( 50 ) begin
			success_condition_is( envelope == 64, "Envelope is MAXIMUM." );
			@( posedge clk );
		end

		// ---------------------------------------------------------
		set_test_pattern_no( 3, "When reg_rr is 0, it will not start decaying even if key_release is entered." );
		ch_key_release			= 1;
		@( posedge clk );
		ch_key_release			= 0;
		@( posedge clk );
		repeat( 50 ) begin
			success_condition_is( envelope == 64, "Envelope is MAXIMUM." );
			@( posedge clk );
		end

		// ---------------------------------------------------------
		set_test_pattern_no( 3, "When key_off is entered, envelope returns to 0." );
		ch_key_off				= 1;
		@( posedge clk );
		ch_key_off				= 0;
		@( posedge clk );
		repeat( 50 ) begin
			success_condition_is( envelope == 0, "Envelope is ZERO." );
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 4, "If you put values in AR, DR, SR, SL, and RR. (1)" );
		reg_ar					= 2;
		reg_dr					= 3;
		reg_sl					= 60;
		reg_sr					= 100;
		reg_rr					= 4;
		@( posedge clk );
		ch_key_on				= 1;
		@( posedge clk );
		ch_key_on				= 0;
		@( posedge clk );
		repeat( 2500 ) begin
			@( posedge clk );
		end
		ch_key_release			= 1;
		@( posedge clk );
		ch_key_release			= 0;
		@( posedge clk );
		repeat( 1500 ) begin
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 5, "If you put values in AR, DR, SR, SL, and RR. (2)" );
		reg_ar					= 0;
		reg_dr					= 3;
		reg_sl					= 0;
		reg_sr					= 0;
		reg_rr					= 3;
		@( posedge clk );
		ch_key_on				= 1;
		@( posedge clk );
		ch_key_on				= 0;
		@( posedge clk );
		repeat( 2500 ) begin
			@( posedge clk );
		end
		ch_key_release			= 1;
		@( posedge clk );
		ch_key_release			= 0;
		@( posedge clk );
		repeat( 1500 ) begin
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 6, "If you put values in AR, DR, SR, SL, and RR. (3)" );
		reg_ar					= 1;
		reg_dr					= 3;
		reg_sl					= 55;
		reg_sr					= 0;
		reg_rr					= 2;
		@( posedge clk );
		ch_key_on				= 1;
		@( posedge clk );
		ch_key_on				= 0;
		@( posedge clk );
		repeat( 1 * 64 * 64 + 3 * 4096 * (64 - 55 + 20) ) begin
			@( posedge clk );
		end
		ch_key_release			= 1;
		@( posedge clk );
		ch_key_release			= 0;
		@( posedge clk );
		repeat( 2 * 4096 * (55 + 20) ) begin
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		$finish;
	end
endmodule
