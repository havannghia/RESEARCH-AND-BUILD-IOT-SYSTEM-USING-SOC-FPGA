module AES_with_buffer_in (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Param
	input				iParam_load,
	input		[3:0]	iKeyLength,
	input		[3:0]	iBlockSize,
	input				iEndec,
	input		[1:0]	iMode,
	
	//	KEY in
	input				iKey_load,
	input		[31:0]	iKey_data_1,
	input		[31:0]	iKey_data_2,
	input		[31:0]	iKey_data_3,
	input		[31:0]	iKey_data_4,
	input		[31:0]	iKey_data_5,
	input		[31:0]	iKey_data_6,
	input		[31:0]	iKey_data_7,
	input		[31:0]	iKey_data_8,
	
	//	m_chain (iv)
	input				iIV_vector_valid,
	input		[31:0]	iIV_vector_1,
	input		[31:0]	iIV_vector_2,
	input		[31:0]	iIV_vector_3,
	input		[31:0]	iIV_vector_4,
	input		[31:0]	iIV_vector_5,
	input		[31:0]	iIV_vector_6,
	input		[31:0]	iIV_vector_7,
	input		[31:0]	iIV_vector_8,
	
	//	Flow data in
	input				iFF_in_empty,
	output				oFF_in_read_req,
	input		[31:0]	iFF_in_data,

	input 		[31:0] idata_1,
	input 		[31:0] idata_2,
	input 		[31:0] idata_3,
	input 		[31:0] idata_4,
	input 		[31:0] idata_5,
	input 		[31:0] idata_6,
	input 		[31:0] idata_7,
	input 		[31:0] idata_8,
	
	//	Flow data out
	input				iFF_out_almost_full,
	output	reg			oFF_out_write_req,
	output	reg	[31:0]	oFF_out_data
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

 wire	[3:0]	Round;
 
 //	Encrypt RAM
 wire	[3:0]	m_Ke_wraddr;
 
 wire			m_Ke_1_wren;
 wire			m_Ke_2_wren;
 wire			m_Ke_3_wren;
 wire			m_Ke_4_wren;
 wire			m_Ke_5_wren;
 wire			m_Ke_6_wren;
 wire			m_Ke_7_wren;
 wire			m_Ke_8_wren;
 
 wire	[31:0]	m_Ke_1_data;
 wire	[31:0]	m_Ke_2_data;
 wire	[31:0]	m_Ke_3_data;
 wire	[31:0]	m_Ke_4_data;
 wire	[31:0]	m_Ke_5_data;
 wire	[31:0]	m_Ke_6_data;
 wire	[31:0]	m_Ke_7_data;
 wire	[31:0]	m_Ke_8_data;
 
 wire	[3:0]	m_Ke_rdaddr;
 
 wire	[31:0]	m_Ke_1_q;
 wire	[31:0]	m_Ke_2_q;
 wire	[31:0]	m_Ke_3_q;
 wire	[31:0]	m_Ke_4_q;
 wire	[31:0]	m_Ke_5_q;
 wire	[31:0]	m_Ke_6_q;
 wire	[31:0]	m_Ke_7_q;
 wire	[31:0]	m_Ke_8_q;
 
 //	Decrypt RAM
 wire	[3:0]	m_Kd_wraddr;
 
 wire			m_Kd_1_wren;
 wire			m_Kd_2_wren;
 wire			m_Kd_3_wren;
 wire			m_Kd_4_wren;
 wire			m_Kd_5_wren;
 wire			m_Kd_6_wren;
 wire			m_Kd_7_wren;
 wire			m_Kd_8_wren;
 
 wire	[31:0]	m_Kd_1_data;
 wire	[31:0]	m_Kd_2_data;
 wire	[31:0]	m_Kd_3_data;
 wire	[31:0]	m_Kd_4_data;
 wire	[31:0]	m_Kd_5_data;
 wire	[31:0]	m_Kd_6_data;
 wire	[31:0]	m_Kd_7_data;
 wire	[31:0]	m_Kd_8_data;
 
 wire	[3:0]	m_Kd_rdaddr;
 
 wire	[31:0]	m_Kd_1_q;
 wire	[31:0]	m_Kd_2_q;
 wire	[31:0]	m_Kd_3_q;
 wire	[31:0]	m_Kd_4_q;
 wire	[31:0]	m_Kd_5_q;
 wire	[31:0]	m_Kd_6_q;
 wire	[31:0]	m_Kd_7_q;
 wire	[31:0]	m_Kd_8_q;
 
 //	AES signals
 wire			AES_makekey_done_wire;
 reg			AES_makekey_done_reg;
 wire			AES_busy;
 
 wire			AES_oData_valid;
 wire	[31:0]	AES_oData_1;
 wire	[31:0]	AES_oData_2;
 wire	[31:0]	AES_oData_3;
 wire	[31:0]	AES_oData_4;
 wire	[31:0]	AES_oData_5;
 wire	[31:0]	AES_oData_6;
 wire	[31:0]	AES_oData_7;
 wire	[31:0]	AES_oData_8;

 // Buffer IN
 reg	[31:0]	Buffer_IN[0:7];
 reg	[2:0]	Buffer_IN_counter;
 wire			Buffer_IN_reset;
 
 // Start for ENDEC
 reg			Start;
 
 //	Buffer OUT
 reg	[31:0]	Buffer_OUT[0:7];
 reg	[2:0]	Buffer_OUT_counter;
 wire			Buffer_OUT_counter_zero;
 wire			Buffer_OUT_reset; //Phat, change reg to wire
 
 //Phat
 reg FF_in_data_valid;
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

 assign Round = ( iKeyLength[3] | iBlockSize[3] ) ? 4'd14 : ( ( iKeyLength[1] | iBlockSize[1] ) ? 4'd12 : 4'd10 );

 assign Buffer_IN_reset =   (iBlockSize[3]) ? 1'b0 :
							(iBlockSize[2]) ? ( ( (iBlockSize[1]) ? Buffer_IN_counter[2] : Buffer_IN_counter[1] ) & Buffer_IN_counter[0] ) : 1'b1;

 assign oFF_in_read_req = ~iFF_in_empty & ~iFF_out_almost_full & ~AES_busy & ~FF_in_data_valid & AES_makekey_done_reg;
 
 assign Buffer_OUT_counter_zero = ~Buffer_OUT_counter[2] & ~Buffer_OUT_counter[1] & ~Buffer_OUT_counter[0];
 assign Buffer_OUT_reset =   (iBlockSize[3]) ? 1'b0 :
							(iBlockSize[2]) ? ( ( (iBlockSize[1]) ? Buffer_OUT_counter[2] : Buffer_OUT_counter[1] ) & Buffer_OUT_counter[0] ) : 1'b1;
							
/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

 //	lay tin hieu data_valid
 always@(posedge iClk)
 begin
	if(~iRst_n)
		FF_in_data_valid <= 1'b0;
	else
		FF_in_data_valid <= oFF_in_read_req;
 end
 
 //	giu cho make key done
 always@(posedge iClk)
 begin
	if(~iRst_n)
		AES_makekey_done_reg <= 1'b0;
	else if(AES_makekey_done_wire)
		AES_makekey_done_reg <= 1'b1;
	else
		AES_makekey_done_reg <= AES_makekey_done_reg;
 end
 
 //	Buffer cho read 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		Buffer_IN_counter <= 3'b0;
	else if(FF_in_data_valid)
		begin
			if(Buffer_IN_reset)
				Buffer_IN_counter <= 3'b0;
			else
				Buffer_IN_counter <= Buffer_IN_counter + 1'b1;
		end
	else
		Buffer_IN_counter <= Buffer_IN_counter;
 end
 
 always@(posedge iClk)
 begin
	if(FF_in_data_valid)
		Buffer_IN[Buffer_IN_counter] <= iFF_in_data;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		Start <= 1'b0;
	else if(Buffer_IN_reset & FF_in_data_valid)
		Start <= 1'b1;
	else
		Start <= 1'b0;
 end
 
 //	Buffer cho write
 always@(posedge iClk)
 begin
	if(AES_oData_valid)
		begin
			Buffer_OUT[0] <= AES_oData_1;
			Buffer_OUT[1] <= AES_oData_2;
			Buffer_OUT[2] <= AES_oData_3;
			Buffer_OUT[3] <= AES_oData_4;
			Buffer_OUT[4] <= AES_oData_5;
			Buffer_OUT[5] <= AES_oData_6;
			Buffer_OUT[6] <= AES_oData_7;
			Buffer_OUT[7] <= AES_oData_8;
		end
 end
 //Phat's code
 //counter for Buffer_OUT is: 1, 2, 3, 0. 
 //Because AES_oData_valid=1 -> Buffer_OUT has value, Buffer_OUT_counter++ means Buffer_OUT_counter=1 and oFF_out_write_req=1
 //After 1 clock, oFF_out_data is written to ram with Buffer_OUT[Buffer_OUT_counter is 1] until 3 and then return 0 because Buffer_OUT_reset and Buffer_OUT_counter_zero
 //My solution, delay AES_oData_valid of Buffer_OUT_counter 1 clock

 //Phat's code
 reg delay_valid_for_buffer_counter;
 always@(posedge iClk)
 begin
	delay_valid_for_buffer_counter <= AES_oData_valid;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		Buffer_OUT_counter <= 3'b0;
	else if(delay_valid_for_buffer_counter | ~Buffer_OUT_counter_zero) //changed AES_oData_valid to delay_valid_for_buffer_counter
		begin
			if(Buffer_OUT_reset)
				Buffer_OUT_counter <= 3'b0;
			else
				Buffer_OUT_counter <= Buffer_OUT_counter + 1'b1;
		end
	else
		Buffer_OUT_counter <= Buffer_OUT_counter;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		oFF_out_write_req <= 1'b0;
	else if(AES_oData_valid)
		oFF_out_write_req <= 1'b1;
	else if(Buffer_OUT_counter_zero)
		oFF_out_write_req <= 1'b0;
	else
		oFF_out_write_req <= oFF_out_write_req;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		oFF_out_data <= 32'b0;
	else
		oFF_out_data <= Buffer_OUT[Buffer_OUT_counter];
 end
 
/*****************************************************************************
 *                                  Make Key                                 *
 *****************************************************************************/
 
 AES_makekey Make_key (
	//	Global signals
	.iClk				(iClk),
	.iRst_n				(iRst_n),
	
	//	Param
	.iParam_load		(iParam_load),
	.iKeyLength			(iKeyLength),
	.iBlockSize			(iBlockSize),
	.iRound				(Round),
	
	//	KEY in
	.iKey_load			(iKey_load),
	.iKey_data_1		(iKey_data_1),
	.iKey_data_2		(iKey_data_2),
	.iKey_data_3		(iKey_data_3),
	.iKey_data_4		(iKey_data_4),
	.iKey_data_5		(iKey_data_5),
	.iKey_data_6		(iKey_data_6),
	.iKey_data_7		(iKey_data_7),
	.iKey_data_8		(iKey_data_8),
	
	//	Encrypt RAM m_Ke access
	.oRAM_Ke_addr		(m_Ke_wraddr),
	.oRAM_Ke_write_1	(m_Ke_1_wren),
	.oRAM_Ke_data_1		(m_Ke_1_data),
	.oRAM_Ke_write_2	(m_Ke_2_wren),
	.oRAM_Ke_data_2		(m_Ke_2_data),
	.oRAM_Ke_write_3	(m_Ke_3_wren),
	.oRAM_Ke_data_3		(m_Ke_3_data),
	.oRAM_Ke_write_4	(m_Ke_4_wren),
	.oRAM_Ke_data_4		(m_Ke_4_data),
	.oRAM_Ke_write_5	(m_Ke_5_wren),
	.oRAM_Ke_data_5		(m_Ke_5_data),
	.oRAM_Ke_write_6	(m_Ke_6_wren),
	.oRAM_Ke_data_6		(m_Ke_6_data),
	.oRAM_Ke_write_7	(m_Ke_7_wren),
	.oRAM_Ke_data_7		(m_Ke_7_data),
	.oRAM_Ke_write_8	(m_Ke_8_wren),
	.oRAM_Ke_data_8		(m_Ke_8_data),
	
	//	Decrypt RAM m_Kd access
	.oRAM_Kd_addr		(m_Kd_wraddr),
	.oRAM_Kd_write_1	(m_Kd_1_wren),
	.oRAM_Kd_data_1		(m_Kd_1_data),
	.oRAM_Kd_write_2	(m_Kd_2_wren),
	.oRAM_Kd_data_2		(m_Kd_2_data),
	.oRAM_Kd_write_3	(m_Kd_3_wren),
	.oRAM_Kd_data_3		(m_Kd_3_data),
	.oRAM_Kd_write_4	(m_Kd_4_wren),
	.oRAM_Kd_data_4		(m_Kd_4_data),
	.oRAM_Kd_write_5	(m_Kd_5_wren),
	.oRAM_Kd_data_5		(m_Kd_5_data),
	.oRAM_Kd_write_6	(m_Kd_6_wren),
	.oRAM_Kd_data_6		(m_Kd_6_data),
	.oRAM_Kd_write_7	(m_Kd_7_wren),
	.oRAM_Kd_data_7		(m_Kd_7_data),
	.oRAM_Kd_write_8	(m_Kd_8_wren),
	.oRAM_Kd_data_8		(m_Kd_8_data),
	
	//	Control signals
	.oDone				(AES_makekey_done_wire)
);

/*****************************************************************************
 *                                Encrypt RAM                                *
 *****************************************************************************/
 
 ram2port m_Ke_1 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Ke_wraddr),
	.wren		(m_Ke_1_wren),
	.data		(m_Ke_1_data),
	
	//	Read
	.rdaddress	(m_Ke_rdaddr),
	.q			(m_Ke_1_q)
 );
 
 ram2port m_Ke_2 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Ke_wraddr),
	.wren		(m_Ke_2_wren),
	.data		(m_Ke_2_data),
	
	//	Read
	.rdaddress	(m_Ke_rdaddr),
	.q			(m_Ke_2_q)
 );
 
 ram2port m_Ke_3 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Ke_wraddr),
	.wren		(m_Ke_3_wren),
	.data		(m_Ke_3_data),
	
	//	Read
	.rdaddress	(m_Ke_rdaddr),
	.q			(m_Ke_3_q)
 );
 
 ram2port m_Ke_4 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Ke_wraddr),
	.wren		(m_Ke_4_wren),
	.data		(m_Ke_4_data),
	
	//	Read
	.rdaddress	(m_Ke_rdaddr),
	.q			(m_Ke_4_q)
 );
 
 ram2port m_Ke_5 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Ke_wraddr),
	.wren		(m_Ke_5_wren),
	.data		(m_Ke_5_data),
	
	//	Read
	.rdaddress	(m_Ke_rdaddr),
	.q			(m_Ke_5_q)
 );
 
 ram2port m_Ke_6 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Ke_wraddr),
	.wren		(m_Ke_6_wren),
	.data		(m_Ke_6_data),
	
	//	Read
	.rdaddress	(m_Ke_rdaddr),
	.q			(m_Ke_6_q)
 );
 
 ram2port m_Ke_7 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Ke_wraddr),
	.wren		(m_Ke_7_wren),
	.data		(m_Ke_7_data),
	
	//	Read
	.rdaddress	(m_Ke_rdaddr),
	.q			(m_Ke_7_q)
 );
 
 ram2port m_Ke_8 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Ke_wraddr),
	.wren		(m_Ke_8_wren),
	.data		(m_Ke_8_data),
	
	//	Read
	.rdaddress	(m_Ke_rdaddr),
	.q			(m_Ke_8_q)
 );
 
