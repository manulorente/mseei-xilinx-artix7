###################################################################################
##  MSEEI 2019-2020
##  Plantilla basica para script de simulacion
##  Engineer: Manuel Lorente Alman - 77844874V
###################################################################################
# Reinicia la simulacion y el instante de simulacion vuelve a 0ns
restart
# Renombramos señales
add_wave {/TOP/MCLK}
add_wave {/TOP/LOCKED}
add_wave {/TOP/GRST}
add_wave {/TOP/SW}
add_wave {/TOP/BTN}
add_wave {/TOP/BTN_debounced_0}
add_wave {/TOP/BTN_debounced_1}
add_wave {/TOP/AN}
add_wave {/TOP/CAT}
add_wave {/TOP/r_reg}
add_wave {/TOP/CEN}
add_wave {/TOP/Q0_Q1_en}
add_wave {/TOP/Q0}
add_wave {/TOP/Q1}
add_wave {/TOP/CONT_EN}
add_wave {/TOP/Q2}
add_wave {/TOP/Q3}

# Aplicacion de estimulos basicos
# Definimos CLK como un reloj de periodo 10ns (100MHz) con valor inicial 0
add_force {/TOP/CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns
add_force {/TOP/BTN} -radix bin {00011 0ns} {00000 10ns}
add_force {/TOP/SW} -radix hex {0000 0ns} {0001 500us} {0000 600us} {0001 700us} {0000 800us}
run 10ms

# add_force {/TOP/SW} -radix hex {0001 0ns}
# # Avanzar simulacion. Observa
# run 80000ns

# # Avanzar simulacion. Observa que se debe hacer en multiplos del periodo de reloj
# run 80000ns

# add_force {/TOP/BTN} -radix bin {00100 0ns}
# # Avanzar simulacion. Observa que se debe hacer en multiplos del periodo de reloj
# run 80000ns

# add_force {/TOP/BTN} -radix bin {01000 0ns}
# # Avanzar simulacion. Observa que se debe hacer en multiplos del periodo de reloj
# run 80000ns

# add_force {/TOP/BTN} -radix bin {10000 0ns}
# # Avanzar simulacion. Observa que se debe hacer en multiplos del periodo de reloj
# run 80000ns

#restart
## Renombramos señales
#add_wave {/TOP/CLK} 		-name CLK
#add_wave {/TOP/reset_in}	-name reset_in
#add_wave {{/TOP/MCLK}} 
#add_wave {{/TOP/locked}}
#add_wave {{/TOP/r_reg}} 	-name free_running
#add_wave {{/TOP/CEN}} 		-name CEN
#add_wave {{/TOP/C}} 		-name Q
#
## Aplicacion de estimulos basicos
## Definimos CLK como un rleoj de periodo 10ns (100MHz) con valor inicial 0
#add_force {/TOP/CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns
#add_force {/TOP/reset_in} -radix hex {0 0ns}
#run 50ns
#
## Valor inicial de las señales de entrada. Pulsadores en reposo
#add_force {/TOP/reset_in} -radix hex {1 0ns} {0 100ns}
#
## Avanzar simulacion. Observa que se debe hacer en multiplos del periodo de reloj
#run 1000ns


