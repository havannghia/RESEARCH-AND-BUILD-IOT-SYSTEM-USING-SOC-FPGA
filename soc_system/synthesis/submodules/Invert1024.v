module Invert1024 
#(parameter iW=32, parameter oW=32)
( 
	input 						iClk,
	input						iEnable,
	input						iSign,
	input 			[iW-1:0] 	iData,
	output						oFinish,
	output 	 reg	[oW-1:0]	oData
);
reg [6:0] Step;
reg		  CheckOne;
wire [31:0] Temp;
always@(posedge iClk)
if(!iEnable)
	Step <= 7'b0;
else
	if(Step<32)
		Step <= Step + 1'b1;
	else
		Step <= Step;

assign oFinish = (Step==31)? 1'b1 : 1'b0;	
assign Temp = ~iData + 1;
always@(*)	
if(!iEnable)
begin
	CheckOne 		=		1'b0;
	oData				=	32'b0;
end
else
if(iSign)
	if(iData==32'b0)
		oData		=		32'b0;
	else
		if(CheckOne)
			oData	=		~iData;
		else
			begin
				oData	=		Temp;
				CheckOne=		1'b1;
			end
else
	oData = iData;
endmodule
