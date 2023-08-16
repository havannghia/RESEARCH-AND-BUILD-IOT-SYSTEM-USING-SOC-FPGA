module MonPro1024
#(parameter iW=1024, parameter oW=1024)
( 
	input 					iClk,
	input					iEnable,
	input					iLoad,
	input 		[iW-1:0] 	iX,
	input 		[iW-1:0] 	iY,
	input 		[iW-1:0] 	iN,
	input 		[iW-1:0] 	iN0,
	output	reg				oDataValid,
	output 		[oW-1:0]	oZ
);
/*
integer data_file_out_X;
integer data_file_out_Y;
integer data_file_out_N;
integer data_file_out_N0;
integer data_file_out_T;
integer data_file_out_runT;
integer data_file_out_runT1;
integer data_file_out_T1;
integer data_file_out_Z;
integer data_file_out_T_Val1;
integer data_file_out_T_Val2;
*/
/****************************************************
		Parameter
****************************************************/
localparam State_Initial 			= 0,
		  State_Mul					= 1,
		  State_M 					= 2,
		  State_MulM 				= 3,
		  State_AddCarry			= 4,
		  State_ShiftT				= 5,
		  State_Compare				= 6,
		  State_Sub					= 7,
		  State_Temp				= 8;
localparam 	YEqualX	   = 2'b11,
			YLessThanX = 2'b01,
			XLessThanY = 2'b10 ;
reg	[3:0]	State;
reg [5:0] NextState_Compare_Count;
wire	  NextState_Compare;
wire NextState_AddCarry;
/****************************************************
		wire/reg cua Reg X
****************************************************/
reg [iW-1:0] 	X;
wire			RegBuffX_Load;
/****************************************************
		wire/reg cua Reg Y
****************************************************/
reg [iW-1:0] 	Y;
wire			RegBuffY_Load;
/****************************************************
		wire/reg cua Reg N
****************************************************/
reg [iW-1:0] 	N;
wire			RegBuffN_Load;
wire [31:0]		FromN,
				ToN;
reg				RegBuffN_Enable;
/****************************************************
		wire/reg cua Reg N0
****************************************************/
reg [iW-1:0] 	N0;
wire			RegBuffN0_Load;
wire [31:0]		FromN0;
/****************************************************
		wire/reg cua Reg T
****************************************************/
reg [iW-1:0] 	T,T1;
reg [1:0]   	RegBuffT_MuxT,RegBuffT1_MuxT;
wire			RegBuffT_Load;
wire [31:0]		FromT,FromT1,
				ToT,ToT1;
reg				RegBuffT_Enable,RegBuffT1_Enable;
/****************************************************
		wire/reg cua Reg Mul
****************************************************/
reg 			Mul1024bit_Enable,
				Mul1024bit_Load;
wire [1023:0]	Mul1024bit_X,
				Mul1024bit_Y;
wire			Mul1024bit_DataValid;
wire			Mul1024bit_Load1;
wire [2047:0]	Mul1024bit_T;
reg  [1:0]		Mul1024bit_Count;
/****************************************************
		wire/reg cua M
****************************************************/
wire [31:0] FromM;
reg	 [31:0] M;
reg			M_Enable;
/****************************************************
		wire/reg cua Val1
****************************************************/
wire [63:0] Val1;
reg  [31:0] Carry;
reg	 [5:0] Val1_Count;
reg			Val1_EnableCarry;
reg			Val1_Enable;
wire   [31:0] Val1_ToT;
/****************************************************
		wire/reg cua Add
****************************************************/
reg 	Add_Enable,
		Add_Count;
wire [31:0] Add_X,
			Add_Y;
wire [31:0] Add_Z;
wire		Add_Finish;
/****************************************************
		wire/reg cua Temp
****************************************************/
wire [31:0] ToTemp;
reg [2047:0] Temp;
reg 			RegBuffTemp_Enable;
/****************************************************
		wire/reg cua Compare
****************************************************/
wire [31:0] Compare_X,
			Compare_Y;
reg 		Compare_Enable;
wire [1:0]	Compare_Mode;
/****************************************************
		wire/reg cua Sub
****************************************************/	
wire [31:0] Sub_X,
			Sub_Y,
			Sub_Z;
