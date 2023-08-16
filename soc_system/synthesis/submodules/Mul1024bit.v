module Mul1024bit 
#(parameter iW=1024, parameter oW=2048)
( 
	input 						iClk,
	input						iEnable,
	input						iLoad,
	input 			[iW-1:0] 	iX,
	input 			[iW-1:0] 	iY,
	//output						oFinish,
	output						oDataValid,
	output 	 	[oW-1:0]	oZ
);
reg [1023:0] BuffRegX,
			 BuffRegY;
reg [1023:0] BuffRegZ;
			 
reg [2047:0] BuffRegOutput;
wire EnableSignOutput;
wire			SignZ;
reg			SignX,
			SignY;
wire			[31:0]		X,Y,Z;
wire  [63:0]  AbsXMultAbsY;
wire	  [63:0]  Val;
wire  [31:0]  Result;
reg  [31:0]  Carry;
wire			[31:0]		AbsX,AbsY,PreZ,AbsZ;
wire  	EnableAdder,
		ControlMuxZ,
		ControlMuxY,
		ControlMuxZOutput,
		FinishAbsX,
		FinishAbsZ,
		EnableShiftRegInputX,		  
		EnableShiftRegInputY,		  
		EnableShiftRegBuffZ,		  
		EnableShiftRegOutputZ,	  
		EnableAbs,		  
		LoadOutput;	  
wire [31:0]	FromMuxZToShiftRegBuffZ,
			FromMuxYToShiftRegInputY,
			FromMuxZOutputToShiftRegOutputZ; 
	  
	  
	  
//Check dau 2 so dau vao
assign 	SignZ 		= 		SignX | SignY;				
//Khi iLoad = 1 thi lay du lieu 512 bit ngo vao va check dau cua 2 so vao
always@(posedge iClk)
	if(!iEnable)//Khi iEnable = 0 thi reset cac gia tri
		begin
			SignX		<= 	1'b0;
			SignY		<=	1'b0;	
		end
	else
		if(iLoad)//Khi iLoad = 1 thi lay du lieu 512 bit ngo vao
			begin
				SignX		<= 	iX[1023];
				SignY		<=	iY[1023];					
			end
		else// X,Y,SignZ giu nguyen gia tri
			begin
				SignX		<= 	SignX;
				SignY		<=	SignY;
			end

/*
ShiftRegInput1024 	shift_reg_input_X	(
							.iClk				(iClk),
							.iEnable			(EnableShiftRegInputX),
							.iLoad				(iLoad),
							.iData				(iX),
							.iDataShiftReg		(AbsX),
							.oDataShiftReg		(X)
);
*/
always@(posedge iClk)
	if(iLoad)
		BuffRegX	<=	iX;
	else
		if(EnableShiftRegInputX)
			begin
				BuffRegX[991:0]   <= BuffRegX[1023:32];
				BuffRegX[1023:992]<= AbsX;
			end
assign X 		= 		BuffRegX[31:0];

/*
ShiftRegInput1024 	shift_reg_input_Y	(
							.iClk				(iClk),
							.iEnable			(EnableShiftRegInputY),
							.iLoad				(iLoad),
							.iData				(iY),
							.iDataShiftReg		(FromMuxYToShiftRegInputY),
							.oDataShiftReg		(Y)
);*/

always@(posedge iClk)
	if(iLoad)
		BuffRegY	<=	iY;
	else
		if(EnableShiftRegInputY)
			begin
				BuffRegY[991:0]   <= BuffRegY[1023:32];
				BuffRegY[1023:992]<= FromMuxYToShiftRegInputY;			
			end
assign Y 		= 		BuffRegY[31:0];	
/*
ShiftRegBuffer1024 	shift_reg_buff_Z	(
							.iClk				(iClk),
							.iEnable			(EnableShiftRegBuffZ),
							.iDataShiftReg		(FromMuxZToShiftRegBuffZ),
							.oDataShiftReg		(Z)
);	
*/
always@(posedge iClk)
	if(EnableShiftRegBuffZ)
		begin
			BuffRegZ[1023:32]   <= BuffRegZ[991:0];
			BuffRegZ[31:0]<= FromMuxZToShiftRegBuffZ;
		end
	else
		begin
			BuffRegZ		<=	1024'b0;
		end
