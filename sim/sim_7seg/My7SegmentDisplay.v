module My7SegmentDecoder_4To7(Decoder_In, Decoder_Out);
    input [3:0] Decoder_In;
    output [6:0] Decoder_Out;
    reg [6:0] Decoder_Out;

    always @(Decoder_In)
        begin
            case(Decoder_In)
		4'b0000: begin Decoder_Out = 7'b0000001; end
        	4'b0001: begin Decoder_Out = 7'b1001111; end
        	4'b0010: begin Decoder_Out = 7'b0010010; end
        	4'b0011: begin Decoder_Out = 7'b0000110; end
        	4'b0100: begin Decoder_Out = 7'b1001100; end
        	4'b0101: begin Decoder_Out = 7'b0100100; end
        	4'b0110: begin Decoder_Out = 7'b0100000; end
        	4'b0111: begin Decoder_Out = 7'b0001111; end
        	4'b1000: begin Decoder_Out = 7'b0000000; end
        	4'b1001: begin Decoder_Out = 7'b0000100; end
        	4'b1010: begin Decoder_Out = 7'b0001000; end
        	4'b1011: begin Decoder_Out = 7'b1100000; end
        	4'b1100: begin Decoder_Out = 7'b0110001; end
        	4'b1101: begin Decoder_Out = 7'b1000010; end
        	4'b1110: begin Decoder_Out = 7'b0110000; end
        	4'b1111: begin Decoder_Out = 7'b0111000; end
        	default: begin Decoder_Out = 7'b1111111; end
	    endcase
	end 

endmodule

