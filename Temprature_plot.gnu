reset

# Set the title and labels
set title "Temprature during simulation" font ",14"
set xlabel "Time ---->" font ",12"
set ylabel "Temperature----->" font ",12"

# Set the grid
set grid

# Plot the data
plot "sample.txt" using 1:3 with lines linecolor rgb "red" linewidth 2 title "Temprature vs Time"

# Close the output
unset output
