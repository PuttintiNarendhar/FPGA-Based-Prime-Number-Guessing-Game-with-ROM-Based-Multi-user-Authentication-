// ECE6370 : ADD
// Author: Dharani Kandhalam - 1389
// -------------------------------------------------------------
// LoadRegister
// This module stores a 4-bit value when the load signal is high.
// The register updates its output only when the LOAD button is
// pressed, preventing intermediate switch changes from affecting
// the system.
// • If load = 1 → input value is stored in register.
// • If load = 0 → previous value is retained.
// • Active-low reset clears the register to 0.
//
// Used in Lab2 to store Player 1 and Player 2 numbers only after
// the corresponding LOAD button is pressed.
// -------------------------------------------------------------
module LoadRegister(Reg_Input, Reg_Output, clk, Rst, load);
	input [3:0] Reg_Input;
	output [3:0] Reg_Output;
	input clk, Rst, load;
	
	reg [3:0] Reg_Output;
	
	always @(posedge clk)
		begin 
			if(Rst == 1'b0)
				begin
					//reset condition
					Reg_Output <= 4'b0000;
				end
			else
				//normal operation after reset where it follows input
				begin 
					if(load == 1'b1) //whenever load button is pushed we are sending input to output
						begin
							Reg_Output <= Reg_Input;
						end
				end
		end
endmodule
	
