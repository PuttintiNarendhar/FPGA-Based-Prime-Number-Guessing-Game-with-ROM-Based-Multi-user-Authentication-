`timescale 1 ns/100 ps
module testbench_LoadRegister();
	reg clk, Rst, load;
	reg [3:0] Reg_Input;
	wire [3:0] Reg_Output;


	//clock
	always 
		begin
			clk = 1'b0;
			#10;
			clk = 1'b1;
			#10;
		end
	
	LoadRegister DUT_MyLoadRegister1(Reg_Input, Reg_Output, clk, Rst, load);
	
	initial 
		begin 
			Rst = 1'b1;
			load = 1'b0;
			Reg_Input = 4'b0000;
			@(posedge clk); // forces the signal to next rising edge of the clock
			@(posedge clk);
			//Reset
			//it pulls down the signal 5ns after the clock edge 
			#5 Rst = 1'b0;
			@(posedge clk);
    		@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			//pulled the reset button backup 
			#5 Rst = 1'b1;
			@(posedge clk);
    		@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			#5 Reg_Input = 4'b0001;
			@(posedge clk);
			#5 load = 1'b1;
			@(posedge clk);
			//pushing back the load button to zero for next operations
			#5 load = 1'b0;
			@(posedge clk);
			#5 Reg_Input = 4'b1111;			
			@(posedge clk);
    		@(posedge clk);
			@(posedge clk);
			#5 Reg_Input = 4'b0111;
			@(posedge clk);
			@(posedge clk);
			#5 load = 1'b1;
    		@(posedge clk);
			#5 load = 1'b0;
			@(posedge clk);

		end
		
endmodule