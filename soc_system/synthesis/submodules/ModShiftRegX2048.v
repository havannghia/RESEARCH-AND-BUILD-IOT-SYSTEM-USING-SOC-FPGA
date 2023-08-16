module ModShiftRegX2048
#(parameter W=32,parameter iW=2048,parameter oW=2048)
(
	input 					iClk,
	input					iEnable,
	input					iLoad,
	input					iOutputLoad,
	input		[iW-1:0]	iData,
	input		[W-1:0]		iDataShiftReg,
	output 		[W-1:0]		oDataShiftReg,
	output		[oW-1:0]	oData
);
reg [iW-1:0]	RegBuff;
always@(posedge iClk)
	if(iLoad)
		RegBuff <= iData;
	else
	if(iEnable)
		begin
			RegBuff[2015:0]   <= RegBuff[2047:32];
			RegBuff[2047:2016]<= iDataShiftReg;
		end
assign	oDataShiftReg = RegBuff[31:0];

assign oData				= 		(iOutputLoad)?RegBuff			:2048'b0; 			

	
endmodule
