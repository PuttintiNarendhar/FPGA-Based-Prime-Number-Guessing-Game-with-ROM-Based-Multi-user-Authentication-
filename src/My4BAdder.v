// ECE6370 : ADD
// Author: Dharani Kandhalam - 1389
// 4 bit adder module
// Description: It adds 2 4bit numbers and stores that value into Sum

module My4BAdder(Num1, Num2, Sum);
    input [3:0] Num1, Num2;
    output [3:0] Sum;
    reg [3:0] Sum;

    always @(Num1, Num2)
        begin
           Sum = Num1 + Num2;
        end

endmodule
