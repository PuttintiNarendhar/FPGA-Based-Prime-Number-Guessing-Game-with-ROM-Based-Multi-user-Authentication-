// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: Lab4Top_KANDHALAM_Dharani
// Description: This top module integrates the Lab 4 single-player game.
// It separates ROM-based password authentication from game control,
// replaces the regular 1 ms timer with the LFSR-based timer, and keeps
// the Lab 3 user interface behavior the same.
// Comments/Log: Required Lab 4 top-level integration.

module Lab4_KANDHALAM_Dharani(
    Player_Switch,
    Password_Switch,
    PasswordGameStartButton,
    Player_LoadButton,
    RNG_Gen_Button,
    clk,
    rst,
    TimerTens_Display,
    TimerOnes_Display,
    ScoreTens_Display,
    SumOrScoreOnes_Display,
    Random_Display,
    Player_Display,
    Logged_In_LED,
    Logged_Out_LED,
    LEDs
);

    input  [3:0] Player_Switch;
    input  [3:0] Password_Switch;
    input        PasswordGameStartButton;
    input        Player_LoadButton;
    input        RNG_Gen_Button;
    input        clk, rst;

    output [6:0] TimerTens_Display, TimerOnes_Display;
    output [6:0] ScoreTens_Display, SumOrScoreOnes_Display;
    output [6:0] Random_Display, Player_Display;
    output       Logged_In_LED, Logged_Out_LED;
    output [9:0] LEDs;

    wire GameButtonPulse;
    wire Load_P_In;

    wire B_password;
    wire B_game;

    assign B_password = GameButtonPulse;
    assign B_game     = GameButtonPulse;

    wire Passed;
    wire Logged_In, Logged_Out;
    wire Load_P_Out;
    wire RNG_Gen_Out;
    wire Timer_Enable, Timer_Reconfig;
    wire ShowScore;
    wire LogoutPulse;

    wire [3:0] Player_Number;
    wire [3:0] Random_Number;
    wire [3:0] Sum;

    wire oneSecPulse;
    wire [3:0] Tensdigit, Onesdigit;
    wire TimeOut;

    wire MatchLED, NonMatchLED;
    wire [3:0] ScoreTens, ScoreOnes;

    wire [3:0] MiddleLeftValue;
    wire [3:0] MiddleRightValue;
    wire [3:0] RandomDisplayValue;
    wire [3:0] PlayerDisplayValue;

    ButtonShaper PasswordGameButtonShaper(
        PasswordGameStartButton,
        GameButtonPulse,
        clk,
        rst
    );

    ButtonShaper PlayerLoadButtonShaper(
        Player_LoadButton,
        Load_P_In,
        clk,
        rst
    );

    ROMAuthentication AuthenticationModule(
        .clk(clk),
        .rst(rst),
        .B_password(B_password),
        .LogoutPulse(LogoutPulse),
        .PasswordSwitches(Password_Switch),
        .Passed(Passed),
        .Logged_In(Logged_In),
        .Logged_Out(Logged_Out)
    );

    GameController_Lab4 GameControllerModule(
        .clk(clk),
        .rst(rst),
        .B_game(B_game),
        .B_load(Load_P_In),
        .Passed(Passed),
        .Logged_In(Logged_In),
        .TimeOut(TimeOut),
        .RNG_Gen_In(RNG_Gen_Button),
        .Load_P_In(Load_P_In),
        .Timer_Reconfig(Timer_Reconfig),
        .Timer_Enable(Timer_Enable),
        .RNG_Gen_Out(RNG_Gen_Out),
        .Load_P_Out(Load_P_Out),
        .ShowScore(ShowScore),
        .LogoutPulse(LogoutPulse)
    );

    LoadRegister PlayerLoadRegister(
        Player_Switch,
        Player_Number,
        clk,
        rst,
        Load_P_Out
    );

    RandomNumberGenerator RNGModule(
        Random_Number,
        RNG_Gen_Out,
        clk,
        rst
    );

    OneSecTimer LFSR_OneSecondTimerModule(
        Timer_Enable,
        clk,
        rst,
        oneSecPulse
    );

    TwoDigitTimer TimerModule(
        Tensdigit,
        Onesdigit,
        TimeOut,
        oneSecPulse,
        Timer_Reconfig,
        clk,
        rst
    );

    My4BAdder AdderModule(
        Player_Number,
        Random_Number,
        Sum
    );

    VerificationModule VerificationModule1(
        Sum,
        MatchLED,
        NonMatchLED
    );

    Scoreboard ScoreboardModule(
        ScoreTens,
        ScoreOnes,
        Load_P_Out,
        MatchLED,
        TimeOut,
        Timer_Reconfig,
        clk,
        rst
    );

    assign RandomDisplayValue = (Logged_In == 1'b1) ? Random_Number : 4'd0;
    assign PlayerDisplayValue = (Logged_In == 1'b1) ? Player_Number : 4'd0;

    assign MiddleLeftValue  = (ShowScore == 1'b1) ? ScoreTens : 4'd0;
    assign MiddleRightValue = (ShowScore == 1'b1) ? ScoreOnes :
                              ((Logged_In == 1'b1) ? Sum : 4'd0);

    My7SegmentDecoder_4To7 TimerTensDisplayModule(
        Tensdigit,
        TimerTens_Display
    );

    My7SegmentDecoder_4To7 TimerOnesDisplayModule(
        Onesdigit,
        TimerOnes_Display
    );

    My7SegmentDecoder_4To7 ScoreTensDisplayModule(
        MiddleLeftValue,
        ScoreTens_Display
    );

    My7SegmentDecoder_4To7 SumOrScoreOnesDisplayModule(
        MiddleRightValue,
        SumOrScoreOnes_Display
    );

    My7SegmentDecoder_4To7 RandomDisplayModule(
        RandomDisplayValue,
        Random_Display
    );

    My7SegmentDecoder_4To7 PlayerDisplayModule(
        PlayerDisplayValue,
        Player_Display
    );

    assign Logged_In_LED  = Logged_In;
    assign Logged_Out_LED = Logged_Out;

    assign LEDs[9] = NonMatchLED;
    assign LEDs[8] = MatchLED;
    assign LEDs[0] = Logged_In;
    assign LEDs[1] = Logged_Out;
    assign LEDs[7:2] = 6'b0;

endmodule