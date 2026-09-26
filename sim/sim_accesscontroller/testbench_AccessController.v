`timescale 1 ns/100 ps
module testbench_AccessControl();

    reg clk, rst;
    reg PasswordEnterKey, LogoutKey;
    reg [3:0] PasswordDigit;
    reg Load_P1_In, Load_P2_In;

    wire Logged_In, Logged_Out;
    wire Load_P1_Out, Load_P2_Out;

    //clock
    always
        begin
            clk = 1'b0;
            #10;
            clk = 1'b1;
            #10;
        end

    // DUT instantiation (positional, same style)
    AccessControl_OneProcedure DUT_MyAccessControl(
        PasswordEnterKey, PasswordDigit, LogoutKey, Load_P1_In, Load_P2_In,
        Logged_In, Logged_Out, Load_P1_Out, Load_P2_Out, clk, rst
    );

    initial
        begin
            // initial conditions
            rst = 1'b1;                 // inactive (reset is active-low)
            PasswordEnterKey = 1'b0;
            LogoutKey = 1'b0;
            PasswordDigit = 4'b0000;
            Load_P1_In = 1'b0;
            Load_P2_In = 1'b0;

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            // Reset pulse
            #5 rst = 1'b0;              // press reset
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #5 rst = 1'b1;              // release reset
            @(posedge clk);
            @(posedge clk);

            // ---------------------------------------------------------
            // TEST 0: Incorrect password case (wrong digit -> reset)
            // Example: enter 1 (correct), then 2 (wrong, expected 3)
            // Result: should NOT log in; LOAD should not pass through.
            // ---------------------------------------------------------

            // digit 1 (correct)
            #5 PasswordDigit = 4'b0001; // 1
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;
            @(posedge clk);
            @(posedge clk);

            // digit 2 (WRONG)
            #5 PasswordDigit = 4'b0010; // 2 (wrong, expected 3)
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;
            @(posedge clk);
            @(posedge clk);

            // Try LOAD after wrong password (should not load)
            #5 Load_P1_In = 1'b1;
            @(posedge clk);
            #5 Load_P1_In = 1'b0;
            @(posedge clk);
            @(posedge clk);

            #5 Load_P2_In = 1'b1;
            @(posedge clk);
            #5 Load_P2_In = 1'b0;
            @(posedge clk);

            // ---------------------------------------------------------
            // TEST 1: Correct password entry: 1 -> 3 -> 8 -> 9
            // ---------------------------------------------------------

            // digit 1
            #5 PasswordDigit = 4'b0001; // 1
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;
            @(posedge clk);
            

            // digit 2
            #5 PasswordDigit = 4'b0011; // 3
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;
            @(posedge clk);

            // digit 3
            #5 PasswordDigit = 4'b1000; // 8
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;
            @(posedge clk);

            // digit 4
            #5 PasswordDigit = 4'b1001; // 9
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;

            // allow VERIFY -> PASSED to happen
            @(posedge clk);
            @(posedge clk);

            // ---------------------------------------------------------
            // TEST 2: While logged in, LOAD should pass through
            // ---------------------------------------------------------
            #5 Load_P1_In = 1'b1;
            @(posedge clk);
            #5 Load_P1_In = 1'b0;
            @(posedge clk);

            #5 Load_P2_In = 1'b1;
            @(posedge clk);
            #5 Load_P2_In = 1'b0;
            @(posedge clk);

            // ---------------------------------------------------------
            // TEST 3 (BONUS): Logout, then LOAD should NOT pass through
            // ---------------------------------------------------------
            #5 LogoutKey = 1'b1;
            @(posedge clk);
            #5 LogoutKey = 1'b0;
            @(posedge clk);

            // try LOAD after logout (should not load new numbers)
            #5 Load_P1_In = 1'b1;
            @(posedge clk);
            #5 Load_P1_In = 1'b0;
            @(posedge clk);

            #5 Load_P2_In = 1'b1;
            @(posedge clk);
            #5 Load_P2_In = 1'b0;
            @(posedge clk);

            // ---------------------------------------------------------
            // TEST 4: Login again after logout (same password)
            // ---------------------------------------------------------

            // digit 1
            #5 PasswordDigit = 4'b0001; // 1
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;
            @(posedge clk);

            // digit 2
            #5 PasswordDigit = 4'b0011; // 3
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;
            @(posedge clk);

            // digit 3
            #5 PasswordDigit = 4'b1000; // 8
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;
            @(posedge clk);

            // digit 4
            #5 PasswordDigit = 4'b1001; // 9
               PasswordEnterKey = 1'b1;
            @(posedge clk);
            #5 PasswordEnterKey = 1'b0;

            // allow VERIFY -> PASSED
            @(posedge clk);
            @(posedge clk);

            // LOAD should pass again
            #5 Load_P1_In = 1'b1;
            @(posedge clk);
            #5 Load_P1_In = 1'b0;
            @(posedge clk);

        end

endmodule