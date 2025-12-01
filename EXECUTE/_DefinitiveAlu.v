module _DefinitiveAlu(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [2:0] op,       
    output reg [31:0] C
);
    _de_ex inst1(.Dr1(A), .Dr2(B));

    always @* begin
        
        //   op[2] == 0 → ARITHMETIC
        if (op[2] == 0) begin : arithm
            case (op[1:0])

                // ADD
                2'b00: C = A + B;          

                // SUB (usado por BEQ)
                2'b01: begin
                    C = A - B;

                    // BEQ → si A == B → C = 1
                    if (op == 3'b001) begin
                        C = (A == B) ? 32'b1 : 32'b0;
                    end
                end        

                // Comparadores
                2'b11: begin                
                    if (op[2] == 0)        
                        C = (A == B) ? 32'b1 : 32'b0;  
                    else
                        C = (A > B) ? 32'b1 : 32'b0;
                end
            endcase
        
        end else begin
        //   op[2] == 1 → LOGIC
            case (op[2:0])
                3'b100: C = A & B;         
                3'b101: C = A | B;         
                3'b110: C = A ^ B;         
                3'b111: C = ~A;            
            endcase
        end
    end

endmodule

