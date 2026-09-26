module PrimeROM(
    input [4:0] address,
    output reg [7:0] prime
);

always @(*) begin
    case(address)
        5'd0:  prime = 8'd2;
        5'd1:  prime = 8'd3;
        5'd2:  prime = 8'd5;
        5'd3:  prime = 8'd7;
        5'd4:  prime = 8'd11;
        5'd5:  prime = 8'd13;
        5'd6:  prime = 8'd17;
        5'd7:  prime = 8'd19;
        5'd8:  prime = 8'd23;
        5'd9:  prime = 8'd29;
        5'd10: prime = 8'd31;
        5'd11: prime = 8'd37;
        5'd12: prime = 8'd41;
        5'd13: prime = 8'd43;
        5'd14: prime = 8'd47;
        5'd15: prime = 8'd53;
        5'd16: prime = 8'd59;
        5'd17: prime = 8'd61;
        5'd18: prime = 8'd67;
        5'd19: prime = 8'd71;
        5'd20: prime = 8'd73;
        5'd21: prime = 8'd79;
        5'd22: prime = 8'd83;
        5'd23: prime = 8'd89;
        5'd24: prime = 8'd97;
        default: prime = 8'd2;
    endcase
end

endmodule