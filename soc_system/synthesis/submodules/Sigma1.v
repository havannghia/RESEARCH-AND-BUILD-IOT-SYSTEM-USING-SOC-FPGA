module Sigma1(
		input 				[31:0] iX,
		output				[31:0] oData
			);
			
	assign oData = {iX[5:0],iX[31:6]} ^ {iX[10:0],iX[31:11]} ^ {iX[24:0],iX[31:25]};
endmodule