assign Z 		= 		BuffRegZ[1023:992];	
/*
ShiftRegOutput2048 	shift_reg_output_Z	(
							.iClk				(iClk),
							.iEnable			(EnableShiftRegOutputZ),
							.iLoadOutput		(LoadOutput),
							.iDataShiftReg		(FromMuxZOutputToShiftRegOutputZ),
							.oDataShiftReg		(oZ),
							.oData				(PreZ)
);	
*/
always@(posedge iClk)
	if(!LoadOutput)
		if(EnableShiftRegOutputZ)
			begin
				BuffRegOutput[2015:0]   <= BuffRegOutput[2047:32];
				BuffRegOutput[2047:2016]<= FromMuxZOutputToShiftRegOutputZ;
			end
assign PreZ 		= 		BuffRegOutput[31:0];	
assign oZ			=		(LoadOutput)?BuffRegOutput:2048'b0;

Invert1024 invertX
(  
				.iClk(iClk),
				.iEnable(EnableAbs),
				.iSign(SignX),
				.iData(X),
				.oFinish(FinishAbsX),
				.oData(AbsX)	
);

Invert1024 invertY
(  
				.iClk(iClk),
				.iEnable(EnableAbs),
				.iSign(SignY),
				.iData(Y),
				.oFinish(),
				.oData(AbsY)	
);

Invert2048 invertZ
(  
				.iClk(iClk),
				.iEnable(EnableSignOutput),
				.iSign(SignZ),
				.iData(PreZ),
				.oFinish(FinishAbsZ),
				.oData(AbsZ)	
);

//phan thuc hien nhan, khoi combine logic
/*
always@(*)
if(!EnableAdder)
	begin
		Val = 64'b0;	
		Carry	= Val[63:32];
	end
else
	begin
			Val = AbsXMultAbsY +(Z+Carry);
			Carry	= Val[63:32];
	end
*/
always@(posedge iClk)
if(!EnableAdder)
	Carry <= 32'b0;
else
	Carry <=Val[63:32]; 
	
assign Val = (EnableAdder)?	AbsXMultAbsY +(Z+Carry):64'b0;	
//assign Carry	= Val[63:32];		
assign Result 	= Val[31:0];
assign	AbsXMultAbsY = X * Y;

//Mux truoc khi vao ShiftRegBuffZ
assign  FromMuxZToShiftRegBuffZ = (ControlMuxZ)?Carry:Result;
//Mux truoc khi vao ShiftRegInputY
assign	FromMuxYToShiftRegInputY = (ControlMuxY)?AbsY:Y;
//Mux truoc khi vao ShiftRegOutputZ
assign FromMuxZOutputToShiftRegOutputZ = (ControlMuxZOutput)?AbsZ:Z;
ControlMul1024 control_mul 
(
	.iClk						(iClk),
	.iEnable					(iEnable),	
    .iLoad						(iLoad),	
    .iFinishAbsX				(FinishAbsX),
	.iFinishAbsZ				(FinishAbsZ),
	.oControlMuxY				(ControlMuxY),	
	.oControlMuxZ				(ControlMuxZ),
	.oControlMuxZOutput			(ControlMuxZOutput),
	.oEnableAdder				(EnableAdder),	
	.oEnableShiftRegInputX		(EnableShiftRegInputX),	
	.oEnableShiftRegInputY		(EnableShiftRegInputY),	
	.oEnableShiftRegBuffZ		(EnableShiftRegBuffZ),	
	.oEnableShiftRegOutputZ		(EnableShiftRegOutputZ),	
	.oEnableAbs					(EnableAbs),
	.oEnableSignOutput			(EnableSignOutput),
	.oLoadOutput				(LoadOutput),	
	.oDataValid					(oDataValid)	
);		
		
		
		
endmodule	
	







