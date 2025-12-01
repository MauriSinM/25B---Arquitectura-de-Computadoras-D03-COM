module _percheron(
	input [31:0] DirInst,
	input  WE,	
	output [31:0] Inst
);
	
	reg [7:0] MI [0:255];
	
	wire [4:0] C3;
	
	_cf_de inst3(.info(Inst));
	
	assign Inst = {MI[DirInst], MI[DirInst+1], MI[DirInst+2], MI[DirInst+3]};
	
	initial begin
		$readmemb("DATA\Set.txt", MI);
	end

endmodule

