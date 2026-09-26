# FPGA Based Prime Number Guessing Game With ROM Based Multi User Authentication And RAM Based Score Tracking
### ECE6370 Advanced Digital Design

*Developer:* Narendhar Puttinti    

---

## 🛠️ Detailed System Architecture

This project implements a secure, highly interactive digital gaming engine deployed on an *Altera Cyclone V (DE0-CV)* FPGA board. The system utilizes a dual-layer architecture: a *ROM-Based Multi-User Authentication Layer* that gates access to a *3-Level Difficulty Prime Number Guessing Engine*.

### 1. Step-by-Step Authentication System
The security module contains a pre-programmed *ID_Checking_Module ROM* containing pairs of registered Player IDs and passwords. Access requires a sequential, two-tiered validation sequence:

1. *System Reset:* Pressing *BUTTON 0* clears any previous state configurations and forces the system into the *Logged Out* state (LED1 active).
2. *Enter Player ID:* The player enters a 4-digit ID number using the 4 input switches (*SW3–SW0), setting one BCD digit at a time. After positioning switches for each digit, they press **BUTTON 1 (Enter)* to latch it.
3. *ID Checking:* The FSM validates the entered ID array against the internal ROM database. If a matching ID configuration is found, the system progresses to the passcode check phase.
4. *Enter Password:* The player enters a 6-digit password sequentially via *SW3–SW0, pushing **BUTTON 1 (Enter)* after each digit selection.
5. *Password Checking:* The ID_Checking_Module matches the completed 6-digit input sequence against the targeted password row mapped to that specific Player ID in ROM.
   * *Login Successful:* LED0 (Logged In) turns ON, unlocking the gameplay states.
   * *Login Failed:* LED1 stays active, completely locking out access. The user must re-enter valid credentials from Step 2.

---

## 🕹️ Gameplay Mechanics & Rules

Once authenticated, the system transitions to the *PrimeGameController FSM*, clearing previous match histories and initializing the gameplay pipelines.

### 1. Difficulty Level Selection
Before the game starts, the player adjusts the difficulty layout using a dedicated selection button. The chosen level configures the hidden prime target range and the system countdown timer settings:
* *Level 1:* Prime Target Range = 2 to 23 | Timer Duration = *099 seconds*
* *Level 2:* Prime Target Range = 2 to 53 | Timer Duration = *160 seconds*
* *Level 3:* Prime Target Range = 2 to 97 | Timer Duration = *220 seconds*

### 2. Target Generation & Play
* Pressing *BUTTON 1 (Game Start)* launches the chosen level configurations and kicks off the decrementing game clock.
* Tapping *BUTTON 2 (Generate Challenge)* causes the PrimeTargetGenerator to capture an integer from its free-running *LFSR pseudo-random generator* network cross-checked against a ROM-based prime number filter. 
* The selected target prime number is kept *completely hidden from the player* throughout the round.

### 3. Entering a Two-Digit Guess (Switch Multiplexing)
Because the prime range can span up to two decimal digits (up to 97), the player inputs a *2-digit base-10 number* using only the 4 binary switches via sequential loading steps:
1. *Enter Tens Digit:* Set switches *SW3–SW0* to match the value of the tens place digit, then press *BUTTON 3 (LOAD)*. This stores the tens value.
2. *Enter Units Digit:* Set switches *SW3–SW0* to match the value of the units place digit, then press *BUTTON 3 (LOAD)* a second time.
3. *Guess Checking:* Once both digits are loaded, the internal system reconstructs the full decimal number to execute comparison checks.

### 4. Real-Time Hint Feedback System
The PrimeChecker instantly validates if the guessed number is a prime number and passes the results to the game controller. The system displays a live feedback string indicator across the *HEX 2 display* panel:
* *P: The entered number is **not prime / invalid guess*.
* *S: The entered guess is **smaller* than the hidden target prime.
* *L: The entered guess is **larger* than the hidden target prime.
* *C: **Correct Guess!* The player successfully matched the hidden target.

