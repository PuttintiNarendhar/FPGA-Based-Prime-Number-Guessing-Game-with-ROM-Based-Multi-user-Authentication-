`timescale 1 ns/100 ps
module testbench_OneSecTimer();

reg enable, clk, rst;
wire OneSecTimeout;


// clock
always
	begin
		clk = 1'b0;
		#10;
		clk = 1'b1;
		#10;
	end


// DUT instantiation
OneSecTimer DUT_OneSecTimer1(enable, clk, rst, OneSecTimeout);


initial
	begin

		rst = 1'b1;
		enable = 1'b0;

		@(posedge clk); // forces the signal to next rising edge
		@(posedge clk);

		// Reset pulse
		#5 rst = 1'b0;

		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		// release reset
		#5 rst = 1'b1;

		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		// enable timer
		#5 enable = 1'b1;

		// run simulation long enough to see two timeout pulses
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);   // ? 24 cycles ? first timeout

		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);   // ? 48 cycles ? second timeout

	end

endmodule