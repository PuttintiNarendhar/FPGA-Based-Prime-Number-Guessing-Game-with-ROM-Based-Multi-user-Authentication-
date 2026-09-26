`timescale 1 ns/100 ps
module testbench_ButtonShaper();

    reg clk, rst, B_in;
    wire B_out;

    //clock
    always
        begin
            clk = 1'b0;
            #10;
            clk = 1'b1;
            #10;
        end

    ButtonShaper DUT_MyButtonShaper(B_in, B_out, clk, rst);

    initial
        begin
            rst = 1'b1;     // inactive (since reset is active-low)
            B_in = 1'b1;    // start high -> INIT will stay in INIT

            @(posedge clk); // forces the signal to next rising edge of the clock
            @(posedge clk);
	        @(posedge clk);
            //Reset
            //it pulls down the signal 5ns after the clock edge
            #5 rst = 1'b0; //press reset
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            //pulled the reset button backup
            #5 rst = 1'b1;
            @(posedge clk);
            @(posedge clk);

            // ---- Test 1: INIT -> PULSE -> WAIT (B_in goes 0) ----
            // INIT stays while B_in=1, then B_in=0 triggers PULSE on next clock
            #5 B_in = 1'b0;
	    // hold for 10 cycles
            @(posedge clk);   
            @(posedge clk);   
	    @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);	


            // release button back to 1
	    #5 B_in = 1'b1;
            @(posedge clk);
            @(posedge clk);

            // Another long press example (20 cycles)
            #5 B_in = 1'b0;
            @(posedge clk);   
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);   
            @(posedge clk);   
	        @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);	

            //release the button 
            #5 B_in = 1'b1;
            @(posedge clk);   
            @(posedge clk);   


        end

endmodule