### 5. Scoring & The Winner Tracking Circle
* *Continuous Play:* When a guess is correct (*C*), the player's session score increments by one. The entered display vanishes, and a brand new hidden target prime is instantly generated while the clock continues counting down.
* *Game Over:* When the timer hits 00 seconds, game actions freeze.
* *Winner Tracking Module:* The system pulls the final score and evaluates it against the user's personal best historical performance and the global all-time high score tracked on the chip. If a new milestone is hit, a personalized visual alert sequence displays.
* *Logout / Session Close:* The player can tap *BUTTON 1 (Load/Logout)* when a game ends to cleanly log out of their session profile and return the system back to the default secure authentication page.

---

## 🗺️ FPGA Hardware Interface Mapping

Based on your design details, the physical peripheral mapping for the *Terasic DE0-CV* board maps exactly as follows:

| Hardware Component | Functional Designation | Operational Behavior / Purpose |
| :--- | :--- | :--- |
| *HEX 5* | Game Timer (Tens) | Displays tens place of the active game clock countdown. |
| *HEX 4* | Game Timer (Units) | Displays units place of the active game clock countdown. |
| *HEX 3* | Player Score | Tracks and displays the total number of correct guesses in the session. |
| *HEX 2* | Hint Status Window | Displays current hint feedback configurations (P, S, L, or C). |
| *HEX 1* | Target Debug / Level | Used to manage and verify internal processing variables. |
| *HEX 0* | User Input Mirror | Echoes the active 4-bit switch data settings toggled by the player. |
| *SW3 ~ SW0* | Shared Input Bus | 4-bit binary input switches used for ID digits, password digits, tens guess, and units guess. |
| *BUTTON 0* | Global System Reset | Erases game variables and forces a clean user *Logout*. |
| *BUTTON 1* | Enter / Start Game | Double-duty: Latches ID/Password entries and initializes the game timer. |
| *BUTTON 2* | Generate Challenge | Captures a fresh hidden target prime from the LFSR tracking network. |
| *BUTTON 3* | Load Guess Button | Latches the input guess sequentially (First press = Tens, Second press = Units). |
| *LED 0* | Logged-In Indicator | High state indicates user authentication pass. |
| *LED 1* | Logged-Out Indicator | High state indicates default system lock or unauthorized access. |
| *LED 8* | Mismatched Guess | Latches high when a user guess does not match the target. |
| *LED 9* | Successful Match | Latches high upon perfect match completion (Guess = Target). |

---

## 💻 Compilation & Deployment Setup

### 1. Generating the Non-Volatile .pof Target
1. Open your project configuration workspace inside *Intel Quartus Prime*.
2. Run your design setup configurations through *Assignments ➔ Device ➔ Device and Pin Options...*
3. Under the *Configuration* module page, switch the scheme to *Active Serial* and match your configuration device setting to your board's flash layer chip target (e.g., *EPCS64*). Click OK.
4. Double-click *Start Compilation* (Ctrl + L). Once compilation reaches 100% without structural errors, a permanent configuration .pof image file will be written into your local output_files/ folder directory.

### 2. Active Serial (AS) Board Programming
1. Hook up the *Terasic DE0-CV Board* to your system computer using a standard USB cable plugged into the native *USB-Blaster Port*.
2. Locate the physical slide toggle switch designated *SW10 (RUN/PROG)* next to the 7-segment display blocks.
3. *Slide the SW10 toggle switch to the PROG position.*
4. From the Quartus top control utility bar, click *Tools ➔ Programmer*.
5. Click *Hardware Setup..., choose your active **USB-Blaster* hardware, and close the sub-window.
6. Change the programmer window operational mode dropdown setting from JTAG to *Active Serial Programming*.
7. Click *Add File..., open the output_files/ directory layout, choose your compiled *.pof file**, and make sure your target hardware row configurations are checked active.
8. Click *Start* to run the hardware flash pipeline. 
9. Once the tool reaches *100% (Successful), **slide SW10 back to the RUN position* to boot up the system. The board will safely run your secure authentication sequence.

---

## 🛠️ Software Environment & Specifications
* *Synthesis Suite:* Intel Quartus Prime Lite / Standard Edition
* *Target Device SoC:* Altera Cyclone V 5CEBA4F23C7N FPGA
* *Hardware Design Description:* Verilog HDL / VHDL
*
