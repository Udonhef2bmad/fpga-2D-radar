puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/PRESCALER.vhd
vcom -93 ../src/FDIV.vhd
vcom -93 ../src/PWM.vhd
vcom -93 ../src/UART_FSM_RX.vhd
vcom -93 ../src/UART_RX.vhd
vcom -93 ../src/UART_PWM.vhd

vcom -93 TB_UART_PWM.vhd

vsim TB_UART_PWM

#add wave *

add wave -noupdate -divider Global
add wave -noupdate /TB_UART_PWM/CLK
add wave -noupdate /TB_UART_PWM/RST_KEY

add wave -noupdate -divider "top level"
add wave -noupdate -label RX /tb_uart_pwm/RX
add wave -noupdate -label PWM /tb_uart_pwm/PWM
add wave -noupdate -label SW /tb_uart_pwm/SW
add wave -noupdate -label LED /tb_uart_pwm/LED
#add wave -noupdate -label DUTYCYCLE /tb_uart_pwm/UUT/PWM_1/DUTYCYCLE

add wave -noupdate -divider "UART RX"
add wave -noupdate -label ERROR_RX /tb_uart_pwm/UUT/UART_RX_1/ERROR_RX
add wave -noupdate -label END_RX /tb_uart_pwm/UUT/UART_RX_1/END_RX
add wave -noupdate -label BPS_MODE /tb_uart_pwm/UUT/UART_RX_1/BPS_MODE
add wave -noupdate -label PARITY_MODE /tb_uart_pwm/UUT/UART_RX_1/PARITY_MODE
add wave -noupdate -label STATE /tb_uart_pwm/UUT/UART_RX_1/UART_FSM_RX_1/STATE
add wave -noupdate -label DATA_RX /tb_uart_pwm/UUT/UART_RX_1/DATA_RX

add wave -noupdate -divider "PWM"
add wave -noupdate -label DUTYCYCLE /tb_uart_pwm/UUT/PWM_1/DUTYCYCLE
add wave -noupdate -label RESOLUTION /tb_uart_pwm/UUT/PWM_1/RESOLUTION
add wave -noupdate -label COUNTER_SIZE /tb_uart_pwm/UUT/PWM_1/COUNTER_SIZE
add wave -noupdate -label ACTIVE_TICKS /tb_uart_pwm/UUT/PWM_1/ACTIVE_TICKS
add wave -noupdate -label PWM_FREQ /tb_uart_pwm/UUT/PWM_1/PWM_FREQ
#add wave -noupdate -label TICK_COUNTER /tb_uart_pwm/UUT/PWM_1/TICK_COUNTER
add wave -noupdate -label TICK_DIV /tb_uart_pwm/UUT/PWM_1/TICK_DIV
add wave -noupdate -label PWM /tb_uart_pwm/UUT/PWM_1/PWM
run 1000 ms