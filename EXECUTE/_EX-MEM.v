module _ex_mem (
    input wire clk,

    // Señales de control desde EX
    input wire MemWrite_in,
    input wire MemRead_in,
    input wire MemToReg_in,
    input wire RegWrite_in,

    // Señales de datos desde EX
    input wire [31:0] AluResult_in,
    input wire [31:0] WriteData_in,
    input wire [4:0]  Rd_in,

    // Señales de control hacia MEM
    output reg MemWrite_out,
    output reg MemRead_out,
    output reg MemToReg_out,
    output reg RegWrite_out,

    // Señales de datos hacia MEM
    output reg [31:0] AluResult_out,
    output reg [31:0] WriteData_out,
    output reg [4:0]  Rd_out
);

    // Inicialización (opcional)
    initial begin
        MemWrite_out  = 0;
        MemRead_out   = 0;
        MemToReg_out  = 0;
        RegWrite_out  = 0;
        AluResult_out = 0;
        WriteData_out = 0;
        Rd_out        = 0;
    end

    // Actualizar en flanco positivo del reloj
    always @(posedge clk) begin
        // Control
        MemWrite_out <= MemWrite_in;
        MemRead_out  <= MemRead_in;
        MemToReg_out <= MemToReg_in;
        RegWrite_out <= RegWrite_in;

        // Datos
        AluResult_out <= AluResult_in;
        WriteData_out <= WriteData_in;
        Rd_out        <= Rd_in;
    end

endmodule
