module Last_round (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Param
	input				iEndec,
	input		[3:0]	iSize,
	
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
	output	reg			oData_valid,
	output		[31:0]	oData_1,
	output		[31:0]	oData_2,
	output		[31:0]	oData_3,
	output		[31:0]	oData_4
 );
 
/*****************************************************************************
 *                              ROM Declarations                             *
 *****************************************************************************/
 
 //	Box for encypt
 reg	[7:0]	sm_S[0:255];
 
 //	Box for decrypt
 reg	[7:0]	sm_Si[0:255];
 
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

 //	Transform SBOX
 reg	[7:0]	Data_1_1_SBOX,
				Data_1_2_SBOX,
				Data_1_3_SBOX,
				Data_1_4_SBOX;
				
 reg	[7:0]	Data_2_1_SBOX,
				Data_2_2_SBOX,
				Data_2_3_SBOX,
				Data_2_4_SBOX;
				
 reg	[7:0]	Data_3_1_SBOX,
				Data_3_2_SBOX,
				Data_3_3_SBOX,
				Data_3_4_SBOX;
				
 reg	[7:0]	Data_4_1_SBOX,
				Data_4_2_SBOX,
				Data_4_3_SBOX,
				Data_4_4_SBOX;

 //	Transfrom SHIFT and MIX
 wire	[7:0]	Data_1_1_SHIFT_and_MIX,
				Data_1_2_SHIFT_and_MIX,
				Data_1_3_SHIFT_and_MIX,
				Data_1_4_SHIFT_and_MIX;
				
 wire	[7:0]	Data_2_1_SHIFT_and_MIX,
				Data_2_2_SHIFT_and_MIX,
				Data_2_3_SHIFT_and_MIX,
				Data_2_4_SHIFT_and_MIX;
				
 wire	[7:0]	Data_3_1_SHIFT_and_MIX,
				Data_3_2_SHIFT_and_MIX,
				Data_3_3_SHIFT_and_MIX,
				Data_3_4_SHIFT_and_MIX;
				
 wire	[7:0]	Data_4_1_SHIFT_and_MIX,
				Data_4_2_SHIFT_and_MIX,
				Data_4_3_SHIFT_and_MIX,
				Data_4_4_SHIFT_and_MIX;
 
 //	Transform ADD ROUND KEY
 wire	[7:0]	Data_1_1_OUT,
				Data_1_2_OUT,
				Data_1_3_OUT,
				Data_1_4_OUT;
				
 wire	[7:0]	Data_2_1_OUT,
				Data_2_2_OUT,
				Data_2_3_OUT,
				Data_2_4_OUT;
				
 wire	[7:0]	Data_3_1_OUT,
				Data_3_2_OUT,
				Data_3_3_OUT,
				Data_3_4_OUT;
				
 wire	[7:0]	Data_4_1_OUT,
				Data_4_2_OUT,
				Data_4_3_OUT,
				Data_4_4_OUT;
 
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
	
	//	sm_Si
	sm_Si[0] = 8'h52;	sm_Si[1] = 8'h09;	sm_Si[2] = 8'h6a;	sm_Si[3] = 8'hd5;	sm_Si[4] = 8'h30;	sm_Si[5] = 8'h36;	sm_Si[6] = 8'ha5;	sm_Si[7] = 8'h38;	sm_Si[8] = 8'hbf;	sm_Si[9] = 8'h40;	sm_Si[10] = 8'ha3;	sm_Si[11] = 8'h9e;	sm_Si[12] = 8'h81;	sm_Si[13] = 8'hf3;	sm_Si[14] = 8'hd7;	sm_Si[15] = 8'hfb;
	sm_Si[16] = 8'h7c;	sm_Si[17] = 8'he3;	sm_Si[18] = 8'h39;	sm_Si[19] = 8'h82;	sm_Si[20] = 8'h9b;	sm_Si[21] = 8'h2f;	sm_Si[22] = 8'hff;	sm_Si[23] = 8'h87;	sm_Si[24] = 8'h34;	sm_Si[25] = 8'h8e;	sm_Si[26] = 8'h43;	sm_Si[27] = 8'h44;	sm_Si[28] = 8'hc4;	sm_Si[29] = 8'hde;	sm_Si[30] = 8'he9;	sm_Si[31] = 8'hcb;
	sm_Si[32] = 8'h54;	sm_Si[33] = 8'h7b;	sm_Si[34] = 8'h94;	sm_Si[35] = 8'h32;	sm_Si[36] = 8'ha6;	sm_Si[37] = 8'hc2;	sm_Si[38] = 8'h23;	sm_Si[39] = 8'h3d;	sm_Si[40] = 8'hee;	sm_Si[41] = 8'h4c;	sm_Si[42] = 8'h95;	sm_Si[43] = 8'h0b;	sm_Si[44] = 8'h42;	sm_Si[45] = 8'hfa;	sm_Si[46] = 8'hc3;	sm_Si[47] = 8'h4e;
	sm_Si[48] = 8'h08;	sm_Si[49] = 8'h2e;	sm_Si[50] = 8'ha1;	sm_Si[51] = 8'h66;	sm_Si[52] = 8'h28;	sm_Si[53] = 8'hd9;	sm_Si[54] = 8'h24;	sm_Si[55] = 8'hb2;	sm_Si[56] = 8'h76;	sm_Si[57] = 8'h5b;	sm_Si[58] = 8'ha2;	sm_Si[59] = 8'h49;	sm_Si[60] = 8'h6d;	sm_Si[61] = 8'h8b;	sm_Si[62] = 8'hd1;	sm_Si[63] = 8'h25;
	sm_Si[64] = 8'h72;	sm_Si[65] = 8'hf8;	sm_Si[66] = 8'hf6;	sm_Si[67] = 8'h64;	sm_Si[68] = 8'h86;	sm_Si[69] = 8'h68;	sm_Si[70] = 8'h98;	sm_Si[71] = 8'h16;	sm_Si[72] = 8'hd4;	sm_Si[73] = 8'ha4;	sm_Si[74] = 8'h5c;	sm_Si[75] = 8'hcc;	sm_Si[76] = 8'h5d;	sm_Si[77] = 8'h65;	sm_Si[78] = 8'hb6;	sm_Si[79] = 8'h92;
	sm_Si[80] = 8'h6c;	sm_Si[81] = 8'h70;	sm_Si[82] = 8'h48;	sm_Si[83] = 8'h50;	sm_Si[84] = 8'hfd;	sm_Si[85] = 8'hed;	sm_Si[86] = 8'hb9;	sm_Si[87] = 8'hda;	sm_Si[88] = 8'h5e;	sm_Si[89] = 8'h15;	sm_Si[90] = 8'h46;	sm_Si[91] = 8'h57;	sm_Si[92] = 8'ha7;	sm_Si[93] = 8'h8d;	sm_Si[94] = 8'h9d;	sm_Si[95] = 8'h84;
	sm_Si[96] = 8'h90;	sm_Si[97] = 8'hd8;	sm_Si[98] = 8'hab;	sm_Si[99] = 8'h00;	sm_Si[100] = 8'h8c;	sm_Si[101] = 8'hbc;	sm_Si[102] = 8'hd3;	sm_Si[103] = 8'h0a;	sm_Si[104] = 8'hf7;	sm_Si[105] = 8'he4;	sm_Si[106] = 8'h58;	sm_Si[107] = 8'h05;	sm_Si[108] = 8'hb8;	sm_Si[109] = 8'hb3;	sm_Si[110] = 8'h45;	sm_Si[111] = 8'h06;
	sm_Si[112] = 8'hd0;	sm_Si[113] = 8'h2c;	sm_Si[114] = 8'h1e;	sm_Si[115] = 8'h8f;	sm_Si[116] = 8'hca;	sm_Si[117] = 8'h3f;	sm_Si[118] = 8'h0f;	sm_Si[119] = 8'h02;	sm_Si[120] = 8'hc1;	sm_Si[121] = 8'haf;	sm_Si[122] = 8'hbd;	sm_Si[123] = 8'h03;	sm_Si[124] = 8'h01;	sm_Si[125] = 8'h13;	sm_Si[126] = 8'h8a;	sm_Si[127] = 8'h6b;
	sm_Si[128] = 8'h3a;	sm_Si[129] = 8'h91;	sm_Si[130] = 8'h11;	sm_Si[131] = 8'h41;	sm_Si[132] = 8'h4f;	sm_Si[133] = 8'h67;	sm_Si[134] = 8'hdc;	sm_Si[135] = 8'hea;	sm_Si[136] = 8'h97;	sm_Si[137] = 8'hf2;	sm_Si[138] = 8'hcf;	sm_Si[139] = 8'hce;	sm_Si[140] = 8'hf0;	sm_Si[141] = 8'hb4;	sm_Si[142] = 8'he6;	sm_Si[143] = 8'h73;
	sm_Si[144] = 8'h96;	sm_Si[145] = 8'hac;	sm_Si[146] = 8'h74;	sm_Si[147] = 8'h22;	sm_Si[148] = 8'he7;	sm_Si[149] = 8'had;	sm_Si[150] = 8'h35;	sm_Si[151] = 8'h85;	sm_Si[152] = 8'he2;	sm_Si[153] = 8'hf9;	sm_Si[154] = 8'h37;	sm_Si[155] = 8'he8;	sm_Si[156] = 8'h1c;	sm_Si[157] = 8'h75;	sm_Si[158] = 8'hdf;	sm_Si[159] = 8'h6e;
	sm_Si[160] = 8'h47;	sm_Si[161] = 8'hf1;	sm_Si[162] = 8'h1a;	sm_Si[163] = 8'h71;	sm_Si[164] = 8'h1d;	sm_Si[165] = 8'h29;	sm_Si[166] = 8'hc5;	sm_Si[167] = 8'h89;	sm_Si[168] = 8'h6f;	sm_Si[169] = 8'hb7;	sm_Si[170] = 8'h62;	sm_Si[171] = 8'h0e;	sm_Si[172] = 8'haa;	sm_Si[173] = 8'h18;	sm_Si[174] = 8'hbe;	sm_Si[175] = 8'h1b;
	sm_Si[176] = 8'hfc;	sm_Si[177] = 8'h56;	sm_Si[178] = 8'h3e;	sm_Si[179] = 8'h4b;	sm_Si[180] = 8'hc6;	sm_Si[181] = 8'hd2;	sm_Si[182] = 8'h79;	sm_Si[183] = 8'h20;	sm_Si[184] = 8'h9a;	sm_Si[185] = 8'hdb;	sm_Si[186] = 8'hc0;	sm_Si[187] = 8'hfe;	sm_Si[188] = 8'h78;	sm_Si[189] = 8'hcd;	sm_Si[190] = 8'h5a;	sm_Si[191] = 8'hf4;
	sm_Si[192] = 8'h1f;	sm_Si[193] = 8'hdd;	sm_Si[194] = 8'ha8;	sm_Si[195] = 8'h33;	sm_Si[196] = 8'h88;	sm_Si[197] = 8'h07;	sm_Si[198] = 8'hc7;	sm_Si[199] = 8'h31;	sm_Si[200] = 8'hb1;	sm_Si[201] = 8'h12;	sm_Si[202] = 8'h10;	sm_Si[203] = 8'h59;	sm_Si[204] = 8'h27;	sm_Si[205] = 8'h80;	sm_Si[206] = 8'hec;	sm_Si[207] = 8'h5f;
	sm_Si[208] = 8'h60;	sm_Si[209] = 8'h51;	sm_Si[210] = 8'h7f;	sm_Si[211] = 8'ha9;	sm_Si[212] = 8'h19;	sm_Si[213] = 8'hb5;	sm_Si[214] = 8'h4a;	sm_Si[215] = 8'h0d;	sm_Si[216] = 8'h2d;	sm_Si[217] = 8'he5;	sm_Si[218] = 8'h7a;	sm_Si[219] = 8'h9f;	sm_Si[220] = 8'h93;	sm_Si[221] = 8'hc9;	sm_Si[222] = 8'h9c;	sm_Si[223] = 8'hef;
	sm_Si[224] = 8'ha0;	sm_Si[225] = 8'he0;	sm_Si[226] = 8'h3b;	sm_Si[227] = 8'h4d;	sm_Si[228] = 8'hae;	sm_Si[229] = 8'h2a;	sm_Si[230] = 8'hf5;	sm_Si[231] = 8'hb0;	sm_Si[232] = 8'hc8;	sm_Si[233] = 8'heb;	sm_Si[234] = 8'hbb;	sm_Si[235] = 8'h3c;	sm_Si[236] = 8'h83;	sm_Si[237] = 8'h53;	sm_Si[238] = 8'h99;	sm_Si[239] = 8'h61;
	sm_Si[240] = 8'h17;	sm_Si[241] = 8'h2b;	sm_Si[242] = 8'h04;	sm_Si[243] = 8'h7e;	sm_Si[244] = 8'hba;	sm_Si[245] = 8'h77;	sm_Si[246] = 8'hd6;	sm_Si[247] = 8'h26;	sm_Si[248] = 8'he1;	sm_Si[249] = 8'h69;	sm_Si[250] = 8'h14;	sm_Si[251] = 8'h63;	sm_Si[252] = 8'h55;	sm_Si[253] = 8'h21;	sm_Si[254] = 8'h0c;	sm_Si[255] = 8'h7d;
	
 end
 
