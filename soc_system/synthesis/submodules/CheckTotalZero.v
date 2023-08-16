module CheckTotalZero 
(
	input	[31:0] 	iData,
	output	reg[5:0]	TotalZero
);

always@(*)
	begin
		if(iData[31]==1'b	1)
			TotalZero = 0;
		else
		if(iData[31:30]==2'b	01)
			TotalZero = 1;
		else
		if(iData[31:29]==3'b	001)
			TotalZero = 2;
		else
		if(iData[31:28]==4'b	0001)
			TotalZero = 3;
		else
		if(iData[31:27]==5'b	00001)
			TotalZero = 4;
		else
		if(iData[31:26]==6'b	000001)
			TotalZero = 5;
		else
		if(iData[31:25]==7'b	0000001)
			TotalZero = 6;
		else
		if(iData[31:24]==8'b	00000001)
			TotalZero = 7;
		else
		if(iData[31:23]==9'b	000000001)
			TotalZero = 8;
		else
		if(iData[31:22]==10'b	0000000001)
			TotalZero = 9;
		else
		if(iData[31:21]==11'b	00000000001)
			TotalZero = 10;
		else
		if(iData[31:20]==12'b	000000000001)
			TotalZero = 11;
		else
		if(iData[31:19]==13'b	0000000000001)
			TotalZero = 12;
		else
		if(iData[31:18]==14'b	00000000000001)
			TotalZero = 13;
		else
		if(iData[31:17]==15'b	000000000000001)
			TotalZero = 14;
		else
		if(iData[31:16]==16'b	0000000000000001)
			TotalZero = 15;
		else
		if(iData[31:15]==17'b	00000000000000001)
			TotalZero = 16;
		else
		if(iData[31:14]==18'b	000000000000000001)
			TotalZero = 17;
		else
		if(iData[31:13]==19'b	0000000000000000001)
			TotalZero = 18;
		else
		if(iData[31:12]==20'b	00000000000000000001)
			TotalZero = 19;
		else
		if(iData[31:11]==21'b	000000000000000000001)
			TotalZero = 20;
		else
		if(iData[31:10]==22'b	0000000000000000000001)
			TotalZero = 21;
		else
		if(iData[31:9]==23'b	00000000000000000000001)
			TotalZero = 22;
		else
		if(iData[31:8]==24'b	000000000000000000000001)
			TotalZero = 23;
		else
		if(iData[31:7]==25'b	0000000000000000000000001)
			TotalZero = 24;	
		else
		if(iData[31:6]==26'b	00000000000000000000000001)
			TotalZero = 25;
		else
		if(iData[31:5]==27'b	000000000000000000000000001)
			TotalZero = 26;
		else
		if(iData[31:4]==28'b	0000000000000000000000000001)
			TotalZero = 27;
		else
		if(iData[31:3]==29'b	00000000000000000000000000001)
			TotalZero = 28;
		else
		if(iData[31:2]==30'b	000000000000000000000000000001)
			TotalZero = 29;
		else
		if(iData[31:1]==31'b	0000000000000000000000000000001)
			TotalZero = 30;
		else
		if(iData[31:0]==32'b	00000000000000000000000000000001)
			TotalZero = 31;
		else
			TotalZero = 32;
			end
endmodule
