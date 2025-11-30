module _MuxPC(
    input wire branch,               // Señal de control (BranchTaken)
    input wire [31:0] pc_plus_4,     // PC + 4
    input wire [31:0] branch_addr,   // PC + 4 + (SE << 2)
    output wire [31:0] pc_next       // Salida al PC
);

    assign pc_next = (branch) ? branch_addr : pc_plus_4;

endmodule
