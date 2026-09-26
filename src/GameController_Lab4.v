// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: GameController_Lab4
// Description: This module controls the game flow after authentication is
// completed. It is separate from the ROM-based authentication module.
// After Passed becomes HIGH, the controller issues a one-cycle timer
// reconfiguration pulse, waits for the shared game button press to start
// the timer, enables gameplay during the active session, blocks gameplay
// when timeout occurs, and waits for the shared game button press to
// restart the game. Bonus feature: if the user is logged in and the timer
// is not running, pressing the Player Load button logs the user out.
// Comments/Log: Lab 4 version with logout bonus.

module GameController_Lab4(
    input  clk,
    input  rst,
    input  B_game,          // shaped shared button
    input  B_load,          // shaped player's load button
    input  Passed,          // from authentication module
    input  Logged_In,       // from authentication module
    input  TimeOut,         // from two-digit timer
    input  RNG_Gen_In,      // raw/allowed RNG request from board path
    input  Load_P_In,       // shaped player load request
    output reg Timer_Reconfig,
    output reg Timer_Enable,
    output reg RNG_Gen_Out,
    output reg Load_P_Out,
    output reg ShowScore,
    output reg LogoutPulse
);

    reg [2:0] State;
    reg [2:0] NextState;

    localparam S_INIT               = 3'd0,
               S_PASSED             = 3'd1,
               S_WAIT_FOR_GAMESTART = 3'd2,
               S_GAMEPLAY           = 3'd3,
               S_GAMEOVER           = 3'd4;

    always @(posedge clk) begin
        if (rst == 1'b0)
            State <= S_INIT;
        else
            State <= NextState;
    end

    always @(*) begin
        NextState = State;

        case (State)
            S_INIT: begin
                if (Passed == 1'b1)
                    NextState = S_PASSED;
                else
                    NextState = S_INIT;
            end

            S_PASSED: begin
                NextState = S_WAIT_FOR_GAMESTART;
            end

            S_WAIT_FOR_GAMESTART: begin
                if (Passed == 1'b0)
                    NextState = S_INIT;
                else if (Logged_In == 1'b1 && B_load == 1'b1)
                    NextState = S_INIT;   // logout
                else if (B_game == 1'b1)
                    NextState = S_GAMEPLAY;
                else
                    NextState = S_WAIT_FOR_GAMESTART;
            end

            S_GAMEPLAY: begin
                if (Passed == 1'b0)
                    NextState = S_INIT;
                else if (TimeOut == 1'b1)
                    NextState = S_GAMEOVER;
                else
                    NextState = S_GAMEPLAY;
            end

            S_GAMEOVER: begin
                if (Passed == 1'b0)
                    NextState = S_INIT;
                else if (Logged_In == 1'b1 && B_load == 1'b1)
                    NextState = S_INIT;   // logout
                else if (B_game == 1'b1)
                    NextState = S_PASSED; // restart flow
                else
                    NextState = S_GAMEOVER;
            end

            default: begin
                NextState = S_INIT;
            end
        endcase
    end

    always @(*) begin
        Timer_Reconfig = 1'b0;
        Timer_Enable   = 1'b0;
        RNG_Gen_Out    = 1'b0;
        Load_P_Out     = 1'b0;
        ShowScore      = 1'b0;
        LogoutPulse    = 1'b0;

        case (State)
            S_INIT: begin
                // everything blocked
            end

            S_PASSED: begin
                Timer_Reconfig = 1'b1;   // one-cycle pulse
            end

            S_WAIT_FOR_GAMESTART: begin
                if (Logged_In == 1'b1 && B_load == 1'b1)
                    LogoutPulse = 1'b1;
            end

            S_GAMEPLAY: begin
                Timer_Enable = 1'b1;
                //RNG_Gen_Out  = RNG_Gen_In;
				RNG_Gen_Out  = ~RNG_Gen_In; 
                Load_P_Out   = Load_P_In;
            end

            S_GAMEOVER: begin
                ShowScore = 1'b1;
                if (Logged_In == 1'b1 && B_load == 1'b1)
                    LogoutPulse = 1'b1;
            end

            default: begin
            end
        endcase
    end

endmodule