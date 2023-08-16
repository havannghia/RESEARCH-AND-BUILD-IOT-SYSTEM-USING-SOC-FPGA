module CheckZero2048
#(parameter iW=32,parameter oW=3)
( 
	input 					iClk,
	input					iEnable,
	input 		[iW-1:0] 	iDataX,	
	input 		[iW-1:0] 	iDataY,
	output					oFinish,
	output	reg	[11:0]		oLength
);
reg 				EnableCheckTotalZero;
reg		[7:0]	Step;
wire [5:0] 			PreTotalZeroY,
					PreTotalZeroX;
reg [11:0] 			TotalZeroY,
					TotalZeroX;
always@(posedge iClk)
if(!iEnable)
	Step	<=		8'b0;
else
  if(Step<65)
    Step <=		Step + 1'b1;
else
    Step <= 1'b0;
	
always@(*)
if(!iEnable)
	oLength		 =	1'b0;
else
	if(Step==64)
			oLength		 = TotalZeroY-TotalZeroX;
assign oFinish = (Step==64)?1:0;
//Kiem tra su chenh lech so bit 
CheckTotalZero total_of_zero_X
(
	.iData(iDataX),
	.TotalZero(PreTotalZeroX)
);

always@(posedge iClk)
if(!iEnable)
begin
	TotalZeroX <= 0;
	EnableCheckTotalZero <= 1;
end
else
begin
	if(EnableCheckTotalZero)
		if(!TotalZeroX)
			TotalZeroX <= PreTotalZeroX;
		else
			if(PreTotalZeroX==32)
				TotalZeroX <= TotalZeroX + PreTotalZeroX;
			else
				TotalZeroX <= PreTotalZeroX;
	if(Step==63)
			EnableCheckTotalZero <=0;
end	
CheckTotalZero total_of_zero_Y
(
	.iData(iDataY),
	.TotalZero(PreTotalZeroY)
	);
	
always@(posedge iClk)
if(!iEnable)
begin
	TotalZeroY <= 0;
end
else
begin
	if(EnableCheckTotalZero)
		if(!TotalZeroY)
			TotalZeroY <= PreTotalZeroY;
		else
			if(PreTotalZeroY==32)
				TotalZeroY <= TotalZeroY + PreTotalZeroY;
			else
				TotalZeroY <= PreTotalZeroY;
end	

endmodule
