reset

set terminal pngcairo size 2400, 1600 enhanced font "Arial,22"
set output 'RSAD_density_compare.png'

set xlabel "time ----->"
set ylabel "Density ----->"
set title "Density for Diffusion and Deposition"
#set xrange [1000: 10000]
#set yrange [0.175: 0.185]
set grid linewidth 2
set logscale x 10

set key outside  # Move legend outside for better clarity

plot 'L50es40.txt' u 1:2 w l lw 2 lc rgb "red" title "L=50", \
     'L80es60.txt' u 1:2 w l lw 2 lc rgb "blue" title "L=80", \
     'L100es60.txt' u 1:2 w l lw 2 lc rgb "green" title "L=100", \
     'L130es40.txt' u 1:2 w l lw 2 lc rgb "purple" title "L=130", \
     'L150es40.txt' u 1:2 w l lw 2 lc rgb "orange" title "L=150", \
     'L170es40.txt' u 1:2 w l lw 2 lc rgb "black" title "L=170"

unset output
