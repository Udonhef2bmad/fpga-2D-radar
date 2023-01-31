### Project Settings ###

# This script sets project paths as well as other project-related variables

# Define project root path relative to this script
set project_root "."

# Define simulation script path
set simu_script "src/scripts/simulate.tcl"

# Define source folder (files will be compiled from here)
set source_path "src"; 

# Define modelsim work folder path
set modelsim_path "simulation/modelsim"; 

# Define simulation wave path folder path
set wave_path "simulation/wave"; 


### Normalize paths ###

set project_root [file normalize [file join [file normalize [file dirname [info script]]] $project_root]]
set simu_script [file normalize [file join $project_root $simu_script]]
set source_path [file normalize [file join $project_root $source_path]]
set modelsim_path [file normalize [file join $project_root $modelsim_path]]
set wave_path [file normalize [file join $project_root $wave_path]]