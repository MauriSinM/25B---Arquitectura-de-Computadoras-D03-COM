module _sign_extend(
    input  wire [15:0] in,     // Inmediato de 16 bits
    output wire [31:0] out     // Inmediato extendido a 32 bits
);

    assign out = {{16{in[15]}}, in};

endmodule
