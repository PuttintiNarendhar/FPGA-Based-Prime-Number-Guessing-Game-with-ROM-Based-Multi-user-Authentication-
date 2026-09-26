// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: RandomNumberGenerator
// Description: This module generates a 4-bit pseudo-random number using
// a 4-bit LFSR. The LFSR advances when rngEnable is HIGH.
// Comments/Log: Lab 4 bonus feature - LFSR-based RNG.

module RandomNumberGenerator(randomNum, rngEnable, clk, rst);

    input clk, rst;
    input rngEnable;
    output [3:0] randomNum;

    reg [3:0] randomNum;
    wire feedback;

    assign feedback = randomNum[3] ^ randomNum[2];

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            randomNum <= 4'b0001;   // nonzero seed
        end
        else if (rngEnable == 1'b1) begin
            randomNum <= {randomNum[2:0], feedback};
        end
    end

endmodule