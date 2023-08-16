module AES_FIFO(
		input i_clk,
		input i_rst_n,
		
		input i_param_load,
		input i_endec,
		
		input i_key_load,
		input [31:0] i_key_data_1,
		input [31:0] i_key_data_2,
		input [31:0] i_key_data_3,
		input [31:0] i_key_data_4,
		
		input i_rst_control,
		
		input i_write_fifoIn,
		input [31:0] i_data_fifoIn,
		output o_full_fifoIn,
		output [7:0] o_usedw,
		
		input i_read_fifoOut,
		output o_empty_fifoOut,
		output [31:0] o_q_fifoOut
	);
	
	wire w_read_fifoIn;
	wire w_empty_fifoIn;
	wire [31:0] w_q_fifoIn;
	
	wire w_write_fifoOut;
	wire w_full_fifoOut;
	wire [31:0] w_data_fifoOut;
	
	wire w_rst = i_rst_control || !i_rst_n;
	
	FIFO_full fifo_in(
		.clock(i_clk),
		.data(i_data_fifoIn),
		.rdreq(w_read_fifoIn),
		.sclr(w_rst),
		.wrreq(i_write_fifoIn),
		.almost_full(o_full_fifoIn),
		.empty(w_empty_fifoIn),
		.full(),
		.q(w_q_fifoIn),
		.usedw(o_usedw)
	);
	
	FIFO_full fifo_out(
		.clock(i_clk),
		.data(w_data_fifoOut),
		.rdreq(i_read_fifoOut),
		.sclr(w_rst),
		.wrreq(w_write_fifoOut),
		.almost_full(w_full_fifoOut),
		.empty(o_empty_fifoOut),
		.full(),
		.q(o_q_fifoOut),
		.usedw()
	);
	
	AES aes_u0(
			//	Global signals
			.iClk(i_clk),
			.iRst_n(i_rst_n),
			
			//	Param
			.iParam_load(i_param_load),
			.iEndec(i_endec),
		
			//	KEY in
			.iKey_load(i_key_load),
			.iKey_data_1(i_key_data_1),
			.iKey_data_2(i_key_data_2),
			.iKey_data_3(i_key_data_3),
			.iKey_data_4(i_key_data_4),
			
			//	Flow data in
			.iFF_in_empty(w_empty_fifoIn),
			.oFF_in_read_req(w_read_fifoIn),
			.iFF_in_data(w_q_fifoIn),

			//	Flow data out
			.iFF_out_almost_full(w_full_fifoOut),
			.oFF_out_write_req(w_write_fifoOut),
			.oFF_out_data(w_data_fifoOut)
	);
endmodule