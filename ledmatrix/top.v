module top(
    input CLK,
    input RST,

    inout LEDA,
    inout LEDB,
    inout LEDC,
    inout LEDD,
    inout LEDE,
    inout LEDF,
    inout LEDG,
    inout LEDH
);

    wire [55:0] pattern;

    // =)
    assign pattern =
        (56'b0000000 << 0) |
        (56'b0010100 << 7) |
        (56'b0010100 << 14) |
        (56'b0010100 << 21) |
        (56'b0000000 << 28) |
        (56'b0100010 << 35) |
        (56'b0011100 << 42) |
        (56'b0000000 << 49);

    ledmatrix matrix(
        .clk(CLK),
        .*
    );

endmodule
