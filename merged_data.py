import numpy as np

# Load data from both files
data_gij = np.loadtxt("gij.txt")
data_density = np.loadtxt("2d_RSAD_density_diffu.txt")

# Ensure both files have the same number of rows
num_rows = min(len(data_gij), len(data_density))
data_gij = data_gij[:num_rows]
data_density = data_density[:num_rows]

# Extract time from '2d_RSAD_density_diffu.txt' and g_diff from 'gij.txt'
time = data_density[:, 0]  # Assuming time is in the first column
density = data_density[:, 1]  # Column 2 from density file
g12_g21 = data_gij[:, 1] - data_gij[:, 5]  # (Column 2 - Column 6)
g24_g42 = data_gij[:, 2] - data_gij[:, 6]  # (Column 3 - Column 7)

# Save to merged file
merged_data = np.column_stack((time, density, g12_g21, g24_g42))
np.savetxt("merged_data.txt", merged_data, fmt="%.6f", header="Time Density g12_g21 g24_g42")
