puts "Test simulation script for ModelSim "

# keep script path
set script_path [ file dirname [ file normalize [ info script ] ] ]

# Define a variable to store the path to the VHDL files
set project_path "../../../fpga-2D-radar"; 
set work_path "simulation/work"
set src_path $project_path/src; 
set designs_path $src_path/designs;
set testbenches_path $src_path/testbenches; 

# Create new project
vlib work

vcom -93 $designs_path/test.vhd
vcom -93 $testbenches_path/test_tb.vhd


# launch simulation
vsim test_tb

# Define signals to plot
# add wave * # Add all signals

set signal_list {a b c}

foreach signal $signal_list {
    add wave -noupdate -label $signal 
}

add wave -noupdate -expand -group Simulation -label CLK /tb_top/CLK
add wave -noupdate -expand -group Simulation -label RST /tb_top/RST
add wave -noupdate -expand -group Simulation -label ENDSIM /tb_top/ENDSIM

#add wave -noupdate -group Constants -label address_bitwidth /tb_top/address_bitwidth
#add wave -noupdate -expand -group Signal -label rdaddress /tb_top/rdaddress

# Run simulation
run -all

#cosmetic
wave zoom full