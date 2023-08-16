module Mod2048
#(parameter iW=2048, parameter oW=1024)
( 
	input 					iClk,
	input					iEnable,
	input					iLoad,
	input 		[iW-1:0] 	iX,
	input 		[iW-1:0] 	iY,
	output	reg				oDataValid,
	output 		[oW-1:0]	oZ
);
localparam 	State_Initial 	= 1,
			State_CheckZero = 2,
			State_ShiftLeft = 3,
			State_Compare   = 4,
			State_ShiftRight= 5,
			State_Sub		= 6,
			State_Finish	= 7;
	
localparam	XEqualY = 2'b11, 
			XLessThanY	= 2'b10, 
			XLargerThanY = 2'b01;
/****************************************************
		Reg
****************************************************/						
reg		[10:0]		Length,Pos;			
reg					RegX_Enable,			
			        RegY_Enable,				
			        CheckZero_Enable,
			        Compare_Enable,
					Enable_XEqualY,
					RegX_OutputLoad,
					Down;
reg					ShiftLeft_Finish;					
reg		[1:0]		RegY_Mode;			
			
reg		[3:0]		State;

reg					Sub_Enable;
/****************************************************
		Wire
****************************************************/			
wire	[iW-1:0]	RegX_Data,RegX_Z;			
wire				RegX_Load;	
wire	[31:0]		RegX_ToX,
					RegX_FromX;
			
wire	[iW-1:0]	RegY_Data;			
wire				RegY_Load; 		
wire	[31:0]		RegY_ToY,		
					RegY_FromY;	
					
wire				CheckZero_Finish; 
wire	[31:0]      CheckZero_X,		
			        CheckZero_Y;	
wire 	[11:0]		CheckZero_Length;

wire	[31:0]      Compare_X,		
                    Compare_Y;		
wire	[1:0]		Compare_Mode;
		

wire	[31:0]		Sub_X,
					Sub_Y,
					Sub_Z;
				
wire				Sub_Finish;
					
/****************************************************
		Thanh ghi DataX
****************************************************/
assign RegX_Data	=	iX;
assign RegX_Load 	= 	iLoad;
//assign RegX_Enable	= 	iEnable;
assign RegX_ToX		=	(~Sub_Enable)?RegX_FromX:Sub_Z;
assign oZ			=  	RegX_Z;
ModShiftRegX2048    reg_data_X
(
		.iClk				(iClk),
		.iEnable			(RegX_Enable),
		.iLoad				(RegX_Load),
		.iOutputLoad		(RegX_OutputLoad),
		.iData				(RegX_Data),
		.iDataShiftReg		(RegX_ToX),
		.oDataShiftReg		(RegX_FromX),
		.oData				(RegX_Z)
);
/****************************************************
		Thanh ghi DataY
	iMode  = 1 : Dich phai 1 bit
	iMode  = 0 : Dich phai 32 bit 
	iMode  = 2 : Dich trai 1 bit
****************************************************/
assign RegY_Data	=	iY;
assign RegY_Load 	= 	iLoad;
//assign RegY_Enable 	= 	iEnable;
assign RegY_ToY		=	RegY_FromY;
ModShiftRegY2048	reg_data_Y
(
		.iClk				(iClk),
		.iEnable			(RegY_Enable),
		.iMode				(RegY_Mode),
		.iLoad				(RegY_Load),
		.iData				(RegY_Data),
		.iDataShiftReg		(RegY_ToY),
		.oDataShiftReg		(RegY_FromY)		
);										
/****************************************************
		Module CheckZero
****************************************************/
//assign CheckZero_Enable 	= 	iEnable;
assign CheckZero_X			=	RegX_FromX;
assign CheckZero_Y			=	RegY_FromY;
CheckZero2048	check_zero
( 
		.iClk			(iClk),
		.iEnable		(CheckZero_Enable),
	 	.iDataX			(CheckZero_X),	
	 	.iDataY			(CheckZero_Y),
		.oFinish		(CheckZero_Finish),
		.oLength		(CheckZero_Length)
);		

always@(posedge iClk)
	if(!iEnable)
	begin
		Length		<= 11'b0;
		Pos			<= 11'b0;
	end
	else
		if(CheckZero_Finish)
		begin
			Length		<= CheckZero_Length;
			Pos			<= CheckZero_Length+1;
		end
		else
			if(RegY_Mode==2)
				Length		<= Length - 1;
			else
			if(Down)
				Pos			<= Pos - 1;
always@(posedge iClk)
	if(RegY_Mode!=2)
		ShiftLeft_Finish	<=	0;
	else
		if(Length==2)
			ShiftLeft_Finish	<=	1;
		
