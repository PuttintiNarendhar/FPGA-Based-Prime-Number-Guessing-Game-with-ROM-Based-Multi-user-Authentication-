// ECE6370 : ADD
// Author: Dharani Kandhalam - 1389
// Verification Module
// Description: It checkes sum of player1+player2 == 15 or not
// if sum == 15 - we are turing on the Leftmost LED on Board, if not we are 
// turing on RightMost LED on Board

module VerificationModule(Sum, LED_Left, LED_Right);
	input  [3:0] Sum;
    output       LED_Left, LED_Right; // one bit outputs


    assign LED_Left  = (Sum == 4'b1111);  // ON if sum = 15
    assign LED_Right = (Sum != 4'b1111);  // ON otherwise

endmodule