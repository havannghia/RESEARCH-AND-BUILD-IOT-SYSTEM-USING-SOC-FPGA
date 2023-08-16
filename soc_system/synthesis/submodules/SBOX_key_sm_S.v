module SBOX_key_sm_S (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Control signal
	input				iSpecial_mode,
	
	//	Input
	input				iData_valid,
	input		[31:0]	iData,
	input		[31:0]	iOrigin_data,
	
	//	Output
	output	reg			oData_valid,
	output		[31:0]	oData
);

/*****************************************************************************
 *                              ROM Declarations                             *
 *****************************************************************************/
 
 reg	[7:0]	sm_S[0:255];
 reg	[7:0]	sm_rcon[0:31];
 
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 reg	[31:0]	Shifted_iOrigin_Data;
 
 reg	[4:0]	rconpointer;
 
 reg	[7:0]	SBOX_data_1,
				SBOX_data_2,
				SBOX_data_3,
				SBOX_data_4;
				
 reg	[7:0]	SBOX_sm_rcon;
 
 wire	[7:0]	Data_OUT_1,
				Data_OUT_2,
				Data_OUT_3,
				Data_OUT_4;
 
/*****************************************************************************
 *                                ROM initial                                *
 *****************************************************************************/

 initial begin
 
	//	sm_S
	sm_S[0] = 8'h63;	sm_S[1] = 8'h7c;	sm_S[2] = 8'h77;	sm_S[3] = 8'h7b;	sm_S[4] = 8'hf2;	sm_S[5] = 8'h6b;	sm_S[6] = 8'h6f;	sm_S[7] = 8'hc5;	sm_S[8] = 8'h30;	sm_S[9] = 8'h01;	sm_S[10] = 8'h67;	sm_S[11] = 8'h2b;	sm_S[12] = 8'hfe;	sm_S[13] = 8'hd7;	sm_S[14] = 8'hab;	sm_S[15] = 8'h76;
	sm_S[16] = 8'hca;	sm_S[17] = 8'h82;	sm_S[18] = 8'hc9;	sm_S[19] = 8'h7d;	sm_S[20] = 8'hfa;	sm_S[21] = 8'h59;	sm_S[22] = 8'h47;	sm_S[23] = 8'hf0;	sm_S[24] = 8'had;	sm_S[25] = 8'hd4;	sm_S[26] = 8'ha2;	sm_S[27] = 8'haf;	sm_S[28] = 8'h9c;	sm_S[29] = 8'ha4;	sm_S[30] = 8'h72;	sm_S[31] = 8'hc0;
	sm_S[32] = 8'hb7;	sm_S[33] = 8'hfd;	sm_S[34] = 8'h93;	sm_S[35] = 8'h26;	sm_S[36] = 8'h36;	sm_S[37] = 8'h3f;	sm_S[38] = 8'hf7;	sm_S[39] = 8'hcc;	sm_S[40] = 8'h34;	sm_S[41] = 8'ha5;	sm_S[42] = 8'he5;	sm_S[43] = 8'hf1;	sm_S[44] = 8'h71;	sm_S[45] = 8'hd8;	sm_S[46] = 8'h31;	sm_S[47] = 8'h15;
	sm_S[48] = 8'h04;	sm_S[49] = 8'hc7;	sm_S[50] = 8'h23;	sm_S[51] = 8'hc3;	sm_S[52] = 8'h18;	sm_S[53] = 8'h96;	sm_S[54] = 8'h05;	sm_S[55] = 8'h9a;	sm_S[56] = 8'h07;	sm_S[57] = 8'h12;	sm_S[58] = 8'h80;	sm_S[59] = 8'he2;	sm_S[60] = 8'heb;	sm_S[61] = 8'h27;	sm_S[62] = 8'hb2;	sm_S[63] = 8'h75;
	sm_S[64] = 8'h09;	sm_S[65] = 8'h83;	sm_S[66] = 8'h2c;	sm_S[67] = 8'h1a;	sm_S[68] = 8'h1b;	sm_S[69] = 8'h6e;	sm_S[70] = 8'h5a;	sm_S[71] = 8'ha0;	sm_S[72] = 8'h52;	sm_S[73] = 8'h3b;	sm_S[74] = 8'hd6;	sm_S[75] = 8'hb3;	sm_S[76] = 8'h29;	sm_S[77] = 8'he3;	sm_S[78] = 8'h2f;	sm_S[79] = 8'h84;
	sm_S[80] = 8'h53;	sm_S[81] = 8'hd1;	sm_S[82] = 8'h00;	sm_S[83] = 8'hed;	sm_S[84] = 8'h20;	sm_S[85] = 8'hfc;	sm_S[86] = 8'hb1;	sm_S[87] = 8'h5b;	sm_S[88] = 8'h6a;	sm_S[89] = 8'hcb;	sm_S[90] = 8'hbe;	sm_S[91] = 8'h39;	sm_S[92] = 8'h4a;	sm_S[93] = 8'h4c;	sm_S[94] = 8'h58;	sm_S[95] = 8'hcf;
	sm_S[96] = 8'hd0;	sm_S[97] = 8'hef;	sm_S[98] = 8'haa;	sm_S[99] = 8'hfb;	sm_S[100] = 8'h43;	sm_S[101] = 8'h4d;	sm_S[102] = 8'h33;	sm_S[103] = 8'h85;	sm_S[104] = 8'h45;	sm_S[105] = 8'hf9;	sm_S[106] = 8'h02;	sm_S[107] = 8'h7f;	sm_S[108] = 8'h50;	sm_S[109] = 8'h3c;	sm_S[110] = 8'h9f;	sm_S[111] = 8'ha8;
	sm_S[112] = 8'h51;	sm_S[113] = 8'ha3;	sm_S[114] = 8'h40;	sm_S[115] = 8'h8f;	sm_S[116] = 8'h92;	sm_S[117] = 8'h9d;	sm_S[118] = 8'h38;	sm_S[119] = 8'hf5;	sm_S[120] = 8'hbc;	sm_S[121] = 8'hb6;	sm_S[122] = 8'hda;	sm_S[123] = 8'h21;	sm_S[124] = 8'h10;	sm_S[125] = 8'hff;	sm_S[126] = 8'hf3;	sm_S[127] = 8'hd2;
	sm_S[128] = 8'hcd;	sm_S[129] = 8'h0c;	sm_S[130] = 8'h13;	sm_S[131] = 8'hec;	sm_S[132] = 8'h5f;	sm_S[133] = 8'h97;	sm_S[134] = 8'h44;	sm_S[135] = 8'h17;	sm_S[136] = 8'hc4;	sm_S[137] = 8'ha7;	sm_S[138] = 8'h7e;	sm_S[139] = 8'h3d;	sm_S[140] = 8'h64;	sm_S[141] = 8'h5d;	sm_S[142] = 8'h19;	sm_S[143] = 8'h73;
	sm_S[144] = 8'h60;	sm_S[145] = 8'h81;	sm_S[146] = 8'h4f;	sm_S[147] = 8'hdc;	sm_S[148] = 8'h22;	sm_S[149] = 8'h2a;	sm_S[150] = 8'h90;	sm_S[151] = 8'h88;	sm_S[152] = 8'h46;	sm_S[153] = 8'hee;	sm_S[154] = 8'hb8;	sm_S[155] = 8'h14;	sm_S[156] = 8'hde;	sm_S[157] = 8'h5e;	sm_S[158] = 8'h0b;	sm_S[159] = 8'hdb;
	sm_S[160] = 8'he0;	sm_S[161] = 8'h32;	sm_S[162] = 8'h3a;	sm_S[163] = 8'h0a;	sm_S[164] = 8'h49;	sm_S[165] = 8'h06;	sm_S[166] = 8'h24;	sm_S[167] = 8'h5c;	sm_S[168] = 8'hc2;	sm_S[169] = 8'hd3;	sm_S[170] = 8'hac;	sm_S[171] = 8'h62;	sm_S[172] = 8'h91;	sm_S[173] = 8'h95;	sm_S[174] = 8'he4;	sm_S[175] = 8'h79;
	sm_S[176] = 8'he7;	sm_S[177] = 8'hc8;	sm_S[178] = 8'h37;	sm_S[179] = 8'h6d;	sm_S[180] = 8'h8d;	sm_S[181] = 8'hd5;	sm_S[182] = 8'h4e;	sm_S[183] = 8'ha9;	sm_S[184] = 8'h6c;	sm_S[185] = 8'h56;	sm_S[186] = 8'hf4;	sm_S[187] = 8'hea;	sm_S[188] = 8'h65;	sm_S[189] = 8'h7a;	sm_S[190] = 8'hae;	sm_S[191] = 8'h08;
	sm_S[192] = 8'hba;	sm_S[193] = 8'h78;	sm_S[194] = 8'h25;	sm_S[195] = 8'h2e;	sm_S[196] = 8'h1c;	sm_S[197] = 8'ha6;	sm_S[198] = 8'hb4;	sm_S[199] = 8'hc6;	sm_S[200] = 8'he8;	sm_S[201] = 8'hdd;	sm_S[202] = 8'h74;	sm_S[203] = 8'h1f;	sm_S[204] = 8'h4b;	sm_S[205] = 8'hbd;	sm_S[206] = 8'h8b;	sm_S[207] = 8'h8a;
	sm_S[208] = 8'h70;	sm_S[209] = 8'h3e;	sm_S[210] = 8'hb5;	sm_S[211] = 8'h66;	sm_S[212] = 8'h48;	sm_S[213] = 8'h03;	sm_S[214] = 8'hf6;	sm_S[215] = 8'h0e;	sm_S[216] = 8'h61;	sm_S[217] = 8'h35;	sm_S[218] = 8'h57;	sm_S[219] = 8'hb9;	sm_S[220] = 8'h86;	sm_S[221] = 8'hc1;	sm_S[222] = 8'h1d;	sm_S[223] = 8'h9e;
	sm_S[224] = 8'he1;	sm_S[225] = 8'hf8;	sm_S[226] = 8'h98;	sm_S[227] = 8'h11;	sm_S[228] = 8'h69;	sm_S[229] = 8'hd9;	sm_S[230] = 8'h8e;	sm_S[231] = 8'h94;	sm_S[232] = 8'h9b;	sm_S[233] = 8'h1e;	sm_S[234] = 8'h87;	sm_S[235] = 8'he9;	sm_S[236] = 8'hce;	sm_S[237] = 8'h55;	sm_S[238] = 8'h28;	sm_S[239] = 8'hdf;
	sm_S[240] = 8'h8c;	sm_S[241] = 8'ha1;	sm_S[242] = 8'h89;	sm_S[243] = 8'h0d;	sm_S[244] = 8'hbf;	sm_S[245] = 8'he6;	sm_S[246] = 8'h42;	sm_S[247] = 8'h68;	sm_S[248] = 8'h41;	sm_S[249] = 8'h99;	sm_S[250] = 8'h2d;	sm_S[251] = 8'h0f;	sm_S[252] = 8'hb0;	sm_S[253] = 8'h54;	sm_S[254] = 8'hbb;	sm_S[255] = 8'h16;

	//	sm_rcon
	sm_rcon[0] = 8'h01;		sm_rcon[1] = 8'h02;		sm_rcon[2] = 8'h04;		sm_rcon[3] = 8'h08;		sm_rcon[4] = 8'h10;		sm_rcon[5] = 8'h20;		sm_rcon[6] = 8'h40;		sm_rcon[7] = 8'h80;
	sm_rcon[8] = 8'h1b;		sm_rcon[9] = 8'h36;		sm_rcon[10] = 8'h6c;	sm_rcon[11] = 8'hd8;	sm_rcon[12] = 8'hab;	sm_rcon[13] = 8'h4d;	sm_rcon[14] = 8'h9a;	sm_rcon[15] = 8'h2f;
	sm_rcon[16] = 8'h5e;	sm_rcon[17] = 8'hbc;	sm_rcon[18] = 8'h63;	sm_rcon[19] = 8'hc6;	sm_rcon[20] = 8'h97;	sm_rcon[21] = 8'h35;	sm_rcon[22] = 8'h6a;	sm_rcon[23] = 8'hd4;
	sm_rcon[24] = 8'hb3;	sm_rcon[25] = 8'h7d;	sm_rcon[26] = 8'hfa;	sm_rcon[27] = 8'hef;	sm_rcon[28] = 8'hc5;	sm_rcon[29] = 8'h91;	sm_rcon[30] = 8'h00;	sm_rcon[31] = 8'h00;
	
 end
 
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
 assign oData = {Data_OUT_1, Data_OUT_2, Data_OUT_3, Data_OUT_4} ^ Shifted_iOrigin_Data;
 
 assign Data_OUT_1 = (iSpecial_mode) ? SBOX_data_1 : (SBOX_data_2 ^ SBOX_sm_rcon);
 assign Data_OUT_2 = (iSpecial_mode) ? SBOX_data_2 : SBOX_data_3;
 assign Data_OUT_3 = (iSpecial_mode) ? SBOX_data_3 : SBOX_data_4;
 assign Data_OUT_4 = (iSpecial_mode) ? SBOX_data_4 : SBOX_data_1;
 
