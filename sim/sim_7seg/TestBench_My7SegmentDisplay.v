`timescale 1 ns/100 ps 
module TestBench_My7SegmentDecoder_4To7();
    reg [3:0] Decoder_In_s;
    wire [6:0] Decoder_Out_s;
    
    My7SegmentDecoder_4To7 DUT_My7SegmentDecoder_4To7(Decoder_In_s, Decoder_Out_s);

    initial
        begin
	    Decoder_In_s = 4'b0000;
            #10 Decoder_In_s = 4'b0001;
            #10 Decoder_In_s = 4'b0010;
            #10 Decoder_In_s = 4'b0011;
            #10 Decoder_In_s = 4'b0100;
            #10 Decoder_In_s = 4'b0101;
            #10 Decoder_In_s = 4'b0110;
            #10 Decoder_In_s = 4'b0111;
            #10 Decoder_In_s = 4'b1000;
            #10 Decoder_In_s = 4'b1001;
            #10 Decoder_In_s = 4'b1010;
            #10 Decoder_In_s = 4'b1011;
            #10 Decoder_In_s = 4'b1100;
            #10 Decoder_In_s = 4'b1101;
            #10 Decoder_In_s = 4'b1110;
            #10 Decoder_In_s = 4'b1111;
	end 

endmodule