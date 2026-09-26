// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: RandomNumberGenerator
// Description: This module implements a hardware-based random number
// generator using a 4-bit counter. When the random number generation
// button is pressed, the counter increments continuously on each rising
// edge of the clock. When the button is released, the counter stops and
// the last counter value is used as the random number output.

module RandomNumberGenerator(randomNum, rngButton, clk, rst);
	input clk, rst;
	input rngButton;
	output [3:0] randomNum;

	reg [3:0] randomNum;

	always @(posedge clk) begin
		if (rst == 1'b0) begin
			randomNum <= 4'd0;
		end
		else begin
			// button is active low, so count when pressed
			if (rngButton == 1'b0) begin
				randomNum <= randomNum + 4'd1;
			end
		end
	end

endmodule