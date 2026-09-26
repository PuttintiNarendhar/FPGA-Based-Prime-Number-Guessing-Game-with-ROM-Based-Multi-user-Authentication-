// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: ROMAuthentication
// Description: This module authenticates the user by comparing the entered
// password digits against the default password stored in ROM. The user enters
// one digit at a time using PasswordSwitches[3:0] and presses B_password for
// each digit. The FSM fetches the expected digit from ROM, waits for ROM data,
// captures it, compares it with the entered digit, and repeats for all four
// digits. If all digits match, Passed is asserted and the system enters the
// logged-in state.
// Comments/Log: Lab 4 required ROM-based authentication module.

module ROMAuthentication(
    input        clk,
    input        rst,
    input        B_password,              // shaped shared button for password entry
    input  [3:0] PasswordSwitches,        // password switches
    output reg   Passed,
    output reg   Logged_In,
    output reg   Logged_Out
);

    // ROM interface
    reg  [4:0] ROMAddr;
    wire [3:0] ROMData;

    ROM_PSWD DUT_ROM_PSWD (
        .address(ROMAddr),
        .clock(clk),
        .q(ROMData)
    );

    // FSM state encoding
    reg [3:0] State;
    reg [3:0] NextState;

    localparam S_CHECK_BUTTON = 4'd0,
               S_FETCH_ROM    = 4'd1,
               S_ROM_CYC1     = 4'd2,
               S_ROM_CYC2     = 4'd3,
               S_ROM_CATCH    = 4'd4,
               S_COMPARE      = 4'd5,
               S_VERIFY       = 4'd6,
               S_SUCCESS      = 4'd7,
               S_FAIL         = 4'd8;

    // Internal registers
    reg [1:0] Cnt;                 // digit index: 0,1,2,3
    reg [3:0] Player_digit;        // captured entered digit
    reg [3:0] ROM_digit;           // captured ROM digit
    reg       MatchOK;             // compare result for current digit

    // Sequential block
    always @(posedge clk) begin
        if (rst == 1'b0) begin
            State        <= S_CHECK_BUTTON;
            ROMAddr      <= 5'd0;
            Cnt          <= 2'd0;
            Player_digit <= 4'd0;
            ROM_digit    <= 4'd0;
            MatchOK      <= 1'b0;
            Passed       <= 1'b0;
            Logged_In    <= 1'b0;
            Logged_Out   <= 1'b1;
        end
        else begin
            State <= NextState;

            case (State)
                S_CHECK_BUTTON: begin
                    // waiting for one digit entry
                    if (Passed == 1'b0 && B_password == 1'b1) begin
                        Player_digit <= PasswordSwitches;
                        ROMAddr <= {3'b000, Cnt};
                    end
                end

                S_FETCH_ROM: begin
                    ROMAddr <= {3'b000, Cnt};
                end

                S_ROM_CYC1: begin
                    ROMAddr <= {3'b000, Cnt};
                end

                S_ROM_CYC2: begin
                    ROMAddr <= {3'b000, Cnt};
                end

                S_ROM_CATCH: begin
                    ROM_digit <= ROMData;
                end

                S_COMPARE: begin
                    if (Player_digit == ROM_digit)
                        MatchOK <= 1'b1;
                    else
                        MatchOK <= 1'b0;
                end

                S_VERIFY: begin
                    if (MatchOK == 1'b1 && Cnt != 2'd3)
                        Cnt <= Cnt + 2'd1;
                end

                S_SUCCESS: begin
                    Passed     <= 1'b1;
                    Logged_In  <= 1'b1;
                    Logged_Out <= 1'b0;
                end

                S_FAIL: begin
                    Passed     <= 1'b0;
                    Logged_In  <= 1'b0;
                    Logged_Out <= 1'b1;
                    Cnt        <= 2'd0;
                    MatchOK    <= 1'b0;
                end

                default: begin
                end
            endcase
        end
    end

    // Next-state logic
    always @(*) begin
        NextState = State;

        case (State)
            S_CHECK_BUTTON: begin
                if (Passed == 1'b1)
                    NextState = S_SUCCESS;
                else if (B_password == 1'b1)
                    NextState = S_FETCH_ROM;
                else
                    NextState = S_CHECK_BUTTON;
            end

            S_FETCH_ROM: begin
                NextState = S_ROM_CYC1;
            end

            S_ROM_CYC1: begin
                NextState = S_ROM_CYC2;
            end

            S_ROM_CYC2: begin
                NextState = S_ROM_CATCH;
            end

            S_ROM_CATCH: begin
                NextState = S_COMPARE;
            end

            S_COMPARE: begin
                NextState = S_VERIFY;
            end

            S_VERIFY: begin
                if (MatchOK == 1'b0)
                    NextState = S_FAIL;
                else if (Cnt == 2'd3)
                    NextState = S_SUCCESS;
                else
                    NextState = S_CHECK_BUTTON;
            end

            S_SUCCESS: begin
                NextState = S_SUCCESS;
            end

            S_FAIL: begin
                NextState = S_CHECK_BUTTON;
            end

            default: begin
                NextState = S_CHECK_BUTTON;
            end
        endcase
    end

endmodule