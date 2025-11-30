module _pc(
	input clk,
	input [31:0] DirSig,
	output reg [31:0] Dir
);
	initial Dir = 0;
	
	always @(posedge clk) begin
		Dir = DirSig;
	end

endmodule