/****************************************************
		Module Compare
****************************************************/
//assign Compare_Enable 	= 	iEnable;
assign Compare_X		=	RegX_FromX;
assign Compare_Y		=	RegY_FromY;			
Compare2048		compare
( 
		.iClk			(iClk),
		.iEnable		(Compare_Enable),
	 	.iDataX			(Compare_X),	
	 	.iDataY			(Compare_Y),	
		.oMode          (Compare_Mode)
);			

/****************************************************
		Module Sub
****************************************************/	
assign Sub_X = RegX_FromX;
assign Sub_Y = RegY_FromY;
Sub2048		sub
( 
		.iClk			(iClk),
		.iEnable		(Sub_Enable),
	 	.iX				(Sub_X),	
	 	.iY				(Sub_Y),	
		.oZ				(Sub_Z),		
		.oFinish 		(Sub_Finish)
);

/****************************************************
		Control Mod
****************************************************/			
always@(posedge iClk)
	if(!iEnable)
		State		<=	State_Initial;
	else
		case(State)
		State_Initial:
			begin
				if(iLoad)
					State		<=	State_CheckZero;
				else
					State		<=	State_Initial;
			end
		State_CheckZero:	
			begin
				if(CheckZero_Finish)	
					State		<=	State_ShiftLeft;
				else
					State		<=	State_CheckZero;
			end
		State_ShiftLeft:
			begin
				if(ShiftLeft_Finish)
					State		<=	State_Compare;
				else
					State		<=	State_ShiftLeft;
			end
		State_Compare:
			begin
				case(Compare_Mode)
					XEqualY:		State <= State_Sub;
					XLessThanY:		State <= State_ShiftRight;
					XLargerThanY: 	State <= State_Sub;
					default:		State <= State_Compare;
				endcase
			end
		State_ShiftRight:
			begin
				if(Pos==1)
					State <= State_Finish;
				else
					State	<=	State_Compare;
			end
		State_Sub:
			begin
				if(Sub_Finish)
					if(Enable_XEqualY)
						State <= State_Finish;
					else
						State <= State_ShiftRight;
				else
					State	<=	State_Sub;
			end
		State_Finish:
			begin
				State <= State_Initial;
			end
			
	endcase
always@(posedge iClk)
	if(~iEnable)
		Enable_XEqualY <= 1'b0;
	else
		if(Compare_Mode==XEqualY)
			Enable_XEqualY <= 1'b1;
		else
			Enable_XEqualY <= Enable_XEqualY;

always@(*)
	case(State)
	State_Initial:
		begin
			RegX_Enable			=	1'b0;
			RegY_Enable			=	1'b0;
			RegY_Mode			=	2'b0;
			CheckZero_Enable	=	1'b0;
			Compare_Enable		=	1'b0;
			Sub_Enable			=	1'b0;
			oDataValid			=	1'b0;
			RegX_OutputLoad		=	1'b0;
			Down				=	1'b0;
		end
	State_CheckZero:	
		if(~CheckZero_Finish)
		begin
			RegX_Enable			=	1'b1;
			RegY_Enable			=	1'b1;
			CheckZero_Enable	=	1'b1;			
		end
		else
		begin
			RegX_Enable			=	1'b0;
			RegY_Enable			=	1'b0;		
		end		
	State_ShiftLeft:
		begin
			RegY_Enable			=	1'b1;
			RegY_Mode			=	2'b10;
			CheckZero_Enable	=	1'b0;				
		end
	State_Compare:
		if(Compare_Mode==0)
		begin
			RegX_Enable			=	1'b1;
			RegY_Enable			=	1'b1;
			RegY_Mode			=	2'b0;
			Sub_Enable			=	1'b0;
			Compare_Enable		=	1'b1;
			Down				=	1'b0;			
		end
		else
		begin
			RegX_Enable			=	1'b0;
			RegY_Enable			=	1'b0;
			RegY_Mode			=	2'b0;
			Sub_Enable			=	1'b0;
			Compare_Enable		=	1'b1;
			Down				=	1'b0;			
		end		
	State_ShiftRight:
		begin
			RegX_Enable			=	1'b0;
			RegY_Enable			=	1'b1;
			RegY_Mode			=	2'b1;
			Sub_Enable			=	1'b0;
			Compare_Enable		=	1'b0;
			Down				=	1'b1;
		end
	State_Sub:
		begin
			RegX_Enable			=	1'b1;
			RegY_Enable			=	1'b1;
			RegY_Mode			=	2'b0;		
			Sub_Enable			=	1'b1;
			Compare_Enable		=	1'b0;			
		end
	State_Finish:
		begin
			RegX_Enable			=	1'b0;
			RegY_Enable			=	1'b0;
			RegY_Mode			=	2'b0;
			CheckZero_Enable	=	1'b0;
			Compare_Enable		=	1'b0;
			Sub_Enable			=	1'b0;		
			oDataValid			=	1'b1;
			RegX_OutputLoad		=	1'b1;
			Down				=	1'b0;			
		end
		
	endcase






endmodule				