wire 		Sub_Finish;
reg			Sub_Enable;
/*
initial
begin
	data_file_out_X			= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_X.txt","w");//xuat du lieu ra file.txt
	data_file_out_Y			= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_Y.txt","w");//xuat du lieu ra file.txt
	data_file_out_N			= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_N.txt","w");//xuat du lieu ra file.txt
	data_file_out_N0		= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_N0.txt","w");//xuat du lieu ra file.txt
	data_file_out_T			= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_T.txt","w");//xuat du lieu ra file.txt
	data_file_out_runT		= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_runT.txt","w");//xuat du lieu ra file.txt
    data_file_out_runT1		= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_runT1.txt","w");
	data_file_out_T1		= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_T1.txt","w");
	data_file_out_Z			= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_Z.txt","w");
	data_file_out_T_Val1	= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_T_Val1.txt","w");
	data_file_out_T_Val2	= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonPro1024_T_Val2.txt","w");

end

always@(posedge iClk)
 if (iLoad)
	$fdisplay(data_file_out_X, "%h\n",iX);
	
always@(posedge iClk)
 if (iLoad)
	$fdisplay(data_file_out_Y, "%h\n",iY);

always@(posedge iClk)
 if (iLoad)
	$fdisplay(data_file_out_N, "%h\n",iN);
	
always@(posedge iClk)
 if (iLoad)
	$fdisplay(data_file_out_N0, "%h\n",iN0);
	
always@(posedge iClk)
 if (Mul1024bit_DataValid)
	$fdisplay(data_file_out_T, "%h\n",Mul1024bit_T);

always@(posedge iClk)
 if (Val1_Enable)
	$fdisplay(data_file_out_T_Val1, "%h\n",T);

always@(posedge iClk)
 if (RegBuffT1_Enable)
	$fdisplay(data_file_out_T_Val2, "%h\n",T1);
	
always@(posedge iClk)
 if (State==State_M)
	$fdisplay(data_file_out_runT, "%h\n",T);
	
always@(posedge iClk)
 if (State==State_M)
	$fdisplay(data_file_out_runT1, "%h\n",T1);
*/
/****************************************************
		Reg X
****************************************************/
assign RegBuffX_Load = iLoad;
always@(posedge iClk)
	if(RegBuffX_Load)
		X	<=	iX;

/****************************************************
		Reg X
****************************************************/
assign RegBuffY_Load = iLoad;
always@(posedge iClk)
	if(RegBuffY_Load)
		Y	<=	iY;
/****************************************************
		Reg N
****************************************************/
assign RegBuffN_Load = iLoad;
assign ToN = FromN;
always@(posedge iClk)
	if(RegBuffN_Load)
		N	<=	iN;
	else
	if(RegBuffN_Enable)		
		begin
			N[991:0]   <= N[1023:32];
			N[1023:992] <= ToN;		
		end
assign FromN 		= 		N[31:0];
/****************************************************
		Reg N0
****************************************************/
assign RegBuffN0_Load = iLoad;
always@(posedge iClk)
	if(RegBuffN0_Load)
		N0	<=	iN0;

assign FromN0 		= 		N0[31:0];		
/****************************************************
		Reg T
****************************************************/
assign RegBuffT_Load = Mul1024bit_DataValid;
assign ToT 			 = (RegBuffT_MuxT==1)?Val1_ToT:
					  ((RegBuffT_MuxT==0)?FromT	  :
					  ((RegBuffT_MuxT==3)?Sub_Z	  :
										  FromT1)) ;
