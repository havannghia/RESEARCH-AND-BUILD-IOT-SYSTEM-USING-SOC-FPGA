/*
This program demonstrate how to use hps communicate with FPGA through light AXI Bridge.
uses should program the FPGA by GHRD project before executing the program
refer to user manual chapter 7 for details about the demo
*/


#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"
#include "oc_i2c_master.h"
#include "oc_i2c_master_regs.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

//===================================================================================
void oc_i2c_master_init(int base, int freq);

void oc_i2c_master_write(oc_i2c_master_dev *i2c_dev, unsigned char address, unsigned char data);
void oc_i2c_master_write_reg(oc_i2c_master_dev *i2c_dev, unsigned char address, unsigned char reg, unsigned char data);

unsigned char oc_i2c_master_read(oc_i2c_master_dev *i2c_dev, unsigned char address);
unsigned char oc_i2c_master_read_reg(oc_i2c_master_dev *i2c_dev, unsigned char address, unsigned char reg);

void IOWR_OC_I2C_MASTER_PRERLO(volatile void * base, unsigned char data) ;
unsigned char IORD_OC_I2C_MASTER_PRERLO(volatile void * base) ;
void IOWR_OC_I2C_MASTER_PRERHI(volatile void * base, unsigned char data);
unsigned char IORD_OC_I2C_MASTER_PRERHI(volatile void * base);
void IOWR_OC_I2C_MASTER_CTR(volatile void * base, unsigned char data);
unsigned char IORD_OC_I2C_MASTER_CTR(volatile void * base);
void IOWR_OC_I2C_MASTER_TXR(volatile void * base, unsigned char data);
unsigned char IORD_OC_I2C_MASTER_RXR(volatile void * base);
void IOWR_OC_I2C_MASTER_CR(volatile void * base, unsigned char data);
unsigned char IORD_OC_I2C_MASTER_SR(volatile void * base);
//===================================================================================
	
int main() {

	void *virtual_base;
	int fd;
	int loop_count;
	int led_direction;
	int led_mask;
	void *i2c_master, *i2c_slave;

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
	//==================================================================================//

	i2c_master = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + I2C_MASTER_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	i2c_slave = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + I2C_SLAVE_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	//==================================================================================//

	oc_i2c_master_dev  *ptr = (oc_i2c_master_dev*)malloc(sizeof(oc_i2c_master_dev));
	ptr->base = i2c_master;

	oc_i2c_master_init(i2c_master,50000000);
	//---------------------------------------------
	int i = 0; 
	unsigned char t = 0;
	//test Master - Arduino's Slave
	/*
	printf("Master write == 0x%x\n", 9);
	oc_i2c_master_write(ptr,I2C_SLAVE_ADDR,9);

	t = oc_i2c_master_read(ptr,I2C_SLAVE_ADDR);
	printf("Master read == 0x%x\n", t);
	*/
	//Test Arduino's Master - Slave
	/*
	while (1)
	{
		if (*(unsigned int*)(i2c_slave + 2*4) != t)
		{
			t = *(unsigned int*)(i2c_slave + 2*4);
			printf("Slave at reg 2 changes 0x%x\n", t);
		}
	}*/
	for (i = 0; i < 256; i++) {
		t = 255 - i;
		printf("Slave write == %d\n", t);
		*(unsigned int*)(i2c_slave + i*4) = t;
	}

	//Test Master - Slave
	/*
	//Master write -> Master read and Slave read -> compare
	for (i = 0; i < 256; i++) {
		printf("Master write == 0x%x\n", i);
		oc_i2c_master_write(ptr,I2C_SLAVE_ADDR,i,i);
	}
	for (i = 0; i < 256; i++) {
		t = oc_i2c_master_read(ptr,I2C_SLAVE_ADDR,i);
		printf("Master read === 0x%x\t", t);
		if (t == *(unsigned int*)(i2c_slave + i*4))
			printf("Slave read: True\n");
		else
			printf("Slave read: False\n");
	}
	*/
	/*
	//Slave write -> Master read and Slave read -> Compare
	for (i = 0; i < 256; i++) {
		t = 255 - i;
		printf("Slave write == %d\n", t);
		*(unsigned int*)(i2c_slave + i*4) = t;
	}

	for (i = 0; i < 256; i++) {
		t = oc_i2c_master_read(ptr,I2C_SLAVE_ADDR,i);
		printf("Master read === %d\t", t);
		if (t == *(unsigned int*)(i2c_slave + i*4))
			printf("Slave read: True\n");
		else
			printf("Slave read: False\n");
	}
	*/
	printf("FINISH!!!\n");
	//==================================================================================//
	// clean up our memory mapping and exit
	
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}

