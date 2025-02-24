#!/bin/bash

# Compile the Fortran code if needed
gfortran -o avgbashnew avgbashnew.f90  

# Run the program 20 times with different output filenames
for i in {1..20}; do
    ./avgbashnew "RSAD_diffu$i.txt" "RSAD_density$i.txt" "gij$i.txt" "g$i.txt" 
done


