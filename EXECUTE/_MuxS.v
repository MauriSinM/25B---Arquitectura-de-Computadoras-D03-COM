module _MuxS (
    input wire sel,
    input wire [4:0] A,
    input wire [4:0] B,
    output wire [4:0] s
);
    assign s = (sel) ? B : A;
endmodule