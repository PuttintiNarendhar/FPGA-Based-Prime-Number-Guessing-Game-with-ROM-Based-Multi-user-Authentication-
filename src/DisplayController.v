module DisplayController(clk, rst, ShowGO, Wrong, TooSmall, TooLarge, Correct,
                         GuessTens, GuessOnes, hint_code, left_digit, right_digit);

    input clk;
    input rst;

    input ShowGO;
    input Wrong;
    input TooSmall;
    input TooLarge;
    input Correct;

    input [3:0] GuessTens;
    input [3:0] GuessOnes;

    output [2:0] hint_code;
    output [3:0] left_digit;
    output [3:0] right_digit;

    reg [2:0] hint_code;
    reg [2:0] result_code;

    localparam HINT_ZERO = 3'b000;
    localparam HINT_G    = 3'b001;
    localparam HINT_F    = 3'b010;
    localparam HINT_S    = 3'b011;
    localparam HINT_L    = 3'b100;
    localparam HINT_C    = 3'b101;

    assign left_digit  = GuessTens;
    assign right_digit = GuessOnes;

    // This block controls what is currently shown.
    // G is shown only while ShowGO is high.
    // Otherwise, the last result status is shown.
    always @(*) begin
        if (ShowGO)
            hint_code = HINT_G;
        else
            hint_code = result_code;
    end

    // This block stores only result hints: F, S, L, C.
    // It does NOT store G.
    always @(posedge clk) begin
        if (rst == 1'b0) begin
            result_code <= HINT_ZERO;
        end
        else begin
            if (Wrong)
                result_code <= HINT_F;
            else if (TooSmall)
                result_code <= HINT_S;
            else if (TooLarge)
                result_code <= HINT_L;
            else if (Correct)
                result_code <= HINT_C;
            else
                result_code <= result_code;
        end
    end

endmodule