module Standard_round (
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
 
 //	Box for Encrypt
 reg	[31:0]	sm_T1[0:255];
 reg	[31:0]	sm_T2[0:255];
 reg	[31:0]	sm_T3[0:255];
 reg	[31:0]	sm_T4[0:255];
 
 //	Box for Decrypt
 reg	[31:0]	sm_T5[0:255];
 reg	[31:0]	sm_T6[0:255];
 reg	[31:0]	sm_T7[0:255];
 reg	[31:0]	sm_T8[0:255];
 
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
				
 //	Transform -> SBOX Step
 reg	[31:0]	Data_1_1_SBOX,
				Data_1_2_SBOX,
				Data_1_3_SBOX,
				Data_1_4_SBOX;
				
 reg	[31:0]	Data_2_1_SBOX,
				Data_2_2_SBOX,
				Data_2_3_SBOX,
				Data_2_4_SBOX;
				
 reg	[31:0]	Data_3_1_SBOX,
				Data_3_2_SBOX,
				Data_3_3_SBOX,
				Data_3_4_SBOX;
			
 reg	[31:0]	Data_4_1_SBOX,
				Data_4_2_SBOX,
				Data_4_3_SBOX,
				Data_4_4_SBOX;
				
 //	Transform -> SHIFT AND MIX Step
 wire	[31:0]	Data_1_SHIFT_and_MIX_en;
 wire	[31:0]	Data_2_SHIFT_and_MIX_en;
 wire	[31:0]	Data_3_SHIFT_and_MIX_en;
 wire	[31:0]	Data_4_SHIFT_and_MIX_en;
 
 wire	[31:0]	Data_1_SHIFT_and_MIX_de;
 wire	[31:0]	Data_2_SHIFT_and_MIX_de;
 wire	[31:0]	Data_3_SHIFT_and_MIX_de;
 wire	[31:0]	Data_4_SHIFT_and_MIX_de;
 
 wire	[31:0]	Data_1_SHIFT_and_MIX;
 wire	[31:0]	Data_2_SHIFT_and_MIX;
 wire	[31:0]	Data_3_SHIFT_and_MIX;
 wire	[31:0]	Data_4_SHIFT_and_MIX;
 
 //	Transform -> ADD ROUND KEY Step
 wire	[31:0]	Data_1_ADD_ROUND_KEY;
 wire	[31:0]	Data_2_ADD_ROUND_KEY;
 wire	[31:0]	Data_3_ADD_ROUND_KEY;
 wire	[31:0]	Data_4_ADD_ROUND_KEY;
				
/*****************************************************************************
 *                                ROM initial                                *
 *****************************************************************************/
/* Phat
        sm_T1[x] = Sbox[x].[02, 01, 01, 03];
        sm_T2[x] = Sbox[x].[03, 02, 01, 01];
        sm_T3[x] = Sbox[x].[01, 03, 02, 01];
        sm_T4[x] = Sbox[x].[01, 01, 03, 02];

        sm_T5[x] = Ibox[x].[0e, 09, 0d, 0b];
        sm_T6[x] = Ibox[x].[0b, 0e, 09, 0d];
        sm_T7[x] = Ibox[x].[0d, 0b, 0e, 09];
        sm_T8[x] = Ibox[x].[09, 0d, 0b, 0e];
		(maybe module x^8 + x^4 + x^3 + x + 1)
*/
 initial begin

	//	sm_T1
	sm_T1[0] = 32'hc66363a5;	sm_T1[1] = 32'hf87c7c84;	sm_T1[2] = 32'hee777799;	sm_T1[3] = 32'hf67b7b8d;	sm_T1[4] = 32'hfff2f20d;	sm_T1[5] = 32'hd66b6bbd;	sm_T1[6] = 32'hde6f6fb1;	sm_T1[7] = 32'h91c5c554;	sm_T1[8] = 32'h60303050;	sm_T1[9] = 32'h02010103;	sm_T1[10] = 32'hce6767a9;	sm_T1[11] = 32'h562b2b7d;	sm_T1[12] = 32'he7fefe19;	sm_T1[13] = 32'hb5d7d762;	sm_T1[14] = 32'h4dababe6;	sm_T1[15] = 32'hec76769a;
	sm_T1[16] = 32'h8fcaca45;	sm_T1[17] = 32'h1f82829d;	sm_T1[18] = 32'h89c9c940;	sm_T1[19] = 32'hfa7d7d87;	sm_T1[20] = 32'heffafa15;	sm_T1[21] = 32'hb25959eb;	sm_T1[22] = 32'h8e4747c9;	sm_T1[23] = 32'hfbf0f00b;	sm_T1[24] = 32'h41adadec;	sm_T1[25] = 32'hb3d4d467;	sm_T1[26] = 32'h5fa2a2fd;	sm_T1[27] = 32'h45afafea;	sm_T1[28] = 32'h239c9cbf;	sm_T1[29] = 32'h53a4a4f7;	sm_T1[30] = 32'he4727296;	sm_T1[31] = 32'h9bc0c05b;
	sm_T1[32] = 32'h75b7b7c2;	sm_T1[33] = 32'he1fdfd1c;	sm_T1[34] = 32'h3d9393ae;	sm_T1[35] = 32'h4c26266a;	sm_T1[36] = 32'h6c36365a;	sm_T1[37] = 32'h7e3f3f41;	sm_T1[38] = 32'hf5f7f702;	sm_T1[39] = 32'h83cccc4f;	sm_T1[40] = 32'h6834345c;	sm_T1[41] = 32'h51a5a5f4;	sm_T1[42] = 32'hd1e5e534;	sm_T1[43] = 32'hf9f1f108;	sm_T1[44] = 32'he2717193;	sm_T1[45] = 32'habd8d873;	sm_T1[46] = 32'h62313153;	sm_T1[47] = 32'h2a15153f;
	sm_T1[48] = 32'h0804040c;	sm_T1[49] = 32'h95c7c752;	sm_T1[50] = 32'h46232365;	sm_T1[51] = 32'h9dc3c35e;	sm_T1[52] = 32'h30181828;	sm_T1[53] = 32'h379696a1;	sm_T1[54] = 32'h0a05050f;	sm_T1[55] = 32'h2f9a9ab5;	sm_T1[56] = 32'h0e070709;	sm_T1[57] = 32'h24121236;	sm_T1[58] = 32'h1b80809b;	sm_T1[59] = 32'hdfe2e23d;	sm_T1[60] = 32'hcdebeb26;	sm_T1[61] = 32'h4e272769;	sm_T1[62] = 32'h7fb2b2cd;	sm_T1[63] = 32'hea75759f;
	sm_T1[64] = 32'h1209091b;	sm_T1[65] = 32'h1d83839e;	sm_T1[66] = 32'h582c2c74;	sm_T1[67] = 32'h341a1a2e;	sm_T1[68] = 32'h361b1b2d;	sm_T1[69] = 32'hdc6e6eb2;	sm_T1[70] = 32'hb45a5aee;	sm_T1[71] = 32'h5ba0a0fb;	sm_T1[72] = 32'ha45252f6;	sm_T1[73] = 32'h763b3b4d;	sm_T1[74] = 32'hb7d6d661;	sm_T1[75] = 32'h7db3b3ce;	sm_T1[76] = 32'h5229297b;	sm_T1[77] = 32'hdde3e33e;	sm_T1[78] = 32'h5e2f2f71;	sm_T1[79] = 32'h13848497;
	sm_T1[80] = 32'ha65353f5;	sm_T1[81] = 32'hb9d1d168;	sm_T1[82] = 32'h00000000;	sm_T1[83] = 32'hc1eded2c;	sm_T1[84] = 32'h40202060;	sm_T1[85] = 32'he3fcfc1f;	sm_T1[86] = 32'h79b1b1c8;	sm_T1[87] = 32'hb65b5bed;	sm_T1[88] = 32'hd46a6abe;	sm_T1[89] = 32'h8dcbcb46;	sm_T1[90] = 32'h67bebed9;	sm_T1[91] = 32'h7239394b;	sm_T1[92] = 32'h944a4ade;	sm_T1[93] = 32'h984c4cd4;	sm_T1[94] = 32'hb05858e8;	sm_T1[95] = 32'h85cfcf4a;
	sm_T1[96] = 32'hbbd0d06b;	sm_T1[97] = 32'hc5efef2a;	sm_T1[98] = 32'h4faaaae5;	sm_T1[99] = 32'hedfbfb16;	sm_T1[100] = 32'h864343c5;	sm_T1[101] = 32'h9a4d4dd7;	sm_T1[102] = 32'h66333355;	sm_T1[103] = 32'h11858594;	sm_T1[104] = 32'h8a4545cf;	sm_T1[105] = 32'he9f9f910;	sm_T1[106] = 32'h04020206;	sm_T1[107] = 32'hfe7f7f81;	sm_T1[108] = 32'ha05050f0;	sm_T1[109] = 32'h783c3c44;	sm_T1[110] = 32'h259f9fba;	sm_T1[111] = 32'h4ba8a8e3;
	sm_T1[112] = 32'ha25151f3;	sm_T1[113] = 32'h5da3a3fe;	sm_T1[114] = 32'h804040c0;	sm_T1[115] = 32'h058f8f8a;	sm_T1[116] = 32'h3f9292ad;	sm_T1[117] = 32'h219d9dbc;	sm_T1[118] = 32'h70383848;	sm_T1[119] = 32'hf1f5f504;	sm_T1[120] = 32'h63bcbcdf;	sm_T1[121] = 32'h77b6b6c1;	sm_T1[122] = 32'hafdada75;	sm_T1[123] = 32'h42212163;	sm_T1[124] = 32'h20101030;	sm_T1[125] = 32'he5ffff1a;	sm_T1[126] = 32'hfdf3f30e;	sm_T1[127] = 32'hbfd2d26d;
	sm_T1[128] = 32'h81cdcd4c;	sm_T1[129] = 32'h180c0c14;	sm_T1[130] = 32'h26131335;	sm_T1[131] = 32'hc3ecec2f;	sm_T1[132] = 32'hbe5f5fe1;	sm_T1[133] = 32'h359797a2;	sm_T1[134] = 32'h884444cc;	sm_T1[135] = 32'h2e171739;	sm_T1[136] = 32'h93c4c457;	sm_T1[137] = 32'h55a7a7f2;	sm_T1[138] = 32'hfc7e7e82;	sm_T1[139] = 32'h7a3d3d47;	sm_T1[140] = 32'hc86464ac;	sm_T1[141] = 32'hba5d5de7;	sm_T1[142] = 32'h3219192b;	sm_T1[143] = 32'he6737395;
	sm_T1[144] = 32'hc06060a0;	sm_T1[145] = 32'h19818198;	sm_T1[146] = 32'h9e4f4fd1;	sm_T1[147] = 32'ha3dcdc7f;	sm_T1[148] = 32'h44222266;	sm_T1[149] = 32'h542a2a7e;	sm_T1[150] = 32'h3b9090ab;	sm_T1[151] = 32'h0b888883;	sm_T1[152] = 32'h8c4646ca;	sm_T1[153] = 32'hc7eeee29;	sm_T1[154] = 32'h6bb8b8d3;	sm_T1[155] = 32'h2814143c;	sm_T1[156] = 32'ha7dede79;	sm_T1[157] = 32'hbc5e5ee2;	sm_T1[158] = 32'h160b0b1d;	sm_T1[159] = 32'haddbdb76;
	sm_T1[160] = 32'hdbe0e03b;	sm_T1[161] = 32'h64323256;	sm_T1[162] = 32'h743a3a4e;	sm_T1[163] = 32'h140a0a1e;	sm_T1[164] = 32'h924949db;	sm_T1[165] = 32'h0c06060a;	sm_T1[166] = 32'h4824246c;	sm_T1[167] = 32'hb85c5ce4;	sm_T1[168] = 32'h9fc2c25d;	sm_T1[169] = 32'hbdd3d36e;	sm_T1[170] = 32'h43acacef;	sm_T1[171] = 32'hc46262a6;	sm_T1[172] = 32'h399191a8;	sm_T1[173] = 32'h319595a4;	sm_T1[174] = 32'hd3e4e437;	sm_T1[175] = 32'hf279798b;
	sm_T1[176] = 32'hd5e7e732;	sm_T1[177] = 32'h8bc8c843;	sm_T1[178] = 32'h6e373759;	sm_T1[179] = 32'hda6d6db7;	sm_T1[180] = 32'h018d8d8c;	sm_T1[181] = 32'hb1d5d564;	sm_T1[182] = 32'h9c4e4ed2;	sm_T1[183] = 32'h49a9a9e0;	sm_T1[184] = 32'hd86c6cb4;	sm_T1[185] = 32'hac5656fa;	sm_T1[186] = 32'hf3f4f407;	sm_T1[187] = 32'hcfeaea25;	sm_T1[188] = 32'hca6565af;	sm_T1[189] = 32'hf47a7a8e;	sm_T1[190] = 32'h47aeaee9;	sm_T1[191] = 32'h10080818;
	sm_T1[192] = 32'h6fbabad5;	sm_T1[193] = 32'hf0787888;	sm_T1[194] = 32'h4a25256f;	sm_T1[195] = 32'h5c2e2e72;	sm_T1[196] = 32'h381c1c24;	sm_T1[197] = 32'h57a6a6f1;	sm_T1[198] = 32'h73b4b4c7;	sm_T1[199] = 32'h97c6c651;	sm_T1[200] = 32'hcbe8e823;	sm_T1[201] = 32'ha1dddd7c;	sm_T1[202] = 32'he874749c;	sm_T1[203] = 32'h3e1f1f21;	sm_T1[204] = 32'h964b4bdd;	sm_T1[205] = 32'h61bdbddc;	sm_T1[206] = 32'h0d8b8b86;	sm_T1[207] = 32'h0f8a8a85;
	sm_T1[208] = 32'he0707090;	sm_T1[209] = 32'h7c3e3e42;	sm_T1[210] = 32'h71b5b5c4;	sm_T1[211] = 32'hcc6666aa;	sm_T1[212] = 32'h904848d8;	sm_T1[213] = 32'h06030305;	sm_T1[214] = 32'hf7f6f601;	sm_T1[215] = 32'h1c0e0e12;	sm_T1[216] = 32'hc26161a3;	sm_T1[217] = 32'h6a35355f;	sm_T1[218] = 32'hae5757f9;	sm_T1[219] = 32'h69b9b9d0;	sm_T1[220] = 32'h17868691;	sm_T1[221] = 32'h99c1c158;	sm_T1[222] = 32'h3a1d1d27;	sm_T1[223] = 32'h279e9eb9;
	sm_T1[224] = 32'hd9e1e138;	sm_T1[225] = 32'hebf8f813;	sm_T1[226] = 32'h2b9898b3;	sm_T1[227] = 32'h22111133;	sm_T1[228] = 32'hd26969bb;	sm_T1[229] = 32'ha9d9d970;	sm_T1[230] = 32'h078e8e89;	sm_T1[231] = 32'h339494a7;	sm_T1[232] = 32'h2d9b9bb6;	sm_T1[233] = 32'h3c1e1e22;	sm_T1[234] = 32'h15878792;	sm_T1[235] = 32'hc9e9e920;	sm_T1[236] = 32'h87cece49;	sm_T1[237] = 32'haa5555ff;	sm_T1[238] = 32'h50282878;	sm_T1[239] = 32'ha5dfdf7a;
	sm_T1[240] = 32'h038c8c8f;	sm_T1[241] = 32'h59a1a1f8;	sm_T1[242] = 32'h09898980;	sm_T1[243] = 32'h1a0d0d17;	sm_T1[244] = 32'h65bfbfda;	sm_T1[245] = 32'hd7e6e631;	sm_T1[246] = 32'h844242c6;	sm_T1[247] = 32'hd06868b8;	sm_T1[248] = 32'h824141c3;	sm_T1[249] = 32'h299999b0;	sm_T1[250] = 32'h5a2d2d77;	sm_T1[251] = 32'h1e0f0f11;	sm_T1[252] = 32'h7bb0b0cb;	sm_T1[253] = 32'ha85454fc;	sm_T1[254] = 32'h6dbbbbd6;	sm_T1[255] = 32'h2c16163a;
	
	//	sm_T2
	sm_T2[0] = 32'ha5c66363;	sm_T2[1] = 32'h84f87c7c;	sm_T2[2] = 32'h99ee7777;	sm_T2[3] = 32'h8df67b7b;	sm_T2[4] = 32'h0dfff2f2;	sm_T2[5] = 32'hbdd66b6b;	sm_T2[6] = 32'hb1de6f6f;	sm_T2[7] = 32'h5491c5c5;	sm_T2[8] = 32'h50603030;	sm_T2[9] = 32'h03020101;	sm_T2[10] = 32'ha9ce6767;	sm_T2[11] = 32'h7d562b2b;	sm_T2[12] = 32'h19e7fefe;	sm_T2[13] = 32'h62b5d7d7;	sm_T2[14] = 32'he64dabab;	sm_T2[15] = 32'h9aec7676;
	sm_T2[16] = 32'h458fcaca;	sm_T2[17] = 32'h9d1f8282;	sm_T2[18] = 32'h4089c9c9;	sm_T2[19] = 32'h87fa7d7d;	sm_T2[20] = 32'h15effafa;	sm_T2[21] = 32'hebb25959;	sm_T2[22] = 32'hc98e4747;	sm_T2[23] = 32'h0bfbf0f0;	sm_T2[24] = 32'hec41adad;	sm_T2[25] = 32'h67b3d4d4;	sm_T2[26] = 32'hfd5fa2a2;	sm_T2[27] = 32'hea45afaf;	sm_T2[28] = 32'hbf239c9c;	sm_T2[29] = 32'hf753a4a4;	sm_T2[30] = 32'h96e47272;	sm_T2[31] = 32'h5b9bc0c0;
	sm_T2[32] = 32'hc275b7b7;	sm_T2[33] = 32'h1ce1fdfd;	sm_T2[34] = 32'hae3d9393;	sm_T2[35] = 32'h6a4c2626;	sm_T2[36] = 32'h5a6c3636;	sm_T2[37] = 32'h417e3f3f;	sm_T2[38] = 32'h02f5f7f7;	sm_T2[39] = 32'h4f83cccc;	sm_T2[40] = 32'h5c683434;	sm_T2[41] = 32'hf451a5a5;	sm_T2[42] = 32'h34d1e5e5;	sm_T2[43] = 32'h08f9f1f1;	sm_T2[44] = 32'h93e27171;	sm_T2[45] = 32'h73abd8d8;	sm_T2[46] = 32'h53623131;	sm_T2[47] = 32'h3f2a1515;
	sm_T2[48] = 32'h0c080404;	sm_T2[49] = 32'h5295c7c7;	sm_T2[50] = 32'h65462323;	sm_T2[51] = 32'h5e9dc3c3;	sm_T2[52] = 32'h28301818;	sm_T2[53] = 32'ha1379696;	sm_T2[54] = 32'h0f0a0505;	sm_T2[55] = 32'hb52f9a9a;	sm_T2[56] = 32'h090e0707;	sm_T2[57] = 32'h36241212;	sm_T2[58] = 32'h9b1b8080;	sm_T2[59] = 32'h3ddfe2e2;	sm_T2[60] = 32'h26cdebeb;	sm_T2[61] = 32'h694e2727;	sm_T2[62] = 32'hcd7fb2b2;	sm_T2[63] = 32'h9fea7575;
	sm_T2[64] = 32'h1b120909;	sm_T2[65] = 32'h9e1d8383;	sm_T2[66] = 32'h74582c2c;	sm_T2[67] = 32'h2e341a1a;	sm_T2[68] = 32'h2d361b1b;	sm_T2[69] = 32'hb2dc6e6e;	sm_T2[70] = 32'heeb45a5a;	sm_T2[71] = 32'hfb5ba0a0;	sm_T2[72] = 32'hf6a45252;	sm_T2[73] = 32'h4d763b3b;	sm_T2[74] = 32'h61b7d6d6;	sm_T2[75] = 32'hce7db3b3;	sm_T2[76] = 32'h7b522929;	sm_T2[77] = 32'h3edde3e3;	sm_T2[78] = 32'h715e2f2f;	sm_T2[79] = 32'h97138484;
	sm_T2[80] = 32'hf5a65353;	sm_T2[81] = 32'h68b9d1d1;	sm_T2[82] = 32'h00000000;	sm_T2[83] = 32'h2cc1eded;	sm_T2[84] = 32'h60402020;	sm_T2[85] = 32'h1fe3fcfc;	sm_T2[86] = 32'hc879b1b1;	sm_T2[87] = 32'hedb65b5b;	sm_T2[88] = 32'hbed46a6a;	sm_T2[89] = 32'h468dcbcb;	sm_T2[90] = 32'hd967bebe;	sm_T2[91] = 32'h4b723939;	sm_T2[92] = 32'hde944a4a;	sm_T2[93] = 32'hd4984c4c;	sm_T2[94] = 32'he8b05858;	sm_T2[95] = 32'h4a85cfcf;
	sm_T2[96] = 32'h6bbbd0d0;	sm_T2[97] = 32'h2ac5efef;	sm_T2[98] = 32'he54faaaa;	sm_T2[99] = 32'h16edfbfb;	sm_T2[100] = 32'hc5864343;	sm_T2[101] = 32'hd79a4d4d;	sm_T2[102] = 32'h55663333;	sm_T2[103] = 32'h94118585;	sm_T2[104] = 32'hcf8a4545;	sm_T2[105] = 32'h10e9f9f9;	sm_T2[106] = 32'h06040202;	sm_T2[107] = 32'h81fe7f7f;	sm_T2[108] = 32'hf0a05050;	sm_T2[109] = 32'h44783c3c;	sm_T2[110] = 32'hba259f9f;	sm_T2[111] = 32'he34ba8a8;
	sm_T2[112] = 32'hf3a25151;	sm_T2[113] = 32'hfe5da3a3;	sm_T2[114] = 32'hc0804040;	sm_T2[115] = 32'h8a058f8f;	sm_T2[116] = 32'had3f9292;	sm_T2[117] = 32'hbc219d9d;	sm_T2[118] = 32'h48703838;	sm_T2[119] = 32'h04f1f5f5;	sm_T2[120] = 32'hdf63bcbc;	sm_T2[121] = 32'hc177b6b6;	sm_T2[122] = 32'h75afdada;	sm_T2[123] = 32'h63422121;	sm_T2[124] = 32'h30201010;	sm_T2[125] = 32'h1ae5ffff;	sm_T2[126] = 32'h0efdf3f3;	sm_T2[127] = 32'h6dbfd2d2;
	sm_T2[128] = 32'h4c81cdcd;	sm_T2[129] = 32'h14180c0c;	sm_T2[130] = 32'h35261313;	sm_T2[131] = 32'h2fc3ecec;	sm_T2[132] = 32'he1be5f5f;	sm_T2[133] = 32'ha2359797;	sm_T2[134] = 32'hcc884444;	sm_T2[135] = 32'h392e1717;	sm_T2[136] = 32'h5793c4c4;	sm_T2[137] = 32'hf255a7a7;	sm_T2[138] = 32'h82fc7e7e;	sm_T2[139] = 32'h477a3d3d;	sm_T2[140] = 32'hacc86464;	sm_T2[141] = 32'he7ba5d5d;	sm_T2[142] = 32'h2b321919;	sm_T2[143] = 32'h95e67373;
	sm_T2[144] = 32'ha0c06060;	sm_T2[145] = 32'h98198181;	sm_T2[146] = 32'hd19e4f4f;	sm_T2[147] = 32'h7fa3dcdc;	sm_T2[148] = 32'h66442222;	sm_T2[149] = 32'h7e542a2a;	sm_T2[150] = 32'hab3b9090;	sm_T2[151] = 32'h830b8888;	sm_T2[152] = 32'hca8c4646;	sm_T2[153] = 32'h29c7eeee;	sm_T2[154] = 32'hd36bb8b8;	sm_T2[155] = 32'h3c281414;	sm_T2[156] = 32'h79a7dede;	sm_T2[157] = 32'he2bc5e5e;	sm_T2[158] = 32'h1d160b0b;	sm_T2[159] = 32'h76addbdb;
	sm_T2[160] = 32'h3bdbe0e0;	sm_T2[161] = 32'h56643232;	sm_T2[162] = 32'h4e743a3a;	sm_T2[163] = 32'h1e140a0a;	sm_T2[164] = 32'hdb924949;	sm_T2[165] = 32'h0a0c0606;	sm_T2[166] = 32'h6c482424;	sm_T2[167] = 32'he4b85c5c;	sm_T2[168] = 32'h5d9fc2c2;	sm_T2[169] = 32'h6ebdd3d3;	sm_T2[170] = 32'hef43acac;	sm_T2[171] = 32'ha6c46262;	sm_T2[172] = 32'ha8399191;	sm_T2[173] = 32'ha4319595;	sm_T2[174] = 32'h37d3e4e4;	sm_T2[175] = 32'h8bf27979;
	sm_T2[176] = 32'h32d5e7e7;	sm_T2[177] = 32'h438bc8c8;	sm_T2[178] = 32'h596e3737;	sm_T2[179] = 32'hb7da6d6d;	sm_T2[180] = 32'h8c018d8d;	sm_T2[181] = 32'h64b1d5d5;	sm_T2[182] = 32'hd29c4e4e;	sm_T2[183] = 32'he049a9a9;	sm_T2[184] = 32'hb4d86c6c;	sm_T2[185] = 32'hfaac5656;	sm_T2[186] = 32'h07f3f4f4;	sm_T2[187] = 32'h25cfeaea;	sm_T2[188] = 32'hafca6565;	sm_T2[189] = 32'h8ef47a7a;	sm_T2[190] = 32'he947aeae;	sm_T2[191] = 32'h18100808;
	sm_T2[192] = 32'hd56fbaba;	sm_T2[193] = 32'h88f07878;	sm_T2[194] = 32'h6f4a2525;	sm_T2[195] = 32'h725c2e2e;	sm_T2[196] = 32'h24381c1c;	sm_T2[197] = 32'hf157a6a6;	sm_T2[198] = 32'hc773b4b4;	sm_T2[199] = 32'h5197c6c6;	sm_T2[200] = 32'h23cbe8e8;	sm_T2[201] = 32'h7ca1dddd;	sm_T2[202] = 32'h9ce87474;	sm_T2[203] = 32'h213e1f1f;	sm_T2[204] = 32'hdd964b4b;	sm_T2[205] = 32'hdc61bdbd;	sm_T2[206] = 32'h860d8b8b;	sm_T2[207] = 32'h850f8a8a;
	sm_T2[208] = 32'h90e07070;	sm_T2[209] = 32'h427c3e3e;	sm_T2[210] = 32'hc471b5b5;	sm_T2[211] = 32'haacc6666;	sm_T2[212] = 32'hd8904848;	sm_T2[213] = 32'h05060303;	sm_T2[214] = 32'h01f7f6f6;	sm_T2[215] = 32'h121c0e0e;	sm_T2[216] = 32'ha3c26161;	sm_T2[217] = 32'h5f6a3535;	sm_T2[218] = 32'hf9ae5757;	sm_T2[219] = 32'hd069b9b9;	sm_T2[220] = 32'h91178686;	sm_T2[221] = 32'h5899c1c1;	sm_T2[222] = 32'h273a1d1d;	sm_T2[223] = 32'hb9279e9e;
	sm_T2[224] = 32'h38d9e1e1;	sm_T2[225] = 32'h13ebf8f8;	sm_T2[226] = 32'hb32b9898;	sm_T2[227] = 32'h33221111;	sm_T2[228] = 32'hbbd26969;	sm_T2[229] = 32'h70a9d9d9;	sm_T2[230] = 32'h89078e8e;	sm_T2[231] = 32'ha7339494;	sm_T2[232] = 32'hb62d9b9b;	sm_T2[233] = 32'h223c1e1e;	sm_T2[234] = 32'h92158787;	sm_T2[235] = 32'h20c9e9e9;	sm_T2[236] = 32'h4987cece;	sm_T2[237] = 32'hffaa5555;	sm_T2[238] = 32'h78502828;	sm_T2[239] = 32'h7aa5dfdf;
	sm_T2[240] = 32'h8f038c8c;	sm_T2[241] = 32'hf859a1a1;	sm_T2[242] = 32'h80098989;	sm_T2[243] = 32'h171a0d0d;	sm_T2[244] = 32'hda65bfbf;	sm_T2[245] = 32'h31d7e6e6;	sm_T2[246] = 32'hc6844242;	sm_T2[247] = 32'hb8d06868;	sm_T2[248] = 32'hc3824141;	sm_T2[249] = 32'hb0299999;	sm_T2[250] = 32'h775a2d2d;	sm_T2[251] = 32'h111e0f0f;	sm_T2[252] = 32'hcb7bb0b0;	sm_T2[253] = 32'hfca85454;	sm_T2[254] = 32'hd66dbbbb;	sm_T2[255] = 32'h3a2c1616;
	
	//	sm_T3
	sm_T3[0] = 32'h63a5c663;	sm_T3[1] = 32'h7c84f87c;	sm_T3[2] = 32'h7799ee77;	sm_T3[3] = 32'h7b8df67b;	sm_T3[4] = 32'hf20dfff2;	sm_T3[5] = 32'h6bbdd66b;	sm_T3[6] = 32'h6fb1de6f;	sm_T3[7] = 32'hc55491c5;	sm_T3[8] = 32'h30506030;	sm_T3[9] = 32'h01030201;	sm_T3[10] = 32'h67a9ce67;	sm_T3[11] = 32'h2b7d562b;	sm_T3[12] = 32'hfe19e7fe;	sm_T3[13] = 32'hd762b5d7;	sm_T3[14] = 32'habe64dab;	sm_T3[15] = 32'h769aec76;
	sm_T3[16] = 32'hca458fca;	sm_T3[17] = 32'h829d1f82;	sm_T3[18] = 32'hc94089c9;	sm_T3[19] = 32'h7d87fa7d;	sm_T3[20] = 32'hfa15effa;	sm_T3[21] = 32'h59ebb259;	sm_T3[22] = 32'h47c98e47;	sm_T3[23] = 32'hf00bfbf0;	sm_T3[24] = 32'hadec41ad;	sm_T3[25] = 32'hd467b3d4;	sm_T3[26] = 32'ha2fd5fa2;	sm_T3[27] = 32'hafea45af;	sm_T3[28] = 32'h9cbf239c;	sm_T3[29] = 32'ha4f753a4;	sm_T3[30] = 32'h7296e472;	sm_T3[31] = 32'hc05b9bc0;
	sm_T3[32] = 32'hb7c275b7;	sm_T3[33] = 32'hfd1ce1fd;	sm_T3[34] = 32'h93ae3d93;	sm_T3[35] = 32'h266a4c26;	sm_T3[36] = 32'h365a6c36;	sm_T3[37] = 32'h3f417e3f;	sm_T3[38] = 32'hf702f5f7;	sm_T3[39] = 32'hcc4f83cc;	sm_T3[40] = 32'h345c6834;	sm_T3[41] = 32'ha5f451a5;	sm_T3[42] = 32'he534d1e5;	sm_T3[43] = 32'hf108f9f1;	sm_T3[44] = 32'h7193e271;	sm_T3[45] = 32'hd873abd8;	sm_T3[46] = 32'h31536231;	sm_T3[47] = 32'h153f2a15;
	sm_T3[48] = 32'h040c0804;	sm_T3[49] = 32'hc75295c7;	sm_T3[50] = 32'h23654623;	sm_T3[51] = 32'hc35e9dc3;	sm_T3[52] = 32'h18283018;	sm_T3[53] = 32'h96a13796;	sm_T3[54] = 32'h050f0a05;	sm_T3[55] = 32'h9ab52f9a;	sm_T3[56] = 32'h07090e07;	sm_T3[57] = 32'h12362412;	sm_T3[58] = 32'h809b1b80;	sm_T3[59] = 32'he23ddfe2;	sm_T3[60] = 32'heb26cdeb;	sm_T3[61] = 32'h27694e27;	sm_T3[62] = 32'hb2cd7fb2;	sm_T3[63] = 32'h759fea75;
	sm_T3[64] = 32'h091b1209;	sm_T3[65] = 32'h839e1d83;	sm_T3[66] = 32'h2c74582c;	sm_T3[67] = 32'h1a2e341a;	sm_T3[68] = 32'h1b2d361b;	sm_T3[69] = 32'h6eb2dc6e;	sm_T3[70] = 32'h5aeeb45a;	sm_T3[71] = 32'ha0fb5ba0;	sm_T3[72] = 32'h52f6a452;	sm_T3[73] = 32'h3b4d763b;	sm_T3[74] = 32'hd661b7d6;	sm_T3[75] = 32'hb3ce7db3;	sm_T3[76] = 32'h297b5229;	sm_T3[77] = 32'he33edde3;	sm_T3[78] = 32'h2f715e2f;	sm_T3[79] = 32'h84971384;
	sm_T3[80] = 32'h53f5a653;	sm_T3[81] = 32'hd168b9d1;	sm_T3[82] = 32'h00000000;	sm_T3[83] = 32'hed2cc1ed;	sm_T3[84] = 32'h20604020;	sm_T3[85] = 32'hfc1fe3fc;	sm_T3[86] = 32'hb1c879b1;	sm_T3[87] = 32'h5bedb65b;	sm_T3[88] = 32'h6abed46a;	sm_T3[89] = 32'hcb468dcb;	sm_T3[90] = 32'hbed967be;	sm_T3[91] = 32'h394b7239;	sm_T3[92] = 32'h4ade944a;	sm_T3[93] = 32'h4cd4984c;	sm_T3[94] = 32'h58e8b058;	sm_T3[95] = 32'hcf4a85cf;
	sm_T3[96] = 32'hd06bbbd0;	sm_T3[97] = 32'hef2ac5ef;	sm_T3[98] = 32'haae54faa;	sm_T3[99] = 32'hfb16edfb;	sm_T3[100] = 32'h43c58643;	sm_T3[101] = 32'h4dd79a4d;	sm_T3[102] = 32'h33556633;	sm_T3[103] = 32'h85941185;	sm_T3[104] = 32'h45cf8a45;	sm_T3[105] = 32'hf910e9f9;	sm_T3[106] = 32'h02060402;	sm_T3[107] = 32'h7f81fe7f;	sm_T3[108] = 32'h50f0a050;	sm_T3[109] = 32'h3c44783c;	sm_T3[110] = 32'h9fba259f;	sm_T3[111] = 32'ha8e34ba8;
	sm_T3[112] = 32'h51f3a251;	sm_T3[113] = 32'ha3fe5da3;	sm_T3[114] = 32'h40c08040;	sm_T3[115] = 32'h8f8a058f;	sm_T3[116] = 32'h92ad3f92;	sm_T3[117] = 32'h9dbc219d;	sm_T3[118] = 32'h38487038;	sm_T3[119] = 32'hf504f1f5;	sm_T3[120] = 32'hbcdf63bc;	sm_T3[121] = 32'hb6c177b6;	sm_T3[122] = 32'hda75afda;	sm_T3[123] = 32'h21634221;	sm_T3[124] = 32'h10302010;	sm_T3[125] = 32'hff1ae5ff;	sm_T3[126] = 32'hf30efdf3;	sm_T3[127] = 32'hd26dbfd2;
	sm_T3[128] = 32'hcd4c81cd;	sm_T3[129] = 32'h0c14180c;	sm_T3[130] = 32'h13352613;	sm_T3[131] = 32'hec2fc3ec;	sm_T3[132] = 32'h5fe1be5f;	sm_T3[133] = 32'h97a23597;	sm_T3[134] = 32'h44cc8844;	sm_T3[135] = 32'h17392e17;	sm_T3[136] = 32'hc45793c4;	sm_T3[137] = 32'ha7f255a7;	sm_T3[138] = 32'h7e82fc7e;	sm_T3[139] = 32'h3d477a3d;	sm_T3[140] = 32'h64acc864;	sm_T3[141] = 32'h5de7ba5d;	sm_T3[142] = 32'h192b3219;	sm_T3[143] = 32'h7395e673;
	sm_T3[144] = 32'h60a0c060;	sm_T3[145] = 32'h81981981;	sm_T3[146] = 32'h4fd19e4f;	sm_T3[147] = 32'hdc7fa3dc;	sm_T3[148] = 32'h22664422;	sm_T3[149] = 32'h2a7e542a;	sm_T3[150] = 32'h90ab3b90;	sm_T3[151] = 32'h88830b88;	sm_T3[152] = 32'h46ca8c46;	sm_T3[153] = 32'hee29c7ee;	sm_T3[154] = 32'hb8d36bb8;	sm_T3[155] = 32'h143c2814;	sm_T3[156] = 32'hde79a7de;	sm_T3[157] = 32'h5ee2bc5e;	sm_T3[158] = 32'h0b1d160b;	sm_T3[159] = 32'hdb76addb;
	sm_T3[160] = 32'he03bdbe0;	sm_T3[161] = 32'h32566432;	sm_T3[162] = 32'h3a4e743a;	sm_T3[163] = 32'h0a1e140a;	sm_T3[164] = 32'h49db9249;	sm_T3[165] = 32'h060a0c06;	sm_T3[166] = 32'h246c4824;	sm_T3[167] = 32'h5ce4b85c;	sm_T3[168] = 32'hc25d9fc2;	sm_T3[169] = 32'hd36ebdd3;	sm_T3[170] = 32'hacef43ac;	sm_T3[171] = 32'h62a6c462;	sm_T3[172] = 32'h91a83991;	sm_T3[173] = 32'h95a43195;	sm_T3[174] = 32'he437d3e4;	sm_T3[175] = 32'h798bf279;
	sm_T3[176] = 32'he732d5e7;	sm_T3[177] = 32'hc8438bc8;	sm_T3[178] = 32'h37596e37;	sm_T3[179] = 32'h6db7da6d;	sm_T3[180] = 32'h8d8c018d;	sm_T3[181] = 32'hd564b1d5;	sm_T3[182] = 32'h4ed29c4e;	sm_T3[183] = 32'ha9e049a9;	sm_T3[184] = 32'h6cb4d86c;	sm_T3[185] = 32'h56faac56;	sm_T3[186] = 32'hf407f3f4;	sm_T3[187] = 32'hea25cfea;	sm_T3[188] = 32'h65afca65;	sm_T3[189] = 32'h7a8ef47a;	sm_T3[190] = 32'haee947ae;	sm_T3[191] = 32'h08181008;
	sm_T3[192] = 32'hbad56fba;	sm_T3[193] = 32'h7888f078;	sm_T3[194] = 32'h256f4a25;	sm_T3[195] = 32'h2e725c2e;	sm_T3[196] = 32'h1c24381c;	sm_T3[197] = 32'ha6f157a6;	sm_T3[198] = 32'hb4c773b4;	sm_T3[199] = 32'hc65197c6;	sm_T3[200] = 32'he823cbe8;	sm_T3[201] = 32'hdd7ca1dd;	sm_T3[202] = 32'h749ce874;	sm_T3[203] = 32'h1f213e1f;	sm_T3[204] = 32'h4bdd964b;	sm_T3[205] = 32'hbddc61bd;	sm_T3[206] = 32'h8b860d8b;	sm_T3[207] = 32'h8a850f8a;
	sm_T3[208] = 32'h7090e070;	sm_T3[209] = 32'h3e427c3e;	sm_T3[210] = 32'hb5c471b5;	sm_T3[211] = 32'h66aacc66;	sm_T3[212] = 32'h48d89048;	sm_T3[213] = 32'h03050603;	sm_T3[214] = 32'hf601f7f6;	sm_T3[215] = 32'h0e121c0e;	sm_T3[216] = 32'h61a3c261;	sm_T3[217] = 32'h355f6a35;	sm_T3[218] = 32'h57f9ae57;	sm_T3[219] = 32'hb9d069b9;	sm_T3[220] = 32'h86911786;	sm_T3[221] = 32'hc15899c1;	sm_T3[222] = 32'h1d273a1d;	sm_T3[223] = 32'h9eb9279e;
	sm_T3[224] = 32'he138d9e1;	sm_T3[225] = 32'hf813ebf8;	sm_T3[226] = 32'h98b32b98;	sm_T3[227] = 32'h11332211;	sm_T3[228] = 32'h69bbd269;	sm_T3[229] = 32'hd970a9d9;	sm_T3[230] = 32'h8e89078e;	sm_T3[231] = 32'h94a73394;	sm_T3[232] = 32'h9bb62d9b;	sm_T3[233] = 32'h1e223c1e;	sm_T3[234] = 32'h87921587;	sm_T3[235] = 32'he920c9e9;	sm_T3[236] = 32'hce4987ce;	sm_T3[237] = 32'h55ffaa55;	sm_T3[238] = 32'h28785028;	sm_T3[239] = 32'hdf7aa5df;
	sm_T3[240] = 32'h8c8f038c;	sm_T3[241] = 32'ha1f859a1;	sm_T3[242] = 32'h89800989;	sm_T3[243] = 32'h0d171a0d;	sm_T3[244] = 32'hbfda65bf;	sm_T3[245] = 32'he631d7e6;	sm_T3[246] = 32'h42c68442;	sm_T3[247] = 32'h68b8d068;	sm_T3[248] = 32'h41c38241;	sm_T3[249] = 32'h99b02999;	sm_T3[250] = 32'h2d775a2d;	sm_T3[251] = 32'h0f111e0f;	sm_T3[252] = 32'hb0cb7bb0;	sm_T3[253] = 32'h54fca854;	sm_T3[254] = 32'hbbd66dbb;	sm_T3[255] = 32'h163a2c16;
	
	//	sm_T4
	sm_T4[0] = 32'h6363a5c6;	sm_T4[1] = 32'h7c7c84f8;	sm_T4[2] = 32'h777799ee;	sm_T4[3] = 32'h7b7b8df6;	sm_T4[4] = 32'hf2f20dff;	sm_T4[5] = 32'h6b6bbdd6;	sm_T4[6] = 32'h6f6fb1de;	sm_T4[7] = 32'hc5c55491;	sm_T4[8] = 32'h30305060;	sm_T4[9] = 32'h01010302;	sm_T4[10] = 32'h6767a9ce;	sm_T4[11] = 32'h2b2b7d56;	sm_T4[12] = 32'hfefe19e7;	sm_T4[13] = 32'hd7d762b5;	sm_T4[14] = 32'hababe64d;	sm_T4[15] = 32'h76769aec;
	sm_T4[16] = 32'hcaca458f;	sm_T4[17] = 32'h82829d1f;	sm_T4[18] = 32'hc9c94089;	sm_T4[19] = 32'h7d7d87fa;	sm_T4[20] = 32'hfafa15ef;	sm_T4[21] = 32'h5959ebb2;	sm_T4[22] = 32'h4747c98e;	sm_T4[23] = 32'hf0f00bfb;	sm_T4[24] = 32'hadadec41;	sm_T4[25] = 32'hd4d467b3;	sm_T4[26] = 32'ha2a2fd5f;	sm_T4[27] = 32'hafafea45;	sm_T4[28] = 32'h9c9cbf23;	sm_T4[29] = 32'ha4a4f753;	sm_T4[30] = 32'h727296e4;	sm_T4[31] = 32'hc0c05b9b;
	sm_T4[32] = 32'hb7b7c275;	sm_T4[33] = 32'hfdfd1ce1;	sm_T4[34] = 32'h9393ae3d;	sm_T4[35] = 32'h26266a4c;	sm_T4[36] = 32'h36365a6c;	sm_T4[37] = 32'h3f3f417e;	sm_T4[38] = 32'hf7f702f5;	sm_T4[39] = 32'hcccc4f83;	sm_T4[40] = 32'h34345c68;	sm_T4[41] = 32'ha5a5f451;	sm_T4[42] = 32'he5e534d1;	sm_T4[43] = 32'hf1f108f9;	sm_T4[44] = 32'h717193e2;	sm_T4[45] = 32'hd8d873ab;	sm_T4[46] = 32'h31315362;	sm_T4[47] = 32'h15153f2a;
	sm_T4[48] = 32'h04040c08;	sm_T4[49] = 32'hc7c75295;	sm_T4[50] = 32'h23236546;	sm_T4[51] = 32'hc3c35e9d;	sm_T4[52] = 32'h18182830;	sm_T4[53] = 32'h9696a137;	sm_T4[54] = 32'h05050f0a;	sm_T4[55] = 32'h9a9ab52f;	sm_T4[56] = 32'h0707090e;	sm_T4[57] = 32'h12123624;	sm_T4[58] = 32'h80809b1b;	sm_T4[59] = 32'he2e23ddf;	sm_T4[60] = 32'hebeb26cd;	sm_T4[61] = 32'h2727694e;	sm_T4[62] = 32'hb2b2cd7f;	sm_T4[63] = 32'h75759fea;
	sm_T4[64] = 32'h09091b12;	sm_T4[65] = 32'h83839e1d;	sm_T4[66] = 32'h2c2c7458;	sm_T4[67] = 32'h1a1a2e34;	sm_T4[68] = 32'h1b1b2d36;	sm_T4[69] = 32'h6e6eb2dc;	sm_T4[70] = 32'h5a5aeeb4;	sm_T4[71] = 32'ha0a0fb5b;	sm_T4[72] = 32'h5252f6a4;	sm_T4[73] = 32'h3b3b4d76;	sm_T4[74] = 32'hd6d661b7;	sm_T4[75] = 32'hb3b3ce7d;	sm_T4[76] = 32'h29297b52;	sm_T4[77] = 32'he3e33edd;	sm_T4[78] = 32'h2f2f715e;	sm_T4[79] = 32'h84849713;
	sm_T4[80] = 32'h5353f5a6;	sm_T4[81] = 32'hd1d168b9;	sm_T4[82] = 32'h00000000;	sm_T4[83] = 32'heded2cc1;	sm_T4[84] = 32'h20206040;	sm_T4[85] = 32'hfcfc1fe3;	sm_T4[86] = 32'hb1b1c879;	sm_T4[87] = 32'h5b5bedb6;	sm_T4[88] = 32'h6a6abed4;	sm_T4[89] = 32'hcbcb468d;	sm_T4[90] = 32'hbebed967;	sm_T4[91] = 32'h39394b72;	sm_T4[92] = 32'h4a4ade94;	sm_T4[93] = 32'h4c4cd498;	sm_T4[94] = 32'h5858e8b0;	sm_T4[95] = 32'hcfcf4a85;
	sm_T4[96] = 32'hd0d06bbb;	sm_T4[97] = 32'hefef2ac5;	sm_T4[98] = 32'haaaae54f;	sm_T4[99] = 32'hfbfb16ed;	sm_T4[100] = 32'h4343c586;	sm_T4[101] = 32'h4d4dd79a;	sm_T4[102] = 32'h33335566;	sm_T4[103] = 32'h85859411;	sm_T4[104] = 32'h4545cf8a;	sm_T4[105] = 32'hf9f910e9;	sm_T4[106] = 32'h02020604;	sm_T4[107] = 32'h7f7f81fe;	sm_T4[108] = 32'h5050f0a0;	sm_T4[109] = 32'h3c3c4478;	sm_T4[110] = 32'h9f9fba25;	sm_T4[111] = 32'ha8a8e34b;
	sm_T4[112] = 32'h5151f3a2;	sm_T4[113] = 32'ha3a3fe5d;	sm_T4[114] = 32'h4040c080;	sm_T4[115] = 32'h8f8f8a05;	sm_T4[116] = 32'h9292ad3f;	sm_T4[117] = 32'h9d9dbc21;	sm_T4[118] = 32'h38384870;	sm_T4[119] = 32'hf5f504f1;	sm_T4[120] = 32'hbcbcdf63;	sm_T4[121] = 32'hb6b6c177;	sm_T4[122] = 32'hdada75af;	sm_T4[123] = 32'h21216342;	sm_T4[124] = 32'h10103020;	sm_T4[125] = 32'hffff1ae5;	sm_T4[126] = 32'hf3f30efd;	sm_T4[127] = 32'hd2d26dbf;
	sm_T4[128] = 32'hcdcd4c81;	sm_T4[129] = 32'h0c0c1418;	sm_T4[130] = 32'h13133526;	sm_T4[131] = 32'hecec2fc3;	sm_T4[132] = 32'h5f5fe1be;	sm_T4[133] = 32'h9797a235;	sm_T4[134] = 32'h4444cc88;	sm_T4[135] = 32'h1717392e;	sm_T4[136] = 32'hc4c45793;	sm_T4[137] = 32'ha7a7f255;	sm_T4[138] = 32'h7e7e82fc;	sm_T4[139] = 32'h3d3d477a;	sm_T4[140] = 32'h6464acc8;	sm_T4[141] = 32'h5d5de7ba;	sm_T4[142] = 32'h19192b32;	sm_T4[143] = 32'h737395e6;
	sm_T4[144] = 32'h6060a0c0;	sm_T4[145] = 32'h81819819;	sm_T4[146] = 32'h4f4fd19e;	sm_T4[147] = 32'hdcdc7fa3;	sm_T4[148] = 32'h22226644;	sm_T4[149] = 32'h2a2a7e54;	sm_T4[150] = 32'h9090ab3b;	sm_T4[151] = 32'h8888830b;	sm_T4[152] = 32'h4646ca8c;	sm_T4[153] = 32'heeee29c7;	sm_T4[154] = 32'hb8b8d36b;	sm_T4[155] = 32'h14143c28;	sm_T4[156] = 32'hdede79a7;	sm_T4[157] = 32'h5e5ee2bc;	sm_T4[158] = 32'h0b0b1d16;	sm_T4[159] = 32'hdbdb76ad;
	sm_T4[160] = 32'he0e03bdb;	sm_T4[161] = 32'h32325664;	sm_T4[162] = 32'h3a3a4e74;	sm_T4[163] = 32'h0a0a1e14;	sm_T4[164] = 32'h4949db92;	sm_T4[165] = 32'h06060a0c;	sm_T4[166] = 32'h24246c48;	sm_T4[167] = 32'h5c5ce4b8;	sm_T4[168] = 32'hc2c25d9f;	sm_T4[169] = 32'hd3d36ebd;	sm_T4[170] = 32'hacacef43;	sm_T4[171] = 32'h6262a6c4;	sm_T4[172] = 32'h9191a839;	sm_T4[173] = 32'h9595a431;	sm_T4[174] = 32'he4e437d3;	sm_T4[175] = 32'h79798bf2;
	sm_T4[176] = 32'he7e732d5;	sm_T4[177] = 32'hc8c8438b;	sm_T4[178] = 32'h3737596e;	sm_T4[179] = 32'h6d6db7da;	sm_T4[180] = 32'h8d8d8c01;	sm_T4[181] = 32'hd5d564b1;	sm_T4[182] = 32'h4e4ed29c;	sm_T4[183] = 32'ha9a9e049;	sm_T4[184] = 32'h6c6cb4d8;	sm_T4[185] = 32'h5656faac;	sm_T4[186] = 32'hf4f407f3;	sm_T4[187] = 32'heaea25cf;	sm_T4[188] = 32'h6565afca;	sm_T4[189] = 32'h7a7a8ef4;	sm_T4[190] = 32'haeaee947;	sm_T4[191] = 32'h08081810;
	sm_T4[192] = 32'hbabad56f;	sm_T4[193] = 32'h787888f0;	sm_T4[194] = 32'h25256f4a;	sm_T4[195] = 32'h2e2e725c;	sm_T4[196] = 32'h1c1c2438;	sm_T4[197] = 32'ha6a6f157;	sm_T4[198] = 32'hb4b4c773;	sm_T4[199] = 32'hc6c65197;	sm_T4[200] = 32'he8e823cb;	sm_T4[201] = 32'hdddd7ca1;	sm_T4[202] = 32'h74749ce8;	sm_T4[203] = 32'h1f1f213e;	sm_T4[204] = 32'h4b4bdd96;	sm_T4[205] = 32'hbdbddc61;	sm_T4[206] = 32'h8b8b860d;	sm_T4[207] = 32'h8a8a850f;
	sm_T4[208] = 32'h707090e0;	sm_T4[209] = 32'h3e3e427c;	sm_T4[210] = 32'hb5b5c471;	sm_T4[211] = 32'h6666aacc;	sm_T4[212] = 32'h4848d890;	sm_T4[213] = 32'h03030506;	sm_T4[214] = 32'hf6f601f7;	sm_T4[215] = 32'h0e0e121c;	sm_T4[216] = 32'h6161a3c2;	sm_T4[217] = 32'h35355f6a;	sm_T4[218] = 32'h5757f9ae;	sm_T4[219] = 32'hb9b9d069;	sm_T4[220] = 32'h86869117;	sm_T4[221] = 32'hc1c15899;	sm_T4[222] = 32'h1d1d273a;	sm_T4[223] = 32'h9e9eb927;
	sm_T4[224] = 32'he1e138d9;	sm_T4[225] = 32'hf8f813eb;	sm_T4[226] = 32'h9898b32b;	sm_T4[227] = 32'h11113322;	sm_T4[228] = 32'h6969bbd2;	sm_T4[229] = 32'hd9d970a9;	sm_T4[230] = 32'h8e8e8907;	sm_T4[231] = 32'h9494a733;	sm_T4[232] = 32'h9b9bb62d;	sm_T4[233] = 32'h1e1e223c;	sm_T4[234] = 32'h87879215;	sm_T4[235] = 32'he9e920c9;	sm_T4[236] = 32'hcece4987;	sm_T4[237] = 32'h5555ffaa;	sm_T4[238] = 32'h28287850;	sm_T4[239] = 32'hdfdf7aa5;
	sm_T4[240] = 32'h8c8c8f03;	sm_T4[241] = 32'ha1a1f859;	sm_T4[242] = 32'h89898009;	sm_T4[243] = 32'h0d0d171a;	sm_T4[244] = 32'hbfbfda65;	sm_T4[245] = 32'he6e631d7;	sm_T4[246] = 32'h4242c684;	sm_T4[247] = 32'h6868b8d0;	sm_T4[248] = 32'h4141c382;	sm_T4[249] = 32'h9999b029;	sm_T4[250] = 32'h2d2d775a;	sm_T4[251] = 32'h0f0f111e;	sm_T4[252] = 32'hb0b0cb7b;	sm_T4[253] = 32'h5454fca8;	sm_T4[254] = 32'hbbbbd66d;	sm_T4[255] = 32'h16163a2c;
	
	//	sm_T5
	sm_T5[0] = 32'h51f4a750;	sm_T5[1] = 32'h7e416553;	sm_T5[2] = 32'h1a17a4c3;	sm_T5[3] = 32'h3a275e96;	sm_T5[4] = 32'h3bab6bcb;	sm_T5[5] = 32'h1f9d45f1;	sm_T5[6] = 32'hacfa58ab;	sm_T5[7] = 32'h4be30393;	sm_T5[8] = 32'h2030fa55;	sm_T5[9] = 32'had766df6;	sm_T5[10] = 32'h88cc7691;	sm_T5[11] = 32'hf5024c25;	sm_T5[12] = 32'h4fe5d7fc;	sm_T5[13] = 32'hc52acbd7;	sm_T5[14] = 32'h26354480;	sm_T5[15] = 32'hb562a38f;
	sm_T5[16] = 32'hdeb15a49;	sm_T5[17] = 32'h25ba1b67;	sm_T5[18] = 32'h45ea0e98;	sm_T5[19] = 32'h5dfec0e1;	sm_T5[20] = 32'hc32f7502;	sm_T5[21] = 32'h814cf012;	sm_T5[22] = 32'h8d4697a3;	sm_T5[23] = 32'h6bd3f9c6;	sm_T5[24] = 32'h038f5fe7;	sm_T5[25] = 32'h15929c95;	sm_T5[26] = 32'hbf6d7aeb;	sm_T5[27] = 32'h955259da;	sm_T5[28] = 32'hd4be832d;	sm_T5[29] = 32'h587421d3;	sm_T5[30] = 32'h49e06929;	sm_T5[31] = 32'h8ec9c844;
	sm_T5[32] = 32'h75c2896a;	sm_T5[33] = 32'hf48e7978;	sm_T5[34] = 32'h99583e6b;	sm_T5[35] = 32'h27b971dd;	sm_T5[36] = 32'hbee14fb6;	sm_T5[37] = 32'hf088ad17;	sm_T5[38] = 32'hc920ac66;	sm_T5[39] = 32'h7dce3ab4;	sm_T5[40] = 32'h63df4a18;	sm_T5[41] = 32'he51a3182;	sm_T5[42] = 32'h97513360;	sm_T5[43] = 32'h62537f45;	sm_T5[44] = 32'hb16477e0;	sm_T5[45] = 32'hbb6bae84;	sm_T5[46] = 32'hfe81a01c;	sm_T5[47] = 32'hf9082b94;
	sm_T5[48] = 32'h70486858;	sm_T5[49] = 32'h8f45fd19;	sm_T5[50] = 32'h94de6c87;	sm_T5[51] = 32'h527bf8b7;	sm_T5[52] = 32'hab73d323;	sm_T5[53] = 32'h724b02e2;	sm_T5[54] = 32'he31f8f57;	sm_T5[55] = 32'h6655ab2a;	sm_T5[56] = 32'hb2eb2807;	sm_T5[57] = 32'h2fb5c203;	sm_T5[58] = 32'h86c57b9a;	sm_T5[59] = 32'hd33708a5;	sm_T5[60] = 32'h302887f2;	sm_T5[61] = 32'h23bfa5b2;	sm_T5[62] = 32'h02036aba;	sm_T5[63] = 32'hed16825c;
	sm_T5[64] = 32'h8acf1c2b;	sm_T5[65] = 32'ha779b492;	sm_T5[66] = 32'hf307f2f0;	sm_T5[67] = 32'h4e69e2a1;	sm_T5[68] = 32'h65daf4cd;	sm_T5[69] = 32'h0605bed5;	sm_T5[70] = 32'hd134621f;	sm_T5[71] = 32'hc4a6fe8a;	sm_T5[72] = 32'h342e539d;	sm_T5[73] = 32'ha2f355a0;	sm_T5[74] = 32'h058ae132;	sm_T5[75] = 32'ha4f6eb75;	sm_T5[76] = 32'h0b83ec39;	sm_T5[77] = 32'h4060efaa;	sm_T5[78] = 32'h5e719f06;	sm_T5[79] = 32'hbd6e1051;
	sm_T5[80] = 32'h3e218af9;	sm_T5[81] = 32'h96dd063d;	sm_T5[82] = 32'hdd3e05ae;	sm_T5[83] = 32'h4de6bd46;	sm_T5[84] = 32'h91548db5;	sm_T5[85] = 32'h71c45d05;	sm_T5[86] = 32'h0406d46f;	sm_T5[87] = 32'h605015ff;	sm_T5[88] = 32'h1998fb24;	sm_T5[89] = 32'hd6bde997;	sm_T5[90] = 32'h894043cc;	sm_T5[91] = 32'h67d99e77;	sm_T5[92] = 32'hb0e842bd;	sm_T5[93] = 32'h07898b88;	sm_T5[94] = 32'he7195b38;	sm_T5[95] = 32'h79c8eedb;
	sm_T5[96] = 32'ha17c0a47;	sm_T5[97] = 32'h7c420fe9;	sm_T5[98] = 32'hf8841ec9;	sm_T5[99] = 32'h00000000;	sm_T5[100] = 32'h09808683;	sm_T5[101] = 32'h322bed48;	sm_T5[102] = 32'h1e1170ac;	sm_T5[103] = 32'h6c5a724e;	sm_T5[104] = 32'hfd0efffb;	sm_T5[105] = 32'h0f853856;	sm_T5[106] = 32'h3daed51e;	sm_T5[107] = 32'h362d3927;	sm_T5[108] = 32'h0a0fd964;	sm_T5[109] = 32'h685ca621;	sm_T5[110] = 32'h9b5b54d1;	sm_T5[111] = 32'h24362e3a;
	sm_T5[112] = 32'h0c0a67b1;	sm_T5[113] = 32'h9357e70f;	sm_T5[114] = 32'hb4ee96d2;	sm_T5[115] = 32'h1b9b919e;	sm_T5[116] = 32'h80c0c54f;	sm_T5[117] = 32'h61dc20a2;	sm_T5[118] = 32'h5a774b69;	sm_T5[119] = 32'h1c121a16;	sm_T5[120] = 32'he293ba0a;	sm_T5[121] = 32'hc0a02ae5;	sm_T5[122] = 32'h3c22e043;	sm_T5[123] = 32'h121b171d;	sm_T5[124] = 32'h0e090d0b;	sm_T5[125] = 32'hf28bc7ad;	sm_T5[126] = 32'h2db6a8b9;	sm_T5[127] = 32'h141ea9c8;
	sm_T5[128] = 32'h57f11985;	sm_T5[129] = 32'haf75074c;	sm_T5[130] = 32'hee99ddbb;	sm_T5[131] = 32'ha37f60fd;	sm_T5[132] = 32'hf701269f;	sm_T5[133] = 32'h5c72f5bc;	sm_T5[134] = 32'h44663bc5;	sm_T5[135] = 32'h5bfb7e34;	sm_T5[136] = 32'h8b432976;	sm_T5[137] = 32'hcb23c6dc;	sm_T5[138] = 32'hb6edfc68;	sm_T5[139] = 32'hb8e4f163;	sm_T5[140] = 32'hd731dcca;	sm_T5[141] = 32'h42638510;	sm_T5[142] = 32'h13972240;	sm_T5[143] = 32'h84c61120;
	sm_T5[144] = 32'h854a247d;	sm_T5[145] = 32'hd2bb3df8;	sm_T5[146] = 32'haef93211;	sm_T5[147] = 32'hc729a16d;	sm_T5[148] = 32'h1d9e2f4b;	sm_T5[149] = 32'hdcb230f3;	sm_T5[150] = 32'h0d8652ec;	sm_T5[151] = 32'h77c1e3d0;	sm_T5[152] = 32'h2bb3166c;	sm_T5[153] = 32'ha970b999;	sm_T5[154] = 32'h119448fa;	sm_T5[155] = 32'h47e96422;	sm_T5[156] = 32'ha8fc8cc4;	sm_T5[157] = 32'ha0f03f1a;	sm_T5[158] = 32'h567d2cd8;	sm_T5[159] = 32'h223390ef;
	sm_T5[160] = 32'h87494ec7;	sm_T5[161] = 32'hd938d1c1;	sm_T5[162] = 32'h8ccaa2fe;	sm_T5[163] = 32'h98d40b36;	sm_T5[164] = 32'ha6f581cf;	sm_T5[165] = 32'ha57ade28;	sm_T5[166] = 32'hdab78e26;	sm_T5[167] = 32'h3fadbfa4;	sm_T5[168] = 32'h2c3a9de4;	sm_T5[169] = 32'h5078920d;	sm_T5[170] = 32'h6a5fcc9b;	sm_T5[171] = 32'h547e4662;	sm_T5[172] = 32'hf68d13c2;	sm_T5[173] = 32'h90d8b8e8;	sm_T5[174] = 32'h2e39f75e;	sm_T5[175] = 32'h82c3aff5;
	sm_T5[176] = 32'h9f5d80be;	sm_T5[177] = 32'h69d0937c;	sm_T5[178] = 32'h6fd52da9;	sm_T5[179] = 32'hcf2512b3;	sm_T5[180] = 32'hc8ac993b;	sm_T5[181] = 32'h10187da7;	sm_T5[182] = 32'he89c636e;	sm_T5[183] = 32'hdb3bbb7b;	sm_T5[184] = 32'hcd267809;	sm_T5[185] = 32'h6e5918f4;	sm_T5[186] = 32'hec9ab701;	sm_T5[187] = 32'h834f9aa8;	sm_T5[188] = 32'he6956e65;	sm_T5[189] = 32'haaffe67e;	sm_T5[190] = 32'h21bccf08;	sm_T5[191] = 32'hef15e8e6;
	sm_T5[192] = 32'hbae79bd9;	sm_T5[193] = 32'h4a6f36ce;	sm_T5[194] = 32'hea9f09d4;	sm_T5[195] = 32'h29b07cd6;	sm_T5[196] = 32'h31a4b2af;	sm_T5[197] = 32'h2a3f2331;	sm_T5[198] = 32'hc6a59430;	sm_T5[199] = 32'h35a266c0;	sm_T5[200] = 32'h744ebc37;	sm_T5[201] = 32'hfc82caa6;	sm_T5[202] = 32'he090d0b0;	sm_T5[203] = 32'h33a7d815;	sm_T5[204] = 32'hf104984a;	sm_T5[205] = 32'h41ecdaf7;	sm_T5[206] = 32'h7fcd500e;	sm_T5[207] = 32'h1791f62f;
	sm_T5[208] = 32'h764dd68d;	sm_T5[209] = 32'h43efb04d;	sm_T5[210] = 32'hccaa4d54;	sm_T5[211] = 32'he49604df;	sm_T5[212] = 32'h9ed1b5e3;	sm_T5[213] = 32'h4c6a881b;	sm_T5[214] = 32'hc12c1fb8;	sm_T5[215] = 32'h4665517f;	sm_T5[216] = 32'h9d5eea04;	sm_T5[217] = 32'h018c355d;	sm_T5[218] = 32'hfa877473;	sm_T5[219] = 32'hfb0b412e;	sm_T5[220] = 32'hb3671d5a;	sm_T5[221] = 32'h92dbd252;	sm_T5[222] = 32'he9105633;	sm_T5[223] = 32'h6dd64713;
	sm_T5[224] = 32'h9ad7618c;	sm_T5[225] = 32'h37a10c7a;	sm_T5[226] = 32'h59f8148e;	sm_T5[227] = 32'heb133c89;	sm_T5[228] = 32'hcea927ee;	sm_T5[229] = 32'hb761c935;	sm_T5[230] = 32'he11ce5ed;	sm_T5[231] = 32'h7a47b13c;	sm_T5[232] = 32'h9cd2df59;	sm_T5[233] = 32'h55f2733f;	sm_T5[234] = 32'h1814ce79;	sm_T5[235] = 32'h73c737bf;	sm_T5[236] = 32'h53f7cdea;	sm_T5[237] = 32'h5ffdaa5b;	sm_T5[238] = 32'hdf3d6f14;	sm_T5[239] = 32'h7844db86;
	sm_T5[240] = 32'hcaaff381;	sm_T5[241] = 32'hb968c43e;	sm_T5[242] = 32'h3824342c;	sm_T5[243] = 32'hc2a3405f;	sm_T5[244] = 32'h161dc372;	sm_T5[245] = 32'hbce2250c;	sm_T5[246] = 32'h283c498b;	sm_T5[247] = 32'hff0d9541;	sm_T5[248] = 32'h39a80171;	sm_T5[249] = 32'h080cb3de;	sm_T5[250] = 32'hd8b4e49c;	sm_T5[251] = 32'h6456c190;	sm_T5[252] = 32'h7bcb8461;	sm_T5[253] = 32'hd532b670;	sm_T5[254] = 32'h486c5c74;	sm_T5[255] = 32'hd0b85742;
	
	//	sm_T6
	sm_T6[0] = 32'h5051f4a7;	sm_T6[1] = 32'h537e4165;	sm_T6[2] = 32'hc31a17a4;	sm_T6[3] = 32'h963a275e;	sm_T6[4] = 32'hcb3bab6b;	sm_T6[5] = 32'hf11f9d45;	sm_T6[6] = 32'habacfa58;	sm_T6[7] = 32'h934be303;	sm_T6[8] = 32'h552030fa;	sm_T6[9] = 32'hf6ad766d;	sm_T6[10] = 32'h9188cc76;	sm_T6[11] = 32'h25f5024c;	sm_T6[12] = 32'hfc4fe5d7;	sm_T6[13] = 32'hd7c52acb;	sm_T6[14] = 32'h80263544;	sm_T6[15] = 32'h8fb562a3;
	sm_T6[16] = 32'h49deb15a;	sm_T6[17] = 32'h6725ba1b;	sm_T6[18] = 32'h9845ea0e;	sm_T6[19] = 32'he15dfec0;	sm_T6[20] = 32'h02c32f75;	sm_T6[21] = 32'h12814cf0;	sm_T6[22] = 32'ha38d4697;	sm_T6[23] = 32'hc66bd3f9;	sm_T6[24] = 32'he7038f5f;	sm_T6[25] = 32'h9515929c;	sm_T6[26] = 32'hebbf6d7a;	sm_T6[27] = 32'hda955259;	sm_T6[28] = 32'h2dd4be83;	sm_T6[29] = 32'hd3587421;	sm_T6[30] = 32'h2949e069;	sm_T6[31] = 32'h448ec9c8;
	sm_T6[32] = 32'h6a75c289;	sm_T6[33] = 32'h78f48e79;	sm_T6[34] = 32'h6b99583e;	sm_T6[35] = 32'hdd27b971;	sm_T6[36] = 32'hb6bee14f;	sm_T6[37] = 32'h17f088ad;	sm_T6[38] = 32'h66c920ac;	sm_T6[39] = 32'hb47dce3a;	sm_T6[40] = 32'h1863df4a;	sm_T6[41] = 32'h82e51a31;	sm_T6[42] = 32'h60975133;	sm_T6[43] = 32'h4562537f;	sm_T6[44] = 32'he0b16477;	sm_T6[45] = 32'h84bb6bae;	sm_T6[46] = 32'h1cfe81a0;	sm_T6[47] = 32'h94f9082b;
	sm_T6[48] = 32'h58704868;	sm_T6[49] = 32'h198f45fd;	sm_T6[50] = 32'h8794de6c;	sm_T6[51] = 32'hb7527bf8;	sm_T6[52] = 32'h23ab73d3;	sm_T6[53] = 32'he2724b02;	sm_T6[54] = 32'h57e31f8f;	sm_T6[55] = 32'h2a6655ab;	sm_T6[56] = 32'h07b2eb28;	sm_T6[57] = 32'h032fb5c2;	sm_T6[58] = 32'h9a86c57b;	sm_T6[59] = 32'ha5d33708;	sm_T6[60] = 32'hf2302887;	sm_T6[61] = 32'hb223bfa5;	sm_T6[62] = 32'hba02036a;	sm_T6[63] = 32'h5ced1682;
	sm_T6[64] = 32'h2b8acf1c;	sm_T6[65] = 32'h92a779b4;	sm_T6[66] = 32'hf0f307f2;	sm_T6[67] = 32'ha14e69e2;	sm_T6[68] = 32'hcd65daf4;	sm_T6[69] = 32'hd50605be;	sm_T6[70] = 32'h1fd13462;	sm_T6[71] = 32'h8ac4a6fe;	sm_T6[72] = 32'h9d342e53;	sm_T6[73] = 32'ha0a2f355;	sm_T6[74] = 32'h32058ae1;	sm_T6[75] = 32'h75a4f6eb;	sm_T6[76] = 32'h390b83ec;	sm_T6[77] = 32'haa4060ef;	sm_T6[78] = 32'h065e719f;	sm_T6[79] = 32'h51bd6e10;
	sm_T6[80] = 32'hf93e218a;	sm_T6[81] = 32'h3d96dd06;	sm_T6[82] = 32'haedd3e05;	sm_T6[83] = 32'h464de6bd;	sm_T6[84] = 32'hb591548d;	sm_T6[85] = 32'h0571c45d;	sm_T6[86] = 32'h6f0406d4;	sm_T6[87] = 32'hff605015;	sm_T6[88] = 32'h241998fb;	sm_T6[89] = 32'h97d6bde9;	sm_T6[90] = 32'hcc894043;	sm_T6[91] = 32'h7767d99e;	sm_T6[92] = 32'hbdb0e842;	sm_T6[93] = 32'h8807898b;	sm_T6[94] = 32'h38e7195b;	sm_T6[95] = 32'hdb79c8ee;
	sm_T6[96] = 32'h47a17c0a;	sm_T6[97] = 32'he97c420f;	sm_T6[98] = 32'hc9f8841e;	sm_T6[99] = 32'h00000000;	sm_T6[100] = 32'h83098086;	sm_T6[101] = 32'h48322bed;	sm_T6[102] = 32'hac1e1170;	sm_T6[103] = 32'h4e6c5a72;	sm_T6[104] = 32'hfbfd0eff;	sm_T6[105] = 32'h560f8538;	sm_T6[106] = 32'h1e3daed5;	sm_T6[107] = 32'h27362d39;	sm_T6[108] = 32'h640a0fd9;	sm_T6[109] = 32'h21685ca6;	sm_T6[110] = 32'hd19b5b54;	sm_T6[111] = 32'h3a24362e;
	sm_T6[112] = 32'hb10c0a67;	sm_T6[113] = 32'h0f9357e7;	sm_T6[114] = 32'hd2b4ee96;	sm_T6[115] = 32'h9e1b9b91;	sm_T6[116] = 32'h4f80c0c5;	sm_T6[117] = 32'ha261dc20;	sm_T6[118] = 32'h695a774b;	sm_T6[119] = 32'h161c121a;	sm_T6[120] = 32'h0ae293ba;	sm_T6[121] = 32'he5c0a02a;	sm_T6[122] = 32'h433c22e0;	sm_T6[123] = 32'h1d121b17;	sm_T6[124] = 32'h0b0e090d;	sm_T6[125] = 32'hadf28bc7;	sm_T6[126] = 32'hb92db6a8;	sm_T6[127] = 32'hc8141ea9;
	sm_T6[128] = 32'h8557f119;	sm_T6[129] = 32'h4caf7507;	sm_T6[130] = 32'hbbee99dd;	sm_T6[131] = 32'hfda37f60;	sm_T6[132] = 32'h9ff70126;	sm_T6[133] = 32'hbc5c72f5;	sm_T6[134] = 32'hc544663b;	sm_T6[135] = 32'h345bfb7e;	sm_T6[136] = 32'h768b4329;	sm_T6[137] = 32'hdccb23c6;	sm_T6[138] = 32'h68b6edfc;	sm_T6[139] = 32'h63b8e4f1;	sm_T6[140] = 32'hcad731dc;	sm_T6[141] = 32'h10426385;	sm_T6[142] = 32'h40139722;	sm_T6[143] = 32'h2084c611;
	sm_T6[144] = 32'h7d854a24;	sm_T6[145] = 32'hf8d2bb3d;	sm_T6[146] = 32'h11aef932;	sm_T6[147] = 32'h6dc729a1;	sm_T6[148] = 32'h4b1d9e2f;	sm_T6[149] = 32'hf3dcb230;	sm_T6[150] = 32'hec0d8652;	sm_T6[151] = 32'hd077c1e3;	sm_T6[152] = 32'h6c2bb316;	sm_T6[153] = 32'h99a970b9;	sm_T6[154] = 32'hfa119448;	sm_T6[155] = 32'h2247e964;	sm_T6[156] = 32'hc4a8fc8c;	sm_T6[157] = 32'h1aa0f03f;	sm_T6[158] = 32'hd8567d2c;	sm_T6[159] = 32'hef223390;
	sm_T6[160] = 32'hc787494e;	sm_T6[161] = 32'hc1d938d1;	sm_T6[162] = 32'hfe8ccaa2;	sm_T6[163] = 32'h3698d40b;	sm_T6[164] = 32'hcfa6f581;	sm_T6[165] = 32'h28a57ade;	sm_T6[166] = 32'h26dab78e;	sm_T6[167] = 32'ha43fadbf;	sm_T6[168] = 32'he42c3a9d;	sm_T6[169] = 32'h0d507892;	sm_T6[170] = 32'h9b6a5fcc;	sm_T6[171] = 32'h62547e46;	sm_T6[172] = 32'hc2f68d13;	sm_T6[173] = 32'he890d8b8;	sm_T6[174] = 32'h5e2e39f7;	sm_T6[175] = 32'hf582c3af;
	sm_T6[176] = 32'hbe9f5d80;	sm_T6[177] = 32'h7c69d093;	sm_T6[178] = 32'ha96fd52d;	sm_T6[179] = 32'hb3cf2512;	sm_T6[180] = 32'h3bc8ac99;	sm_T6[181] = 32'ha710187d;	sm_T6[182] = 32'h6ee89c63;	sm_T6[183] = 32'h7bdb3bbb;	sm_T6[184] = 32'h09cd2678;	sm_T6[185] = 32'hf46e5918;	sm_T6[186] = 32'h01ec9ab7;	sm_T6[187] = 32'ha8834f9a;	sm_T6[188] = 32'h65e6956e;	sm_T6[189] = 32'h7eaaffe6;	sm_T6[190] = 32'h0821bccf;	sm_T6[191] = 32'he6ef15e8;
	sm_T6[192] = 32'hd9bae79b;	sm_T6[193] = 32'hce4a6f36;	sm_T6[194] = 32'hd4ea9f09;	sm_T6[195] = 32'hd629b07c;	sm_T6[196] = 32'haf31a4b2;	sm_T6[197] = 32'h312a3f23;	sm_T6[198] = 32'h30c6a594;	sm_T6[199] = 32'hc035a266;	sm_T6[200] = 32'h37744ebc;	sm_T6[201] = 32'ha6fc82ca;	sm_T6[202] = 32'hb0e090d0;	sm_T6[203] = 32'h1533a7d8;	sm_T6[204] = 32'h4af10498;	sm_T6[205] = 32'hf741ecda;	sm_T6[206] = 32'h0e7fcd50;	sm_T6[207] = 32'h2f1791f6;
	sm_T6[208] = 32'h8d764dd6;	sm_T6[209] = 32'h4d43efb0;	sm_T6[210] = 32'h54ccaa4d;	sm_T6[211] = 32'hdfe49604;	sm_T6[212] = 32'he39ed1b5;	sm_T6[213] = 32'h1b4c6a88;	sm_T6[214] = 32'hb8c12c1f;	sm_T6[215] = 32'h7f466551;	sm_T6[216] = 32'h049d5eea;	sm_T6[217] = 32'h5d018c35;	sm_T6[218] = 32'h73fa8774;	sm_T6[219] = 32'h2efb0b41;	sm_T6[220] = 32'h5ab3671d;	sm_T6[221] = 32'h5292dbd2;	sm_T6[222] = 32'h33e91056;	sm_T6[223] = 32'h136dd647;
	sm_T6[224] = 32'h8c9ad761;	sm_T6[225] = 32'h7a37a10c;	sm_T6[226] = 32'h8e59f814;	sm_T6[227] = 32'h89eb133c;	sm_T6[228] = 32'heecea927;	sm_T6[229] = 32'h35b761c9;	sm_T6[230] = 32'hede11ce5;	sm_T6[231] = 32'h3c7a47b1;	sm_T6[232] = 32'h599cd2df;	sm_T6[233] = 32'h3f55f273;	sm_T6[234] = 32'h791814ce;	sm_T6[235] = 32'hbf73c737;	sm_T6[236] = 32'hea53f7cd;	sm_T6[237] = 32'h5b5ffdaa;	sm_T6[238] = 32'h14df3d6f;	sm_T6[239] = 32'h867844db;
	sm_T6[240] = 32'h81caaff3;	sm_T6[241] = 32'h3eb968c4;	sm_T6[242] = 32'h2c382434;	sm_T6[243] = 32'h5fc2a340;	sm_T6[244] = 32'h72161dc3;	sm_T6[245] = 32'h0cbce225;	sm_T6[246] = 32'h8b283c49;	sm_T6[247] = 32'h41ff0d95;	sm_T6[248] = 32'h7139a801;	sm_T6[249] = 32'hde080cb3;	sm_T6[250] = 32'h9cd8b4e4;	sm_T6[251] = 32'h906456c1;	sm_T6[252] = 32'h617bcb84;	sm_T6[253] = 32'h70d532b6;	sm_T6[254] = 32'h74486c5c;	sm_T6[255] = 32'h42d0b857;
	
	//	sm_T7
	sm_T7[0] = 32'ha75051f4;	sm_T7[1] = 32'h65537e41;	sm_T7[2] = 32'ha4c31a17;	sm_T7[3] = 32'h5e963a27;	sm_T7[4] = 32'h6bcb3bab;	sm_T7[5] = 32'h45f11f9d;	sm_T7[6] = 32'h58abacfa;	sm_T7[7] = 32'h03934be3;	sm_T7[8] = 32'hfa552030;	sm_T7[9] = 32'h6df6ad76;	sm_T7[10] = 32'h769188cc;	sm_T7[11] = 32'h4c25f502;	sm_T7[12] = 32'hd7fc4fe5;	sm_T7[13] = 32'hcbd7c52a;	sm_T7[14] = 32'h44802635;	sm_T7[15] = 32'ha38fb562;
	sm_T7[16] = 32'h5a49deb1;	sm_T7[17] = 32'h1b6725ba;	sm_T7[18] = 32'h0e9845ea;	sm_T7[19] = 32'hc0e15dfe;	sm_T7[20] = 32'h7502c32f;	sm_T7[21] = 32'hf012814c;	sm_T7[22] = 32'h97a38d46;	sm_T7[23] = 32'hf9c66bd3;	sm_T7[24] = 32'h5fe7038f;	sm_T7[25] = 32'h9c951592;	sm_T7[26] = 32'h7aebbf6d;	sm_T7[27] = 32'h59da9552;	sm_T7[28] = 32'h832dd4be;	sm_T7[29] = 32'h21d35874;	sm_T7[30] = 32'h692949e0;	sm_T7[31] = 32'hc8448ec9;
	sm_T7[32] = 32'h896a75c2;	sm_T7[33] = 32'h7978f48e;	sm_T7[34] = 32'h3e6b9958;	sm_T7[35] = 32'h71dd27b9;	sm_T7[36] = 32'h4fb6bee1;	sm_T7[37] = 32'had17f088;	sm_T7[38] = 32'hac66c920;	sm_T7[39] = 32'h3ab47dce;	sm_T7[40] = 32'h4a1863df;	sm_T7[41] = 32'h3182e51a;	sm_T7[42] = 32'h33609751;	sm_T7[43] = 32'h7f456253;	sm_T7[44] = 32'h77e0b164;	sm_T7[45] = 32'hae84bb6b;	sm_T7[46] = 32'ha01cfe81;	sm_T7[47] = 32'h2b94f908;
	sm_T7[48] = 32'h68587048;	sm_T7[49] = 32'hfd198f45;	sm_T7[50] = 32'h6c8794de;	sm_T7[51] = 32'hf8b7527b;	sm_T7[52] = 32'hd323ab73;	sm_T7[53] = 32'h02e2724b;	sm_T7[54] = 32'h8f57e31f;	sm_T7[55] = 32'hab2a6655;	sm_T7[56] = 32'h2807b2eb;	sm_T7[57] = 32'hc2032fb5;	sm_T7[58] = 32'h7b9a86c5;	sm_T7[59] = 32'h08a5d337;	sm_T7[60] = 32'h87f23028;	sm_T7[61] = 32'ha5b223bf;	sm_T7[62] = 32'h6aba0203;	sm_T7[63] = 32'h825ced16;
	sm_T7[64] = 32'h1c2b8acf;	sm_T7[65] = 32'hb492a779;	sm_T7[66] = 32'hf2f0f307;	sm_T7[67] = 32'he2a14e69;	sm_T7[68] = 32'hf4cd65da;	sm_T7[69] = 32'hbed50605;	sm_T7[70] = 32'h621fd134;	sm_T7[71] = 32'hfe8ac4a6;	sm_T7[72] = 32'h539d342e;	sm_T7[73] = 32'h55a0a2f3;	sm_T7[74] = 32'he132058a;	sm_T7[75] = 32'heb75a4f6;	sm_T7[76] = 32'hec390b83;	sm_T7[77] = 32'hefaa4060;	sm_T7[78] = 32'h9f065e71;	sm_T7[79] = 32'h1051bd6e;
	sm_T7[80] = 32'h8af93e21;	sm_T7[81] = 32'h063d96dd;	sm_T7[82] = 32'h05aedd3e;	sm_T7[83] = 32'hbd464de6;	sm_T7[84] = 32'h8db59154;	sm_T7[85] = 32'h5d0571c4;	sm_T7[86] = 32'hd46f0406;	sm_T7[87] = 32'h15ff6050;	sm_T7[88] = 32'hfb241998;	sm_T7[89] = 32'he997d6bd;	sm_T7[90] = 32'h43cc8940;	sm_T7[91] = 32'h9e7767d9;	sm_T7[92] = 32'h42bdb0e8;	sm_T7[93] = 32'h8b880789;	sm_T7[94] = 32'h5b38e719;	sm_T7[95] = 32'heedb79c8;
	sm_T7[96] = 32'h0a47a17c;	sm_T7[97] = 32'h0fe97c42;	sm_T7[98] = 32'h1ec9f884;	sm_T7[99] = 32'h00000000;	sm_T7[100] = 32'h86830980;	sm_T7[101] = 32'hed48322b;	sm_T7[102] = 32'h70ac1e11;	sm_T7[103] = 32'h724e6c5a;	sm_T7[104] = 32'hfffbfd0e;	sm_T7[105] = 32'h38560f85;	sm_T7[106] = 32'hd51e3dae;	sm_T7[107] = 32'h3927362d;	sm_T7[108] = 32'hd9640a0f;	sm_T7[109] = 32'ha621685c;	sm_T7[110] = 32'h54d19b5b;	sm_T7[111] = 32'h2e3a2436;
	sm_T7[112] = 32'h67b10c0a;	sm_T7[113] = 32'he70f9357;	sm_T7[114] = 32'h96d2b4ee;	sm_T7[115] = 32'h919e1b9b;	sm_T7[116] = 32'hc54f80c0;	sm_T7[117] = 32'h20a261dc;	sm_T7[118] = 32'h4b695a77;	sm_T7[119] = 32'h1a161c12;	sm_T7[120] = 32'hba0ae293;	sm_T7[121] = 32'h2ae5c0a0;	sm_T7[122] = 32'he0433c22;	sm_T7[123] = 32'h171d121b;	sm_T7[124] = 32'h0d0b0e09;	sm_T7[125] = 32'hc7adf28b;	sm_T7[126] = 32'ha8b92db6;	sm_T7[127] = 32'ha9c8141e;
	sm_T7[128] = 32'h198557f1;	sm_T7[129] = 32'h074caf75;	sm_T7[130] = 32'hddbbee99;	sm_T7[131] = 32'h60fda37f;	sm_T7[132] = 32'h269ff701;	sm_T7[133] = 32'hf5bc5c72;	sm_T7[134] = 32'h3bc54466;	sm_T7[135] = 32'h7e345bfb;	sm_T7[136] = 32'h29768b43;	sm_T7[137] = 32'hc6dccb23;	sm_T7[138] = 32'hfc68b6ed;	sm_T7[139] = 32'hf163b8e4;	sm_T7[140] = 32'hdccad731;	sm_T7[141] = 32'h85104263;	sm_T7[142] = 32'h22401397;	sm_T7[143] = 32'h112084c6;
	sm_T7[144] = 32'h247d854a;	sm_T7[145] = 32'h3df8d2bb;	sm_T7[146] = 32'h3211aef9;	sm_T7[147] = 32'ha16dc729;	sm_T7[148] = 32'h2f4b1d9e;	sm_T7[149] = 32'h30f3dcb2;	sm_T7[150] = 32'h52ec0d86;	sm_T7[151] = 32'he3d077c1;	sm_T7[152] = 32'h166c2bb3;	sm_T7[153] = 32'hb999a970;	sm_T7[154] = 32'h48fa1194;	sm_T7[155] = 32'h642247e9;	sm_T7[156] = 32'h8cc4a8fc;	sm_T7[157] = 32'h3f1aa0f0;	sm_T7[158] = 32'h2cd8567d;	sm_T7[159] = 32'h90ef2233;
	sm_T7[160] = 32'h4ec78749;	sm_T7[161] = 32'hd1c1d938;	sm_T7[162] = 32'ha2fe8cca;	sm_T7[163] = 32'h0b3698d4;	sm_T7[164] = 32'h81cfa6f5;	sm_T7[165] = 32'hde28a57a;	sm_T7[166] = 32'h8e26dab7;	sm_T7[167] = 32'hbfa43fad;	sm_T7[168] = 32'h9de42c3a;	sm_T7[169] = 32'h920d5078;	sm_T7[170] = 32'hcc9b6a5f;	sm_T7[171] = 32'h4662547e;	sm_T7[172] = 32'h13c2f68d;	sm_T7[173] = 32'hb8e890d8;	sm_T7[174] = 32'hf75e2e39;	sm_T7[175] = 32'haff582c3;
	sm_T7[176] = 32'h80be9f5d;	sm_T7[177] = 32'h937c69d0;	sm_T7[178] = 32'h2da96fd5;	sm_T7[179] = 32'h12b3cf25;	sm_T7[180] = 32'h993bc8ac;	sm_T7[181] = 32'h7da71018;	sm_T7[182] = 32'h636ee89c;	sm_T7[183] = 32'hbb7bdb3b;	sm_T7[184] = 32'h7809cd26;	sm_T7[185] = 32'h18f46e59;	sm_T7[186] = 32'hb701ec9a;	sm_T7[187] = 32'h9aa8834f;	sm_T7[188] = 32'h6e65e695;	sm_T7[189] = 32'he67eaaff;	sm_T7[190] = 32'hcf0821bc;	sm_T7[191] = 32'he8e6ef15;
	sm_T7[192] = 32'h9bd9bae7;	sm_T7[193] = 32'h36ce4a6f;	sm_T7[194] = 32'h09d4ea9f;	sm_T7[195] = 32'h7cd629b0;	sm_T7[196] = 32'hb2af31a4;	sm_T7[197] = 32'h23312a3f;	sm_T7[198] = 32'h9430c6a5;	sm_T7[199] = 32'h66c035a2;	sm_T7[200] = 32'hbc37744e;	sm_T7[201] = 32'hcaa6fc82;	sm_T7[202] = 32'hd0b0e090;	sm_T7[203] = 32'hd81533a7;	sm_T7[204] = 32'h984af104;	sm_T7[205] = 32'hdaf741ec;	sm_T7[206] = 32'h500e7fcd;	sm_T7[207] = 32'hf62f1791;
	sm_T7[208] = 32'hd68d764d;	sm_T7[209] = 32'hb04d43ef;	sm_T7[210] = 32'h4d54ccaa;	sm_T7[211] = 32'h04dfe496;	sm_T7[212] = 32'hb5e39ed1;	sm_T7[213] = 32'h881b4c6a;	sm_T7[214] = 32'h1fb8c12c;	sm_T7[215] = 32'h517f4665;	sm_T7[216] = 32'hea049d5e;	sm_T7[217] = 32'h355d018c;	sm_T7[218] = 32'h7473fa87;	sm_T7[219] = 32'h412efb0b;	sm_T7[220] = 32'h1d5ab367;	sm_T7[221] = 32'hd25292db;	sm_T7[222] = 32'h5633e910;	sm_T7[223] = 32'h47136dd6;
	sm_T7[224] = 32'h618c9ad7;	sm_T7[225] = 32'h0c7a37a1;	sm_T7[226] = 32'h148e59f8;	sm_T7[227] = 32'h3c89eb13;	sm_T7[228] = 32'h27eecea9;	sm_T7[229] = 32'hc935b761;	sm_T7[230] = 32'he5ede11c;	sm_T7[231] = 32'hb13c7a47;	sm_T7[232] = 32'hdf599cd2;	sm_T7[233] = 32'h733f55f2;	sm_T7[234] = 32'hce791814;	sm_T7[235] = 32'h37bf73c7;	sm_T7[236] = 32'hcdea53f7;	sm_T7[237] = 32'haa5b5ffd;	sm_T7[238] = 32'h6f14df3d;	sm_T7[239] = 32'hdb867844;
	sm_T7[240] = 32'hf381caaf;	sm_T7[241] = 32'hc43eb968;	sm_T7[242] = 32'h342c3824;	sm_T7[243] = 32'h405fc2a3;	sm_T7[244] = 32'hc372161d;	sm_T7[245] = 32'h250cbce2;	sm_T7[246] = 32'h498b283c;	sm_T7[247] = 32'h9541ff0d;	sm_T7[248] = 32'h017139a8;	sm_T7[249] = 32'hb3de080c;	sm_T7[250] = 32'he49cd8b4;	sm_T7[251] = 32'hc1906456;	sm_T7[252] = 32'h84617bcb;	sm_T7[253] = 32'hb670d532;	sm_T7[254] = 32'h5c74486c;	sm_T7[255] = 32'h5742d0b8;
	
	//	sm_T8
	sm_T8[0] = 32'hf4a75051;	sm_T8[1] = 32'h4165537e;	sm_T8[2] = 32'h17a4c31a;	sm_T8[3] = 32'h275e963a;	sm_T8[4] = 32'hab6bcb3b;	sm_T8[5] = 32'h9d45f11f;	sm_T8[6] = 32'hfa58abac;	sm_T8[7] = 32'he303934b;	sm_T8[8] = 32'h30fa5520;	sm_T8[9] = 32'h766df6ad;	sm_T8[10] = 32'hcc769188;	sm_T8[11] = 32'h024c25f5;	sm_T8[12] = 32'he5d7fc4f;	sm_T8[13] = 32'h2acbd7c5;	sm_T8[14] = 32'h35448026;	sm_T8[15] = 32'h62a38fb5;
	sm_T8[16] = 32'hb15a49de;	sm_T8[17] = 32'hba1b6725;	sm_T8[18] = 32'hea0e9845;	sm_T8[19] = 32'hfec0e15d;	sm_T8[20] = 32'h2f7502c3;	sm_T8[21] = 32'h4cf01281;	sm_T8[22] = 32'h4697a38d;	sm_T8[23] = 32'hd3f9c66b;	sm_T8[24] = 32'h8f5fe703;	sm_T8[25] = 32'h929c9515;	sm_T8[26] = 32'h6d7aebbf;	sm_T8[27] = 32'h5259da95;	sm_T8[28] = 32'hbe832dd4;	sm_T8[29] = 32'h7421d358;	sm_T8[30] = 32'he0692949;	sm_T8[31] = 32'hc9c8448e;
	sm_T8[32] = 32'hc2896a75;	sm_T8[33] = 32'h8e7978f4;	sm_T8[34] = 32'h583e6b99;	sm_T8[35] = 32'hb971dd27;	sm_T8[36] = 32'he14fb6be;	sm_T8[37] = 32'h88ad17f0;	sm_T8[38] = 32'h20ac66c9;	sm_T8[39] = 32'hce3ab47d;	sm_T8[40] = 32'hdf4a1863;	sm_T8[41] = 32'h1a3182e5;	sm_T8[42] = 32'h51336097;	sm_T8[43] = 32'h537f4562;	sm_T8[44] = 32'h6477e0b1;	sm_T8[45] = 32'h6bae84bb;	sm_T8[46] = 32'h81a01cfe;	sm_T8[47] = 32'h082b94f9;
	sm_T8[48] = 32'h48685870;	sm_T8[49] = 32'h45fd198f;	sm_T8[50] = 32'hde6c8794;	sm_T8[51] = 32'h7bf8b752;	sm_T8[52] = 32'h73d323ab;	sm_T8[53] = 32'h4b02e272;	sm_T8[54] = 32'h1f8f57e3;	sm_T8[55] = 32'h55ab2a66;	sm_T8[56] = 32'heb2807b2;	sm_T8[57] = 32'hb5c2032f;	sm_T8[58] = 32'hc57b9a86;	sm_T8[59] = 32'h3708a5d3;	sm_T8[60] = 32'h2887f230;	sm_T8[61] = 32'hbfa5b223;	sm_T8[62] = 32'h036aba02;	sm_T8[63] = 32'h16825ced;
	sm_T8[64] = 32'hcf1c2b8a;	sm_T8[65] = 32'h79b492a7;	sm_T8[66] = 32'h07f2f0f3;	sm_T8[67] = 32'h69e2a14e;	sm_T8[68] = 32'hdaf4cd65;	sm_T8[69] = 32'h05bed506;	sm_T8[70] = 32'h34621fd1;	sm_T8[71] = 32'ha6fe8ac4;	sm_T8[72] = 32'h2e539d34;	sm_T8[73] = 32'hf355a0a2;	sm_T8[74] = 32'h8ae13205;	sm_T8[75] = 32'hf6eb75a4;	sm_T8[76] = 32'h83ec390b;	sm_T8[77] = 32'h60efaa40;	sm_T8[78] = 32'h719f065e;	sm_T8[79] = 32'h6e1051bd;
	sm_T8[80] = 32'h218af93e;	sm_T8[81] = 32'hdd063d96;	sm_T8[82] = 32'h3e05aedd;	sm_T8[83] = 32'he6bd464d;	sm_T8[84] = 32'h548db591;	sm_T8[85] = 32'hc45d0571;	sm_T8[86] = 32'h06d46f04;	sm_T8[87] = 32'h5015ff60;	sm_T8[88] = 32'h98fb2419;	sm_T8[89] = 32'hbde997d6;	sm_T8[90] = 32'h4043cc89;	sm_T8[91] = 32'hd99e7767;	sm_T8[92] = 32'he842bdb0;	sm_T8[93] = 32'h898b8807;	sm_T8[94] = 32'h195b38e7;	sm_T8[95] = 32'hc8eedb79;
	sm_T8[96] = 32'h7c0a47a1;	sm_T8[97] = 32'h420fe97c;	sm_T8[98] = 32'h841ec9f8;	sm_T8[99] = 32'h00000000;	sm_T8[100] = 32'h80868309;	sm_T8[101] = 32'h2bed4832;	sm_T8[102] = 32'h1170ac1e;	sm_T8[103] = 32'h5a724e6c;	sm_T8[104] = 32'h0efffbfd;	sm_T8[105] = 32'h8538560f;	sm_T8[106] = 32'haed51e3d;	sm_T8[107] = 32'h2d392736;	sm_T8[108] = 32'h0fd9640a;	sm_T8[109] = 32'h5ca62168;	sm_T8[110] = 32'h5b54d19b;	sm_T8[111] = 32'h362e3a24;
	sm_T8[112] = 32'h0a67b10c;	sm_T8[113] = 32'h57e70f93;	sm_T8[114] = 32'hee96d2b4;	sm_T8[115] = 32'h9b919e1b;	sm_T8[116] = 32'hc0c54f80;	sm_T8[117] = 32'hdc20a261;	sm_T8[118] = 32'h774b695a;	sm_T8[119] = 32'h121a161c;	sm_T8[120] = 32'h93ba0ae2;	sm_T8[121] = 32'ha02ae5c0;	sm_T8[122] = 32'h22e0433c;	sm_T8[123] = 32'h1b171d12;	sm_T8[124] = 32'h090d0b0e;	sm_T8[125] = 32'h8bc7adf2;	sm_T8[126] = 32'hb6a8b92d;	sm_T8[127] = 32'h1ea9c814;
	sm_T8[128] = 32'hf1198557;	sm_T8[129] = 32'h75074caf;	sm_T8[130] = 32'h99ddbbee;	sm_T8[131] = 32'h7f60fda3;	sm_T8[132] = 32'h01269ff7;	sm_T8[133] = 32'h72f5bc5c;	sm_T8[134] = 32'h663bc544;	sm_T8[135] = 32'hfb7e345b;	sm_T8[136] = 32'h4329768b;	sm_T8[137] = 32'h23c6dccb;	sm_T8[138] = 32'hedfc68b6;	sm_T8[139] = 32'he4f163b8;	sm_T8[140] = 32'h31dccad7;	sm_T8[141] = 32'h63851042;	sm_T8[142] = 32'h97224013;	sm_T8[143] = 32'hc6112084;
	sm_T8[144] = 32'h4a247d85;	sm_T8[145] = 32'hbb3df8d2;	sm_T8[146] = 32'hf93211ae;	sm_T8[147] = 32'h29a16dc7;	sm_T8[148] = 32'h9e2f4b1d;	sm_T8[149] = 32'hb230f3dc;	sm_T8[150] = 32'h8652ec0d;	sm_T8[151] = 32'hc1e3d077;	sm_T8[152] = 32'hb3166c2b;	sm_T8[153] = 32'h70b999a9;	sm_T8[154] = 32'h9448fa11;	sm_T8[155] = 32'he9642247;	sm_T8[156] = 32'hfc8cc4a8;	sm_T8[157] = 32'hf03f1aa0;	sm_T8[158] = 32'h7d2cd856;	sm_T8[159] = 32'h3390ef22;
	sm_T8[160] = 32'h494ec787;	sm_T8[161] = 32'h38d1c1d9;	sm_T8[162] = 32'hcaa2fe8c;	sm_T8[163] = 32'hd40b3698;	sm_T8[164] = 32'hf581cfa6;	sm_T8[165] = 32'h7ade28a5;	sm_T8[166] = 32'hb78e26da;	sm_T8[167] = 32'hadbfa43f;	sm_T8[168] = 32'h3a9de42c;	sm_T8[169] = 32'h78920d50;	sm_T8[170] = 32'h5fcc9b6a;	sm_T8[171] = 32'h7e466254;	sm_T8[172] = 32'h8d13c2f6;	sm_T8[173] = 32'hd8b8e890;	sm_T8[174] = 32'h39f75e2e;	sm_T8[175] = 32'hc3aff582;
	sm_T8[176] = 32'h5d80be9f;	sm_T8[177] = 32'hd0937c69;	sm_T8[178] = 32'hd52da96f;	sm_T8[179] = 32'h2512b3cf;	sm_T8[180] = 32'hac993bc8;	sm_T8[181] = 32'h187da710;	sm_T8[182] = 32'h9c636ee8;	sm_T8[183] = 32'h3bbb7bdb;	sm_T8[184] = 32'h267809cd;	sm_T8[185] = 32'h5918f46e;	sm_T8[186] = 32'h9ab701ec;	sm_T8[187] = 32'h4f9aa883;	sm_T8[188] = 32'h956e65e6;	sm_T8[189] = 32'hffe67eaa;	sm_T8[190] = 32'hbccf0821;	sm_T8[191] = 32'h15e8e6ef;
	sm_T8[192] = 32'he79bd9ba;	sm_T8[193] = 32'h6f36ce4a;	sm_T8[194] = 32'h9f09d4ea;	sm_T8[195] = 32'hb07cd629;	sm_T8[196] = 32'ha4b2af31;	sm_T8[197] = 32'h3f23312a;	sm_T8[198] = 32'ha59430c6;	sm_T8[199] = 32'ha266c035;	sm_T8[200] = 32'h4ebc3774;	sm_T8[201] = 32'h82caa6fc;	sm_T8[202] = 32'h90d0b0e0;	sm_T8[203] = 32'ha7d81533;	sm_T8[204] = 32'h04984af1;	sm_T8[205] = 32'hecdaf741;	sm_T8[206] = 32'hcd500e7f;	sm_T8[207] = 32'h91f62f17;
	sm_T8[208] = 32'h4dd68d76;	sm_T8[209] = 32'hefb04d43;	sm_T8[210] = 32'haa4d54cc;	sm_T8[211] = 32'h9604dfe4;	sm_T8[212] = 32'hd1b5e39e;	sm_T8[213] = 32'h6a881b4c;	sm_T8[214] = 32'h2c1fb8c1;	sm_T8[215] = 32'h65517f46;	sm_T8[216] = 32'h5eea049d;	sm_T8[217] = 32'h8c355d01;	sm_T8[218] = 32'h877473fa;	sm_T8[219] = 32'h0b412efb;	sm_T8[220] = 32'h671d5ab3;	sm_T8[221] = 32'hdbd25292;	sm_T8[222] = 32'h105633e9;	sm_T8[223] = 32'hd647136d;
	sm_T8[224] = 32'hd7618c9a;	sm_T8[225] = 32'ha10c7a37;	sm_T8[226] = 32'hf8148e59;	sm_T8[227] = 32'h133c89eb;	sm_T8[228] = 32'ha927eece;	sm_T8[229] = 32'h61c935b7;	sm_T8[230] = 32'h1ce5ede1;	sm_T8[231] = 32'h47b13c7a;	sm_T8[232] = 32'hd2df599c;	sm_T8[233] = 32'hf2733f55;	sm_T8[234] = 32'h14ce7918;	sm_T8[235] = 32'hc737bf73;	sm_T8[236] = 32'hf7cdea53;	sm_T8[237] = 32'hfdaa5b5f;	sm_T8[238] = 32'h3d6f14df;	sm_T8[239] = 32'h44db8678;
	sm_T8[240] = 32'haff381ca;	sm_T8[241] = 32'h68c43eb9;	sm_T8[242] = 32'h24342c38;	sm_T8[243] = 32'ha3405fc2;	sm_T8[244] = 32'h1dc37216;	sm_T8[245] = 32'he2250cbc;	sm_T8[246] = 32'h3c498b28;	sm_T8[247] = 32'h0d9541ff;	sm_T8[248] = 32'ha8017139;	sm_T8[249] = 32'h0cb3de08;	sm_T8[250] = 32'hb4e49cd8;	sm_T8[251] = 32'h56c19064;	sm_T8[252] = 32'hcb84617b;	sm_T8[253] = 32'h32b670d5;	sm_T8[254] = 32'h6c5c7448;	sm_T8[255] = 32'hb85742d0;
	
 end
				
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
 assign oData_1 = Data_1_ADD_ROUND_KEY;
 assign oData_2 = Data_2_ADD_ROUND_KEY;
 assign oData_3 = Data_3_ADD_ROUND_KEY;
 assign oData_4 = Data_4_ADD_ROUND_KEY;
 
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
 
/*****************************************************************************
 *                         TRANSFORM -> SBOX step                            *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			Data_1_1_SBOX <= 32'b0;
			Data_1_2_SBOX <= 32'b0;
			Data_1_3_SBOX <= 32'b0;
			Data_1_4_SBOX <= 32'b0;
		end
	else if(iData_valid)
		begin
			if(iEndec)
				begin
					Data_1_1_SBOX <= sm_T5[iData_1[31:24]];
					Data_1_2_SBOX <= sm_T6[iData_1[23:16]];
					Data_1_3_SBOX <= sm_T7[iData_1[15:8]];
					Data_1_4_SBOX <= sm_T8[iData_1[7:0]];
				end
			else
				begin
					Data_1_1_SBOX <= sm_T1[iData_1[31:24]];
					Data_1_2_SBOX <= sm_T2[iData_1[23:16]];
					Data_1_3_SBOX <= sm_T3[iData_1[15:8]];
					Data_1_4_SBOX <= sm_T4[iData_1[7:0]];
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
			Data_2_1_SBOX <= 32'b0;
			Data_2_2_SBOX <= 32'b0;
			Data_2_3_SBOX <= 32'b0;
			Data_2_4_SBOX <= 32'b0;
		end
	else if(iData_valid)
		begin
			if(iEndec)
				begin
					Data_2_1_SBOX <= sm_T5[iData_2[31:24]];
					Data_2_2_SBOX <= sm_T6[iData_2[23:16]];
					Data_2_3_SBOX <= sm_T7[iData_2[15:8]];
					Data_2_4_SBOX <= sm_T8[iData_2[7:0]];
				end
			else
				begin
					Data_2_1_SBOX <= sm_T1[iData_2[31:24]];
					Data_2_2_SBOX <= sm_T2[iData_2[23:16]];
					Data_2_3_SBOX <= sm_T3[iData_2[15:8]];
					Data_2_4_SBOX <= sm_T4[iData_2[7:0]];
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
			Data_3_1_SBOX <= 32'b0;
			Data_3_2_SBOX <= 32'b0;
			Data_3_3_SBOX <= 32'b0;
			Data_3_4_SBOX <= 32'b0;
		end
	else if(iData_valid)
		begin
			if(iEndec)
				begin
					Data_3_1_SBOX <= sm_T5[iData_3[31:24]];
					Data_3_2_SBOX <= sm_T6[iData_3[23:16]];
					Data_3_3_SBOX <= sm_T7[iData_3[15:8]];
					Data_3_4_SBOX <= sm_T8[iData_3[7:0]];
				end
			else
				begin
					Data_3_1_SBOX <= sm_T1[iData_3[31:24]];
					Data_3_2_SBOX <= sm_T2[iData_3[23:16]];
					Data_3_3_SBOX <= sm_T3[iData_3[15:8]];
					Data_3_4_SBOX <= sm_T4[iData_3[7:0]];
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
			Data_4_1_SBOX <= 32'b0;
			Data_4_2_SBOX <= 32'b0;
			Data_4_3_SBOX <= 32'b0;
			Data_4_4_SBOX <= 32'b0;
		end
	else if(iData_valid)
		begin
			if(iEndec)
				begin
					Data_4_1_SBOX <= sm_T5[iData_4[31:24]];
					Data_4_2_SBOX <= sm_T6[iData_4[23:16]];
					Data_4_3_SBOX <= sm_T7[iData_4[15:8]];
					Data_4_4_SBOX <= sm_T8[iData_4[7:0]];
				end
			else
				begin
					Data_4_1_SBOX <= sm_T1[iData_4[31:24]];
					Data_4_2_SBOX <= sm_T2[iData_4[23:16]];
					Data_4_3_SBOX <= sm_T3[iData_4[15:8]];
					Data_4_4_SBOX <= sm_T4[iData_4[7:0]];
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
 *                     TRANSFORM -> SHIFT AND MIX STEP                       *
 *****************************************************************************/
 assign Data_1_SHIFT_and_MIX_en = Data_1_1_SBOX ^ Data_2_2_SBOX ^ Data_3_3_SBOX ^ Data_4_4_SBOX;
 assign Data_2_SHIFT_and_MIX_en = Data_2_1_SBOX ^ Data_3_2_SBOX ^ Data_4_3_SBOX ^ Data_1_4_SBOX;
 assign Data_3_SHIFT_and_MIX_en = Data_3_1_SBOX ^ Data_4_2_SBOX ^ Data_1_3_SBOX ^ Data_2_4_SBOX;
 assign Data_4_SHIFT_and_MIX_en = Data_4_1_SBOX ^ Data_1_2_SBOX ^ Data_2_3_SBOX ^ Data_3_4_SBOX;
 
 assign Data_1_SHIFT_and_MIX_de = Data_1_1_SBOX ^ Data_4_2_SBOX ^ Data_3_3_SBOX ^ Data_2_4_SBOX;
 assign Data_2_SHIFT_and_MIX_de = Data_2_1_SBOX ^ Data_1_2_SBOX ^ Data_4_3_SBOX ^ Data_3_4_SBOX;
 assign Data_3_SHIFT_and_MIX_de = Data_3_1_SBOX ^ Data_2_2_SBOX ^ Data_1_3_SBOX ^ Data_4_4_SBOX;
 assign Data_4_SHIFT_and_MIX_de = Data_4_1_SBOX ^ Data_3_2_SBOX ^ Data_2_3_SBOX ^ Data_1_4_SBOX;
 
 assign Data_1_SHIFT_and_MIX = (iEndec) ? Data_1_SHIFT_and_MIX_de : Data_1_SHIFT_and_MIX_en;
 assign Data_2_SHIFT_and_MIX = (iEndec) ? Data_2_SHIFT_and_MIX_de : Data_2_SHIFT_and_MIX_en;
 assign Data_3_SHIFT_and_MIX = (iEndec) ? Data_3_SHIFT_and_MIX_de : Data_3_SHIFT_and_MIX_en;
 assign Data_4_SHIFT_and_MIX = (iEndec) ? Data_4_SHIFT_and_MIX_de : Data_4_SHIFT_and_MIX_en;
 
/*****************************************************************************
 *                     TRANSFORM -> ADD ROUND KEY STEP                       *
 *****************************************************************************/
 
 assign Data_1_ADD_ROUND_KEY = Data_1_SHIFT_and_MIX ^ iRAM_data_1;
 assign Data_2_ADD_ROUND_KEY = Data_2_SHIFT_and_MIX ^ iRAM_data_2;
 assign Data_3_ADD_ROUND_KEY = Data_3_SHIFT_and_MIX ^ iRAM_data_3;
 assign Data_4_ADD_ROUND_KEY = Data_4_SHIFT_and_MIX ^ iRAM_data_4;
 
endmodule 