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

		SCC_POKE( 'h9800, 0 );
		SCC_POKE( 'h9801, 2 );
		SCC_POKE( 'h9802, 4 );
		SCC_POKE( 'h9803, 6 );
		SCC_POKE( 'h9804, 8 );
		SCC_POKE( 'h9805, 10 );
		SCC_POKE( 'h9806, 12 );
		SCC_POKE( 'h9807, 14 );
		SCC_POKE( 'h9808, 16 );
		SCC_POKE( 'h9809, 18 );
		SCC_POKE( 'h980A, 20 );
		SCC_POKE( 'h980B, 22 );
		SCC_POKE( 'h980C, 24 );
		SCC_POKE( 'h980D, 26 );
		SCC_POKE( 'h980E, 28 );
		SCC_POKE( 'h980F, 30 );
		SCC_POKE( 'h9810, 32 );
		SCC_POKE( 'h9811, 34 );
		SCC_POKE( 'h9812, 36 );
		SCC_POKE( 'h9813, 38 );
		SCC_POKE( 'h9814, 40 );
		SCC_POKE( 'h9815, 42 );
		SCC_POKE( 'h9816, 44 );
		SCC_POKE( 'h9817, 46 );
		SCC_POKE( 'h9818, 48 );
		SCC_POKE( 'h9819, 50 );
		SCC_POKE( 'h981A, 52 );
		SCC_POKE( 'h981B, 54 );
		SCC_POKE( 'h981C, 56 );
		SCC_POKE( 'h981D, 58 );
		SCC_POKE( 'h981E, 60 );
		SCC_POKE( 'h981F, 62 );

		SCC_POKE( 'h988F, 1 );

		SCC_POKE( 'h9880, 253 );
		SCC_POKE( 'h9881, 0 );

		SCC_POKE( 'h988A, 8 );

		SCC_CLOCK( 50000 );
		end_of_test();
	end
endmodule
