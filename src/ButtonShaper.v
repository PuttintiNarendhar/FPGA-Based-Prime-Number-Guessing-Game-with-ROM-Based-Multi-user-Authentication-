// ECE6370 : ADD
// Author: Dharani Kandhalam - 1389
// ButtonShaper
// -------------------------------------------------------------
// ButtonShaper
//
// This module converts a mechanical push button input into a
// single clock-cycle pulse.
//
// • Push buttons may produce multiple transitions due to bouncing.
// • This FSM ensures only one clean pulse is generated per press.
// • Output (B_out) goes high for exactly one clock cycle when the
//   button is pressed.
//
// States:
// INIT  -> waits for button press
// PULSE -> generates one clock pulse
// WAIT  -> waits until button is released
// -------------------------------------------------------------
module ButtonShaper(B_in, B_out, clk, rst);

    input B_in;
    output B_out;
    input clk, rst;
    reg B_out;

    parameter INIT = 0, PULSE = 1, WAIT = 2;

    reg [2:0] State, StateNext;

    // Combinational Logic using blocking assignment
    always @(State, B_in) begin
        case (State)

            INIT: begin
                      B_out = 1'b0;
                      if (B_in == 1'b0)
                          StateNext = PULSE;
                      else
                          StateNext = INIT;
            	  end

            PULSE: begin
                       B_out = 1'b1;
                       StateNext = WAIT;
            	   end

            WAIT: begin
                      B_out = 1'b0;
                      if (B_in == 1'b1)
                    	  StateNext = INIT;
                      else
                          StateNext = WAIT;
                  end

            default: begin
                         B_out = 1'b0;
                         StateNext = INIT;
                     end

        endcase
    end

    // StateRegister using non-blocking assignment
    always @(posedge clk) begin
        if (rst == 1'b0)
            State <= INIT;
        else
            State <= StateNext;
    end

endmodule
