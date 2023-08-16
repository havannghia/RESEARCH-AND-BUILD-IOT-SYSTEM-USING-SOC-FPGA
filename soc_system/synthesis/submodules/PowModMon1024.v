module PowModMon1024
#(parameter iW=1024, parameter oW=1024)
( 
	input 					iClk,
	input					iEnable,
	input					iLoad,
	input 		[iW-1:0] 	iA,
	input 		[iW-1:0] 	iB,
	input 		[iW-1:0] 	iN,
	output	reg				oDataValid,
	output 		[oW-1:0]	oZ
);
/*
integer data_file_out_A;
integer data_file_out_B;
integer data_file_out_N;
integer data_file_out_A1;
integer data_file_out_Z1;
integer data_file_out_N0;
integer data_file_out_N0_1;
integer data_file_out_Z1_MonPro;

*/
wire NextStateFinish;
wire [2047:0] A_Temp1;
/****************************************************
		wire/reg cua Reg A
****************************************************/
reg [iW-1:0] 	A;
wire			RegBuffA_Load;
/****************************************************
		wire/reg cua Reg B
****************************************************/
reg [iW-1:0] 	B;
wire			RegBuffB_Load;
wire 			FromB;
reg				RegBuffB_Enable;
/****************************************************
		wire/reg cua Reg N
****************************************************/
reg [iW-1:0] 	N;
wire			RegBuffN_Load;
/****************************************************
		wire/reg cua Reg N0
****************************************************/
reg [2047:0] 	N0;
reg				RegBuffN0_Enable;
wire			RegBuffN0_Load;
wire [31:0]		ToN0,
				FromN0;
/****************************************************
		wire/reg cua Reg Z1
****************************************************/
reg [iW-1:0] 	Z1;
wire			RegBuffZ1_Load;
/****************************************************
		wire/reg cua khoi Mod2048_1
****************************************************/
wire	[2047:0]	Mod2048_A_Temp1_1,
					Mod2048_N_1;
					
wire	[iW-1:0]	Mod2048_A1_1;
wire				Mod2048_Enable1_1,
					Mod2048_Load1_1,
					Mod2048_DataValid_1;

reg					Mod2048_Count_1,
					Mod2048_Count1_1;
					
reg					Mod2048_Load_1,
					Mod2048_Enable_1;

/****************************************************
		wire/reg cua khoi Mod2048_2
****************************************************/
wire	[2047:0]	Mod2048_R_2,
					Mod2048_N_2;
					
wire	[iW-1:0]	Mod2048_Z1_2;
					
wire				Mod2048_Enable1_2,
					Mod2048_Load1_2,
					Mod2048_DataValid_2;

reg					Mod2048_Count_2,
					Mod2048_Count1_2;
					
reg					Mod2048_Load_2,
					Mod2048_Enable_2;
/****************************************************
		wire/reg cua khoi MonModInverse
****************************************************/
reg				MonModInverse_Enable,
				MonModInverse_Load,
				MonModInverse_Count;
wire			MonModInverse_Load1,
				MonModInverse_DataValid;
wire [iW-1:0]	MonModInverse_N,
				MonModInverse_N0;
wire [10:0]		MonModInverse_Length;
wire 			MonModInverse_Enable1;
reg	 			MonModInverse_Count1;
/****************************************************
		wire/reg cua khoi Sub
****************************************************/
reg	[5:0]	Sub_Count;
wire		Sub_Finish;
reg			Sub_Enable;
wire [31:0]		FromR,
				Sub_X,
				Sub_Y,
				Sub_Z;
/****************************************************
		wire/reg cua khoi Control PowModMon
****************************************************/
localparam	State_Initial 		= 	0,
			State_Mode 			= 	1,
			State_Sub			=	2,
			State_GetBit 		= 	3,
			State_MonPro1		=	4,
			State_Delay			=	5,
			State_MonPro2		=	6,
			State_ShiftLeftOne	=	7,
			State_MonPro3		=	8,
			State_Finish		=	9;
/****************************************************
		wire/reg cua khoi GetBit
****************************************************/
wire		GetBit_Dis,
		Down;
reg		GetBit_Enable,
		Down1;	
/****************************************************
		wire/reg cua khoi MonPro
****************************************************/
wire [iW-1:0]	MonPro_X ,
                MonPro_Y ,	
                MonPro_N ,
                MonPro_N0,
				MonPro_Z;
wire			MonPro_DataValid,
				MonPro_Load1;

