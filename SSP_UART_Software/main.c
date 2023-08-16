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

int main() {

	void *virtual_base;
	void *axi_virtual_base;
	int fd;
	void *sdram_64MB_HPS;
	void *ssp_uart;
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
	
	ssp_uart = virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + SSP_UART_AVALON_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	
	*((uint32_t*)ssp_uart + 0) = 0x1100;
	printf("UCR = %x\n", *((uint32_t*)ssp_uart + 0));
	int count = 0;
	char ch[10] = "Kiet Khung";
	*((uint32_t*)ssp_uart + 2) = 0x1800;
	sleep(0.5);
	/*while(1){
		*((uint32_t*)ssp_uart + 2) = (0x1000 | ch[count]);	
		usleep(5000);
		count ++;
		if(count == 10){
			break;	
			}
	}*/
	int temp = 0;
	char c = 0;
	count = 0;
	while(1){
		*((uint32_t*)ssp_uart + 2) = (0x1000 | 0x5a);	
		temp = *((uint32_t*)ssp_uart + 1);
		printf("USR = %x\n", temp);
		temp = temp & 0x40;
		if(temp == 0x40){
			c = *((uint32_t*)ssp_uart + 3) & 0x7F;
			printf("c = %x\n", c);
			count ++;
			//printf("count = %d\n",count);
		}
		usleep(1000);
		if(count == 20){
			break;
		}
	}

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
