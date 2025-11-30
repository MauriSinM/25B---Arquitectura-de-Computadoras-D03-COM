module _adder(
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] S
);

    assign S = A + B;

endmodule
