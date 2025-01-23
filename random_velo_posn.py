import numpy as np
import matplotlib.pyplot as plt

N = 10
mean = 0
std_dev = 1

# Generate random velocities and positions
vx = np.random.normal(mean, std_dev, N)
vy = np.random.normal(mean, std_dev, N)
vz = np.random.normal(mean, std_dev, N)

x = np.random.normal(mean, std_dev, N)
y = np.random.normal(mean, std_dev, N)
z = np.random.normal(mean, std_dev, N)

# Combine components into arrays
X = np.column_stack((x, y, z))  # Shape: N x 3
V = np.column_stack((vx, vy, vz))  # Shape: N x 3
dt = 0.01

# Update positions based on velocity
Xnew = X + V * dt  # This will correctly apply element-wise operations

# Print results
print("X (Original positions):")
print(X)

print("\nXnew (Updated positions):")
print(Xnew)

print("\nShapes:")
print("X shape:", X.shape)
print("Xnew shape:", Xnew.shape)
