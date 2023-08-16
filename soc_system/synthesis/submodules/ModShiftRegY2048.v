module ModShiftRegY2048
#(parameter W=32,parameter iW=2048,parameter oW=2048)
(
	input 					iClk,
	input					iEnable,
	input		[1:0]		iMode,
	input					iLoad,
	input		[iW-1:0]	iData,
	input		[W-1:0]		iDataShiftReg,
	output 		[W-1:0]		oDataShiftReg
);
reg [iW-1:0]	RegBuff;
always@(posedge iClk)
	if(iLoad)
		RegBuff <= iData;
	else
	if(iEnable)
		begin
			case(iMode)
			2'b10://dich trai 1 bit
				begin
					RegBuff[2047:1] <= RegBuff[2046:0];
					RegBuff[0]   <= 1'b0;
				end
			2'b01://dich phai 1 bit
				begin
					RegBuff[2046:0] <= RegBuff[2047:1];
					RegBuff[2047]   <= 1'b0;
				end
			2'b00://dich phai 32 bit
				begin
					RegBuff[2015:0]   <= RegBuff[2047:32];
					RegBuff[2047:2016]<= iDataShiftReg;
				end
				endcase
		end
assign	oDataShiftReg = RegBuff[31:0];
endmodule
