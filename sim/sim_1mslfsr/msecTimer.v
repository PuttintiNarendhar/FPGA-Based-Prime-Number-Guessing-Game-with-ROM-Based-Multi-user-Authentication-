// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: msecTimer
// Description: This module generates a one-clock-cycle msecTimeOut pulse
// by counting clock cycles when enable is HIGH. When the count reaches
// 49999, the counter resets and the module produces the timeout pulse.
// Comments/Log: This module is used as the first stage in the nested
// OneSecTimer design for Lab 3.

module msecTimer(enable, clk, rst, msecTimeOut);

input enable, clk, rst;
output msecTimeOut;

reg msecTimeOut;
reg [15:0] count;

always @(posedge clk) begin
    if (rst == 1'b0) begin
        count <= 0;
        msecTimeOut <= 0;
    end
    else if (enable == 1'b1) begin
        if (count == 16'd49999) begin
            count <= 0;
            msecTimeOut <= 1;
        end
        else begin
            count <= count + 1;
            msecTimeOut <= 0;
        end
    end
    else
        msecTimeOut <= 0;
end

endmodule