puts "Test simulation script for ModelSim "

set tb_name "test_tb"

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

# Change to source dir for compilation
#cd $src_path

vcom -93 $designs_path/test.vhd

vcom -93 $testbenches_path/$tb_name.vhd

# launch simulation
vsim $tb_name

# Define signals to plot
# add wave * ;# Add all signals

add wave -noupdate -expand -group Simulation -label CLK $tb_name/CLK
add wave -noupdate -expand -group Simulation -label RST $tb_name/RST
add wave -noupdate -expand -group Simulation -label ENDSIM $tb_name/ENDSIM

set signal_list {a_i b_i combinatorial_o clocked_o}

foreach signal $signal_list {
    add wave -noupdate -label $signal $tb_name/$signal 
}



#add wave -noupdate -group Constants -label address_bitwidth /tb_top/address_bitwidth
#add wave -noupdate -expand -group Signal -label rdaddress /tb_top/rdaddress

# Run simulation
run -all

#cosmetic
wave zoom full