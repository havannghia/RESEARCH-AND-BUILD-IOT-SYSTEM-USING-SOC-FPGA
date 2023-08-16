module ModPower1024
#(parameter iW=1024, parameter oW=1024)
( 
	input 					iClk,
	input					iEnable,
	input					iLoad,
	input 		[iW-1:0] 	iX,
	input 		[10:0] 		iTwoexp,
	output					oDataValid,
	output 		[oW-1:0]	oZ
);

wire [10:0] r;
wire [5:0] b;
wire [31:0] temp,temp_1;
reg [1:0] Count;
reg [31:0]	RegBuffX [31:0];	
assign b = iTwoexp>>5;
assign r = iTwoexp - (b<<5);

assign temp = 1<<r;
assign temp_1 = temp - 1;
/****************************************************
		Reg X
****************************************************/

always@(posedge iClk)
	if(iLoad)
		begin
			RegBuffX[0]  <= iX[31:0]	;
			RegBuffX[1]  <= iX[63:32]	;
			RegBuffX[2]  <= iX[95:64]	;
			RegBuffX[3]  <= iX[127:96];
			RegBuffX[4]  <= iX[159:128];
			RegBuffX[5]  <= iX[191:160];
			RegBuffX[6]  <= iX[223:192];
			RegBuffX[7]  <= iX[255:224];
			RegBuffX[8]  <= iX[287:256];
			RegBuffX[9]  <= iX[319:288];
			RegBuffX[10] <= iX[351:320];
			RegBuffX[11] <= iX[383:352];
			RegBuffX[12] <= iX[415:384];
			RegBuffX[13] <= iX[447:416];
			RegBuffX[14] <= iX[479:448];
			RegBuffX[15] <= iX[511:480];
			
			RegBuffX[16] <= iX[543	:512];
			RegBuffX[17] <= iX[575	:544];
			RegBuffX[18] <= iX[607	:576];
			RegBuffX[19] <= iX[639	:608];
			RegBuffX[20] <= iX[671	:640];
			RegBuffX[21] <= iX[703	:672];
			RegBuffX[22] <= iX[735	:704];
			RegBuffX[23] <= iX[767	:736];
			RegBuffX[24] <= iX[799	:768];
			RegBuffX[25] <= iX[831	:800];
			RegBuffX[26] <= iX[863	:832];
			RegBuffX[27] <= iX[895	:864];
			RegBuffX[28] <= iX[927	:896];
			RegBuffX[29] <= iX[959	:928];
			RegBuffX[30] <= iX[991	:960];
			RegBuffX[31] <= iX[1023 :992];
						
		end
	else
		if(iEnable)			
				RegBuffX[b] <= RegBuffX[b]&temp_1;
				
				
				
assign oZ[31:0]				= 		(oDataValid==1 && b>=0)?RegBuffX[0] 			:32'b0; 			
assign oZ[63:32]			= 		(oDataValid==1 && b>=1)?RegBuffX[1] 		:32'b0; 			
assign oZ[95:64]			= 		(oDataValid==1 && b>=2)?RegBuffX[2] 		:32'b0; 			
assign oZ[127:96]			= 		(oDataValid==1 && b>=3)?RegBuffX[3] 			:32'b0; 			
assign oZ[159:128]			= 		(oDataValid==1 && b>=4)?RegBuffX[4] 			:32'b0;	
assign oZ[191:160]			= 		(oDataValid==1 && b>=5)?RegBuffX[5] 			:32'b0;	
assign oZ[223:192]			= 		(oDataValid==1 && b>=6)?RegBuffX[6] 			:32'b0;	
assign oZ[255:224]			= 		(oDataValid==1 && b>=7)?RegBuffX[7] 			:32'b0;	
assign oZ[287:256]			= 		(oDataValid==1 && b>=8)?RegBuffX[8] 			:32'b0;	
assign oZ[319:288]			= 		(oDataValid==1 && b>=9)?RegBuffX[9] 			:32'b0;	
assign oZ[351:320]			= 		(oDataValid==1 && b>=10)?RegBuffX[10]			:32'b0;
assign oZ[383:352]			= 		(oDataValid==1 && b>=11)?RegBuffX[11]			:32'b0;
assign oZ[415:384]			= 		(oDataValid==1 && b>=12)?RegBuffX[12]			:32'b0;
assign oZ[447:416]			= 		(oDataValid==1 && b>=13)?RegBuffX[13]			:32'b0;
assign oZ[479:448]			= 		(oDataValid==1 && b>=14)?RegBuffX[14]			:32'b0;
assign oZ[511:480]			= 		(oDataValid==1 && b>=15)?RegBuffX[15]			:32'b0;

assign	oZ[543	:512]		=		(oDataValid==1 && b>=16)?RegBuffX[16]			:32'b0; 
assign  oZ[575	:544]   	=       (oDataValid==1 && b>=17)?RegBuffX[17]			:32'b0; 	
assign  oZ[607	:576]   	=       (oDataValid==1 && b>=18)?RegBuffX[18]			:32'b0; 	
assign  oZ[639	:608]   	=       (oDataValid==1 && b>=19)?RegBuffX[19]			:32'b0; 
assign  oZ[671	:640]   	=       (oDataValid==1 && b>=20)?RegBuffX[20]			:32'b0;	
assign  oZ[703	:672]   	=       (oDataValid==1 && b>=21)?RegBuffX[21]			:32'b0;	
assign  oZ[735	:704]   	=       (oDataValid==1 && b>=22)?RegBuffX[22]			:32'b0;	
assign  oZ[767	:736]   	=       (oDataValid==1 && b>=23)?RegBuffX[23]			:32'b0;	
assign  oZ[799	:768]   	=       (oDataValid==1 && b>=24)?RegBuffX[24]			:32'b0;	
assign  oZ[831	:800]   	=       (oDataValid==1 && b>=25)?RegBuffX[25]			:32'b0;	
assign  oZ[863	:832]   	=       (oDataValid==1 && b>=26)?RegBuffX[26]			:32'b0;
assign  oZ[895	:864]   	=       (oDataValid==1 && b>=27)?RegBuffX[27]			:32'b0;
assign  oZ[927	:896]   	=       (oDataValid==1 && b>=28)?RegBuffX[28]			:32'b0;
assign  oZ[959	:928]   	=       (oDataValid==1 && b>=29)?RegBuffX[29]			:32'b0;
assign  oZ[991	:960]   	=       (oDataValid==1 && b>=30)?RegBuffX[30]			:32'b0;
assign  oZ[1023 :992]   	=       (oDataValid==1 && b>=31)?RegBuffX[31]			:32'b0;

always@(posedge iClk)
	if(~iEnable)
		Count <= 0;
	else
		Count <= Count + 1;
assign 	oDataValid = (iEnable==1 && iLoad ==0 && Count ==2)? 1 : 0;

endmodule			

			
			
		


























