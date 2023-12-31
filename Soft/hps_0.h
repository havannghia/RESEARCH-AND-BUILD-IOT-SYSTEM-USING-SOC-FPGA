#ifndef _ALTERA_HPS_0_H_
#define _ALTERA_HPS_0_H_

/*
 * This file was automatically generated by the swinfo2header utility.
 * 
 * Created from SOPC Builder system 'soc_system' in
 * file './soc_system.sopcinfo'.
 */

/*
 * This file contains macros for module 'hps_0' and devices
 * connected to the following masters:
 *   h2f_axi_master
 *   h2f_lw_axi_master
 * 
 * Do not include this header file and another header file created for a
 * different module or master group at the same time.
 * Doing so may result in duplicate macro names.
 * Instead, use the system header file which has macros with unique names.
 */

/*
 * Macros for device 'ILC', class 'interrupt_latency_counter'
 * The macros are prefixed with 'ILC_'.
 * The prefix is the slave descriptor.
 */
#define ILC_COMPONENT_TYPE interrupt_latency_counter
#define ILC_COMPONENT_NAME ILC
#define ILC_BASE 0x0
#define ILC_SPAN 256
#define ILC_END 0xff

/*
 * Macros for device 'AES_0', class 'AES'
 * The macros are prefixed with 'AES_0_'.
 * The prefix is the slave descriptor.
 */
#define AES_0_COMPONENT_TYPE AES
#define AES_0_COMPONENT_NAME AES_0
#define AES_0_BASE 0x100
#define AES_0_SPAN 64
#define AES_0_END 0x13f

/*
 * Macros for device 'RSA_0', class 'RSA'
 * The macros are prefixed with 'RSA_0_'.
 * The prefix is the slave descriptor.
 */
#define RSA_0_COMPONENT_TYPE RSA
#define RSA_0_COMPONENT_NAME RSA_0
#define RSA_0_BASE 0x140
#define RSA_0_SPAN 32
#define RSA_0_END 0x15f

/*
 * Macros for device 'SHA_256_0', class 'SHA_256'
 * The macros are prefixed with 'SHA_256_0_'.
 * The prefix is the slave descriptor.
 */
#define SHA_256_0_COMPONENT_TYPE SHA_256
#define SHA_256_0_COMPONENT_NAME SHA_256_0
#define SHA_256_0_BASE 0x160
#define SHA_256_0_SPAN 32
#define SHA_256_0_END 0x17f

/*
 * Macros for device 'led_pio', class 'altera_avalon_pio'
 * The macros are prefixed with 'LED_PIO_'.
 * The prefix is the slave descriptor.
 */
#define LED_PIO_COMPONENT_TYPE altera_avalon_pio
#define LED_PIO_COMPONENT_NAME led_pio
#define LED_PIO_BASE 0x180
#define LED_PIO_SPAN 16
#define LED_PIO_END 0x18f
#define LED_PIO_BIT_CLEARING_EDGE_REGISTER 0
#define LED_PIO_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_PIO_CAPTURE 0
#define LED_PIO_DATA_WIDTH 10
#define LED_PIO_DO_TEST_BENCH_WIRING 0
#define LED_PIO_DRIVEN_SIM_VALUE 0
#define LED_PIO_EDGE_TYPE NONE
#define LED_PIO_FREQ 150000000
#define LED_PIO_HAS_IN 0
#define LED_PIO_HAS_OUT 1
#define LED_PIO_HAS_TRI 0
#define LED_PIO_IRQ_TYPE NONE
#define LED_PIO_RESET_VALUE 0

/*
 * Macros for device 'dipsw_pio', class 'altera_avalon_pio'
 * The macros are prefixed with 'DIPSW_PIO_'.
 * The prefix is the slave descriptor.
 */
#define DIPSW_PIO_COMPONENT_TYPE altera_avalon_pio
#define DIPSW_PIO_COMPONENT_NAME dipsw_pio
#define DIPSW_PIO_BASE 0x190
#define DIPSW_PIO_SPAN 16
#define DIPSW_PIO_END 0x19f
#define DIPSW_PIO_IRQ 0
#define DIPSW_PIO_BIT_CLEARING_EDGE_REGISTER 1
#define DIPSW_PIO_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DIPSW_PIO_CAPTURE 1
#define DIPSW_PIO_DATA_WIDTH 10
#define DIPSW_PIO_DO_TEST_BENCH_WIRING 0
#define DIPSW_PIO_DRIVEN_SIM_VALUE 0
#define DIPSW_PIO_EDGE_TYPE ANY
#define DIPSW_PIO_FREQ 150000000
#define DIPSW_PIO_HAS_IN 1
#define DIPSW_PIO_HAS_OUT 0
#define DIPSW_PIO_HAS_TRI 0
#define DIPSW_PIO_IRQ_TYPE EDGE
#define DIPSW_PIO_RESET_VALUE 0

