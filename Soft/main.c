/*
This program demonstrate how to use hps communicate with FPGA through light AXI Bridge.
uses should program the FPGA by GHRD project before executing the program
refer to user manual chapter 7 for details about the demo
*/

/*refyghjdjbvjocjewjfoieowihefjoiwejfijewoijfiojewijfioewjiofhwehfuihewuhfuiewifgyiweefiewhfhewoiwfhioehwiofhoiewhfoihoewfhioewf*/

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"
#include <math.h>
#include "alt_interrupt.h"
#include "alt_timers.h"
#include "alt_generalpurpose_io.h"
#include "RSA.h"
#include "SHA_256.h"
#include "AES.h"
#include "UART.h"
//#include "TIME_COUNT.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

//setting for the HPS2FPGA AXI Bridge
#define ALT_AXI_FPGASLVS_OFST (0xC0000000) // axi_master
#define HW_FPGA_AXI_SPAN (0x40000000) // Bridge span 1GB
#define HW_FPGA_AXI_MASK ( HW_FPGA_AXI_SPAN - 1 )

//DDR3 32000000-35ffffff //64 MB
#define DDR3_HPS_BASE 0x32000000
#define DDR3_HPS_SPAN 0x3FFFFFF

#define AES_AMOUNT_DATA 8

void RSA_Init(void *rsa_base, int readAdderss, int writeAddress, int length){
	RSA_Configure_Address_Read(rsa_base , readAdderss);
	RSA_Configure_Address_Write(rsa_base, writeAddress);
	RSA_Configure_Length(rsa_base, length);
	RSA_Configure_Control(rsa_base, 0x0);
	RSA_Configure_Control(rsa_base, RSA_CONTROL_UNASSIGN_SOFT_RESET | RSA_CONTROL_START);
}

void RSA_CheckDone(void *rsa_base){
	while(1){
		if( (RSA_Read(rsa_base, RSA_OFFSET_STATUS) & RSA_STATUS_MASTER_WRITE_DONE) == RSA_STATUS_MASTER_WRITE_DONE){
			break;
		}
	}
}

void SHA_256_Intit(void *sha_256_base, int readAddress, int writeAddress, int numberBlock){
	SHA_256_Configure_Address_Read(sha_256_base, readAddress);
	SHA_256_Configure_Address_Write(sha_256_base, writeAddress);
	SHA_256_Configure_Length(sha_256_base, numberBlock*4*16);
	SHA_256_Configure_Control(sha_256_base, SHA_256_CONTROL_CLEAR_FIFO);
	SHA_256_Configure_Control(sha_256_base, 0x0);
	SHA_256_Configure_Control(sha_256_base, SHA_256_CONTROL_UNASSIGN_SOFT_RESET | SHA_256_CONTROL_START);
}

void SHA_256_CheckDone(void *sha_256_base){
	while(1){
		printf("Status = %.8x\n",(SHA_256_Read(sha_256_base, SHA_256_OFFSET_STATUS)));
		if( (SHA_256_Read(sha_256_base, SHA_256_OFFSET_STATUS)  & SHA_256_STATUS_MASTER_WRITE_DONE) == SHA_256_STATUS_MASTER_WRITE_DONE){

			break;
		}
	}
}

void AES_Init(void *aes_base, int mode, int key[4], int readAddress, int writeAddress, int lengthOfValue){

	AES_Configure_Mode(aes_base, mode);
	AES_Configure_Key_0(aes_base, key[0]);
	AES_Configure_Key_1(aes_base, key[1]);
	AES_Configure_Key_2(aes_base, key[2]);
	AES_Configure_Key_3(aes_base, key[3]);
	AES_Configure_Key_Load(aes_base, AES_KEY_LOAD);
	AES_Configure_Read_Address(aes_base, readAddress);
	AES_Configure_Write_Address(aes_base, writeAddress);
	AES_Configure_Length(aes_base, lengthOfValue * 4);
	AES_Configure_Control(aes_base, AES_CONTROL_RESET);
	AES_Configure_Control(aes_base, AES_CONTROL_START);
}

