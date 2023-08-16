#ifndef _SHA_256_
#define _SHA_256_

#define SHA_256_CONTROL_UNASSIGN_SOFT_RESET     0x1
#define SHA_256_CONTROL_START                   0x2
#define SHA_256_CONTROL_CLEAR_FIFO              0x4

#define SHA_256_STATUS_SOFT_RESET			    0x1
#define SHA_256_STATUS_START_READ			    0x2
#define SHA_256_STATUS_START_WRITE			    0x4
#define SHA_256_STATUS_MASTER_READ_DONE			0x8
#define SHA_256_STATUS_MASTER_WRITE_DONE		0x10
#define SHA_256_STATUS_SHA_256_DONE				0x20

#define SHA_256_OFFSET_CONTROL				    0x0
#define SHA_256_OFFSET_READ_ADDRESS			    0x1
#define SHA_256_OFFSET_WRITE_ADDRESS		    0x2
#define SHA_256_OFFSET_LENGTH				    0x3
#define	SHA_256_OFFSET_STATUS				    0x4
#define	SHA_256_OFFSET_SHA_256_COUNTER			0x5
#define	SHA_256_OFFSET_READ_COUNTER			    0x6
#define	SHA_256_OFFSET_WRITE_COUNTER		    0x7

#define SHA_256_CLOCK							80000000
#define SYS_CLOCK								150000000

    void SHA_256_Configure_Control(void *SHA_256_base, int control_value){
		*((int*)SHA_256_base + SHA_256_OFFSET_CONTROL) = control_value;
	}
	
	void SHA_256_Configure_Address_Read(void *SHA_256_base, int address_read){
		*((int*)SHA_256_base + SHA_256_OFFSET_READ_ADDRESS) = address_read;
	}
	
	void SHA_256_Configure_Address_Write(void *SHA_256_base, int address_write){
		*((int*)SHA_256_base + SHA_256_OFFSET_WRITE_ADDRESS) = address_write;
	}
	
	void SHA_256_Configure_Length(void *SHA_256_base, int length){
		*((int*)SHA_256_base + SHA_256_OFFSET_LENGTH) = length;
	}
	
	int SHA_256_Read(void *SHA_256_base, int offset){
		return *((int*)SHA_256_base + offset); 
	}

	void SHA_256_Show_Control(void *SHA_256_base){
		printf("SHA_256_Control: 0x%.8x\n", *((int*)SHA_256_base + SHA_256_OFFSET_CONTROL));
	}

	void SHA_256_Show_Read_Address(void *SHA_256_base){
		printf("SHA_256_Read_Address: 0x%.8x\n", *((int*)SHA_256_base + SHA_256_OFFSET_READ_ADDRESS));
	}

	void SHA_256_Show_Write_Address(void *SHA_256_base){
		printf("SHA_256_Write_Address: 0x%.8x\n", *((int*)SHA_256_base + SHA_256_OFFSET_WRITE_ADDRESS));
	}

	void SHA_256_Show_Length(void *SHA_256_base){
		printf("SHA_256_Length: 0x%.8x\n", *((int*)SHA_256_base + SHA_256_OFFSET_LENGTH));
	}

	void SHA_256_Show_Status(void *SHA_256_base){
		printf("SHA_256_Length: 0x%.8x\n", *((int*)SHA_256_base + SHA_256_OFFSET_STATUS));
	}

	void SHA_256_Show_SHA_256_Counter(void *SHA_256_base){
		printf("SHA_256_Counter: %d\n", *((int*)SHA_256_base + SHA_256_OFFSET_SHA_256_COUNTER));
	}

	void SHA_256_Show_Read_Counter(void *SHA_256_base){
		printf("SHA_256_Read_Counter: %d\n", *((int*)SHA_256_base + SHA_256_OFFSET_READ_COUNTER));
	}

	void SHA_256_Show_Write_Counter(void *SHA_256_base){
		printf("SHA_256_Write_Counter: %d\n", *((int*)SHA_256_base + SHA_256_OFFSET_WRITE_COUNTER));
	}

	void SHA_256_Show_Result(void *mem_base, int offset){
		int i;
		printf("\nHASH SHA_256: ");
			for(i = 7 ; i >= 0 ; i--){
				printf("%x",*((int*)mem_base + offset/4 + i));
		}
	}

	float SHA_256_Speed_Of_SHA_256(void *SHA_256_base, int N){
		int counter = SHA_256_Read(SHA_256_base, SHA_256_OFFSET_SHA_256_COUNTER);
		float speed = (float)(N*4*16*8)*SHA_256_CLOCK/counter/1024/1024;
		return speed;
	}

	void SHA_256_Show_SHA_256_Speed(void *rsa_base, int N){
		float speed = SHA_256_Speed_Of_SHA_256(rsa_base, N);		
		printf("Speed of SHA_256 with Clock %d Hz = %f Mbps\n",SHA_256_CLOCK, speed);
	}

	float SHA_256_Speed_Of_Master_Read(void *SHA_256_base, int N){
		int counter = SHA_256_Read(SHA_256_base, SHA_256_OFFSET_READ_COUNTER);
		float speed = (float)(N*4*16*8)*SYS_CLOCK/counter/1024/1024;
		return speed;
	}

	void SHA_256_Show_Master_Read_Speed(void *rsa_base, int N){
		float speed = SHA_256_Speed_Of_Master_Read(rsa_base, N);		
		printf("Speed of Master Read with Clock %d Hz = %f Mbps\n",SYS_CLOCK,speed);
	}

	float SHA_256_Speed_Of_Master_Write(void *SHA_256_base){
		int counter = SHA_256_Read(SHA_256_base, SHA_256_OFFSET_WRITE_COUNTER);
		float speed = (float)(256)*SYS_CLOCK/counter/1024/1024;
		return speed;
	}

	void SHA_256_Show_Master_Write_Speed(void *rsa_base){
		float speed = SHA_256_Speed_Of_Master_Write(rsa_base);		
		printf("Speed of Master Read with Clock %d Hz = %f Mbps\n",SYS_CLOCK,speed);
	}

    //Hàm tính chiều dài của thông điệp
    int getLength(char Message[]) {
	    int length;
	    length = 0;
	    while (1) {
		    if (Message[length] != '\n')
		    	length++;
		    else
			    break;
	    }
	    return length;
    }

    //Hàm chèn bit
    int Padding(void *mem, char Message[], int length) {
		int i , j, count, NumberBlock,l;
		l = length;
		unsigned int temp;

		j = 0;
		count = 0;
		temp = 0;
		*((uint32_t*)mem + j) = 0;

		for (i = 0; i < l; i++) {
			temp = Message[i];
			if (count < 3) {
				temp = temp << (3-count)*8;
			}		
			*((uint32_t*)mem + j) = *((uint32_t*)mem + j) | temp;
			count++;
			if (count == 4) {		
				j++;
				*((uint32_t*)mem + j) = 0;
				temp = 0;
				count = 0;
			}
		}
		if ((l % 4) == 0) {
			*((uint32_t*)mem + l/4) = 0x80 << 24;
		}
		else {
			j = l / 4;
			i = l % 4;
			if (i < 4) {
				temp = 0x80 << (3 - i) * 8;
			}
			else {
				temp = 0x80;
			}	
			*((uint32_t*)mem + j) = *((uint32_t*)mem + j) | temp;
		
		}
	
		if (l <= 55) {
			for (i = j + 1; i < 15; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 1;
			}
		}
		else if (l >= 56 && l <= 119) {
			for (i = j + 1; i < 31; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 2;
			}
		}
		else if (l >= 120 && l <= 183) {
			for (i = j + 1; i < 47; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 3;
			}
		}else if (l >= 184 && l <= 247) {
			for (i = j + 1; i < 63; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 4;
			}
		}else if (l >= 248 && l <= 311) {
			for (i = j + 1; i < 79; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 5;
			}
		}else if (l >= 312 && l <= 375) {
			for (i = j + 1; i < 95; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 6;
			}
		}else if (l >= 376 && l <= 439) {
			for (i = j + 1; i < 111; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 7;
			}
		}else if (l >= 440 && l <= 503) {
			for (i = j + 1; i < 127; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 8;
			}
		}else if (l >= 504 && l <= 567) {
			for (i = j + 1; i < 143; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 9;
			}
		}else if (l >= 568 && l <= 631) {
			for (i = j + 1; i < 159; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 10;
			}
		}else if (l >= 632 && l <= 695) {
			for (i = j + 1; i < 175; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 11;
			}
		}else if (l >= 696 && l <= 759) {
			for (i = j + 1; i < 191; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 12;
			}
		}else if (l >= 760 && l <= 823) {
			for (i = j + 1; i < 207; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 13;
			}
		}else if (l >= 824 && l <= 897) {
			for (i = j + 1; i < 223; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 14;
			}
		}else if (l >= 898 && l <= 951) {
			for (i = j + 1; i < 239; i++) {
				*((uint32_t*)mem + i) = 0;
				NumberBlock = 15;
			}
		}	
		*((uint32_t*)mem + i) = l * 8;
		for (i = i + 1; i < 64; i++) {
			*((uint32_t*)mem + i) = 0;
		}
		return NumberBlock;
    }
#endif 