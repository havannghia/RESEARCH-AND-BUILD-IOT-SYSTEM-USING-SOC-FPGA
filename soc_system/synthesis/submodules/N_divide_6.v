module N_divide_6 (
	//	Inputs
	input	[6:0]	iN,
	
	//	Outputs
	output	[4:0]	oResult,
	output	[2:0]	oRemain
);

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
 
 wire	[2:0]	N_1;
 wire	[3:0]	N_2,
				N_3,
				N_4,
				N_5;
				
 wire	[2:0]	N_2_temp;
 wire	[3:0]	N_3_temp,
				N_4_temp,
				N_5_temp;
				
 wire	[3:0]	P_temp;
				
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
 //Phat
 //Thực hiện phép chia như phép tính tay của con người 
 //Do số chia là 6 nên ta kiểm tra số bị chia từ trái qua phải sao cho nếu 3 bit (vì 6 được biểu diễn bằng 3 bits, 3'd6) đầu tiên chia hết thì oResult[i] = 1
 //Kế tiếp như tính tay là hạ 1 số (kế tiếp 3 số đầu tiên), ở đây thêm vào 1 bit kế tiếp rồi check bằng logic như sau: N_2[3] | (N_2[2] & N_2[1]), nghĩa
 //xem số này có lớn hoặc bằng 6 hay k, có thêm phép OR vì có thể 4 bit. Cứ như vậy làm cho đến khi số bị chia hết bit.
 // Vì số 6 là số không phải là số đặc biệt như 4 và 8 nên k thể làm tìm thương và số dư như 4 và 8.
 assign N_1 = iN[6:4];
 assign oResult[4] = N_1[2] & N_1[1];//iN = xNNx xxxx - Phat
 
 assign N_2_temp = (oResult[4]) ? (N_1 - 3'd6) : N_1;//oResult[4]=1 nghĩa là N_1 >=6, N_2_temp là phần dư của phép chia cho 6
 assign N_2 = {N_2_temp, iN[3]};
 assign oResult[3] = N_2[3] | (N_2[2] & N_2[1]); //N_2 = NNNx, oResult[3] >= 6
 
 assign N_3_temp = (oResult[3]) ? (N_2 - 3'd6) : N_2;
 assign N_3 = {N_3_temp[2:0], iN[2]};
 assign oResult[2] = N_3[3] | (N_3[2] & N_3[1]);
 
 assign N_4_temp = (oResult[2]) ? (N_3 - 3'd6) : N_3;
 assign N_4 = {N_4_temp[2:0], iN[1]};
 assign oResult[1] = N_4[3] | (N_4[2] & N_4[1]);
 
 assign N_5_temp = (oResult[1]) ? (N_4 - 3'd6) : N_4;
 assign N_5 = {N_5_temp[2:0], iN[0]};
 assign oResult[0] = N_5[3] | (N_5[2] & N_5[1]);
 
 assign P_temp = (oResult[0]) ? (N_5 - 3'd6) : N_5;
 assign oRemain = P_temp[2:0];
 
endmodule 