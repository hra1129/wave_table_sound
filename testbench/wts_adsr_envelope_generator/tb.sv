module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				nreset;					//	negative logic
	reg				clk;
	reg				active;					//	3.579MHz timing pulse
	reg				key_on;					//	pulse
	reg				key_release;			//	pulse
	reg				key_off;				//	pulse
	wire	[8:0]	envelope;				//	0...256
	reg		[15:0]	reg_ar;
	reg		[15:0]	reg_dr;
	reg		[15:0]	reg_sr;
	reg		[15:0]	reg_rr;
	reg		[7:0]	reg_sl;

	reg		[2:0]	ff_div;
	int				pattern_no = 0;
	int				error_count = 0;

	// -------------------------------------------------------------
	//	clock generator
	// -------------------------------------------------------------
	always #(CLK_BASE/2) begin
		clk	<= ~clk;
	end

	always @( posedge clk ) begin
		if( active ) begin
			ff_div <= 3'd5;
		end
		else begin
			ff_div <= ff_div - 3'd1;
		end
	end

	assign active = (ff_div == 3'd0) ? 1'b1 : 1'b0;

	// -------------------------------------------------------------
	//	DUT
	// -------------------------------------------------------------
	wts_adsr_envelope_generator u_wts_adsr_envelope_generator (
		.nreset				( nreset			),
		.clk				( clk				),
		.active				( active			),
		.key_on				( key_on			),
		.key_release		( key_release		),
		.key_off			( key_off			),
		.envelope			( envelope			),
		.reg_ar				( reg_ar			),
		.reg_dr				( reg_dr			),
		.reg_sr				( reg_sr			),
		.reg_rr				( reg_rr			),
		.reg_sl				( reg_sl			)
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
		clk					= 0;
		ff_div				= 0;
		nreset				= 0;
		key_on				= 0;
		key_release			= 0;
		key_off				= 0;
		reg_ar				= 0;
		reg_dr				= 0;
		reg_sr				= 0;
		reg_rr				= 0;
		reg_sl				= 0;
		repeat( 50 ) @( negedge clk );

		nreset				= 1;
		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 1, "In the steady state, envelope does not change." );
		repeat( 50 ) begin
			success_condition_is( envelope == 0, "Envelope is ZERO." );
			@( posedge active );
			@( posedge clk );
		end

		// ---------------------------------------------------------
		set_test_pattern_no( 2, "If key_on is entered when reg_ar is 0, it suddenly rises to the maximum." );
		key_on				= 1;
		@( posedge active );
		@( posedge clk );
		key_on				= 0;
		@( posedge active );
		@( posedge clk );
		repeat( 50 ) begin
			success_condition_is( envelope == 256, "Envelope is MAXIMUM." );
			@( posedge active );
			@( posedge clk );
		end

		// ---------------------------------------------------------
		set_test_pattern_no( 3, "When reg_rr is 0, it will not start decaying even if key_release is entered." );
		key_release			= 1;
		@( posedge active );
		@( posedge clk );
		key_release			= 0;
		@( posedge active );
		@( posedge clk );
		repeat( 50 ) begin
			success_condition_is( envelope == 256, "Envelope is MAXIMUM." );
			@( posedge active );
			@( posedge clk );
		end

		// ---------------------------------------------------------
		set_test_pattern_no( 3, "When key_off is entered, envelope returns to 0." );
		key_off				= 1;
		@( posedge active );
		@( posedge clk );
		key_off				= 0;
		@( posedge active );
		@( posedge clk );
		repeat( 50 ) begin
			success_condition_is( envelope == 0, "Envelope is ZERO." );
			@( posedge active );
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 4, "If you put values in AR, DR, SR, SL, and RR. (1)" );
		reg_ar				= 2;
		reg_dr				= 3;
		reg_sl				= 200;
		reg_sr				= 100;
		reg_rr				= 4;
		key_on				= 1;
		@( posedge active );
		@( posedge clk );
		key_on				= 0;
		@( posedge active );
		@( posedge clk );
		repeat( 2500 ) begin
			@( posedge active );
			@( posedge clk );
		end
		key_release			= 1;
		@( posedge active );
		@( posedge clk );
		key_release			= 0;
		@( posedge active );
		@( posedge clk );
		repeat( 1500 ) begin
			@( posedge active );
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 5, "If you put values in AR, DR, SR, SL, and RR. (2)" );
		reg_ar				= 0;
		reg_dr				= 3;
		reg_sl				= 0;
		reg_sr				= 0;
		reg_rr				= 3;
		key_on				= 1;
		@( posedge active );
		@( posedge clk );
		key_on				= 0;
		@( posedge active );
		@( posedge clk );
		repeat( 2500 ) begin
			@( posedge active );
			@( posedge clk );
		end
		key_release			= 1;
		@( posedge active );
		@( posedge clk );
		key_release			= 0;
		@( posedge active );
		@( posedge clk );
		repeat( 1500 ) begin
			@( posedge active );
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		// ---------------------------------------------------------
		set_test_pattern_no( 6, "If you put values in AR, DR, SR, SL, and RR. (3)" );
		reg_ar				= 1;
		reg_dr				= 3;
		reg_sl				= 200;
		reg_sr				= 0;
		reg_rr				= 3;
		key_on				= 1;
		@( posedge active );
		@( posedge clk );
		key_on				= 0;
		@( posedge active );
		@( posedge clk );
		repeat( 2500 ) begin
			@( posedge active );
			@( posedge clk );
		end
		key_release			= 1;
		@( posedge active );
		@( posedge clk );
		key_release			= 0;
		@( posedge active );
		@( posedge clk );
		repeat( 1500 ) begin
			@( posedge active );
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		$finish;
	end
endmodule