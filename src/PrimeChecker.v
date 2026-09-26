module PrimeChecker(
    input [7:0] number,
    output reg is_prime
);

always @(*) begin
    case(number)
        8'd2, 8'd3, 8'd5, 8'd7,
        8'd11, 8'd13, 8'd17, 8'd19, 8'd23,
        8'd29, 8'd31, 8'd37, 8'd41, 8'd43,
        8'd47, 8'd53, 8'd59, 8'd61, 8'd67,
        8'd71, 8'd73, 8'd79, 8'd83, 8'd89, 8'd97:
            is_prime = 1'b1;
        default:
            is_prime = 1'b0;
    endcase
end

endmodule