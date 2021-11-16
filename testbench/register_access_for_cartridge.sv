	localparam		CLK_BASE	= 1000000000/21477;
	localparam		CLK4M_BASE	= CLK_BASE * 6;

	reg				clk4m;			//	3.579MHz
	reg				clk;			//	21.47727MHz
	reg				slot_nreset;	//	negative logic
	reg		[14:0]	slot_a;
	wire	[7:0]	slot_d;
	reg		[7:0]	ff_slot_d;
	reg				ff_slot_d_dir;
	reg				slot_nsltsl;	//	negative logic
	reg				slot_nmerq;		//	negative logic
	reg				slot_nrd;		//	negative logic
	reg				slot_nwr;		//	negative logic
	wire			mem_ncs;		//	negative logic
	wire	[7:0]	mem_a;			//	external memory address [20:13] Up to 2MB (8KB x 256banks)
	wire	[10:0]	sound_out;		//	digital sound output (11 bits)

	reg				ff_mem_ncs;
	reg		[20:0]	ff_mem_a;

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
	scc_for_cartridge u_scc_for_cartridge (
		.clk			( clk				),
		.slot_nreset	( slot_nreset		),
		.slot_a			( slot_a			),
		.slot_d			( slot_d			),
		.slot_nsltsl	( slot_nsltsl		),
		.slot_nmerq		( slot_nmerq		),
		.slot_nrd		( slot_nrd			),
		.slot_nwr		( slot_nwr			),
		.mem_ncs		( mem_ncs			),
		.mem_a			( mem_a				),
		.sound_out		( sound_out			)
	);

	assign slot_d	= ff_slot_d_dir ? ff_slot_d : 8'dz;

	// -------------------------------------------------------------
	task SCC_POKE(
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
		@( negedge clk4m );

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
	task SCC_PEEK(
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
	task SCC_INIT();
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
		repeat( 50 ) @( negedge clk );

		slot_nreset		= 1;
		repeat( 50 ) @( posedge clk );
	endtask

	// -------------------------------------------------------------
	task SCC_CLOCK(
		input			count = 1
	);
		repeat( count ) @( posedge clk );
	endtask
