module OneSecTimer(enable, clk, rst, OneSecTimeout);

input enable, clk, rst;
output OneSecTimeout;

wire msecTimeOut;
wire hundredmsecTimeOut;

msecTimer DUT_msecTimer(enable, clk, rst, msecTimeOut);
hundredmsecTimer DUT_hundredmsecTimer(msecTimeOut, clk, rst, hundredmsecTimeOut);
countTo10Timer DUT_countTo10Timer(hundredmsecTimeOut, clk, rst, OneSecTimeout);

endmodule
