// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: Scoreboard
// Description: This module implements a two-digit BCD scoreboard.
// It increments once for each valid correct load event and resets to 00
// when reconfig is asserted or reset is active.

module Scoreboard(scoreTens, scoreOnes, load_pulse, correct_led, timeout, reconfig, clk, rst);

	input clk, rst;
	input load_pulse, correct_led, timeout, reconfig;
	output [3:0] scoreTens, scoreOnes;

	reg [3:0] scoreTens, scoreOnes;
	reg load_pulse_d;

	always @(posedge clk) begin
		if (rst == 1'b0) begin
			scoreTens <= 4'd0;
			scoreOnes <= 4'd0;
			load_pulse_d <= 1'b0;
		end
		else begin
			load_pulse_d <= load_pulse;

			if (reconfig == 1'b1) begin
				scoreTens <= 4'd0;
				scoreOnes <= 4'd0;
			end
			else if ((load_pulse_d == 1'b1) && (correct_led == 1'b1) && (timeout == 1'b0)) begin
				if ((scoreTens == 4'd9) && (scoreOnes == 4'd9)) begin
					scoreTens <= 4'd9;
					scoreOnes <= 4'd9;
				end
				else if (scoreOnes == 4'd9) begin
					scoreOnes <= 4'd0;
					scoreTens <= scoreTens + 4'd1;
				end
				else begin
					scoreOnes <= scoreOnes + 4'd1;
				end
			end
		end
	end

endmodule