/*****************************************************************************
 *                                  Data OUT                                 *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		oData_valid <= 1'b0;
	else
		oData_valid <= iData_valid;
 end
 
 assign oData_1 = {Data_1_1_OUT, Data_1_2_OUT, Data_1_3_OUT, Data_1_4_OUT};
 assign oData_2 = {Data_2_1_OUT, Data_2_2_OUT, Data_2_3_OUT, Data_2_4_OUT};
 assign oData_3 = {Data_3_1_OUT, Data_3_2_OUT, Data_3_3_OUT, Data_3_4_OUT};
 assign oData_4 = {Data_4_1_OUT, Data_4_2_OUT, Data_4_3_OUT, Data_4_4_OUT};
 
/*****************************************************************************
 *                              TRANSFORM SBOX                               *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Data_1_1_SBOX <= 8'b0;
			Data_1_2_SBOX <= 8'b0;
			Data_1_3_SBOX <= 8'b0;
			Data_1_4_SBOX <= 8'b0;
		end
	else if(iData_valid)
		begin
			if(iEndec)
				begin
					Data_1_1_SBOX <= sm_Si[iData_1[31:24]];
					Data_1_2_SBOX <= sm_Si[iData_1[23:16]];
					Data_1_3_SBOX <= sm_Si[iData_1[15:8]];
					Data_1_4_SBOX <= sm_Si[iData_1[7:0]];
				end
			else
				begin
					Data_1_1_SBOX <= sm_S[iData_1[31:24]];
					Data_1_2_SBOX <= sm_S[iData_1[23:16]];
					Data_1_3_SBOX <= sm_S[iData_1[15:8]];
					Data_1_4_SBOX <= sm_S[iData_1[7:0]];
				end
		end
	else
		begin
			Data_1_1_SBOX <= Data_1_1_SBOX;
			Data_1_2_SBOX <= Data_1_2_SBOX;
			Data_1_3_SBOX <= Data_1_3_SBOX;
			Data_1_4_SBOX <= Data_1_4_SBOX;
		end
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Data_2_1_SBOX <= 8'b0;
			Data_2_2_SBOX <= 8'b0;
			Data_2_3_SBOX <= 8'b0;
			Data_2_4_SBOX <= 8'b0;
		end
	else if(iData_valid)
		begin
			if(iEndec)
				begin
					Data_2_1_SBOX <= sm_Si[iData_2[31:24]];
					Data_2_2_SBOX <= sm_Si[iData_2[23:16]];
					Data_2_3_SBOX <= sm_Si[iData_2[15:8]];
					Data_2_4_SBOX <= sm_Si[iData_2[7:0]];
				end
			else
				begin
					Data_2_1_SBOX <= sm_S[iData_2[31:24]];
					Data_2_2_SBOX <= sm_S[iData_2[23:16]];
					Data_2_3_SBOX <= sm_S[iData_2[15:8]];
					Data_2_4_SBOX <= sm_S[iData_2[7:0]];
				end
		end
	else
		begin
			Data_2_1_SBOX <= Data_2_1_SBOX;
			Data_2_2_SBOX <= Data_2_2_SBOX;
			Data_2_3_SBOX <= Data_2_3_SBOX;
			Data_2_4_SBOX <= Data_2_4_SBOX;
		end
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Data_3_1_SBOX <= 8'b0;
			Data_3_2_SBOX <= 8'b0;
			Data_3_3_SBOX <= 8'b0;
			Data_3_4_SBOX <= 8'b0;
		end
	else if(iData_valid)
		begin
			if(iEndec)
				begin
					Data_3_1_SBOX <= sm_Si[iData_3[31:24]];
					Data_3_2_SBOX <= sm_Si[iData_3[23:16]];
					Data_3_3_SBOX <= sm_Si[iData_3[15:8]];
					Data_3_4_SBOX <= sm_Si[iData_3[7:0]];
				end
			else
				begin
					Data_3_1_SBOX <= sm_S[iData_3[31:24]];
					Data_3_2_SBOX <= sm_S[iData_3[23:16]];
					Data_3_3_SBOX <= sm_S[iData_3[15:8]];
					Data_3_4_SBOX <= sm_S[iData_3[7:0]];
				end
		end
	else
		begin
			Data_3_1_SBOX <= Data_3_1_SBOX;
			Data_3_2_SBOX <= Data_3_2_SBOX;
			Data_3_3_SBOX <= Data_3_3_SBOX;
			Data_3_4_SBOX <= Data_3_4_SBOX;
		end
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Data_4_1_SBOX <= 8'b0;
			Data_4_2_SBOX <= 8'b0;
			Data_4_3_SBOX <= 8'b0;
			Data_4_4_SBOX <= 8'b0;
		end
	else if(iData_valid)
		begin
			if(iEndec)
				begin
					Data_4_1_SBOX <= sm_Si[iData_4[31:24]];
					Data_4_2_SBOX <= sm_Si[iData_4[23:16]];
					Data_4_3_SBOX <= sm_Si[iData_4[15:8]];
					Data_4_4_SBOX <= sm_Si[iData_4[7:0]];
				end
			else
				begin
					Data_4_1_SBOX <= sm_S[iData_4[31:24]];
					Data_4_2_SBOX <= sm_S[iData_4[23:16]];
					Data_4_3_SBOX <= sm_S[iData_4[15:8]];
					Data_4_4_SBOX <= sm_S[iData_4[7:0]];
				end
		end
	else
		begin
			Data_4_1_SBOX <= Data_4_1_SBOX;
			Data_4_2_SBOX <= Data_4_2_SBOX;
			Data_4_3_SBOX <= Data_4_3_SBOX;
			Data_4_4_SBOX <= Data_4_4_SBOX;
		end
 end

 
/*****************************************************************************
 *                          TRANSFORM SHIFT AND MIX                          *
 *****************************************************************************/
 
 assign Data_1_1_SHIFT_and_MIX = Data_1_1_SBOX;

 assign Data_1_2_SHIFT_and_MIX = (iEndec) ? Data_4_2_SBOX : Data_2_2_SBOX;
 assign Data_1_3_SHIFT_and_MIX = (iEndec) ? Data_3_3_SBOX : Data_3_3_SBOX;
 assign Data_1_4_SHIFT_and_MIX = (iEndec) ? Data_2_4_SBOX : Data_4_4_SBOX;
 
 assign Data_2_1_SHIFT_and_MIX = Data_2_1_SBOX;
 assign Data_2_2_SHIFT_and_MIX = (iEndec) ? Data_1_2_SBOX : Data_3_2_SBOX;
 assign Data_2_3_SHIFT_and_MIX = (iEndec) ? Data_4_3_SBOX : Data_4_3_SBOX;
 assign Data_2_4_SHIFT_and_MIX = (iEndec) ? Data_3_4_SBOX : Data_1_4_SBOX;
 
 assign Data_3_1_SHIFT_and_MIX = Data_3_1_SBOX;
 assign Data_3_2_SHIFT_and_MIX = (iEndec) ? Data_2_2_SBOX : Data_4_2_SBOX;
 assign Data_3_3_SHIFT_and_MIX = (iEndec) ? Data_1_3_SBOX : Data_1_3_SBOX;
 assign Data_3_4_SHIFT_and_MIX = (iEndec) ? Data_4_4_SBOX : Data_2_4_SBOX;
 
 assign Data_4_1_SHIFT_and_MIX = Data_4_1_SBOX;
 assign Data_4_2_SHIFT_and_MIX = (iEndec) ? Data_3_2_SBOX : Data_1_2_SBOX;
 assign Data_4_3_SHIFT_and_MIX = (iEndec) ? Data_2_3_SBOX : Data_2_3_SBOX;
 assign Data_4_4_SHIFT_and_MIX = (iEndec) ? Data_1_4_SBOX : Data_3_4_SBOX;
 
