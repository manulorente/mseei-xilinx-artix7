###################################################################################
##  MSEEI 2019-2020
##  Plantilla basica para script de simulacion
##  Engineer: Manuel Lorente Alman - 77844874V
###################################################################################
# Reinicia la simulacion y el instante de simulacion vuelve a 0ns
restart
# Renombramos señales
add_wave {/FIFO/CLK}
add_wave {/FIFO/RST}
add_wave {/FIFO/DIN}
add_wave {/FIFO/PUSH}
add_wave {/FIFO/POP}
add_wave {/FIFO/FULL}
add_wave {/FIFO/EMPTY}
add_wave {/FIFO/DOUT}
add_wave {/FIFO/wr_en}
add_wave {/FIFO/rd_en}
add_wave {/FIFO/ram}
add_wave {/FIFO/words}
add_wave {/FIFO/rptr}
add_wave {/FIFO/wptr}

# Aplicacion de estimulos basicos - Memoria de 4 palabras
# Definimos CLK como un rleoj de periodo 10ns (100MHz) con valor inicial 0
add_force {/FIFO/CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# Efecto del reset
add_force {/FIFO/RST} -radix hex {1 0ns} {0 10ns}
run 20ns

# PUSH con FIFO vacia
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/DIN} -radix hex {01 0ns}
run 10ns
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/DIN} -radix hex {02 0ns}
run 10ns

# PUSH y POP de manera simultanea con FIFO a medio llenar
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/POP} -radix bin {1 0ns} {0 10ns}
run 10ns

# PUSH con FIFO a medio llenar - el 0x3 se va a perder al haber prioridad de lectura
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/DIN} -radix hex {03 0ns}
run 10ns
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/DIN} -radix hex {04 0ns}
run 10ns
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/DIN} -radix hex {05 0ns}
run 10ns
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/DIN} -radix hex {06 0ns}
run 10ns

# PUSH con FIFO llena
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/DIN} -radix hex {07 0ns}
run 20ns

# PUSH y POP de manera simultanea con FIFO llena
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/POP} -radix bin {1 0ns} {0 10ns}
run 10ns

# POP con FIFO llena - sacamos 2 datos
add_force {/FIFO/POP} -radix bin {1 0ns} {0 20ns}
run 20ns
# POP con FIFO medio llena - la vaciamos
add_force {/FIFO/POP} -radix bin {1 0ns} {0 20ns}
run 20ns
# POP con FIFO vacia
add_force {/FIFO/POP} -radix bin {1 0ns} {0 20ns}
run 20ns

# PUSH y POP de manera simultanea con FIFO vacia
add_force {/FIFO/PUSH} -radix bin {1 0ns} {0 10ns}
add_force {/FIFO/POP} -radix bin {1 0ns} {0 10ns}
run 50ns