int main() {

	void *virtual_base;
	void *axi_virtual_base;
	int fd;
	void *sdram_64MB_HPS;
	void *rsa_base;
	void *sha_base;
	void *aes_base;
	void *ssp_uart;
	
	int i, j, k ;
	int mem;
	FILE *f;
	char *file;
	char key[257];
		
	unsigned int e[32];	
	unsigned int d[32];
	unsigned int n[32];
	
	
	char *pathN;
	char *pathE;
	char *pathD;

	
	char ch[1024] = "kiet_demo_sha_rsa_aes\n";
	//printf("Ch = ");
	//fgets(ch, 1024, stdin);
	int length;
	int N;

	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span
	

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	axi_virtual_base = mmap( NULL, HW_FPGA_AXI_SPAN, ( PROT_READ | PROT_WRITE), MAP_SHARED, fd, ALT_AXI_FPGASLVS_OFST);
	
	if (axi_virtual_base == MAP_FAILED) {
		printf("ERROR: axi mmap() failed...\n");
		close(fd);
		return (1);
	}
	
	sdram_64MB_HPS = mmap( NULL, DDR3_HPS_SPAN, ( PROT_READ | PROT_WRITE), MAP_SHARED, fd, DDR3_HPS_BASE);	
	if (sdram_64MB_HPS == MAP_FAILED) {
		printf("ERROR: sdram mmap() failed...\n");
		close(fd);
		return (1);
	}
	
	rsa_base = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + RSA_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	
	sha_base = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SHA_256_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	aes_base = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + AES_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

	ssp_uart = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SSP_UART_AVALON_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	

	printf("\n\n");
	
	printf("  ************************************************************************\n");
	printf("  *                        Key_Exchange and Signature                    *\n");
	printf("  ************************************************************************\n");

	printf("\n\n");
	
	printf("           *************************************************************\n");
	printf("           *                          SHA_256                          *\n");
	printf("           *************************************************************\n");
	
	printf("M(signature) = ");
	j = 0;
	mem = 0;
	k = 0;

	for(i = 0 ; i < 1024; i++){		
		printf("%c",ch[i]);
		mem = mem | ch[i];		
		j++;
		if(j == 4){
			AES_Message[k] = mem;
			mem = 0;
			j = 0;
			k++;
		}
		else{
			mem = mem << 8;
		}
	}
	printf("\n");
	
	length = getLength(ch);
	//printf("Length = %d\n",length);

	N = Padding(sdram_64MB_HPS,ch,length);

	// printf("Number of block: %d\n",N);


	SHA_256_Intit(sha_base, DDR3_HPS_BASE, DDR3_HPS_BASE + 12000,  N);
	SHA_256_CheckDone(sha_base);
	SHA_256_Show_Result(sdram_64MB_HPS, 12000);
	printf("\n\n");

	unsigned int Digit[32] = {0};
	for(i = 0; i < 8; i++){
		Digit[i] = *((int*)sdram_64MB_HPS +  12000/4 +  i);
	}

	// SHA_256_Show_SHA_256_Counter(sha_base);
	// SHA_256_Show_Read_Counter(sha_base);
	// SHA_256_Show_Write_Counter(sha_base);

	// SHA_256_Show_SHA_256_Speed(sha_base, N);
	// SHA_256_Show_Master_Read_Speed(sha_base, N);
	// SHA_256_Show_Master_Write_Speed(sha_base);

	printf("\n\n");
	
	printf("           *************************************************************\n");
	printf("           *                          RSA_Infor                        *\n");
	printf("           *************************************************************\n");

	pathE = "Public1.txt";
	pathD = "Private1.txt";		
	pathN = "N3.txt";
	
	//public key
	file = pathE;
	f = fopen(file, "r");	
	fgets(key,257,f);
	printf("\n\nPublic key = %s\n",key);		
	RSA_Convert(e, key);
	fclose(f);
	
	//private key
	file = pathD;
	f = fopen(file, "r");
	fgets(key,257,f);
	printf("\n\nPirvate Key = %s\n",key);		
	RSA_Convert(d, key);
	fclose(f);
	
	//read file "N.txt" for iN 
	file = pathN;
	f = fopen(file, "r");
	fgets(key,257,f);
	printf("\n\nN = %s\n",key);		
	RSA_Convert(n, key);
	fclose(f);

	printf("\n\n");

	printf("           *************************************************************\n");
	printf("           *             RSA_1024 Encrypt C = M^(Puplic) mod N         *\n");
	printf("           *                      RSA Digit of SHA-256                 *\n");
	printf("           *************************************************************\n");

	for(i = 0; i < 32; i++){		
		*((uint32_t *)sdram_64MB_HPS + i) = Digit[i];
		//printf("sdram[%d] = %x\n",0+i,*((int*)sdram_64MB_HPS + 0 + i ));
	}
	printf("\n");
	//write b to iB
	for(i = 0; i < 32; i++){
		*((uint32_t *)sdram_64MB_HPS + 32 + i) = e[i];
		//printf("sdram[%d] = %x\n",32+i,*((int*)sdram_64MB_HPS + 32 + i ));
	}
	printf("\n");
	//write n to iN
	for(i = 0; i < 32; i++){
		*((uint32_t *)sdram_64MB_HPS + 64 + i) = n[i];
		//printf("sdram[%d] = %x\n",64+i,*((int*)sdram_64MB_HPS + 64 + i ));
	}

	RSA_Init(rsa_base, DDR3_HPS_BASE, DDR3_HPS_BASE + 4000, 96*4);
	RSA_CheckDone(rsa_base);

	RSA_Show_Result(sdram_64MB_HPS, 4000);
	
	unsigned int Signature[32];
	for(i = 0; i < 32; i++){
		Signature[i] = *((int*)sdram_64MB_HPS + 1000 + i);
	}

	printf("\n\n");

	printf("           *************************************************************\n");
	printf("           *             RSA_1024 Encrypt C = M^(Puplic) mod N         *\n");
	printf("           *                      RSA Key of AES-128                   *\n");
	printf("           *************************************************************\n");

	int AES_Key[4]  = {AES_KEY_0, AES_KEY_1, AES_KEY_2, AES_KEY_3};

	for(i = 0; i < 4; i++){		
		*((uint32_t *)sdram_64MB_HPS + i) = AES_Key[3 - i];
		//printf("sdram[%d] = %x\n",0+i,*((int*)sdram_64MB_HPS + 0 + i ));
	}
	for(i = 4; i < 32; i++){		
		*((uint32_t *)sdram_64MB_HPS + i) = 0;
		//printf("sdram[%d] = %x\n",0+i,*((int*)sdram_64MB_HPS + 0 + i ));
	}
	printf("\n");

	RSA_Init(rsa_base, DDR3_HPS_BASE, DDR3_HPS_BASE + 4000, 96*4);
	RSA_CheckDone(rsa_base);

	RSA_Show_Result(sdram_64MB_HPS, 4000);

	unsigned int Key_AES_Encrypted[32];
	for(i = 0; i < 32; i++){
		Key_AES_Encrypted[i] = *((int*)sdram_64MB_HPS + 1000 + i);
	}

	printf("\n\n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||                 ||                 \n");
	printf("                                ||     Transmit    ||                 \n");
	printf("                                ||       To        ||                 \n");
	printf("                                ||      Other      ||                 \n");
	printf("                                ||      Person     ||                 \n");
	printf("                                \\\\                 //                 \n");
	printf("                                 \\\\               //                  \n");
	printf("                                  \\\\             //                   \n");
	printf("                                   \\\\           //                    \n");
	printf("                                    \\\\         //                     \n");
	printf("                                     \\\\-------//                      \n");
	printf("                                      \\\\-----//                      \n");

	printf("\n\n");
	printf("           *************************************************************\n");
	printf("           *             RSA_1024 Decrypt M = C^(Private) mod N        *\n");
	printf("           *                      RSA Key of AES-128                   *\n");
	printf("           *************************************************************\n");

	for(i = 0 ; i < 32; i++){
		*((int*)sdram_64MB_HPS + i) = Key_AES_Encrypted[i];
		//printf("sdram[%d] = %x\n",0+i,*((int*)sdram_64MB_HPS + 0 + i ));
	}	

	printf("\n");
	//write b to iB
	for(i = 0; i < 32; i++){
		*((uint32_t *)sdram_64MB_HPS + 32 + i) = d[i];
		//printf("sdram[%d] = %x\n",32+i,*((int*)sdram_64MB_HPS + 32 + i ));
	}
	printf("\n");
	//write n to iN
	for(i = 0; i < 32; i++){
		*((uint32_t *)sdram_64MB_HPS + 64 + i) = n[i];
		//printf("sdram[%d] = %x\n",64 + i,*((int*)sdram_64MB_HPS + 64 + i ));
	}

	RSA_Init(rsa_base, DDR3_HPS_BASE, DDR3_HPS_BASE + 4000, 96*4);
	RSA_CheckDone(rsa_base);

	RSA_Show_Result(sdram_64MB_HPS, 4000);

	unsigned int Key_AES_Decrypt[4];
	Key_AES_Decrypt[3] = *((int*)sdram_64MB_HPS + 1000 +  0);
	Key_AES_Decrypt[2] = *((int*)sdram_64MB_HPS + 1000 + 1);
	Key_AES_Decrypt[1] = *((int*)sdram_64MB_HPS + 1000 + 2);
	Key_AES_Decrypt[0] = *((int*)sdram_64MB_HPS + 1000 + 3);

	// printf("Key AES[0] = %.8x\n",AES_Key[0]);
	// printf("Key AES[1] = %.8x\n",AES_Key[1]);
	// printf("Key AES[2] = %.8x\n",AES_Key[2]);
	// printf("Key AES[3] = %.8x\n",AES_Key[3]);

	// printf("Key AES Decrypt[0] = %.8x\n",Key_AES_Decrypt[0]);
	// printf("Key AES Decrypt[1] = %.8x\n",Key_AES_Decrypt[1]);
	// printf("Key AES Decrypt[2] = %.8x\n",Key_AES_Decrypt[2]);
	// printf("Key AES Decrypt[3] = %.8x\n",Key_AES_Decrypt[3]);

	printf("\n\n");

	printf("           *************************************************************\n");
	printf("           *             RSA_1024 Decrypt M = C^(Private) mod N        *\n");
	printf("           *                      RSA Digit of SHA-256                 *\n");
	printf("           *************************************************************\n");

	for(i = 0 ; i < 32; i++){
		*((int*)sdram_64MB_HPS + i) = Signature[i];
		//printf("sdram[%d] = %x\n",0+i,*((int*)sdram_64MB_HPS + 0 + i ));
	}

	RSA_Init(rsa_base, DDR3_HPS_BASE, DDR3_HPS_BASE + 4000, 96*4);
	RSA_CheckDone(rsa_base);

	RSA_Show_Result(sdram_64MB_HPS, 4000);

	//if( RSA_Chech_Data(sdram_64MB_HPS, 4000, rsa) == true){
	//	RSA_Show_Result(sdram_64MB_HPS, 4000);
	//}else{
	//	printf("RSA core failure!\n\n");
	//}
	
	// printf("\n");

	// RSA_Show_RSA_Counter(rsa_base);
	// RSA_Show_Read_Counter(rsa_base);
	// RSA_Show_Write_Counter(rsa_base);

	// RSA_Show_RSA_Speed(rsa_base);
	// RSA_Show_Master_Read_Speed(rsa_base);
	// RSA_Show_Master_Write_Speed(rsa_base);

    printf("\n\n");

	printf("           *************************************************************\n");
	printf("           *                          AES_128                          *\n");
	printf("           *                          Encrypt                          *\n");
	printf("           *************************************************************\n");

	int amount_data = AES_AMOUNT_DATA;
	for (i = 0; i < amount_data; i++){
		*(uint32_t *)(sdram_64MB_HPS + 16000 + i*4) = AES_Message[i];
		printf("data = %.8x\n", *(uint32_t *)(sdram_64MB_HPS + 16000 + i*4));
	}

	
	AES_Init(aes_base, AES_ENCRYPT, AES_Key, DDR3_HPS_BASE + 16000, DDR3_HPS_BASE + 20000, amount_data*4);

	for (i = 0; i < 260; i++);// wait for the results//260 from experience 

	AES_Show_Result(sdram_64MB_HPS, 20000, amount_data * 4);

	unsigned int AES_Encrypted_Message[256];

	for(i = 0 ; i < amount_data; i++){
		AES_Encrypted_Message[i] =  *((int*)sdram_64MB_HPS + 5000 + i); 
	}
	// AES_Encrypted_Message[0] = *((int*)sdram_64MB_HPS + 5000 + 0);
	// AES_Encrypted_Message[1] = *((int*)sdram_64MB_HPS + 5000 + 1);
	// AES_Encrypted_Message[2] = *((int*)sdram_64MB_HPS + 5000 + 2);
	// AES_Encrypted_Message[3] = *((int*)sdram_64MB_HPS + 5000 + 3);

	printf("\n\n");

	printf("           *************************************************************\n");
	printf("           *                          AES_128                          *\n");
	printf("           *                          Decrypt                          *\n");
	printf("           *************************************************************\n");


	for (i = 0; i < amount_data; i++){
		*(uint32_t *)(sdram_64MB_HPS + 16000 + i*4) = AES_Encrypted_Message[i];
	}

	
	AES_Init(aes_base, AES_DECRYPT, Key_AES_Decrypt, DDR3_HPS_BASE + 16000, DDR3_HPS_BASE + 20000, amount_data*4);

	for (i = 0; i < 260; i++);// wait for the results//260 from experience 

	AES_Show_Result(sdram_64MB_HPS, 20000, amount_data * 4);

	unsigned int AES_Decrypted_Message[256];

	for(i = 0; i < amount_data; i++){
		AES_Decrypted_Message[i] =  *((int*)sdram_64MB_HPS + 5000 + i); 
	}
	printf("\n\n");
	
	printf("           *************************************************************\n");
	printf("           *                          SHA_256                          *\n");
	printf("           *************************************************************\n");
	
	mem = 21;
	char decryptChar[1024] = {0};
	printf("M(signature) = ");
	for(i = amount_data - 1 ; i >= 0; i = i - 1){
		for( j = 0; j < 4; j ++){
			if( (char)(AES_Decrypted_Message[i] & 0xff) != 0){
				decryptChar[mem] = (char)(AES_Decrypted_Message[i] & 0xff);
				mem--;
			}
			AES_Decrypted_Message[i] = AES_Decrypted_Message[i] >> 8;
			//printf("%c",*((char*)sdram_64MB_HPS + 20000 + i + mem));
		}		
	}
	
	length = getLength(decryptChar);

	for(i = 0 ; i < length; i++){
		printf("%c",decryptChar[i]);
	}

	printf("\n");

	

	printf("Length = %d\n",length);

	N = Padding(sdram_64MB_HPS,ch,length);

	 printf("Number of block: %d\n",N);


	SHA_256_Intit(sha_base, DDR3_HPS_BASE, DDR3_HPS_BASE + 12000,  N);
	SHA_256_CheckDone(sha_base);
	
	SHA_256_Show_Result(sdram_64MB_HPS, 12000);

	bool flag = 1;
	for(i = 0; i < 8; i++){
		if(Digit[i] != *((int*)sdram_64MB_HPS + 3000 + i) ){
			printf("\n\n======> SHA do not match!\n");
			flag = 0;
			break;
		}
	}

	if(flag){
		printf("\n======> SHA match!\n");
	}
	printf("\n\n");

	printf("  ************************************************************************\n");
	printf("  *                                  SSP UART                            *\n");
	printf("  ************************************************************************\n");

	*((uint32_t*)ssp_uart + 0) = 0x1100;
	printf("UCR = %x\n", *((uint32_t*)ssp_uart + 0));
	
	int count = 0;
	char ch2[10] = "Kiet Khung";
	*((uint32_t*)ssp_uart + 2) = 0x1800;
	sleep(0.5);
	while(1){
		*((uint32_t*)ssp_uart + 2) = (0x1000 | ch2[count]);
		count ++;
		if(count == 10){
			break;	
		}
	}
	int temp = 0;
	char c = 0;
	count = 0;
	while(1){
		temp = *((uint32_t*)ssp_uart + 1);
		printf("USR = %x\n", temp);
		temp = temp & 0x40;
		if(temp == 0x40){
			c = *((uint32_t*)ssp_uart + 3) & 0x7F;
			printf("c = %c\n", c);
			count ++;
		}
		usleep(200000);
		if(count == 10){
			break;
		}
	}
	*((uint32_t*)ssp_uart + 2) = 0x1C00;
	
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	if( munmap( axi_virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	if( munmap( sdram_64MB_HPS, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	close( fd );
	return 0;
}
