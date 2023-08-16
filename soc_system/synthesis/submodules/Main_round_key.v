module Main_round_key (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Params
	input		[3:0]	iKC,
	input		[3:0]	iBC,
	input		[3:0]	iRound,
	
	//	KEY in
	input				iKey_load,
	input		[31:0]	iKey_data_1,
	input		[31:0]	iKey_data_2,
	input		[31:0]	iKey_data_3,
	input		[31:0]	iKey_data_4,
	
	//	Signals from First round key
	input				iLast_key_data_valid,
	input		[31:0]	iLast_key_data,
	
	//	Encrypt RAM m_Ke access
	output		[3:0]	oRAM_Ke_addr,
	output				oRAM_Ke_write_1,
	output		[31:0]	oRAM_Ke_data_1,
	output				oRAM_Ke_write_2,
	output		[31:0]	oRAM_Ke_data_2,
	output				oRAM_Ke_write_3,
	output		[31:0]	oRAM_Ke_data_3,
	output				oRAM_Ke_write_4,
	output		[31:0]	oRAM_Ke_data_4,
	
	//	Decrypt RAM m_Kd access
	output		[3:0]	oRAM_Kd_addr,
	output				oRAM_Kd_write_1,
	output		[31:0]	oRAM_Kd_data_1,
	output				oRAM_Kd_write_2,
	output		[31:0]	oRAM_Kd_data_2,
	output				oRAM_Kd_write_3,
	output		[31:0]	oRAM_Kd_data_3,
	output				oRAM_Kd_write_4,
	output		[31:0]	oRAM_Kd_data_4,
	
	//	Control signals
	output				oDone
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 //	FSM signals
 reg	[2:0]	State;
 
 //	Inner - KEY
 reg	[31:0]	KEY_1;
 reg	[31:0]	KEY_2;
 reg	[31:0]	KEY_3;
 reg	[31:0]	KEY_4;
 
 //	SBOX
 reg			SBOX_reset;
 reg			SBOX_iSpecial_mode;
 reg			SBOX_iData_valid;
 reg	[31:0]	SBOX_iData;
 reg	[31:0]	SBOX_iOrigin_data;
 wire			SBOX_oData_valid;
 wire	[31:0]	SBOX_oData;
 
 //	Write to RAM
 reg			Write_to_RAM_iStart;
 wire			Write_to_RAM_oDone;
 reg	[6:0]	Write_to_RAM_iCount;
 
 //	Condition for loop
 wire	[3:0]	Round_plus_1;
 wire	[6:0]	ROUND_KEY_COUNT;
 wire	[6:0]	ROUND_KEY_COUNT_minus_KC;
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
 assign Round_plus_1 = iRound + 1'b1;
 assign ROUND_KEY_COUNT = Round_plus_1 * iBC;
 assign ROUND_KEY_COUNT_minus_KC = ROUND_KEY_COUNT - iKC;
 
 assign oDone = SBOX_reset;
 
/*****************************************************************************
 *                           Finite State Machine                            *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			State <= 3'b0;
			KEY_1 <= 32'b0;
			KEY_2 <= 32'b0;
			KEY_3 <= 32'b0;
			KEY_4 <= 32'b0;
			SBOX_reset <= 1'b0;
			SBOX_iSpecial_mode <= 1'b0;
			SBOX_iData_valid <= 1'b0;
			SBOX_iData <= 32'b0;
			SBOX_iOrigin_data <= 32'b0;
			Write_to_RAM_iStart <= 1'b0;
			Write_to_RAM_iCount <= 7'b0;
		end
	else
		begin
			case(State)
				3'd0:
					begin
						SBOX_reset <= 1'b0;
						if(iKey_load)
							begin
								KEY_1 <= iKey_data_1;
								KEY_2 <= iKey_data_2;
								KEY_3 <= iKey_data_3;
								KEY_4 <= iKey_data_4;
								State <= State;
							end
						else if(iLast_key_data_valid)
							begin
								SBOX_iData_valid <= 1'b1;
								SBOX_iData <= iLast_key_data;
								SBOX_iOrigin_data <= KEY_1;
								State <= 3'd1;
							end
						else
							State <= State;
					end
				3'd1:
					begin
						SBOX_iData_valid <= 1'b0;
						if(SBOX_oData_valid)
							begin
								KEY_1 <= SBOX_oData;
								KEY_2 <= KEY_2 ^ SBOX_oData;
								KEY_3 <= KEY_3 ^ KEY_2 ^ SBOX_oData;
								KEY_4 <= KEY_4 ^ KEY_3 ^ KEY_2 ^ SBOX_oData;
								State <= 3'd4;
								/*if(iKC[3])
									State <= 3'd2;
								else
									begin
										KEY_5 <= KEY_5 ^ KEY_4 ^ KEY_3 ^ KEY_2 ^ SBOX_oData;
										KEY_6 <= KEY_6 ^ KEY_5 ^ KEY_4 ^ KEY_3 ^ KEY_2 ^ SBOX_oData;
										State <= 3'd4;
									end*/
							end
						else
							State <= State;
					end
				3'd4:
					begin
						Write_to_RAM_iStart <= 1'b1;
						Write_to_RAM_iCount <= Write_to_RAM_iCount + iKC;
						State <= 3'd5;
					end
				3'd5:
					begin
						Write_to_RAM_iStart <= 1'b0;
						if(Write_to_RAM_oDone)
							begin
								if(Write_to_RAM_iCount < ROUND_KEY_COUNT_minus_KC)
									State <= 3'd6;
								else
									State <= 3'd7;
							end
						else
							State <= State;
					end
				3'd6:
					begin
						SBOX_iData_valid <= 1'b1;
						SBOX_iOrigin_data <= KEY_1;
						State <= 3'd1;
						SBOX_iData <= KEY_4;
					end
				3'd7:
					begin
						SBOX_reset <= 1'b1;
						Write_to_RAM_iCount <= 7'b0;
						State <= 3'd0;
					end
			endcase
		end
 end
 
/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
 
 SBOX_key_sm_S SBOX (
	//	Global signals
	.iClk			(iClk),
	.iRst_n			(iRst_n & ~SBOX_reset),
	
	//	Control signal
	.iSpecial_mode	(SBOX_iSpecial_mode),
	
	//	Input
	.iData_valid	(SBOX_iData_valid),
	.iData			(SBOX_iData),
	.iOrigin_data	(SBOX_iOrigin_data),
	
	//	Output
	.oData_valid	(SBOX_oData_valid),
	.oData			(SBOX_oData)
 );
 
 Makekey_write_to_RAM Write_to_RAM (
	//	Global signals
	.iClk				(iClk),
	.iRst_n				(iRst_n),
	
	//	Control signals
	.iStart				(Write_to_RAM_iStart),
	.oDone				(Write_to_RAM_oDone),
	
	//	Param
	.iKC				(iKC),
	.iBC				(iBC),
	.iRound				(iRound),
	.iCount				(Write_to_RAM_iCount),
	
	//	Data need to write
	.iKEY_1				(KEY_1),
	.iKEY_2				(KEY_2),
	.iKEY_3				(KEY_3),
	.iKEY_4				(KEY_4),
	
	//	Encrypt RAM m_Ke access
	.oRAM_Ke_addr		(oRAM_Ke_addr),
	.oRAM_Ke_write_1	(oRAM_Ke_write_1),
	.oRAM_Ke_data_1		(oRAM_Ke_data_1),
	.oRAM_Ke_write_2	(oRAM_Ke_write_2),
	.oRAM_Ke_data_2		(oRAM_Ke_data_2),
	.oRAM_Ke_write_3	(oRAM_Ke_write_3),
	.oRAM_Ke_data_3		(oRAM_Ke_data_3),
	.oRAM_Ke_write_4	(oRAM_Ke_write_4),
	.oRAM_Ke_data_4		(oRAM_Ke_data_4),
	
	//	Decrypt RAM m_Kd access
	.oRAM_Kd_addr		(oRAM_Kd_addr),
	.oRAM_Kd_write_1	(oRAM_Kd_write_1),
	.oRAM_Kd_data_1		(oRAM_Kd_data_1),
	.oRAM_Kd_write_2	(oRAM_Kd_write_2),
	.oRAM_Kd_data_2		(oRAM_Kd_data_2),
	.oRAM_Kd_write_3	(oRAM_Kd_write_3),
	.oRAM_Kd_data_3		(oRAM_Kd_data_3),
	.oRAM_Kd_write_4	(oRAM_Kd_write_4),
	.oRAM_Kd_data_4		(oRAM_Kd_data_4)
 );
 
endmodule 