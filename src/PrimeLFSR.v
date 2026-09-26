module PrimeLFSR(clk, rst, lfsr_out);

    input clk;
    input rst;

    output [15:0] lfsr_out;

    reg [15:0] lfsr_reg;
    wire feedback;

    assign feedback = lfsr_reg[15];

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            lfsr_reg <= 16'hACE1;
        end
        else begin
            lfsr_reg[0]  <= feedback;
            lfsr_reg[1]  <= lfsr_reg[0];
            lfsr_reg[2]  <= lfsr_reg[1] ~^ feedback;
            lfsr_reg[3]  <= lfsr_reg[2] ~^ feedback;
            lfsr_reg[4]  <= lfsr_reg[3];
            lfsr_reg[5]  <= lfsr_reg[4] ~^ feedback;
            lfsr_reg[6]  <= lfsr_reg[5];
            lfsr_reg[7]  <= lfsr_reg[6];
            lfsr_reg[8]  <= lfsr_reg[7];
            lfsr_reg[9]  <= lfsr_reg[8];
            lfsr_reg[10] <= lfsr_reg[9];
            lfsr_reg[11] <= lfsr_reg[10];
            lfsr_reg[12] <= lfsr_reg[11];
            lfsr_reg[13] <= lfsr_reg[12];
            lfsr_reg[14] <= lfsr_reg[13];
            lfsr_reg[15] <= lfsr_reg[14];
        end
    end

    assign lfsr_out = lfsr_reg;

endmodule