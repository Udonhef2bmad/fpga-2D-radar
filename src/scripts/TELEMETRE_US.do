### User defined ###

# Define TestBench (TB)
set TB "TELEMETRE_US_TB"

# Define Design Under Test (DUT), used to pick viewed signals
set DUT "test_inst"

# Define list of files to compile (be wary of compilation order)
set compile_list {
    designs/TELEMETRE_US.vhd
    testbenches/TELEMETRE_US_TB.vhd
}

### Project Settings ###

# Define project path (all subsequent paths will be based on this path)
set project_path "../../../fpga-2D-radar"; 

# Define source folder (files will be compiled from here)
set source_path "src"; 

# Define modelsim work folder path
set modelsim_path "simulation/modelsim"; 

# Define simulation wave path folder path
set wave_path "simulation/wave"; 

### Script ###

puts "Test simulation script for ModelSim "

# Save working directory
set script_path [pwd]
puts "script_path : $script_path"

#catch {


# Move to project folder
cd $project_path

# Create new project
vlib $modelsim_path

# Compile source files
foreach file $compile_list {
    vcom -93 -work $modelsim_path $source_path/$file
}

# return to active directory
cd $script_path

# launch simulation
vsim -lib $project_path/$modelsim_path -wlf $project_path/$wave_path $TB


# Define signals to plot
add wave -position end  sim:/$TB/$DUT/*

# Run simulation
run -all

#cosmetic
# short names (remove paths)
configure wave -signalnamewidth 1
wave zoom full

