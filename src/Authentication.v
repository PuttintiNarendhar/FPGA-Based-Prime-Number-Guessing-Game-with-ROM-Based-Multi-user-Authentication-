//ECE6370
//Author: Narendhar Puttinti, PSID: 2454090
//Authentication
//controls the login and logout by verifing the ID and password entered with the ID and password stored in the ROMs
//there are four modules inside this they are PlayerID_ROM, Password_ROM, ID_Checking_Module and Password_Checking_Module
//it will control game controller module to start or not by the signal called Passed
module Authentication(
    ID_Password_Enter,
    ID_Password_Digit,
    LogOut_From_GCM,
    clk,
    rst,
    Logged_In,
    Logged_Out,
    Passed,
    isGuest_FromAuth,
    PlayerInternalID_FromAuth
);

   input clk, rst;
   input ID_Password_Enter, LogOut_From_GCM;
   input [3:0] ID_Password_Digit;

   output Logged_In, Logged_Out, Passed;
   output isGuest_FromAuth;
   output [2:0] PlayerInternalID_FromAuth;

   wire [4:0] ID_ROM_Addr, PSWD_ROM_Addr;
   wire [15:0] ID_ROM_Data;
   wire [23:0] PSWD_ROM_Data;
   wire LogOut_From_PCM, IsGuest, MatchedID;
   wire [2:0] Internal_PlayerID, Internal_PlayerID_PCM;
   wire IsGuest_From_PCM;
   
   PlayerID_ROM DUT_PlayerID_ROM (
      ID_ROM_Addr,
      clk,
      ID_ROM_Data
   );

   ID_Checking_Module DUT_ID_Checking_Module (
      ID_Password_Enter,
      ID_Password_Digit,
      ID_ROM_Data,
      LogOut_From_PCM,
      clk,
      rst,
      IsGuest,
      MatchedID,
      Internal_PlayerID,
      ID_ROM_Addr
   );

   Password_ROM DUT_Password_ROM (
      PSWD_ROM_Addr,
      clk,
      PSWD_ROM_Data
   );

   Password_Checking_Module DUT_Password_Checking_Module (
      ID_Password_Enter,
      ID_Password_Digit,
      IsGuest,
      MatchedID,
      Internal_PlayerID,
      PSWD_ROM_Data,
      LogOut_From_GCM,
      clk,
      rst,
      Logged_In,
      Logged_Out,
      Passed,
      LogOut_From_PCM,
      IsGuest_From_PCM,
      Internal_PlayerID_PCM,
      PSWD_ROM_Addr
   );

   assign isGuest_FromAuth = IsGuest_From_PCM;
   assign PlayerInternalID_FromAuth = Internal_PlayerID_PCM;

endmodule
