module LevelSelector(
    input clk,
    input rst,
    input level_pulse,
    input game_active,
    output reg [1:0] level
);

always @(posedge clk) begin
    if (rst == 1'b0)
        level <= 2'd1;
    else if (level_pulse && !game_active) begin
        if (level == 2'd3)
            level <= 2'd1;
        else
            level <= level + 2'd1;
    end
end

endmodule