module _Modifiedregister_b(
    input [4:0] RS,
    input [4:0] RT,
    input [4:0] RD,
    input [31:0] DataIn,
    input WE,
    output reg [31:0] Dr1,
    output reg [31:0] Dr2
);

    reg [31:0] RB [0:31];

    initial begin
        $readmemb("Datos.txt", RB);
    end

    always @(*) begin
        Dr1 = RB[RS];
        Dr2 = RB[RT];
    end

    always @(*) begin
        if (WE)
            RB[RD] = DataIn;
    end

endmodule
