module TwoDigitGuessInput(clk, rst, load_pulse, clear, digit_in,
                          tens, ones, guess, guess_ready);

    input clk;
    input rst;
    input load_pulse;
    input clear;
    input [3:0] digit_in;

    output [3:0] tens;
    output [3:0] ones;
    output [7:0] guess;
    output guess_ready;

    reg [3:0] tens;
    reg [3:0] ones;
    reg [7:0] guess;
    reg guess_ready;

    reg digit_state;
    reg pending_ready;
    reg [3:0] temp_tens;

    always @(posedge clk) begin
        if (rst == 1'b0 || clear) begin
            tens <= 4'd0;
            ones <= 4'd0;
            guess <= 8'd0;
            guess_ready <= 1'b0;
            digit_state <= 1'b0;
            pending_ready <= 1'b0;
            temp_tens <= 4'd0;
        end
        else begin
            guess_ready <= 1'b0;

            if (pending_ready) begin
                guess_ready <= 1'b1;
                pending_ready <= 1'b0;
            end

            if (load_pulse && digit_in <= 4'd9) begin
                if (digit_state == 1'b0) begin
                    // Store first digit internally only.
                    // Do not update display yet.
                    temp_tens <= digit_in;
                    digit_state <= 1'b1;
                end
                else begin
                    // Now both digits are available.
                    // Update display and guess together.
                    tens <= temp_tens;
                    ones <= digit_in;
                    guess <= (temp_tens * 8'd10) + digit_in;

                    digit_state <= 1'b0;
                    pending_ready <= 1'b1;
                end
            end
        end
    end

endmodule