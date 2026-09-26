module ScoreTracking (
    score_request,
    isGuest_FromGC,
    PlayerInternalID_FromGC,
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

    input clk, rst;
    input score_request;
    input isGuest_FromGC;
    input [2:0] PlayerInternalID_FromGC;
    input [7:0] FinalScore;
    input [7:0] Score_RAMdata_in;

    output [7:0] Score_RAMdata_out;
    output [4:0] Score_RAMaddr;
    output Score_write_enb;
    output valid;
    output Personal_Winner;
    output Global_Winner;

    reg [7:0] Score_RAMdata_out;
    reg [4:0] Score_RAMaddr;
    reg Score_write_enb;
    reg valid;
    reg Personal_Winner;
    reg Global_Winner;

    reg [7:0] Global_WinnerScore;
    reg [7:0] PersonalBestScore;

    reg [7:0] FinalScore_Reg;
    reg [2:0] PlayerInternalID_Reg;

    // One bit per player.
    // PlayerPlayed[id] = 1 means that player already has a benchmark score.
    reg [7:0] PlayerPlayed;

    // This tells whether a global benchmark already exists.
    reg GlobalScoreValid;

    reg [3:0] State;

    parameter RAMINIT           = 4'd0,
              WAITFORSCORE      = 4'd1,
              FETCHRAM          = 4'd2,
              RAMCYCLE1         = 4'd3,
              RAMCYCLE2         = 4'd4,
              RAMCATCH          = 4'd5,
              COMPARE_PERSONAL  = 4'd6,
              WRITE_PERSONAL    = 4'd7,
              CHECK_GLOBAL      = 4'd8;

    always @(posedge clk) begin
        if(rst == 1'b0) begin
            Score_RAMdata_out <= 8'd0;
            Score_RAMaddr     <= 5'd0;
            Score_write_enb   <= 1'b0;

            valid             <= 1'b0;
            Personal_Winner   <= 1'b0;
            Global_Winner     <= 1'b0;

            Global_WinnerScore <= 8'd0;
            PersonalBestScore  <= 8'd0;

            FinalScore_Reg         <= 8'd0;
            PlayerInternalID_Reg   <= 3'd0;

            PlayerPlayed     <= 8'b00000000;
            GlobalScoreValid <= 1'b0;

            State <= RAMINIT;
        end
        else begin
            case(State)

                // Clear all RAM locations to 0 at startup
                RAMINIT: begin
                    Score_RAMdata_out <= 8'd0;
                    Score_write_enb   <= 1'b1;

                    if(Score_RAMaddr == 5'd31) begin
                        Score_write_enb <= 1'b0;
                        State <= WAITFORSCORE;
                    end
                    else begin
                        Score_RAMaddr <= Score_RAMaddr + 5'd1;
                        State <= RAMINIT;
                    end
                end

                WAITFORSCORE: begin
                    Score_write_enb <= 1'b0;

                    if(score_request == 1'b1) begin
                        // Clear previous result while checking new final score
                        valid           <= 1'b0;
                        Personal_Winner <= 1'b0;
                        Global_Winner   <= 1'b0;

                        FinalScore_Reg       <= FinalScore;
                        PlayerInternalID_Reg <= PlayerInternalID_FromGC;

                        if(isGuest_FromGC == 1'b1) begin
                            // Guest has no personal RAM score.
                            // Guest can still be checked for global winner.
                            State <= CHECK_GLOBAL;
                        end
                        else begin
                            State <= FETCHRAM;
                        end
                    end
                    else begin
                        State <= WAITFORSCORE;
                    end
                end

                FETCHRAM: begin
                    // Personal score stored at address equal to player ID
                    Score_RAMaddr <= {2'b00, PlayerInternalID_Reg};
                    State <= RAMCYCLE1;
                end

                RAMCYCLE1: begin
                    State <= RAMCYCLE2;
                end

                RAMCYCLE2: begin
                    State <= RAMCATCH;
                end

                RAMCATCH: begin
                    PersonalBestScore <= Score_RAMdata_in;
                    State <= COMPARE_PERSONAL;
                end

                COMPARE_PERSONAL: begin
                    // Local winner rule:
                    // First completed game for this player OR new score beats old personal best.
                    if((PlayerPlayed[PlayerInternalID_Reg] == 1'b0) ||
                       (FinalScore_Reg > PersonalBestScore)) begin

                        Score_write_enb   <= 1'b1;
                        Score_RAMdata_out <= FinalScore_Reg;
                        Personal_Winner   <= 1'b1;

                        State <= WRITE_PERSONAL;
                    end
                    else begin
                        Score_write_enb <= 1'b0;
                        Personal_Winner <= 1'b0;

                        State <= CHECK_GLOBAL;
                    end
                end

                WRITE_PERSONAL: begin
                    Score_write_enb <= 1'b0;

                    // Mark this player as having a benchmark score now.
                    PlayerPlayed[PlayerInternalID_Reg] <= 1'b1;

                    State <= CHECK_GLOBAL;
                end

                CHECK_GLOBAL: begin
                    valid <= 1'b1;

                    // Global winner rule:
                    // First completed game overall OR score beats previous global best.
                    if((GlobalScoreValid == 1'b0) ||
                       (FinalScore_Reg > Global_WinnerScore)) begin

                        Global_WinnerScore <= FinalScore_Reg;
                        GlobalScoreValid   <= 1'b1;
                        Global_Winner      <= 1'b1;
                    end
                    else begin
                        Global_Winner <= 1'b0;
                    end

                    State <= WAITFORSCORE;
                end

                default: begin
                    Score_RAMdata_out <= 8'd0;
                    Score_RAMaddr     <= 5'd0;
                    Score_write_enb   <= 1'b0;

                    valid             <= 1'b0;
                    Personal_Winner   <= 1'b0;
                    Global_Winner     <= 1'b0;

                    Global_WinnerScore <= 8'd0;
                    PersonalBestScore  <= 8'd0;

                    FinalScore_Reg       <= 8'd0;
                    PlayerInternalID_Reg <= 3'd0;

                    PlayerPlayed     <= 8'b00000000;
                    GlobalScoreValid <= 1'b0;

                    State <= RAMINIT;
                end

            endcase
        end
    end

endmodule