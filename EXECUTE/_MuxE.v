module _MuxE (
    input wire sel,
    input wire [4:0] Dr2,
    input wire [4:0] X,
    output wire [4:0] e
);
    assign e = (sel) ? X : Dr2;
endmodule