reg				MonPro_Load,
				MonPro_Count,
				MonPro_Enable;		
reg [10:0]	i;			
reg	[3:0]	State;
wire		Mod2048_DataValid;
reg 	MonModInverse_1,
		Mod2048_2,
		Mod2048_1;
		/*
initial
begin
	data_file_out_A		= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_PowModMon1024_A.txt","w");//xuat du lieu ra file.txt
	data_file_out_B		= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_PowModMon1024_B.txt","w");//xuat du lieu ra file.txt
	data_file_out_N		= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_PowModMon1024_N.txt","w");//xuat du lieu ra file.txt
	data_file_out_A1	= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_PowModMon1024_A1.txt","w");//xuat du lieu ra file.txt
    data_file_out_Z1	= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_PowModMon1024_Z1.txt","w");//xuat du lieu ra file.txt
	data_file_out_N0	= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_PowModMon1024_N0.txt","w");//xuat du lieu ra file.txt
	data_file_out_N0_1	= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_PowModMon1024_N0_1.txt","w");//xuat du lieu ra file.txt
	data_file_out_Z1_MonPro = $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_PowModMon1024_Z1_MonPro.txt","w");//xuat du lieu ra file.txt
end
always@(posedge iClk)
 if (RegBuffA_Load)
	$fdisplay(data_file_out_A, "%h\n",iA);

always@(posedge iClk)
 if (RegBuffB_Load)
	$fdisplay(data_file_out_B, "%h\n",iB);

always@(posedge iClk)
 if (RegBuffN_Load)
	$fdisplay(data_file_out_N, "%h\n",iN);

always@(posedge iClk)
 if (Mod2048_DataValid_1)
	$fdisplay(data_file_out_A1, "%h\n",Mod2048_A1_1);

always@(posedge iClk)
 if (Mod2048_DataValid_2)
	$fdisplay(data_file_out_Z1, "%h\n",Mod2048_Z1_2);
	
always@(posedge iClk)
 if (MonModInverse_DataValid)
	$fdisplay(data_file_out_N0, "%h\n",MonModInverse_N0);

always@(posedge iClk)
 if (Sub_Finish)
	$fdisplay(data_file_out_N0_1, "%h\n",{Sub_Z,N0>>32});
	
always@(posedge iClk)
 if (MonPro_DataValid)
	$fdisplay(data_file_out_Z1_MonPro, "%h\n",MonPro_Z);
*/	
/****************************************************
		Reg A
****************************************************/
assign RegBuffA_Load = iLoad;
always@(posedge iClk)
	if(RegBuffA_Load)
		A	<=	iA;
	else
		if(Mod2048_DataValid_1)
			A	<=	Mod2048_A1_1;
