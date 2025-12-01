module _pc(
    input clk,
    input [31:0] DirSig,
    output reg [31:0] Dir
);
    initial Dir = 32'b0;
    
    always @(posedge clk) begin
        if (Dir === 32'bx || Dir === 32'bz) begin  // Si es desconocido o alta impedancia
            Dir <= 32'b0;
        end else begin
            Dir <= DirSig;
        end
    end
endmodule
