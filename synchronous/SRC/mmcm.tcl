###################################################################################
##  MSEEI 2019-2020
##  Plantilla basica para script de simulacion
##  Engineer: Manuel Lorente Alman - 77844874V
###################################################################################
# Reinicia la simulacion y el instante de simulacion vuelve a 0ns
restart
# Renombramos señales
add_wave {/TOP/CLK} -name CLK
add_wave {/TOP/reset_in} -name reset_in
add_wave {{/TOP/MCLK}} 
add_wave {{/TOP/locked}} 

# Aplicacion de estimulos basicos
# Definimos CLK como un rleoj de periodo 10ns (100MHz) con valor inicial 0
add_force {/TOP/CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns
add_force {/TOP/reset_in} -radix hex {0 0ns}
run 50ns

# Valor inicial de las señales de entrada. Pulsadores en reposo
add_force {/TOP/reset_in} -radix hex {1 0ns} {0 100ns}

# Avanzar simulacion. Observa que se debe hacer en multiplos del periodo de reloj
run 800ns

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


