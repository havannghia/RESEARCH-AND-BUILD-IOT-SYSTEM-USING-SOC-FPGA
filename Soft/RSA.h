#ifndef _RSA_
#define _RSA_
	
#define RSA_CONTROL_UNASSIGN_SOFT_RESET	0x1
#define RSA_CONTROL_START				0X2
#define RSA_CONTROL_CLEAR_FIFO			0X4

#define RSA_STATUS_SOFT_RESET			0x1
#define RSA_STATUS_START_READ			0x2
#define RSA_STATUS_START_WRITE			0x4
#define RSA_STATUS_READ_FIFO_DONE		0x8
#define RSA_STATUS_MASTER_READ_DONE		0x10
#define RSA_STATUS_MASTER_WRITE_DONE	0x20
#define RSA_STATUS_RSA_DONE				0x40

#define RSA_OFFSET_CONTROL				0x0
#define RSA_OFFSET_READ_ADDRESS			0x1
#define RSA_OFFSET_WRITE_ADDRESS		0x2
#define RSA_OFFSET_LENGTH				0x3
#define	RSA_OFFSET_STATUS				0x4
#define	RSA_OFFSET_RSA_COUNTER			0x5
#define	RSA_OFFSET_READ_COUNTER			0x6
#define	RSA_OFFSET_WRITE_COUNTER		0x7

#define RSA_CLOCK						50000000
#define SYS_CLOCK						150000000
	
	void RSA_Configure_Control(void *rsa_base, int control_value){
		*((int*)rsa_base + RSA_OFFSET_CONTROL) = control_value;
	}
	
	void RSA_Configure_Address_Read(void *rsa_base, int address_read){
		*((int*)rsa_base + RSA_OFFSET_READ_ADDRESS) = address_read;
	}
	
	void RSA_Configure_Address_Write(void *rsa_base, int address_write){
		*((int*)rsa_base + RSA_OFFSET_WRITE_ADDRESS) = address_write;
	}
	
	void RSA_Configure_Length(void *rsa_base, int length){
		*((int*)rsa_base + RSA_OFFSET_LENGTH) = length;
	}
	
	int RSA_Read(void *rsa_base, int offset){
		return *((int*)rsa_base + offset); 
	}

	void RSA_Show_Control(void *rsa_base){
		printf("RSA_Control: 0x%.8x\n", *((int*)rsa_base + RSA_OFFSET_CONTROL));
	}

	void RSA_Show_Read_Address(void *rsa_base){
		printf("RSA_Read_Address: 0x%.8x\n", *((int*)rsa_base + RSA_OFFSET_READ_ADDRESS));
	}

	void RSA_Show_Write_Address(void *rsa_base){
		printf("RSA_Write_Address: 0x%.8x\n", *((int*)rsa_base + RSA_OFFSET_WRITE_ADDRESS));
	}

	void RSA_Show_Length(void *rsa_base){
		printf("RSA_Length: 0x%.8x\n", *((int*)rsa_base + RSA_OFFSET_LENGTH));
	}

	void RSA_Show_Status(void *rsa_base){
		printf("RSA_Length: 0x%.8x\n", *((int*)rsa_base + RSA_OFFSET_STATUS));
	}

	void RSA_Show_RSA_Counter(void *rsa_base){
		printf("RSA_Counter: %d\n", *((int*)rsa_base + RSA_OFFSET_RSA_COUNTER));
	}

	void RSA_Show_Read_Counter(void *rsa_base){
		printf("RSA_Read_Counter: %d\n", *((int*)rsa_base + RSA_OFFSET_READ_COUNTER));
	}

	void RSA_Show_Write_Counter(void *rsa_base){
		printf("RSA_Write_Counter: %d\n", *((int*)rsa_base + RSA_OFFSET_WRITE_COUNTER));
	}

	void RSA_Show_Result(void *mem_base, int offset){
		int i;
		printf("\nRSA = ");
		for(i = 31 ; i >= 0; i--){
			printf("%.8x",*((int*)mem_base + offset/4 + i) );					
		}
		printf("\n\n");
	}
	
	bool RSA_Chech_Data(void *mem_base, int offset, unsigned int data[]){
		int i;
		for(i = 31 ; i >= 0; i--){			
			if(*((int*)mem_base + offset/4 + i) != data[i] ){				
				return false;
			}
		}
		return true;
	}

	float RSA_Speed_Of_RSA(void *rsa_base){
		int counter = RSA_Read(rsa_base, RSA_OFFSET_RSA_COUNTER);
		float speed = (float)(1024*3)*RSA_CLOCK/counter/1024;
		return speed;
	}

	void RSA_Show_RSA_Speed(void *rsa_base){
		float speed = RSA_Speed_Of_RSA(rsa_base);		
		printf("Speed of RSA with Clock %d Hz = %f Kbps\n",RSA_CLOCK,speed);
	}

	float RSA_Speed_Of_Master_Read(void *rsa_base){
		int counter = RSA_Read(rsa_base, RSA_OFFSET_READ_COUNTER);
		float speed = (float)(1024*3)*SYS_CLOCK/counter/1024/1024;
		return speed;
	}

	void RSA_Show_Master_Read_Speed(void *rsa_base){
		float speed = RSA_Speed_Of_Master_Read(rsa_base);		
		printf("Speed of Master Read with Clock %d Hz = %f Mbps\n",SYS_CLOCK,speed);
	}

	float RSA_Speed_Of_Master_Write(void *rsa_base){
		int counter = RSA_Read(rsa_base, RSA_OFFSET_WRITE_COUNTER);
		float speed = (float)(1024)*SYS_CLOCK/counter/1024/1024;
		return speed;
	}

	void RSA_Show_Master_Write_Speed(void *rsa_base){
		float speed = RSA_Speed_Of_Master_Write(rsa_base);		
		printf("Speed of Master Write with Clock %d Hz = %f Mbps\n",SYS_CLOCK,speed);
	}

	int RSA_Hex2Dec(char s) {
		switch (s){
			case('0'): return 0; break;
			case('1'): return 1; break;
			case('2'): return 2; break;
			case('3'): return 3; break;
			case('4'): return 4; break;
			case('5'): return 5; break;
			case('6'): return 6; break;
			case('7'): return 7; break;
			case('8'): return 8; break;
			case('9'): return 9; break;
			case('a'): return 10; break;
			case('b'): return 11; break;
			case('c'): return 12; break;
			case('d'): return 13; break;
			case('e'): return 14; break;
			case('f'): return 15; break;
			default: return -1; break;
		}
	}

	int RSA_Power(int a, int n) {
		int result = 1;
		int i = 0;
		for (i = 0; i < n; i++) {
			result = result*a;
		}
		return result;
	}	

	void RSA_Convert(unsigned int a[32], char key[257]) {
		unsigned int temp = 0;
		int i = 255;
		int k = 0;
		int j = 0;
		while (i >= 0) {
			temp = 0;
			for (j = 0; j < 8; j++) {
				temp += RSA_Hex2Dec(key[i]) * RSA_Power(16, j);
				i--;
				if (j == 7) {
					a[k++] = temp;
				}
			}
		}
	}
	
#endif 