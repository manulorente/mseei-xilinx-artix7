###################################################################################
##  MSEEI 2019-2020
##  Plantilla basica para script de simulacion
##  Engineer: Manuel Lorente Alman - 77844874V
###################################################################################
# Reinicia la simulacion y el instante de simulacion vuelve a 0ns
restart
# Renombramos señales
add_wave {/TOP/TX/CLK}
add_wave {/TOP/TX/RESET}
add_wave {/TOP/TX/S_TICK}
add_wave {/TOP/TX/DIN}
add_wave {/TOP/TX/TX_START}
add_wave {/TOP/TX/TX}
add_wave {/TOP/TX/TX_DONE_TICK}
add_wave {/TOP/TX/clk_count}
add_wave {/TOP/TX/tx_data}
add_wave {/TOP/TX/bit_index}
add_wave {/TOP/TX/state_reg}

# Aplicacion de estimulos basicos 
# Definimos CLK como un reloj de periodo 10ns (100MHz) con valor inicial 0
add_force {/TOP/TX/CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns
add_force {/TOP/TX/RESET} -radix bin {1 0ns} {0 40ns}
add_force {/TOP/TX/S_TICK} -radix bin {0 0ns} {1 10ns} -repeat_every 320ns
add_force {/TOP/TX/TX_START} -radix bin {1 0ns}
add_force {/TOP/TX/DIN} -radix hex {5A 0ns} {1C 30us} {88 60us} {34 90us} {22 120us}

run 120us
