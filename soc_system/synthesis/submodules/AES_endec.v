// mode = 00 -> ECB (no chain); 01 -> CBC (xor + block); 10 -> CFB (block + xor); 11 -> invalid mode
// endec = 0 -> encrypt; 1 -> decrypt
// round = 10, 12, 14 - counter
// size = 4, 6, 8 - counter in

module AES_endec (
	//	Global signals
	input			iClk,
	input			iRst_n,
	
	//	Params
	input			iParam_load,
	input			iEndec,
	input	[1:0]	iMode,
	input	[3:0]	iRound,
	input	[3:0]	iSize,
	
	//	Control signals
	output	reg		oBusy,
	
	//	Encrypt RAM m_Ke access
	output	[3:0]	oRAM_Ke_addr,
	input	[31:0]	iRAM_Ke_data_1,
	input	[31:0]	iRAM_Ke_data_2,
	input	[31:0]	iRAM_Ke_data_3,
	input	[31:0]	iRAM_Ke_data_4,

	
	//	Decrypt RAM m_Kd access
	output	[3:0]	oRAM_Kd_addr,
	input	[31:0]	iRAM_Kd_data_1,
	input	[31:0]	iRAM_Kd_data_2,
	input	[31:0]	iRAM_Kd_data_3,
	input	[31:0]	iRAM_Kd_data_4,
	
	//	Flow data in
	input			iData_valid,
	input	[31:0]	iData_1,
	input	[31:0]	iData_2,
	input	[31:0]	iData_3,
	input	[31:0]	iData_4,
	
	//	Flow data out
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
 reg	[1:0]	Mode;
 reg			Endec;
 
 //	shift signals
 reg			Shifted_iData_valid;
 
 // buffer IN
 reg	[31:0]	Data_1;
 reg	[31:0]	Data_2;
 reg	[31:0]	Data_3;
 reg	[31:0]	Data_4;

 
 //	AES endec block
 wire			AES_endec_block_oBusy;
 
 wire	[3:0]	AES_endec_block_oRAM_addr;
 wire	[31:0]	AES_endec_block_iRAM_data_1;
 wire	[31:0]	AES_endec_block_iRAM_data_2;
 wire	[31:0]	AES_endec_block_iRAM_data_3;
 wire	[31:0]	AES_endec_block_iRAM_data_4;
 
 wire			AES_endec_block_iData_valid;
 wire	[31:0]	AES_endec_block_iData_1;
 wire	[31:0]	AES_endec_block_iData_2;
 wire	[31:0]	AES_endec_block_iData_3;
 wire	[31:0]	AES_endec_block_iData_4;
 
 wire			AES_endec_block_oData_valid_pre;
 wire			AES_endec_block_oData_valid;
 wire	[31:0]	AES_endec_block_oData_1;
 wire	[31:0]	AES_endec_block_oData_2;
 wire	[31:0]	AES_endec_block_oData_3;
 wire	[31:0]	AES_endec_block_oData_4;
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
 assign oRAM_Ke_addr = AES_endec_block_oRAM_addr;
 assign oRAM_Kd_addr = AES_endec_block_oRAM_addr;
 
 assign AES_endec_block_iRAM_data_1 = Endec ? iRAM_Kd_data_1 : iRAM_Ke_data_1;
 assign AES_endec_block_iRAM_data_2 = Endec ? iRAM_Kd_data_2 : iRAM_Ke_data_2;
 assign AES_endec_block_iRAM_data_3 = Endec ? iRAM_Kd_data_3 : iRAM_Ke_data_3;
 assign AES_endec_block_iRAM_data_4 = Endec ? iRAM_Kd_data_4 : iRAM_Ke_data_4;
 
 assign oData_valid = AES_endec_block_oData_valid;
 
 assign oData_1 = AES_endec_block_oData_1;
 assign oData_2 = AES_endec_block_oData_2;
 assign oData_3 = AES_endec_block_oData_3;
 assign oData_4 = AES_endec_block_oData_4;
 
 assign AES_endec_block_iData_valid = Shifted_iData_valid;
 
 assign AES_endec_block_iData_1 = Data_1;
 assign AES_endec_block_iData_2 = Data_2;
 assign AES_endec_block_iData_3 = Data_3;
 assign AES_endec_block_iData_4 = Data_4;
 
/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 //	in-param
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Mode <= 2'b0;
			Endec <= 1'b0;
		end
	else if(iParam_load)
		begin
			Endec <= iEndec;
			Mode <= iMode;
		end
	else
		begin
			Mode <= Mode;
			Endec <= Endec;
		end
 end
 
 //	shift signals
 always@(posedge iClk)
 begin
	if(~iRst_n)
		Shifted_iData_valid <= 1'b0;
	else
		Shifted_iData_valid <= iData_valid;
 end
 
 //	Control oBusy signal
 always@(posedge iClk)
 begin
	if(~iRst_n)
		oBusy <= 1'b0;
	else if(iData_valid)
		oBusy <= 1'b1;
	else if(AES_endec_block_oData_valid_pre)
		oBusy <= 1'b0;
	else
		oBusy <= oBusy;
 end
 
 // buffer IN
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Data_1 <= 32'b0;
			Data_2 <= 32'b0;
			Data_3 <= 32'b0;
			Data_4 <= 32'b0;
		end
	else if(iData_valid)
		begin
			Data_1 <= iData_1;
			Data_2 <= iData_2;
			Data_3 <= iData_3;
			Data_4 <= iData_4;
		end
	else
		begin
			Data_1 <= Data_1;
			Data_2 <= Data_2;
			Data_3 <= Data_3;
			Data_4 <= Data_4;
		end
 end

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
 
 AES_endec_block AES_block (
 	//	Global signals
	.iClk			(iClk),
	.iRst_n			(iRst_n),
	
	//	Choose param
	.iParam_load	(iParam_load),
	.iEndec			(iEndec & ~iMode[1]),
	.iRound			(iRound),
	.iSize			(iSize),
	
	//	RAM access
	.oRAM_addr		(AES_endec_block_oRAM_addr),
	.iRAM_data_1	(AES_endec_block_iRAM_data_1),
	.iRAM_data_2	(AES_endec_block_iRAM_data_2),
	.iRAM_data_3	(AES_endec_block_iRAM_data_3),
	.iRAM_data_4	(AES_endec_block_iRAM_data_4),
	
	//	Flow data in
	.iData_valid	(AES_endec_block_iData_valid),
	.iData_1		(AES_endec_block_iData_1),
	.iData_2		(AES_endec_block_iData_2),
	.iData_3		(AES_endec_block_iData_3),
	.iData_4		(AES_endec_block_iData_4),
	
	//	Flow data out
	.oData_valid_pre	(AES_endec_block_oData_valid_pre),	//	truoc oData_valid that 1 clock
	.oData_valid	(AES_endec_block_oData_valid),
	.oData_1		(AES_endec_block_oData_1),
	.oData_2		(AES_endec_block_oData_2),
	.oData_3		(AES_endec_block_oData_3),
	.oData_4		(AES_endec_block_oData_4)
 );
 
 endmodule 