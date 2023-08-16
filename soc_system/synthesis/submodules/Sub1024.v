module Sub1024
#(parameter iW=32, parameter oW=32, parameter W = 33)
( 
	input 					iClk,
	input					iEnable,
	input 		[iW-1:0] 	iX,	
	input 		[iW-1:0] 	iY,	
	output 		[oW-1:0]	oZ,		
	output 	reg				oFinish 
);
wire [W-1:0] 		Diff ;
reg 				Carry;
wire 		 		PreDiff;
reg [6:0] 			Step;
/*************************************************************
Assign
*************************************************************/
assign Diff 	= iX - iY - Carry;
assign oZ	= Diff & 32'hFFFFFFFF;

always@(posedge iClk)
if(!iEnable)
begin
	Carry <= 1'b0;
end
else
begin
	if(Diff[32])
		Carry <= 1'b1;
	else
		Carry <= 1'b0;
end
/*************************************************************
Tao counter xac dinh cac step
1 du lieu 1024 bit can 32 step de thuc hien voi moi lan 32 bit
*************************************************************/
always@(posedge iClk)
if(!iEnable)
	Step <= 7'b0;
else
begin
	Step <= Step + 1'b1;
	if(Step==30)
		Step<=0;
end
/*************************************************************
Sub function
*************************************************************/
always@(posedge iClk)
if(!iEnable)
	oFinish		<= 	1'b0;
else
	if(Step<30)
		oFinish <= 1'b0;
	else
		oFinish <= 1'b1;
	
endmodule
