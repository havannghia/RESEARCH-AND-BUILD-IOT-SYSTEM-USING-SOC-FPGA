module Multiple_standard_round (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Param
	input				iEndec,
	input		[3:0]	iRound,
	input		[3:0]	iSize,
	
	//	RAM access
	output	reg	[3:0]	oRAM_addr,
	input		[31:0]	iRAM_data_1,
	input		[31:0]	iRAM_data_2,
	input		[31:0]	iRAM_data_3,
	input		[31:0]	iRAM_data_4,
	
	//	Data IN
	input				iData_valid,
	input		[31:0]	iData_1,
	input		[31:0]	iData_2,
	input		[31:0]	iData_3,
	input		[31:0]	iData_4,
	
	//	Data OUT
	output	reg			oData_valid,
	output	reg	[31:0]	oData_1,
	output	reg	[31:0]	oData_2,
	output	reg	[31:0]	oData_3,
	output	reg	[31:0]	oData_4,
	
	//	Reset oRAM_addr
	input				iLast_round_done
 );
 
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

 //	Bufer IN
 reg			Shift_iData_valid;
 reg	[31:0]	Data_1,
				Data_2,
				Data_3,
				Data_4;
 
 // Round counter
 reg	[3:0]	Round_counter;
 
 //	Control Round N
 reg			init;
 reg			Control_Round_N_iData_valid;
 reg	[31:0]	Control_Round_N_iData_1;
 reg	[31:0]	Control_Round_N_iData_2;
 reg	[31:0]	Control_Round_N_iData_3;
 reg	[31:0]	Control_Round_N_iData_4;
 
 // Round N signals
 wire			Round_N_iData_valid;
 wire	[31:0]	Round_N_iData_1;
 wire	[31:0]	Round_N_iData_2;
 wire	[31:0]	Round_N_iData_3;
 wire	[31:0]	Round_N_iData_4;
	
 wire			Round_N_oData_valid;
 wire	[31:0]	Round_N_oData_1;
 wire	[31:0]	Round_N_oData_2;
 wire	[31:0]	Round_N_oData_3;
 wire	[31:0]	Round_N_oData_4;
 
 //	Other signals
 wire	[3:0]	Round_minus_2;
 wire			Round_counter_meet_max;
	
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

 assign Round_N_iData_valid = (init) ? Control_Round_N_iData_valid : Shift_iData_valid;
 assign Round_N_iData_1 = (init) ? Control_Round_N_iData_1 : Data_1;
 assign Round_N_iData_2 = (init) ? Control_Round_N_iData_2 : Data_2;
 assign Round_N_iData_3 = (init) ? Control_Round_N_iData_3 : Data_3;
 assign Round_N_iData_4 = (init) ? Control_Round_N_iData_4 : Data_4;
 
 assign Round_minus_2 = iRound - 2'd2;
 assign Round_counter_meet_max = ( (Round_counter == Round_minus_2) & Round_N_oData_valid );
 
/*****************************************************************************
 *                                BUFFER IN                                  *
 *****************************************************************************/
 //Phat
 //Shift_iData_valid chờ iData_valid, khi iData_valid=1 thì sau 1 clock Shift_iData_valid=1, và sau 1 clock thì mới kich hoạt các khối khác.
 //ngay clock đầu Shift_iData_valid=1 thì Data_1 = iData_1(giá trị đúng cho data in) và Round_N_iData_1 cũng bàng Data_1,và Round_N_iData_1 được đưa vào xử lý bởi combintinal logic
 // Ngay sau clock đó, bắt đầu xử lý round
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		Shift_iData_valid <= 1'b0;
	else
		Shift_iData_valid <= iData_valid;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Data_1 <= 32'b0;
			Data_2 <= 32'b0;
			Data_3 <= 32'b0;
			Data_4 <= 32'b0;
		end
	else
		begin
			Data_1 <= iData_1;
			Data_2 <= iData_2;
			Data_3 <= iData_3;
			Data_4 <= iData_4;
		end
 end
 
/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

 always@(posedge iClk)
 begin
	if(~iRst_n | Round_counter_meet_max)
		init <= 1'b0;
	else if (Shift_iData_valid)
		init <= 1'b1;
	else
		init <= init;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n | Round_counter_meet_max)
		Control_Round_N_iData_valid <= 1'b0;
	else
		Control_Round_N_iData_valid <= Round_N_oData_valid;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n | Round_counter_meet_max)
		Round_counter <= 4'b0;
	else if(Round_N_oData_valid)
		Round_counter <= Round_counter + 1'b1;
	else
		Round_counter <= Round_counter;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n | iLast_round_done)
		oRAM_addr <= 4'b0;
	else if(iData_valid | Round_N_oData_valid)
		oRAM_addr <= oRAM_addr + 1'b1;
	else
		oRAM_addr <= oRAM_addr;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Control_Round_N_iData_1 <= 32'b0;
			Control_Round_N_iData_2 <= 32'b0;
			Control_Round_N_iData_3 <= 32'b0;
			Control_Round_N_iData_4 <= 32'b0;
		end
	else
		begin
			Control_Round_N_iData_1 <= Round_N_oData_1;
			Control_Round_N_iData_2 <= Round_N_oData_2;
			Control_Round_N_iData_3 <= Round_N_oData_3;
			Control_Round_N_iData_4 <= Round_N_oData_4;
		end
 end
 
/*****************************************************************************
 *                           Sequential Logic: OUT                           *
 *****************************************************************************/

 always@(posedge iClk)
 begin
	if(~iRst_n)
		oData_valid <= 1'b0;
	else
		oData_valid <= Round_counter_meet_max;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			oData_1 <= 32'b0;
			oData_2 <= 32'b0;
			oData_3 <= 32'b0;
			oData_4 <= 32'b0;
		end
	else if(Round_counter_meet_max)
		begin
			oData_1 <= Round_N_oData_1;
			oData_2 <= Round_N_oData_2;
			oData_3 <= Round_N_oData_3;
			oData_4 <= Round_N_oData_4;
		end
	else
		begin
			oData_1 <= oData_1;
			oData_2 <= oData_2;
			oData_3 <= oData_3;
			oData_4 <= oData_4;
		end
 end
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Standard_round Round_N(
	//	Global signals
	.iClk			(iClk),
	.iRst_n			(iRst_n),
	
	//	Param
	.iEndec			(iEndec),
	.iSize			(iSize),
	
	//	RAM access
	.iRAM_data_1	(iRAM_data_1),
	.iRAM_data_2	(iRAM_data_2),
	.iRAM_data_3	(iRAM_data_3),
	.iRAM_data_4	(iRAM_data_4),
	
	//	Data IN
	.iData_valid	(Round_N_iData_valid),
	.iData_1		(Round_N_iData_1),
	.iData_2		(Round_N_iData_2),
	.iData_3		(Round_N_iData_3),
	.iData_4		(Round_N_iData_4),
	
	//	Data OUT
	.oData_valid	(Round_N_oData_valid),
	.oData_1		(Round_N_oData_1),
	.oData_2		(Round_N_oData_2),
	.oData_3		(Round_N_oData_3),
	.oData_4		(Round_N_oData_4)
 );
 
endmodule 