// endec = 0 -> encrypt; 1 -> decrypt
// round = 10, 12, 14 - counter
// size = 4, 6, 8 - counter in

module AES_endec_block (
	//	Global signals
	input			iClk,
	input			iRst_n,
	
	//	Params
	input			iParam_load,
	input			iEndec,
	input	[3:0]	iRound,
	input	[3:0]	iSize,
	
	//	RAM access
	output	[3:0]	oRAM_addr,
	input	[31:0]	iRAM_data_1,
	input	[31:0]	iRAM_data_2,
	input	[31:0]	iRAM_data_3,
	input	[31:0]	iRAM_data_4,
	
	//	Flow data in
	input			iData_valid,
	input	[31:0]	iData_1,
	input	[31:0]	iData_2,
	input	[31:0]	iData_3,
	input	[31:0]	iData_4,
	
	//	Flow data out
	output			oData_valid_pre,
	output			oData_valid,
	output	[31:0]	oData_1,
	output	[31:0]	oData_2,
	output	[31:0]	oData_3,
	output	[31:0]	oData_4
);
 
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 //	in-param
 reg			Endec;
 reg	[3:0]	Round;
 reg	[3:0]	Size;
 
 //	First round signals
 wire			Round_1st_oData_valid;
 wire	[31:0]	Round_1st_oData_1,
				Round_1st_oData_2,
				Round_1st_oData_3,
				Round_1st_oData_4;
				
 // Round N signals
 wire			Round_N_oData_valid;
 wire	[31:0]	Round_N_oData_1,
				Round_N_oData_2,
				Round_N_oData_3,
				Round_N_oData_4;
 wire			Round_N_oDone;
 
 //	Last round signals
 wire			Last_round_oData_valid;
 wire	[31:0]	Last_round_oData_1,
				Last_round_oData_2,
				Last_round_oData_3,
				Last_round_oData_4;

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
							
 assign oData_valid_pre = Round_N_oData_valid;
 assign oData_valid = Last_round_oData_valid;

/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 //	Load ex-param to in-param
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Endec <= 1'b0;
			Round <= 4'b0;
			Size <= 4'b0;
		end
	else if(iParam_load)
		begin
			Endec <= iEndec;
			Round <= iRound;
			Size <= iSize;
		end
	else
		begin
			Endec <= Endec;
			Round <= Round;
			Size <= Size;
		end
 end

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
 
 First_round Round_1st(
	//	Global signal
	.iClk			(iClk),
	.iRst_n			(iRst_n),
	
	//	RAM access
	.iRAM_data_1	(iRAM_data_1),
	.iRAM_data_2	(iRAM_data_2),
	.iRAM_data_3	(iRAM_data_3),
	.iRAM_data_4	(iRAM_data_4),
	
	//	Data IN
	.iData_valid	(iData_valid),
	.iData_1		(iData_1),
	.iData_2		(iData_2),
	.iData_3		(iData_3),
	.iData_4		(iData_4),
	
	//	Data OUT
	.oData_valid	(Round_1st_oData_valid),
	.oData_1		(Round_1st_oData_1),
	.oData_2		(Round_1st_oData_2),
	.oData_3		(Round_1st_oData_3),
	.oData_4		(Round_1st_oData_4)
 );
 
 Multiple_standard_round Multiple_round_N (
	//	Global signals
	.iClk			(iClk),
	.iRst_n			(iRst_n),
	
	//	Param
	.iEndec			(Endec),
	.iRound			(Round),
	.iSize			(Size),
	
	//	RAM access
	.oRAM_addr		(oRAM_addr),
	.iRAM_data_1	(iRAM_data_1),
	.iRAM_data_2	(iRAM_data_2),
	.iRAM_data_3	(iRAM_data_3),
	.iRAM_data_4	(iRAM_data_4),
	
	//	Data IN
	.iData_valid	(Round_1st_oData_valid),
	.iData_1		(Round_1st_oData_1),
	.iData_2		(Round_1st_oData_2),
	.iData_3		(Round_1st_oData_3),
	.iData_4		(Round_1st_oData_4),
	
	//	Data OUT
	.oData_valid	(Round_N_oData_valid),
	.oData_1		(Round_N_oData_1),
	.oData_2		(Round_N_oData_2),
	.oData_3		(Round_N_oData_3),
	.oData_4		(Round_N_oData_4),
	
	//	Reset oRAM_addr
	.iLast_round_done	(Last_round_oData_valid)
 );
 
 Last_round Round_last (
	//	Global signals
	.iClk			(iClk),
	.iRst_n			(iRst_n),
	
	//	Param
	.iEndec			(Endec),
	.iSize			(Size),
	
	//	RAM access
	.iRAM_data_1	(iRAM_data_1),
	.iRAM_data_2	(iRAM_data_2),
	.iRAM_data_3	(iRAM_data_3),
	.iRAM_data_4	(iRAM_data_4),
	
	//	Data IN
	.iData_valid	(Round_N_oData_valid),
	.iData_1		(Round_N_oData_1),
	.iData_2		(Round_N_oData_2),
	.iData_3		(Round_N_oData_3),
	.iData_4		(Round_N_oData_4),
	
	//	Data OUT
	.oData_valid	(Last_round_oData_valid),
	.oData_1		(oData_1),
	.oData_2		(oData_2),
	.oData_3		(oData_3),
	.oData_4		(oData_4)
 );
 
endmodule 