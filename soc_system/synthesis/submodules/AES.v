module AES (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Param
	input				iParam_load,
	input				iEndec,
	
	//	KEY in
	input				iKey_load,
	input		[31:0]	iKey_data_1,
	input		[31:0]	iKey_data_2,
	input		[31:0]	iKey_data_3,
	input		[31:0]	iKey_data_4,
	
	//	Flow data in
	input				iFF_in_empty,
	output				oFF_in_read_req,
	input		[31:0]	iFF_in_data,
	
	//	Flow data out
	input				iFF_out_almost_full,
	output	reg			oFF_out_write_req,
	output	reg	[31:0]	oFF_out_data
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
	parameter KEY_LENGTH = 4;
	parameter BLOCK_SIZE = 4;
	parameter ROUND = 10;
	parameter MODE = 0;
 
 //	Encrypt RAM
 wire	[3:0]	m_Ke_wraddr;
 
 wire			m_Ke_1_wren;
 wire			m_Ke_2_wren;
 wire			m_Ke_3_wren;
 wire			m_Ke_4_wren;

 
 wire	[31:0]	m_Ke_1_data;
 wire	[31:0]	m_Ke_2_data;
 wire	[31:0]	m_Ke_3_data;
 wire	[31:0]	m_Ke_4_data;
 
 wire	[3:0]	m_Ke_rdaddr;
 
 wire	[31:0]	m_Ke_1_q;
 wire	[31:0]	m_Ke_2_q;
 wire	[31:0]	m_Ke_3_q;
 wire	[31:0]	m_Ke_4_q;
 
 //	Decrypt RAM
 wire	[3:0]	m_Kd_wraddr;
 
 wire			m_Kd_1_wren;
 wire			m_Kd_2_wren;
 wire			m_Kd_3_wren;
 wire			m_Kd_4_wren;
 
 wire	[31:0]	m_Kd_1_data;
 wire	[31:0]	m_Kd_2_data;
 wire	[31:0]	m_Kd_3_data;
 wire	[31:0]	m_Kd_4_data;
 
 wire	[3:0]	m_Kd_rdaddr;
 
 wire	[31:0]	m_Kd_1_q;
 wire	[31:0]	m_Kd_2_q;
 wire	[31:0]	m_Kd_3_q;
 wire	[31:0]	m_Kd_4_q;
 
 //	AES signals
 wire			AES_makekey_done_wire;
 reg			AES_makekey_done_reg;
 wire			AES_busy;
 
 wire			AES_oData_valid;
 wire	[31:0]	AES_oData_1;
 wire	[31:0]	AES_oData_2;
 wire	[31:0]	AES_oData_3;
 wire	[31:0]	AES_oData_4;

 // Buffer IN
 reg	[31:0]	Buffer_IN[0:3];
 reg	[2:0]	Buffer_IN_counter;
 wire			Buffer_IN_reset;
 
 // Start for ENDEC
 reg			Start;
 
 //	Buffer OUT
 reg	[31:0]	Buffer_OUT[0:3];
 reg	[2:0]	Buffer_OUT_counter;
 wire			Buffer_OUT_counter_zero;
 wire			Buffer_OUT_reset;
 
 //Phat
 reg 			FF_in_data_valid;
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 							
 assign Buffer_IN_reset = Buffer_IN_counter[1] & Buffer_IN_counter[0];
 assign oFF_in_read_req = ~iFF_in_empty & ~iFF_out_almost_full & ~AES_busy & ~FF_in_data_valid & AES_makekey_done_reg;
 assign Buffer_OUT_counter_zero = ~Buffer_OUT_counter[2] & ~Buffer_OUT_counter[1] & ~Buffer_OUT_counter[0];
 assign Buffer_OUT_reset = Buffer_OUT_counter[1] & Buffer_OUT_counter[0];
							
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
 
//assign BUFFER OUT
 always@(posedge iClk)
 begin
	if(AES_oData_valid)
		begin
			Buffer_OUT[0] <= AES_oData_1;
			Buffer_OUT[1] <= AES_oData_2;
			Buffer_OUT[2] <= AES_oData_3;
			Buffer_OUT[3] <= AES_oData_4;
		end
 end
 
 reg r_delay;
 always@(posedge iClk)
 begin
	r_delay <= AES_oData_valid;
 end
 
//Counter OUT
 always@(posedge iClk)
 begin
	if(~iRst_n)
		Buffer_OUT_counter <= 3'b0;
	else if(r_delay | ~Buffer_OUT_counter_zero) 	//change here
		begin
			if(Buffer_OUT_reset)
				Buffer_OUT_counter <= 3'b0;
			else
				Buffer_OUT_counter <= Buffer_OUT_counter + 1'b1;
		end
	else
		Buffer_OUT_counter <= Buffer_OUT_counter;
 end
 
 //WRITE FIFO OUT
 always@(posedge iClk)
 begin
	if(~iRst_n)
		oFF_out_write_req <= 1'b0;
	else if(r_delay) 						//change here		
		oFF_out_write_req <= 1'b1;
	else if(Buffer_OUT_counter_zero)
		oFF_out_write_req <= 1'b0;
	else
		oFF_out_write_req <= oFF_out_write_req;
 end
 
 //out data form buffer out
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
	.iKeyLength			(KEY_LENGTH),
	.iBlockSize			(BLOCK_SIZE),
	.iRound				(ROUND),
	
	//	KEY in
	.iKey_load			(iKey_load),
	.iKey_data_1		(iKey_data_1),
	.iKey_data_2		(iKey_data_2),
	.iKey_data_3		(iKey_data_3),
	.iKey_data_4		(iKey_data_4),
	
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
	.iMode				(MODE),
	.iRound				(ROUND),
	.iSize				(BLOCK_SIZE),
	
	//	Control signals
	.oBusy				(AES_busy),
	
	//	Encrypt RAM m_Ke access
	.oRAM_Ke_addr		(m_Ke_rdaddr),
	.iRAM_Ke_data_1		(m_Ke_1_q),
	.iRAM_Ke_data_2		(m_Ke_2_q),
	.iRAM_Ke_data_3		(m_Ke_3_q),
	.iRAM_Ke_data_4		(m_Ke_4_q),
	
	//	Decrypt RAM m_Kd access
	.oRAM_Kd_addr		(m_Kd_rdaddr),
	.iRAM_Kd_data_1		(m_Kd_1_q),
	.iRAM_Kd_data_2		(m_Kd_2_q),
	.iRAM_Kd_data_3		(m_Kd_3_q),
	.iRAM_Kd_data_4		(m_Kd_4_q),
	
	//	Flow data in
	.iData_valid		(Start),
	.iData_1			(Buffer_IN[0]),
	.iData_2			(Buffer_IN[1]),
	.iData_3			(Buffer_IN[2]),
	.iData_4			(Buffer_IN[3]),
	
	//	Flow data out
	.oData_valid		(AES_oData_valid),
	.oData_1			(AES_oData_1),
	.oData_2			(AES_oData_2),
	.oData_3			(AES_oData_3),
	.oData_4			(AES_oData_4)
);

endmodule
