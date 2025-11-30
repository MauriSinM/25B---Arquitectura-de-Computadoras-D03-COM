module _Newburrito (
    input wire clk,
    input wire WE,               
    input wire [31:0] info,      
    output wire [31:0] Dr1,      
    output wire [31:0] Dr2,      
    output wire [4:0] dataWrite  
);

    reg  [4:0]  Ar1;     
    reg  [4:0]  Ar2;     
    reg  [4:0]  AW;      
    reg  [31:0] ext;     
    reg         sel;     
    reg  [4:0]  s;

    _Modifiedregister_b inst1(.RS(Ar1), .RT(Ar2), .RD(AW), .DataIn(dataWrite), .WE(WE), .Dr1(Dr1), .Dr2(Dr2));
    _cf_de inst2(.Bytes(info));
    _MuxS inst3(.sel(sel), .A(Ar2), .B(AW), .s(dataWrite));

    always @(*) begin
        // Valores por defecto
        sel = 1'b1;  // Por defecto rt como destino (Tipo I)
        Ar1 = 5'b0;
        Ar2 = 5'b0;
        AW  = 5'b0;
        ext = 32'b0;

        // Decodificación por opcode
        case(info[31:26])
            // INSTRUCCIONES TIPO R
            6'b000000: begin  // ADD, SUB, AND, OR, SLT, etc.
                sel = 1'b0;   // rd como destino
                Ar1 = info[25:21]; // rs
                Ar2 = info[20:16]; // rt
                AW  = info[15:11]; // rd
            end
            
            // INSTRUCCIONES TIPO I - ARITMÉTICAS
            6'b001000: begin // ADDI
                sel = 1'b1;   // rt como destino
                Ar1 = info[25:21]; // rs
                AW  = info[20:16]; // rt
            end
            
            6'b001100: begin // ANDI
                sel = 1'b1;
                Ar1 = info[25:21]; // rs
                AW  = info[20:16]; // rt
            end
            
            6'b001101: begin // ORI
                sel = 1'b1;
                Ar1 = info[25:21]; // rs
                AW  = info[20:16]; // rt
            end
            
            6'b001010: begin // SLTI
                sel = 1'b1;
                Ar1 = info[25:21]; // rs
                AW  = info[20:16]; // rt
            end

            // INSTRUCCIONES TIPO I - MEMORIA
            6'b100011: begin // LW (Load Word)
                sel = 1'b1;   // rt como destino
                Ar1 = info[25:21]; // base address register
                AW  = info[20:16]; // rt destino
            end
            
            6'b101011: begin // SW (Store Word)
                sel = 1'b1;   // no importa (no escritura)
                Ar1 = info[25:21]; // base address register
                Ar2 = info[20:16]; // rt con dato a almacenar
            end
            
            6'b100000: begin // LB (Load Byte)
                sel = 1'b1;
                Ar1 = info[25:21]; // base
                AW  = info[20:16]; // rt destino
            end
            
            6'b101000: begin // SB (Store Byte)
                sel = 1'b1;
                Ar1 = info[25:21]; // base
                Ar2 = info[20:16]; // rt con dato
            end

            // INSTRUCCIONES TIPO I - SALTO CONDICIONAL
            6'b000100: begin // BEQ (Branch Equal)
                sel = 1'b1;   // no escritura
                Ar1 = info[25:21]; // rs
                Ar2 = info[20:16]; // rt
            end
            
            6'b000101: begin // BNE (Branch Not Equal)
                sel = 1'b1;
                Ar1 = info[25:21]; // rs
                Ar2 = info[20:16]; // rt
            end
            
            6'b000001: begin // BGEZ/BLTZ
                sel = 1'b1;
                Ar1 = info[25:21]; // rs
            end

            // INSTRUCCIONES TIPO J
            6'b000010: begin // J (Jump)
                sel = 1'b1;   // no escritura
                // No usa registros
            end
            
            default: begin
                // Instrucción no reconocida - NOP
                sel = 1'b1;
                Ar1 = 5'b0;
                Ar2 = 5'b0;
                AW  = 5'b0;
            end
        endcase
    end
	
    assign dataWrite = s;

endmodule
