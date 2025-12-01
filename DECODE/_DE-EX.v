module _DE_EX (
    input wire clk,
    input wire [31:0] Dr1,   
    input wire [31:0] Dr2,   
    output reg [31:0] A ,
    output reg [31:0] B
);

    initial A = 32'b0;
    initial B = 32'b0;
	
	_Newburrito inst1(.clk(clk), .C1(Dr1), .C2(Dr2));
	
    always @(posedge clk) begin
		A = Dr1;
		B = Dr2;
	end

endmodule

