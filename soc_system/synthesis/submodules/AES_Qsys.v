module AES_Qsys 
	#(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 4)
	(
		input iClk,
		input iRst_n,
		input iRead_n,
		input iWrite_n,
		input [(ADDR_WIDTH-1):0] iAddress,
		input [(DATA_WIDTH-1):0] iData,
		output reg [(DATA_WIDTH-1):0] oData,
	
		//MASTER READ
		//input
		input iRM_rddatavalid,
		input iRM_wairequest,
		input [DATA_WIDTH-1:0] iRM_rddata,
		//output
		output reg oRM_read,
		output reg [DATA_WIDTH-1:0] oRM_rdaddr,
		
		//MASTER WRITE
		//input
		input iWM_waitrequest,
		//output
		output reg oWM_write,
		output reg [DATA_WIDTH-1:0] oWM_wraddr,
		output reg [DATA_WIDTH-1:0] oWM_wrdata
	);
	/*=============================================================================================
												
	==============================================================================================*/
	/*Address: 	signal
				0	iParam_load,********************* bit 0 of ram 0
				1	iEndec,
					
					//	KEY in
					iKey_load,************************ bit 1 of ram 0
				2	iKey_data [0],
				3	iKey_data [1],
				4	iKey_data [2],
				5	iKey_data [3],
			
					//	Data in
				6	fifo_in full
				7	data in,
				

				//Data out
				8 	fifo_out empty
				9 	data out
				
				DMA:
				10 	read_address
				11 	write_address
				12 	length
				13	control: start[0], reset[1], clear[2]
				14	status: busy[0] , RMdone[1], WMdone[2]
	*/
	/*=============================================================================================
											DECLARATIONS
	==============================================================================================*/
	//PARAMETER
	parameter MEM_DEPTH = 1 << ADDR_WIDTH;
	parameter ADDR_FULL_FIFOIN = 6;
	parameter ADDR_EMPTY_FIFOOUT = 8;
	parameter ADDR_RM_ADDR = 10;
	parameter ADDR_WM_ADDR = 11;
	parameter ADDR_LENGTH_DMA = 12;
	parameter ADDR_CONTROL = 13;
	parameter ADDR_STATUS = 14;
	parameter ADDR_COUNTER = 15;
	
	//MEMORY
	reg [31:0] ram [0:MEM_DEPTH-1];
	
	//DATA IN
	reg r_write_fifoIn;
	reg [31:0] r_data_fifoIn;
	wire w_full_fifoIn;
	
	//DATA OUT
	reg r_read_fifoOut;
	wire [31:0] w_q_fifoOut;
	wire w_empty_fifoOut;
	
	//CONFIGURE
	reg enable;
	
	//WRITE FIFO OUT TO RAM
	reg r_take_first;
	reg [1:0] r_state;
	reg r_write_q_fifoOut_to_ram;
	
	//DMA
	reg [2:0] r_state_DMA_RM;
	reg [2:0] r_state_DMA_WM;
	parameter IDLE = 0;
	parameter STEP_1 = 1;
	parameter STEP_2 = 2;
	parameter STEP_3 = 3;
	parameter STEP_4 = 4;
	parameter STEP_5 = 5;
	parameter STOP = 6;
	
	wire [DATA_WIDTH-1:0] RM_START_ADDR = ram[ADDR_RM_ADDR];
	wire [DATA_WIDTH-1:0] WM_START_ADDR = ram[ADDR_WM_ADDR];
	wire [DATA_WIDTH-1:0] LENGTH = ram[ADDR_LENGTH_DMA];
	wire START = ram[ADDR_CONTROL][0];
	wire RESET = ram[ADDR_CONTROL][1];
	
	reg [DATA_WIDTH-1:0] r_RM_lastaddr;
	reg [DATA_WIDTH-1:0] r_WM_lastaddr;
	
	reg r_RM_done, r_WM_done, r_busy;
	
	reg [7:0] r_fifo_guess_stored;
	wire [7:0] w_usedw;
	reg r_add_stored;
	/*=============================================================================================
											READ MASTER
	==============================================================================================*/
	always@(posedge iClk)
	begin
		if (!iRst_n)
		begin
			r_state_DMA_RM <= IDLE;			
			oRM_read <= 0;
			oRM_rdaddr <= 0;
			r_RM_done <= 0;
			r_add_stored <= 0;
		end
		else if (RESET)
		begin
			r_state_DMA_RM <= IDLE;			
			oRM_read <= 0;
			oRM_rdaddr <= 0;
			r_RM_done <= 0;
			r_add_stored <= 0;	
		end
		else			
		begin
			case(r_state_DMA_RM)
				IDLE:	begin
							if (START)
							begin
								oRM_rdaddr <= RM_START_ADDR;
								r_RM_lastaddr <= RM_START_ADDR + LENGTH;
								r_state_DMA_RM <= STEP_1;
							end
							else
								r_state_DMA_RM <= IDLE;
						end
				STEP_1:	begin
							if (((w_usedw + r_fifo_guess_stored) < 56) && (!w_full_fifoIn))
							begin
								oRM_read <= 1;
								r_add_stored <= 1;
								r_state_DMA_RM <= STEP_2;
							end
							else
								r_state_DMA_RM <= STEP_1;
						end
				STEP_2:	begin
							r_add_stored <= 0;
							if (!iRM_wairequest)
							begin
								oRM_read <= 0;
								oRM_rdaddr <= oRM_rdaddr + 4;
								r_state_DMA_RM <= STOP;
							end
							else
								r_state_DMA_RM <= STEP_2;
						end
				STOP:	begin
							if (oRM_rdaddr == r_RM_lastaddr)
								r_RM_done <= 1;
							else
								r_state_DMA_RM <= STEP_1;
						end						
			endcase
		end
	end
	
	always@(posedge iClk)
	begin
		if (!iRst_n)
			r_fifo_guess_stored <= 0;
		else if(RESET)
			r_fifo_guess_stored <= 0;
		else
			if (r_add_stored && iRM_rddatavalid)
				r_fifo_guess_stored <= r_fifo_guess_stored;
			else if (r_add_stored)
				r_fifo_guess_stored <= r_fifo_guess_stored + 1;
			else if (iRM_rddatavalid)
				r_fifo_guess_stored <= r_fifo_guess_stored - 1;
			else
				r_fifo_guess_stored <= r_fifo_guess_stored;
	end	
	/*=============================================================================================
										WRITE MASTER DMA
	==============================================================================================*/
	wire w_WM_start = ~w_empty_fifoOut;
	
	always@(posedge iClk)
	begin
		if (!iRst_n)
		begin
			r_state_DMA_WM <= IDLE;
			oWM_write <= 0;
			oWM_wraddr <= 0;
			r_WM_done <= 0;
			r_read_fifoOut <= 0;
		end
		else if(RESET)
		begin
			r_state_DMA_WM <= IDLE;
			oWM_write <= 0;
			oWM_wraddr <= 0;
			r_WM_done <= 0;
			r_read_fifoOut <= 0;
		end
		begin
			case(r_state_DMA_WM)
				IDLE:	begin
							r_read_fifoOut <= 0;
							if (w_WM_start)
							begin
								oWM_wraddr <= WM_START_ADDR;
								r_WM_lastaddr <= WM_START_ADDR + LENGTH;
								r_state_DMA_WM <= STEP_1;
							end
							else
								r_state_DMA_WM <= IDLE;
						end
				STEP_1:	begin
							if (!w_empty_fifoOut)
							begin
								r_read_fifoOut <= 1;
								r_state_DMA_WM <= STEP_2;
							end
							else
								r_state_DMA_WM <= STEP_1;
						end
				STEP_2: begin
							r_read_fifoOut <= 0;
							r_state_DMA_WM <= STEP_3;
						end
				STEP_3: begin
							oWM_wrdata <= w_q_fifoOut;
							r_state_DMA_WM <= STEP_4;
						end
				STEP_4:	begin
							oWM_write <= 1;
							r_state_DMA_WM <= STEP_5;
						end
				STEP_5:	begin
							if (!iWM_waitrequest)
							begin
								oWM_write <= 0;
								oWM_wraddr <= oWM_wraddr + 4;
								r_state_DMA_WM <= STOP;
							end
							else
								r_state_DMA_WM <= STEP_5;
						end
				STOP:	begin
							if (oWM_wraddr == r_WM_lastaddr)
								r_WM_done <= 1;
							else
								r_state_DMA_WM <= STEP_1;
						end
			endcase
		end								
	end	
	/*=============================================================================================
												WRITE
	==============================================================================================*/
	
	always@(posedge iClk)
	begin
		if (!iWrite_n)
		begin
			ram[iAddress] <= iData;
		end
		
		//WRITE DATA TO FIFO
		if(iRM_rddatavalid)
		begin
			r_write_fifoIn <= 1;
			r_data_fifoIn <= iRM_rddata;
		end
		else
			r_write_fifoIn <= 0;
	
		//FULL FIFO IN
		if (!w_full_fifoIn)
			ram[ADDR_FULL_FIFOIN] <= 0;
		else
			ram[ADDR_FULL_FIFOIN] <= 1;
		
		//EMPTY FIFO OUT
		if (!w_empty_fifoOut)
			ram[ADDR_EMPTY_FIFOOUT] <= 0;
		else
			ram[ADDR_EMPTY_FIFOOUT] <= 1;
			
		//OTHERS
		if (enable == 1) 
			ram[0] <= 32'd0;
			
		ram[ADDR_STATUS] <= {29'b0, r_WM_done, r_RM_done, r_busy};
	end
	
	/*=============================================================================================
												READ
	==============================================================================================*/
	always@(posedge iClk)
	begin
		if (~iRead_n) 
		begin
			oData <= ram[iAddress];
		end
	end
	
	/*=============================================================================================
											OTHERS
	==============================================================================================*/
	//ENABLE PARAM_LOAD, KEY_LOAD
	always@(posedge iClk)
	begin
		if (ram[0][0] && ram[0][1]) 
			enable <= 1;
		else
			enable <= 0;
	end
	
	//BUSY
	always@(posedge iClk)
	begin
		if(!iRst_n || RESET)
			r_busy <= 0;
		else if (START && (oWM_wraddr != r_WM_lastaddr))
			r_busy <= 1;
		else
			r_busy <= 0;
	end
	
	/*=============================================================================================
												CONSTANCE
	==============================================================================================*/
	AES_FIFO aes_u0(
			//	Global signals
			.i_clk(iClk),
			.i_rst_n(iRst_n),
			
			//	Param
			.i_param_load(enable),
			.i_endec(ram[1]),
		
			//	KEY in
			.i_key_load(enable),
			.i_key_data_1(ram[2]),
			.i_key_data_2(ram[3]),
			.i_key_data_3(ram[4]),
			.i_key_data_4(ram[5]),
			
			.i_rst_control(RESET),
			//DATA IN
			.i_write_fifoIn(r_write_fifoIn),
			.i_data_fifoIn(r_data_fifoIn),
			.o_full_fifoIn(w_full_fifoIn),
			.o_usedw(w_usedw),
		
			//DATA OUT
			.i_read_fifoOut(r_read_fifoOut),
			.o_empty_fifoOut(w_empty_fifoOut),
			.o_q_fifoOut(w_q_fifoOut)
	);
	
endmodule 