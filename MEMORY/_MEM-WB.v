module _mem_br (
    input wire clk,
    input wire [31:0] ReadData,   // dato leído de memoria (MEM)
    input wire [31:0] AluRes,     // resultado de ALU (MEM)
    input wire [4:0]  Rd,         // registro destino (MEM)
    input wire RegWrite_in,       // señal RegWrite desde MEM
    input wire MemToReg_in,       // señal MemToReg desde MEM

    output reg [31:0] ReadData_out,   // pasa a br
    output reg [31:0] AluRes_out,     // pasa a br
    output reg [4:0]  Rd_out,         // pasa a br
    output reg RegWrite_out,          // pasa a br
    output reg MemToReg_out           // pasa a br
);

    initial begin
        ReadData_out = 32'b0;
        AluRes_out   = 32'b0;
        Rd_out       = 5'b0;
        RegWrite_out = 1'b0;
        MemToReg_out = 1'b0;
    end

    always @(posedge clk) begin
        ReadData_out <= ReadData;
        AluRes_out   <= AluRes;
        Rd_out       <= Rd;
        RegWrite_out <= RegWrite_in;
        MemToReg_out <= MemToReg_in;
    end

endmodule
