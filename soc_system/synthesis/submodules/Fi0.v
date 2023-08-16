module Fi0(
		input 		[31:0]iX,
		output		[31:0]oData
		);
		
	assign oData = {iX[6:0],iX[31:7]} ^ {iX[17:0],iX[31:18]} ^ {3'd0,iX[31:3]};
endmodule

