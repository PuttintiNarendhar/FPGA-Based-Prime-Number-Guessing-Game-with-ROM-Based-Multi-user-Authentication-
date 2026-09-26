//ECE6370
//Author: Narendhar Puttinti, PSID: 2454090
//Password_Checking_Module
//verifies the User entered Password with the Password stored in the ROM
//using High level FSM 
//if rst is 0 current state is DIGIT1 otherwise Next State
//it is a positive edge triggered System with active low reset
//there are 13 states namely DIGIT1, DIGIT2, DIGIT3, DIGIT4, DIGIT5, DIGIT6, FETCHROMWD, ROMCYC1, ROMCYC2, ROMCATCH, COMPARE, PASSED and WAITCYCLE
//it will control the Game Controller module(GCM) to start or not 
module Password_Checking_Module(PasswordEnter, PasswordDigit, IsGuest, MatchedID, Internal_PlayerID, ROM_Data, LogOut_From_GCM, clk, rst, 
Logged_In, Logged_Out, Passed, LogOut_From_PCM, IsGuest_From_PCM, Internal_PlayerID_PCM, ROM_Addr);
   input clk, rst;
   input PasswordEnter, LogOut_From_GCM, IsGuest, MatchedID;
   input [23:0] ROM_Data;
   input [3:0] PasswordDigit;
   input [2:0] Internal_PlayerID;
   output IsGuest_From_PCM, LogOut_From_PCM;
   output Logged_In, Logged_Out, Passed;
   output [4:0] ROM_Addr;
   output [2:0] Internal_PlayerID_PCM;
   reg IsGuest_From_PCM, LogOut_From_PCM, Logged_In, Logged_Out, Passed;
   reg [4:0] ROM_Addr;
   reg [2:0] Internal_PlayerID_PCM;
   
   parameter DIGIT1 = 0, DIGIT2 = 1, DIGIT3 = 2, DIGIT4 = 3, DIGIT5 = 4, DIGIT6 = 5, FETCHROMWD = 6, ROMCYC1 = 7, ROMCYC2 = 8, ROMCATCH = 9, COMPARE = 10, PASSED = 11, WAITCYCLE = 12;
   reg [3:0] State;
   reg [23:0] UserEnteredPswd;
   reg [23:0] Store_ROMData;
   reg [1:0] Tries_Count;

   always @(posedge clk) begin
      if(rst == 1'b0) begin
         IsGuest_From_PCM <= 1'b0;
         LogOut_From_PCM <= 1'b0;
         Logged_In <= 1'b0;
         Logged_Out <= 1'b1;
         Passed <= 1'b0;
         ROM_Addr <= 5'b00000;
         Internal_PlayerID_PCM <= 3'b000;
         Store_ROMData <= 24'd0;
         UserEnteredPswd <= 24'd0;
         Tries_Count <= 2'b00;
         State <= DIGIT1;
      end
      else begin
         case(State)
            DIGIT1: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    if(MatchedID == 1'b1) begin
                       if(PasswordEnter == 1'b1) begin
                          UserEnteredPswd[23:20] <= PasswordDigit;
                          State <= DIGIT2;
                       end
                       else begin
                          UserEnteredPswd <= 24'd0;
                          State <= DIGIT1;
                       end
                    end
                    else begin
                       UserEnteredPswd <= 24'd0;
                       State <= DIGIT1;
                    end
                    end
            DIGIT2: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    if(PasswordEnter == 1'b1) begin
                       UserEnteredPswd[19:16] <= PasswordDigit;
                       State <= DIGIT3;
                    end
                    else begin
                       State <= DIGIT2;
                    end
                    end
            DIGIT3: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    if(PasswordEnter == 1'b1) begin
                       UserEnteredPswd[15:12] <= PasswordDigit;
                       State <= DIGIT4;
                    end
                    else begin
                       State <= DIGIT3;
                    end
                    end
            DIGIT4: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    if(PasswordEnter == 1'b1) begin
                       UserEnteredPswd[11:8] <= PasswordDigit;
                       State <= DIGIT5;
                    end
                    else begin
                       State <= DIGIT4;
                    end
                    end
            DIGIT5: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    if(PasswordEnter == 1'b1) begin
                       UserEnteredPswd[7:4] <= PasswordDigit;
                       State <= DIGIT6;
                    end
                    else begin
                       State <= DIGIT5;
                    end
                    end
            DIGIT6: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    if(PasswordEnter == 1'b1) begin
                       UserEnteredPswd[3:0] <= PasswordDigit;
                       State <= FETCHROMWD;
                    end
                    else begin
                       State <= DIGIT6;
                    end
                    end
        FETCHROMWD: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    ROM_Addr <= {2'b00 , Internal_PlayerID};
                    State <= ROMCYC1;
                    end
           ROMCYC1: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    State <= ROMCYC2;
                    end
           ROMCYC2: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    State <= ROMCATCH;
                    end
          ROMCATCH: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= ROM_Data;
                    State <= COMPARE;
                    end
           COMPARE: begin
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    Internal_PlayerID_PCM <= 3'b000;
                    IsGuest_From_PCM <= 1'b0;
                    if(Tries_Count < 2'b11) begin // checking whether count reached the maximum tries or not
                       LogOut_From_PCM <= 1'b0;
                       Tries_Count <= Tries_Count + 1'b1;
                       if(Store_ROMData == UserEnteredPswd) begin
                          //User entered Password is correct
                          State <= PASSED;
                       end
                       else begin
                          //User entered Password is wrong
                          State <= DIGIT1;
                       end
                    end
                    else begin
                       LogOut_From_PCM <= 1'b1;
                       State <= WAITCYCLE;
                    end
                    end
            PASSED: begin
                    Logged_In <= 1'b1;
                    Logged_Out <= 1'b0;
                    Passed <= 1'b1;
                    Internal_PlayerID_PCM <= Internal_PlayerID;
                    IsGuest_From_PCM <= IsGuest;
                    if(LogOut_From_GCM == 1'b1) begin // checking the LogOut signal from Game Controller Module
                       State <= WAITCYCLE;
                       LogOut_From_PCM <= 1'b1;
                    end
                    else begin
                       LogOut_From_PCM <= 1'b0;
                       State <= PASSED;
                    end
                    end
         WAITCYCLE: begin
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    if(MatchedID == 1'b0) begin
                       State <= DIGIT1;
                    end
                    else begin
                       State <= WAITCYCLE;
                    end
                    end
            default: begin
                    IsGuest_From_PCM <= 1'b0;
                    LogOut_From_PCM <= 1'b0;
                    Logged_In <= 1'b0;
                    Logged_Out <= 1'b1;
                    Passed <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID_PCM <= 3'b000;
                    Store_ROMData <= 24'd0;
                    UserEnteredPswd <= 24'd0;
                    Tries_Count <= 2'b00;
                    State <= DIGIT1;
                    end
         endcase
      end
   end

endmodule
