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
	task SCC_POKE(
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
	task SCC_PEEK(
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
	task SCC_INIT();
		clk21m			= 0;
		reset			= 1;
		adr				= 'd0;
		dbo				= 8'd0;
		req				= 0;
		wrt				= 0;
		repeat( 50 ) @( negedge clk21m );

		reset			= 0;
		repeat( 50 ) @( posedge clk21m );
	endtask

	// -------------------------------------------------------------
	task SCC_CLOCK(
		input			count = 1
	);
		repeat( count ) @( posedge clk21m );
	endtask
