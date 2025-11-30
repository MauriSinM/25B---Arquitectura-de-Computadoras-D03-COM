module _counter(
	input [31:0] dirsig,
	output reg[31:0] pc
);

	always @* begin
        pc = dirsig + 4;
    end
	
endmodule