/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		oData_valid <= 1'b0;
	else
		oData_valid <= iData_valid;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		Shifted_iOrigin_Data <= 32'b0;
	else if(iData_valid)
		Shifted_iOrigin_Data <= iOrigin_data;
	else
		Shifted_iOrigin_Data <= Shifted_iOrigin_Data;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		rconpointer <= 5'b0;
	else if(iData_valid & ~iSpecial_mode)//rconpointer++ when iSpecial_mode = 0, first state in keyexpand - Phat
		rconpointer <= rconpointer + 1'b1;
	else
		rconpointer <= rconpointer;
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			SBOX_data_1 <= 8'b0;
			SBOX_data_2 <= 8'b0;
			SBOX_data_3 <= 8'b0;
			SBOX_data_4 <= 8'b0;
		end
	else if(iData_valid)
		begin
			SBOX_data_1 <= sm_S[iData[31:24]];
			SBOX_data_2 <= sm_S[iData[23:16]];
			SBOX_data_3 <= sm_S[iData[15:8]];
			SBOX_data_4 <= sm_S[iData[7:0]];
		end
	else
		begin
			SBOX_data_1 <= SBOX_data_1;
			SBOX_data_2 <= SBOX_data_2;
			SBOX_data_3 <= SBOX_data_3;
			SBOX_data_4 <= SBOX_data_4;
		end
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		SBOX_sm_rcon <= 8'b0;
	else if(iData_valid)
		SBOX_sm_rcon <= sm_rcon[rconpointer];
	else
		SBOX_sm_rcon <= SBOX_sm_rcon;
 end
 
endmodule 