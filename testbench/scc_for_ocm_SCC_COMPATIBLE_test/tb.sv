module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				clk21m;			//	21.47727MHz
	reg				reset;
	reg				req;
	wire			ack;
	reg				wrt;
	reg		[15:0]	adr;
	wire	[7:0]	dbi;
	reg		[7:0]	dbo;
	wire			ramreq;
	wire			ramwrt;
	wire	[20:0]	ramadr;
	reg		[7:0]	ramdbi;
	wire	[7:0]	ramdbo;
	wire	[14:0]	wavl;			//	digital sound ouput (15 bits)

	reg				ff_mem_ncs;
	reg		[20:0]	ff_mem_a;
	reg		[7:0]	read_data;

	int				pattern_no = 0;
	int				error_count = 0;
	int				last_wave_address;
	int				i, j;
	reg		[7:0]	ff_i;

	// -------------------------------------------------------------
	//	clock generator
	// -------------------------------------------------------------
	always #(CLK_BASE/2) begin
		clk21m <= ~clk21m;
	end

	// -------------------------------------------------------------
	//	DUT
	// -------------------------------------------------------------
	scc_for_ocm u_scc_for_ocm (
		.clk21m		( clk21m		),
		.reset		( reset			),
		.req		( req			),
		.ack		( ack			),
		.wrt		( wrt			),
		.adr		( adr			),
		.dbi		( dbi			),
		.dbo		( dbo			),
		.ramreq		( ramreq		),
		.ramwrt		( ramwrt		),
		.ramadr		( ramadr		),
		.ramdbi		( ramdbi		),
		.ramdbo		( ramdbo		),
		.wavl		( wavl			)
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
		adr		<= address;
		req		<= 1'b1;
		wrt		<= 1'b1;
		dbo		<= data;
		@( posedge clk21m );

		req		<= 1'b0;
		wrt		<= 1'b0;
		dbo		<= 'd0;
		@( posedge clk21m );

		ff_mem_ncs			<= ~ramreq;
		ff_mem_a			<= ramadr;
		@( posedge clk21m );

		adr					<= 'd0;
		repeat( 7 ) @( posedge clk21m );
	endtask

	// -------------------------------------------------------------
	task read_reg(
		input	[15:0]	address,
		output	[7:0]	data
	);
		adr		<= address;
		req		<= 1'b1;
		wrt		<= 1'b0;
		@( posedge clk21m );
		@( ack == 1'b1 );

		req		<= 1'b0;
		wrt		<= 1'b0;
		@( posedge clk21m );
		@( posedge clk21m );

		ff_mem_ncs			<= ~ramreq;
		ff_mem_a			<= ramadr;
		data				<= dbi;

		adr		<= 'd0;
		repeat( 10 ) @( posedge clk21m );
	endtask

	// -------------------------------------------------------------
	//	test scenario
	// -------------------------------------------------------------
	initial begin

		//	initialization
		clk21m			= 0;
		reset			= 1;
		adr				= 'd0;
		dbo				= 8'd0;
		req				= 0;
		wrt				= 0;
		repeat( 50 ) @( negedge clk21m );

		reset			= 0;
		repeat( 50 ) @( posedge clk21m );

		// -------------------------------------------------------------
		set_test_pattern_no( 1, "Write Test by SCC registers." );

		write_reg( 'h9000, 63 );

		// write wave tables -------------------------------------------
		for( i = 0; i < 4; i++ ) begin
			for( j = 0; j < 16; j++ ) begin
				write_reg( 'h9800 + i * 32 + j, 127 );
			end
			for( j = 16; j < 32; j++ ) begin
				write_reg( 'h9800 + i * 32 + j, 0 );
			end
		end

		// read wave tables -------------------------------------------
		read_reg( 'h9800, read_data );
		success_condition_is( read_data == 127, "0x9800 is 127." );

		read_reg( 'h9810, read_data );
		success_condition_is( read_data == 0, "0x9800 is 0." );

		// write frequency count --------------------------------------
		//	(1 / (440Hz * 32)) / (1 / 3.579MHz) = 254.1903409
		//	about 254
		//	00FE
		write_reg( 'h9880, 'hFE );
		write_reg( 'h9881, 'h00 );

		// write volume -----------------------------------------------
		write_reg( 'h988A, 'h0F );

		// write port enable ------------------------------------------
		write_reg( 'h988F, 'h001 );

		repeat( 50000 ) @( posedge clk21m );
		end_of_test();
	end
endmodule
