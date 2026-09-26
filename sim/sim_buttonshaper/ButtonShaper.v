
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
