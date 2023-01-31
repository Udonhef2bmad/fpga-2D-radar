### User defined ###

# Define TestBench (TB)
set TB "servomoteur_avalon_tb"

# Define Design Under Test (DUT), used to pick viewed signals
set DUT "test_inst"

# Define list of files to compile, path starts from designated source folder (be wary of compilation order)
set compile_list {
    designs/servomoteur.vhd
    designs/servomoteur_avalon.vhd
    testbenches/servomoteur_avalon_tb.vhd
}

### Script start ###

puts "Test simulation script for ModelSim "

# Read project settings from file at project root
set project_settings "../../project_settings.tcl"
source $project_settings

# Launch generic simulation script
source $simu_script

### Cosmetics ###

# short names (remove paths)
configure wave -signalnamewidth 1

# zoom to see entire simulation
wave zoom full