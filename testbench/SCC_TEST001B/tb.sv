module tb;
	reg		[7:0]	read_data;

	int				i, j;
	reg		[7:0]	ff_i;

	// -------------------------------------------------------------
	`include "../testbench.sv"
	`include `TARGET

	// -------------------------------------------------------------
	//	test scenario
	// -------------------------------------------------------------
	initial begin

		//	initialization
		SCC_INIT();

		// -------------------------------------------------------------
		set_test_pattern_no( 1, "TEST001" );

		SCC_POKE( 'h9000, 63 );

		SCC_POKE( 'h9820, 0 );
		SCC_POKE( 'h9821, 2 );
		SCC_POKE( 'h9822, 4 );
		SCC_POKE( 'h9823, 6 );
		SCC_POKE( 'h9824, 8 );
		SCC_POKE( 'h9825, 10 );
		SCC_POKE( 'h9826, 12 );
		SCC_POKE( 'h9827, 14 );
		SCC_POKE( 'h9828, 16 );
		SCC_POKE( 'h9829, 18 );
		SCC_POKE( 'h982A, 20 );
		SCC_POKE( 'h982B, 22 );
		SCC_POKE( 'h982C, 24 );
		SCC_POKE( 'h982D, 26 );
		SCC_POKE( 'h982E, 28 );
		SCC_POKE( 'h982F, 30 );
		SCC_POKE( 'h9830, 32 );
		SCC_POKE( 'h9831, 34 );
		SCC_POKE( 'h9832, 36 );
		SCC_POKE( 'h9833, 38 );
		SCC_POKE( 'h9834, 40 );
		SCC_POKE( 'h9835, 42 );
		SCC_POKE( 'h9836, 44 );
		SCC_POKE( 'h9837, 46 );
		SCC_POKE( 'h9838, 48 );
		SCC_POKE( 'h9839, 50 );
		SCC_POKE( 'h983A, 52 );
		SCC_POKE( 'h983B, 54 );
		SCC_POKE( 'h983C, 56 );
		SCC_POKE( 'h983D, 58 );
		SCC_POKE( 'h983E, 60 );
		SCC_POKE( 'h983F, 62 );

		SCC_POKE( 'h988F, 2 );

		SCC_POKE( 'h9882, 253 );
		SCC_POKE( 'h9883, 0 );

		SCC_POKE( 'h988B, 8 );

		SCC_CLOCK( 50000 );
		end_of_test();
	end
endmodule
