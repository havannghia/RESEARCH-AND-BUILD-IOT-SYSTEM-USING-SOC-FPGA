set_global_assignment -entity "SSP_UART_PLL" -library "lib_SSP_UART_PLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "SSP_UART_PLL" -library "lib_SSP_UART_PLL" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "SSP_UART_PLL" -library "lib_SSP_UART_PLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_SSP_UART_PLL" -name SPD_FILE [file join $::quartus(sip_path) "SSP_UART_PLL.spd"]

set_global_assignment -library "lib_SSP_UART_PLL" -name MISC_FILE [file join $::quartus(sip_path) "SSP_UART_PLL_sim/SSP_UART_PLL.vo"]
