module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				nreset;					//	negative logic
	reg				clk;
	reg		[7:0]	envelope;
	reg		[7:0]	sram_q;					//	signed
	wire	[7:0]	channel;				//	signed
	reg		[3:0]	reg_volume;
	int				i;
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
	wts_channel_volume u_channel_volume (
		.nreset			( nreset			),
		.clk			( clk				),
		.envelope		( envelope			),
		.sram_q			( sram_q			),
		.channel		( channel			),
		.reg_volume		( reg_volume		)
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
		clk							= 0;
		envelope					= 0;
		sram_q						= 0;
		reg_volume					= 0;
		repeat( 50 ) @( negedge clk );

		repeat( 50 ) @( posedge clk );

		// -------------------------------------------------------------
		set_test_pattern_no( 1, "Data can be written." );

		repeat( 50 ) @( posedge clk );

		end_of_test();
	end
endmodule