//===================================================================================
// scl prescale register lo
void IOWR_OC_I2C_MASTER_PRERLO(volatile void * base, unsigned char data)  {
	//IOWR(base, 0, data);
	*(unsigned int*)(base + 0*4) = data;
}
unsigned char IORD_OC_I2C_MASTER_PRERLO(volatile void * base) {
    //return IORD(base, 0);
	return *(unsigned int*)(base + 0*4);
}

// scl prescale register hi
void IOWR_OC_I2C_MASTER_PRERHI(volatile void * base, unsigned char data)  {
	//IOWR(base, 1, data);
	*(unsigned int*)(base + 1*4) = data;
}
unsigned char IORD_OC_I2C_MASTER_PRERHI(volatile void * base) {
    //return IORD(base, 1);
	return *(unsigned int*)(base + 1*4);
}

// control register
void IOWR_OC_I2C_MASTER_CTR(volatile void * base, unsigned char data)  {
	//IOWR(base, 2, data);
	*(unsigned int*)(base + 2*4) = data;
}
unsigned char IORD_OC_I2C_MASTER_CTR(volatile void * base) {
    //return IORD(base, 2);
	return *(unsigned int*)(base + 2*4);
}

// tx and rx registers
void IOWR_OC_I2C_MASTER_TXR(volatile void * base, unsigned char data)  {
	//IOWR(base, 3, data);
	*(unsigned int*)(base + 3*4) = data;
}
unsigned char IORD_OC_I2C_MASTER_RXR(volatile void * base) {
    //return IORD(base, 3);
	return *(unsigned int*)(base + 3*4);
}
// command and status register
void IOWR_OC_I2C_MASTER_CR(volatile void * base, unsigned char data)  {
	//IOWR(base, 4, data);
	*(unsigned int*)(base + 4*4) = data;
}
unsigned char IORD_OC_I2C_MASTER_SR(volatile void * base) {
    //return IORD(base, 4);
	return *(unsigned int*)(base + 4*4);
}
//===================================================================================
void oc_i2c_master_init(int base, int freq)
{
    // Setup prescaler for a 100KHz I2C clock based on the frequency of the oc_i2c_master clock

    int prescale = ((freq) / (5*100000)) - 1;                   // calculate the prescaler value

    IOWR_OC_I2C_MASTER_CTR(base, 0x00);                         // disable the I2C core

    IOWR_OC_I2C_MASTER_PRERLO(base, prescale & 0xff);           // write the lo prescaler register
    IOWR_OC_I2C_MASTER_PRERHI(base, (prescale & 0xff00)>>8);    // write the hi prescaler register

    IOWR_OC_I2C_MASTER_CTR(base, OC_I2C_MASTER_CTR_CORE_EN);    // enable the I2C core
}
//===================================================================================
void oc_i2c_master_write(oc_i2c_master_dev *i2c_dev, unsigned char address, unsigned char data)
{
  unsigned char temp;

  do
  {
    temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
  } while((temp & OC_I2C_MASTER_SR_TIP));
  printf("TIP\n");
  while(1)
  {
    temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    while(temp & OC_I2C_MASTER_SR_BUSY)
    {
      i2c_dev->busy_on_entry++;

      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
      if(temp & OC_I2C_MASTER_SR_BUSY)
      {
        IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STO | OC_I2C_MASTER_SR_IF);

        do
        {
          temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
        } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
      }
    }
    printf("Busy\n");
    // write address
    IOWR_OC_I2C_MASTER_TXR(i2c_dev->base, address<<1);
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STA | OC_I2C_MASTER_CR_WR | OC_I2C_MASTER_SR_IF);
    printf("Send Addr\n");
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if((temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }
    printf("ADDR\n");
    // write data
    IOWR_OC_I2C_MASTER_TXR(i2c_dev->base, data);
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STO | OC_I2C_MASTER_CR_WR | OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if((temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }
    printf("DATA\n");
    break;
  }
}

