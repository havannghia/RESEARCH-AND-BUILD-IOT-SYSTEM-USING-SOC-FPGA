module First_round (
	//	Global signal
	input				iClk,
	input				iRst_n,
	
	//	RAM access
	input		[31:0]	iRAM_data_1,
	input		[31:0]	iRAM_data_2,
	input		[31:0]	iRAM_data_3,
	input		[31:0]	iRAM_data_4,
	
	//	Data IN
	input				iData_valid,
	input		[31:0]	iData_1,
	input		[31:0]	iData_2,
	input		[31:0]	iData_3,
	input		[31:0]	iData_4,
	
	//	Data OUT
	output				oData_valid,
	output		[31:0]	oData_1,
	output		[31:0]	oData_2,
	output		[31:0]	oData_3,
	output		[31:0]	oData_4
);
			
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

 assign oData_valid = iData_valid;
 
 assign oData_1 = iData_1 ^ iRAM_data_1;
 assign oData_2 = iData_2 ^ iRAM_data_2;
 assign oData_3 = iData_3 ^ iRAM_data_3;
 assign oData_4 = iData_4 ^ iRAM_data_4;
 
endmodule 