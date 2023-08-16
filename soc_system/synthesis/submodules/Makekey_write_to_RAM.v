module Makekey_write_to_RAM (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Control signals
	input				iStart,
	output				oDone,
	
	//	Param
	input		[3:0]	iKC,
	input		[3:0]	iBC,
	input		[3:0]	iRound,
	input		[6:0]	iCount,
	
	//	Data need to write
	input		[31:0]	iKEY_1,
	input		[31:0]	iKEY_2,
	input		[31:0]	iKEY_3,
	input		[31:0]	iKEY_4,
	
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
	output		[31:0]	oRAM_Kd_data_4
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 wire	[31:0]	Data;
 reg			write;
 
 reg	[6:0]	t;
 
 wire	[3:0]	t_divide_4;
 wire	[1:0]	t_remain_4;
 
 wire	[3:0]	t_divide;
 wire	[2:0]	t_remain;
 
 wire			t_remain_equal_0,
				t_remain_equal_1,
				t_remain_equal_2,
				t_remain_equal_3;
				
 reg	[2:0]	j;
				
 wire			j_equal_0,
				j_equal_1,
				j_equal_2,
				j_equal_3;
				
 wire			reset_condition;

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
 assign oDone = reset_condition;
 //những bit cao (divide) có thể xem như phút, bit thấp(remain) như giây, khi đủ số lượng giây thì phút+1 - Phat
 //remain dùng để ghi vào từng thanh ghi khác nhau, vd: BC=4, thì ghi 4 thanh ghi cùng 1 địa chỉ,rồi sau đó tăng địa chỉ - Phat
 assign t_divide_4 = t[5:2];
 assign t_remain_4 = t[1:0];
 
 assign t_divide =  t_divide_4;
 assign t_remain = {1'b0, t_remain_4};

 assign t_remain_equal_0 = ~t_remain[2] & ~t_remain[1] & ~t_remain[0];
 assign t_remain_equal_1 = ~t_remain[2] & ~t_remain[1] & t_remain[0];
 assign t_remain_equal_2 = ~t_remain[2] & t_remain[1] & ~t_remain[0];
 assign t_remain_equal_3 = ~t_remain[2] & t_remain[1] & t_remain[0];
 
 assign oRAM_Ke_addr = t_divide;
 assign oRAM_Kd_addr = iRound - t_divide;
 
 assign oRAM_Ke_write_1 = write & t_remain_equal_0;
 assign oRAM_Ke_write_2 = write & t_remain_equal_1;
 assign oRAM_Ke_write_3 = write & t_remain_equal_2;
 assign oRAM_Ke_write_4 = write & t_remain_equal_3;
 
 assign oRAM_Kd_write_1 = write & t_remain_equal_0;
 assign oRAM_Kd_write_2 = write & t_remain_equal_1;
 assign oRAM_Kd_write_3 = write & t_remain_equal_2;
 assign oRAM_Kd_write_4 = write & t_remain_equal_3;
 
 assign j_equal_0 = ~j[2] & ~j[1] & ~j[0];
 assign j_equal_1 = ~j[2] & ~j[1] & j[0];
 assign j_equal_2 = ~j[2] & j[1] & ~j[0];
 assign j_equal_3 = ~j[2] & j[1] & j[0];
 
 assign Data =	(j_equal_0) ? iKEY_1 :
				(j_equal_1) ? iKEY_2 :
				(j_equal_2) ? iKEY_3 : iKEY_4;
 
 assign oRAM_Ke_data_1 = Data;
 assign oRAM_Ke_data_2 = Data;
 assign oRAM_Ke_data_3 = Data;
 assign oRAM_Ke_data_4 = Data;
 
 assign oRAM_Kd_data_1 = Data;
 assign oRAM_Kd_data_2 = Data;
 assign oRAM_Kd_data_3 = Data;
 assign oRAM_Kd_data_4 = Data;
 
 assign reset_condition = j_equal_3;
 
/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(~iRst_n | reset_condition)
		write <= 1'b0;
	else if(iStart)
		write <= 1'b1;
	else
		write <= write;
 end
 
 //j dùng để tín hiệu để chọn data đưa vào - Phat
 always@(posedge iClk)
 begin
	if(~iRst_n | reset_condition)
		j <= 3'b0;
	else if(write)
		j <= j + 1'b1;
	else
		j <= j;
 end
 
 // t dùng để chọn write nào được enable - Phat
 always@(posedge iClk)
 begin
	if(~iRst_n | reset_condition)
		t <= 7'b0;
	else if(iStart)
		t <= iCount;
	else if(write)
		t <= t + 1'b1;
	else
		t <= t;
 end
 
endmodule