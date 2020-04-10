###################################################################################
##  MSEEI 2019-2020
##  Plantilla basica para script de simulacion
##  Engineer: Manuel Lorente Alman - 77844874V
###################################################################################
# Reinicia la simulacion y el instante de simulacion vuelve a 0ns
restart
# Renombramos señales
add_wave {/TOP/CLK}
add_wave {/TOP/RESET}
add_wave {/TOP/MCLK}
add_wave {/TOP/GRST}
add_wave {/TOP/LOCKED}
add_wave {/TOP/BAUDGEN/COUNT}
add_wave {/TOP/TX/RESET}
add_wave {/TOP/TX/S_TICK}
add_wave {/TOP/TX/DIN}
add_wave {/TOP/TX/TX_START}
add_wave {/TOP/TX/TX}
add_wave {/TOP/TX/TX_DONE_TICK}
add_wave {/TOP/TX/state_reg}

# Aplicacion de estimulos basicos 
# Definimos CLK como un reloj de periodo 10ns (100MHz) con valor inicial 0
add_force {/TOP/CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns
add_force {/TOP/RESET} -radix bin {1 0ns} {0 40ns}
run 1us

#Escribimos dato
add_force {/TOP/TX/DIN} -radix hex {5A 0ns} {1C 1us} {88 2us} {34 3us} {00 4us}
run 5us
