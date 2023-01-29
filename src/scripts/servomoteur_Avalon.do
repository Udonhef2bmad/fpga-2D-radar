### User defined ###

# Define TestBench (TB)
set TB "servomoteur_Avalon_tb"

# Define Design Under Test (DUT), used to pick viewed signals
set DUT "test_inst"

# Define list of files to compile, path starts from designated source folder (be wary of compilation order)
set compile_list {
    designs/servomoteur.vhd
    designs/servomoteur_Avalon.vhd
    testbenches/servomoteur_Avalon_tb.vhd
}

### Script start ###

puts "Test simulation script for ModelSim "

# Read project settings from file at project root
set project_settings "../../project_settings.tcl"
source $project_settings

# Create new project
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

### Cosmetics ###

# short names (remove paths)
configure wave -signalnamewidth 1

# zoom to see entire simulation
wave zoom full