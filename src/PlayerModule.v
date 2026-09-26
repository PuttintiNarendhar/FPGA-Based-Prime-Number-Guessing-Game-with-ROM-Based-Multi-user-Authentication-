// ECE6370 : ADD
// Author: Dharani Kandhalam - 1389
// Player Module
// Description: It takes 4 bit number from player and send it to 
// 7segmentdecoder for Displaying on 7segment Display

module PlayerModule(PlayerSwitch, PlayerDisplay);
    input [3:0] PlayerSwitch;
    output [6:0] PlayerDisplay;
	//output [6:0] D_out;
	
	//wire [3:0] D_in;
	
	My7SegmentDecoder_4To7 My7SegmentDisplay1(PlayerSwitch, PlayerDisplay);

	//DoorOpener MyDoorOpener1(Person, FaceRecognized, CardRecognized, Dlock_in);
	//DecoderLock MyDecoderLock1(Dlock_in, Dlock_out);
	//assign UnlockDoor = Dlock_in;
	
endmodule
