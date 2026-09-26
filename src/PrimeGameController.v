module PrimeGameController(clk, rst, Logged_In, StartPulse, LogoutPulse, GuessReady, TimeOut, IsPrimeGuess, GuessNumber, TargetPrime,
                           Timer_Enable, Timer_Reconfig, Generate_Target, ClearGuess, ShowScore, ShowGO,
                           CorrectPulse, Wrong, TooSmall, TooLarge, Correct, GameActive,
                           score_request, Logout_From_GCM, valid);

    input clk;
    input rst;

    input Logged_In;
    input StartPulse;
    input LogoutPulse;
    input GuessReady;
    input TimeOut;
    input valid;

    input IsPrimeGuess;
    input [7:0] GuessNumber;
    input [7:0] TargetPrime;

    output Timer_Enable;
    output Timer_Reconfig;
    output Generate_Target;
    output ClearGuess;
    output ShowScore;
    output ShowGO;

    output CorrectPulse;
    output Wrong;
    output TooSmall;
    output TooLarge;
    output Correct;
    output GameActive;

    output score_request;
    output Logout_From_GCM;

    reg Timer_Enable;
    reg Timer_Reconfig;
    reg Generate_Target;
    reg ClearGuess;
    reg ShowScore;
    reg ShowGO;

    reg CorrectPulse;
    reg Wrong;
    reg TooSmall;
    reg TooLarge;
    reg Correct;
    reg GameActive;

    reg score_request;
    reg Logout_From_GCM;
    reg score_saved;

    localparam IDLE              = 4'd0;
    localparam START_GAME        = 4'd1;
    localparam WAIT_TARGET_START = 4'd2;
    localparam SHOW_GO           = 4'd3;
    localparam ACTIVE            = 4'd4;
    localparam CORRECT_SHOW      = 4'd5;
    localparam NEW_ROUND         = 4'd6;
    localparam WAIT_TARGET_ROUND = 4'd7;
    localparam GAME_OVER         = 4'd8;
    localparam LOGOUT            = 4'd9;
    localparam WAIT_SCORE_VALID  = 4'd10;
    localparam SHOW_WINNER_STATUS = 4'd11;

    localparam GO_DELAY      = 26'd50_000_000;
    localparam CORRECT_DELAY = 26'd25_000_000;

    reg [3:0] state;
    reg [25:0] go_counter;

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            state           <= IDLE;

            Timer_Enable    <= 1'b0;
            Timer_Reconfig  <= 1'b0;
            Generate_Target <= 1'b0;
            ClearGuess      <= 1'b1;
            ShowScore       <= 1'b0;
            ShowGO          <= 1'b0;

            CorrectPulse    <= 1'b0;
            Wrong           <= 1'b0;
            TooSmall        <= 1'b0;
            TooLarge        <= 1'b0;
            Correct         <= 1'b0;
            GameActive      <= 1'b0;
            go_counter      <= 26'd0;

            score_request   <= 1'b0;
            Logout_From_GCM <= 1'b0;
            score_saved     <= 1'b0;
        end
        else begin
            // Default one-clock pulse outputs
            Timer_Reconfig  <= 1'b0;
            Generate_Target <= 1'b0;
            ClearGuess      <= 1'b0;
            CorrectPulse    <= 1'b0;
            ShowGO          <= 1'b0;

            score_request   <= 1'b0;
            Logout_From_GCM <= 1'b0;

            case(state)

                IDLE: begin
                    Timer_Enable <= 1'b0;
                    ShowScore    <= 1'b0;
                    GameActive   <= 1'b0;
                    go_counter   <= 26'd0;

                    Wrong        <= 1'b0;
                    TooSmall     <= 1'b0;
                    TooLarge     <= 1'b0;
                    Correct      <= 1'b0;

                    if (Logged_In && LogoutPulse) begin
                        state <= LOGOUT;
                    end
                    else if (Logged_In && StartPulse) begin
                        state <= START_GAME;
                    end
                    else begin
                        state <= IDLE;
                    end
                end

                START_GAME: begin
                    Timer_Reconfig  <= 1'b1;
                    Generate_Target <= 1'b1;
                    ClearGuess      <= 1'b1;

                    Timer_Enable    <= 1'b1;
                    ShowScore       <= 1'b0;
                    GameActive      <= 1'b1;
                    go_counter      <= 26'd0;

                    Wrong           <= 1'b0;
                    TooSmall        <= 1'b0;
                    TooLarge        <= 1'b0;
                    Correct         <= 1'b0;

                    score_saved     <= 1'b0;

                    state <= WAIT_TARGET_START;
                end

                WAIT_TARGET_START: begin
                    Timer_Enable <= 1'b1;
                    ShowScore    <= 1'b0;
                    GameActive   <= 1'b1;
                    go_counter   <= 26'd0;

                    state <= SHOW_GO;
                end

                SHOW_GO: begin
                    Timer_Enable <= 1'b1;
                    ShowScore    <= 1'b0;
                    ShowGO       <= 1'b1;
                    GameActive   <= 1'b1;
                    Correct      <= 1'b0;

                    if (TimeOut) begin
                        go_counter <= 26'd0;
                        state <= GAME_OVER;
                    end
                    else if (go_counter >= GO_DELAY) begin
                        go_counter <= 26'd0;
                        state <= ACTIVE;
                    end
                    else begin
                        go_counter <= go_counter + 26'd1;
                        state <= SHOW_GO;
                    end
                end

                ACTIVE: begin
                    Timer_Enable <= 1'b1;
                    ShowScore    <= 1'b0;
                    GameActive   <= 1'b1;
                    go_counter   <= 26'd0;

                    if (TimeOut) begin
                        state <= GAME_OVER;
                    end
                    else if (GuessReady) begin
                        Wrong    <= 1'b0;
                        TooSmall <= 1'b0;
                        TooLarge <= 1'b0;
                        Correct  <= 1'b0;

                        if (!IsPrimeGuess) begin
                            Wrong <= 1'b1;
                            state <= ACTIVE;
                        end
                        else if (GuessNumber < TargetPrime) begin
                            TooSmall <= 1'b1;
                            state <= ACTIVE;
                        end
                        else if (GuessNumber > TargetPrime) begin
                            TooLarge <= 1'b1;
                            state <= ACTIVE;
                        end
                        else begin
                            Correct      <= 1'b1;
                            CorrectPulse <= 1'b1;
                            ClearGuess   <= 1'b1;
                            go_counter   <= 26'd0;
                            state        <= CORRECT_SHOW;
                        end
                    end
                    else begin
                        state <= ACTIVE;
                    end
                end

                CORRECT_SHOW: begin
                    Timer_Enable <= 1'b1;
                    ShowScore    <= 1'b0;
                    GameActive   <= 1'b1;

                    Correct      <= 1'b1;
                    Wrong        <= 1'b0;
                    TooSmall     <= 1'b0;
                    TooLarge     <= 1'b0;

                    if (TimeOut) begin
                        go_counter <= 26'd0;
                        state <= GAME_OVER;
                    end
                    else if (go_counter >= CORRECT_DELAY) begin
                        go_counter <= 26'd0;
                        state <= NEW_ROUND;
                    end
                    else begin
                        go_counter <= go_counter + 26'd1;
                        state <= CORRECT_SHOW;
                    end
                end

                NEW_ROUND: begin
                    Generate_Target <= 1'b1;
                    ClearGuess      <= 1'b1;

                    Timer_Enable    <= 1'b1;
                    ShowScore       <= 1'b0;
                    GameActive      <= 1'b1;
                    go_counter      <= 26'd0;

                    Wrong           <= 1'b0;
                    TooSmall        <= 1'b0;
                    TooLarge        <= 1'b0;
                    Correct         <= 1'b0;

                    state <= WAIT_TARGET_ROUND;
                end

                WAIT_TARGET_ROUND: begin
                    Timer_Enable <= 1'b1;
                    ShowScore    <= 1'b0;
                    GameActive   <= 1'b1;
                    Correct      <= 1'b0;

                    state <= ACTIVE;
                end

                GAME_OVER: begin
                    Timer_Enable <= 1'b0;
                    ShowScore    <= 1'b1;
                    ShowGO       <= 1'b0;
                    GameActive   <= 1'b0;
                    go_counter   <= 26'd0;

                    if (score_saved == 1'b0) begin
                        score_request <= 1'b1;
                        score_saved   <= 1'b1;
                        state         <= WAIT_SCORE_VALID;
                    end
                    else begin
                        state <= WAIT_SCORE_VALID;
                    end
                end

                WAIT_SCORE_VALID: begin
                    Timer_Enable <= 1'b0;
                    ShowScore    <= 1'b1;
                    ShowGO       <= 1'b0;
                    GameActive   <= 1'b0;
                    go_counter   <= 26'd0;

                    if (valid == 1'b1) begin
                        state <= SHOW_WINNER_STATUS;
                    end
                    else begin
                        state <= WAIT_SCORE_VALID;
                    end
                end

                SHOW_WINNER_STATUS: begin
                    Timer_Enable <= 1'b0;
                    ShowScore    <= 1'b1;
                    ShowGO       <= 1'b0;
                    GameActive   <= 1'b0;
                    go_counter   <= 26'd0;

                    if (Logged_In && LogoutPulse) begin
                        state <= LOGOUT;
                    end
                    else if (Logged_In && StartPulse) begin
                        state <= START_GAME;
                    end
                    else begin
                        state <= SHOW_WINNER_STATUS;
                    end
                end

                LOGOUT: begin
                    Timer_Enable    <= 1'b0;
                    Timer_Reconfig  <= 1'b0;
                    Generate_Target <= 1'b0;
                    ClearGuess      <= 1'b1;
                    ShowScore       <= 1'b0;
                    ShowGO          <= 1'b0;

                    CorrectPulse    <= 1'b0;
                    Wrong           <= 1'b0;
                    TooSmall        <= 1'b0;
                    TooLarge        <= 1'b0;
                    Correct         <= 1'b0;
                    GameActive      <= 1'b0;
                    go_counter      <= 26'd0;

                    Logout_From_GCM <= 1'b1;
                    score_saved     <= 1'b0;

                    state <= IDLE;
                end

                default: begin
                    state           <= IDLE;

                    Timer_Enable    <= 1'b0;
                    Timer_Reconfig  <= 1'b0;
                    Generate_Target <= 1'b0;
                    ClearGuess      <= 1'b0;
                    ShowScore       <= 1'b0;
                    ShowGO          <= 1'b0;

                    CorrectPulse    <= 1'b0;
                    Wrong           <= 1'b0;
                    TooSmall        <= 1'b0;
                    TooLarge        <= 1'b0;
                    Correct         <= 1'b0;
                    GameActive      <= 1'b0;
                    go_counter      <= 26'd0;

                    score_request   <= 1'b0;
                    Logout_From_GCM <= 1'b0;
                    score_saved     <= 1'b0;
                end

            endcase
        end
    end

endmodule