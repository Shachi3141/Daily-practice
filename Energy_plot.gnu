reset

# Set the title and labels
set title "Energy during simulation" font ",14"
set xlabel "Time ---->" font ",12"
set ylabel "Energy ---->" font ",12"
#set yrange [-4.5:-5.5]
# Set the grid
set grid

# Plot the data
plot "sample.txt" using 1:2 with lines linecolor rgb "red" linewidth 2 title "Energy vs Time"

# Close the output
unset output
