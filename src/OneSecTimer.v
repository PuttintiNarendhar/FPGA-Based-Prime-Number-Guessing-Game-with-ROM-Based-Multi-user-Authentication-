// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: OneSecTimer
// Description: This module generates a one-second timeout pulse using
// three smaller timer stages. The first stage uses the Lab 4 LFSR-based
// 1 ms timer, followed by the 100 ms timer and the count-to-10 timer.
// Comments/Log: Updated for Lab 4 by replacing the regular 1 ms timer
// with the LFSR-based 1 ms timer.

module OneSecTimer(enable, clk, rst, OneSecTimeout);

input enable, clk, rst;
output OneSecTimeout;

wire msecTimeOut;
wire hundredmsecTimeOut;
wire [15:0] q_unused;

// Replace regular msecTimer with LFSR-based version
msecTimer_LFSR DUT_msecTimer_LFSR(enable, clk, rst, msecTimeOut, q_unused);

hundredmsecTimer DUT_hundredmsecTimer(msecTimeOut, clk, rst, hundredmsecTimeOut);

countTo10Timer DUT_countTo10Timer(hundredmsecTimeOut, clk, rst, OneSecTimeout);

endmodule