/*****************************************************************************
 *                                Decrypt RAM                                *
 *****************************************************************************/
 
 ram2port m_Kd_1 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Kd_wraddr),
	.wren		(m_Kd_1_wren),
	.data		(m_Kd_1_data),
	
	//	Read
	.rdaddress	(m_Kd_rdaddr),
	.q			(m_Kd_1_q)
 );
 
 ram2port m_Kd_2 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Kd_wraddr),
	.wren		(m_Kd_2_wren),
	.data		(m_Kd_2_data),
	
	//	Read
	.rdaddress	(m_Kd_rdaddr),
	.q			(m_Kd_2_q)
 );
 
 ram2port m_Kd_3 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Kd_wraddr),
	.wren		(m_Kd_3_wren),
	.data		(m_Kd_3_data),
	
	//	Read
	.rdaddress	(m_Kd_rdaddr),
	.q			(m_Kd_3_q)
 );
 
 ram2port m_Kd_4 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Kd_wraddr),
	.wren		(m_Kd_4_wren),
	.data		(m_Kd_4_data),
	
	//	Read
	.rdaddress	(m_Kd_rdaddr),
	.q			(m_Kd_4_q)
 );
 
 ram2port m_Kd_5 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Kd_wraddr),
	.wren		(m_Kd_5_wren),
	.data		(m_Kd_5_data),
	
	//	Read
	.rdaddress	(m_Kd_rdaddr),
	.q			(m_Kd_5_q)
 );
 
 ram2port m_Kd_6 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Kd_wraddr),
	.wren		(m_Kd_6_wren),
	.data		(m_Kd_6_data),
	
	//	Read
	.rdaddress	(m_Kd_rdaddr),
	.q			(m_Kd_6_q)
 );
 
 ram2port m_Kd_7 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Kd_wraddr),
	.wren		(m_Kd_7_wren),
	.data		(m_Kd_7_data),
	
	//	Read
	.rdaddress	(m_Kd_rdaddr),
	.q			(m_Kd_7_q)
 );
 
 ram2port m_Kd_8 (
	//	Global signals
	.clock		(iClk),
	
	//	Write
	.wraddress	(m_Kd_wraddr),
	.wren		(m_Kd_8_wren),
	.data		(m_Kd_8_data),
	
	//	Read
	.rdaddress	(m_Kd_rdaddr),
	.q			(m_Kd_8_q)
 );

