module Inverse_MixColumn_round (
	//	Global signals
	input				iClk,
	input				iRst_n,
	
	//	Param
	input		[3:0]	iRound,
	
	//	Original data from above
	input		[3:0]	iRAM_Kd_addr,
	input				iRAM_Kd_write_1,
	input		[31:0]	iRAM_Kd_data_1,
	input				iRAM_Kd_write_2,
	input		[31:0]	iRAM_Kd_data_2,
	input				iRAM_Kd_write_3,
	input		[31:0]	iRAM_Kd_data_3,
	input				iRAM_Kd_write_4,
	input		[31:0]	iRAM_Kd_data_4,
	
	//	Write Decrypt RAM m_Kd
	output	reg	[3:0]	oRAM_Kd_addr,
	output	reg			oRAM_Kd_write_1,
	output		[31:0]	oRAM_Kd_data_1,
	output	reg			oRAM_Kd_write_2,
	output		[31:0]	oRAM_Kd_data_2,
	output	reg			oRAM_Kd_write_3,
	output		[31:0]	oRAM_Kd_data_3,
	output	reg			oRAM_Kd_write_4,
	output		[31:0]	oRAM_Kd_data_4
);

/*****************************************************************************
 *                              ROM Declarations                             *
 *****************************************************************************/
 
 reg	[31:0]	sm_U1[0:255];
 reg	[31:0]	sm_U2[0:255];
 reg	[31:0]	sm_U3[0:255];
 reg	[31:0]	sm_U4[0:255];

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 //	Buffer IN
 reg	[31:0]	RAM_Kd_data_1,
				RAM_Kd_data_2,
				RAM_Kd_data_3,
				RAM_Kd_data_4;
 
 reg	[31:0]	SBOX_data_1_1,
				SBOX_data_1_2,
				SBOX_data_1_3,
				SBOX_data_1_4;
				
 reg	[31:0]	SBOX_data_2_1,
				SBOX_data_2_2,
				SBOX_data_2_3,
				SBOX_data_2_4;
				
 reg	[31:0]	SBOX_data_3_1,
				SBOX_data_3_2,
				SBOX_data_3_3,
				SBOX_data_3_4;
				
 reg	[31:0]	SBOX_data_4_1,
				SBOX_data_4_2,
				SBOX_data_4_3,
				SBOX_data_4_4;
				
 wire	[31:0]	SBOX_data_OUT_1,
				SBOX_data_OUT_2,
				SBOX_data_OUT_3,
				SBOX_data_OUT_4;
				
 wire			Condition_for_not_change;
 
