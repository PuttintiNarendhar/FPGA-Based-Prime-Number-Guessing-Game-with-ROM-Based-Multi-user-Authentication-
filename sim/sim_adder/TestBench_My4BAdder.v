`timescale 1 ns/100 ps
module TestBench_My4BAdder();
    reg [3:0] Num1_s, Num2_s;
    wire [3:0] Sum_s;
    
    My4BAdder DUT_My4BAdder(Num1_s, Num2_s, Sum_s);

    initial
        begin
            // Initialize inputs
      	    Num1_s = 4'b0000; Num2_s = 4'b0000;
	    
            //Matching combination: 5+10 == 15
	    #10 Num1_s = 4'b0101; Num2_s = 4'b1010;
	    
            //Non-Matching combination: 1+11 < 15
            #10 Num1_s = 4'b0001; Num2_s = 4'b1011;

            //Non-Matching combination: 3+1 < 15
            #10 Num1_s = 4'b0011; Num2_s = 4'b0001;
	    
	    //Non-Matching combination: 9+8 > 15 
	    #10 Num1_s = 4'b1001; Num2_s = 4'b1000;

	    //Non-Matching combination: 15+15 > 15
	    #10 Num1_s = 4'b1111; Num2_s = 4'b1111;
    
            //Matching: 7+8 == 15
            #10 Num1_s = 4'b0111; Num2_s = 4'b1000;
        end
endmodule