/*****************************************************************************
 *                          TRANSFORM ADD ROUND KEY                          *
 *****************************************************************************/
 
 assign Data_1_1_OUT = iRAM_data_1[31:24] ^ Data_1_1_SHIFT_and_MIX;
 assign Data_1_2_OUT = iRAM_data_1[23:16] ^ Data_1_2_SHIFT_and_MIX;
 assign Data_1_3_OUT = iRAM_data_1[15:8] ^ Data_1_3_SHIFT_and_MIX;
 assign Data_1_4_OUT = iRAM_data_1[7:0] ^ Data_1_4_SHIFT_and_MIX;
 
 assign Data_2_1_OUT = iRAM_data_2[31:24] ^ Data_2_1_SHIFT_and_MIX;
 assign Data_2_2_OUT = iRAM_data_2[23:16] ^ Data_2_2_SHIFT_and_MIX;
 assign Data_2_3_OUT = iRAM_data_2[15:8] ^ Data_2_3_SHIFT_and_MIX;
 assign Data_2_4_OUT = iRAM_data_2[7:0] ^ Data_2_4_SHIFT_and_MIX;
 
 assign Data_3_1_OUT = iRAM_data_3[31:24] ^ Data_3_1_SHIFT_and_MIX;
 assign Data_3_2_OUT = iRAM_data_3[23:16] ^ Data_3_2_SHIFT_and_MIX;
 assign Data_3_3_OUT = iRAM_data_3[15:8] ^ Data_3_3_SHIFT_and_MIX;
 assign Data_3_4_OUT = iRAM_data_3[7:0] ^ Data_3_4_SHIFT_and_MIX;
 
 assign Data_4_1_OUT = iRAM_data_4[31:24] ^ Data_4_1_SHIFT_and_MIX;
 assign Data_4_2_OUT = iRAM_data_4[23:16] ^ Data_4_2_SHIFT_and_MIX;
 assign Data_4_3_OUT = iRAM_data_4[15:8] ^ Data_4_3_SHIFT_and_MIX;
 assign Data_4_4_OUT = iRAM_data_4[7:0] ^ Data_4_4_SHIFT_and_MIX;
 
endmodule 