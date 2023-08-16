module MonModInverse1024
#(parameter iW=1024, parameter oW=1024)
( 
	input 					iClk,
	input					iEnable,
	input					iLoad,
	input 		[iW-1:0] 	iX,
	input 		[10:0] 		iLength,
	output	reg				oDataValid,
	output 		[oW-1:0]	oZ
);
/*
integer data_file_out_temp;
integer data_file_out_temp1;
integer data_file_out_y;
integer data_file_out_twopowi;
*/
/****************************************************
		Parameter
****************************************************/
localparam State_Initial 			= 0,
		  State_Mul					= 1,
		  State_ModPower2 			= 2,
		  State_ShiftLeftTwoPow2 	= 3,
		  State_Compare				= 4,
		  State_Add					= 5,
		  State_Finish				= 6;
localparam 	YEqualX	   = 2'b11,
			YLessThanX = 2'b01,
			XLessThanY = 2'b10 ;
wire [10:0] Length1;
reg	[2:0]	State;
reg [10:0]	i;
wire		Next_State_Finish;
reg Down;
reg Down1_Count;
wire Down1;
/****************************************************
		wire/reg cua Reg X
****************************************************/
reg [oW-1:0] 	X;
wire			RegBuffX_Load;
/****************************************************
		wire/reg cua Reg Y
****************************************************/
reg [oW-1:0] 	RegBuffY;
wire [31:0]		ToY,
				FromY;
reg 			RegBuffY_Enable,
				RegBuffY_OutputLoad;
wire [iW-1:0] 	Y;
reg				ControlMuxRegY;

/****************************************************
		wire/reg cua Twopowi
****************************************************/
reg [oW-1:0] Twopowi;
wire [31:0]	ToTwopowi,
			FromTwopowi;
reg [1:0]	Twopowi_Mode;			
reg			Twopowi_Enable;
/****************************************************
		wire/reg cua ModPower2
****************************************************/
reg				ModPower2_Enable,
				ModPower2_Load;
wire				ModPower2_Load1;
wire			ModPower2_DataValid;
wire [1023:0]	ModPower2_Temp;
wire [10:0]		ModPower2_i;
wire [iW-1:0]	ModPower2_Temp1;
reg 			ModPower2_Count;
/****************************************************
		wire/reg cua Reg Temp1
****************************************************/
reg [oW-1:0] 	RegTemp1,
				Temp;
wire [31:0]		FromTemp1;
wire 			RegTemp1_Load;			
reg				RegTemp1_Enable;
/****************************************************
		wire/reg cua Reg Mul
****************************************************/
reg 			Mul1024bit_Enable,
				Mul1024bit_Load;
wire [iW-1:0]	Mul1024bit_X,
				Mul1024bit_Y;
wire			Mul1024bit_DataValid;
wire				Mul1024bit_Load1;
wire [2047:0]	Mul1024bit_Temp;
reg  [1:0]		Mul1024bit_Count;
/****************************************************
		wire/reg cua Reg Compare
****************************************************/
wire 	[31:0]	Compare_X,
				Compare_Y;
wire	[1:0]	Compare_Mode;
reg 			Compare_Enable;
/****************************************************
		wire/reg cua Reg Add
****************************************************/
reg 		Add_Enable;
wire [31:0]	Add_X,
			Add_Y;
wire [31:0] Add_Z;
wire		Add_Finish;


/*
initial
begin
	data_file_out_temp 		= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonModInverse_Temp.txt","w");//xuat du lieu ra file.txt
	data_file_out_temp1 	= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonModInverse_Temp1.txt","w");//xuat du lieu ra file.txt
	data_file_out_y 		= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonModInverse_Y.txt","w");//xuat du lieu ra file.txt
	data_file_out_twopowi 	= $fopen("E:\\Project\\AnhDat\\RSA_v3\\PowModMon1024\\Data\\Output_MonModInverse_Twopowi.txt","w");//xuat du lieu ra file.txt
end

always@(posedge iClk)
 if (Mul1024bit_DataValid)
	$fdisplay(data_file_out_temp, "%h\n",Mul1024bit_Temp);

always@(posedge iClk)
 if (ModPower2_DataValid)
	$fdisplay(data_file_out_temp1, "%h\n",ModPower2_Temp1);

always@(posedge iClk)
 if (Twopowi_Mode==2'b10)
	$fdisplay(data_file_out_twopowi, "%h\n",Twopowi);

always@(posedge iClk)
 if (Mul1024bit_Load1)
	$fdisplay(data_file_out_y, "%h\n",RegBuffY>>32);	
*/
assign oZ[1023:0] = (oDataValid)?Y[1023:0]:1024'b0;
/****************************************************
		Reg X
****************************************************/
assign RegBuffX_Load = iLoad;
always@(posedge iClk)
	if(~iEnable)
		X	<=	iX;
	else
	if(RegBuffX_Load)
		X	<=	iX;

