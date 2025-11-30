module alu_control(
    input wire [1:0] ALUOp,        // Señales desde control unit
    input wire [5:0] funct,        // Campo funct de instrucciones tipo R
    output reg [3:0] ALUCtrl       // Señal final hacia la ALU
);

    always @(*) begin
        case(ALUOp)

            // 00 → LW / SW → ADD
            2'b00: begin
                ALUCtrl = 4'b0010;
            end
            
            // 01 → BEQ → SUB
            2'b01: begin
                ALUCtrl = 4'b0110;
            end

            // 10 → Tipo R → depende de funct
            2'b10: begin
                case(funct)
                    6'b100000: ALUCtrl = 4'b0010; // ADD
                    6'b100010: ALUCtrl = 4'b0110; // SUB
                    6'b100100: ALUCtrl = 4'b0000; // AND
                    6'b100101: ALUCtrl = 4'b0001; // OR
                    6'b101010: ALUCtrl = 4'b0111; // SLT
                    default:   ALUCtrl = 4'b1111; // operación inválida
                endcase
            end

            // Cualquier otro ALUOp (no debería pasar)
            default: begin
                ALUCtrl = 4'b1111;
            end

        endcase
    end

endmodule
