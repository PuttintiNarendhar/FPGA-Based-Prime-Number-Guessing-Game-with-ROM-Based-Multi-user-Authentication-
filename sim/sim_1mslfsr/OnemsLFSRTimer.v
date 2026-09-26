// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: msecTimer_LFSR
// Description: This module generates a one-clock-cycle msecTimeOut pulse
// using a 16-bit LFSR. When enable is HIGH, the LFSR advances one state
// per clock cycle. If the next LFSR state matches the identified terminal
// value, the module generates the timeout pulse in the same cycle.
// Comments/Log: Final LFSR-based replacement for the regular 1 ms timer.

module msecTimer_LFSR(enable, clk, rst, msecTimeOut, q);

input enable, clk, rst;
output msecTimeOut;
output [15:0] q;

reg msecTimeOut;
reg [15:0] LFSR;

wire feedback;
wire [15:0] next_lfsr;

parameter TERMINAL_VALUE = 16'hb11f;

assign feedback = LFSR[15];

// next-state logic
assign next_lfsr[0]  = feedback;
assign next_lfsr[1]  = LFSR[0];
assign next_lfsr[2]  = LFSR[1] ^ feedback;
assign next_lfsr[3]  = LFSR[2] ^ feedback;
assign next_lfsr[4]  = LFSR[3];
assign next_lfsr[5]  = LFSR[4] ^ feedback;
assign next_lfsr[6]  = LFSR[5];
assign next_lfsr[7]  = LFSR[6];
assign next_lfsr[8]  = LFSR[7];
assign next_lfsr[9]  = LFSR[8];
assign next_lfsr[10] = LFSR[9];
assign next_lfsr[11] = LFSR[10];
assign next_lfsr[12] = LFSR[11];
assign next_lfsr[13] = LFSR[12];
assign next_lfsr[14] = LFSR[13];
assign next_lfsr[15] = LFSR[14];

assign q = LFSR;

always @(posedge clk) begin
    if (rst == 1'b0) begin
        LFSR <= 16'h0001;
        msecTimeOut <= 1'b0;
    end
    else if (enable == 1'b1) begin
        if (next_lfsr == TERMINAL_VALUE) begin
            LFSR <= 16'h0001;      // restart sequence
            msecTimeOut <= 1'b1;   // pulse aligned with old timer
        end
        else begin
            LFSR <= next_lfsr;
            msecTimeOut <= 1'b0;
        end
    end
    else begin
        msecTimeOut <= 1'b0;
    end
end

endmodule