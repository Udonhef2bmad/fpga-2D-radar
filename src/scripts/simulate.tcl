### Generic simulation script ###

# This script compiles abd simulates a given testbench
# Make sure the project paths and compilation files are set before calling this script
# You probably don't need to edit this script


# Create new simulation project
vlib $modelsim_path

# Compile source files
foreach file $compile_list {
    vcom -93 -work $modelsim_path $source_path/$file
}

# launch simulation
vsim -lib $modelsim_path -wlf $wave_path $TB

# Define signals to plot
add wave -position end  sim:/$TB/$DUT/*

# Run simulation
run -all
