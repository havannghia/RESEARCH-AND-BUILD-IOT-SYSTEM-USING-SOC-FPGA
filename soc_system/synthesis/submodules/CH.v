module CH(
		input [31:0] iX,
		input [31:0] iY,
		input [31:0] iZ,
		
		output [31:0] oData
		);
		
	wire [31:0]temp1;
	wire [31:0]temp2;
	
	assign temp1 = iX & iY;
	assign temp2 = ~iX & iZ;
	
	assign oData = temp1 ^ temp2;
endmodule