/****************************************************
		Reg Y
****************************************************/
assign ToY		= (ControlMuxRegY)?Add_Z:FromY;
always@(posedge iClk)
	if(~iEnable)
		RegBuffY	<=	1;
	else
	if(RegBuffY_Enable)		
		begin
			RegBuffY[991:0]   <= RegBuffY[1023:32];
			RegBuffY[1023:992] <= ToY;
		end
assign FromY		= 		RegBuffY[31:0];
			
assign Y		= 		(RegBuffY_OutputLoad)?RegBuffY	:1024'b0; 			

/****************************************************
		Reg Twopowi
****************************************************/
assign ToTwopowi = FromTwopowi;
always@(posedge iClk)
	if(~iEnable)
		Twopowi	<=	1;
	else
	if(Twopowi_Enable)
		if(Twopowi_Mode==2'b10)// dich trai 1 bit
			begin
				Twopowi[1023:1] <= Twopowi[1022:0];
				Twopowi[0]		<=	1'b0;
			end
		else
		if(Twopowi_Mode==2'b01)// dich phai 32bit			
			begin
				Twopowi[991:0]    <= Twopowi[1023:32];
				Twopowi[1023:992] <= ToTwopowi;
			end	
assign FromTwopowi = Twopowi[31:0];	
/****************************************************
		Khoi ModPower2
****************************************************/
always@(posedge iClk)
	if(~ModPower2_Load)
	begin
		ModPower2_Count <= 1'b1;
	end
	else
		if(ModPower2_Count)
			ModPower2_Count <= 1'b0;

assign 	ModPower2_Load1 = (ModPower2_Count)?ModPower2_Load:1'b0;

assign  ModPower2_Temp	=	Temp;
assign  ModPower2_i		= 	i;
ModPower1024 mod_power2
( 
		.iClk			(iClk),
		.iEnable		(ModPower2_Enable),
		.iLoad			(ModPower2_Load1),
		.iX				(ModPower2_Temp),
		.iTwoexp		(ModPower2_i),
		.oDataValid		(ModPower2_DataValid),
		.oZ				(ModPower2_Temp1)
);

assign RegTemp1_Load = ModPower2_DataValid;
always@(posedge iClk)
	if(RegTemp1_Load)
		RegTemp1	<=	ModPower2_Temp1;
	else
		if(RegTemp1_Enable)			
			begin
				RegTemp1[991:0]    <= RegTemp1[1023:32];
				RegTemp1[1023:992] <= 32'b0;			
			end
assign FromTemp1		= 		RegTemp1[31:0];
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
Mul1024bit 	mul_512bit
( 
		.iClk			(iClk),
		.iEnable		(Mul1024bit_Enable),
		.iLoad			(Mul1024bit_Load1),
	 	.iX				(Mul1024bit_X),
	 	.iY				(Mul1024bit_Y),
		.oDataValid		(Mul1024bit_DataValid),
		.oZ				(Mul1024bit_Temp)
);

always@(posedge iClk)
	if(!iEnable)
		Temp <= 1024'b0;
	else
		if(Mul1024bit_DataValid)
		begin
			Temp <= Mul1024bit_Temp[1023:0];			
		end
		else
			Temp <= Temp;

/****************************************************
		Khoi Compare
****************************************************/
assign Compare_X = FromTemp1;
assign Compare_Y = FromTwopowi;
Compare1024 compare_1024
( 
		.iClk			(iClk),
		.iEnable		(Compare_Enable),
	 	.iDataX			(Compare_X),	
	 	.iDataY			(Compare_Y),	
		.oMode			(Compare_Mode)
);
/****************************************************
		Khoi Add
****************************************************/
assign Add_Y = FromTwopowi;
assign Add_X = FromY;
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
		Control MonModInverse
****************************************************/

always@(posedge iClk)
	if(~Down)
	begin
		Down1_Count <= 1'b1;
	end
	else
		if(Down1_Count)
			Down1_Count <= 1'b0;
		else
			Down1_Count <= Down1_Count;

assign 	Down1 = (Down1_Count)?Down:1'b0;

always@(posedge iClk)
	if(iLoad)
		i <= 2;
	else
		if(Down1)
			i <= i+1;
assign Length1 = iLength+1;
assign 	Next_State_Finish = (i==Length1)?1:0;	
		
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
					State <= State_ModPower2;
				else
				if(Next_State_Finish)
					State <= State_Finish;
				else
					State <= State_Mul;
			end				
        State_ModPower2:
			begin
				if(ModPower2_DataValid)
					State <= State_ShiftLeftTwoPow2;
				else
					State <= State_ModPower2;
			end 		
        State_ShiftLeftTwoPow2:
			begin
				State <= State_Compare;
			end
        State_Compare:
			begin
				case(Compare_Mode)
				YEqualX:	State <= State_Mul;	
				XLessThanY:	State <= State_Mul;
				YLessThanX:	State <= State_Add;
				default: State <= State_Compare;
				endcase
			end			
        State_Add:
			begin
				if(Add_Finish)
					State <= State_Mul;
			end				
        State_Finish:
			begin
				State <= State_Initial;
			end
		endcase

always@(*)
	case(State)
	State_Initial:
		begin
			ControlMuxRegY		= 1'b0;
		    RegBuffY_Enable		= 1'b0;
		    RegBuffY_OutputLoad = 1'b0; 
		    Twopowi_Enable		= 1'b0;
		    Twopowi_Mode	 	= 2'b0;					
		    ModPower2_Enable	= 1'b0;
		    ModPower2_Load		= 1'b0;					
		    RegTemp1_Enable		= 1'b0;			
		    Mul1024bit_Enable	= 1'b0;
		    Mul1024bit_Load		= 1'b0;				
		    Compare_Enable		= 1'b0;				
		    Add_Enable			= 1'b0;
			oDataValid			= 1'b0;
			Down				= 1'b0;
		end
	State_Mul:
		begin
			Twopowi_Enable		= 1'b0;
		    Twopowi_Mode	 	= 2'b0;
			ControlMuxRegY		= 1'b0;
		    RegBuffY_Enable		= 1'b0;
		    RegBuffY_OutputLoad = 1'b1; 								
		    RegTemp1_Enable		= 1'b0;			
		    Mul1024bit_Enable	= 1'b1;
		    Mul1024bit_Load		= 1'b1;				
		    Compare_Enable		= 1'b0;				
		    Add_Enable			= 1'b0;
			Down				= 1'b0;
		end				
	State_ModPower2:
		begin
			Twopowi_Enable		= 1'b0;
		    Twopowi_Mode	 	= 2'b0;
		    RegBuffY_OutputLoad = 1'b0; 				
		    ModPower2_Enable	= 1'b1;
		    ModPower2_Load		= 1'b1;							
		    Mul1024bit_Enable	= 1'b0;
		    Mul1024bit_Load		= 1'b0;					
		end 		
	State_ShiftLeftTwoPow2:
		begin
		    Twopowi_Enable		= 1'b1;
		    Twopowi_Mode	 	= 2'b10;					
		    ModPower2_Enable	= 1'b0;
		    ModPower2_Load		= 1'b0;						
		end
	State_Compare:
		if(Compare_Mode==0)	
		begin
		    Twopowi_Enable		= 1'b1;
		    Twopowi_Mode	 	= 2'b01;									
		    RegTemp1_Enable		= 1'b1;						
		    Compare_Enable		= 1'b1;	
			Down				= 1'b1;
		end
		else
		begin
			Twopowi_Enable		= 1'b0;
			RegTemp1_Enable		= 1'b0;	
		end
	State_Add:
		begin
			Add_Enable			= 1'b1;
			ControlMuxRegY		= 1'b1;
		    RegBuffY_Enable		= 1'b1;
		    RegBuffY_OutputLoad = 1'b0; 
		    Twopowi_Enable		= 1'b1;
		    Twopowi_Mode	 	= 2'b1;									
		    RegTemp1_Enable		= 1'b0;						
		    Compare_Enable		= 1'b0;
			Down				= 1'b0;			
		end				
	State_Finish:
		begin
			ControlMuxRegY		= 1'b0;
		    RegBuffY_Enable		= 1'b0;
		    RegBuffY_OutputLoad = 1'b1; 
		    Twopowi_Enable		= 1'b0;
		    Twopowi_Mode	 	= 2'b0;					
		    ModPower2_Enable	= 1'b0;
		    ModPower2_Load		= 1'b0;					
		    RegTemp1_Enable		= 1'b0;			
		    Mul1024bit_Enable	= 1'b0;
		    Mul1024bit_Load		= 1'b0;				
		    Compare_Enable		= 1'b0;				
		    Add_Enable			= 1'b0;
			Down				= 1'b0;
			oDataValid			= 1'b1;		
		end
	endcase

endmodule













	