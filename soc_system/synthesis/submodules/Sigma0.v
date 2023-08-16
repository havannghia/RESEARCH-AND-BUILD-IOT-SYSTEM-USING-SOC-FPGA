module Sigma0(
			input 			[31:0]		iX,
			output			[31:0]		oData
			);
	
	assign oData = {iX[1:0],iX[31:2]} ^ {iX[12:0],iX[31:13]} ^ {iX[21:0],iX[31:22]};
endmodule

