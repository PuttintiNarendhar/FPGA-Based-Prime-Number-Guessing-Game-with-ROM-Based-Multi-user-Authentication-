//ECE6370
//Author: Narendhar Puttinti, PSID: 2454090
//ID_Checking_Module
//verifies the User ID entered with the ID stored in the ROM
//using High level FSM 
//if rst is 0 current state is DIGIT1 otherwise Next State
//it is a positive edge triggered System with active low reset
//there are 11 states namely DIGIT1, DIGIT2, DIGIT3, DIGIT4, FETCHROMWD, ROMCYC1, ROMCYC2, ROMCATCH, COMPARE, CHECKSTATUS and CHECKGUEST
//it will control Pasword Checking module(PCM) to start or not 
module ID_Checking_Module(ID_Enter, ID_Digit, ROM_Data, LogOut_From_PCM, clk, rst, IsGuest, MatchedID, Internal_PlayerID, ROM_Addr);
   input clk, rst;
   input ID_Enter, LogOut_From_PCM;
   input [15:0] ROM_Data;
   input [3:0] ID_Digit;
   output IsGuest, MatchedID;
   output [4:0] ROM_Addr;
   output [2:0] Internal_PlayerID;
   reg IsGuest, MatchedID;
   reg [4:0] ROM_Addr;
   reg [2:0] Internal_PlayerID;
   
   parameter DIGIT1 = 0, DIGIT2 = 1, DIGIT3 = 2, DIGIT4 = 3, FETCHROMWD = 4, ROMCYC1 = 5, ROMCYC2 = 6, ROMCATCH = 7, COMPARE = 8, CHECKSTATUS = 9, CHECKGUEST = 10;
   reg [3:0] State;
   reg [15:0] UserEnteredID;
   reg [15:0] Store_ROMData;
   reg [2:0] Count;

   always @(posedge clk) begin
      if(rst == 1'b0) begin
         IsGuest <= 1'b0;
         MatchedID <= 1'b0;
         ROM_Addr <= 5'b00000;
         Internal_PlayerID <= 3'b000;
         Store_ROMData <= 16'd0;
         UserEnteredID <= 16'd0;
         Count <= 3'b000;
         State <= DIGIT1;
      end
      else begin
         case(State)
            DIGIT1: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID <= 3'b000;
                    Store_ROMData <= 16'd0;
                    Count <= 3'b000;
                    if(ID_Enter == 1'b1) begin
                       UserEnteredID[15:12] <= ID_Digit;
                       State <= DIGIT2;
                    end
                    else begin
                       UserEnteredID <= 16'd0;
                       State <= DIGIT1;
                    end
                    end
            DIGIT2: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID <= 3'b000;
                    Store_ROMData <= 16'd0;
                    Count <= 3'b000;
                    if(ID_Enter == 1'b1) begin
                       UserEnteredID[11:8] <= ID_Digit;
                       State <= DIGIT3;
                    end
                    else begin
                       State <= DIGIT2;
                    end
                    end
            DIGIT3: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID <= 3'b000;
                    Store_ROMData <= 16'd0;
                    Count <= 3'b000;
                    if(ID_Enter == 1'b1) begin
                       UserEnteredID[7:4] <= ID_Digit;
                       State <= DIGIT4;
                    end
                    else begin
                       State <= DIGIT3;
                    end
                    end
            DIGIT4: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID <= 3'b000;
                    Store_ROMData <= 16'd0;
                    Count <= 3'b000;
                    if(ID_Enter == 1'b1) begin
                       UserEnteredID[3:0] <= ID_Digit;
                       State <= FETCHROMWD;
                    end
                    else begin
                       State <= DIGIT4;
                    end
                    end
        FETCHROMWD: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    Internal_PlayerID <= 3'b000;
                    Store_ROMData <= 16'd0;
                    ROM_Addr <= {2'b00 , Count};
                    State <= ROMCYC1;
                    end
           ROMCYC1: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    Internal_PlayerID <= 3'b000;
                    Store_ROMData <= 16'd0;
                    State <= ROMCYC2;
                    end
           ROMCYC2: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    Internal_PlayerID <= 3'b000;
                    Store_ROMData <= 16'd0;
                    State <= ROMCATCH;
                    end
          ROMCATCH: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    Internal_PlayerID <= 3'b000;
                    Store_ROMData <= ROM_Data;
                    State <= COMPARE;
                    end
           COMPARE: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    if(Store_ROMData == UserEnteredID) begin
                       //User entered ID is correct
                       Internal_PlayerID <= Count;
                       State <= CHECKGUEST;
                    end
                    else begin
                       //User entered ID is wrong
                       Internal_PlayerID <= 3'b000;
                       State <= CHECKSTATUS;
                    end
                    end
       CHECKSTATUS: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    if(Store_ROMData == 16'hFFFF) begin // checking whether Data reached the end of the ROM or not
                       State <= DIGIT1;
                    end
                    else begin
                       Count <= Count + 1'b1;
                       State <= FETCHROMWD;
                    end
                    end
        CHECKGUEST: begin
                    if(LogOut_From_PCM == 1'b1) begin // checking the LogOut signal from Password Checking Module
                       State <= DIGIT1;
                    end
                    else begin
                       State <= CHECKGUEST;
                       MatchedID <= 1'b1;
                       if(Store_ROMData == 16'h8888) begin // checking whether the user is a guest or not
                          IsGuest <= 1'b1;
                       end
                       else begin
                          IsGuest <= 1'b0;
                       end
                    end
                    end
            default: begin
                    IsGuest <= 1'b0;
                    MatchedID <= 1'b0;
                    ROM_Addr <= 5'b00000;
                    Internal_PlayerID <= 3'b000;
                    Store_ROMData <= 16'd0;
                    UserEnteredID <= 16'd0;
                    Count <= 3'b000;
                    State <= DIGIT1;
                    end
         endcase
      end
   end

endmodule
