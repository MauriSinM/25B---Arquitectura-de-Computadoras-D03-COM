module _control_unit(
    input  wire [5:0] opcode,       // bits [31:26] de la instrucción
    output reg        RegDst,       
    output reg        ALUSrc,       
    output reg        MemToReg,     
    output reg        RegWrite,     
    output reg        MemRead,      
    output reg        MemWrite,     
    output reg        Branch,       
    output reg [1:0]  ALUOp         
);

    always @(*) begin
        case(opcode)

            //          TIPO R
            6'b000000: begin
                RegDst   = 1'b1;   // destino = rd
                ALUSrc   = 1'b0;   // ALU usa registro B
                MemToReg = 1'b0;   // WB viene de ALU
                RegWrite = 1'b1;   // escribe registro
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b10;  // la ALU depende de funct
            end

            //          LW
            6'b100011: begin
                RegDst   = 1'b0;   // rt
                ALUSrc   = 1'b1;   // inmediato
                MemToReg = 1'b1;   // WB = memoria
                RegWrite = 1'b1;
                MemRead  = 1'b1;   // leer memoria
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b00;  // suma para dirección
            end

            //          SW
            6'b101011: begin
                RegDst   = 1'bx;   // no se usa
                ALUSrc   = 1'b1;   // inmediato
                MemToReg = 1'bx;   // no se usa
                RegWrite = 1'b0;   // no escribe registro
                MemRead  = 1'b0;
                MemWrite = 1'b1;   // escribe memoria
                Branch   = 1'b0;
                ALUOp    = 2'b00;  // suma
            end

            //          BEQ
            6'b000100: begin
                RegDst   = 1'bx;
                ALUSrc   = 1'b0;   
                MemToReg = 1'bx;
                RegWrite = 1'b0;   // no escribe
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b1;   // activar comparación
                ALUOp    = 2'b01;  // ALU = resta
            end

            //          ADDI
            6'b001000: begin
                RegDst   = 1'b0;   // rt
                ALUSrc   = 1'b1;   // inmediato
                MemToReg = 1'b0;   // WB viene de ALU
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b00;  // suma
            end

            //          Otro/opcode inválido
            default: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b00;
            end

        endcase
    end

endmodule
