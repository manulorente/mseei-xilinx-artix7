###################################################################################
##  MSEEI 2019-2020
##  Plantilla basica para script de simulacion
##  Engineer: Manuel Lorente Alman - 77844874V
###################################################################################
# Reinicia la simulacion y el instante de simulacion vuelve a 0ns
restart
# Renombramos señales
add_wave {/TOP/CLK} -name CLK
add_wave {/TOP/BTN(0)} -name RST
add_wave {/TOP/BTN(4)} -name A
add_wave {/TOP/BTN(2)} -name B
add_wave {/TOP/LED(0)} -name Y0
add_wave {/TOP/LED(1)} -name Y1
add_wave {/TOP/LED(5)} -name LED_s0
add_wave {/TOP/LED(6)} -name LED_s1
add_wave {/TOP/LED(7)} -name LED_s2
add_wave {{/TOP/state_reg}} 
add_wave {{/TOP/state_next}} 

# Aplicacion de estimulos basicos
# Definimos CLK como un rleoj de periodo 10ns (100MHz) con valor inicial 0
add_force {/TOP/CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns

# Valor inicial de las señales de entrada. Pulsadores en reposo
add_force {/TOP/BTN} -radix hex {0 0ns}
# Avanzar simulacion. Observa que se debe hacer en multiplos del periodo de reloj
run 10ns

# Un pulso: activamos la entrada de RST y la desactivamos transcurrido el tiempo deseado
add_force {/TOP/BTN(0)} -radix hex {1 0ns} {0 10ns}
run 50ns
# deberiamos estar en S0

# Vamos a pasar a S1 - Activamos A durante un ciclo
add_force {/TOP/BTN(4)} -radix hex {1 0ns} {0 10ns}
run 50ns

# Vamos a pasar a S0 - Activamos A durante un ciclo
add_force {/TOP/BTN(4)} -radix hex {1 0ns} {0 10ns}
run 50ns

# Deberia quedarse en S0 - Activamos B durante un ciclo
add_force {/TOP/BTN(2)} -radix hex {1 0ns} {0 10ns}
run 50ns

# Deberia pasar a S2 y volver a S0 - Activamos A y B durante un ciclo
add_force {/TOP/BTN(4)} -radix hex {1 0ns} {0 10ns}
add_force {/TOP/BTN(2)} -radix hex {1 0ns} {0 10ns}
run 50ns



