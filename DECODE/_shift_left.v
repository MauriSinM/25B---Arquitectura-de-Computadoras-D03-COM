module _shift_left(
    input wire [31:0] A,     // Entrada a desplazar
    output wire [31:0] B     // Salida desplazada
);

    assign B = {A[29:0], 2'b00}; // shift left 2

endmodule
