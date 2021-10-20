module tb;
	localparam		CLK_BASE	= 1000000000/21477;

	reg				nreset;					//	negative logic
	reg				clk;
	reg				active;					//	3.579MHz timing pulse
	reg				enable;
	wire			noise;
	reg		[4:0]	reg_frequency_count;
	int				i;
	reg		[2:0]	ff_div;

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
	wts_noise_generator u_wts_noise_generator (
		.nreset			( nreset			),
		.clk			( clk				),
		.active			( active			),
		.enable			( enable			),
		.noise			( noise				),
		.reg_frequency_count			( reg_frequency_count			)
	);

	// -------------------------------------------------------------
	//	test scenario
	// -------------------------------------------------------------
	initial begin

		//	initialization
		clk					= 0;
		ff_div				= 0;
		nreset				= 0;
		reg_frequency_count				= 0;
		enable				= 0;
		repeat( 50 ) @( negedge clk );

		nreset				= 1;
		repeat( 50 ) @( posedge clk );

		//	enable
		for( i = 0; i < 32; i++ ) begin
			enable <= 1;
			reg_frequency_count <= i;
			repeat( 50 * 6 ) @( negedge clk );
		end

		//	disable
		for( i = 0; i < 32; i++ ) begin
			enable <= 0;
			reg_frequency_count <= i;
			repeat( 50 * 6 ) @( negedge clk );
		end

		//	enable
		for( i = 0; i < 32; i++ ) begin
			enable <= 1;
			reg_frequency_count <= i;
			repeat( 50 * 6 ) @( negedge clk );
		end

		repeat( 50 ) @( posedge clk );

		$finish;
	end
endmodule
