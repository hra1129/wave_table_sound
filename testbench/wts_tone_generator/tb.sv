module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				nreset;					//	negative logic
	reg				clk;
	wire			active;					//	3.579MHz timing pulse
	reg				address_reset;
	wire	[6:0]	wave_address;
	reg		[1:0]	reg_wave_length;
	reg		[11:0]	reg_frequency_count;
	reg		[2:0]	ff_div;
	int				pattern_no = 0;
	int				error_count = 0;
	int				last_wave_address;

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
	wts_tone_generator u_wts_tone_generator (
		.nreset					( nreset				),
		.clk					( clk					),
		.active					( active				),
		.address_reset			( address_reset			),
		.wave_address			( wave_address			),
		.reg_wave_length		( reg_wave_length		),
		.reg_frequency_count	( reg_frequency_count	)
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
		ff_div						= 0;
		nreset						= 0;
		address_reset				= 0;
		reg_wave_length				= 0;
		reg_frequency_count			= 0;
		repeat( 50 ) @( negedge clk );

		nreset				= 1;
		repeat( 50 ) @( posedge clk );

		// -------------------------------------------------------------
		set_test_pattern_no( 1, "The address increments every cycle." );
		reg_frequency_count = 0;
		last_wave_address = 0;
		@( posedge active );
		address_reset <= 1;
		@( posedge active );
		address_reset <= 0;
		repeat( 20 ) begin
			success_condition_is( wave_address == last_wave_address, "The address will be incremented." );
			last_wave_address <= (wave_address + 1) & 31;
			@( posedge active );
		end

		// -------------------------------------------------------------
		set_test_pattern_no( 2, "The address is incremented once every two cycles." );
		reg_frequency_count = 1;
		last_wave_address = 0;
		@( posedge active );
		address_reset <= 1;
		@( posedge active );
		address_reset <= 0;
		repeat( 20 ) begin
			success_condition_is( wave_address == last_wave_address, "The address does not change." );
			last_wave_address <= wave_address;
			@( posedge active );
			success_condition_is( wave_address == last_wave_address, "The address will be incremented." );
			last_wave_address <= (wave_address + 1) & 31;
			@( posedge active );
		end

		// -------------------------------------------------------------
		set_test_pattern_no( 3, "The address is incremented once every three cycles." );
		reg_frequency_count = 2;
		last_wave_address = 0;
		@( posedge active );
		address_reset <= 1;
		@( posedge active );
		address_reset <= 0;
		repeat( 20 ) begin
			success_condition_is( wave_address == last_wave_address, "The address does not change." );
			last_wave_address <= wave_address;
			@( posedge active );
			success_condition_is( wave_address == last_wave_address, "The address does not change." );
			last_wave_address <= wave_address;
			@( posedge active );
			success_condition_is( wave_address == last_wave_address, "The address will be incremented." );
			last_wave_address <= (wave_address + 1) & 31;
			@( posedge active );
		end

		repeat( 50 ) @( posedge clk );

		end_of_test();
	end
endmodule
