module ControlMul1024
(
	input 					iClk,
	input					iEnable,
	input					iLoad,
	input 					iFinishAbsX,
	input					iFinishAbsZ,
	output 		reg			oControlMuxY,
	output 		reg			oControlMuxZ,
	output		reg			oControlMuxZOutput,
	output 		reg			oEnableAdder,
	output 		reg			oEnableShiftRegInputX,
	output 		reg			oEnableShiftRegInputY,
	output 		reg			oEnableShiftRegBuffZ,
	output 		reg			oEnableShiftRegOutputZ,
	output 		reg			oEnableAbs,
	output		reg			oEnableSignOutput,
	output 		reg			oLoadOutput,
	output 		reg			oDataValid
);

parameter 	InitialState = 0, 
			AbsState = 1, 
			MulStep1State = 2, 
			MulStep2State = 3,
			SignOutputState = 4,
			FinishState = 5;
reg	[5:0]	Step,
			Step2,
			Times;
reg [2:0]	State;
reg	[1:0]	EnableSignOutput;
reg			EnableMulStep2,
			StartingMul;
			
always@(posedge iClk)
if(!iEnable)
	Times <= 6'b0;
else
	if(Step == 30)
		Times <= Times + 1'b1;
	else
		Times <= Times; 

always@(posedge iClk)
if(!iEnable)
begin
	Step2	<= 0;
	EnableSignOutput <= 0;
end
else
	if(Times==32)
		if(Step2 == 32)
		begin
			EnableSignOutput <= 2;
			Step2 <= 0;
		end
		else
		begin
			Step2 <= Step2 + 1'b1;
			EnableSignOutput <= 1;
		end
		
always@(posedge iClk)
if(!StartingMul)
	begin
		Step <= 5'b0;
		EnableMulStep2 <= 1'b0;
	end
else
	begin
		if(Step == 30)
		begin
			EnableMulStep2 <= 1'b1;
			Step <= 5'b0;
		end
		else
			Step <= Step + 1'b1;
	end
	
always@(posedge iClk)
if(!iEnable)
begin
	State			<=	InitialState;
end
else
begin
	case(State)
		InitialState:	
			begin	
				if(!iLoad)
					State <= AbsState;
				else
					State <= InitialState;
			end
		
		AbsState:
			begin
				if(iFinishAbsX)
					State <= MulStep1State;
				else
					State <= AbsState;
			end
		
		MulStep1State:
			begin
				if(EnableMulStep2)
					State <= MulStep2State;
				else
					State <= MulStep1State;
			end
		
		MulStep2State:
			begin
				if(EnableSignOutput==2)
					State <= SignOutputState;
				else
					if(EnableSignOutput==0)
						State <= MulStep1State;
					else
						State <= MulStep2State;
			end
		SignOutputState:
			begin
				if(iFinishAbsZ)
					State <= FinishState;
				else
					State <= SignOutputState;
			end
		FinishState:
			begin
				State <= InitialState;
			end
	endcase
end

always@(State)
	case	(State)
		InitialState:
			begin
				StartingMul 			= 1'b0;
				oControlMuxY			= 1'b0;
				oControlMuxZ 			= 1'b0;
				oControlMuxZOutput		= 1'b0;
				oEnableAdder 			= 1'b0;
				oEnableShiftRegInputX 	= 1'b0;
				oEnableShiftRegInputY 	= 1'b0;
				oEnableShiftRegBuffZ 	= 1'b0;
				oEnableShiftRegOutputZ 	= 1'b0;
				oEnableAbs 				= 1'b0;
				oEnableSignOutput		= 1'b0;
				oLoadOutput 			= 1'b0;
				oDataValid 				= 1'b0;
			end
		
		AbsState:
			begin
				StartingMul 			= 1'b0;
				oControlMuxY			= 1'b1;
				oControlMuxZ 			= 1'b0;
				oControlMuxZOutput		= 1'b0;
				oEnableAdder 			= 1'b0;
				oEnableShiftRegInputX 	= 1'b1;
				oEnableShiftRegInputY 	= 1'b1;
				oEnableShiftRegBuffZ 	= 1'b0;
				oEnableShiftRegOutputZ 	= 1'b0;
				oEnableAbs 				= 1'b1;
				oEnableSignOutput		= 1'b0;
				oLoadOutput 			= 1'b0;
				oDataValid 				= 1'b0;
			end		
	
		MulStep1State:
			begin
				StartingMul 			= 1'b1;
				oControlMuxY			= 1'b0;
				oControlMuxZ 			= 1'b0;
				oControlMuxZOutput		= 1'b0;
				oEnableAdder 			= 1'b1;
				oEnableShiftRegInputX 	= 1'b0;
				oEnableShiftRegInputY 	= 1'b1;
				oEnableShiftRegBuffZ 	= 1'b1;
				oEnableShiftRegOutputZ 	= 1'b0;
				oEnableAbs 				= 1'b0;
				oEnableSignOutput		= 1'b0;
				oLoadOutput 			= 1'b0;
				oDataValid 				= 1'b0;				
			end	
		
		MulStep2State:
			begin
				StartingMul 			= 1'b0;
				oControlMuxY			= 1'b1;				
				oControlMuxZ 			= 1'b1;
				oControlMuxZOutput		= 1'b0;				
				oEnableAdder 			= 1'b0;
				oEnableShiftRegInputX 	= 1'b1;
				oEnableShiftRegInputY 	= 1'b0;
				oEnableShiftRegBuffZ 	= 1'b1;				
				oEnableShiftRegOutputZ 	= 1'b1;
				oEnableAbs 				= 1'b0;
				oEnableSignOutput		= 1'b0;
				oLoadOutput 			= 1'b0;
				oDataValid 				= 1'b0;					
			end
			
		SignOutputState:
			begin
				StartingMul 			= 1'b0;
				oControlMuxY			= 1'b0;
				oControlMuxZ 			= 1'b0;			
				oControlMuxZOutput		= 1'b1;
				oEnableAdder 			= 1'b0;
				oEnableShiftRegInputX 	= 1'b0;
				oEnableShiftRegInputY 	= 1'b0;
				oEnableShiftRegBuffZ 	= 1'b0;				
				oEnableShiftRegOutputZ 	= 1'b0;
				oEnableAbs 				= 1'b0;				
				oEnableSignOutput		= 1'b1;
				oLoadOutput 			= 1'b0;
				oDataValid 				= 1'b0;					
			end
		FinishState:
			begin
				StartingMul 			= 1'b0;
				oControlMuxY			= 1'b0;
				oControlMuxZ 			= 1'b0;
				oControlMuxZOutput		= 1'b0;
				oEnableAdder 			= 1'b0;
				oEnableShiftRegInputX 	= 1'b0;
				oEnableShiftRegInputY 	= 1'b0;
				oEnableShiftRegBuffZ 	= 1'b0;
				oEnableShiftRegOutputZ 	= 1'b0;
				oEnableAbs 				= 1'b0;
				oEnableSignOutput		= 1'b0;
				oLoadOutput 			= 1'b1;
				oDataValid 				= 1'b1;
			end
		
	endcase
endmodule	