/*****************************************************************************
 *                                ROM initial                                *
 *****************************************************************************/
 //Phat
 //sm_U1[i] = i*[0e, 09, 0d, 0b]
 //sm_U2[i] = i*[0b, 0e, 09, 0d]
 //sm_U3[i] = i*[0d, 0b, 0e, 09]
 //sm_U4[i] = i*[09, 0d, 0b, 0e]
 //result = sm_U1[i] ^ sm_U2[i] ^ sm_U3[i] ^ sm_U4[i]
 initial begin
 
	//	sm_U1
	sm_U1[0] = 32'h00000000;	sm_U1[1] = 32'h0e090d0b;	sm_U1[2] = 32'h1c121a16;	sm_U1[3] = 32'h121b171d;	sm_U1[4] = 32'h3824342c;	sm_U1[5] = 32'h362d3927;	sm_U1[6] = 32'h24362e3a;	sm_U1[7] = 32'h2a3f2331;	sm_U1[8] = 32'h70486858;	sm_U1[9] = 32'h7e416553;	sm_U1[10] = 32'h6c5a724e;	sm_U1[11] = 32'h62537f45;	sm_U1[12] = 32'h486c5c74;	sm_U1[13] = 32'h4665517f;	sm_U1[14] = 32'h547e4662;	sm_U1[15] = 32'h5a774b69;
	sm_U1[16] = 32'he090d0b0;	sm_U1[17] = 32'hee99ddbb;	sm_U1[18] = 32'hfc82caa6;	sm_U1[19] = 32'hf28bc7ad;	sm_U1[20] = 32'hd8b4e49c;	sm_U1[21] = 32'hd6bde997;	sm_U1[22] = 32'hc4a6fe8a;	sm_U1[23] = 32'hcaaff381;	sm_U1[24] = 32'h90d8b8e8;	sm_U1[25] = 32'h9ed1b5e3;	sm_U1[26] = 32'h8ccaa2fe;	sm_U1[27] = 32'h82c3aff5;	sm_U1[28] = 32'ha8fc8cc4;	sm_U1[29] = 32'ha6f581cf;	sm_U1[30] = 32'hb4ee96d2;	sm_U1[31] = 32'hbae79bd9;
	sm_U1[32] = 32'hdb3bbb7b;	sm_U1[33] = 32'hd532b670;	sm_U1[34] = 32'hc729a16d;	sm_U1[35] = 32'hc920ac66;	sm_U1[36] = 32'he31f8f57;	sm_U1[37] = 32'hed16825c;	sm_U1[38] = 32'hff0d9541;	sm_U1[39] = 32'hf104984a;	sm_U1[40] = 32'hab73d323;	sm_U1[41] = 32'ha57ade28;	sm_U1[42] = 32'hb761c935;	sm_U1[43] = 32'hb968c43e;	sm_U1[44] = 32'h9357e70f;	sm_U1[45] = 32'h9d5eea04;	sm_U1[46] = 32'h8f45fd19;	sm_U1[47] = 32'h814cf012;
	sm_U1[48] = 32'h3bab6bcb;	sm_U1[49] = 32'h35a266c0;	sm_U1[50] = 32'h27b971dd;	sm_U1[51] = 32'h29b07cd6;	sm_U1[52] = 32'h038f5fe7;	sm_U1[53] = 32'h0d8652ec;	sm_U1[54] = 32'h1f9d45f1;	sm_U1[55] = 32'h119448fa;	sm_U1[56] = 32'h4be30393;	sm_U1[57] = 32'h45ea0e98;	sm_U1[58] = 32'h57f11985;	sm_U1[59] = 32'h59f8148e;	sm_U1[60] = 32'h73c737bf;	sm_U1[61] = 32'h7dce3ab4;	sm_U1[62] = 32'h6fd52da9;	sm_U1[63] = 32'h61dc20a2;
	sm_U1[64] = 32'had766df6;	sm_U1[65] = 32'ha37f60fd;	sm_U1[66] = 32'hb16477e0;	sm_U1[67] = 32'hbf6d7aeb;	sm_U1[68] = 32'h955259da;	sm_U1[69] = 32'h9b5b54d1;	sm_U1[70] = 32'h894043cc;	sm_U1[71] = 32'h87494ec7;	sm_U1[72] = 32'hdd3e05ae;	sm_U1[73] = 32'hd33708a5;	sm_U1[74] = 32'hc12c1fb8;	sm_U1[75] = 32'hcf2512b3;	sm_U1[76] = 32'he51a3182;	sm_U1[77] = 32'heb133c89;	sm_U1[78] = 32'hf9082b94;	sm_U1[79] = 32'hf701269f;
	sm_U1[80] = 32'h4de6bd46;	sm_U1[81] = 32'h43efb04d;	sm_U1[82] = 32'h51f4a750;	sm_U1[83] = 32'h5ffdaa5b;	sm_U1[84] = 32'h75c2896a;	sm_U1[85] = 32'h7bcb8461;	sm_U1[86] = 32'h69d0937c;	sm_U1[87] = 32'h67d99e77;	sm_U1[88] = 32'h3daed51e;	sm_U1[89] = 32'h33a7d815;	sm_U1[90] = 32'h21bccf08;	sm_U1[91] = 32'h2fb5c203;	sm_U1[92] = 32'h058ae132;	sm_U1[93] = 32'h0b83ec39;	sm_U1[94] = 32'h1998fb24;	sm_U1[95] = 32'h1791f62f;
	sm_U1[96] = 32'h764dd68d;	sm_U1[97] = 32'h7844db86;	sm_U1[98] = 32'h6a5fcc9b;	sm_U1[99] = 32'h6456c190;	sm_U1[100] = 32'h4e69e2a1;	sm_U1[101] = 32'h4060efaa;	sm_U1[102] = 32'h527bf8b7;	sm_U1[103] = 32'h5c72f5bc;	sm_U1[104] = 32'h0605bed5;	sm_U1[105] = 32'h080cb3de;	sm_U1[106] = 32'h1a17a4c3;	sm_U1[107] = 32'h141ea9c8;	sm_U1[108] = 32'h3e218af9;	sm_U1[109] = 32'h302887f2;	sm_U1[110] = 32'h223390ef;	sm_U1[111] = 32'h2c3a9de4;
	sm_U1[112] = 32'h96dd063d;	sm_U1[113] = 32'h98d40b36;	sm_U1[114] = 32'h8acf1c2b;	sm_U1[115] = 32'h84c61120;	sm_U1[116] = 32'haef93211;	sm_U1[117] = 32'ha0f03f1a;	sm_U1[118] = 32'hb2eb2807;	sm_U1[119] = 32'hbce2250c;	sm_U1[120] = 32'he6956e65;	sm_U1[121] = 32'he89c636e;	sm_U1[122] = 32'hfa877473;	sm_U1[123] = 32'hf48e7978;	sm_U1[124] = 32'hdeb15a49;	sm_U1[125] = 32'hd0b85742;	sm_U1[126] = 32'hc2a3405f;	sm_U1[127] = 32'hccaa4d54;
	sm_U1[128] = 32'h41ecdaf7;	sm_U1[129] = 32'h4fe5d7fc;	sm_U1[130] = 32'h5dfec0e1;	sm_U1[131] = 32'h53f7cdea;	sm_U1[132] = 32'h79c8eedb;	sm_U1[133] = 32'h77c1e3d0;	sm_U1[134] = 32'h65daf4cd;	sm_U1[135] = 32'h6bd3f9c6;	sm_U1[136] = 32'h31a4b2af;	sm_U1[137] = 32'h3fadbfa4;	sm_U1[138] = 32'h2db6a8b9;	sm_U1[139] = 32'h23bfa5b2;	sm_U1[140] = 32'h09808683;	sm_U1[141] = 32'h07898b88;	sm_U1[142] = 32'h15929c95;	sm_U1[143] = 32'h1b9b919e;
	sm_U1[144] = 32'ha17c0a47;	sm_U1[145] = 32'haf75074c;	sm_U1[146] = 32'hbd6e1051;	sm_U1[147] = 32'hb3671d5a;	sm_U1[148] = 32'h99583e6b;	sm_U1[149] = 32'h97513360;	sm_U1[150] = 32'h854a247d;	sm_U1[151] = 32'h8b432976;	sm_U1[152] = 32'hd134621f;	sm_U1[153] = 32'hdf3d6f14;	sm_U1[154] = 32'hcd267809;	sm_U1[155] = 32'hc32f7502;	sm_U1[156] = 32'he9105633;	sm_U1[157] = 32'he7195b38;	sm_U1[158] = 32'hf5024c25;	sm_U1[159] = 32'hfb0b412e;
	sm_U1[160] = 32'h9ad7618c;	sm_U1[161] = 32'h94de6c87;	sm_U1[162] = 32'h86c57b9a;	sm_U1[163] = 32'h88cc7691;	sm_U1[164] = 32'ha2f355a0;	sm_U1[165] = 32'hacfa58ab;	sm_U1[166] = 32'hbee14fb6;	sm_U1[167] = 32'hb0e842bd;	sm_U1[168] = 32'hea9f09d4;	sm_U1[169] = 32'he49604df;	sm_U1[170] = 32'hf68d13c2;	sm_U1[171] = 32'hf8841ec9;	sm_U1[172] = 32'hd2bb3df8;	sm_U1[173] = 32'hdcb230f3;	sm_U1[174] = 32'hcea927ee;	sm_U1[175] = 32'hc0a02ae5;
	sm_U1[176] = 32'h7a47b13c;	sm_U1[177] = 32'h744ebc37;	sm_U1[178] = 32'h6655ab2a;	sm_U1[179] = 32'h685ca621;	sm_U1[180] = 32'h42638510;	sm_U1[181] = 32'h4c6a881b;	sm_U1[182] = 32'h5e719f06;	sm_U1[183] = 32'h5078920d;	sm_U1[184] = 32'h0a0fd964;	sm_U1[185] = 32'h0406d46f;	sm_U1[186] = 32'h161dc372;	sm_U1[187] = 32'h1814ce79;	sm_U1[188] = 32'h322bed48;	sm_U1[189] = 32'h3c22e043;	sm_U1[190] = 32'h2e39f75e;	sm_U1[191] = 32'h2030fa55;
	sm_U1[192] = 32'hec9ab701;	sm_U1[193] = 32'he293ba0a;	sm_U1[194] = 32'hf088ad17;	sm_U1[195] = 32'hfe81a01c;	sm_U1[196] = 32'hd4be832d;	sm_U1[197] = 32'hdab78e26;	sm_U1[198] = 32'hc8ac993b;	sm_U1[199] = 32'hc6a59430;	sm_U1[200] = 32'h9cd2df59;	sm_U1[201] = 32'h92dbd252;	sm_U1[202] = 32'h80c0c54f;	sm_U1[203] = 32'h8ec9c844;	sm_U1[204] = 32'ha4f6eb75;	sm_U1[205] = 32'haaffe67e;	sm_U1[206] = 32'hb8e4f163;	sm_U1[207] = 32'hb6edfc68;
	sm_U1[208] = 32'h0c0a67b1;	sm_U1[209] = 32'h02036aba;	sm_U1[210] = 32'h10187da7;	sm_U1[211] = 32'h1e1170ac;	sm_U1[212] = 32'h342e539d;	sm_U1[213] = 32'h3a275e96;	sm_U1[214] = 32'h283c498b;	sm_U1[215] = 32'h26354480;	sm_U1[216] = 32'h7c420fe9;	sm_U1[217] = 32'h724b02e2;	sm_U1[218] = 32'h605015ff;	sm_U1[219] = 32'h6e5918f4;	sm_U1[220] = 32'h44663bc5;	sm_U1[221] = 32'h4a6f36ce;	sm_U1[222] = 32'h587421d3;	sm_U1[223] = 32'h567d2cd8;
	sm_U1[224] = 32'h37a10c7a;	sm_U1[225] = 32'h39a80171;	sm_U1[226] = 32'h2bb3166c;	sm_U1[227] = 32'h25ba1b67;	sm_U1[228] = 32'h0f853856;	sm_U1[229] = 32'h018c355d;	sm_U1[230] = 32'h13972240;	sm_U1[231] = 32'h1d9e2f4b;	sm_U1[232] = 32'h47e96422;	sm_U1[233] = 32'h49e06929;	sm_U1[234] = 32'h5bfb7e34;	sm_U1[235] = 32'h55f2733f;	sm_U1[236] = 32'h7fcd500e;	sm_U1[237] = 32'h71c45d05;	sm_U1[238] = 32'h63df4a18;	sm_U1[239] = 32'h6dd64713;
	sm_U1[240] = 32'hd731dcca;	sm_U1[241] = 32'hd938d1c1;	sm_U1[242] = 32'hcb23c6dc;	sm_U1[243] = 32'hc52acbd7;	sm_U1[244] = 32'hef15e8e6;	sm_U1[245] = 32'he11ce5ed;	sm_U1[246] = 32'hf307f2f0;	sm_U1[247] = 32'hfd0efffb;	sm_U1[248] = 32'ha779b492;	sm_U1[249] = 32'ha970b999;	sm_U1[250] = 32'hbb6bae84;	sm_U1[251] = 32'hb562a38f;	sm_U1[252] = 32'h9f5d80be;	sm_U1[253] = 32'h91548db5;	sm_U1[254] = 32'h834f9aa8;	sm_U1[255] = 32'h8d4697a3;
	
	//	sm_U2
	sm_U2[0] = 32'h00000000;	sm_U2[1] = 32'h0b0e090d;	sm_U2[2] = 32'h161c121a;	sm_U2[3] = 32'h1d121b17;	sm_U2[4] = 32'h2c382434;	sm_U2[5] = 32'h27362d39;	sm_U2[6] = 32'h3a24362e;	sm_U2[7] = 32'h312a3f23;	sm_U2[8] = 32'h58704868;	sm_U2[9] = 32'h537e4165;	sm_U2[10] = 32'h4e6c5a72;	sm_U2[11] = 32'h4562537f;	sm_U2[12] = 32'h74486c5c;	sm_U2[13] = 32'h7f466551;	sm_U2[14] = 32'h62547e46;	sm_U2[15] = 32'h695a774b;
	sm_U2[16] = 32'hb0e090d0;	sm_U2[17] = 32'hbbee99dd;	sm_U2[18] = 32'ha6fc82ca;	sm_U2[19] = 32'hadf28bc7;	sm_U2[20] = 32'h9cd8b4e4;	sm_U2[21] = 32'h97d6bde9;	sm_U2[22] = 32'h8ac4a6fe;	sm_U2[23] = 32'h81caaff3;	sm_U2[24] = 32'he890d8b8;	sm_U2[25] = 32'he39ed1b5;	sm_U2[26] = 32'hfe8ccaa2;	sm_U2[27] = 32'hf582c3af;	sm_U2[28] = 32'hc4a8fc8c;	sm_U2[29] = 32'hcfa6f581;	sm_U2[30] = 32'hd2b4ee96;	sm_U2[31] = 32'hd9bae79b;
	sm_U2[32] = 32'h7bdb3bbb;	sm_U2[33] = 32'h70d532b6;	sm_U2[34] = 32'h6dc729a1;	sm_U2[35] = 32'h66c920ac;	sm_U2[36] = 32'h57e31f8f;	sm_U2[37] = 32'h5ced1682;	sm_U2[38] = 32'h41ff0d95;	sm_U2[39] = 32'h4af10498;	sm_U2[40] = 32'h23ab73d3;	sm_U2[41] = 32'h28a57ade;	sm_U2[42] = 32'h35b761c9;	sm_U2[43] = 32'h3eb968c4;	sm_U2[44] = 32'h0f9357e7;	sm_U2[45] = 32'h049d5eea;	sm_U2[46] = 32'h198f45fd;	sm_U2[47] = 32'h12814cf0;
	sm_U2[48] = 32'hcb3bab6b;	sm_U2[49] = 32'hc035a266;	sm_U2[50] = 32'hdd27b971;	sm_U2[51] = 32'hd629b07c;	sm_U2[52] = 32'he7038f5f;	sm_U2[53] = 32'hec0d8652;	sm_U2[54] = 32'hf11f9d45;	sm_U2[55] = 32'hfa119448;	sm_U2[56] = 32'h934be303;	sm_U2[57] = 32'h9845ea0e;	sm_U2[58] = 32'h8557f119;	sm_U2[59] = 32'h8e59f814;	sm_U2[60] = 32'hbf73c737;	sm_U2[61] = 32'hb47dce3a;	sm_U2[62] = 32'ha96fd52d;	sm_U2[63] = 32'ha261dc20;
	sm_U2[64] = 32'hf6ad766d;	sm_U2[65] = 32'hfda37f60;	sm_U2[66] = 32'he0b16477;	sm_U2[67] = 32'hebbf6d7a;	sm_U2[68] = 32'hda955259;	sm_U2[69] = 32'hd19b5b54;	sm_U2[70] = 32'hcc894043;	sm_U2[71] = 32'hc787494e;	sm_U2[72] = 32'haedd3e05;	sm_U2[73] = 32'ha5d33708;	sm_U2[74] = 32'hb8c12c1f;	sm_U2[75] = 32'hb3cf2512;	sm_U2[76] = 32'h82e51a31;	sm_U2[77] = 32'h89eb133c;	sm_U2[78] = 32'h94f9082b;	sm_U2[79] = 32'h9ff70126;
	sm_U2[80] = 32'h464de6bd;	sm_U2[81] = 32'h4d43efb0;	sm_U2[82] = 32'h5051f4a7;	sm_U2[83] = 32'h5b5ffdaa;	sm_U2[84] = 32'h6a75c289;	sm_U2[85] = 32'h617bcb84;	sm_U2[86] = 32'h7c69d093;	sm_U2[87] = 32'h7767d99e;	sm_U2[88] = 32'h1e3daed5;	sm_U2[89] = 32'h1533a7d8;	sm_U2[90] = 32'h0821bccf;	sm_U2[91] = 32'h032fb5c2;	sm_U2[92] = 32'h32058ae1;	sm_U2[93] = 32'h390b83ec;	sm_U2[94] = 32'h241998fb;	sm_U2[95] = 32'h2f1791f6;
	sm_U2[96] = 32'h8d764dd6;	sm_U2[97] = 32'h867844db;	sm_U2[98] = 32'h9b6a5fcc;	sm_U2[99] = 32'h906456c1;	sm_U2[100] = 32'ha14e69e2;	sm_U2[101] = 32'haa4060ef;	sm_U2[102] = 32'hb7527bf8;	sm_U2[103] = 32'hbc5c72f5;	sm_U2[104] = 32'hd50605be;	sm_U2[105] = 32'hde080cb3;	sm_U2[106] = 32'hc31a17a4;	sm_U2[107] = 32'hc8141ea9;	sm_U2[108] = 32'hf93e218a;	sm_U2[109] = 32'hf2302887;	sm_U2[110] = 32'hef223390;	sm_U2[111] = 32'he42c3a9d;
	sm_U2[112] = 32'h3d96dd06;	sm_U2[113] = 32'h3698d40b;	sm_U2[114] = 32'h2b8acf1c;	sm_U2[115] = 32'h2084c611;	sm_U2[116] = 32'h11aef932;	sm_U2[117] = 32'h1aa0f03f;	sm_U2[118] = 32'h07b2eb28;	sm_U2[119] = 32'h0cbce225;	sm_U2[120] = 32'h65e6956e;	sm_U2[121] = 32'h6ee89c63;	sm_U2[122] = 32'h73fa8774;	sm_U2[123] = 32'h78f48e79;	sm_U2[124] = 32'h49deb15a;	sm_U2[125] = 32'h42d0b857;	sm_U2[126] = 32'h5fc2a340;	sm_U2[127] = 32'h54ccaa4d;
	sm_U2[128] = 32'hf741ecda;	sm_U2[129] = 32'hfc4fe5d7;	sm_U2[130] = 32'he15dfec0;	sm_U2[131] = 32'hea53f7cd;	sm_U2[132] = 32'hdb79c8ee;	sm_U2[133] = 32'hd077c1e3;	sm_U2[134] = 32'hcd65daf4;	sm_U2[135] = 32'hc66bd3f9;	sm_U2[136] = 32'haf31a4b2;	sm_U2[137] = 32'ha43fadbf;	sm_U2[138] = 32'hb92db6a8;	sm_U2[139] = 32'hb223bfa5;	sm_U2[140] = 32'h83098086;	sm_U2[141] = 32'h8807898b;	sm_U2[142] = 32'h9515929c;	sm_U2[143] = 32'h9e1b9b91;
	sm_U2[144] = 32'h47a17c0a;	sm_U2[145] = 32'h4caf7507;	sm_U2[146] = 32'h51bd6e10;	sm_U2[147] = 32'h5ab3671d;	sm_U2[148] = 32'h6b99583e;	sm_U2[149] = 32'h60975133;	sm_U2[150] = 32'h7d854a24;	sm_U2[151] = 32'h768b4329;	sm_U2[152] = 32'h1fd13462;	sm_U2[153] = 32'h14df3d6f;	sm_U2[154] = 32'h09cd2678;	sm_U2[155] = 32'h02c32f75;	sm_U2[156] = 32'h33e91056;	sm_U2[157] = 32'h38e7195b;	sm_U2[158] = 32'h25f5024c;	sm_U2[159] = 32'h2efb0b41;
	sm_U2[160] = 32'h8c9ad761;	sm_U2[161] = 32'h8794de6c;	sm_U2[162] = 32'h9a86c57b;	sm_U2[163] = 32'h9188cc76;	sm_U2[164] = 32'ha0a2f355;	sm_U2[165] = 32'habacfa58;	sm_U2[166] = 32'hb6bee14f;	sm_U2[167] = 32'hbdb0e842;	sm_U2[168] = 32'hd4ea9f09;	sm_U2[169] = 32'hdfe49604;	sm_U2[170] = 32'hc2f68d13;	sm_U2[171] = 32'hc9f8841e;	sm_U2[172] = 32'hf8d2bb3d;	sm_U2[173] = 32'hf3dcb230;	sm_U2[174] = 32'heecea927;	sm_U2[175] = 32'he5c0a02a;
	sm_U2[176] = 32'h3c7a47b1;	sm_U2[177] = 32'h37744ebc;	sm_U2[178] = 32'h2a6655ab;	sm_U2[179] = 32'h21685ca6;	sm_U2[180] = 32'h10426385;	sm_U2[181] = 32'h1b4c6a88;	sm_U2[182] = 32'h065e719f;	sm_U2[183] = 32'h0d507892;	sm_U2[184] = 32'h640a0fd9;	sm_U2[185] = 32'h6f0406d4;	sm_U2[186] = 32'h72161dc3;	sm_U2[187] = 32'h791814ce;	sm_U2[188] = 32'h48322bed;	sm_U2[189] = 32'h433c22e0;	sm_U2[190] = 32'h5e2e39f7;	sm_U2[191] = 32'h552030fa;
	sm_U2[192] = 32'h01ec9ab7;	sm_U2[193] = 32'h0ae293ba;	sm_U2[194] = 32'h17f088ad;	sm_U2[195] = 32'h1cfe81a0;	sm_U2[196] = 32'h2dd4be83;	sm_U2[197] = 32'h26dab78e;	sm_U2[198] = 32'h3bc8ac99;	sm_U2[199] = 32'h30c6a594;	sm_U2[200] = 32'h599cd2df;	sm_U2[201] = 32'h5292dbd2;	sm_U2[202] = 32'h4f80c0c5;	sm_U2[203] = 32'h448ec9c8;	sm_U2[204] = 32'h75a4f6eb;	sm_U2[205] = 32'h7eaaffe6;	sm_U2[206] = 32'h63b8e4f1;	sm_U2[207] = 32'h68b6edfc;
	sm_U2[208] = 32'hb10c0a67;	sm_U2[209] = 32'hba02036a;	sm_U2[210] = 32'ha710187d;	sm_U2[211] = 32'hac1e1170;	sm_U2[212] = 32'h9d342e53;	sm_U2[213] = 32'h963a275e;	sm_U2[214] = 32'h8b283c49;	sm_U2[215] = 32'h80263544;	sm_U2[216] = 32'he97c420f;	sm_U2[217] = 32'he2724b02;	sm_U2[218] = 32'hff605015;	sm_U2[219] = 32'hf46e5918;	sm_U2[220] = 32'hc544663b;	sm_U2[221] = 32'hce4a6f36;	sm_U2[222] = 32'hd3587421;	sm_U2[223] = 32'hd8567d2c;
	sm_U2[224] = 32'h7a37a10c;	sm_U2[225] = 32'h7139a801;	sm_U2[226] = 32'h6c2bb316;	sm_U2[227] = 32'h6725ba1b;	sm_U2[228] = 32'h560f8538;	sm_U2[229] = 32'h5d018c35;	sm_U2[230] = 32'h40139722;	sm_U2[231] = 32'h4b1d9e2f;	sm_U2[232] = 32'h2247e964;	sm_U2[233] = 32'h2949e069;	sm_U2[234] = 32'h345bfb7e;	sm_U2[235] = 32'h3f55f273;	sm_U2[236] = 32'h0e7fcd50;	sm_U2[237] = 32'h0571c45d;	sm_U2[238] = 32'h1863df4a;	sm_U2[239] = 32'h136dd647;
	sm_U2[240] = 32'hcad731dc;	sm_U2[241] = 32'hc1d938d1;	sm_U2[242] = 32'hdccb23c6;	sm_U2[243] = 32'hd7c52acb;	sm_U2[244] = 32'he6ef15e8;	sm_U2[245] = 32'hede11ce5;	sm_U2[246] = 32'hf0f307f2;	sm_U2[247] = 32'hfbfd0eff;	sm_U2[248] = 32'h92a779b4;	sm_U2[249] = 32'h99a970b9;	sm_U2[250] = 32'h84bb6bae;	sm_U2[251] = 32'h8fb562a3;	sm_U2[252] = 32'hbe9f5d80;	sm_U2[253] = 32'hb591548d;	sm_U2[254] = 32'ha8834f9a;	sm_U2[255] = 32'ha38d4697;
	
	//	sm_U3
	sm_U3[0] = 32'h00000000;	sm_U3[1] = 32'h0d0b0e09;	sm_U3[2] = 32'h1a161c12;	sm_U3[3] = 32'h171d121b;	sm_U3[4] = 32'h342c3824;	sm_U3[5] = 32'h3927362d;	sm_U3[6] = 32'h2e3a2436;	sm_U3[7] = 32'h23312a3f;	sm_U3[8] = 32'h68587048;	sm_U3[9] = 32'h65537e41;	sm_U3[10] = 32'h724e6c5a;	sm_U3[11] = 32'h7f456253;	sm_U3[12] = 32'h5c74486c;	sm_U3[13] = 32'h517f4665;	sm_U3[14] = 32'h4662547e;	sm_U3[15] = 32'h4b695a77;
	sm_U3[16] = 32'hd0b0e090;	sm_U3[17] = 32'hddbbee99;	sm_U3[18] = 32'hcaa6fc82;	sm_U3[19] = 32'hc7adf28b;	sm_U3[20] = 32'he49cd8b4;	sm_U3[21] = 32'he997d6bd;	sm_U3[22] = 32'hfe8ac4a6;	sm_U3[23] = 32'hf381caaf;	sm_U3[24] = 32'hb8e890d8;	sm_U3[25] = 32'hb5e39ed1;	sm_U3[26] = 32'ha2fe8cca;	sm_U3[27] = 32'haff582c3;	sm_U3[28] = 32'h8cc4a8fc;	sm_U3[29] = 32'h81cfa6f5;	sm_U3[30] = 32'h96d2b4ee;	sm_U3[31] = 32'h9bd9bae7;
	sm_U3[32] = 32'hbb7bdb3b;	sm_U3[33] = 32'hb670d532;	sm_U3[34] = 32'ha16dc729;	sm_U3[35] = 32'hac66c920;	sm_U3[36] = 32'h8f57e31f;	sm_U3[37] = 32'h825ced16;	sm_U3[38] = 32'h9541ff0d;	sm_U3[39] = 32'h984af104;	sm_U3[40] = 32'hd323ab73;	sm_U3[41] = 32'hde28a57a;	sm_U3[42] = 32'hc935b761;	sm_U3[43] = 32'hc43eb968;	sm_U3[44] = 32'he70f9357;	sm_U3[45] = 32'hea049d5e;	sm_U3[46] = 32'hfd198f45;	sm_U3[47] = 32'hf012814c;
	sm_U3[48] = 32'h6bcb3bab;	sm_U3[49] = 32'h66c035a2;	sm_U3[50] = 32'h71dd27b9;	sm_U3[51] = 32'h7cd629b0;	sm_U3[52] = 32'h5fe7038f;	sm_U3[53] = 32'h52ec0d86;	sm_U3[54] = 32'h45f11f9d;	sm_U3[55] = 32'h48fa1194;	sm_U3[56] = 32'h03934be3;	sm_U3[57] = 32'h0e9845ea;	sm_U3[58] = 32'h198557f1;	sm_U3[59] = 32'h148e59f8;	sm_U3[60] = 32'h37bf73c7;	sm_U3[61] = 32'h3ab47dce;	sm_U3[62] = 32'h2da96fd5;	sm_U3[63] = 32'h20a261dc;
	sm_U3[64] = 32'h6df6ad76;	sm_U3[65] = 32'h60fda37f;	sm_U3[66] = 32'h77e0b164;	sm_U3[67] = 32'h7aebbf6d;	sm_U3[68] = 32'h59da9552;	sm_U3[69] = 32'h54d19b5b;	sm_U3[70] = 32'h43cc8940;	sm_U3[71] = 32'h4ec78749;	sm_U3[72] = 32'h05aedd3e;	sm_U3[73] = 32'h08a5d337;	sm_U3[74] = 32'h1fb8c12c;	sm_U3[75] = 32'h12b3cf25;	sm_U3[76] = 32'h3182e51a;	sm_U3[77] = 32'h3c89eb13;	sm_U3[78] = 32'h2b94f908;	sm_U3[79] = 32'h269ff701;
	sm_U3[80] = 32'hbd464de6;	sm_U3[81] = 32'hb04d43ef;	sm_U3[82] = 32'ha75051f4;	sm_U3[83] = 32'haa5b5ffd;	sm_U3[84] = 32'h896a75c2;	sm_U3[85] = 32'h84617bcb;	sm_U3[86] = 32'h937c69d0;	sm_U3[87] = 32'h9e7767d9;	sm_U3[88] = 32'hd51e3dae;	sm_U3[89] = 32'hd81533a7;	sm_U3[90] = 32'hcf0821bc;	sm_U3[91] = 32'hc2032fb5;	sm_U3[92] = 32'he132058a;	sm_U3[93] = 32'hec390b83;	sm_U3[94] = 32'hfb241998;	sm_U3[95] = 32'hf62f1791;
	sm_U3[96] = 32'hd68d764d;	sm_U3[97] = 32'hdb867844;	sm_U3[98] = 32'hcc9b6a5f;	sm_U3[99] = 32'hc1906456;	sm_U3[100] = 32'he2a14e69;	sm_U3[101] = 32'hefaa4060;	sm_U3[102] = 32'hf8b7527b;	sm_U3[103] = 32'hf5bc5c72;	sm_U3[104] = 32'hbed50605;	sm_U3[105] = 32'hb3de080c;	sm_U3[106] = 32'ha4c31a17;	sm_U3[107] = 32'ha9c8141e;	sm_U3[108] = 32'h8af93e21;	sm_U3[109] = 32'h87f23028;	sm_U3[110] = 32'h90ef2233;	sm_U3[111] = 32'h9de42c3a;
	sm_U3[112] = 32'h063d96dd;	sm_U3[113] = 32'h0b3698d4;	sm_U3[114] = 32'h1c2b8acf;	sm_U3[115] = 32'h112084c6;	sm_U3[116] = 32'h3211aef9;	sm_U3[117] = 32'h3f1aa0f0;	sm_U3[118] = 32'h2807b2eb;	sm_U3[119] = 32'h250cbce2;	sm_U3[120] = 32'h6e65e695;	sm_U3[121] = 32'h636ee89c;	sm_U3[122] = 32'h7473fa87;	sm_U3[123] = 32'h7978f48e;	sm_U3[124] = 32'h5a49deb1;	sm_U3[125] = 32'h5742d0b8;	sm_U3[126] = 32'h405fc2a3;	sm_U3[127] = 32'h4d54ccaa;
	sm_U3[128] = 32'hdaf741ec;	sm_U3[129] = 32'hd7fc4fe5;	sm_U3[130] = 32'hc0e15dfe;	sm_U3[131] = 32'hcdea53f7;	sm_U3[132] = 32'heedb79c8;	sm_U3[133] = 32'he3d077c1;	sm_U3[134] = 32'hf4cd65da;	sm_U3[135] = 32'hf9c66bd3;	sm_U3[136] = 32'hb2af31a4;	sm_U3[137] = 32'hbfa43fad;	sm_U3[138] = 32'ha8b92db6;	sm_U3[139] = 32'ha5b223bf;	sm_U3[140] = 32'h86830980;	sm_U3[141] = 32'h8b880789;	sm_U3[142] = 32'h9c951592;	sm_U3[143] = 32'h919e1b9b;
	sm_U3[144] = 32'h0a47a17c;	sm_U3[145] = 32'h074caf75;	sm_U3[146] = 32'h1051bd6e;	sm_U3[147] = 32'h1d5ab367;	sm_U3[148] = 32'h3e6b9958;	sm_U3[149] = 32'h33609751;	sm_U3[150] = 32'h247d854a;	sm_U3[151] = 32'h29768b43;	sm_U3[152] = 32'h621fd134;	sm_U3[153] = 32'h6f14df3d;	sm_U3[154] = 32'h7809cd26;	sm_U3[155] = 32'h7502c32f;	sm_U3[156] = 32'h5633e910;	sm_U3[157] = 32'h5b38e719;	sm_U3[158] = 32'h4c25f502;	sm_U3[159] = 32'h412efb0b;
	sm_U3[160] = 32'h618c9ad7;	sm_U3[161] = 32'h6c8794de;	sm_U3[162] = 32'h7b9a86c5;	sm_U3[163] = 32'h769188cc;	sm_U3[164] = 32'h55a0a2f3;	sm_U3[165] = 32'h58abacfa;	sm_U3[166] = 32'h4fb6bee1;	sm_U3[167] = 32'h42bdb0e8;	sm_U3[168] = 32'h09d4ea9f;	sm_U3[169] = 32'h04dfe496;	sm_U3[170] = 32'h13c2f68d;	sm_U3[171] = 32'h1ec9f884;	sm_U3[172] = 32'h3df8d2bb;	sm_U3[173] = 32'h30f3dcb2;	sm_U3[174] = 32'h27eecea9;	sm_U3[175] = 32'h2ae5c0a0;
	sm_U3[176] = 32'hb13c7a47;	sm_U3[177] = 32'hbc37744e;	sm_U3[178] = 32'hab2a6655;	sm_U3[179] = 32'ha621685c;	sm_U3[180] = 32'h85104263;	sm_U3[181] = 32'h881b4c6a;	sm_U3[182] = 32'h9f065e71;	sm_U3[183] = 32'h920d5078;	sm_U3[184] = 32'hd9640a0f;	sm_U3[185] = 32'hd46f0406;	sm_U3[186] = 32'hc372161d;	sm_U3[187] = 32'hce791814;	sm_U3[188] = 32'hed48322b;	sm_U3[189] = 32'he0433c22;	sm_U3[190] = 32'hf75e2e39;	sm_U3[191] = 32'hfa552030;
	sm_U3[192] = 32'hb701ec9a;	sm_U3[193] = 32'hba0ae293;	sm_U3[194] = 32'had17f088;	sm_U3[195] = 32'ha01cfe81;	sm_U3[196] = 32'h832dd4be;	sm_U3[197] = 32'h8e26dab7;	sm_U3[198] = 32'h993bc8ac;	sm_U3[199] = 32'h9430c6a5;	sm_U3[200] = 32'hdf599cd2;	sm_U3[201] = 32'hd25292db;	sm_U3[202] = 32'hc54f80c0;	sm_U3[203] = 32'hc8448ec9;	sm_U3[204] = 32'heb75a4f6;	sm_U3[205] = 32'he67eaaff;	sm_U3[206] = 32'hf163b8e4;	sm_U3[207] = 32'hfc68b6ed;
	sm_U3[208] = 32'h67b10c0a;	sm_U3[209] = 32'h6aba0203;	sm_U3[210] = 32'h7da71018;	sm_U3[211] = 32'h70ac1e11;	sm_U3[212] = 32'h539d342e;	sm_U3[213] = 32'h5e963a27;	sm_U3[214] = 32'h498b283c;	sm_U3[215] = 32'h44802635;	sm_U3[216] = 32'h0fe97c42;	sm_U3[217] = 32'h02e2724b;	sm_U3[218] = 32'h15ff6050;	sm_U3[219] = 32'h18f46e59;	sm_U3[220] = 32'h3bc54466;	sm_U3[221] = 32'h36ce4a6f;	sm_U3[222] = 32'h21d35874;	sm_U3[223] = 32'h2cd8567d;
	sm_U3[224] = 32'h0c7a37a1;	sm_U3[225] = 32'h017139a8;	sm_U3[226] = 32'h166c2bb3;	sm_U3[227] = 32'h1b6725ba;	sm_U3[228] = 32'h38560f85;	sm_U3[229] = 32'h355d018c;	sm_U3[230] = 32'h22401397;	sm_U3[231] = 32'h2f4b1d9e;	sm_U3[232] = 32'h642247e9;	sm_U3[233] = 32'h692949e0;	sm_U3[234] = 32'h7e345bfb;	sm_U3[235] = 32'h733f55f2;	sm_U3[236] = 32'h500e7fcd;	sm_U3[237] = 32'h5d0571c4;	sm_U3[238] = 32'h4a1863df;	sm_U3[239] = 32'h47136dd6;
	sm_U3[240] = 32'hdccad731;	sm_U3[241] = 32'hd1c1d938;	sm_U3[242] = 32'hc6dccb23;	sm_U3[243] = 32'hcbd7c52a;	sm_U3[244] = 32'he8e6ef15;	sm_U3[245] = 32'he5ede11c;	sm_U3[246] = 32'hf2f0f307;	sm_U3[247] = 32'hfffbfd0e;	sm_U3[248] = 32'hb492a779;	sm_U3[249] = 32'hb999a970;	sm_U3[250] = 32'hae84bb6b;	sm_U3[251] = 32'ha38fb562;	sm_U3[252] = 32'h80be9f5d;	sm_U3[253] = 32'h8db59154;	sm_U3[254] = 32'h9aa8834f;	sm_U3[255] = 32'h97a38d46;
	
	//	sm_U4
	sm_U4[0] = 32'h00000000;	sm_U4[1] = 32'h090d0b0e;	sm_U4[2] = 32'h121a161c;	sm_U4[3] = 32'h1b171d12;	sm_U4[4] = 32'h24342c38;	sm_U4[5] = 32'h2d392736;	sm_U4[6] = 32'h362e3a24;	sm_U4[7] = 32'h3f23312a;	sm_U4[8] = 32'h48685870;	sm_U4[9] = 32'h4165537e;	sm_U4[10] = 32'h5a724e6c;	sm_U4[11] = 32'h537f4562;	sm_U4[12] = 32'h6c5c7448;	sm_U4[13] = 32'h65517f46;	sm_U4[14] = 32'h7e466254;	sm_U4[15] = 32'h774b695a;
	sm_U4[16] = 32'h90d0b0e0;	sm_U4[17] = 32'h99ddbbee;	sm_U4[18] = 32'h82caa6fc;	sm_U4[19] = 32'h8bc7adf2;	sm_U4[20] = 32'hb4e49cd8;	sm_U4[21] = 32'hbde997d6;	sm_U4[22] = 32'ha6fe8ac4;	sm_U4[23] = 32'haff381ca;	sm_U4[24] = 32'hd8b8e890;	sm_U4[25] = 32'hd1b5e39e;	sm_U4[26] = 32'hcaa2fe8c;	sm_U4[27] = 32'hc3aff582;	sm_U4[28] = 32'hfc8cc4a8;	sm_U4[29] = 32'hf581cfa6;	sm_U4[30] = 32'hee96d2b4;	sm_U4[31] = 32'he79bd9ba;
	sm_U4[32] = 32'h3bbb7bdb;	sm_U4[33] = 32'h32b670d5;	sm_U4[34] = 32'h29a16dc7;	sm_U4[35] = 32'h20ac66c9;	sm_U4[36] = 32'h1f8f57e3;	sm_U4[37] = 32'h16825ced;	sm_U4[38] = 32'h0d9541ff;	sm_U4[39] = 32'h04984af1;	sm_U4[40] = 32'h73d323ab;	sm_U4[41] = 32'h7ade28a5;	sm_U4[42] = 32'h61c935b7;	sm_U4[43] = 32'h68c43eb9;	sm_U4[44] = 32'h57e70f93;	sm_U4[45] = 32'h5eea049d;	sm_U4[46] = 32'h45fd198f;	sm_U4[47] = 32'h4cf01281;
	sm_U4[48] = 32'hab6bcb3b;	sm_U4[49] = 32'ha266c035;	sm_U4[50] = 32'hb971dd27;	sm_U4[51] = 32'hb07cd629;	sm_U4[52] = 32'h8f5fe703;	sm_U4[53] = 32'h8652ec0d;	sm_U4[54] = 32'h9d45f11f;	sm_U4[55] = 32'h9448fa11;	sm_U4[56] = 32'he303934b;	sm_U4[57] = 32'hea0e9845;	sm_U4[58] = 32'hf1198557;	sm_U4[59] = 32'hf8148e59;	sm_U4[60] = 32'hc737bf73;	sm_U4[61] = 32'hce3ab47d;	sm_U4[62] = 32'hd52da96f;	sm_U4[63] = 32'hdc20a261;
	sm_U4[64] = 32'h766df6ad;	sm_U4[65] = 32'h7f60fda3;	sm_U4[66] = 32'h6477e0b1;	sm_U4[67] = 32'h6d7aebbf;	sm_U4[68] = 32'h5259da95;	sm_U4[69] = 32'h5b54d19b;	sm_U4[70] = 32'h4043cc89;	sm_U4[71] = 32'h494ec787;	sm_U4[72] = 32'h3e05aedd;	sm_U4[73] = 32'h3708a5d3;	sm_U4[74] = 32'h2c1fb8c1;	sm_U4[75] = 32'h2512b3cf;	sm_U4[76] = 32'h1a3182e5;	sm_U4[77] = 32'h133c89eb;	sm_U4[78] = 32'h082b94f9;	sm_U4[79] = 32'h01269ff7;
	sm_U4[80] = 32'he6bd464d;	sm_U4[81] = 32'hefb04d43;	sm_U4[82] = 32'hf4a75051;	sm_U4[83] = 32'hfdaa5b5f;	sm_U4[84] = 32'hc2896a75;	sm_U4[85] = 32'hcb84617b;	sm_U4[86] = 32'hd0937c69;	sm_U4[87] = 32'hd99e7767;	sm_U4[88] = 32'haed51e3d;	sm_U4[89] = 32'ha7d81533;	sm_U4[90] = 32'hbccf0821;	sm_U4[91] = 32'hb5c2032f;	sm_U4[92] = 32'h8ae13205;	sm_U4[93] = 32'h83ec390b;	sm_U4[94] = 32'h98fb2419;	sm_U4[95] = 32'h91f62f17;
	sm_U4[96] = 32'h4dd68d76;	sm_U4[97] = 32'h44db8678;	sm_U4[98] = 32'h5fcc9b6a;	sm_U4[99] = 32'h56c19064;	sm_U4[100] = 32'h69e2a14e;	sm_U4[101] = 32'h60efaa40;	sm_U4[102] = 32'h7bf8b752;	sm_U4[103] = 32'h72f5bc5c;	sm_U4[104] = 32'h05bed506;	sm_U4[105] = 32'h0cb3de08;	sm_U4[106] = 32'h17a4c31a;	sm_U4[107] = 32'h1ea9c814;	sm_U4[108] = 32'h218af93e;	sm_U4[109] = 32'h2887f230;	sm_U4[110] = 32'h3390ef22;	sm_U4[111] = 32'h3a9de42c;
	sm_U4[112] = 32'hdd063d96;	sm_U4[113] = 32'hd40b3698;	sm_U4[114] = 32'hcf1c2b8a;	sm_U4[115] = 32'hc6112084;	sm_U4[116] = 32'hf93211ae;	sm_U4[117] = 32'hf03f1aa0;	sm_U4[118] = 32'heb2807b2;	sm_U4[119] = 32'he2250cbc;	sm_U4[120] = 32'h956e65e6;	sm_U4[121] = 32'h9c636ee8;	sm_U4[122] = 32'h877473fa;	sm_U4[123] = 32'h8e7978f4;	sm_U4[124] = 32'hb15a49de;	sm_U4[125] = 32'hb85742d0;	sm_U4[126] = 32'ha3405fc2;	sm_U4[127] = 32'haa4d54cc;
	sm_U4[128] = 32'hecdaf741;	sm_U4[129] = 32'he5d7fc4f;	sm_U4[130] = 32'hfec0e15d;	sm_U4[131] = 32'hf7cdea53;	sm_U4[132] = 32'hc8eedb79;	sm_U4[133] = 32'hc1e3d077;	sm_U4[134] = 32'hdaf4cd65;	sm_U4[135] = 32'hd3f9c66b;	sm_U4[136] = 32'ha4b2af31;	sm_U4[137] = 32'hadbfa43f;	sm_U4[138] = 32'hb6a8b92d;	sm_U4[139] = 32'hbfa5b223;	sm_U4[140] = 32'h80868309;	sm_U4[141] = 32'h898b8807;	sm_U4[142] = 32'h929c9515;	sm_U4[143] = 32'h9b919e1b;
	sm_U4[144] = 32'h7c0a47a1;	sm_U4[145] = 32'h75074caf;	sm_U4[146] = 32'h6e1051bd;	sm_U4[147] = 32'h671d5ab3;	sm_U4[148] = 32'h583e6b99;	sm_U4[149] = 32'h51336097;	sm_U4[150] = 32'h4a247d85;	sm_U4[151] = 32'h4329768b;	sm_U4[152] = 32'h34621fd1;	sm_U4[153] = 32'h3d6f14df;	sm_U4[154] = 32'h267809cd;	sm_U4[155] = 32'h2f7502c3;	sm_U4[156] = 32'h105633e9;	sm_U4[157] = 32'h195b38e7;	sm_U4[158] = 32'h024c25f5;	sm_U4[159] = 32'h0b412efb;
	sm_U4[160] = 32'hd7618c9a;	sm_U4[161] = 32'hde6c8794;	sm_U4[162] = 32'hc57b9a86;	sm_U4[163] = 32'hcc769188;	sm_U4[164] = 32'hf355a0a2;	sm_U4[165] = 32'hfa58abac;	sm_U4[166] = 32'he14fb6be;	sm_U4[167] = 32'he842bdb0;	sm_U4[168] = 32'h9f09d4ea;	sm_U4[169] = 32'h9604dfe4;	sm_U4[170] = 32'h8d13c2f6;	sm_U4[171] = 32'h841ec9f8;	sm_U4[172] = 32'hbb3df8d2;	sm_U4[173] = 32'hb230f3dc;	sm_U4[174] = 32'ha927eece;	sm_U4[175] = 32'ha02ae5c0;
	sm_U4[176] = 32'h47b13c7a;	sm_U4[177] = 32'h4ebc3774;	sm_U4[178] = 32'h55ab2a66;	sm_U4[179] = 32'h5ca62168;	sm_U4[180] = 32'h63851042;	sm_U4[181] = 32'h6a881b4c;	sm_U4[182] = 32'h719f065e;	sm_U4[183] = 32'h78920d50;	sm_U4[184] = 32'h0fd9640a;	sm_U4[185] = 32'h06d46f04;	sm_U4[186] = 32'h1dc37216;	sm_U4[187] = 32'h14ce7918;	sm_U4[188] = 32'h2bed4832;	sm_U4[189] = 32'h22e0433c;	sm_U4[190] = 32'h39f75e2e;	sm_U4[191] = 32'h30fa5520;
	sm_U4[192] = 32'h9ab701ec;	sm_U4[193] = 32'h93ba0ae2;	sm_U4[194] = 32'h88ad17f0;	sm_U4[195] = 32'h81a01cfe;	sm_U4[196] = 32'hbe832dd4;	sm_U4[197] = 32'hb78e26da;	sm_U4[198] = 32'hac993bc8;	sm_U4[199] = 32'ha59430c6;	sm_U4[200] = 32'hd2df599c;	sm_U4[201] = 32'hdbd25292;	sm_U4[202] = 32'hc0c54f80;	sm_U4[203] = 32'hc9c8448e;	sm_U4[204] = 32'hf6eb75a4;	sm_U4[205] = 32'hffe67eaa;	sm_U4[206] = 32'he4f163b8;	sm_U4[207] = 32'hedfc68b6;
	sm_U4[208] = 32'h0a67b10c;	sm_U4[209] = 32'h036aba02;	sm_U4[210] = 32'h187da710;	sm_U4[211] = 32'h1170ac1e;	sm_U4[212] = 32'h2e539d34;	sm_U4[213] = 32'h275e963a;	sm_U4[214] = 32'h3c498b28;	sm_U4[215] = 32'h35448026;	sm_U4[216] = 32'h420fe97c;	sm_U4[217] = 32'h4b02e272;	sm_U4[218] = 32'h5015ff60;	sm_U4[219] = 32'h5918f46e;	sm_U4[220] = 32'h663bc544;	sm_U4[221] = 32'h6f36ce4a;	sm_U4[222] = 32'h7421d358;	sm_U4[223] = 32'h7d2cd856;
	sm_U4[224] = 32'ha10c7a37;	sm_U4[225] = 32'ha8017139;	sm_U4[226] = 32'hb3166c2b;	sm_U4[227] = 32'hba1b6725;	sm_U4[228] = 32'h8538560f;	sm_U4[229] = 32'h8c355d01;	sm_U4[230] = 32'h97224013;	sm_U4[231] = 32'h9e2f4b1d;	sm_U4[232] = 32'he9642247;	sm_U4[233] = 32'he0692949;	sm_U4[234] = 32'hfb7e345b;	sm_U4[235] = 32'hf2733f55;	sm_U4[236] = 32'hcd500e7f;	sm_U4[237] = 32'hc45d0571;	sm_U4[238] = 32'hdf4a1863;	sm_U4[239] = 32'hd647136d;
	sm_U4[240] = 32'h31dccad7;	sm_U4[241] = 32'h38d1c1d9;	sm_U4[242] = 32'h23c6dccb;	sm_U4[243] = 32'h2acbd7c5;	sm_U4[244] = 32'h15e8e6ef;	sm_U4[245] = 32'h1ce5ede1;	sm_U4[246] = 32'h07f2f0f3;	sm_U4[247] = 32'h0efffbfd;	sm_U4[248] = 32'h79b492a7;	sm_U4[249] = 32'h70b999a9;	sm_U4[250] = 32'h6bae84bb;	sm_U4[251] = 32'h62a38fb5;	sm_U4[252] = 32'h5d80be9f;	sm_U4[253] = 32'h548db591;	sm_U4[254] = 32'h4f9aa883;	sm_U4[255] = 32'h4697a38d;
 
 end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 
 assign SBOX_data_OUT_1 = SBOX_data_1_1 ^ SBOX_data_1_2 ^ SBOX_data_1_3 ^ SBOX_data_1_4;
 assign SBOX_data_OUT_2 = SBOX_data_2_1 ^ SBOX_data_2_2 ^ SBOX_data_2_3 ^ SBOX_data_2_4;
 assign SBOX_data_OUT_3 = SBOX_data_3_1 ^ SBOX_data_3_2 ^ SBOX_data_3_3 ^ SBOX_data_3_4;
 assign SBOX_data_OUT_4 = SBOX_data_4_1 ^ SBOX_data_4_2 ^ SBOX_data_4_3 ^ SBOX_data_4_4;

 assign Condition_for_not_change = ( ~oRAM_Kd_addr[3] & ~oRAM_Kd_addr[2] & ~oRAM_Kd_addr[1] & ~oRAM_Kd_addr[0] ) | (oRAM_Kd_addr == iRound);
 //oRAM_Kd_addr = 0000 or iRound (10,12,14) - Phat
 
 //round 0 and last round run normally, and other use Inverse_MixColumn_- Phat
 assign oRAM_Kd_data_1 = (Condition_for_not_change) ? RAM_Kd_data_1 : SBOX_data_OUT_1;
 assign oRAM_Kd_data_2 = (Condition_for_not_change) ? RAM_Kd_data_2 : SBOX_data_OUT_2;
 assign oRAM_Kd_data_3 = (Condition_for_not_change) ? RAM_Kd_data_3 : SBOX_data_OUT_3;
 assign oRAM_Kd_data_4 = (Condition_for_not_change) ? RAM_Kd_data_4 : SBOX_data_OUT_4;
 
