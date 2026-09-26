module PrimeTargetGenerator(clk, rst, gen_target, level,
                            target_prime);

    input clk;
    input rst;
    input gen_target;
    input [1:0] level;

    output [7:0] target_prime;
    reg [7:0] target_prime;

    localparam IDLE           = 3'd0;
    localparam FETCH_ROM_ADDR = 3'd1;
    localparam ROM_CYC1       = 3'd2;
    localparam ROM_CYC2       = 3'd3;
    localparam ROM_CATCH      = 3'd4;

    reg [2:0] state;

    wire [2:0] level1_index;
    wire [3:0] level2_index;
    wire [4:0] level3_index;

    reg  [4:0] rom_address;
    wire [7:0] rom_q;

    reg [4:0] request_counter;

    RandomIndexLFSR RandomIndexLFSR_Module(
        clk,
        rst,
        level1_index,
        level2_index,
        level3_index
    );

    // Correct ROM module
    // Port order: address, clock, q
    ROM_PrimerNumbers ROM_PrimerNumbers_Module(
        rom_address,
        clk,
        rom_q
    );

    function [4:0] limit_index;
        input [1:0] level_in;
        input [4:0] value;

        begin
            case(level_in)

                // Level 1: ROM addresses 0 to 8
                // Prime range: 2 to 23
                2'd1: begin
                    if (value < 5'd9)
                        limit_index = value;
                    else if (value < 5'd18)
                        limit_index = value - 5'd9;
                    else if (value < 5'd27)
                        limit_index = value - 5'd18;
                    else
                        limit_index = value - 5'd27;
                end

                // Level 2: ROM addresses 0 to 15
                // Prime range: 2 to 53
                2'd2: begin
                    limit_index = {1'b0, value[3:0]};
                end

                // Level 3: ROM addresses 0 to 24
                // Prime range: 2 to 97
                2'd3: begin
                    if (value < 5'd25)
                        limit_index = value;
                    else
                        limit_index = value - 5'd25;
                end

                // If level is accidentally 0, treat it like Level 1
                default: begin
                    if (value < 5'd9)
                        limit_index = value;
                    else if (value < 5'd18)
                        limit_index = value - 5'd9;
                    else if (value < 5'd27)
                        limit_index = value - 5'd18;
                    else
                        limit_index = value - 5'd27;
                end

            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            state           <= IDLE;
            rom_address     <= 5'd0;
            target_prime    <= 8'd2;
            request_counter <= 5'd7;
        end
        else begin
            case(state)

                IDLE: begin
                    if (gen_target == 1'b1) begin
                        state <= FETCH_ROM_ADDR;
                    end
                    else begin
                        state <= IDLE;
                    end
                end

                FETCH_ROM_ADDR: begin

                    case(level)

                        // Level 1:
                        // Use level2_index because level1_index only gives 0 to 7.
                        // XOR with request_counter so address does not keep becoming 0.
                        2'd1: begin
                            rom_address <= limit_index(2'd1, ({1'b0, level2_index} ^ request_counter));
                        end

                        // Level 2:
                        // Address range 0 to 15
                        2'd2: begin
                            rom_address <= limit_index(2'd2, ({1'b0, level2_index} ^ request_counter));
                        end

                        // Level 3:
                        // Address range 0 to 24
                        2'd3: begin
                            rom_address <= limit_index(2'd3, (level3_index ^ request_counter));
                        end

                        // Safety default: treat invalid level as Level 1
                        default: begin
                            rom_address <= limit_index(2'd1, ({1'b0, level2_index} ^ request_counter));
                        end

                    endcase

                    request_counter <= request_counter + 5'd3;
                    state <= ROM_CYC1;
                end

                ROM_CYC1: begin
                    state <= ROM_CYC2;
                end

                ROM_CYC2: begin
                    state <= ROM_CATCH;
                end

                ROM_CATCH: begin
                    target_prime <= rom_q;
                    state <= IDLE;
                end

                default: begin
                    state        <= IDLE;
                    rom_address  <= 5'd0;
                    target_prime <= 8'd2;
                end

            endcase
        end
    end

endmodule