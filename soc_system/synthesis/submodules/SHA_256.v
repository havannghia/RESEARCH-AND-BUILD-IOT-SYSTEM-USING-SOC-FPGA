module SHA_256(
		input					iClk,
		input					iEnable,
		input					iDataValid,
		input		[511:0]     iMessage,
		input		[31:0]		iNumberBlock,		
		output reg				oReadBlock,
		output 		[255:0]		oHashValue,
		output 		            oDone
		);
	
	
	wire [31:0] W;
	wire start;
	wire load;
	wire data_request;
	//reg [5:0] controller_iterations;
	reg	[1:0] controller_state;
	
	assign load = oReadBlock;
	
	always@(posedge iClk)
	begin
		if(!iEnable)
		begin
			controller_state	<=	2'd0;
			oReadBlock			<=	1'b0;
			//controller_iterations	<=  5'd0;
		end
		else
		begin
			case(controller_state)
				2'd0:
					begin
						if(iDataValid & data_request)
						begin
							oReadBlock <= 1'b1;
							controller_state <= 2'd1;
						end
						else
						begin
							controller_state <= controller_state;
						end
					end
				2'd1:
					begin
						oReadBlock <= 1'b0;
						//controller_iterations <= controller_iterations + 1'b1;
						if(oDone)
						begin
							controller_state <= 2'd3;
						end
						else if(iDataValid & data_request)
						begin
							controller_state <= 2'd2;
							oReadBlock <= 1'b1;
						end						
						else
						begin
							controller_state <= controller_state;
						end
					end
				2'd2:
					begin
						oReadBlock <= 1'b0;
						controller_state <= 2'd1;
					end
			endcase
		end
	end
	
	
	Compressor compressor(
			.iClk(iClk),
			.iEnable(iEnable),
			.iStart(start),
			.iW(W),
			.iNumberBlock(iNumberBlock),
			.oHashDigit(oHashValue),
			.oDone(oDone)
			);
	
	Scheduler scheduler(
			.iClk(iClk),
			.iEnable(iEnable),
			.iLoad(load),
			.iMessage(iMessage),
			.oStartCompressor(start),
			.oDataRequest(data_request),
			.oW(W)
			);
		
endmodule