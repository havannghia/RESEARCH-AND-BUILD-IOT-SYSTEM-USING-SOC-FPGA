module Compressor(
	input iClk,
	input iEnable,
	
	input iStart,
	input [31:0] iW,
	input [31:0] iNumberBlock,
	
	output [255:0]oHashDigit,
	output oDone
	);
	
	reg 	[31:0] 	H	[7:0];		   	
	
	reg 	[31:0]	a,	b,	c,	d,	e,	f,	g,	h;
		
	reg 	[2:0]	compressor_state;
	reg 	[31:0] 	block_i;	
	reg		[6:0] 	iterations;
	
	wire 	[31:0] 	T1, T2;
	
	wire 	[31:0]	ch, maj, sigma0, sigma1;
	
	
	assign T1 = h + sigma1 + ch + iW;
	assign T2 = sigma0 + maj;
	
	assign oDone = (compressor_state[2])? 1'b1 : 1'b0;
	
	
	// hash compress function
	always@(posedge iClk)
	begin
		if(!iEnable)
			begin						
				compressor_state 			<= 	3'd0;
				iterations 		<= 	7'd0;
				block_i 		<= 	32'd0;						
				
				H[0] 			<= 	32'h6a09e667;
     			H[1] 			<= 	32'hbb67ae85;
				H[2]		 	<= 	32'h3c6ef372;
				H[3] 			<= 	32'ha54ff53a;
				H[4] 			<= 	32'h510e527f;
				H[5] 			<= 	32'h9b05688c;
				H[6] 			<= 	32'h1f83d9ab;
				H[7] 			<= 	32'h5be0cd19;							  			
			end			
		else
			begin
				case(compressor_state)	
					3'd0:
						begin			
							if(iStart)
							begin								
								compressor_state 		<= 	3'd1;
							end
							else
							begin
								compressor_state <= compressor_state;
							end
						end		
					3'd1:
						begin
							a 			<= 	H[0];
							b 			<= 	H[1];
							c 			<= 	H[2];
							d 			<= 	H[3];
							e 			<= 	H[4];
							f 			<= 	H[5];
							g 			<= 	H[6];
							h 			<= 	H[7];
							compressor_state 		<= 	3'd2;							
						end
					3'd2:
						begin							
							h 			<= 	g;
							g 			<= 	f;
							f 			<= 	e;
							e 			<= 	d + T1;
							d 			<= 	c;
							c 			<= 	b;
							b 			<= 	a;
							a 			<= 	T1 + T2 ;
						
							iterations = iterations + 1'b1;
							
							if(iterations == 7'd64)	
								begin
									compressor_state 		<= 	3'd3;								
								end
							else
								begin
									compressor_state 		<= 	3'd2;		
								end						
						end					
					3'd3:
						begin							
							H[0] 		<= 	a + H[0];
							H[1] 		<= 	b + H[1];
							H[2] 		<= 	c + H[2];
							H[3] 		<= 	d + H[3];
							H[4] 		<= 	e + H[4];
							H[5] 		<= 	f + H[5];
							H[6] 		<= 	g + H[6];
							H[7] 		<= 	h + H[7];							
							
							a 		<= 	a + H[0];
							b 		<= 	b + H[1];
							c 		<= 	c + H[2];
							d 		<= 	d + H[3];
							e 		<= 	e + H[4];
							f 		<= 	f + H[5];
							g 		<= 	g + H[6];
							h 		<= 	h + H[7];		
							
							iterations <= 7'd0;
							
							if(block_i == iNumberBlock - 2'd1)							
								begin
									compressor_state 		<= 	3'd4;									
								end
								
							else
								begin
									compressor_state 		<= 	3'd2;							
									block_i 	<= block_i + 1'b1;
								end
						end
				endcase
			end
	end
	
CH CH(
	.iX(e),
	.iY(f),
	.iZ(g),
	.oData(ch)
	);

MAJ MAJ(
	.iX(a),
	.iY(b),
	.iZ(c),
	.oData(maj)	
		);

Sigma0 SIGMA0(
	.iX(a),
	.oData(sigma0)
	);

Sigma1 SIGMA1(
	.iX(e),
	.oData(sigma1)
	);
	
	assign oHashDigit  = (compressor_state[2])? {H[0],H[1],H[2],H[3],H[4],H[5],H[6],H[7]} : 256'd0;
endmodule