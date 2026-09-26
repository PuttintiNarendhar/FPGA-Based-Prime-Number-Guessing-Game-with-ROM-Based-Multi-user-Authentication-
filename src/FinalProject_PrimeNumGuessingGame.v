// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: FinalProject_PrimeNumGuessingGame

module FinalProject_PrimeNumGuessingGame(Player_Switch, Password_Switch, PasswordGameStartButton, Player_LoadButton, Level_Button, clk, rst,
                                         TimerTens_Display, TimerOnes_Display, ScoreTens_Display, ScoreOnes_Display, GameLeft_Display,
                                         GameRight_Display, Logged_In_LED, Logged_Out_LED, LEDs);

    input [3:0] Player_Switch;
    input [3:0] Password_Switch;

    input PasswordGameStartButton;
    input Player_LoadButton;
    input Level_Button;

    input clk, rst;

    output [6:0] TimerTens_Display, TimerOnes_Display;
    output [6:0] ScoreTens_Display, ScoreOnes_Display;
    output [6:0] GameLeft_Display, GameRight_Display;

    output Logged_In_LED, Logged_Out_LED;
    output [9:0] LEDs;

    wire StartPulse;
    wire LoadPulse;
    wire LevelPulse;

    wire Passed;
    wire Logged_In;
    wire Logged_Out;

    wire isGuest_FromAuth;
    wire [2:0] PlayerInternalID_FromAuth;

    wire oneSecPulse;
    wire [3:0] TimerHundreds;
    wire [3:0] TimerTens;
    wire [3:0] TimerOnes;
    wire TimeOut;

    wire [1:0] Level;

    wire Timer_Enable;
    wire Timer_Reconfig;
    wire Generate_Target;
    wire ClearGuess;
    wire ShowScore;
    wire ShowGO;
    wire GameActive;

    wire [7:0] TargetPrime;
    wire [7:0] GuessNumber;
    wire [3:0] GuessTens;
    wire [3:0] GuessOnes;
    wire GuessReady;

    wire IsPrimeGuess;

    wire CorrectPulse;
    wire Wrong;
    wire TooSmall;
    wire TooLarge;
    wire Correct;

    wire [3:0] ScoreTens;
    wire [3:0] ScoreOnes;

    wire [3:0] guess_left_digit;
    wire [3:0] guess_right_digit;

    wire [2:0] hint_code;

    wire [3:0] TimerLeftDisplayValue;
    wire [3:0] TimerMiddleDisplayValue;
    wire [3:0] ScoreTensDisplayValue;

    wire [6:0] score_ones_seg;
    wire [6:0] hint_seg;

    wire LogoutPulse;
	 wire Logout_From_GCM;
    wire PlayerLoadEnable;
	 
	 // -------- SCORE TRACKING --------
	 wire score_request;
	 wire [7:0] FinalScore;
	 wire valid;
	 wire Personal_Winner;
	 wire Global_Winner;

    wire [7:0] Score_RAMdata_in;
    wire [7:0] Score_RAMdata_out;
    wire [4:0] Score_RAMaddr;
    wire Score_write_enb;
	
	 

    // During game:
    // TimerTens_Display  = timer hundreds
    // TimerOnes_Display  = timer tens
    // ScoreTens_Display  = timer ones
    // ScoreOnes_Display  = hint
    //
    // After timeout:
    // TimerTens_Display  = 0
    // TimerOnes_Display  = 0
    // ScoreTens_Display  = score tens
    // ScoreOnes_Display  = score ones

    assign TimerLeftDisplayValue   = ShowScore ? 4'd0 : TimerHundreds;
    assign TimerMiddleDisplayValue = ShowScore ? 4'd0 : TimerTens;
    assign ScoreTensDisplayValue   = ShowScore ? ScoreTens : TimerOnes;

    assign PlayerLoadEnable = LoadPulse && Logged_In && GameActive && !ShowGO;

    // Player_LoadButton works as logout only when logged in and game is not active
    assign LogoutPulse = LoadPulse && Logged_In && !GameActive;
	 
	 
	 
	 assign FinalScore = {ScoreTens, ScoreOnes};
	 
	 

    // ---------------- BUTTON SHAPERS ----------------

    ButtonShaper StartButtonShaper(
        PasswordGameStartButton,
        StartPulse,
        clk,
        rst
    );

    ButtonShaper PlayerLoadButtonShaper(
        Player_LoadButton,
        LoadPulse,
        clk,
        rst
    );

    ButtonShaper LevelButtonShaper(
        Level_Button,
        LevelPulse,
        clk,
        rst
    );

    // ---------------- AUTHENTICATION ----------------
    // Port order:
    // ID_Password_Enter, ID_Password_Digit, LogOut_From_GCM,
    // clk, rst, Logged_In, Logged_Out, Passed,
    // isGuest_FromAuth, PlayerInternalID_FromAuth

    Authentication AuthenticationModule(
        StartPulse,
        Password_Switch,
        Logout_From_GCM,
        clk,
        rst,
        Logged_In,
        Logged_Out,
        Passed,
        isGuest_FromAuth,
        PlayerInternalID_FromAuth
    );

    // ---------------- LEVEL SELECTOR ----------------
    // Port order:
    // clk, rst, level_pulse, game_active, level

    LevelSelector LevelSelectorModule(
        clk,
        rst,
        LevelPulse,
        GameActive,
        Level
    );

    // ---------------- TARGET GENERATOR ----------------
    // PrimeTargetGenerator internally uses:
    // PrimeLFSR + RandomIndexLFSR + ROM_PrimerNumbers
    //
    // Port order:
    // clk, rst, gen_target, level, target_prime

    PrimeTargetGenerator TargetGeneratorModule(
        clk,
        rst,
        Generate_Target,
        Level,
        TargetPrime
    );

    // ---------------- TWO DIGIT GUESS INPUT ----------------
    // Port order:
    // clk, rst, load_pulse, clear, digit_in,
    // tens, ones, guess, guess_ready

    TwoDigitGuessInput GuessInputModule(
        clk,
        rst,
        PlayerLoadEnable,
        ClearGuess,
        Player_Switch,
        GuessTens,
        GuessOnes,
        GuessNumber,
        GuessReady
    );

    // ---------------- PRIME CHECKER ----------------
    // Port order:
    // number, is_prime

    PrimeChecker PrimeCheckerModule(
        GuessNumber,
        IsPrimeGuess
    );

    // ---------------- GAME CONTROLLER ----------------
    // Port order:
    // clk, rst,
    // Logged_In, StartPulse, GuessReady, TimeOut,
    // IsPrimeGuess, GuessNumber, TargetPrime,
    // Timer_Enable, Timer_Reconfig, Generate_Target,
    // ClearGuess, ShowScore, ShowGO,
    // CorrectPulse, Wrong, TooSmall, TooLarge,
    // Correct, GameActive

    PrimeGameController GameControllerModule(
		  clk,
        rst,

        Logged_In,
        StartPulse,
        LogoutPulse,
        GuessReady,
        TimeOut,

        IsPrimeGuess,
        GuessNumber,
        TargetPrime,

        Timer_Enable,
        Timer_Reconfig,
        Generate_Target,
        ClearGuess,
        ShowScore,
        ShowGO,

        CorrectPulse,
        Wrong,
        TooSmall,
        TooLarge,
        Correct,
        GameActive,
        score_request,
        Logout_From_GCM,
		  valid
	 );

    // ---------------- ONE SECOND TIMER ----------------
    // Port order:
    // Timer_Enable, clk, rst, oneSecPulse

    OneSecTimer LFSR_OneSecondTimerModule(
        Timer_Enable,
        clk,
        rst,
        oneSecPulse
    );

    // ---------------- THREE DIGIT TIMER ----------------
    // Port order:
    // Hundredsdigit, Tensdigit, Onesdigit, TimeOut,
    // Timer_enable, Timer_reconfig, Level, clk, rst

    ThreeDigitTimer TimerModule(
        TimerHundreds,
        TimerTens,
        TimerOnes,
        TimeOut,
        oneSecPulse,
        Timer_Reconfig,
        Level,
        clk,
        rst
    );

    // ---------------- SCOREBOARD ----------------
    // Port order:
    // ScoreTens, ScoreOnes, CorrectPulse, MatchEnable,
    // TimeOut, Timer_Reconfig, clk, rst

    Scoreboard ScoreboardModule(
        ScoreTens,
        ScoreOnes,
        CorrectPulse,
        1'b1,
        TimeOut,
        Timer_Reconfig,
        clk,
        rst
    );
	 	 
	 // ---------------- SCORETRACKING ----------------	 
	 ScoreTracking ScoreTrackingModule (
		  score_request,
        isGuest_FromAuth,
		  PlayerInternalID_FromAuth,
		  FinalScore,
        Score_RAMdata_in,
        clk,
        rst,
        Score_RAMdata_out,
        Score_RAMaddr,
        Score_write_enb,
        valid,
        Personal_Winner,
        Global_Winner
    );
	 
	 
	 Score_RAM ScoreRAMModule (
		  Score_RAMaddr,       // address
        clk,                 // clock
        Score_RAMdata_out,   // data (write)
        Score_write_enb,     // wren
        Score_RAMdata_in     // q (read)
    );

	 

    // ---------------- DISPLAY CONTROLLER ----------------
    // Port order:
    // clk, rst, ShowGO, Wrong, TooSmall, TooLarge, Correct,
    // GuessTens, GuessOnes,
    // hint_code, left_digit, right_digit

    DisplayController DisplayModule(
        clk,
        rst,
        ShowGO,
        Wrong,
        TooSmall,
        TooLarge,
        Correct,
        GuessTens,
        GuessOnes,
        hint_code,
        guess_left_digit,
        guess_right_digit
    );
	 

    // ---------------- 7-SEG DISPLAY DECODERS ----------------

    My7SegmentDecoder_4To7 TimerTensDisplayModule(
        TimerLeftDisplayValue,
        TimerTens_Display
    );

    My7SegmentDecoder_4To7 TimerOnesDisplayModule(
        TimerMiddleDisplayValue,
        TimerOnes_Display
    );

    My7SegmentDecoder_4To7 ScoreTensDisplayModule(
        ScoreTensDisplayValue,
        ScoreTens_Display
    );

    // Score ones digit is decoded separately.
    // It is shown only after timeout.

    My7SegmentDecoder_4To7 ScoreOnesDigitDisplayModule(
        ScoreOnes,
        score_ones_seg
    );

    // Hint display is decoded using the special hint decoder.
    // It is shown during active game.

    Hint7SegmentDecoder HintDisplayModule(
        hint_code,
        hint_seg
    );

    assign ScoreOnes_Display = ShowScore ? score_ones_seg : hint_seg;

    My7SegmentDecoder_4To7 GameLeftDisplayModule(
        guess_left_digit,
        GameLeft_Display
    );

    My7SegmentDecoder_4To7 GameRightDisplayModule(
        guess_right_digit,
        GameRight_Display
    );

	// ---------------- LED OUTPUTS ----------------
	assign Logged_In_LED  = Logged_In;
	assign Logged_Out_LED = Logged_Out;

	// Right side first 2 LEDs
	assign LEDs[0] = Logged_In;
	assign LEDs[1] = Logged_Out;

	assign LEDs[2] = 1'b0;

	assign LEDs[3] = Logged_In && ShowScore && valid && (Global_Winner);
	assign LEDs[4] = Logged_In && ShowScore && valid && (Global_Winner || Personal_Winner);
	assign LEDs[5] = Logged_In && ShowScore && valid && (Global_Winner);

	assign LEDs[6] = 1'b0;

	// Left side last 3 LEDs for level indication
	assign LEDs[7] = Logged_In ? (Level == 2'd1) : 1'b0;
	assign LEDs[8] = Logged_In ? (Level == 2'd2) : 1'b0;
	assign LEDs[9] = Logged_In ? (Level == 2'd3) : 1'b0;

endmodule