assign A_Temp1 = {A,1024'b0};
/****************************************************
		Reg B
****************************************************/
assign RegBuffB_Load = iLoad;
always@(posedge iClk)
	if(RegBuffB_Load)
		B	<=	iB;
	else
		if(RegBuffB_Enable)
			begin
				B[1023:1] <= B[1022:0];
				B[0]	  <= 1'b0;
			end
assign FromB = B[1023];
/****************************************************
		Reg N
****************************************************/
assign RegBuffN_Load = iLoad;
always@(posedge iClk)
	if(RegBuffN_Load)
		N	<=	iN;
		
/****************************************************
		Reg N0
****************************************************/
assign ToN0			  =	Sub_Z;
assign RegBuffN0_Load = MonModInverse_DataValid;
always@(posedge iClk)
	if(RegBuffN0_Load)
		N0	<=	{1024'b0,MonModInverse_N0};
	else
		if(RegBuffN0_Enable)
			begin
				N0[2015:0]   <= N0[2047:32];
				N0[2047:2016]<= ToN0;
			end
assign FromN0 		= 		N0[31:0];
/****************************************************
		Reg Z1
****************************************************/
assign RegBuffZ1_Load = Mod2048_DataValid_2;
always@(posedge iClk)
	if(RegBuffZ1_Load)
		Z1	<=	Mod2048_Z1_2;
	else
	if(MonPro_DataValid)
		Z1	<=	MonPro_Z;
assign	oZ	=	(oDataValid)?Z1:1024'b0;
/****************************************************
		Khoi Mod2048_1
****************************************************/			
assign 	Mod2048_A_Temp1_1 	=	A_Temp1;
assign 	Mod2048_N_1			=	{1024'b0,N};
always@(posedge iClk)
	if(~Mod2048_Load_1)
	begin
		Mod2048_Count_1 <= 1'b1;
	end
	else
		if(Mod2048_Count_1)
			Mod2048_Count_1 <= 1'b0;

assign 	Mod2048_Load1_1 = (Mod2048_Count_1)?Mod2048_Load_1:1'b0;

always@(posedge iClk)
	if(~iEnable)
		Mod2048_Count1_1	<=	1'b0;
	else
	if(Mod2048_DataValid_1)
		Mod2048_Count1_1	<=	1'b1;
assign	Mod2048_Enable1_1	=	(Mod2048_Count1_1)?1'b0:Mod2048_Enable_1;		
Mod2048 mod_A_temp1_with_n
( 
		.iClk			(iClk),
		.iEnable		(Mod2048_Enable1_1),
		.iLoad			(Mod2048_Load1_1),
	 	.iX				(Mod2048_A_Temp1_1),
	 	.iY				(Mod2048_N_1),
		.oDataValid		(Mod2048_DataValid_1),
		.oZ				(Mod2048_A1_1)
);
/****************************************************
		Khoi Mod2048_2
****************************************************/
assign 	Mod2048_R_2 		=	{1024'b1,1024'b0};
assign 	Mod2048_N_2			=	{1024'b0,N};	
always@(posedge iClk)
	if(~Mod2048_Load_2)
	begin
		Mod2048_Count_2 <= 1'b1;
	end
	else
		if(Mod2048_Count_2)
			Mod2048_Count_2 <= 1'b0;

assign 	Mod2048_Load1_2 = (Mod2048_Count_2)?Mod2048_Load_2:1'b0;
always@(posedge iClk)
	if(~iEnable)
		Mod2048_Count1_2	<=	1'b0;
	else
	if(Mod2048_DataValid_2)
		Mod2048_Count1_2	<=	1'b1;
assign	Mod2048_Enable1_2	=	(Mod2048_Count1_2)?1'b0:Mod2048_Enable_2;				
Mod2048 mod_R_with_n
( 
		.iClk			(iClk),
		.iEnable		(Mod2048_Enable1_2),
		.iLoad			(Mod2048_Load1_2),
	 	.iX				(Mod2048_R_2),
	 	.iY				(Mod2048_N_2),
		.oDataValid		(Mod2048_DataValid_2),
		.oZ				(Mod2048_Z1_2)
);
/****************************************************
		Khoi MonModInverse
****************************************************/
assign	MonModInverse_N		 =	N;
assign	MonModInverse_Length =	1024;
always@(posedge iClk)
	if(~MonModInverse_Load)
	begin
		MonModInverse_Count <= 1'b1;
	end
	else
		if(MonModInverse_Count)
			MonModInverse_Count <= 1'b0;

assign 	MonModInverse_Load1 = (MonModInverse_Count)?MonModInverse_Load:1'b0;


always@(posedge iClk)
	if(~iEnable)
		MonModInverse_Count1	<=	1'b0;
	else
	if(MonModInverse_DataValid)
		MonModInverse_Count1	<=	1'b1;
assign	MonModInverse_Enable1	=	(MonModInverse_Count1)?1'b0:MonModInverse_Enable;	

MonModInverse1024	mod_mon_inverse_1024
( 
		.iClk			(iClk),
		.iEnable			(MonModInverse_Enable1),
		.iLoad			(MonModInverse_Load1),
	 	.iX				(MonModInverse_N),
		.iLength			(MonModInverse_Length),
		.oDataValid		(MonModInverse_DataValid),
		.oZ				(MonModInverse_N0)
);

/****************************************************
		Module Sub
****************************************************/

always@(posedge iClk)
	if(~Sub_Enable)
		Sub_Count <= 6'b0;
	else
		Sub_Count <= Sub_Count + 1'b1;
assign FromR = (Sub_Count==32)?32'b1:32'b0;
assign Sub_X = FromR;
assign Sub_Y = FromN0;
Sub2048		sub_2048
( 
		.iClk			(iClk),
		.iEnable		(Sub_Enable),
	 	.iX				(Sub_X),	
	 	.iY				(Sub_Y),	
		.oZ				(Sub_Z),		
		.oFinish 		(Sub_Finish)
);	
/****************************************************
		Khoi GetBit
****************************************************/
assign	GetBit_Dis = (GetBit_Enable)? FromB:1'b0;				
assign 	Down = (GetBit_Enable)? ~FromB:1'b0;	
always@(posedge iClk)
	if(~iEnable)
		i	<=	1024;
	else
		if((Down==1) || (Down1 ==1))
			i <= i - 1;

assign	NextStateFinish	=	(i==1)?1'b1:1'b0;
/****************************************************
		Khoi MonPro
****************************************************/
always@(posedge iClk)
	if(~MonPro_Load)
	begin
		MonPro_Count <= 1'b1;
	end
	else
		if(MonPro_Count)
			MonPro_Count <= 1'b0;

assign 	MonPro_Load1 = (MonPro_Count)?MonPro_Load:1'b0;
assign 	MonPro_X 	= 	Z1	;
assign 	MonPro_Y	= 	(State == State_MonPro1)?Z1:
					   ((State == State_MonPro3)?1024'b1 :A)	;
assign 	MonPro_N	=	N	;
assign	MonPro_N0	=	N0	;
MonPro1024		mon_pro_1024
( 
		.iClk				(iClk),
		.iEnable			(MonPro_Enable),
		.iLoad				(MonPro_Load1),
	 	.iX					(MonPro_X),
	 	.iY					(MonPro_Y),
	 	.iN					(MonPro_N),
	 	.iN0				(MonPro_N0),
		.oDataValid			(MonPro_DataValid),
		.oZ					(MonPro_Z)
);



/****************************************************
		Khoi Control PowModMon
****************************************************/
always@(posedge iClk)
	if(~iEnable)
		Mod2048_1	<=	1'b0;
	else
		if(State!=State_Mode)
			Mod2048_1	<=	1'b0;
		else
			if(Mod2048_DataValid_1)
				Mod2048_1	<=	1'b1;
			else
				Mod2048_1	<=	Mod2048_1;
				
always@(posedge iClk)
	if(~iEnable)
		Mod2048_2	<=	1'b0;
	else
		if(State!=State_Mode)
			Mod2048_2	<=	1'b0;
		else
			if(Mod2048_DataValid_2)
				Mod2048_2	<=	1'b1;
			else
				Mod2048_2	<=	Mod2048_2;

always@(posedge iClk)
	if(~iEnable)
		MonModInverse_1	<=	1'b0;
	else
		if(State!=State_Mode)
			MonModInverse_1	<=	1'b0;
		else
			if(MonModInverse_DataValid)
				MonModInverse_1	<=	1'b1;
			else
				MonModInverse_1	<=	MonModInverse_1;
				
assign		Mod2048_DataValid = Mod2048_1&Mod2048_2&MonModInverse_1;

always@(posedge iClk)
if(~iEnable)
	State	<=	State_Initial;
else
	case(State)
	State_Initial:
		begin
			if(iLoad)
				State	<=	State_Mode;
			else
				State	<=	State_Initial;
		end
	State_Mode:
		begin
			if(Mod2048_DataValid)
				State	<=	State_Sub;
			else
				State	<=	State_Mode;
		end
	State_Sub:
		begin
			if(Sub_Finish)
				State	<=	State_GetBit;
			else
				State	<=	State_Sub;
		end
	State_GetBit:
		begin
			if(GetBit_Dis)
				State	<=	State_MonPro1;
			else
				State	<=	State_GetBit;
		end
	State_MonPro1:
		begin
			if(MonPro_DataValid)
				if(FromB)
					State	<=	State_Delay;
				else
					State	<=	State_ShiftLeftOne;
			else
				State	<=	State_MonPro1;
		end
	State_Delay:
		begin
			State	<=	State_MonPro2;
		end	
	State_MonPro2:
		begin
			if(MonPro_DataValid)
				State	<=	State_ShiftLeftOne;
			else
				State	<=	State_MonPro2;
		end
	State_ShiftLeftOne:
		begin
			if(NextStateFinish)
				State	<=	State_MonPro3;
			else
				State 	<=	State_MonPro1;
		end	
	State_MonPro3:
		begin
			if(MonPro_DataValid)
				State	<=	State_Finish;
			else
				State	<=	State_MonPro3;		
		end
	State_Finish:
		begin
			State	<=	State_Initial;
		end


	endcase
	
always@(*)
	case(State)
	State_Initial:
		begin
			Mod2048_Enable_1		=	1'b0;
			Mod2048_Load_1			=	1'b0;
			Mod2048_Enable_2		=	1'b0;
			Mod2048_Load_2			=	1'b0;
			MonModInverse_Enable	=	1'b0;
			MonModInverse_Load		=	1'b0;
			RegBuffN0_Enable		=	1'b0;
			Sub_Enable				=	1'b0;
			RegBuffB_Enable			=	1'b0;			
			GetBit_Enable			=	1'b0;
			MonPro_Enable			=	1'b0;
			MonPro_Load				=	1'b0;
			Down1					=	1'b0;
			oDataValid				=	1'b0;
		end
		
	State_Mode:
		begin
			Mod2048_Enable_1		=	1'b1;
			Mod2048_Load_1			=	1'b1;
			Mod2048_Enable_2		=	1'b1;
			Mod2048_Load_2			=	1'b1;
			MonModInverse_Enable	=	1'b1;
			MonModInverse_Load		=	1'b1;
		end

	State_Sub:
		begin
			Mod2048_Enable_1		=	1'b0;
			Mod2048_Load_1			=	1'b0;
			Mod2048_Enable_2		=	1'b0;
			Mod2048_Load_2			=	1'b0;
			MonModInverse_Enable	=	1'b0;
			MonModInverse_Load		=	1'b0;
			RegBuffN0_Enable		=	1'b1;			
			Sub_Enable				=	1'b1;
		end
		
	State_GetBit:
		begin
			if(~GetBit_Dis)
			begin
				RegBuffN0_Enable		=	1'b0;
				Sub_Enable				=	1'b0;
				RegBuffB_Enable			=	1'b1;
				GetBit_Enable			=	1'b1;	
			end
			else
			begin
				RegBuffB_Enable			=	1'b0;
			end
		end
		
	State_MonPro1:
		begin
			RegBuffB_Enable			=	1'b0;			
			GetBit_Enable			=	1'b0;
			MonPro_Enable			=	1'b1;
			MonPro_Load				=	1'b1;
			Down1					=	1'b0;
		end
		
	State_Delay:
		begin
			Mod2048_Enable_1		=	1'b0;
			Mod2048_Load_1			=	1'b0;
			Mod2048_Enable_2		=	1'b0;
			Mod2048_Load_2			=	1'b0;
			MonModInverse_Enable	=	1'b0;
			MonModInverse_Load		=	1'b0;
			RegBuffN0_Enable		=	1'b0;
			Sub_Enable				=	1'b0;
			RegBuffB_Enable			=	1'b0;			
			GetBit_Enable			=	1'b0;
			MonPro_Enable			=	1'b0;
			MonPro_Load				=	1'b0;		
		end
	State_MonPro2:
		begin
			MonPro_Enable			=	1'b1;
			MonPro_Load				=	1'b1;				
		end
		
	State_ShiftLeftOne:
		begin
			MonPro_Enable			=	1'b0;
			MonPro_Load				=	1'b0;
			Down1					=	1'b1;
			RegBuffB_Enable			=	1'b1;			
		end
	State_MonPro3:
		begin
			MonPro_Enable			=	1'b1;
			MonPro_Load				=	1'b1;
			Down1					=	1'b0;
			RegBuffB_Enable			=	1'b0;				
		end	
	State_Finish:
		begin
			Mod2048_Enable_1		=	1'b0;
			Mod2048_Load_1			=	1'b0;
			Mod2048_Enable_2		=	1'b0;
			Mod2048_Load_2			=	1'b0;
			MonModInverse_Enable	=	1'b0;
			MonModInverse_Load		=	1'b0;
			RegBuffN0_Enable		=	1'b0;
			Sub_Enable				=	1'b0;
			RegBuffB_Enable			=	1'b0;			
			GetBit_Enable			=	1'b0;
			MonPro_Enable			=	1'b0;
			MonPro_Load				=	1'b0;
			Down1					=	1'b0;			
			oDataValid				=	1'b1;				
		end
	default :
		begin
			Mod2048_Enable_1		=	1'b0;
			Mod2048_Load_1			=	1'b0;
			Mod2048_Enable_2		=	1'b0;
			Mod2048_Load_2			=	1'b0;
			MonModInverse_Enable	=	1'b0;
			MonModInverse_Load		=	1'b0;
			RegBuffN0_Enable		=	1'b0;
			Sub_Enable				=	1'b0;
			RegBuffB_Enable			=	1'b0;			
			GetBit_Enable			=	1'b0;
			MonPro_Enable			=	1'b0;
			MonPro_Load				=	1'b0;
			Down1					=	1'b0;
			oDataValid				=	1'b0;		
		end
	endcase
endmodule



