###################################################################################
##  MSEEI 2019-2020
##  Plantilla basica para script de simulacion
##  Engineer: Manuel Lorente Alman - 77844874V
###################################################################################
# Reinicia la simulacion y el instante de simulacion vuelve a 0ns
restart
# Renombramos señales
add_wave {/FT245_IF/CLK}
add_wave {/FT245_IF/RESET}
add_wave {/FT245_IF/TXEN}
add_wave {/FT245_IF/DIN}
add_wave {/FT245_IF/WREN}
add_wave {/FT245_IF/READY}
add_wave {/FT245_IF/WR}
add_wave {/FT245_IF/DATA}
add_wave {/FT245_IF/state_reg}

# Aplicacion de estimulos basicos 
# Definimos CLK como un reloj de periodo 10ns (100MHz) con valor inicial 0
add_force {/FT245_IF/CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns
# Definimos entradas como en idle
add_force {/FT245_IF/TXEN} -radix bin {1 0ns}
add_force {/FT245_IF/WREN} -radix bin {1 0ns}
# Reseteamos para partir de un estado conocido
add_force {/FT245_IF/RESET} -radix hex {1 0ns} {0 10ns}
run 10ns

#Escribimos dato cada t6+t7+t8 = 15 + 50 + 5
add_force {/FT245_IF/DIN} -radix hex {5A 0ns} {1C 70ns} {88 140ns} {34 210ns} {00 280ns}

# Ciclo de escritura #1
add_force {/FT245_IF/TXEN} -radix bin {0 0ns} {1 20ns} {0 70ns}
add_force {/FT245_IF/WREN} -radix bin {1 0ns} {0 5ns} {1 35ns} 
run 70ns

# Ciclo de escritura #2
add_force {/FT245_IF/TXEN} -radix bin {0 0ns} {1 20ns} {0 70ns}
add_force {/FT245_IF/WREN} -radix bin {1 0ns} {0 5ns} {1 35ns} 
run 70ns

# Ciclo de escritura #3
add_force {/FT245_IF/TXEN} -radix bin {0 0ns} {1 20ns} {0 70ns}
add_force {/FT245_IF/WREN} -radix bin {1 0ns} {0 5ns} {1 35ns} 
run 70ns

# Deshabilitamos escritura - No deberia cambiar el bus de salida
add_force {/FT245_IF/TXEN} -radix bin {1 0ns}
run 140ns

# # Idle state
# add_force {/FT245_IF/WREN} -radix bin {1 0ns} {0 10ns}
# run 10ns

# # wait_for_TXE state
# add_force {/FT245_IF/TXEN} -radix bin {0 0ns} {1 10ns}
# run 10ns

# # output_data - write_1 - write_2 - write 3 - idle
# run 30ns

# # wait_for_TXE state - write_1 - write_2 - write 3
# add_force {/FT245_IF/TXEN} -radix bin {0 0ns} {1 10ns}
# run 40ns

# # Idle state
# add_force {/FT245_IF/WREN} -radix bin {0 0ns}
# run 10ns







