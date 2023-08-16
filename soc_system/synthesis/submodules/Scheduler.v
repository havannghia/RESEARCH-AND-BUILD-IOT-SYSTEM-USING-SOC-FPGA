module Scheduler (
		input				iClk,
		input				iEnable,
		input				iLoad,
		input		[511:0]	iMessage,
		output              oStartCompressor,
		output  			oDataRequest,
		output	reg	[31:0]	oW
		);
		
	reg	[31:0]W [15:0];
	reg [31:0]K_data[63:0];
	reg	[5:0]iterations;
	reg [511:0] message;
	reg	data_ready;
	reg scheduler_state;
	
	wire [31:0]W1, W2, W_t;
	
	assign oStartCompressor = data_ready;
	assign oDataRequest = ~data_ready;
	
	always@(posedge iClk)
	begin
		if(!iEnable)
		begin
			oW <= 32'd0;
			iterations <= 6'd0;
			scheduler_state	<= 1'b0;
			message <= 512'd0;
			data_ready <= 1'b0;
			
			K_data[0] 			<= 	32'h428a2f98;
			K_data[1] 			<= 	32'h71374491;
			K_data[2] 			<= 	32'hb5c0fbcf;
			K_data[3] 			<= 	32'he9b5dba5;
			K_data[4] 			<= 	32'h3956c25b;
			K_data[5] 			<= 	32'h59f111f1;
			K_data[6] 			<= 	32'h923f82a4;
			K_data[7] 			<= 	32'hab1c5ed5;
			
			K_data[8] 			<= 	32'hd807aa98;
			K_data[9] 			<= 	32'h12835b01;
			K_data[10] 			<= 	32'h243185be;
			K_data[11] 			<= 	32'h550c7dc3;
			K_data[12] 			<= 	32'h72be5d74;
			K_data[13] 			<= 	32'h80deb1fe;
			K_data[14] 			<= 	32'h9bdc06a7;
			K_data[15] 			<= 	32'hc19bf174;
	
			K_data[16] 			<= 	32'he49b69c1;
			K_data[17] 			<= 	32'hefbe4786;
			K_data[18] 			<= 	32'h0fc19dc6;	
			K_data[19] 			<= 	32'h240ca1cc;
			K_data[20] 			<= 	32'h2de92c6f;
			K_data[21] 			<= 	32'h4a7484aa;
			K_data[22] 			<= 	32'h5cb0a9dc;
			K_data[23] 			<= 	32'h76f988da;
				
			K_data[24] 			<= 	32'h983e5152;
			K_data[25] 			<= 	32'ha831c66d;
			K_data[26] 			<= 	32'hb00327c8;
			K_data[27] 			<= 	32'hbf597fc7;
			K_data[28] 			<= 	32'hc6e00bf3;
			K_data[29] 			<= 	32'hd5a79147;
			K_data[30] 			<= 	32'h06ca6351;
			K_data[31] 			<= 	32'h14292967;
	
			K_data[32] 			<= 	32'h27b70a85;
			K_data[33] 			<= 	32'h2e1b2138;
			K_data[34] 			<= 	32'h4d2c6dfc;
			K_data[35] 			<= 	32'h53380d13;
			K_data[36] 			<= 	32'h650a7354;
			K_data[37] 			<= 	32'h766a0abb;
			K_data[38] 			<= 	32'h81c2c92e;
			K_data[39] 			<= 	32'h92722c85;
	
			K_data[40] 			<= 	32'ha2bfe8a1;
			K_data[41] 			<= 	32'ha81a664b;
			K_data[42] 			<= 	32'hc24b8b70;
			K_data[43] 			<= 	32'hc76c51a3;
			K_data[44] 			<= 	32'hd192e819;
			K_data[45] 			<= 	32'hd6990624;
			K_data[46] 			<= 	32'hf40e3585;
			K_data[47] 			<= 	32'h106aa070;
				
			K_data[48] 			<= 	32'h19a4c116;
			K_data[49] 			<= 	32'h1e376c08;
			K_data[50] 			<= 	32'h2748774c;
			K_data[51] 			<= 	32'h34b0bcb5;
			K_data[52] 			<= 	32'h391c0cb3;
			K_data[53] 			<= 	32'h4ed8aa4a;
			K_data[54] 			<= 	32'h5b9cca4f;
			K_data[55] 			<= 	32'h682e6ff3;
				
			K_data[56] 			<= 	32'h748f82ee;
			K_data[57] 			<= 	32'h78a5636f;
			K_data[58] 			<= 	32'h84c87814;
			K_data[59] 			<= 	32'h8cc70208;
			K_data[60] 			<= 	32'h90befffa;
			K_data[61] 			<= 	32'ha4506ceb;
			K_data[62] 			<= 	32'hbef9a3f7;
			K_data[63] 			<= 	32'hc67178f2;
			
		end
		else
		begin
			if(iLoad)
			begin
				message <= iMessage;
				data_ready <= 1'b1;
			end
			
			case(scheduler_state)
				1'b0:
					begin
						if(data_ready)
						begin
							{W[0],W[1],W[2],W[3],W[4],W[5],W[6],W[7],W[8],W[9],W[10],W[11],W[12],W[13],W[14],W[15]} <= message;				
							iterations <= 6'd0;
							data_ready <= 1'b0;
							scheduler_state <= 1'b1;
						end
						else
						begin
							scheduler_state <= scheduler_state;
						end
					end	
				1'b1:
					begin
						{W[0],W[1],W[2],W[3],W[4],W[5],W[6],W[7],W[8],W[9],W[10],W[11],W[12],W[13],W[14],W[15]} <= {W[1],W[2],W[3],W[4],W[5],W[6],W[7],W[8],W[9],W[10],W[11],W[12],W[13],W[14],W[15],W_t};
						oW <=  W[0] + K_data[iterations];
						iterations <= iterations + 1'd1;
						if(iterations == 6'd63)
						begin
							scheduler_state <= 1'b0;
						end
						else
						begin
							scheduler_state <= scheduler_state;
						end
					end					
			endcase
		end
	end
	
assign W_t = W1 + W2 + W[9] + W[0];

Fi1 FI1(
	.iX(W[14]),
	.oData(W1)
	);

Fi0 FI0(
	.iX(W[1]),
	.oData(W2)
	);
endmodule