void oc_i2c_master_write_reg(oc_i2c_master_dev *i2c_dev, unsigned char address, unsigned char reg, unsigned char data)
{
  unsigned char temp;

  do
  {
    temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
  } while((temp & OC_I2C_MASTER_SR_TIP));
  printf("TIP\n");
  while(1)
  {
    temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    while(temp & OC_I2C_MASTER_SR_BUSY)
    {
      i2c_dev->busy_on_entry++;

      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
      if(temp & OC_I2C_MASTER_SR_BUSY)
      {
        IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STO | OC_I2C_MASTER_SR_IF);

        do
        {
          temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
        } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
      }
    }
    printf("Busy\n");
    // write address
    IOWR_OC_I2C_MASTER_TXR(i2c_dev->base, address<<1);
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STA | OC_I2C_MASTER_CR_WR | OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if((temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }
    printf("ADDR\n");
    // write register address
    IOWR_OC_I2C_MASTER_TXR(i2c_dev->base, reg);
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_WR | OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if((temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }
    printf("REG\n");
    // write data
    IOWR_OC_I2C_MASTER_TXR(i2c_dev->base, data);
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STO | OC_I2C_MASTER_CR_WR | OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if((temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }
    printf("DATA\n");
    break;
  }
}
//===================================================================================
unsigned char oc_i2c_master_read(oc_i2c_master_dev *i2c_dev, unsigned char address)
{
  unsigned char temp;

  do
  {
    temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
  } while((temp & OC_I2C_MASTER_SR_TIP));

  while(1)
  {
    temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    while(temp & OC_I2C_MASTER_SR_BUSY)
    {
      i2c_dev->busy_on_entry++;

      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
      if(temp & OC_I2C_MASTER_SR_BUSY)
      {
        IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STO | OC_I2C_MASTER_SR_IF);

        do
        {
          temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
        } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
      }
    }

    // write address for reading
    IOWR_OC_I2C_MASTER_TXR(i2c_dev->base, (address<<1) | 1);
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STA | OC_I2C_MASTER_CR_WR | OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if((temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }

    // read data
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_RD | OC_I2C_MASTER_CR_ACK | OC_I2C_MASTER_CR_STO | OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if(!(temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }

    break;
  }

  return IORD_OC_I2C_MASTER_RXR(i2c_dev->base);
}

unsigned char oc_i2c_master_read_reg(oc_i2c_master_dev *i2c_dev, unsigned char address, unsigned char reg)
{
  unsigned char temp;

  do
  {
    temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
  } while((temp & OC_I2C_MASTER_SR_TIP));

  while(1)
  {
    temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    while(temp & OC_I2C_MASTER_SR_BUSY)
    {
      i2c_dev->busy_on_entry++;

      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
      if(temp & OC_I2C_MASTER_SR_BUSY)
      {
        IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STO | OC_I2C_MASTER_SR_IF);

        do
        {
          temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
        } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
      }
    }

    // write address
    IOWR_OC_I2C_MASTER_TXR(i2c_dev->base, address<<1);
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STA | OC_I2C_MASTER_CR_WR | OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if((temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }

    // write register address
    IOWR_OC_I2C_MASTER_TXR(i2c_dev->base, reg);
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_WR |OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if((temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }

    // write address for reading
    IOWR_OC_I2C_MASTER_TXR(i2c_dev->base, (address<<1) | 1);
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_STA | OC_I2C_MASTER_CR_WR | OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if((temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }

    // read data
    IOWR_OC_I2C_MASTER_CR(i2c_dev->base, OC_I2C_MASTER_CR_RD | OC_I2C_MASTER_CR_ACK | OC_I2C_MASTER_CR_STO | OC_I2C_MASTER_SR_IF);
    do
    {
      temp = IORD_OC_I2C_MASTER_SR(i2c_dev->base);
    } while((temp & OC_I2C_MASTER_SR_TIP) || (!(temp & OC_I2C_MASTER_SR_IF)));
    if(!(temp & OC_I2C_MASTER_SR_RxACK) || (temp & OC_I2C_MASTER_SR_AL))
    {
      i2c_dev->bad_cycle_term++;
      continue;
    }

    break;
  }

  return IORD_OC_I2C_MASTER_RXR(i2c_dev->base);
}
