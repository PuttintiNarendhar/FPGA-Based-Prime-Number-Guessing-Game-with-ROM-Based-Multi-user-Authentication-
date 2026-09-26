// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: hundredmsecTimer
// Description: This module generates a hundredmsecTimeOut pulse by counting
// clock cycles when enable is HIGH. When the count reaches 99, the module
// resets the counter and produces a one-clock-cycle timeout pulse.
// The active-low reset clears both the counter and the timeout output.
// Comments/Log: This module is used as the intermediate timer stage in the
// nested OneSecTimer design for Lab 3.

module hundredmsecTimer(enable, clk, rst, hundredmsecTimeOut);

input enable, clk, rst;
output hundredmsecTimeOut;

reg hundredmsecTimeOut;
reg [6:0] count;

always @(posedge clk) begin
    if (rst == 1'b0) begin
        count <= 0;
        hundredmsecTimeOut <= 0;
    end
    else if (enable == 1'b1) begin
        if (count == 7'd99) begin
            count <= 0;
            hundredmsecTimeOut <= 1;
        end
        else begin
            count <= count + 1;
            hundredmsecTimeOut <= 0;
        end
    end
    else
        hundredmsecTimeOut <= 0;
end

endmodule