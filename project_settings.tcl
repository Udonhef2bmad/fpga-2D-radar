### Project Settings ###

#  Normalise project root path if not done already
set project_root [file normalize [file dirname [info script]]]

# Define source folder (files will be compiled from here)
set source_path "src"; 
set source_path [file normalize [file join $project_root $source_path]]

# Define modelsim work folder path
set modelsim_path "simulation/modelsim"; 
set modelsim_path [file normalize [file join $project_root $modelsim_path]]

# Define simulation wave path folder path
set wave_path "simulation/wave"; 
set wave_path [file normalize [file join $project_root $wave_path]]