/*****************************************************************************
 *                              Encrypt / Decrypt                            *
 *****************************************************************************/

 AES_endec	Endec (
	//	Global signals
	.iClk				(iClk),
	.iRst_n				(iRst_n),
	
	//	Params
	.iParam_load		(iParam_load),
	.iEndec				(iEndec),
	.iMode				(iMode),
	.iRound				(Round),
	.iSize				(iBlockSize),
	
	//	Control signals
	.oBusy				(AES_busy),
	
	//	Encrypt RAM m_Ke access
	.oRAM_Ke_addr		(m_Ke_rdaddr),
	.iRAM_Ke_data_1		(m_Ke_1_q),
	.iRAM_Ke_data_2		(m_Ke_2_q),
	.iRAM_Ke_data_3		(m_Ke_3_q),
	.iRAM_Ke_data_4		(m_Ke_4_q),
	.iRAM_Ke_data_5		(m_Ke_5_q),
	.iRAM_Ke_data_6		(m_Ke_6_q),
	.iRAM_Ke_data_7		(m_Ke_7_q),
	.iRAM_Ke_data_8		(m_Ke_8_q),
	
	//	Decrypt RAM m_Kd access
	.oRAM_Kd_addr		(m_Kd_rdaddr),
	.iRAM_Kd_data_1		(m_Kd_1_q),
	.iRAM_Kd_data_2		(m_Kd_2_q),
	.iRAM_Kd_data_3		(m_Kd_3_q),
	.iRAM_Kd_data_4		(m_Kd_4_q),
	.iRAM_Kd_data_5		(m_Kd_5_q),
	.iRAM_Kd_data_6		(m_Kd_6_q),
	.iRAM_Kd_data_7		(m_Kd_7_q),
	.iRAM_Kd_data_8		(m_Kd_8_q),
	
	//	Flow data in
	.iData_valid		(Start),
	.iData_1			(iData_1),
	.iData_2			(iData_2),
	.iData_3			(iData_3),
	.iData_4			(iData_4),
	.iData_5			(iData_5),
	.iData_6			(iData_6),
	.iData_7			(iData_7),
	.iData_8			(iData_8),
	
	//	Flow data out
	.oData_valid		(AES_oData_valid),
	.oData_1			(AES_oData_1),
	.oData_2			(AES_oData_2),
	.oData_3			(AES_oData_3),
	.oData_4			(AES_oData_4),
	.oData_5			(AES_oData_5),
	.oData_6			(AES_oData_6),
	.oData_7			(AES_oData_7),
	.oData_8			(AES_oData_8),
	
	//	m_chain (iv)
	.iIV_vector_valid	(iIV_vector_valid),
	.iIV_vector_1		(iIV_vector_1),
	.iIV_vector_2		(iIV_vector_2),
	.iIV_vector_3		(iIV_vector_3),
	.iIV_vector_4		(iIV_vector_4),
	.iIV_vector_5		(iIV_vector_5),
	.iIV_vector_6		(iIV_vector_6),
	.iIV_vector_7		(iIV_vector_7),
	.iIV_vector_8		(iIV_vector_8)
);

endmodule
