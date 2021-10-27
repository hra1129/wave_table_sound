module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				clk21m;
	reg				reset;
	reg				req;
	wire			ack;
	reg				wrt;
	reg		[15:0]	adr;
	wire	[7:0]	dbi;
	reg		[7:0]	dbo;
	wire			nint;
	reg				sw_mono;
	wire			ramreq;
	wire			ramwrt;
	wire	[20:0]	ramadr;
	reg		[7:0]	ramdbi;
	wire	[7:0]	ramdbo;
	wire	[14:0]	wavl;
	wire	[14:0]	wavr;

	int				pattern_no = 0;
	int				error_count = 0;
	int				last_wave_address;
	int				i;
	reg		[7:0]	ff_i;

	localparam		TIMER_ENABLE = 8'h80;
	localparam		TIMER_ONE_SHOT = 8'h40;

	// -------------------------------------------------------------
	//	clock generator
	// -------------------------------------------------------------
	always #(CLK_BASE/2) begin
		clk21m <= ~clk21m;
	end

	// -------------------------------------------------------------
	//	DUT
	// -------------------------------------------------------------
	wts_for_ocm u_wts_for_ocm (
		.clk21m		( clk21m		),
		.reset		( reset			),
		.req		( req			),
		.ack		( ack			),
		.wrt		( wrt			),
		.adr		( adr			),
		.dbi		( dbi			),
		.dbo		( dbo			),
		.nint		( nint			),
		.sw_mono	( sw_mono		),
		.ramreq		( ramreq		),
		.ramwrt		( ramwrt		),
		.ramadr		( ramadr		),
		.ramdbi		( ramdbi		),
		.ramdbo		( ramdbo		),
		.wavl		( wavl			),
		.wavr		( wavr			)
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
	task write_reg(
		input	[15:0]	address,
		input	[7:0]	data
	);
	endtask

	// -------------------------------------------------------------
	task read_reg(
		input	[15:0]	address,
		output	[7:0]	data
	);
	endtask

	// -------------------------------------------------------------
	//	test scenario
	// -------------------------------------------------------------
	initial begin

		//	initialization
		clk21m			= 0;
		reset			= 1;
		req				= 0;
		wrt				= 0;
		adr				= 0;
		dbo				= 0;
		sw_mono			= 1;
		ramdbi			= 0;

		repeat( 50 ) @( negedge clk21m );

		reset			= 0;
		repeat( 50 ) @( posedge clk21m );

		// -------------------------------------------------------------
		set_test_pattern_no( 1, "Check /INT signal." );

		success_condition_is( nint === 1'b1, "SLOT_NINT signal is Hi-Z." );
		repeat( 50 ) @( posedge clk21m );

		// -------------------------------------------------------------
		set_test_pattern_no( 2, "Activate WTS registers." );

		write_reg( 'hB000, 128 );
		write_reg( 'hBFFF, 8'b01000000 );

		// -------------------------------------------------------------
		for( i = 0; i < 12; i++ ) begin
			write_reg( 'hAE00 + i * 16, i * 2 );		//	freq. low
			write_reg( 'hAE01 + i * 16, 0     );		//	freq. high
			write_reg( 'hAE02 + i * 16, 15    );		//	volume
			write_reg( 'hAE03 + i * 16, 3     );		//	enable
		end

		//	Default status
//		read_reg( 'hAEF1, read_data );
//		success_condition_is( read_data === 8'h80, "<1> TIMER1 status is 8'h80." );

//		read_reg( 'hAEF3, read_data );
//		success_condition_is( read_data === 8'h80, "<2> TIMER2 status is 8'h80." );

		//	Timer
		write_reg( 'hAEF0, TIMER_ENABLE | TIMER_ONE_SHOT | 0 );
		write_reg( 'hAEF2, TIMER_ENABLE | TIMER_ONE_SHOT | 0 );

		repeat( 50 ) @( posedge clk21m );

		success_condition_is( nint === 1'b0, "NINT is 0." );

		//	Clear
//		read_reg( 'hAEF1, read_data );
//		success_condition_is( read_data === 8'h00, "<3> TIMER1 status is 8'h00." );

//		read_reg( 'hAEF3, read_data );
//		success_condition_is( read_data === 8'h00, "<4> TIMER2 status is 8'h00." );

		repeat( 50 ) @( posedge clk21m );

		//	Default status
//		read_reg( 'hAEF1, read_data );
//		success_condition_is( read_data === 8'h80, "<5> TIMER1 status is 8'h80." );

//		read_reg( 'hAEF3, read_data );
//		success_condition_is( read_data === 8'h80, "<6> TIMER2 status is 8'h80." );

		repeat( 50 ) @( posedge clk21m );

		end_of_test();
	end
endmodule
