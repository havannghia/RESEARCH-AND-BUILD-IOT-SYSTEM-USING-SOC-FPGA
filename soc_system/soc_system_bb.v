
module soc_system (
	button_pio_external_connection_export,
	clk_clk,
	dipsw_pio_external_connection_export,
	hps_0_f2h_cold_reset_req_reset_n,
	hps_0_f2h_debug_reset_req_reset_n,
	hps_0_f2h_stm_hw_events_stm_hwevents,
	hps_0_f2h_warm_reset_req_reset_n,
	hps_0_h2f_reset_reset_n,
	hps_0_hps_io_hps_io_emac1_inst_TX_CLK,
	hps_0_hps_io_hps_io_emac1_inst_TXD0,
	hps_0_hps_io_hps_io_emac1_inst_TXD1,
	hps_0_hps_io_hps_io_emac1_inst_TXD2,
	hps_0_hps_io_hps_io_emac1_inst_TXD3,
	hps_0_hps_io_hps_io_emac1_inst_RXD0,
	hps_0_hps_io_hps_io_emac1_inst_MDIO,
	hps_0_hps_io_hps_io_emac1_inst_MDC,
	hps_0_hps_io_hps_io_emac1_inst_RX_CTL,
	hps_0_hps_io_hps_io_emac1_inst_TX_CTL,
	hps_0_hps_io_hps_io_emac1_inst_RX_CLK,
	hps_0_hps_io_hps_io_emac1_inst_RXD1,
	hps_0_hps_io_hps_io_emac1_inst_RXD2,
	hps_0_hps_io_hps_io_emac1_inst_RXD3,
	hps_0_hps_io_hps_io_qspi_inst_IO0,
	hps_0_hps_io_hps_io_qspi_inst_IO1,
	hps_0_hps_io_hps_io_qspi_inst_IO2,
	hps_0_hps_io_hps_io_qspi_inst_IO3,
	hps_0_hps_io_hps_io_qspi_inst_SS0,
	hps_0_hps_io_hps_io_qspi_inst_CLK,
	hps_0_hps_io_hps_io_sdio_inst_CMD,
	hps_0_hps_io_hps_io_sdio_inst_D0,
	hps_0_hps_io_hps_io_sdio_inst_D1,
	hps_0_hps_io_hps_io_sdio_inst_CLK,
	hps_0_hps_io_hps_io_sdio_inst_D2,
	hps_0_hps_io_hps_io_sdio_inst_D3,
	hps_0_hps_io_hps_io_usb1_inst_D0,
	hps_0_hps_io_hps_io_usb1_inst_D1,
	hps_0_hps_io_hps_io_usb1_inst_D2,
	hps_0_hps_io_hps_io_usb1_inst_D3,
	hps_0_hps_io_hps_io_usb1_inst_D4,
	hps_0_hps_io_hps_io_usb1_inst_D5,
	hps_0_hps_io_hps_io_usb1_inst_D6,
	hps_0_hps_io_hps_io_usb1_inst_D7,
	hps_0_hps_io_hps_io_usb1_inst_CLK,
	hps_0_hps_io_hps_io_usb1_inst_STP,
	hps_0_hps_io_hps_io_usb1_inst_DIR,
	hps_0_hps_io_hps_io_usb1_inst_NXT,
	hps_0_hps_io_hps_io_spim0_inst_CLK,
	hps_0_hps_io_hps_io_spim0_inst_MOSI,
	hps_0_hps_io_hps_io_spim0_inst_MISO,
	hps_0_hps_io_hps_io_spim0_inst_SS0,
	hps_0_hps_io_hps_io_uart0_inst_RX,
	hps_0_hps_io_hps_io_uart0_inst_TX,
	hps_0_hps_io_hps_io_i2c0_inst_SDA,
	hps_0_hps_io_hps_io_i2c0_inst_SCL,
	hps_0_hps_io_hps_io_i2c1_inst_SDA,
	hps_0_hps_io_hps_io_i2c1_inst_SCL,
	hps_0_hps_io_hps_io_gpio_inst_GPIO09,
	hps_0_hps_io_hps_io_gpio_inst_GPIO35,
	hps_0_hps_io_hps_io_gpio_inst_GPIO37,
	hps_0_hps_io_hps_io_gpio_inst_GPIO40,
	hps_0_hps_io_hps_io_gpio_inst_GPIO41,
	hps_0_hps_io_hps_io_gpio_inst_GPIO44,
	hps_0_hps_io_hps_io_gpio_inst_GPIO48,
	hps_0_hps_io_hps_io_gpio_inst_GPIO53,
	hps_0_hps_io_hps_io_gpio_inst_GPIO54,
	hps_0_hps_io_hps_io_gpio_inst_GPIO61,
	hps_0_i2c2_out_data,
	hps_0_i2c2_sda,
	hps_0_i2c2_clk_clk,
	hps_0_i2c2_scl_in_clk,
	hps_0_spim1_txd,
	hps_0_spim1_rxd,
	hps_0_spim1_ss_in_n,
	hps_0_spim1_ssi_oe_n,
	hps_0_spim1_ss_0_n,
	hps_0_spim1_ss_1_n,
	hps_0_spim1_ss_2_n,
	hps_0_spim1_ss_3_n,
	hps_0_spim1_sclk_out_clk,
	hps_0_spis1_txd,
	hps_0_spis1_rxd,
	hps_0_spis1_ss_in_n,
	hps_0_spis1_ssi_oe_n,
	hps_0_spis1_sclk_in_clk,
	hps_0_uart1_cts,
	hps_0_uart1_dsr,
	hps_0_uart1_dcd,
	hps_0_uart1_ri,
	hps_0_uart1_dtr,
	hps_0_uart1_rts,
	hps_0_uart1_out1_n,
	hps_0_uart1_out2_n,
	hps_0_uart1_rxd,
	hps_0_uart1_txd,
	i2c_0_i2c_serial_sda_in,
	i2c_0_i2c_serial_scl_in,
	i2c_0_i2c_serial_sda_oe,
	i2c_0_i2c_serial_scl_oe,
	i2c_master_0_scl_export,
	i2c_master_0_sda_export,
	i2c_slave_0_scl_export,
	i2c_slave_0_sda_export,
	led_pio_external_connection_export,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	reset_reset_n,
	reset_0_reset_n,
	spi_0_external_MISO,
	spi_0_external_MOSI,
	spi_0_external_SCLK,
	spi_0_external_SS_n,
	spi_cores_0_spi_miso_export,
	spi_cores_0_spi_mosi_export,
	spi_cores_0_spi_sck_export,
	spi_cores_0_spi_ss_export,
	ssp_uart_avalon_0_rxd_232_export,
	ssp_uart_avalon_0_rxd_485_export,
	ssp_uart_avalon_0_txd_232_export,
	ssp_uart_avalon_0_txd_485_export,
	ssp_uart_avalon_0_xcts_export,
	ssp_uart_avalon_0_xde_export,
	ssp_uart_avalon_0_xrts_export,
	uart_0_external_connection_rxd,
	uart_0_external_connection_txd,
	uart_clock_clk);	

	input	[3:0]	button_pio_external_connection_export;
	input		clk_clk;
	input	[9:0]	dipsw_pio_external_connection_export;
	input		hps_0_f2h_cold_reset_req_reset_n;
	input		hps_0_f2h_debug_reset_req_reset_n;
	input	[27:0]	hps_0_f2h_stm_hw_events_stm_hwevents;
	input		hps_0_f2h_warm_reset_req_reset_n;
	output		hps_0_h2f_reset_reset_n;
	output		hps_0_hps_io_hps_io_emac1_inst_TX_CLK;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD0;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD1;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD2;
	output		hps_0_hps_io_hps_io_emac1_inst_TXD3;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD0;
	inout		hps_0_hps_io_hps_io_emac1_inst_MDIO;
	output		hps_0_hps_io_hps_io_emac1_inst_MDC;
	input		hps_0_hps_io_hps_io_emac1_inst_RX_CTL;
	output		hps_0_hps_io_hps_io_emac1_inst_TX_CTL;
	input		hps_0_hps_io_hps_io_emac1_inst_RX_CLK;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD1;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD2;
	input		hps_0_hps_io_hps_io_emac1_inst_RXD3;
	inout		hps_0_hps_io_hps_io_qspi_inst_IO0;
	inout		hps_0_hps_io_hps_io_qspi_inst_IO1;
	inout		hps_0_hps_io_hps_io_qspi_inst_IO2;
	inout		hps_0_hps_io_hps_io_qspi_inst_IO3;
	output		hps_0_hps_io_hps_io_qspi_inst_SS0;
	output		hps_0_hps_io_hps_io_qspi_inst_CLK;
	inout		hps_0_hps_io_hps_io_sdio_inst_CMD;
	inout		hps_0_hps_io_hps_io_sdio_inst_D0;
	inout		hps_0_hps_io_hps_io_sdio_inst_D1;
	output		hps_0_hps_io_hps_io_sdio_inst_CLK;
	inout		hps_0_hps_io_hps_io_sdio_inst_D2;
	inout		hps_0_hps_io_hps_io_sdio_inst_D3;
	inout		hps_0_hps_io_hps_io_usb1_inst_D0;
	inout		hps_0_hps_io_hps_io_usb1_inst_D1;
	inout		hps_0_hps_io_hps_io_usb1_inst_D2;
	inout		hps_0_hps_io_hps_io_usb1_inst_D3;
	inout		hps_0_hps_io_hps_io_usb1_inst_D4;
	inout		hps_0_hps_io_hps_io_usb1_inst_D5;
	inout		hps_0_hps_io_hps_io_usb1_inst_D6;
	inout		hps_0_hps_io_hps_io_usb1_inst_D7;
	input		hps_0_hps_io_hps_io_usb1_inst_CLK;
	output		hps_0_hps_io_hps_io_usb1_inst_STP;
	input		hps_0_hps_io_hps_io_usb1_inst_DIR;
	input		hps_0_hps_io_hps_io_usb1_inst_NXT;
	output		hps_0_hps_io_hps_io_spim0_inst_CLK;
	output		hps_0_hps_io_hps_io_spim0_inst_MOSI;
	input		hps_0_hps_io_hps_io_spim0_inst_MISO;
	output		hps_0_hps_io_hps_io_spim0_inst_SS0;
	input		hps_0_hps_io_hps_io_uart0_inst_RX;
	output		hps_0_hps_io_hps_io_uart0_inst_TX;
	inout		hps_0_hps_io_hps_io_i2c0_inst_SDA;
	inout		hps_0_hps_io_hps_io_i2c0_inst_SCL;
	inout		hps_0_hps_io_hps_io_i2c1_inst_SDA;
	inout		hps_0_hps_io_hps_io_i2c1_inst_SCL;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO09;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO35;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO37;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO40;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO41;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO44;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO48;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO53;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO54;
	inout		hps_0_hps_io_hps_io_gpio_inst_GPIO61;
	output		hps_0_i2c2_out_data;
	input		hps_0_i2c2_sda;
	output		hps_0_i2c2_clk_clk;
	input		hps_0_i2c2_scl_in_clk;
	output		hps_0_spim1_txd;
	input		hps_0_spim1_rxd;
	input		hps_0_spim1_ss_in_n;
	output		hps_0_spim1_ssi_oe_n;
	output		hps_0_spim1_ss_0_n;
	output		hps_0_spim1_ss_1_n;
	output		hps_0_spim1_ss_2_n;
	output		hps_0_spim1_ss_3_n;
	output		hps_0_spim1_sclk_out_clk;
	output		hps_0_spis1_txd;
	input		hps_0_spis1_rxd;
	input		hps_0_spis1_ss_in_n;
	output		hps_0_spis1_ssi_oe_n;
	input		hps_0_spis1_sclk_in_clk;
	input		hps_0_uart1_cts;
	input		hps_0_uart1_dsr;
	input		hps_0_uart1_dcd;
	input		hps_0_uart1_ri;
	output		hps_0_uart1_dtr;
	output		hps_0_uart1_rts;
	output		hps_0_uart1_out1_n;
	output		hps_0_uart1_out2_n;
	input		hps_0_uart1_rxd;
	output		hps_0_uart1_txd;
	input		i2c_0_i2c_serial_sda_in;
	input		i2c_0_i2c_serial_scl_in;
	output		i2c_0_i2c_serial_sda_oe;
	output		i2c_0_i2c_serial_scl_oe;
	inout		i2c_master_0_scl_export;
	inout		i2c_master_0_sda_export;
	input		i2c_slave_0_scl_export;
	inout		i2c_slave_0_sda_export;
	output	[9:0]	led_pio_external_connection_export;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	input		reset_reset_n;
	input		reset_0_reset_n;
	output		spi_0_external_MISO;
	input		spi_0_external_MOSI;
	input		spi_0_external_SCLK;
	input		spi_0_external_SS_n;
	input		spi_cores_0_spi_miso_export;
	output		spi_cores_0_spi_mosi_export;
	output		spi_cores_0_spi_sck_export;
	output	[7:0]	spi_cores_0_spi_ss_export;
	input		ssp_uart_avalon_0_rxd_232_export;
	input		ssp_uart_avalon_0_rxd_485_export;
	output		ssp_uart_avalon_0_txd_232_export;
	output		ssp_uart_avalon_0_txd_485_export;
	input		ssp_uart_avalon_0_xcts_export;
	output		ssp_uart_avalon_0_xde_export;
	output		ssp_uart_avalon_0_xrts_export;
	input		uart_0_external_connection_rxd;
	output		uart_0_external_connection_txd;
	input		uart_clock_clk;
endmodule
