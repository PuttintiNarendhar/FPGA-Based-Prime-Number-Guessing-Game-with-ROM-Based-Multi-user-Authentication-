// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: PrimeRandomIndexGenerator
// Description: Generates random index values for different prime game levels
// using selected bits from a 16-bit LFSR.

module RandomIndexLFSR(clk, rst, level1_index, level2_index, level3_index);

    input clk;
    input rst;

    output [2:0] level1_index;
    output [3:0] level2_index;
    output [4:0] level3_index;

    wire [15:0] lfsr_value;

    PrimeLFSR PrimeLFSR_Module(
        clk,
        rst,
        lfsr_value
    );

    assign level1_index = {lfsr_value[13], lfsr_value[10], lfsr_value[6]};
    assign level2_index = {lfsr_value[14], lfsr_value[11], lfsr_value[8], lfsr_value[5]};
    assign level3_index = {lfsr_value[15], lfsr_value[12], lfsr_value[9], lfsr_value[7], lfsr_value[4]};

endmodule