/*
 * Macros for device 'button_pio', class 'altera_avalon_pio'
 * The macros are prefixed with 'BUTTON_PIO_'.
 * The prefix is the slave descriptor.
 */
#define BUTTON_PIO_COMPONENT_TYPE altera_avalon_pio
#define BUTTON_PIO_COMPONENT_NAME button_pio
#define BUTTON_PIO_BASE 0x1a0
#define BUTTON_PIO_SPAN 16
#define BUTTON_PIO_END 0x1af
#define BUTTON_PIO_IRQ 1
#define BUTTON_PIO_BIT_CLEARING_EDGE_REGISTER 1
#define BUTTON_PIO_BIT_MODIFYING_OUTPUT_REGISTER 0
#define BUTTON_PIO_CAPTURE 1
#define BUTTON_PIO_DATA_WIDTH 4
#define BUTTON_PIO_DO_TEST_BENCH_WIRING 0
#define BUTTON_PIO_DRIVEN_SIM_VALUE 0
#define BUTTON_PIO_EDGE_TYPE FALLING
#define BUTTON_PIO_FREQ 150000000
#define BUTTON_PIO_HAS_IN 1
#define BUTTON_PIO_HAS_OUT 0
#define BUTTON_PIO_HAS_TRI 0
#define BUTTON_PIO_IRQ_TYPE EDGE
#define BUTTON_PIO_RESET_VALUE 0

/*
 * Macros for device 'sysid_qsys', class 'altera_avalon_sysid_qsys'
 * The macros are prefixed with 'SYSID_QSYS_'.
 * The prefix is the slave descriptor.
 */
#define SYSID_QSYS_COMPONENT_TYPE altera_avalon_sysid_qsys
#define SYSID_QSYS_COMPONENT_NAME sysid_qsys
#define SYSID_QSYS_BASE 0x1b0
#define SYSID_QSYS_SPAN 8
#define SYSID_QSYS_END 0x1b7
#define SYSID_QSYS_ID 2899645186
#define SYSID_QSYS_TIMESTAMP 1584070621

/*
 * Macros for device 'SSP_UART_Avalon_0', class 'SSP_UART_Avalon'
 * The macros are prefixed with 'SSP_UART_AVALON_0_'.
 * The prefix is the slave descriptor.
 */
#define SSP_UART_AVALON_0_COMPONENT_TYPE SSP_UART_Avalon
#define SSP_UART_AVALON_0_COMPONENT_NAME SSP_UART_Avalon_0
#define SSP_UART_AVALON_0_BASE 0x10000
#define SSP_UART_AVALON_0_SPAN 32
#define SSP_UART_AVALON_0_END 0x1001f

/*
 * Macros for device 'jtag_uart', class 'altera_avalon_jtag_uart'
 * The macros are prefixed with 'JTAG_UART_'.
 * The prefix is the slave descriptor.
 */
#define JTAG_UART_COMPONENT_TYPE altera_avalon_jtag_uart
#define JTAG_UART_COMPONENT_NAME jtag_uart
#define JTAG_UART_BASE 0x20000
#define JTAG_UART_SPAN 8
#define JTAG_UART_END 0x20007
#define JTAG_UART_IRQ 2
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8

/*
 * Macros for device 'SPI_Cores_0', class 'SPI_Cores'
 * The macros are prefixed with 'SPI_CORES_0_'.
 * The prefix is the slave descriptor.
 */
#define SPI_CORES_0_COMPONENT_TYPE SPI_Cores
#define SPI_CORES_0_COMPONENT_NAME SPI_Cores_0
#define SPI_CORES_0_BASE 0x30000
#define SPI_CORES_0_SPAN 128
#define SPI_CORES_0_END 0x3007f

/*
 * Macros for device 'I2C_Master_0', class 'I2C_Master'
 * The macros are prefixed with 'I2C_MASTER_0_'.
 * The prefix is the slave descriptor.
 */
#define I2C_MASTER_0_COMPONENT_TYPE I2C_Master
#define I2C_MASTER_0_COMPONENT_NAME I2C_Master_0
#define I2C_MASTER_0_BASE 0x31000
#define I2C_MASTER_0_SPAN 32
#define I2C_MASTER_0_END 0x3101f

/*
 * Macros for device 'I2C_Slave_0', class 'I2C_Slave'
 * The macros are prefixed with 'I2C_SLAVE_0_'.
 * The prefix is the slave descriptor.
 */
#define I2C_SLAVE_0_COMPONENT_TYPE I2C_Slave
#define I2C_SLAVE_0_COMPONENT_NAME I2C_Slave_0
#define I2C_SLAVE_0_BASE 0x32000
#define I2C_SLAVE_0_SPAN 1024
#define I2C_SLAVE_0_END 0x323ff


#endif /* _ALTERA_HPS_0_H_ */
