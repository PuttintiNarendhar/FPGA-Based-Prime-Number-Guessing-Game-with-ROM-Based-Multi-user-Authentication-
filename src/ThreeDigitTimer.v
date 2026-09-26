// ECE6370
// Author: Dharani Kandhalam - 1389
// Name of Module: ThreeDigitTimer
// Description: Level-based 3-digit countdown timer.
// Level 1 = 099, Level 2 = 160, Level 3 = 220.

module ThreeDigitTimer(
    Hundredsdigit,
    Tensdigit,
    Onesdigit,
    TimeOut,
    Timer_enable,
    Timer_reconfig,
    Level,
    clk,
    rst
);

    input clk, rst;
    input Timer_enable, Timer_reconfig;
    input [1:0] Level;

    output [3:0] Hundredsdigit, Tensdigit, Onesdigit;
    output TimeOut;

    reg [3:0] Hundredsdigit;
    reg [3:0] Tensdigit;
    reg [3:0] Onesdigit;

    wire timer_done;

    assign timer_done = (Hundredsdigit == 4'd0) &&
                        (Tensdigit == 4'd0) &&
                        (Onesdigit == 4'd0);

    assign TimeOut = timer_done;

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            Hundredsdigit <= 4'd0;
            Tensdigit     <= 4'd0;
            Onesdigit     <= 4'd0;
        end
        else begin
            if (Timer_reconfig == 1'b1) begin
                case(Level)
                    2'd1: begin
                        Hundredsdigit <= 4'd0;
                        Tensdigit     <= 4'd9;
                        Onesdigit     <= 4'd9;
                    end

                    2'd2: begin
                        Hundredsdigit <= 4'd1;
                        Tensdigit     <= 4'd6;
                        Onesdigit     <= 4'd0;
                    end

                    2'd3: begin
                        Hundredsdigit <= 4'd2;
                        Tensdigit     <= 4'd2;
                        Onesdigit     <= 4'd0;
                    end

                    default: begin
                        Hundredsdigit <= 4'd0;
                        Tensdigit     <= 4'd9;
                        Onesdigit     <= 4'd9;
                    end
                endcase
            end
            else if (Timer_enable == 1'b1 && !timer_done) begin
                if (Onesdigit > 4'd0) begin
                    Onesdigit <= Onesdigit - 4'd1;
                end
                else begin
                    Onesdigit <= 4'd9;

                    if (Tensdigit > 4'd0) begin
                        Tensdigit <= Tensdigit - 4'd1;
                    end
                    else begin
                        Tensdigit <= 4'd9;

                        if (Hundredsdigit > 4'd0)
                            Hundredsdigit <= Hundredsdigit - 4'd1;
                    end
                end
            end
        end
    end

endmodule