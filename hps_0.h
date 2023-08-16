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
 * Macros for device 'I2C_Slave_0', class 'I2C_Slave'
 * The macros are prefixed with 'I2C_SLAVE_0_'.
 * The prefix is the slave descriptor.
 */
#define I2C_SLAVE_0_COMPONENT_TYPE I2C_Slave
#define I2C_SLAVE_0_COMPONENT_NAME I2C_Slave_0
#define I2C_SLAVE_0_BASE 0x0
#define I2C_SLAVE_0_SPAN 1024
#define I2C_SLAVE_0_END 0x3ff

/*
 * Macros for device 'ILC', class 'interrupt_latency_counter'
 * The macros are prefixed with 'ILC_'.
 * The prefix is the slave descriptor.
 */
#define ILC_COMPONENT_TYPE interrupt_latency_counter
#define ILC_COMPONENT_NAME ILC
#define ILC_BASE 0x400
#define ILC_SPAN 256
#define ILC_END 0x4ff

/*
 * Macros for device 'SPI_Cores_0', class 'SPI_Cores'
 * The macros are prefixed with 'SPI_CORES_0_'.
 * The prefix is the slave descriptor.
 */
#define SPI_CORES_0_COMPONENT_TYPE SPI_Cores
#define SPI_CORES_0_COMPONENT_NAME SPI_Cores_0
#define SPI_CORES_0_BASE 0x500
#define SPI_CORES_0_SPAN 128
#define SPI_CORES_0_END 0x57f

/*
 * Macros for device 'i2c_0', class 'altera_avalon_i2c'
 * The macros are prefixed with 'I2C_0_'.
 * The prefix is the slave descriptor.
 */
#define I2C_0_COMPONENT_TYPE altera_avalon_i2c
#define I2C_0_COMPONENT_NAME i2c_0
#define I2C_0_BASE 0x580
#define I2C_0_SPAN 64
#define I2C_0_END 0x5bf
#define I2C_0_IRQ 6
#define I2C_0_FIFO_DEPTH 4
#define I2C_0_FREQ 150000000
#define I2C_0_USE_AV_ST 0

#define SPI_0_COMPONENT_TYPE altera_avalon_spi
#define SPI_0_COMPONENT_NAME spi_0
#define SPI_0_BASE 0x5c0
#define SPI_0_SPAN 32
#define SPI_0_END 0x5df
// #define SPI_0_IRQ 6
// #define SPI_0_FIFO_DEPTH 4
// #define SPI_0_FREQ 150000000
// #define SPI_0_USE_AV_ST 0
/*
 * Macros for device 'I2C_Master_0', class 'I2C_Master'
 * The macros are prefixed with 'I2C_MASTER_0_'.
 * The prefix is the slave descriptor.
 */
#define I2C_MASTER_0_COMPONENT_TYPE I2C_Master
#define I2C_MASTER_0_COMPONENT_NAME I2C_Master_0
#define I2C_MASTER_0_BASE 0x5c0
#define I2C_MASTER_0_SPAN 32
#define I2C_MASTER_0_END 0x5df

/*
 * Macros for device 'SSP_UART_Avalon_0', class 'SSP_UART_Avalon'
 * The macros are prefixed with 'SSP_UART_AVALON_0_'.
 * The prefix is the slave descriptor.
 */
#define SSP_UART_AVALON_0_COMPONENT_TYPE SSP_UART_Avalon
#define SSP_UART_AVALON_0_COMPONENT_NAME SSP_UART_Avalon_0
#define SSP_UART_AVALON_0_BASE 0x5e0
#define SSP_UART_AVALON_0_SPAN 32
#define SSP_UART_AVALON_0_END 0x5ff

/*
 * Macros for device 'led_pio', class 'altera_avalon_pio'
 * The macros are prefixed with 'LED_PIO_'.
 * The prefix is the slave descriptor.
 */
#define LED_PIO_COMPONENT_TYPE altera_avalon_pio
#define LED_PIO_COMPONENT_NAME led_pio
#define LED_PIO_BASE 0x640
#define LED_PIO_SPAN 16
#define LED_PIO_END 0x64f
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
#define DIPSW_PIO_BASE 0x650
#define DIPSW_PIO_SPAN 16
#define DIPSW_PIO_END 0x65f
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
#define BUTTON_PIO_BASE 0x660
#define BUTTON_PIO_SPAN 16
#define BUTTON_PIO_END 0x66f
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
#define SYSID_QSYS_BASE 0x670
#define SYSID_QSYS_SPAN 8
#define SYSID_QSYS_END 0x677
#define SYSID_QSYS_ID 2899645186
#define SYSID_QSYS_TIMESTAMP 1687618609

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

#define UART_0_COMPONENT_TYPE altera_avalon_uart
#define UART_0_COMPONENT_NAME uart_0
#define UART_0_BASE 0x5e0
#define UART_0_SPAN 32
#define UART_0_END 0x5df
#endif /* _ALTERA_HPS_0_H_ */
