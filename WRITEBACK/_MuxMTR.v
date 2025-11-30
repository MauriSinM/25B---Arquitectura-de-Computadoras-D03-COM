module _MuxMTR (
    input wire MemToReg,          // 1: usar ReadData, 0: usar AluRes
    input wire [31:0] ReadData,   // salida de data_memory
    input wire [31:0] AluRes,     // salida de la ALU
    output wire [31:0] WriteData  // dato final que va al banco de registros
);

    assign WriteData = (MemToReg) ? ReadData : AluRes;

endmodule
