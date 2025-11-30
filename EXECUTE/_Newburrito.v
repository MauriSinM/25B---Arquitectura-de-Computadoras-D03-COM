module _Newburrito (
    input wire clk,
    input wire WE,               
    input wire [31:0] info,      
    input wire [5:0] opcode,     // Añadido: opcode de la instrucción
    input wire [5:0] funct,      // Añadido: campo funct para tipo R
    output wire [31:0] Dr1,      
    output wire [31:0] Dr2,      
    output wire [4:0] dataWrite,
    output wire [3:0] ALUControl // Añadido: señal de control para ALU
);

    // Declarar todas las señales de control
    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch;
    wire [1:0] ALUOp;
    
    reg [4:0] Ar1;     
    reg [4:0] Ar2;     
    reg [4:0] AW;      
    reg [31:0] ext;     
    reg sel;     
    reg [4:0] s;

    // Instanciar módulos
    _Modifiedregister_b inst1(
        .RS(Ar1), 
        .RT(Ar2), 
        .RD(AW), 
        .DataIn(dataWrite), 
        .WE(WE), 
        .Dr1(Dr1), 
        .Dr2(Dr2)
    );

    _cf_de inst2(.Bytes(info));
    
    _MuxS inst3(.sel(sel), .A(Ar2), .B(AW), .s(dataWrite));

    // Unidad de control principal
    always @(*) begin
        case(opcode)
            // TIPO R
            6'b000000: begin
                RegDst   = 1'b1;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b10;
            end

            // LW
            6'b100011: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemToReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b00;
            end

            // SW
            6'b101011: begin
                RegDst   = 1'bx;
                ALUSrc   = 1'b1;
                MemToReg = 1'bx;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                Branch   = 1'b0;
                ALUOp    = 2'b00;
            end

            // BEQ
            6'b000100: begin
                RegDst   = 1'bx;
                ALUSrc   = 1'b0;
                MemToReg = 1'bx;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b1;
                ALUOp    = 2'b01;
            end

            // ADDI
            6'b001000: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                ALUOp    = 2'b00;
            end

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

    // ALU Control - genera las señales específicas para la ALU
    reg [3:0] ALUControl_reg;
    
    always @(*) begin
        case(ALUOp)
            2'b00: ALUControl_reg = 4'b0010; // Suma (para LW/SW/ADDI)
            2'b01: ALUControl_reg = 4'b0110; // Resta (para BEQ)
            2'b10: begin // Tipo R - depende de funct
                case(funct)
                    6'b100000: ALUControl_reg = 4'b0010; // ADD
                    6'b100010: ALUControl_reg = 4'b0110; // SUB
                    6'b100100: ALUControl_reg = 4'b0000; // AND
                    6'b100101: ALUControl_reg = 4'b0001; // OR
                    6'b101010: ALUControl_reg = 4'b0111; // SLT
                    default:   ALUControl_reg = 4'b0000; // Por defecto
                endcase
            end
            default: ALUControl_reg = 4'b0000;
        endcase
    end

    assign ALUControl = ALUControl_reg;
    assign dataWrite = s;

endmodule
