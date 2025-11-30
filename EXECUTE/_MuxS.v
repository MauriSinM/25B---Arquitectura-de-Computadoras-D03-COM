module _MuxS (
    input wire sel,
    input wire [31:0] A,
    input wire [31:0] B,
    output wire [31:0] s
);
    assign s = (sel) ? B : A;
endmodule
