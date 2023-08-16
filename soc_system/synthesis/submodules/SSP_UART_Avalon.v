module SSP_UART_Avalon(
		input iClk,
		input iRst,
		
		input SSP_SCK,
		input iChipSelect,
		input iWrite,
		input iRead,
		input [2:0] iAddress,
		input [31:0] iData,
		output [31:0] oData,
		
		 //  External UART Interface
    
		output  TxD_232,              
		input   RxD_232,              
		output  xRTS,             
		input   xCTS,                 
    
		output  TxD_485,              
		input   RxD_485,              
		output  xDE,                  

		//  External Interrupt Request
    
		output IRQ          
    
		);
		
	wire SSP_SSEL;
	wire [2:0] SSP_RA;
	wire SSP_WnR;
	wire SSP_En;
	wire SSP_EOC;
	wire [11:0] SSP_DI;
	wire [11:0] SSP_DO;
	wire TxIdle;
	wire RxIdle;
	
	//reg [15:0] command;
	
	/*always @(posedge SSP_SCK, posedge iRst)
	begin
		if(iRst)
		begin
			command <= 16'd0;
		end
		else
		begin
			if(iChipSelect)
			begin
				if(iWrite)
				begin
					command <= iData[15:0];
				end
				if(iRead)
				begin
					if(iAddress <= 3'd4)
						oData <= {16'd0,SSP_EOC, SSP_En, SSP_WnR, SSP_SSEL, SSP_DO};
					else 
						oData <= {29'd0, TxIdle, RxIdle};
				end
			end
		end
	end
	*/
	
	/*assign  SSP_RA = iAddress;	
	assign  SSP_DI = command[11:0];
	assign	SSP_SSEL = command[12];
	assign  SSP_WnR = command[13];
	assign  SSP_En = command[14];
	assign  SSP_EOC = command[15];	*/
	
	assign  SSP_EOC = iChipSelect & (iWrite |iRead );
	assign  SSP_En  = (iChipSelect & iRead & (SSP_RA == 3'd3))? 1'b1 : 1'b0;
	assign  SSP_WnR = (iChipSelect & iWrite)? 1'b1 : (iChipSelect & iRead)? 1'b0 : 1'bz;
	assign  SSP_SSEL = iChipSelect;
	assign  SSP_DI  = (iChipSelect & iWrite)? iData[11:0] : 12'd0;
	assign  SSP_RA = (iChipSelect & (iWrite | iRead) )? iAddress : 3'd0;
	assign  oData = (iChipSelect & iRead)? {16'd0,SSP_EOC, SSP_En, SSP_WnR, SSP_SSEL, SSP_DO} : 32'd0;
	
	SSP_UART  	#(
					.pPS_Default   (4'hC),
					.pDiv_Default  (8'h01),
					.pRTOChrDlyCnt (3),
					.pTF_Depth	   (2),
					.pRF_Depth	   (2),
					.pTF_Init	   ("UART_RF.coe"),
					.pRF_Init      ("UART_RF.coe")
				)uart    (
					.Rst           (iRst),
					.Clk		   (iClk),
					.SSP_SSEL	   (SSP_SSEL),
					.SSP_SCK	   (SSP_SCK),
					.SSP_RA		   (SSP_RA),
					.SSP_WnR	   (SSP_WnR),
					.SSP_En		   (SSP_En),
					.SSP_EOC	   (SSP_EOC),
					.SSP_DI	       (SSP_DI),
					.SSP_DO	       (SSP_DO),
					.TxD_232	   (TxD_232),
					.RxD_232       (RxD_232),
					.xRTS		   (xRTS),
					.xCTS	       (xCTS),
					.TxD_485	   (TxD_485),
					.RxD_485	   (RxD_485),
					.xDE	       (xDE),
					.IRQ		   (IRQ),
					.TxIdle        (TxIdle),
					.RxIdle	       (RxIdle)				
				);
endmodule
