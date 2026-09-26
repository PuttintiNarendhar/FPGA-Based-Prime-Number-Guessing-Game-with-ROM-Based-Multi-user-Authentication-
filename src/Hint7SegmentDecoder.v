// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: Hint7SegmentDecoder
// Description: Decodes game hint codes to 7-segment display patterns.
// Active-low 7-segment display.

module Hint7SegmentDecoder(Hint_In, Hint_Out);

    input [2:0] Hint_In;
    output [6:0] Hint_Out;
    reg [6:0] Hint_Out;

    // Hint code definitions:
    // 000 = blank
    // 001 = G  (GO)
    // 010 = F  (wrong / not prime)
    // 011 = S  (too small)
    // 100 = L  (too large)
    // 101 = C  (correct)

    always @(Hint_In) begin
        case(Hint_In)
            3'b000: begin Hint_Out = 7'b1000000; end // blank

            // G approximation, similar to 6
            3'b001: begin Hint_Out = 7'b1000010; end // G

            // F
            3'b010: begin Hint_Out = 7'b0001110; end // F

            // S approximation, same as 5
            3'b011: begin Hint_Out = 7'b0010010; end // S

            // L
            3'b100: begin Hint_Out = 7'b1000111; end // L

            // C
            3'b101: begin Hint_Out = 7'b1000110; end // C

            default: begin Hint_Out = 7'b1111111; end // blank
        endcase
    end

endmodule