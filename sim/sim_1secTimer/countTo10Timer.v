// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: countTo10Timer
// Description: This module generates the final OneSecTimeout pulse by
// counting 10 enable pulses. When enable is HIGH, the counter increments
// from 0 to 9. Once the terminal count is reached, the counter resets
// and produces a one-clock-cycle OneSecTimeout pulse.
// Comments/Log: This module is used as the final stage in the nested
// OneSecTimer design for Lab 3.

module countTo10Timer(enable, clk, rst, OneSecTimeout);

input enable, clk, rst;
output OneSecTimeout;

reg OneSecTimeout;
reg [3:0] count;

always @(posedge clk) begin
    if (rst==1'b0) begin
        count <= 0;
        OneSecTimeout <= 0;
    end
    else if (enable==1'b1) begin
        if (count == 4'd9) begin
            count <= 0;
            OneSecTimeout <= 1;
        end
        else begin
            count <= count + 1;
            OneSecTimeout <= 0;
        end
    end
    else
        OneSecTimeout <= 0;
end

endmodule