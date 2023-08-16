module Padding(
		input					iClk,
		input					iRst_n,
		input					iEnable,
		input					iLoad,
		input		[1:0] 		iIdBlock,
		input		[1023:0]	iMessage,
		output	reg				oDone,
		output 	reg				oDataValid,
		output	reg [511:0]		oBlockValue,
		output  reg [1:0]		oNumberBlock
		);
		
	reg [31:0]M[47:0];
	reg [7:0]length;
	reg [1023:0]data;
	reg [3:0]state;
	reg [5:0]i;
	reg [7:0]j;
	reg [2:0]count;
	reg [31:0] temp;
	
	always@(posedge iClk)
	begin
		if(!iRst_n)
			begin
				length <= 8'd0;
				state <= 4'd0;
				data <= iMessage;
				i <= 6'd0;
				j <= 8'd0;
				count <= 3'd0;		
				temp <= 32'd0;
				oNumberBlock <= 2'd0;
				oDone <= 32'd0;
				oDataValid <= 1'b0;
			end
		else if(!iEnable)
			begin
				length <= 8'd0;
				state <= 4'd0;
				data <= iMessage;
				i <= 6'd0;
				j <= 8'd0;
				count <= 3'd0;
				temp <= 32'd0;
				oNumberBlock <= 2'd0;
				oDone <= 32'd0;
				oDataValid <= 1'b0;
			end
		else
			begin
				case(state)
					4'd0:
						begin
							if(data[1023:1016] == 8'd0)
								begin
									length <= length + 1'b1;
									state <= 4'd1;
								end
							else
								begin
									state <= 4'd2;
								end
						end
					4'd1:
						begin
							data = {data[1015:0],8'd0};
							state <= 4'd0;
						end
					4'd2:
						begin
							length <= 8'd128 - length;
							state <= 4'd3;
						end
					4'd3:
						begin
							case(count)
								2'd0:
									temp[31:24] <= data[1023:1016];
								2'd1:
									temp[23:16] <= data[1023:1016];
								2'd2:
									temp[15:8] <= data[1023:1016];
								2'd3:
									temp[7:0] <= data[1023:1016];
							endcase							
							count <= count + 1'b1;								
							j <= j + 1'b1;						
							if(j == length)
								state <= 4'd6;
							else
								state <= 4'd4;
						end
					4'd4:
						begin																			
							data <= {data[1015:0],8'd0};
							M[i] <= temp;	
							if (count == 3'd4)	
								begin
									count <= 3'd0;							
									temp <= 32'd0;
									i <= i + 1'b1;			
								end
							state <= 4'd3;
						end
					4'd5:
						begin																							
							state <= 4'd3;
						end
					4'd6:
						begin			
							M[i] <= temp;
							j <= length - (length/3'd4)*3'd4;
							state <= 4'd7;
						end					
					4'd7:					
						begin
							if(j == 8'd0)
								begin
									M[i] <= 8'h80 << 5'd24;
									state <= 4'd9;
								end
							else
								begin
									if(j < 3'd3)
										temp <= 8'h80 << (2'd3-j)*(4'd8);
									else
										temp <= 8'h80;
									state <= 4'd8;
								end
						end
					4'd8:
						begin
							M[i] <= M[i] | temp;
							state <= 4'd9;
						end
					4'd9:
						begin
							i <= i + 1'b1;
							if(length <= 6'd55)
								begin
									oNumberBlock <= 2'd1;									
								end
							else if(length >= 56 && length <= 119)
								begin
									oNumberBlock <= 2'd2;
								end
							else if(length >= 120 && length <= 183)
								begin
									oNumberBlock <= 2'd3;
								end
							state <= 4'd10;
						end
					4'd10:
						begin							
							if(length <= 6'd55)
								begin
									if(i <= 4'd14)		
										begin
											i <= i + 1'b1;
											M[i] <= 32'd0;									
											state <= 4'd10;
										end
									else
										state <= 4'd11;
								end
							else if(length >= 6'd56 && length <= 7'd119)
								begin
									if(i <= 5'd30)
										begin
											i <= i + 1'b1;
											M[i] <= 32'd0;
											state <= 4'd10;
										end
									else
										state <= 4'd11;
								end
							else if(length >= 7'd120 && length <= 8'd183)
								begin
									if(i <= 6'd46)
										begin
											i <= i + 1'b1;
											M[i] <= 32'd0;
											state <= 4'd10;
										end
									else
										state <= 4'd11;
								end
						end
					4'd11:
						begin
							M[i] <= length  << 3'd3;
							oDone <= 1'd1;
							state <= 4'd12;
						end
					4'd12:
						begin
							if(oDone && iLoad)
							begin
								case(iIdBlock)
									2'd1:
										oBlockValue = {M[0],M[1],M[2],M[3],M[4],M[5],M[6],M[7],M[8],M[9],M[10],M[11],M[12],M[13],M[14],M[15]};
									2'd2:
										oBlockValue = {M[16],M[17],M[18],M[19],M[20],M[21],M[22],M[23],M[24],M[25],M[26],M[27],M[28],M[29],M[30],M[31]};
									2'd3:
										oBlockValue = {M[32],M[33],M[34],M[35],M[36],M[37],M[38],M[39],M[40],M[41],M[42],M[43],M[44],M[45],M[46],M[47]};
								endcase
								oDataValid <= 1'b1;								
							end							
							state <= 4'd13;
						end
					4'd13:
						begin
							oDataValid <= 1'b0;
							if(iLoad)
								state <= 4'd12;
							else
								state <= 4'd13;
						end
				endcase
			end
	end
endmodule
