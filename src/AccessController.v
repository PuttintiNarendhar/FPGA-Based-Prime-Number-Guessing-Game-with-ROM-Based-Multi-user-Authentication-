// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: AccessControl_Lab3
// Description: This module verifies the password and controls the Lab 3
// game flow. After successful password entry, it sends a one-cycle timer
// reconfiguration pulse, waits for game start, enables gameplay, blocks
// player load and random number generation after timeout, and enables
// scoreboard display during game over.

module AccessControl_Lab3(GameButton, PasswordDigit, RNG_Gen_In, Load_P_In, Timeout,
                          Logged_In, Logged_Out, Load_P_Out, RNG_Gen_Out,
                          Timer_Enable, Timer_Reconfig, ShowScore, clk, rst);

    input [3:0] PasswordDigit;
    input GameButton, RNG_Gen_In, Load_P_In, Timeout, clk, rst;

    output Logged_In, Logged_Out;
    output Load_P_Out, RNG_Gen_Out;
    output Timer_Enable, Timer_Reconfig, ShowScore;

    reg Logged_In, Logged_Out;
    reg Load_P_Out, RNG_Gen_Out;
    reg Timer_Enable, Timer_Reconfig, ShowScore;

    parameter DIGIT1 = 0,
              DIGIT2 = 1,
              DIGIT3 = 2,
              DIGIT4 = 3,
              VERIFY = 4,
              RECONFIGTIMER = 5,
              WAIT_FOR_GAMESTART = 6,
              GAMEPLAY = 7,
              GAMEOVER = 8;

    reg [3:0] State;
    reg soFarSoGood;

    // one procedural block using non-blocking assignments
    always @(posedge clk) begin

        if (rst == 1'b0) begin
            State <= DIGIT1;
            soFarSoGood <= 1'b1;

            Logged_In <= 1'b0;
            Logged_Out <= 1'b1;

            Load_P_Out <= 1'b0;
            RNG_Gen_Out <= 1'b1;     // force unpressed before login
            Timer_Enable <= 1'b0;
            Timer_Reconfig <= 1'b0;
            ShowScore <= 1'b0;
        end

        else begin
            case (State)

                DIGIT1: begin
                    soFarSoGood <= 1'b1;

                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;

                    Load_P_Out <= 1'b0;
                    RNG_Gen_Out <= 1'b1;
                    Timer_Enable <= 1'b0;
                    Timer_Reconfig <= 1'b0;
                    ShowScore <= 1'b0;

                    if (GameButton == 1'b1) begin
                        if (PasswordDigit == 4'b0001) // 1
                            State <= DIGIT2;
                        else begin
                            soFarSoGood <= 1'b0;
                            State <= DIGIT1;
                        end
                    end
                    else
                        State <= DIGIT1;
                end

                DIGIT2: begin
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;

                    Load_P_Out <= 1'b0;
                    RNG_Gen_Out <= 1'b1;
                    Timer_Enable <= 1'b0;
                    Timer_Reconfig <= 1'b0;
                    ShowScore <= 1'b0;

                    if (GameButton == 1'b1) begin
                        if (PasswordDigit == 4'b0011) // 3
                            State <= DIGIT3;
                        else begin
                            soFarSoGood <= 1'b0;
                            State <= DIGIT1;
                        end
                    end
                    else
                        State <= DIGIT2;
                end

                DIGIT3: begin
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;

                    Load_P_Out <= 1'b0;
                    RNG_Gen_Out <= 1'b1;
                    Timer_Enable <= 1'b0;
                    Timer_Reconfig <= 1'b0;
                    ShowScore <= 1'b0;

                    if (GameButton == 1'b1) begin
                        if (PasswordDigit == 4'b1000) // 8
                            State <= DIGIT4;
                        else begin
                            soFarSoGood <= 1'b0;
                            State <= DIGIT1;
                        end
                    end
                    else
                        State <= DIGIT3;
                end

                DIGIT4: begin
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;

                    Load_P_Out <= 1'b0;
                    RNG_Gen_Out <= 1'b1;
                    Timer_Enable <= 1'b0;
                    Timer_Reconfig <= 1'b0;
                    ShowScore <= 1'b0;

                    if (GameButton == 1'b1) begin
                        if (PasswordDigit == 4'b1001) // 9
                            State <= VERIFY;
                        else begin
                            soFarSoGood <= 1'b0;
                            State <= DIGIT1;
                        end
                    end
                    else
                        State <= DIGIT4;
                end

                VERIFY: begin
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;

                    Load_P_Out <= 1'b0;
                    RNG_Gen_Out <= 1'b1;
                    Timer_Enable <= 1'b0;
                    Timer_Reconfig <= 1'b0;
                    ShowScore <= 1'b0;

                    if (soFarSoGood == 1'b1)
                        State <= RECONFIGTIMER;
                    else
                        State <= DIGIT1;
                end

                RECONFIGTIMER: begin
                    Logged_In <= 1'b1;
                    Logged_Out <= 1'b0;

                    Load_P_Out <= 1'b0;
                    RNG_Gen_Out <= 1'b1;
                    Timer_Enable <= 1'b0;
                    Timer_Reconfig <= 1'b1;   // one-cycle pulse to load 99
                    ShowScore <= 1'b0;

                    State <= WAIT_FOR_GAMESTART;
                end

                WAIT_FOR_GAMESTART: begin
                    Logged_In <= 1'b1;
                    Logged_Out <= 1'b0;

                    Load_P_Out <= 1'b0;
                    RNG_Gen_Out <= 1'b1;
                    Timer_Enable <= 1'b0;
                    Timer_Reconfig <= 1'b0;
                    ShowScore <= 1'b0;

                    if (GameButton == 1'b1)
                        State <= GAMEPLAY;
                    else
                        State <= WAIT_FOR_GAMESTART;
                end

                GAMEPLAY: begin
                    Logged_In <= 1'b1;
                    Logged_Out <= 1'b0;

                    Load_P_Out <= Load_P_In;
                    RNG_Gen_Out <= RNG_Gen_In;
                    Timer_Enable <= 1'b1;
                    Timer_Reconfig <= 1'b0;
                    ShowScore <= 1'b0;

                    if (Timeout == 1'b1)
                        State <= GAMEOVER;
                    else
                        State <= GAMEPLAY;
                end

                GAMEOVER: begin
                    Logged_In <= 1'b1;
                    Logged_Out <= 1'b0;

                    Load_P_Out <= 1'b0;
                    RNG_Gen_Out <= 1'b1;
                    Timer_Enable <= 1'b0;
                    Timer_Reconfig <= 1'b0;
                    ShowScore <= 1'b1;   // show scoreboard only when game is over

                    if (GameButton == 1'b1)
                        State <= RECONFIGTIMER;
                    else
                        State <= GAMEOVER;
                end

                default: begin
                    State <= DIGIT1;
                    soFarSoGood <= 1'b1;

                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;

                    Load_P_Out <= 1'b0;
                    RNG_Gen_Out <= 1'b1;
                    Timer_Enable <= 1'b0;
                    Timer_Reconfig <= 1'b0;
                    ShowScore <= 1'b0;
                end

            endcase
        end
    end

endmodule