module _CF_DE (
    input wire clk,
    input wire [31:0] Inst,       // instrucción de entrada
    input wire [31:0] PC,         // contador de programa
    input wire [31:0] PC_plus_4,  // PC + 4
    output reg [31:0] Bytes,      // instrucción almacenada
    output reg [31:0] PC_out,     // PC almacenado
    output reg [31:0] PC_plus_4_out // PC + 4 almacenado
);
    initial begin
        Bytes = 32'b0;
        PC_out = 32'b0;
        PC_plus_4_out = 32'b0;
    end

    always @(posedge clk) begin
        Bytes = Inst;
        PC_out = PC;
        PC_plus_4_out = PC_plus_4;
    end

endmodule
