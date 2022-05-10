/*
 * Driver for Sparkfun 8x7 Charlieplexed LED matrix.
 * https://www.sparkfun.com/products/retired/13795
 */
module ledmatrix(
    input clk,

    input [55:0] pattern,

    /* Need to use inout for Yosys tri-state inference to work */
    inout LEDA,
    inout LEDB,
    inout LEDC,
    inout LEDD,
    inout LEDE,
    inout LEDF,
    inout LEDG,
    inout LEDH
);

    parameter COUNTER_WIDTH = 8;
    reg [COUNTER_WIDTH-1:0] counter = 0;

    always @(posedge clk) begin
        counter <= counter + 1'b1;
    end

    wire row_on;
    wire [2:0] row_num;
    reg [6:0] row_pattern;

    assign row_num = counter[COUNTER_WIDTH-1:COUNTER_WIDTH-3];
    assign row_on = counter[COUNTER_WIDTH-4];

    /*
    * TODO: odd bug. This assignment doesn't work, but the long-form does.
    * With the short-form, a 1 bit in the MSB of the 2nd-to-last row causes the
    * MSB of the last bit to always be on.
    */
    // assign row_pattern = (pattern >> (row_num * 7)) & 7'h7f;
    always @(*) begin
        case (row_num)
            3'd0: row_pattern = pattern & 7'h7f;
            3'd1: row_pattern = (pattern >> 7) & 7'h7f;
            3'd2: row_pattern = (pattern >> 14) & 7'h7f;
            3'd3: row_pattern = (pattern >> 21) & 7'h7f;
            3'd4: row_pattern = (pattern >> 28) & 7'h7f;
            3'd5: row_pattern = (pattern >> 35) & 7'h7f;
            3'd6: row_pattern = (pattern >> 42) & 7'h7f;
            3'd7: row_pattern = (pattern >> 49) & 7'h7f;
        endcase
    end

    reg [7:0] led_oe;
    wire [7:0] led_val;

    always @(*) begin
        if (!row_on) begin
            led_oe = 8'b0;
        end else begin
            case (row_num)
                3'd0:
                    led_oe = {row_pattern, 1'b1};
                3'd1:
                    led_oe = {row_pattern[6:1], 1'b1, row_pattern[0]};
                3'd2:
                    led_oe = {row_pattern[6:2], 1'b1, row_pattern[1:0]};
                3'd3:
                    led_oe = {row_pattern[6:3], 1'b1, row_pattern[2:0]};
                3'd4:
                    led_oe = {row_pattern[6:4], 1'b1, row_pattern[3:0]};
                3'd5:
                    led_oe = {row_pattern[6:5], 1'b1, row_pattern[4:0]};
                3'd6:
                    led_oe = {row_pattern[6], 1'b1, row_pattern[5:0]};
                3'd7:
                    led_oe = {1'b1, row_pattern};
            endcase
        end
    end

    assign led_val = 8'b1 << row_num;

    assign LEDA = led_oe[0] ? led_val[0] : 1'bZ;
    assign LEDB = led_oe[1] ? led_val[1] : 1'bZ;
    assign LEDC = led_oe[2] ? led_val[2] : 1'bZ;
    assign LEDD = led_oe[3] ? led_val[3] : 1'bZ;
    assign LEDE = led_oe[4] ? led_val[4] : 1'bZ;
    assign LEDF = led_oe[5] ? led_val[5] : 1'bZ;
    assign LEDG = led_oe[6] ? led_val[6] : 1'bZ;
    assign LEDH = led_oe[7] ? led_val[7] : 1'bZ;

endmodule
