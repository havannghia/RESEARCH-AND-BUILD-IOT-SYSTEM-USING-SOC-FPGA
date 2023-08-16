	component soc_system is
		port (
			button_pio_external_connection_export : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			clk_clk                               : in    std_logic                     := 'X';             -- clk
			dipsw_pio_external_connection_export  : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			hps_0_f2h_cold_reset_req_reset_n      : in    std_logic                     := 'X';             -- reset_n
			hps_0_f2h_debug_reset_req_reset_n     : in    std_logic                     := 'X';             -- reset_n
			hps_0_f2h_stm_hw_events_stm_hwevents  : in    std_logic_vector(27 downto 0) := (others => 'X'); -- stm_hwevents
			hps_0_f2h_warm_reset_req_reset_n      : in    std_logic                     := 'X';             -- reset_n
			hps_0_h2f_reset_reset_n               : out   std_logic;                                        -- reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_qspi_inst_IO0     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
			hps_0_hps_io_hps_io_qspi_inst_IO1     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
			hps_0_hps_io_hps_io_qspi_inst_IO2     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
			hps_0_hps_io_hps_io_qspi_inst_IO3     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
			hps_0_hps_io_hps_io_qspi_inst_SS0     : out   std_logic;                                        -- hps_io_qspi_inst_SS0
			hps_0_hps_io_hps_io_qspi_inst_CLK     : out   std_logic;                                        -- hps_io_qspi_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP     : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim0_inst_CLK    : out   std_logic;                                        -- hps_io_spim0_inst_CLK
			hps_0_hps_io_hps_io_spim0_inst_MOSI   : out   std_logic;                                        -- hps_io_spim0_inst_MOSI
			hps_0_hps_io_hps_io_spim0_inst_MISO   : in    std_logic                     := 'X';             -- hps_io_spim0_inst_MISO
			hps_0_hps_io_hps_io_spim0_inst_SS0    : out   std_logic;                                        -- hps_io_spim0_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX     : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_i2c1_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_0_hps_io_hps_io_i2c1_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_0_hps_io_hps_io_gpio_inst_GPIO09  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO37  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO37
			hps_0_hps_io_hps_io_gpio_inst_GPIO40  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_0_hps_io_hps_io_gpio_inst_GPIO41  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO41
			hps_0_hps_io_hps_io_gpio_inst_GPIO44  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO44
			hps_0_hps_io_hps_io_gpio_inst_GPIO48  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
			hps_0_hps_io_hps_io_gpio_inst_GPIO53  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_0_hps_io_hps_io_gpio_inst_GPIO54  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_0_hps_io_hps_io_gpio_inst_GPIO61  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			hps_0_i2c2_out_data                   : out   std_logic;                                        -- out_data
			hps_0_i2c2_sda                        : in    std_logic                     := 'X';             -- sda
			hps_0_i2c2_clk_clk                    : out   std_logic;                                        -- clk
			hps_0_i2c2_scl_in_clk                 : in    std_logic                     := 'X';             -- clk
			hps_0_spim1_txd                       : out   std_logic;                                        -- txd
			hps_0_spim1_rxd                       : in    std_logic                     := 'X';             -- rxd
			hps_0_spim1_ss_in_n                   : in    std_logic                     := 'X';             -- ss_in_n
			hps_0_spim1_ssi_oe_n                  : out   std_logic;                                        -- ssi_oe_n
			hps_0_spim1_ss_0_n                    : out   std_logic;                                        -- ss_0_n
			hps_0_spim1_ss_1_n                    : out   std_logic;                                        -- ss_1_n
			hps_0_spim1_ss_2_n                    : out   std_logic;                                        -- ss_2_n
			hps_0_spim1_ss_3_n                    : out   std_logic;                                        -- ss_3_n
			hps_0_spim1_sclk_out_clk              : out   std_logic;                                        -- clk
			hps_0_spis1_txd                       : out   std_logic;                                        -- txd
			hps_0_spis1_rxd                       : in    std_logic                     := 'X';             -- rxd
			hps_0_spis1_ss_in_n                   : in    std_logic                     := 'X';             -- ss_in_n
			hps_0_spis1_ssi_oe_n                  : out   std_logic;                                        -- ssi_oe_n
			hps_0_spis1_sclk_in_clk               : in    std_logic                     := 'X';             -- clk
			hps_0_uart1_cts                       : in    std_logic                     := 'X';             -- cts
			hps_0_uart1_dsr                       : in    std_logic                     := 'X';             -- dsr
			hps_0_uart1_dcd                       : in    std_logic                     := 'X';             -- dcd
			hps_0_uart1_ri                        : in    std_logic                     := 'X';             -- ri
			hps_0_uart1_dtr                       : out   std_logic;                                        -- dtr
			hps_0_uart1_rts                       : out   std_logic;                                        -- rts
			hps_0_uart1_out1_n                    : out   std_logic;                                        -- out1_n
			hps_0_uart1_out2_n                    : out   std_logic;                                        -- out2_n
			hps_0_uart1_rxd                       : in    std_logic                     := 'X';             -- rxd
			hps_0_uart1_txd                       : out   std_logic;                                        -- txd
			i2c_0_i2c_serial_sda_in               : in    std_logic                     := 'X';             -- sda_in
			i2c_0_i2c_serial_scl_in               : in    std_logic                     := 'X';             -- scl_in
			i2c_0_i2c_serial_sda_oe               : out   std_logic;                                        -- sda_oe
			i2c_0_i2c_serial_scl_oe               : out   std_logic;                                        -- scl_oe
			i2c_master_0_scl_export               : inout std_logic                     := 'X';             -- export
			i2c_master_0_sda_export               : inout std_logic                     := 'X';             -- export
			i2c_slave_0_scl_export                : in    std_logic                     := 'X';             -- export
			i2c_slave_0_sda_export                : inout std_logic                     := 'X';             -- export
			led_pio_external_connection_export    : out   std_logic_vector(9 downto 0);                     -- export
			memory_mem_a                          : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba                         : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                         : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n                       : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                        : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n                       : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n                      : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n                      : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n                       : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n                    : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                         : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs                        : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                      : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                        : out   std_logic;                                        -- mem_odt
			memory_mem_dm                         : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin                      : in    std_logic                     := 'X';             -- oct_rzqin
			reset_reset_n                         : in    std_logic                     := 'X';             -- reset_n
			reset_0_reset_n                       : in    std_logic                     := 'X';             -- reset_n
			spi_0_external_MISO                   : out   std_logic;                                        -- MISO
			spi_0_external_MOSI                   : in    std_logic                     := 'X';             -- MOSI
			spi_0_external_SCLK                   : in    std_logic                     := 'X';             -- SCLK
			spi_0_external_SS_n                   : in    std_logic                     := 'X';             -- SS_n
			spi_cores_0_spi_miso_export           : in    std_logic                     := 'X';             -- export
			spi_cores_0_spi_mosi_export           : out   std_logic;                                        -- export
			spi_cores_0_spi_sck_export            : out   std_logic;                                        -- export
			spi_cores_0_spi_ss_export             : out   std_logic_vector(7 downto 0);                     -- export
			ssp_uart_avalon_0_rxd_232_export      : in    std_logic                     := 'X';             -- export
			ssp_uart_avalon_0_rxd_485_export      : in    std_logic                     := 'X';             -- export
			ssp_uart_avalon_0_txd_232_export      : out   std_logic;                                        -- export
			ssp_uart_avalon_0_txd_485_export      : out   std_logic;                                        -- export
			ssp_uart_avalon_0_xcts_export         : in    std_logic                     := 'X';             -- export
			ssp_uart_avalon_0_xde_export          : out   std_logic;                                        -- export
			ssp_uart_avalon_0_xrts_export         : out   std_logic;                                        -- export
			uart_0_external_connection_rxd        : in    std_logic                     := 'X';             -- rxd
			uart_0_external_connection_txd        : out   std_logic;                                        -- txd
			uart_clock_clk                        : in    std_logic                     := 'X'              -- clk
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			button_pio_external_connection_export => CONNECTED_TO_button_pio_external_connection_export, -- button_pio_external_connection.export
			clk_clk                               => CONNECTED_TO_clk_clk,                               --                            clk.clk
			dipsw_pio_external_connection_export  => CONNECTED_TO_dipsw_pio_external_connection_export,  --  dipsw_pio_external_connection.export
			hps_0_f2h_cold_reset_req_reset_n      => CONNECTED_TO_hps_0_f2h_cold_reset_req_reset_n,      --       hps_0_f2h_cold_reset_req.reset_n
			hps_0_f2h_debug_reset_req_reset_n     => CONNECTED_TO_hps_0_f2h_debug_reset_req_reset_n,     --      hps_0_f2h_debug_reset_req.reset_n
			hps_0_f2h_stm_hw_events_stm_hwevents  => CONNECTED_TO_hps_0_f2h_stm_hw_events_stm_hwevents,  --        hps_0_f2h_stm_hw_events.stm_hwevents
			hps_0_f2h_warm_reset_req_reset_n      => CONNECTED_TO_hps_0_f2h_warm_reset_req_reset_n,      --       hps_0_f2h_warm_reset_req.reset_n
			hps_0_h2f_reset_reset_n               => CONNECTED_TO_hps_0_h2f_reset_reset_n,               --                hps_0_h2f_reset.reset_n
			hps_0_hps_io_hps_io_emac1_inst_TX_CLK => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CLK, --                   hps_0_hps_io.hps_io_emac1_inst_TX_CLK
			hps_0_hps_io_hps_io_emac1_inst_TXD0   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD0,   --                               .hps_io_emac1_inst_TXD0
			hps_0_hps_io_hps_io_emac1_inst_TXD1   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD1,   --                               .hps_io_emac1_inst_TXD1
			hps_0_hps_io_hps_io_emac1_inst_TXD2   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD2,   --                               .hps_io_emac1_inst_TXD2
			hps_0_hps_io_hps_io_emac1_inst_TXD3   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TXD3,   --                               .hps_io_emac1_inst_TXD3
			hps_0_hps_io_hps_io_emac1_inst_RXD0   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD0,   --                               .hps_io_emac1_inst_RXD0
			hps_0_hps_io_hps_io_emac1_inst_MDIO   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDIO,   --                               .hps_io_emac1_inst_MDIO
			hps_0_hps_io_hps_io_emac1_inst_MDC    => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_MDC,    --                               .hps_io_emac1_inst_MDC
			hps_0_hps_io_hps_io_emac1_inst_RX_CTL => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CTL, --                               .hps_io_emac1_inst_RX_CTL
			hps_0_hps_io_hps_io_emac1_inst_TX_CTL => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_TX_CTL, --                               .hps_io_emac1_inst_TX_CTL
			hps_0_hps_io_hps_io_emac1_inst_RX_CLK => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RX_CLK, --                               .hps_io_emac1_inst_RX_CLK
			hps_0_hps_io_hps_io_emac1_inst_RXD1   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD1,   --                               .hps_io_emac1_inst_RXD1
			hps_0_hps_io_hps_io_emac1_inst_RXD2   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD2,   --                               .hps_io_emac1_inst_RXD2
			hps_0_hps_io_hps_io_emac1_inst_RXD3   => CONNECTED_TO_hps_0_hps_io_hps_io_emac1_inst_RXD3,   --                               .hps_io_emac1_inst_RXD3
			hps_0_hps_io_hps_io_qspi_inst_IO0     => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO0,     --                               .hps_io_qspi_inst_IO0
			hps_0_hps_io_hps_io_qspi_inst_IO1     => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO1,     --                               .hps_io_qspi_inst_IO1
			hps_0_hps_io_hps_io_qspi_inst_IO2     => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO2,     --                               .hps_io_qspi_inst_IO2
			hps_0_hps_io_hps_io_qspi_inst_IO3     => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_IO3,     --                               .hps_io_qspi_inst_IO3
			hps_0_hps_io_hps_io_qspi_inst_SS0     => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_SS0,     --                               .hps_io_qspi_inst_SS0
			hps_0_hps_io_hps_io_qspi_inst_CLK     => CONNECTED_TO_hps_0_hps_io_hps_io_qspi_inst_CLK,     --                               .hps_io_qspi_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_CMD     => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CMD,     --                               .hps_io_sdio_inst_CMD
			hps_0_hps_io_hps_io_sdio_inst_D0      => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D0,      --                               .hps_io_sdio_inst_D0
			hps_0_hps_io_hps_io_sdio_inst_D1      => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D1,      --                               .hps_io_sdio_inst_D1
			hps_0_hps_io_hps_io_sdio_inst_CLK     => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_CLK,     --                               .hps_io_sdio_inst_CLK
			hps_0_hps_io_hps_io_sdio_inst_D2      => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D2,      --                               .hps_io_sdio_inst_D2
			hps_0_hps_io_hps_io_sdio_inst_D3      => CONNECTED_TO_hps_0_hps_io_hps_io_sdio_inst_D3,      --                               .hps_io_sdio_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D0      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D0,      --                               .hps_io_usb1_inst_D0
			hps_0_hps_io_hps_io_usb1_inst_D1      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D1,      --                               .hps_io_usb1_inst_D1
			hps_0_hps_io_hps_io_usb1_inst_D2      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D2,      --                               .hps_io_usb1_inst_D2
			hps_0_hps_io_hps_io_usb1_inst_D3      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D3,      --                               .hps_io_usb1_inst_D3
			hps_0_hps_io_hps_io_usb1_inst_D4      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D4,      --                               .hps_io_usb1_inst_D4
			hps_0_hps_io_hps_io_usb1_inst_D5      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D5,      --                               .hps_io_usb1_inst_D5
			hps_0_hps_io_hps_io_usb1_inst_D6      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D6,      --                               .hps_io_usb1_inst_D6
			hps_0_hps_io_hps_io_usb1_inst_D7      => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_D7,      --                               .hps_io_usb1_inst_D7
			hps_0_hps_io_hps_io_usb1_inst_CLK     => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_CLK,     --                               .hps_io_usb1_inst_CLK
			hps_0_hps_io_hps_io_usb1_inst_STP     => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_STP,     --                               .hps_io_usb1_inst_STP
			hps_0_hps_io_hps_io_usb1_inst_DIR     => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_DIR,     --                               .hps_io_usb1_inst_DIR
			hps_0_hps_io_hps_io_usb1_inst_NXT     => CONNECTED_TO_hps_0_hps_io_hps_io_usb1_inst_NXT,     --                               .hps_io_usb1_inst_NXT
			hps_0_hps_io_hps_io_spim0_inst_CLK    => CONNECTED_TO_hps_0_hps_io_hps_io_spim0_inst_CLK,    --                               .hps_io_spim0_inst_CLK
			hps_0_hps_io_hps_io_spim0_inst_MOSI   => CONNECTED_TO_hps_0_hps_io_hps_io_spim0_inst_MOSI,   --                               .hps_io_spim0_inst_MOSI
			hps_0_hps_io_hps_io_spim0_inst_MISO   => CONNECTED_TO_hps_0_hps_io_hps_io_spim0_inst_MISO,   --                               .hps_io_spim0_inst_MISO
			hps_0_hps_io_hps_io_spim0_inst_SS0    => CONNECTED_TO_hps_0_hps_io_hps_io_spim0_inst_SS0,    --                               .hps_io_spim0_inst_SS0
			hps_0_hps_io_hps_io_uart0_inst_RX     => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_RX,     --                               .hps_io_uart0_inst_RX
			hps_0_hps_io_hps_io_uart0_inst_TX     => CONNECTED_TO_hps_0_hps_io_hps_io_uart0_inst_TX,     --                               .hps_io_uart0_inst_TX
			hps_0_hps_io_hps_io_i2c0_inst_SDA     => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SDA,     --                               .hps_io_i2c0_inst_SDA
			hps_0_hps_io_hps_io_i2c0_inst_SCL     => CONNECTED_TO_hps_0_hps_io_hps_io_i2c0_inst_SCL,     --                               .hps_io_i2c0_inst_SCL
			hps_0_hps_io_hps_io_i2c1_inst_SDA     => CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SDA,     --                               .hps_io_i2c1_inst_SDA
			hps_0_hps_io_hps_io_i2c1_inst_SCL     => CONNECTED_TO_hps_0_hps_io_hps_io_i2c1_inst_SCL,     --                               .hps_io_i2c1_inst_SCL
			hps_0_hps_io_hps_io_gpio_inst_GPIO09  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO09,  --                               .hps_io_gpio_inst_GPIO09
			hps_0_hps_io_hps_io_gpio_inst_GPIO35  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO35,  --                               .hps_io_gpio_inst_GPIO35
			hps_0_hps_io_hps_io_gpio_inst_GPIO37  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO37,  --                               .hps_io_gpio_inst_GPIO37
			hps_0_hps_io_hps_io_gpio_inst_GPIO40  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO40,  --                               .hps_io_gpio_inst_GPIO40
			hps_0_hps_io_hps_io_gpio_inst_GPIO41  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO41,  --                               .hps_io_gpio_inst_GPIO41
			hps_0_hps_io_hps_io_gpio_inst_GPIO44  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO44,  --                               .hps_io_gpio_inst_GPIO44
			hps_0_hps_io_hps_io_gpio_inst_GPIO48  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO48,  --                               .hps_io_gpio_inst_GPIO48
			hps_0_hps_io_hps_io_gpio_inst_GPIO53  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO53,  --                               .hps_io_gpio_inst_GPIO53
			hps_0_hps_io_hps_io_gpio_inst_GPIO54  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO54,  --                               .hps_io_gpio_inst_GPIO54
			hps_0_hps_io_hps_io_gpio_inst_GPIO61  => CONNECTED_TO_hps_0_hps_io_hps_io_gpio_inst_GPIO61,  --                               .hps_io_gpio_inst_GPIO61
			hps_0_i2c2_out_data                   => CONNECTED_TO_hps_0_i2c2_out_data,                   --                     hps_0_i2c2.out_data
			hps_0_i2c2_sda                        => CONNECTED_TO_hps_0_i2c2_sda,                        --                               .sda
			hps_0_i2c2_clk_clk                    => CONNECTED_TO_hps_0_i2c2_clk_clk,                    --                 hps_0_i2c2_clk.clk
			hps_0_i2c2_scl_in_clk                 => CONNECTED_TO_hps_0_i2c2_scl_in_clk,                 --              hps_0_i2c2_scl_in.clk
			hps_0_spim1_txd                       => CONNECTED_TO_hps_0_spim1_txd,                       --                    hps_0_spim1.txd
			hps_0_spim1_rxd                       => CONNECTED_TO_hps_0_spim1_rxd,                       --                               .rxd
			hps_0_spim1_ss_in_n                   => CONNECTED_TO_hps_0_spim1_ss_in_n,                   --                               .ss_in_n
			hps_0_spim1_ssi_oe_n                  => CONNECTED_TO_hps_0_spim1_ssi_oe_n,                  --                               .ssi_oe_n
			hps_0_spim1_ss_0_n                    => CONNECTED_TO_hps_0_spim1_ss_0_n,                    --                               .ss_0_n
			hps_0_spim1_ss_1_n                    => CONNECTED_TO_hps_0_spim1_ss_1_n,                    --                               .ss_1_n
			hps_0_spim1_ss_2_n                    => CONNECTED_TO_hps_0_spim1_ss_2_n,                    --                               .ss_2_n
			hps_0_spim1_ss_3_n                    => CONNECTED_TO_hps_0_spim1_ss_3_n,                    --                               .ss_3_n
			hps_0_spim1_sclk_out_clk              => CONNECTED_TO_hps_0_spim1_sclk_out_clk,              --           hps_0_spim1_sclk_out.clk
			hps_0_spis1_txd                       => CONNECTED_TO_hps_0_spis1_txd,                       --                    hps_0_spis1.txd
			hps_0_spis1_rxd                       => CONNECTED_TO_hps_0_spis1_rxd,                       --                               .rxd
			hps_0_spis1_ss_in_n                   => CONNECTED_TO_hps_0_spis1_ss_in_n,                   --                               .ss_in_n
			hps_0_spis1_ssi_oe_n                  => CONNECTED_TO_hps_0_spis1_ssi_oe_n,                  --                               .ssi_oe_n
			hps_0_spis1_sclk_in_clk               => CONNECTED_TO_hps_0_spis1_sclk_in_clk,               --            hps_0_spis1_sclk_in.clk
			hps_0_uart1_cts                       => CONNECTED_TO_hps_0_uart1_cts,                       --                    hps_0_uart1.cts
			hps_0_uart1_dsr                       => CONNECTED_TO_hps_0_uart1_dsr,                       --                               .dsr
			hps_0_uart1_dcd                       => CONNECTED_TO_hps_0_uart1_dcd,                       --                               .dcd
			hps_0_uart1_ri                        => CONNECTED_TO_hps_0_uart1_ri,                        --                               .ri
			hps_0_uart1_dtr                       => CONNECTED_TO_hps_0_uart1_dtr,                       --                               .dtr
			hps_0_uart1_rts                       => CONNECTED_TO_hps_0_uart1_rts,                       --                               .rts
			hps_0_uart1_out1_n                    => CONNECTED_TO_hps_0_uart1_out1_n,                    --                               .out1_n
			hps_0_uart1_out2_n                    => CONNECTED_TO_hps_0_uart1_out2_n,                    --                               .out2_n
			hps_0_uart1_rxd                       => CONNECTED_TO_hps_0_uart1_rxd,                       --                               .rxd
			hps_0_uart1_txd                       => CONNECTED_TO_hps_0_uart1_txd,                       --                               .txd
			i2c_0_i2c_serial_sda_in               => CONNECTED_TO_i2c_0_i2c_serial_sda_in,               --               i2c_0_i2c_serial.sda_in
			i2c_0_i2c_serial_scl_in               => CONNECTED_TO_i2c_0_i2c_serial_scl_in,               --                               .scl_in
			i2c_0_i2c_serial_sda_oe               => CONNECTED_TO_i2c_0_i2c_serial_sda_oe,               --                               .sda_oe
			i2c_0_i2c_serial_scl_oe               => CONNECTED_TO_i2c_0_i2c_serial_scl_oe,               --                               .scl_oe
			i2c_master_0_scl_export               => CONNECTED_TO_i2c_master_0_scl_export,               --               i2c_master_0_scl.export
			i2c_master_0_sda_export               => CONNECTED_TO_i2c_master_0_sda_export,               --               i2c_master_0_sda.export
			i2c_slave_0_scl_export                => CONNECTED_TO_i2c_slave_0_scl_export,                --                i2c_slave_0_scl.export
			i2c_slave_0_sda_export                => CONNECTED_TO_i2c_slave_0_sda_export,                --                i2c_slave_0_sda.export
			led_pio_external_connection_export    => CONNECTED_TO_led_pio_external_connection_export,    --    led_pio_external_connection.export
			memory_mem_a                          => CONNECTED_TO_memory_mem_a,                          --                         memory.mem_a
			memory_mem_ba                         => CONNECTED_TO_memory_mem_ba,                         --                               .mem_ba
			memory_mem_ck                         => CONNECTED_TO_memory_mem_ck,                         --                               .mem_ck
			memory_mem_ck_n                       => CONNECTED_TO_memory_mem_ck_n,                       --                               .mem_ck_n
			memory_mem_cke                        => CONNECTED_TO_memory_mem_cke,                        --                               .mem_cke
			memory_mem_cs_n                       => CONNECTED_TO_memory_mem_cs_n,                       --                               .mem_cs_n
			memory_mem_ras_n                      => CONNECTED_TO_memory_mem_ras_n,                      --                               .mem_ras_n
			memory_mem_cas_n                      => CONNECTED_TO_memory_mem_cas_n,                      --                               .mem_cas_n
			memory_mem_we_n                       => CONNECTED_TO_memory_mem_we_n,                       --                               .mem_we_n
			memory_mem_reset_n                    => CONNECTED_TO_memory_mem_reset_n,                    --                               .mem_reset_n
			memory_mem_dq                         => CONNECTED_TO_memory_mem_dq,                         --                               .mem_dq
			memory_mem_dqs                        => CONNECTED_TO_memory_mem_dqs,                        --                               .mem_dqs
			memory_mem_dqs_n                      => CONNECTED_TO_memory_mem_dqs_n,                      --                               .mem_dqs_n
			memory_mem_odt                        => CONNECTED_TO_memory_mem_odt,                        --                               .mem_odt
			memory_mem_dm                         => CONNECTED_TO_memory_mem_dm,                         --                               .mem_dm
			memory_oct_rzqin                      => CONNECTED_TO_memory_oct_rzqin,                      --                               .oct_rzqin
			reset_reset_n                         => CONNECTED_TO_reset_reset_n,                         --                          reset.reset_n
			reset_0_reset_n                       => CONNECTED_TO_reset_0_reset_n,                       --                        reset_0.reset_n
			spi_0_external_MISO                   => CONNECTED_TO_spi_0_external_MISO,                   --                 spi_0_external.MISO
			spi_0_external_MOSI                   => CONNECTED_TO_spi_0_external_MOSI,                   --                               .MOSI
			spi_0_external_SCLK                   => CONNECTED_TO_spi_0_external_SCLK,                   --                               .SCLK
			spi_0_external_SS_n                   => CONNECTED_TO_spi_0_external_SS_n,                   --                               .SS_n
			spi_cores_0_spi_miso_export           => CONNECTED_TO_spi_cores_0_spi_miso_export,           --           spi_cores_0_spi_miso.export
			spi_cores_0_spi_mosi_export           => CONNECTED_TO_spi_cores_0_spi_mosi_export,           --           spi_cores_0_spi_mosi.export
			spi_cores_0_spi_sck_export            => CONNECTED_TO_spi_cores_0_spi_sck_export,            --            spi_cores_0_spi_sck.export
			spi_cores_0_spi_ss_export             => CONNECTED_TO_spi_cores_0_spi_ss_export,             --             spi_cores_0_spi_ss.export
			ssp_uart_avalon_0_rxd_232_export      => CONNECTED_TO_ssp_uart_avalon_0_rxd_232_export,      --      ssp_uart_avalon_0_rxd_232.export
			ssp_uart_avalon_0_rxd_485_export      => CONNECTED_TO_ssp_uart_avalon_0_rxd_485_export,      --      ssp_uart_avalon_0_rxd_485.export
			ssp_uart_avalon_0_txd_232_export      => CONNECTED_TO_ssp_uart_avalon_0_txd_232_export,      --      ssp_uart_avalon_0_txd_232.export
			ssp_uart_avalon_0_txd_485_export      => CONNECTED_TO_ssp_uart_avalon_0_txd_485_export,      --      ssp_uart_avalon_0_txd_485.export
			ssp_uart_avalon_0_xcts_export         => CONNECTED_TO_ssp_uart_avalon_0_xcts_export,         --         ssp_uart_avalon_0_xcts.export
			ssp_uart_avalon_0_xde_export          => CONNECTED_TO_ssp_uart_avalon_0_xde_export,          --          ssp_uart_avalon_0_xde.export
			ssp_uart_avalon_0_xrts_export         => CONNECTED_TO_ssp_uart_avalon_0_xrts_export,         --         ssp_uart_avalon_0_xrts.export
			uart_0_external_connection_rxd        => CONNECTED_TO_uart_0_external_connection_rxd,        --     uart_0_external_connection.rxd
			uart_0_external_connection_txd        => CONNECTED_TO_uart_0_external_connection_txd,        --                               .txd
			uart_clock_clk                        => CONNECTED_TO_uart_clock_clk                         --                     uart_clock.clk
		);

