module countTo10Timer(enable, clk, rst, OneSecTimeout);

input enable, clk, rst;
output OneSecTimeout;

reg OneSecTimeout;
reg [3:0] count;

always @(posedge clk) begin
    if (rst==1'b0) begin
        count <= 0;
        OneSecTimeout <= 0;
    end
    else if (enable==1'b1) begin
        if (count == 4'd9) begin
            count <= 0;
            OneSecTimeout <= 1;
        end
        else begin
            count <= count + 1;
            OneSecTimeout <= 0;
        end
    end
    else
        OneSecTimeout <= 0;
end

endmodule