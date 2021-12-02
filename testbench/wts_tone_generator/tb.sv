module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				nreset;
	reg				clk;
	reg		[2:0]	active;
	reg				address_reset;
	wire	[6:0]	wave_address;
	wire			half_timing;
	reg		[1:0]	reg_wave_length;
	reg		[11:0]	reg_frequency_count;
	reg				reg_wave_reset;
	reg				clear_counter_a;
	reg				clear_counter_b;
	reg				clear_counter_c;
	reg				clear_counter_d;
	reg				clear_counter_e;

	int				pattern_no = 0;
	int				error_count = 0;
	int				last_wave_address;

	// -------------------------------------------------------------
	//	clock generator
	// -------------------------------------------------------------
	always #(CLK_BASE/2) begin
		clk	<= ~clk;
	end

	// -------------------------------------------------------------
	//	DUT
	// -------------------------------------------------------------
	wts_tone_generator_5ch u_tone_generator_5ch (
		.nreset						( nreset					),
		.clk						( clk						),
		.active						( active					),
		.address_reset				( address_reset				),
		.wave_address				( wave_address				),
		.half_timing				( half_timing				),
		.reg_wave_length			( reg_wave_length			),
		.reg_frequency_count		( reg_frequency_count		),
		.reg_wave_reset				( reg_wave_reset			),
		.clear_counter_a			( clear_counter_a			),
		.clear_counter_b			( clear_counter_b			),
		.clear_counter_c			( clear_counter_c			),
		.clear_counter_d			( clear_counter_d			),
		.clear_counter_e			( clear_counter_e			)
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
		nreset						= 0;
		active						= 0;
		address_reset				= 0;
		reg_wave_length				= 0;
		reg_frequency_count			= 0;
		reg_wave_reset				= 0;
		clear_counter_a				= 0;
		clear_counter_b				= 0;
		clear_counter_c				= 0;
		clear_counter_d				= 0;
		clear_counter_e				= 0;
		repeat( 50 ) @( negedge clk );

		nreset				= 1;
		repeat( 50 ) @( posedge clk );

		// -------------------------------------------------------------
		set_test_pattern_no( 1, "The address increments every cycle." );
		reg_frequency_count = 0;
		last_wave_address = 0;
		@( posedge clk );
		address_reset <= 1;
		@( posedge clk );
		address_reset <= 0;
		repeat( 20 ) begin
			@( negedge clk );
			success_condition_is( wave_address == last_wave_address, "The address will be incremented." );
			last_wave_address <= (wave_address + 1) & 31;
			@( posedge clk );
		end

		// -------------------------------------------------------------
		set_test_pattern_no( 2, "The address is incremented once every two cycles." );
		reg_frequency_count = 1;
		last_wave_address = 0;
		@( posedge clk );
		address_reset <= 1;
		@( posedge clk );
		address_reset <= 0;
		repeat( 20 ) begin
			@( negedge clk );
			success_condition_is( wave_address == last_wave_address, "The address does not change." );
			last_wave_address <= wave_address;
			@( posedge clk );
			@( negedge clk );
			success_condition_is( wave_address == last_wave_address, "The address will be incremented." );
			last_wave_address <= (wave_address + 1) & 31;
			@( posedge clk );
		end

		// -------------------------------------------------------------
		set_test_pattern_no( 3, "The address is incremented once every three cycles." );
		reg_frequency_count = 2;
		last_wave_address = 0;
		@( posedge clk );
		address_reset <= 1;
		@( posedge clk );
		address_reset <= 0;
		repeat( 20 ) begin
			@( negedge clk );
			success_condition_is( wave_address == last_wave_address, "The address does not change." );
			last_wave_address <= wave_address;
			@( posedge clk );
			@( negedge clk );
			success_condition_is( wave_address == last_wave_address, "The address does not change." );
			last_wave_address <= wave_address;
			@( posedge clk );
			@( negedge clk );
			success_condition_is( wave_address == last_wave_address, "The address will be incremented." );
			last_wave_address <= (wave_address + 1) & 31;
			@( posedge clk );
		end

		repeat( 50 ) @( posedge clk );

		end_of_test();
	end
endmodule
