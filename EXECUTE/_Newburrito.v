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
        // Opcode (bits [31:26]) define tipo
        if (info[31:26] == 6'b000000) begin
            // Tipo R
            sel = 0;
            Ar1 = info[25:21];
            Ar2 = info[20:16];
            AW  = info[15:11];
            ext = 32'b0;
        end

		// else begin

        // end
    end
	
    assign dataWrite = s;

endmodule
