module First_round_key (
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
	
	//	Encrypt RAM m_Ke access
	output	reg	[3:0]	oRAM_Ke_addr,
	output				oRAM_Ke_write_1,
	output		[31:0]	oRAM_Ke_data_1,
	output				oRAM_Ke_write_2,
	output		[31:0]	oRAM_Ke_data_2,
	output				oRAM_Ke_write_3,
	output		[31:0]	oRAM_Ke_data_3,
	output				oRAM_Ke_write_4,
	output		[31:0]	oRAM_Ke_data_4,
	
	//	Decrypt RAM m_Kd access
	output	reg	[3:0]	oRAM_Kd_addr,
	output				oRAM_Kd_write_1,
	output		[31:0]	oRAM_Kd_data_1,
	output				oRAM_Kd_write_2,
	output		[31:0]	oRAM_Kd_data_2,
	output				oRAM_Kd_write_3,
	output		[31:0]	oRAM_Kd_data_3,
	output				oRAM_Kd_write_4,
	output		[31:0]	oRAM_Kd_data_4,
	
	//	Signals to Main round key
	output	reg			oLast_key_data_valid,
	output		[31:0]	oLast_key_data
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 //	Buffer IN
 reg	[31:0]	Key_1;
 reg	[31:0]	Key_2;
 reg	[31:0]	Key_3;
 reg	[31:0]	Key_4;
 
 //	Buffer OUT
 wire	[31:0]	Last_key_data_pre;
 
 //	FSM
 reg	[2:0]	State;
 reg			FSM_write;
 

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 //	Buffer OUT
 assign oLast_key_data = Key_4;
 
 // For Encrypt RAM
 assign oRAM_Ke_data_1 = Key_1;
 assign oRAM_Ke_data_2 = Key_2;
 assign oRAM_Ke_data_3 = Key_3;
 assign oRAM_Ke_data_4 = Key_4;

 assign oRAM_Ke_write_1 = FSM_write & ~State[2];
 assign oRAM_Ke_write_2 = FSM_write & ~State[2];
 assign oRAM_Ke_write_3 = FSM_write & ~State[2];
 assign oRAM_Ke_write_4 = FSM_write & ~State[2];

 
 //	For Decrypt RAM
 assign oRAM_Kd_data_1 = Key_1;
 assign oRAM_Kd_data_2 = Key_2;
 assign oRAM_Kd_data_3 = Key_3;
 assign oRAM_Kd_data_4 = Key_4;

 assign oRAM_Kd_write_1 = FSM_write & ~State[2];
 assign oRAM_Kd_write_2 = FSM_write & ~State[2];
 assign oRAM_Kd_write_3 = FSM_write & ~State[2];
 assign oRAM_Kd_write_4 = FSM_write & ~State[2];
 
/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 //	Buffer IN
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Key_1 <= 32'b0;
			Key_2 <= 32'b0;
			Key_3 <= 32'b0;
			Key_4 <= 32'b0;
		end
	else if(iKey_load)
		begin
			Key_1 <= iKey_data_1;
			Key_2 <= iKey_data_2;
			Key_3 <= iKey_data_3;
			Key_4 <= iKey_data_4;
		end
	else
		begin
			Key_1 <= Key_1;
			Key_2 <= Key_2;
			Key_3 <= Key_3;
			Key_4 <= Key_4;
		end
 end
 
/*****************************************************************************
 *                           Finite State Machine                            *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			State <= 3'd0;
			FSM_write <= 1'b0;
			oRAM_Ke_addr <= 4'b0;
			oRAM_Kd_addr <= 4'b0;
			oLast_key_data_valid <= 1'b0;
		end
	else
		begin
			case(State)
				3'd0:
					begin
						oLast_key_data_valid <= 1'b0;
						if(iKey_load)
							State <= 3'd1;
						else
							State <= State;
					end
				3'd1:
					begin
						FSM_write <= 1'b1;
						oRAM_Ke_addr <= 4'b0;
						oRAM_Kd_addr <= iRound;//store data opposite Ke.
						State <= 3'd2;
					end
				3'd2:
					begin
						FSM_write <= 1'b0;
						/*if(BC_smaller_KC)
							State <= 3'd3;
						else*/
							State <= 3'd4;
					end
				/*3'd3:
					begin
						FSM_write <= 1'b1;
						oRAM_Ke_addr <= 4'd1;
						oRAM_Kd_addr <= oRAM_Kd_addr - 1'b1;
						State <= 3'd4;
					end*/
				3'd4:
					begin
						FSM_write <= 1'b0;
						oLast_key_data_valid <= 1'b1;
						State <= 3'd0;
					end
				default: State <= State;
			endcase
		end
 end
 
endmodule 