assign ToT1 		 = (RegBuffT1_MuxT==1)?Add_Z:
					  ((RegBuffT1_MuxT==0)?FromT1 :
										   32'b0) ;
always@(posedge iClk)
	if(RegBuffT_Load)
		T	<=	Mul1024bit_T[1023:0];
	else
		if(RegBuffT_Enable)
			begin
				T[991:0]   <= T[1023:32];
				T[1023:992] <= ToT;			
			end
assign FromT = T[31:0];	
assign oZ	= (oDataValid)?T:0;
always@(posedge iClk)
	if(RegBuffT_Load)
		T1	<=	Mul1024bit_T[2047:1024];
	else
		if(RegBuffT1_Enable)
			begin
				T1[991:0]   <= T1[1023:32];
				T1[1023:992] <= ToT1;				
			end
assign FromT1 = T1[31:0];
/****************************************************
		Reg Temp
****************************************************/
assign ToTemp = FromT;
always@(posedge iClk)
	if(RegBuffTemp_Enable)		
		begin
			Temp[2015:0]   <= Temp[2047:32];
			Temp[2047:2016]<= ToTemp;		
		end
/****************************************************
		Khoi Mul
****************************************************/
assign Mul1024bit_X = X;
assign Mul1024bit_Y = Y;
always@(posedge iClk)
	if(~Mul1024bit_Load)
	begin
		Mul1024bit_Count <= 1'b1;
	end
	else
		if(Mul1024bit_Count)
			Mul1024bit_Count <= 1'b0;

assign 	Mul1024bit_Load1 = (Mul1024bit_Count)?Mul1024bit_Load:1'b0;
Mul1024bit 	mul_1024bit
( 
		.iClk			(iClk),
		.iEnable		(Mul1024bit_Enable),
		.iLoad			(Mul1024bit_Load1),
	 	.iX				(Mul1024bit_X),
	 	.iY				(Mul1024bit_Y),
		.oDataValid		(Mul1024bit_DataValid),
		.oZ				(Mul1024bit_T)
);

/****************************************************
		Khoi tinh M
****************************************************/
assign FromM = FromT*FromN0;

always@(posedge iClk)
	if(M_Enable)
		M	<=	FromM;

/****************************************************
		Khoi tinh Val1
****************************************************/
always@(posedge iClk)
	if(~Val1_Enable)
		Val1_Count <= 0;
	else
		if(Val1_Count<31)
			Val1_Count <= Val1_Count +1;
		else
			Val1_Count <= 0;

assign NextState_AddCarry = (Val1_Count==31)?1'b1:1'b0;
assign Val1 = FromT+(M*FromN)+Carry;
assign Val1_ToT = Val1[31:0];
always@(posedge iClk)	
	if(Val1_EnableCarry)
		Carry	<=	Val1[63:32];
	else
		Carry	<= 	32'b0;
/****************************************************
		Khoi tinh Add
****************************************************/
always@(posedge iClk)
	if(~Add_Enable)
	begin
		Add_Count <= 1'b1;
	end
	else
		if(Add_Count)
			Add_Count <= 1'b0;
		else
			Add_Count <= Add_Count;
			
assign Add_Y = (Add_Count)?Carry:32'b0;
assign Add_X = FromT1;

Add1024		add_1024
( 
		.iClk			(iClk),
		.iEnable		(Add_Enable),
	 	.iX				(Add_X),	
	 	.iY				(Add_Y),	
		.oZ				(Add_Z),		
		.oFinish		(Add_Finish) 
);
/****************************************************
		Module Compare
****************************************************/
assign Compare_X		=	FromT;
assign Compare_Y		=	FromN;			
Compare1024		compare_1024
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
assign Sub_X = FromT;
assign Sub_Y = FromN;
Sub1024		sub_1024
( 
		.iClk			(iClk),
		.iEnable		(Sub_Enable),
	 	.iX				(Sub_X),	
	 	.iY				(Sub_Y),	
		.oZ				(Sub_Z),		
		.oFinish 		(Sub_Finish)
);	
/****************************************************
		Control MonPro
****************************************************/

always@(posedge iClk)
	if(!iEnable)
		NextState_Compare_Count <= 0;
	else
	if(State==State_ShiftT)
		if(NextState_Compare_Count<34)
			NextState_Compare_Count <= NextState_Compare_Count+1;
		else
			NextState_Compare_Count <= 0;
assign NextState_Compare = (NextState_Compare_Count==32)?1:0;
	
always@(posedge iClk)
	if(~iEnable)
		State <= State_Initial;
	else
		case(State)
		State_Initial:
			begin
				if(iLoad)
					State <= State_Mul;
				else
					State <= State_Initial;
			end
        State_Mul:
			begin
				if(Mul1024bit_DataValid)
					State <= State_M;
				else
					State <= State_Mul;	
			end
		State_M:
			begin
				if(NextState_Compare)
					State <= State_Compare;
				else
					State <= State_MulM;			
			end
		State_MulM:
			begin
				if(NextState_AddCarry)
					State <= State_AddCarry;
				else
					State <= State_MulM;
			end
		State_AddCarry:
			begin
				if(Add_Finish)
					State <= State_ShiftT;
				else
					State <= State_AddCarry;
			end
		State_ShiftT:
			begin
				State <= State_M;
			end
		State_Compare:
			begin
				case(Compare_Mode)
				YEqualX:	State <= State_Sub;	  
				YLessThanX: State <= State_Sub;	
				XLessThanY: State <= State_Temp;
				default: State <= State_Compare;
				endcase
			end
		State_Sub:
			begin
				if(Sub_Finish)
					State <= State_Temp;
			end
		State_Temp:
			begin
				State <= State_Initial;
			end
		
		endcase

always@(*)
	case(State)
	State_Initial:
		begin
			Val1_Enable			=	1'b0;
			RegBuffT_Enable		=	1'b0;
			RegBuffT_MuxT		=	2'b0;
			Val1_EnableCarry	= 	1'b0;
			Mul1024bit_Enable	=	1'b0;
			Mul1024bit_Load		=	1'b0;
			oDataValid			=	1'b0;
			RegBuffN_Enable		=	1'b0;
			RegBuffT1_MuxT		=	2'b0;
			Add_Enable			=	1'b0;
			RegBuffTemp_Enable	=	1'b0;
			Compare_Enable		=	1'b0;
			Sub_Enable			=	1'b0;
		end
	State_Mul:
		begin
			Mul1024bit_Enable	=	1'b1;
			Mul1024bit_Load		=	1'b1;
			Add_Enable			=	1'b0;				
		end				
	State_M:
		begin
			RegBuffTemp_Enable	=	1'b0;
			RegBuffT_Enable		=	1'b0;
			Mul1024bit_Enable	=	1'b0;
			Mul1024bit_Load		=	1'b0;		
			M_Enable			=	1'b1;
			Add_Enable			=	1'b0;
			RegBuffT1_Enable	=	1'b0;			
			RegBuffT1_MuxT		=	2'b0;	
			Val1_EnableCarry	= 	1'b0;			
		end
	State_MulM:
		begin
			M_Enable			=	1'b0;
			Val1_Enable			=	1'b1;
			RegBuffT_Enable		=	1'b1;
			RegBuffT_MuxT		=	2'b1;
			Val1_EnableCarry	= 	1'b1;
			RegBuffN_Enable		=	1'b1;
			Add_Enable			=	1'b0;	
		end
	State_AddCarry:
		begin
			RegBuffN_Enable		=	1'b0;
			Val1_Enable			=	1'b0;
			RegBuffT_Enable		=	1'b0;
			RegBuffT_MuxT		=	2'b0;		
			Add_Enable			=	1'b1;
			RegBuffT1_Enable	=	1'b1;			
			RegBuffT1_MuxT		=	2'b1;
		end
	State_ShiftT:
		begin
			RegBuffN_Enable		=	1'b0;
			Val1_Enable			=	1'b0;		
			Add_Enable			=	1'b0;
			RegBuffT1_Enable	=	1'b1;			
			RegBuffT1_MuxT		=	2'b10;
			RegBuffT_Enable		=	1'b1;			
			RegBuffT_MuxT		=	2'b10;	
			RegBuffTemp_Enable	=	1'b1;			
		end		
	State_Compare:
		begin
			if(Compare_Mode==2'b00)
			begin
				Compare_Enable		=	1'b1;
				Val1_Enable			=	1'b0;
				RegBuffT_Enable		=	1'b1;
				RegBuffT_MuxT		=	2'b0;
				RegBuffN_Enable		=	1'b1;
				RegBuffT1_MuxT		=	2'b0;	
			end
			else
			begin
				Compare_Enable		=	1'b1;
				Val1_Enable			=	1'b0;
				RegBuffT_Enable		=	1'b0;
				RegBuffT_MuxT		=	2'b0;
				RegBuffN_Enable		=	1'b0;
				RegBuffT1_MuxT		=	2'b0;
			end
		end
	State_Sub:
		begin
			Sub_Enable			=	1'b1;
			Compare_Enable		=	1'b0;
			RegBuffT_Enable		=	1'b1;
			RegBuffN_Enable		=	1'b1;
			RegBuffT1_MuxT		=	2'b0;
			RegBuffT_MuxT		=	2'b11;
		end
	State_Temp:
		begin
			Val1_Enable			=	1'b0;
			RegBuffT_Enable		=	1'b0;
			RegBuffT_MuxT		=	2'b0;
			Val1_EnableCarry	= 	1'b0;
			Mul1024bit_Enable	=	1'b0;
			Mul1024bit_Load		=	1'b0;
			oDataValid			=	1'b1;
			RegBuffN_Enable		=	1'b0;
			RegBuffT1_MuxT		=	2'b0;
			Add_Enable			=	1'b0;
			RegBuffTemp_Enable	=	1'b0;
			Compare_Enable		=	1'b0;
			Sub_Enable			=	1'b0;
		
		end
	endcase


endmodule






















