module MAJ(
		input 			[31:0]	iX,
		input			[31:0]	iY,
		input			[31:0]	iZ,
		output			[31:0]	oData
		);

	assign oData = (iX & iY) ^ (iX & iZ) ^ (iY & iZ); 
endmodule
