// ECE6370 : ADD
// Author: Dharani Kandhalam - 1389
// AccessController

// -------------------------------------------------------------
// AccessControl FSM (One Procedure Implementation)
//
// This module implements a 4-digit password based access control
// system using a Finite State Machine (FSM).
//
// ? The system checks password digits sequentially when
//   PasswordEnterKey is pressed.
//
// ? If all digits are correct ?
//      - Logged_In = 1
//      - Logged_Out = 0
//      - load inputs are passed to outputs.
//
// ? If any digit is incorrect ?
//      - system resets to first digit state.
//
// ? Reset (rst = 0) initializes system to logged-out state
//   and clears outputs.
//
// States Flow:
// DIGIT1 ? DIGIT2 ? DIGIT3 ? DIGIT4 ? VERIFY ? PASSED
// -------------------------------------------------------------


module AccessControl_OneProcedure(PasswordEnterKey, PasswordDigit, LogoutKey, Load_P1_In, Load_P2_In,
                                  Logged_In, Logged_Out, Load_P1_Out, Load_P2_Out, clk, rst);

    input  [3:0] PasswordDigit;
    input  PasswordEnterKey, LogoutKey, clk, rst;
    input  Load_P1_In, Load_P2_In;

    output Logged_In, Logged_Out;
    output Load_P1_Out, Load_P2_Out;

    reg Logged_In, Logged_Out;
    reg Load_P1_Out, Load_P2_Out;

    parameter DIGIT1 = 0, DIGIT2 = 1, DIGIT3 = 2, DIGIT4 = 3, VERIFY = 4, PASSED = 5;
    reg [2:0] State;
    reg soFarSoGood;

    //one procedural block using non blocking assignments
    always @(posedge clk) begin

        if (rst == 1'b0) begin
            State       <= DIGIT1;
            soFarSoGood <= 1'b1;

            Logged_In   <= 1'b0;
            Logged_Out  <= 1'b1;

            Load_P1_Out <= 1'b0;
            Load_P2_Out <= 1'b0;
        end

        else begin
            case (State)

                DIGIT1: begin
                    soFarSoGood <= 1'b1;
                    Logged_In   <= 1'b0;
                    Logged_Out  <= 1'b1;
                    Load_P1_Out <= 1'b0;
                    Load_P2_Out <= 1'b0;

                    if (PasswordEnterKey == 1'b1) begin
                        if (PasswordDigit == 4'b0001) //1
                            State <= DIGIT2;
                        else begin
                            soFarSoGood <= 1'b0;
                            State       <= DIGIT1;
                        end
                    end
                    else
                        State <= DIGIT1;
                end

                DIGIT2: begin
                    if (PasswordEnterKey == 1'b1) begin
                        if (PasswordDigit == 4'b0011) //3
                            State <= DIGIT3;
                        else begin
                            soFarSoGood <= 1'b0;
                            State       <= DIGIT1;
                        end
                    end
                    else
                        State <= DIGIT2;
                end

                DIGIT3: begin
                    if (PasswordEnterKey == 1'b1) begin
                        if (PasswordDigit == 4'b1000) //8
                            State <= DIGIT4;
                        else begin
                            soFarSoGood <= 1'b0;
                            State       <= DIGIT1;
                        end
                    end
                    else
                        State <= DIGIT3;
                end

                DIGIT4: begin
                    if (PasswordEnterKey == 1'b1) begin
                        if (PasswordDigit == 4'b1001) //9
                            State <= VERIFY;
                        else begin
                            soFarSoGood <= 1'b0;
                            State       <= DIGIT1;
                        end
                    end
                    else
                        State <= DIGIT4;
                end

                VERIFY: begin
                    if (soFarSoGood == 1'b1)
                        State <= PASSED;
                    else
                        State <= DIGIT1;
                end

                PASSED: begin
                    // Bonus: Log Out function
                    // If logged out, LOAD should not load any new numbers.
                    // Player should be allowed to log in again.
                    if (LogoutKey == 1'b1) begin
                        Logged_In   <= 1'b0;
                        Logged_Out  <= 1'b1;
                        Load_P1_Out <= 1'b0;
                        Load_P2_Out <= 1'b0;

                        soFarSoGood <= 1'b1;
                        State       <= DIGIT1;   // allow login again
                    end
                    else begin
                        Load_P1_Out <= Load_P1_In;  // allow LOAD only when authenticated
                        Load_P2_Out <= Load_P2_In;

                        Logged_In   <= 1'b1;
                        Logged_Out  <= 1'b0;

                        State <= PASSED;
                    end
                end

                default: begin
                    Logged_In   <= 1'b0;
                    Logged_Out  <= 1'b1;
                    Load_P1_Out <= 1'b0;
                    Load_P2_Out <= 1'b0;

                    soFarSoGood <= 1'b1;
                    State       <= DIGIT1;
                end

            endcase
        end
    end

endmodule