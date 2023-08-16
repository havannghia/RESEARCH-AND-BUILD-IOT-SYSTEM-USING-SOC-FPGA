module Compare2048
#(parameter iW=32,parameter oW=3)
( 
	input 					iClk,
	input					iEnable,
	input 		[iW-1:0] 	iDataX,	
	input 		[iW-1:0] 	iDataY,	
	output 	reg	[oW-1:0]	oMode
);
wire 			XCompareY,
				Equal;
reg		[7:0]	Step;
reg				YLessThanX,
				XLessThanY;

//assign oWidth = (Step==32)?(TotalZeroY-TotalZeroX):0;
//Step kiem tra so lan so sanh, den khi nao du 32 lan se cho ket qua cua oMode
always@(posedge iClk)
if(!iEnable)
	Step	<=		8'b0;
else
  if(Step<64)
    Step <=		Step + 1'b1;
else
    Step <= 1'b0;
//Kiem tra 2 bien bang nhau, chi can 1 lan khong bang thi ko can xet gia tri Equal nua
assign Equal	= 		(iDataX==iDataY);		
//Kiem tra X<Y, chi quan tam ket qua cua lan so sanh co su thay doi cuoi cung.
//if X < Y , XComareY = 1 ;
//if X > Y , XCompareY = 0 ;
assign XCompareY 	=	(iDataX <iDataY);


wire	StepCompare32;	
assign 	StepCompare32 = (Step>=64);

always@(posedge iClk)
if(!iEnable)
	begin
		YLessThanX <=	1'b0;
		XLessThanY <=	1'b0;
	end
else
begin
	case({StepCompare32,Equal})
	2'b10:
		begin
			YLessThanX <=	1'b0;
			XLessThanY <=	1'b0;
		end
	2'b11:
		begin
			YLessThanX <=	1'b0;
			XLessThanY <=	1'b0;
		end
	2'b00:
		begin
			if(XCompareY)
			begin
				YLessThanX <= 1'b0;
				XLessThanY <= 1'b1;
			end
			else
			begin
				YLessThanX <= 1'b1;
				XLessThanY <= 1'b0;
			end
		end
	2'b01:
		begin
			YLessThanX <= YLessThanX;
			XLessThanY <= XLessThanY;
		end
	endcase
end
//Sau 32 clock se tra ket qua 
always@(*)
if(Step==64)
	begin
		if(XLessThanY)
		 begin
			oMode = 2'b10;
		end
		else
			if(YLessThanX)
			begin
				oMode 	= 2'b01;
			end
			else
			begin
				oMode = 2'b11;
			end
	end
else
	oMode = 3'b00;

			
		
endmodule
		
		
	

