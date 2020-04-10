###################################################################################
##  MSEEI 2019-2020
##  Plantilla basica para script de simulacion
##  Engineer: Manuel Lorente Alman - 77844874V
###################################################################################
# Reinicia la simulacion y el instante de simulacion vuelve a 0ns
restart
# Renombramos señales
add_wave {/UART/CLK}
add_wave {/UART/RESET}
add_wave {/UART/WR_UART}
add_wave {/UART/RD_UART}
add_wave {/UART/W_DATA}
add_wave {/UART/TX}
add_wave {/UART/RX}
add_wave {/UART/UART_TX/TX_DONE_TICK}
add_wave {/UART/UART_TX/DIN}
add_wave {/UART/UART_TX/TX_START}
add_wave {/UART/UART_TX/S_TICK}
add_wave {/UART/UART_TX/state_reg}
add_wave {/UART/UART_TX/bit_index}
add_wave {/UART/FIFO_TX/RAM}
add_wave {/UART/UART_RX/DOUT}
add_wave {/UART/UART_RX/state_reg}

# Aplicacion de estimulos basicos 
# Definimos CLK como un reloj de periodo 20ns (50MHz) con valor inicial 0
add_force {/UART/CLK} -radix bin {0 0ns} {1 10ns} -repeat_every 20ns
add_force {/UART/RESET} -radix bin {1 0ns} {0 40ns}
run 40ns

# Transmitimos y recibimos 0x5A
add_force {/UART/WR_UART} -radix bin {1 0ns} {0 20ns}
add_force {/UART/W_DATA} -radix hex {5A 0ns}

# Recibimos datos a 115200 baudios
run 600us

