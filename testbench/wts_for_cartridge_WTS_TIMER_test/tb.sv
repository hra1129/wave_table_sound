module tb;
	localparam		CLK_BASE	= 1000000000/21477;
	localparam		CLK4M_BASE	= CLK_BASE * 6;

	reg				clk4m;			//	3.579MHz
	reg				clk;			//	21.47727MHz
	reg				slot_nreset;	//	negative logic
	wire			slot_nint;		//	negative logic; open collector
	reg		[14:0]	slot_a;
	wire	[7:0]	slot_d;
	reg		[7:0]	ff_slot_d;
	reg				ff_slot_d_dir;
	reg				slot_nsltsl;	//	negative logic
	reg				slot_nmerq;		//	negative logic
	reg				slot_nrd;		//	negative logic
	reg				slot_nwr;		//	negative logic
	reg				sw_mono;
	wire			mem_ncs;		//	negative logic
	wire	[7:0]	mem_a;			//	external memory address [20:13] Up to 2MB (8KB x 256banks)
	wire	[11:0]	left_out;		//	digital sound output (12 bits)
	wire	[11:0]	right_out;		//	digital sound output (12 bits)

	reg				ff_mem_ncs;
	reg		[20:0]	ff_mem_a;
	reg		[7:0]	read_data;

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
		clk <= ~clk;
	end

	always #(CLK4M_BASE/2) begin
		clk4m <= ~clk4m;
	end

	// -------------------------------------------------------------
	//	DUT
	// -------------------------------------------------------------
	wts_for_cartridge u_wts_for_cartridge (
		.clk			( clk				),
		.slot_nreset	( slot_nreset		),
		.slot_nint		( slot_nint			),
		.slot_a			( slot_a			),
		.slot_d			( slot_d			),
		.slot_nsltsl	( slot_nsltsl		),
		.slot_nmerq		( slot_nmerq		),
		.slot_nrd		( slot_nrd			),
		.slot_nwr		( slot_nwr			),
		.sw_mono		( sw_mono			),
		.mem_ncs		( mem_ncs			),
		.mem_a			( mem_a				),
		.left_out		( left_out			),
		.right_out		( right_out			)
	);

	assign slot_d	= ff_slot_d_dir ? ff_slot_d : 8'dz;

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
		slot_a		<= address;
		@( negedge clk4m );

		#145ns
			slot_nmerq		<= 1'b0;
		#10ns
			slot_nsltsl		<= 1'b0;
			ff_slot_d_dir	<= 1'b1;
		#55ns
			ff_slot_d		<= data;
		@( negedge clk4m );

		#140ns
			slot_nwr		<= 1'b0;
		@( negedge clk4m );

		ff_mem_ncs			<= mem_ncs;
		ff_mem_a			<= { mem_a, slot_a[12:0] };

		#120ns
			slot_nwr		<= 1'b1;
		#25ns
			slot_nmerq		<= 1'b1;
		#10ns
			slot_nsltsl		<= 1'b1;
		@( negedge clk4m );

		slot_a				<= 'dx;
		ff_slot_d_dir		<= 1'b0;
		@( posedge clk4m );
	endtask

	// -------------------------------------------------------------
	task read_reg(
		input	[15:0]	address,
		output	[7:0]	data
	);
		slot_a		<= address;
		@( negedge clk4m );

		#145ns
			slot_nmerq		<= 1'b0;
		#10ns
			slot_nsltsl		<= 1'b0;
			slot_nrd		<= 1'b0;
			ff_slot_d_dir	<= 1'b0;
		@( negedge clk4m );
		@( negedge clk4m );

		ff_mem_ncs			<= mem_ncs;
		ff_mem_a			<= { mem_a, slot_a[12:0] };
		data				<= slot_d;

		#145ns
			slot_nrd		<= 1'b1;
			slot_nmerq		<= 1'b1;
		#10ns
			slot_nsltsl		<= 1'b1;
		@( negedge clk4m );

		slot_a				<= 'dx;
		ff_slot_d_dir		<= 1'b0;
		@( posedge clk4m );
	endtask

	// -------------------------------------------------------------
	//	test scenario
	// -------------------------------------------------------------
	initial begin

		//	initialization
		clk				= 0;
		clk4m			= 0;
		slot_nreset		= 0;
		slot_a			= 'dx;
		ff_slot_d_dir	= 1'b0;
		ff_slot_d		= 8'd0;
		slot_nsltsl		= 1;
		slot_nmerq		= 1;
		slot_nrd		= 1;
		slot_nwr		= 1;
		sw_mono			= 0;
		repeat( 50 ) @( negedge clk );

		slot_nreset		= 1;
		repeat( 50 ) @( posedge clk );

		// -------------------------------------------------------------
		set_test_pattern_no( 1, "Check /INT signal." );

		success_condition_is( slot_nint === 1'bz, "SLOT_NINT signal is Hi-Z." );
		repeat( 50 ) @( posedge clk );

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
		read_reg( 'hAEF1, read_data );
		success_condition_is( read_data === 8'h80, "<1> TIMER1 status is 8'h80." );

		read_reg( 'hAEF3, read_data );
		success_condition_is( read_data === 8'h80, "<2> TIMER2 status is 8'h80." );

		//	Timer
		write_reg( 'hAEF0, TIMER_ENABLE | TIMER_ONE_SHOT | 0 );
		write_reg( 'hAEF2, TIMER_ENABLE | TIMER_ONE_SHOT | 0 );

		repeat( 50 ) @( posedge clk );

		success_condition_is( slot_nint === 1'b0, "SLOT_NINT is 0." );

		//	Clear
		read_reg( 'hAEF1, read_data );
		success_condition_is( read_data === 8'h00, "<3> TIMER1 status is 8'h00." );

		read_reg( 'hAEF3, read_data );
		success_condition_is( read_data === 8'h00, "<4> TIMER2 status is 8'h00." );

		repeat( 50 ) @( posedge clk );

		//	Default status
		read_reg( 'hAEF1, read_data );
		success_condition_is( read_data === 8'h80, "<5> TIMER1 status is 8'h80." );

		read_reg( 'hAEF3, read_data );
		success_condition_is( read_data === 8'h80, "<6> TIMER2 status is 8'h80." );

		repeat( 50 ) @( posedge clk );

		end_of_test();
	end
endmodule
