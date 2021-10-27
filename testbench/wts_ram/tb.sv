module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				clk;
	reg				sram_we;
	reg		[9:0]	sram_a;
	reg		[7:0]	sram_d;
	wire	[7:0]	sram_q;
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
	wts_ram u_ram (
		.clk			( clk				),
		.sram_we		( sram_we			),
		.sram_a			( sram_a			),
		.sram_d			( sram_d			),
		.sram_q			( sram_q			)
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
		sram_we						= 0;
		sram_a						= 0;
		sram_d						= 0;
		repeat( 50 ) @( negedge clk );

		repeat( 50 ) @( posedge clk );

		// -------------------------------------------------------------
		set_test_pattern_no( 1, "Data can be written." );
		for( i = 0; i < 640; i++ ) begin
			sram_we		<= 1'b1;
			sram_a		<= i;
			sram_d		<= i + 100;
			@( posedge clk );
		end

		sram_we		<= 1'b0;
		sram_a		<= 0;
		sram_d		<= 0;
		@( posedge clk );

		// -------------------------------------------------------------
		set_test_pattern_no( 2, "Data can be read out." );
		for( i = 0; i < 640; i++ ) begin
			sram_we		<= 1'b0;
			sram_a		<= i;
			sram_d		<= $random;
			@( posedge clk );
			@( posedge clk );
			success_condition_is( sram_q == ((i + 100) & 255), "The data read out is as expected." );
		end

		repeat( 50 ) @( posedge clk );

		end_of_test();
	end
endmodule
