module Fi1(
		input 			[31:0]iX,
		output			[31:0]oData
		);
		
	assign oData = {iX[16:0],iX[31:17]} ^ {iX[18:0], iX[31:19]} ^ {10'd0,iX[31:10]};
	
endmodule

