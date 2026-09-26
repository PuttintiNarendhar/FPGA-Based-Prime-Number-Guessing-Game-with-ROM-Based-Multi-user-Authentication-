// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: twoDigitTimer
// Description: This module implements a two-digit decimal countdown timer
// using two cascaded one-digit timer modules. The ones digit receives the
// one-second pulse and generates a borrow signal to the tens digit when it
// rolls over from 0 to 9. The timer is initialized to 99 using the reconfig
// signal and counts down to 00. The timeOut signal is asserted when the
// timer reaches its final state.

module TwoDigitTimer(Tensdigit, Onesdigit, TimeOut, Timer_enable, Timer_reconfig, clk, rst);

	input clk, rst;
	input Timer_enable, Timer_reconfig;
	output [3:0] Tensdigit, Onesdigit;
	output TimeOut;

	wire reload_ones;
	wire enable_tens;
	wire timer_done;

	assign timer_done = (Tensdigit == 4'd0) && (Onesdigit == 4'd0);

	assign reload_ones = Timer_enable && (Onesdigit == 4'd0) && (Tensdigit != 4'd0);
	assign enable_tens = Timer_enable && (Onesdigit == 4'd0) && (Tensdigit != 4'd0);

	OneDigitTimer ones_digit(Onesdigit, Timer_enable && !timer_done, reload_ones, Timer_reconfig, clk, rst);

	OneDigitTimer tens_digit(Tensdigit, enable_tens, 1'b0, Timer_reconfig, clk, rst);

	assign TimeOut = timer_done;

endmodule