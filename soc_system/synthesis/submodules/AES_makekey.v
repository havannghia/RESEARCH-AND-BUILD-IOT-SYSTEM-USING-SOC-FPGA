module AES_makekey (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Param
	input				iParam_load,
	input		[3:0]	iKeyLength,
	input		[3:0]	iBlockSize,
	input		[3:0]	iRound,
	
	//	KEY in
	input				iKey_load,
	input		[31:0]	iKey_data_1,
	input		[31:0]	iKey_data_2,
	input		[31:0]	iKey_data_3,
	input		[31:0]	iKey_data_4,
	
	//	Encrypt RAM m_Ke access
	output		[3:0]	oRAM_Ke_addr,
	output				oRAM_Ke_write_1,
	output		[31:0]	oRAM_Ke_data_1,
	output				oRAM_Ke_write_2,
	output		[31:0]	oRAM_Ke_data_2,
	output				oRAM_Ke_write_3,
	output		[31:0]	oRAM_Ke_data_3,
	output				oRAM_Ke_write_4,
	output		[31:0]	oRAM_Ke_data_4,
	
	//	Decrypt RAM m_Kd access
	output		[3:0]	oRAM_Kd_addr,
	output				oRAM_Kd_write_1,
	output		[31:0]	oRAM_Kd_data_1,
	output				oRAM_Kd_write_2,
	output		[31:0]	oRAM_Kd_data_2,
	output				oRAM_Kd_write_3,
	output		[31:0]	oRAM_Kd_data_3,
	output				oRAM_Kd_write_4,
	output		[31:0]	oRAM_Kd_data_4,
	
	//	Control signals
	output				oDone
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 //	in-param
 reg	[3:0]	KC;
 reg	[3:0]	BC;
 
 //	Control RAM access
 reg			RAM_control_sel;
 
 //	First round key
 wire	[3:0]	First_round_oRAM_Ke_addr;
 wire			First_round_oRAM_Ke_write_1;
 wire	[31:0]	First_round_oRAM_Ke_data_1;
 wire			First_round_oRAM_Ke_write_2;
 wire	[31:0]	First_round_oRAM_Ke_data_2;
 wire			First_round_oRAM_Ke_write_3;
 wire	[31:0]	First_round_oRAM_Ke_data_3;
 wire			First_round_oRAM_Ke_write_4;
 wire	[31:0]	First_round_oRAM_Ke_data_4;
 
 wire	[3:0]	First_round_oRAM_Kd_addr;
 wire			First_round_oRAM_Kd_write_1;
 wire	[31:0]	First_round_oRAM_Kd_data_1;
 wire			First_round_oRAM_Kd_write_2;
 wire	[31:0]	First_round_oRAM_Kd_data_2;
 wire			First_round_oRAM_Kd_write_3;
 wire	[31:0]	First_round_oRAM_Kd_data_3;
 wire			First_round_oRAM_Kd_write_4;
 wire	[31:0]	First_round_oRAM_Kd_data_4;
 
 wire			First_round_oLast_key_data_valid;
 wire	[31:0]	First_round_oLast_key_data;
 
 //	Main round key
 wire	[3:0]	Main_round_oRAM_Ke_addr;
 wire			Main_round_oRAM_Ke_write_1;
 wire	[31:0]	Main_round_oRAM_Ke_data_1;
 wire			Main_round_oRAM_Ke_write_2;
 wire	[31:0]	Main_round_oRAM_Ke_data_2;
 wire			Main_round_oRAM_Ke_write_3;
 wire	[31:0]	Main_round_oRAM_Ke_data_3;
 wire			Main_round_oRAM_Ke_write_4;
 wire	[31:0]	Main_round_oRAM_Ke_data_4;

 
 wire	[3:0]	Main_round_oRAM_Kd_addr;
 wire			Main_round_oRAM_Kd_write_1;
 wire	[31:0]	Main_round_oRAM_Kd_data_1;
 wire			Main_round_oRAM_Kd_write_2;
 wire	[31:0]	Main_round_oRAM_Kd_data_2;
 wire			Main_round_oRAM_Kd_write_3;
 wire	[31:0]	Main_round_oRAM_Kd_data_3;
 wire			Main_round_oRAM_Kd_write_4;
 wire	[31:0]	Main_round_oRAM_Kd_data_4;
 
 wire			Main_round_oDone;
 
 //	Inverse MixColumn
 wire	[3:0]	Inverse_MixColumn_iRAM_Kd_addr;
 wire			Inverse_MixColumn_iRAM_Kd_write_1;
 wire	[31:0]	Inverse_MixColumn_iRAM_Kd_data_1;
 wire			Inverse_MixColumn_iRAM_Kd_write_2;
 wire	[31:0]	Inverse_MixColumn_iRAM_Kd_data_2;
 wire			Inverse_MixColumn_iRAM_Kd_write_3;
 wire	[31:0]	Inverse_MixColumn_iRAM_Kd_data_3;
 wire			Inverse_MixColumn_iRAM_Kd_write_4;
 wire	[31:0]	Inverse_MixColumn_iRAM_Kd_data_4;
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
 assign oDone = Main_round_oDone;
 
 assign oRAM_Ke_addr =	(RAM_control_sel) ? Main_round_oRAM_Ke_addr : First_round_oRAM_Ke_addr;
 assign oRAM_Ke_write_1 = (RAM_control_sel) ? Main_round_oRAM_Ke_write_1 : First_round_oRAM_Ke_write_1;
 assign oRAM_Ke_data_1 = (RAM_control_sel) ? Main_round_oRAM_Ke_data_1 : First_round_oRAM_Ke_data_1;
 assign oRAM_Ke_write_2 = (RAM_control_sel) ? Main_round_oRAM_Ke_write_2 : First_round_oRAM_Ke_write_2;
 assign oRAM_Ke_data_2 = (RAM_control_sel) ? Main_round_oRAM_Ke_data_2 : First_round_oRAM_Ke_data_2;
 assign oRAM_Ke_write_3 = (RAM_control_sel) ? Main_round_oRAM_Ke_write_3 : First_round_oRAM_Ke_write_3;
 assign oRAM_Ke_data_3 = (RAM_control_sel) ? Main_round_oRAM_Ke_data_3 : First_round_oRAM_Ke_data_3;
 assign oRAM_Ke_write_4 = (RAM_control_sel) ? Main_round_oRAM_Ke_write_4 : First_round_oRAM_Ke_write_4;
 assign oRAM_Ke_data_4 = (RAM_control_sel) ? Main_round_oRAM_Ke_data_4 : First_round_oRAM_Ke_data_4;
 
 assign Inverse_MixColumn_iRAM_Kd_addr =  (RAM_control_sel) ? Main_round_oRAM_Kd_addr : First_round_oRAM_Kd_addr;
 assign Inverse_MixColumn_iRAM_Kd_write_1 = (RAM_control_sel) ? Main_round_oRAM_Kd_write_1 : First_round_oRAM_Kd_write_1;
 assign Inverse_MixColumn_iRAM_Kd_data_1 = (RAM_control_sel) ? Main_round_oRAM_Kd_data_1 : First_round_oRAM_Kd_data_1;
 assign Inverse_MixColumn_iRAM_Kd_write_2 = (RAM_control_sel) ? Main_round_oRAM_Kd_write_2 : First_round_oRAM_Kd_write_2;
 assign Inverse_MixColumn_iRAM_Kd_data_2 = (RAM_control_sel) ? Main_round_oRAM_Kd_data_2 : First_round_oRAM_Kd_data_2;
 assign Inverse_MixColumn_iRAM_Kd_write_3 = (RAM_control_sel) ? Main_round_oRAM_Kd_write_3 : First_round_oRAM_Kd_write_3;
 assign Inverse_MixColumn_iRAM_Kd_data_3 = (RAM_control_sel) ? Main_round_oRAM_Kd_data_3 : First_round_oRAM_Kd_data_3;
 assign Inverse_MixColumn_iRAM_Kd_write_4 = (RAM_control_sel) ? Main_round_oRAM_Kd_write_4 : First_round_oRAM_Kd_write_4;
 assign Inverse_MixColumn_iRAM_Kd_data_4 = (RAM_control_sel) ? Main_round_oRAM_Kd_data_4 : First_round_oRAM_Kd_data_4;
 
/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			KC <= 4'b0;
			BC <= 4'b0;
		end
	else if(iParam_load)
		begin
			KC <= iKeyLength;
			BC <= iBlockSize;
		end
	else
		begin
			KC <= KC;
			BC <= BC;
		end
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		RAM_control_sel <= 1'b0;
	else if(First_round_oLast_key_data_valid | Main_round_oDone)
		RAM_control_sel <= ~RAM_control_sel;
	else
		RAM_control_sel <= RAM_control_sel;
 end
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
 
 First_round_key First_round (
	//	Global signals
	.iClk					(iClk),
	.iRst_n					(iRst_n),
	
	//	Params
	.iKC					(KC),
	.iBC					(BC),
	.iRound					(iRound),
	
	//	KEY in
	.iKey_load				(iKey_load),
	.iKey_data_1			(iKey_data_1),
	.iKey_data_2			(iKey_data_2),
	.iKey_data_3			(iKey_data_3),
	.iKey_data_4			(iKey_data_4),
	
	//	Encrypt RAM m_Ke access
	.oRAM_Ke_addr			(First_round_oRAM_Ke_addr),
	.oRAM_Ke_write_1		(First_round_oRAM_Ke_write_1),
	.oRAM_Ke_data_1			(First_round_oRAM_Ke_data_1),
	.oRAM_Ke_write_2		(First_round_oRAM_Ke_write_2),
	.oRAM_Ke_data_2			(First_round_oRAM_Ke_data_2),
	.oRAM_Ke_write_3		(First_round_oRAM_Ke_write_3),
	.oRAM_Ke_data_3			(First_round_oRAM_Ke_data_3),
	.oRAM_Ke_write_4		(First_round_oRAM_Ke_write_4),
	.oRAM_Ke_data_4			(First_round_oRAM_Ke_data_4),
	
	//	Decrypt RAM m_Kd access
	.oRAM_Kd_addr			(First_round_oRAM_Kd_addr),
	.oRAM_Kd_write_1		(First_round_oRAM_Kd_write_1),
	.oRAM_Kd_data_1			(First_round_oRAM_Kd_data_1),
	.oRAM_Kd_write_2		(First_round_oRAM_Kd_write_2),
	.oRAM_Kd_data_2			(First_round_oRAM_Kd_data_2),
	.oRAM_Kd_write_3		(First_round_oRAM_Kd_write_3),
	.oRAM_Kd_data_3			(First_round_oRAM_Kd_data_3),
	.oRAM_Kd_write_4		(First_round_oRAM_Kd_write_4),
	.oRAM_Kd_data_4			(First_round_oRAM_Kd_data_4),
	
	//	Signals to Main round key
	.oLast_key_data_valid	(First_round_oLast_key_data_valid),
	.oLast_key_data			(First_round_oLast_key_data)
 );
 
 Main_round_key Main_round (
	//	Global signals
	.iClk					(iClk),
	.iRst_n					(iRst_n),
	
	//	Params
	.iKC					(KC),
	.iBC					(BC),
	.iRound					(iRound),
	
	//	KEY in
	.iKey_load				(iKey_load),
	.iKey_data_1			(iKey_data_1),
	.iKey_data_2			(iKey_data_2),
	.iKey_data_3			(iKey_data_3),
	.iKey_data_4			(iKey_data_4),
	
	//	Signals from First round key
	.iLast_key_data_valid	(First_round_oLast_key_data_valid),
	.iLast_key_data			(First_round_oLast_key_data),
	
	//	Encrypt RAM m_Ke access
	.oRAM_Ke_addr			(Main_round_oRAM_Ke_addr),
	.oRAM_Ke_write_1		(Main_round_oRAM_Ke_write_1),
	.oRAM_Ke_data_1			(Main_round_oRAM_Ke_data_1),
	.oRAM_Ke_write_2		(Main_round_oRAM_Ke_write_2),
	.oRAM_Ke_data_2			(Main_round_oRAM_Ke_data_2),
	.oRAM_Ke_write_3		(Main_round_oRAM_Ke_write_3),
	.oRAM_Ke_data_3			(Main_round_oRAM_Ke_data_3),
	.oRAM_Ke_write_4		(Main_round_oRAM_Ke_write_4),
	.oRAM_Ke_data_4			(Main_round_oRAM_Ke_data_4),
	
	//	Decrypt RAM m_Kd access
	.oRAM_Kd_addr			(Main_round_oRAM_Kd_addr),
	.oRAM_Kd_write_1		(Main_round_oRAM_Kd_write_1),
	.oRAM_Kd_data_1			(Main_round_oRAM_Kd_data_1),
	.oRAM_Kd_write_2		(Main_round_oRAM_Kd_write_2),
	.oRAM_Kd_data_2			(Main_round_oRAM_Kd_data_2),
	.oRAM_Kd_write_3		(Main_round_oRAM_Kd_write_3),
	.oRAM_Kd_data_3			(Main_round_oRAM_Kd_data_3),
	.oRAM_Kd_write_4		(Main_round_oRAM_Kd_write_4),
	.oRAM_Kd_data_4			(Main_round_oRAM_Kd_data_4),
	
	//	Control signals
	.oDone					(Main_round_oDone)
 );
 
 Inverse_MixColumn_round Inverse_MixColumn (
	//	Global signals
	.iClk					(iClk),
	.iRst_n					(iRst_n),
	
	//	Param
	.iRound					(iRound),
	
	//	Original data from above
	.iRAM_Kd_addr			(Inverse_MixColumn_iRAM_Kd_addr),
	.iRAM_Kd_write_1		(Inverse_MixColumn_iRAM_Kd_write_1),
	.iRAM_Kd_data_1			(Inverse_MixColumn_iRAM_Kd_data_1),
	.iRAM_Kd_write_2		(Inverse_MixColumn_iRAM_Kd_write_2),
	.iRAM_Kd_data_2			(Inverse_MixColumn_iRAM_Kd_data_2),
	.iRAM_Kd_write_3		(Inverse_MixColumn_iRAM_Kd_write_3),
	.iRAM_Kd_data_3			(Inverse_MixColumn_iRAM_Kd_data_3),
	.iRAM_Kd_write_4		(Inverse_MixColumn_iRAM_Kd_write_4),
	.iRAM_Kd_data_4			(Inverse_MixColumn_iRAM_Kd_data_4),
	
	//	Write Decrypt RAM m_Kd
	.oRAM_Kd_addr			(oRAM_Kd_addr),
	.oRAM_Kd_write_1		(oRAM_Kd_write_1),
	.oRAM_Kd_data_1			(oRAM_Kd_data_1),
	.oRAM_Kd_write_2		(oRAM_Kd_write_2),
	.oRAM_Kd_data_2			(oRAM_Kd_data_2),
	.oRAM_Kd_write_3		(oRAM_Kd_write_3),
	.oRAM_Kd_data_3			(oRAM_Kd_data_3),
	.oRAM_Kd_write_4		(oRAM_Kd_write_4),
	.oRAM_Kd_data_4			(oRAM_Kd_data_4)
 );
 
endmodule 