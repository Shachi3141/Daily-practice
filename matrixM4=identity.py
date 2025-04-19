import numpy as np
from scipy.linalg import block_diag

# Define a 2x2 rotation matrix of 90 degrees (order 4)
theta = np.pi / 2
R = np.array([[np.cos(theta), -np.sin(theta)],
              [np.sin(theta),  np.cos(theta)]])

# Create a 4x4 block diagonal matrix with two copies of R
M = block_diag(R, R)
M = np.round(M)
# Print the 4x4 matrix
print("Matrix M (4x4):")
print(M)

# Verify M^4 = I
M4 = np.linalg.matrix_power(M, 4)

print("\nM^4:")
print(M4)

print("\nIs M^4 approximately the identity?")
print(np.allclose(M4, np.identity(4)))
