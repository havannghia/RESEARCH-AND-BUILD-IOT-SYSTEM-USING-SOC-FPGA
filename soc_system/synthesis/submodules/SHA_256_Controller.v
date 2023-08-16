module SHA_256_Controller(
		input							iClk,
		input							iSHA_clk,
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
		
		// Slave read
		/*input							iChipSelect_Slave,
		input							iRead_Slave,
		input				[2:0]	   	iAddress_Slave,
		output	reg			[31:0]		oData_Slave*/
		);
		
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
		reg		[2:0]		address_write;		
		wire   				master_write_done;
		
		// read form fifo write to mem		
		reg		[511:0]		mem;
		reg					write_done;
		reg		[1:0] 		state_fifo_to_mem;		
		reg		[3:0] 		counter_read_fifo;
		
		// fifo
		wire				fifo_clear;
		reg					fifo_read;
		wire				fifo_write;	
		wire				fifo_full;
		wire				fifo_empty;
		wire	[7:0] 		number_word_used;
		wire	[31:0]		fifo_out_data;
		wire	[31:0]		fifo_in_data;
		
		// SHA 256
		wire	 [31:0] 	number_block;
		wire				read_block;
		wire           		data_valid;
		reg					SHA_enable;
		wire				SHA_done;
		wire	[255:0]		SHA_value;
		
		// counter
		reg		[31:0]		counter_read_time;
		reg		[31:0]		counter_write_time;
		reg		[31:0]		counter_sha;
		
		
		// assignment of contron and status 
		assign fifo_clear 	= control[2];
		assign start_read	= control[1];
		assign resetn 		= control[0];	
		
		assign status 		= {25'd0,							  
							  SHA_done, 			//	0x20
							  master_write_done, 	//	0x10
							  master_read_done, 	//	0x08
							  start_write, 			//	0x04	
							  start_read, 			//	0x02
							  resetn};				//	0x01
		
		// assignment of master read
		assign end_address_read = read_start_address + length;
		assign master_read_done = (oAddress_Master_Read == end_address_read);
		
		// assignment of master write 
		assign end_address_write = write_start_address + 6'd32;
		assign master_write_done = (oAddress_Master_Write == end_address_write);
		assign start_write = SHA_done;
		
		// assignment of fifo
		assign	fifo_in_data	=	iReadData_Master_Read;
		assign	fifo_write		=	iDataValid_Master_Read;
		
		// assignment of SHA 256
		assign	number_block	=	length >> 3'd6;
		
		// assignment of data_valid
		assign   data_valid = write_done;
		
		// control and status
		always@(posedge iClk)
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
					3'd5:	oData_Control 			<= 	counter_sha;
					3'd6: 	oData_Control 			<= 	counter_read_time;
					3'd7:	oData_Control 			<= 	counter_write_time;
				endcase
		end
		
		// master read
		always@(posedge iClk, negedge iRstn)
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
		
		// master write
		always@(posedge iClk, negedge iRstn)
		begin
			if(!iRstn)
				begin
					state_master_write 			<= 	2'd0;					
					oAddress_Master_Write 		<= 	32'd0;
					oWrite_Master_Write 		<= 	1'b0;	
					address_write 				<= 	3'd0;
				end
			else if(!resetn)
				begin
					state_master_write 			<= 	2'd0;					
					oAddress_Master_Write 		<= 	32'd0;
					oWrite_Master_Write 		<= 	1'b0;
					address_write 				<= 	3'd0;
				end
			else
				begin
					case(state_master_write)
						2'd0:
							begin
								if(start_write)
									begin
										oAddress_Master_Write 	<= 	write_start_address ;										
										oData_Master_Write 		<= 	SHA_value[31:0];						
										state_master_write 		<= 	2'd1;
										address_write			<= 3'd1;
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
											3'd0:	oData_Master_Write 	<= 	SHA_value[31:0];
											3'd1:	oData_Master_Write 	<= 	SHA_value[63:32];
											3'd2:	oData_Master_Write 	<= 	SHA_value[95:64];
											3'd3:	oData_Master_Write 	<= 	SHA_value[127:96];
											3'd4:	oData_Master_Write 	<= 	SHA_value[159:128];
											3'd5:	oData_Master_Write 	<= 	SHA_value[191:160];
											3'd6:	oData_Master_Write 	<= 	SHA_value[223:192];
											3'd7:	oData_Master_Write 	<= 	SHA_value[255:224];
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
		
		// read from FIFO write to mem
		always@(posedge iClk, negedge iRstn)
		begin
			if(!iRstn)
				begin
					state_fifo_to_mem	<= 	2'd0;					
					counter_read_fifo	<= 	4'd0;					
					fifo_read			<= 	1'b0;	
					write_done			<= 	1'b0;					
					SHA_enable			<= 	1'b0;
				end
			else if(!resetn)
				begin
					state_fifo_to_mem	<= 	2'd0;					
					counter_read_fifo	<= 	4'd0;					
					fifo_read			<= 	1'b0;	
					write_done			<= 	1'b0;					
					SHA_enable			<= 	1'b0;
					
				end
			else
				begin
					case(state_fifo_to_mem)
						2'd0:
							begin
								if(!fifo_empty & !write_done)
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
								mem 						<= 	{mem[479:0],fifo_out_data};
								counter_read_fifo 			<= 	counter_read_fifo + 1'b1;								
								state_fifo_to_mem 			<= 	3'd3;
								if(counter_read_fifo == 4'hf)
									begin
										write_done 			<= 	1'b1;
										SHA_enable 			<= 	1'b1;
										state_fifo_to_mem 	<= 	2'd3;
									end
								else
									begin
										state_fifo_to_mem 	<= 	2'd0;
									end
							end
						2'd3:
							begin
								if(read_block)
									begin
										write_done 			<= 	3'd0;
										counter_read_fifo 	<= 	4'd0;
										state_fifo_to_mem 	<= 2'd0;
									end
								else
									begin
										state_fifo_to_mem 	<= 	state_fifo_to_mem;
									end
							end
					endcase
				end
		end
	
	// slave read
	/*always@(posedge iClk)
	begin
		if( iChipSelect_Slave & iRead_Slave)
			begin
				case(iAddress_Slave)					
					4'd0:	oData_Slave <= SHA_value[31:0];
					4'd1:	oData_Slave <= SHA_value[63:32];
					4'd2:	oData_Slave <= SHA_value[95:64];
					4'd3:	oData_Slave <= SHA_value[127:96];
					4'd4:	oData_Slave <= SHA_value[159:128];
					4'd5:	oData_Slave <= SHA_value[191:160];
					4'd6:	oData_Slave <= SHA_value[223:192];
					4'd7:	oData_Slave <= SHA_value[255:224];
				endcase				
			end
	end*/
	
	//FIFO	
	FIFO fifo(
		.aclr		(fifo_clear),
		
		.wrclk		(iClk),
		.wrreq		(fifo_write),
		.data		(fifo_in_data),
		.wrfull		(fifo_full),
		.wrusedw	(number_word_used),
		
		.rdreq		(fifo_read),
		.rdclk		(iClk),
		.rdempty	(fifo_empty),
		.q			(fifo_out_data)	
		);
 
	
	//SHA 256
	SHA_256 sha(
		.iClk			(iSHA_clk),
		.iEnable		(SHA_enable),
		.iDataValid 	(data_valid),
		.iMessage		(mem),
		.iNumberBlock	(number_block),				
		.oReadBlock		(read_block),
		.oHashValue		(SHA_value),
		.oDone			(SHA_done)
			); 
 
 // counter
	always@(posedge iClk, negedge iRstn)
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
	
	always@(posedge iSHA_clk)
	begin
		if(!resetn)
			begin
				counter_sha			<= 32'd0;
			end
		else
			begin
				if(SHA_enable & !SHA_done)
					begin
							counter_sha 		<= counter_sha + 1'b1;
					end
			end
	end
endmodule
