module quesadilla_decode (
    input wire clk,
    input wire WE,
    input wire [31:0] Inst,
    input wire [31:0] DataW,
    output wire [31:0] Dr1,
    output wire [31:0] Dr2,
    output wire [4:0]  dataWrite
);

    wire [31:0] instr_buffer;

    _cf_de if_id (
        .clk(clk),
        .Inst(Inst),
        .Bytes(instr_buffer)
    );

    _Newburrito decode (
        .clk(clk),
        .WE(WE),
        .info(instr_buffer),
        .DataW(DataW),
        .Dr1(Dr1),
        .Dr2(Dr2),
        .dataWrite(dataWrite)
    );

endmodule