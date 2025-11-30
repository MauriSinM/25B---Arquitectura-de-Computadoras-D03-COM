module _cf_de (
    input wire clk,
    input wire [31:0] Inst,       // instrucción de entrada
    output reg [31:0] Bytes       // instrucción almacenada
);
    initial Bytes = 32'b0;

    always @(posedge clk) begin
        Bytes = Inst;
    end

endmodule
