module _quesadilla(
	input clk
);
	
	wire [31:0] C1; 
	wire [31:0] C2; 
	wire [31:0] C3; 

	_pc inst5(.clk(clk), .DirSig(C2), .Dir(C1));

	_counter inst6(.dirsig(C1), .pc(C2));


	_percheron inst7(.DirInst(C1), .Inst(C3));

endmodule
