module RSA_Controller (
	//	Global signals
	input							iSys_clk,
	input							iRSA_clk,
	input							iRstn,
		
	//	Configuration
	input							iChipSelect_Control,
	input							iWrite_Control,
	input							iRead_Control,
	input				[2:0]		iAddress_Control,
	input				[31:0]		iData_Control,
	output	reg			[31:0]		oData_Control,
		
	// Master Read
	output	reg			[31:0]		oAddress_Master_Read,
	output	reg						oRead_Master_Read,
	input							iDataValid_Master_Read,
	input							iWait_Master_Read,
	input				[31:0]		iReadData_Master_Read,
		
	// Master write
	output	reg			[31:0]		oAddress_Master_Write,
	output	reg			[31:0]		oData_Master_Write,
	output	reg						oWrite_Master_Write,
	input							iWait_Master_Write
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
		// control & status
		reg 	[31:0] 		control;
		wire	[31:0]		status;		
		reg		[31:0] 		read_start_address;
		reg		[31:0] 		length;
		reg		[31:0] 		write_start_address;
		wire				resetn;
		
		// read master
		wire				start_read;
		reg		[1:0] 		state_master_read;
		wire	[31:0]		end_address_read;
		wire				master_read_done;
 
		// write master
		wire				start_write;
		reg		[1:0]		state_master_write;
		wire	[31:0] 		end_address_write;
		reg		[4:0]		address_write;		
		wire   				master_write_done;
		
		// read form fifo write to mem		
		reg		[31:0]		mem [95:0];
		reg					read_fifo_done;
		reg		[1:0] 		state_fifo_to_mem;		
		reg		[6:0] 		counter_read_fifo;
		
		// fifo
		wire				fifo_clear;
		reg					fifo_read;
		wire				fifo_write;	
		wire				fifo_full;
		wire				fifo_empty;
		wire	[7:0] 		number_word_used;
		wire	[31:0]		fifo_out_data;
		wire	[31:0]		fifo_in_data; 
 
		//RSA state machine
		reg		[1:0]		RSA_state;
		
		//	CORE Signals
		reg					RSA_load;
		//wire				RSA_enable;
		wire				RSA_valid;
		wire	[1023:0]	RSA_data;
		reg   	[1023:0]	RSA_data_1024;
		reg					RSA_done;
		reg					reset_n_delay_for_low_clk;

		
		
		wire	[1023:0]	A;
		wire	[1023:0]	B;
		wire	[1023:0]	N;
 
 
		// counter
		reg		[31:0]		counter_read_time;
		reg		[31:0]		counter_write_time;
		reg		[31:0]		counter_rsa;
 
	// assignment of contron and status 
		assign fifo_clear 	= control[2];
		assign start_read	= control[1];
		assign resetn 		= control[0];
 
		assign status 		= {25'd0,							  
							  RSA_done, 			//	0x40
							  master_write_done, 	//	0x20
							  master_read_done,		//	0x10
							  read_fifo_done,		//	0x08
							  start_write, 			//	0x04	
							  start_read, 			//	0x02
							  resetn};				//	0x01
							  
		// assignment of master read
		assign end_address_read = read_start_address + length;
		assign master_read_done = (oAddress_Master_Read == end_address_read);
		
		// assignment of master write 
		assign end_address_write = write_start_address + 8'd128;
		assign master_write_done = (oAddress_Master_Write == end_address_write);
		assign start_write = RSA_done;
		
		// assignment of fifo
		assign	fifo_in_data	=	iReadData_Master_Read;
		assign	fifo_write		=	iDataValid_Master_Read;
		
		// core RSA
		//assign	RSA_enable = read_fifo_done;
		
		// control and status
		always@(posedge iSys_clk)
		begin
			if(iChipSelect_Control & iWrite_Control)
				case(iAddress_Control)
					3'd0:	control 				<= 	iData_Control;
					3'd1:	read_start_address 		<= 	iData_Control;
					3'd2:	write_start_address		<= 	iData_Control;
					3'd3:	length 					<= 	iData_Control;					
				endcase
			if(iChipSelect_Control & iRead_Control)
				case(iAddress_Control)
					3'd0:	oData_Control 			<= 	control;
					3'd1:	oData_Control 			<= 	read_start_address;
					3'd2:	oData_Control 			<= 	write_start_address;							
					3'd3:	oData_Control 			<= 	length;
					3'd4:	oData_Control 			<= 	status;
					3'd5:	oData_Control 			<= 	counter_rsa;
					3'd6: 	oData_Control 			<= 	counter_read_time;
					3'd7:	oData_Control 			<= 	counter_write_time;
				endcase
		end
 
		// master read
		always@(posedge iSys_clk, negedge iRstn)
		begin
			if(!iRstn)
				begin
					state_master_read 				<= 	2'd0;
					oAddress_Master_Read 			<= 	32'd0;
					oRead_Master_Read				<= 	1'b0;
				end
			else if(!resetn)
				begin
					state_master_read 				<= 	2'd0;
					oAddress_Master_Read 			<= 	32'd0;
					oRead_Master_Read				<= 	1'b0;
				end
			else
				begin
					case(state_master_read)
						2'd0:
							begin
								if(start_read)
									begin
										oAddress_Master_Read 	<= 	read_start_address;										
										state_master_read 		<= 	2'd1;
									end
								else
									state_master_read 			<= 	state_master_read;
							end
						2'd1:
							begin
								oRead_Master_Read 				<= 	1'b1;
								state_master_read				<= 	2'd2;
							end
						2'd2:
							begin
								if(iWait_Master_Read | fifo_full)
									begin																				
										state_master_read 		<= 	state_master_read;
									end
								else
									begin
										oAddress_Master_Read 	<= 	oAddress_Master_Read + 3'd4;										
										oRead_Master_Read 		<= 	1'b0;										
										state_master_read 		<= 	2'd3;
									end
							end						
						2'd3:
							begin
								if(master_read_done)
									begin
										state_master_read 		<= 	state_master_read;
									end
								else
									begin
										state_master_read 		<= 	2'd1;
									end
							end
					endcase
				end
		end
	
		// read from FIFO write to mem
		always@(posedge iSys_clk, negedge iRstn)
		begin
			if(!iRstn)
				begin
					state_fifo_to_mem	<= 	2'd0;					
					counter_read_fifo	<= 	7'd0;					
					fifo_read			<= 	1'b0;	
					read_fifo_done		<= 	1'b0;		//change here for test
				end
			else if(!resetn)
				begin
					state_fifo_to_mem	<= 	2'd0;					
					counter_read_fifo	<= 	7'd0;					
					fifo_read			<= 	1'b0;	
					read_fifo_done		<= 	1'b0;		//change here for test													
				end
			else
				begin
					case(state_fifo_to_mem)
						2'd0:
							begin
								if(!fifo_empty & !read_fifo_done) // change here for test
									begin
										fifo_read 			<= 	1'b1;										
										state_fifo_to_mem 	<= 	2'd1;										
									end
								else
									begin
										state_fifo_to_mem 	<= 	2'd0;
									end
							end
						2'd1:
							begin
								fifo_read 					<= 	1'b0;															
								state_fifo_to_mem 			<= 	2'd2;
							end
						2'd2:
							begin
								mem[counter_read_fifo]		<=	fifo_out_data;
								counter_read_fifo 			= 	counter_read_fifo + 1'b1;	 //change here for test															
								if(counter_read_fifo == 7'd96)
									begin
										read_fifo_done 			<= 	1'b1;	//change here for test
										state_fifo_to_mem 	<= 	2'd3;
									end
								else
									begin
										state_fifo_to_mem 	<= 	2'd0;
									end
							end
						2'd3:
							begin									
								counter_read_fifo 	<= 	7'd0;
								state_fifo_to_mem 	<= 	2'd0;															
							end
					endcase
				end
		end
 
		always@(posedge iRSA_clk, negedge iRstn)
		begin
			if(!iRstn)
				reset_n_delay_for_low_clk <= 1'b0;
			else if (!resetn)
				reset_n_delay_for_low_clk <= 1'b0;
			else
				reset_n_delay_for_low_clk <= 1'b1;
		end	
		
		always@(posedge iRSA_clk)
		begin
			if(!reset_n_delay_for_low_clk)
				begin
				RSA_load	<=	1'b0;
				RSA_state 	<=	2'd0;
				RSA_done	<=	1'b0;
				end
			else
			begin
				case(RSA_state)
					2'd0:
						begin
							if(read_fifo_done)
								begin
									RSA_load 	<= 1'b1;
									RSA_state 	<= 2'd1;
								end
							else	
								begin
									RSA_state	<=	RSA_state;
								end
						end
					2'd1:
						begin
							RSA_load 	<= 1'b0;
							RSA_state 	<= 2'd2;
						end
					2'd2:
						begin
							if(RSA_valid)
								begin
									RSA_data_1024 <= RSA_data;
									RSA_done <= 1'b1;
									RSA_state <= 2'd3;
								end
							else
								begin
									RSA_state 	<= RSA_state;
								end
						end
				endcase			
			end
		end
 
/*****************************************************************************
 *                               Core module                                 *
 *****************************************************************************/ 
  
 //FIFO	
	FIFO fifo(
		.aclr		(fifo_clear),
		
		.wrclk		(iSys_clk),
		.wrreq		(fifo_write),
		.data		(fifo_in_data),
		.wrfull		(fifo_full),
		.wrusedw	(number_word_used),
		
		.rdreq		(fifo_read),
		.rdclk		(iSys_clk), // change here for test
		.rdempty	(fifo_empty),
		.q			(fifo_out_data)	
		);
		
		
	assign A = (read_fifo_done)? {mem[31],mem[30],mem[29],mem[28],mem[27],mem[26],mem[25],mem[24],mem[23],mem[22],mem[21],mem[20],mem[19],mem[18],mem[17],mem[16],
						   mem[15],mem[14],mem[13],mem[12],mem[11],mem[10],mem[9],mem[8],mem[7],mem[6],mem[5],mem[4],mem[3],mem[2],mem[1],mem[0]} : 1024'd0;

	assign B = (read_fifo_done)? {mem[63], mem[62],mem[61],mem[60],mem[59],mem[58],mem[57],mem[56],mem[55],mem[54],mem[53],mem[52],mem[51],mem[50],mem[49],mem[48],
						   mem[47],mem[46],mem[45],mem[44],mem[43],mem[42],mem[41],mem[40],mem[39],mem[38],mem[37],mem[36],mem[35],mem[34],mem[33],mem[32]} : 1024'd0;
						   
	assign N = (read_fifo_done)? {mem[95],mem[94],mem[93],mem[92],mem[91],mem[90],mem[89],mem[88],mem[87],mem[86],mem[85],mem[84],mem[83],mem[82],mem[81],mem[80],
						   mem[79],mem[78],mem[77],mem[76],mem[75],mem[74],mem[73],mem[72],mem[71],mem[70],mem[69],mem[68],mem[67],mem[66],mem[65],mem[64]} : 1024'd0;	
	
	PowModMon1024 RSA (
 	.iClk			(iRSA_clk),
	.iEnable		(reset_n_delay_for_low_clk),
	.iLoad			(RSA_load),
	.iA				(A),
	.iB				(B),
	.iN				(N),
	.oDataValid		(RSA_valid),
	.oZ				(RSA_data)
 );
 
 
		// master write
		always@(posedge iSys_clk, negedge iRstn)
		begin
			if(!iRstn)
				begin
					state_master_write 			<= 	2'd0;					
					oAddress_Master_Write 		<= 	32'd0;
					oWrite_Master_Write 		<= 	1'b0;	
					address_write 				<= 	5'd0;
				end
			else if(!resetn)
				begin
					state_master_write 			<= 	2'd0;					
					oAddress_Master_Write 		<= 	32'd0;
					oWrite_Master_Write 		<= 	1'b0;
					address_write 				<= 	5'd0;
				end
			else
				begin
					case(state_master_write)
						2'd0:
							begin
								if(start_write)
									begin
										oAddress_Master_Write 	<= 	write_start_address ;										
										oData_Master_Write 		<= 	RSA_data_1024[31:0];						
										state_master_write 		<= 	2'd1;
										address_write			<= 	5'd1;
									end
								else
									begin
										state_master_write 		<= 	2'd0;
									end
							end
						2'd1:
							begin
								oWrite_Master_Write 	<= 	1'b1;
								state_master_write 		<= 	2'd2;								
							end
						2'd2:
							begin
								if(!iWait_Master_Write)
									begin
										oWrite_Master_Write 			<= 	1'b0;
										oAddress_Master_Write 			<= 	oAddress_Master_Write + 3'd4;
										address_write 					<= 	address_write + 1'b1;										
										case(address_write)					
											5'd0:	oData_Master_Write 	<= 	RSA_data_1024[31:0];
											5'd1:	oData_Master_Write 	<= 	RSA_data_1024[63:32];
											5'd2:	oData_Master_Write 	<= 	RSA_data_1024[95:64];
											5'd3:	oData_Master_Write 	<= 	RSA_data_1024[127:96];
											5'd4:	oData_Master_Write 	<= 	RSA_data_1024[159:128];
											5'd5:	oData_Master_Write 	<= 	RSA_data_1024[191:160];
											5'd6:	oData_Master_Write 	<= 	RSA_data_1024[223:192];
											5'd7:	oData_Master_Write 	<= 	RSA_data_1024[255:224];
											5'd8:	oData_Master_Write 	<= 	RSA_data_1024[287:256];
											5'd9:	oData_Master_Write 	<= 	RSA_data_1024[319:288];
											5'd10:	oData_Master_Write 	<= 	RSA_data_1024[351:320];
											5'd11:	oData_Master_Write 	<= 	RSA_data_1024[383:352];
											5'd12:	oData_Master_Write 	<= 	RSA_data_1024[415:384];
											5'd13:	oData_Master_Write 	<= 	RSA_data_1024[447:416];
											5'd14:	oData_Master_Write 	<= 	RSA_data_1024[479:448];
											5'd15:	oData_Master_Write 	<= 	RSA_data_1024[511:480];
											5'd16:	oData_Master_Write 	<= 	RSA_data_1024[543:512];
											5'd17:	oData_Master_Write 	<= 	RSA_data_1024[575:544];
											5'd18:	oData_Master_Write 	<= 	RSA_data_1024[607:576];
											5'd19:	oData_Master_Write 	<= 	RSA_data_1024[639:608];
											5'd20:	oData_Master_Write 	<= 	RSA_data_1024[671:640];
											5'd21:	oData_Master_Write 	<= 	RSA_data_1024[703:672];
											5'd22:	oData_Master_Write 	<= 	RSA_data_1024[735:704];
											5'd23:	oData_Master_Write 	<= 	RSA_data_1024[767:736];
											5'd24:	oData_Master_Write 	<= 	RSA_data_1024[799:768];
											5'd25:	oData_Master_Write 	<= 	RSA_data_1024[831:800];
											5'd26:	oData_Master_Write 	<= 	RSA_data_1024[863:832];
											5'd27:	oData_Master_Write 	<= 	RSA_data_1024[895:864];
											5'd28:	oData_Master_Write 	<= 	RSA_data_1024[927:896];
											5'd29:	oData_Master_Write 	<= 	RSA_data_1024[959:928];
											5'd30:	oData_Master_Write 	<= 	RSA_data_1024[991:960];
											5'd31:	oData_Master_Write 	<= 	RSA_data_1024[1023:992];
										endcase
										state_master_write 				<= 	2'd3;
									end
								else
									begin
										state_master_write 				<= 	state_master_write;
									end
							end
						2'd3:
							begin
								if(master_write_done)
									begin
										state_master_write 				<= 	state_master_write;
									end
								else
									begin
										state_master_write 				<= 	2'd1;
									end
							end							
					endcase
				end
		end
 	
	
	always@(posedge iRSA_clk, negedge iRstn)
	begin
		if(!iRstn)
			begin
				counter_rsa <= 32'd0;
			end
		else if(!resetn)
			begin
				counter_rsa <= 32'd0;
			end
		else
			begin
				if(read_fifo_done & !RSA_done)
					begin
						counter_rsa <= counter_rsa + 1'b1;
					end
			end
	end
	
	// counter
	always@(posedge iSys_clk, negedge iRstn)
	begin
		if(!iRstn)
			begin
				counter_read_time 	<= 32'd0;
				counter_write_time 	<= 32'd0;
			end
		else if(!resetn)
			begin
				counter_read_time 	<= 32'd0;			
				counter_write_time 	<= 32'd0;
			end
		else
			begin
				if(start_read & !master_read_done) 
					begin
						counter_read_time 	<= counter_read_time + 1'b1;
					end				
				if(start_write & !master_write_done)
					begin
						counter_write_time 	<= counter_write_time + 1'b1;
					end
			end
	end
 
endmodule 