/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			oRAM_Kd_addr <= 4'b0;
			oRAM_Kd_write_1 <= 1'b0;
			oRAM_Kd_write_2 <= 1'b0;
			oRAM_Kd_write_3 <= 1'b0;
			oRAM_Kd_write_4 <= 1'b0;

			RAM_Kd_data_1 <= 32'b0;
			RAM_Kd_data_2 <= 32'b0;
			RAM_Kd_data_3 <= 32'b0;
			RAM_Kd_data_4 <= 32'b0;
		end
	else
		begin
			oRAM_Kd_addr <= iRAM_Kd_addr;
			oRAM_Kd_write_1 <= iRAM_Kd_write_1;
			oRAM_Kd_write_2 <= iRAM_Kd_write_2;
			oRAM_Kd_write_3 <= iRAM_Kd_write_3;
			oRAM_Kd_write_4 <= iRAM_Kd_write_4;

			RAM_Kd_data_1 <= iRAM_Kd_data_1;
			RAM_Kd_data_2 <= iRAM_Kd_data_2;
			RAM_Kd_data_3 <= iRAM_Kd_data_3;
			RAM_Kd_data_4 <= iRAM_Kd_data_4;
		end
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			SBOX_data_1_1 <= 32'b0;
			SBOX_data_1_2 <= 32'b0;
			SBOX_data_1_3 <= 32'b0;
			SBOX_data_1_4 <= 32'b0;
		end
	else if(iRAM_Kd_write_1)
		begin
			SBOX_data_1_1 <= sm_U1[iRAM_Kd_data_1[31:24]];
			SBOX_data_1_2 <= sm_U2[iRAM_Kd_data_1[23:16]];
			SBOX_data_1_3 <= sm_U3[iRAM_Kd_data_1[15:8]];
			SBOX_data_1_4 <= sm_U4[iRAM_Kd_data_1[7:0]];
		end
	else
		begin
			SBOX_data_1_1 <= SBOX_data_1_1;
			SBOX_data_1_2 <= SBOX_data_1_2;
			SBOX_data_1_3 <= SBOX_data_1_3;
			SBOX_data_1_4 <= SBOX_data_1_4;
		end
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			SBOX_data_2_1 <= 32'b0;
			SBOX_data_2_2 <= 32'b0;
			SBOX_data_2_3 <= 32'b0;
			SBOX_data_2_4 <= 32'b0;
		end
	else if(iRAM_Kd_write_2)
		begin
			SBOX_data_2_1 <= sm_U1[iRAM_Kd_data_2[31:24]];
			SBOX_data_2_2 <= sm_U2[iRAM_Kd_data_2[23:16]];
			SBOX_data_2_3 <= sm_U3[iRAM_Kd_data_2[15:8]];
			SBOX_data_2_4 <= sm_U4[iRAM_Kd_data_2[7:0]];
		end
	else
		begin
			SBOX_data_2_1 <= SBOX_data_2_1;
			SBOX_data_2_2 <= SBOX_data_2_2;
			SBOX_data_2_3 <= SBOX_data_2_3;
			SBOX_data_2_4 <= SBOX_data_2_4;
		end
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			SBOX_data_3_1 <= 32'b0;
			SBOX_data_3_2 <= 32'b0;
			SBOX_data_3_3 <= 32'b0;
			SBOX_data_3_4 <= 32'b0;
		end
	else if(iRAM_Kd_write_3)
		begin
			SBOX_data_3_1 <= sm_U1[iRAM_Kd_data_3[31:24]];
			SBOX_data_3_2 <= sm_U2[iRAM_Kd_data_3[23:16]];
			SBOX_data_3_3 <= sm_U3[iRAM_Kd_data_3[15:8]];
			SBOX_data_3_4 <= sm_U4[iRAM_Kd_data_3[7:0]];
		end
	else
		begin
			SBOX_data_3_1 <= SBOX_data_3_1;
			SBOX_data_3_2 <= SBOX_data_3_2;
			SBOX_data_3_3 <= SBOX_data_3_3;
			SBOX_data_3_4 <= SBOX_data_3_4;
		end
 end
 
 always@(posedge iClk)
 begin
	if(~iRst_n)
		begin
			SBOX_data_4_1 <= 32'b0;
			SBOX_data_4_2 <= 32'b0;
			SBOX_data_4_3 <= 32'b0;
			SBOX_data_4_4 <= 32'b0;
		end
	else if(iRAM_Kd_write_4)
		begin
			SBOX_data_4_1 <= sm_U1[iRAM_Kd_data_4[31:24]];
			SBOX_data_4_2 <= sm_U2[iRAM_Kd_data_4[23:16]];
			SBOX_data_4_3 <= sm_U3[iRAM_Kd_data_4[15:8]];
			SBOX_data_4_4 <= sm_U4[iRAM_Kd_data_4[7:0]];
		end
	else
		begin
			SBOX_data_4_1 <= SBOX_data_4_1;
			SBOX_data_4_2 <= SBOX_data_4_2;
			SBOX_data_4_3 <= SBOX_data_4_3;
			SBOX_data_4_4 <= SBOX_data_4_4;
		end
 end

endmodule
