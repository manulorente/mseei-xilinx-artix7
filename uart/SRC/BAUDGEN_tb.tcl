###################################################################################
##  MSEEI 2019-2020
##  Plantilla basica para script de simulacion
##  Engineer: Manuel Lorente Alman - 77844874V
###################################################################################
# Reinicia la simulacion y el instante de simulacion vuelve a 0ns
restart
# Renombramos señales
add_wave {/TOP/BAUDGEN/CLK}
add_wave {/TOP/BAUDGEN/RESET}
add_wave {/TOP/BAUDGEN/SAT}
add_wave {/TOP/BAUDGEN/COUNT}
add_wave {/TOP/BAUDGEN/Q_reg}

# Aplicacion de estimulos basicos 
# Definimos CLK como un reloj de periodo 20ns (50MHz) con valor inicial 0
add_force {/TOP/BAUDGEN/CLK} -radix bin {0 0ns} {1 10ns} -repeat_every 20ns
add_force {/TOP/BAUDGEN/RESET} -radix bin {1 0ns} {0 40ns}
run 10us
