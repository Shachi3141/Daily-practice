# Plot of particles and their velocity in side a box.

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
l=6.348475790538236

# Cube vertices
vertices = np.array([
    [0, 0, 0], [l, 0, 0], [l, l, 0], [0, l, 0],  # Bottom face
    [0, 0, l], [l, 0, l], [l, l, l], [0, l, l]  # Top face
])

# Cube edges (connect the vertices)
edges = [
    [0, 1], [1, 2], [2, 3], [3, 0],  # Bottom face edges
    [4, 5], [5, 6], [6, 7], [7, 4],  # Top face edges
    [0, 4], [1, 5], [2, 6], [3, 7]   # Vertical edges
]

# Create the figure and 3D axis
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')

# Plot the scatter points 
ax.scatter(x, y, z, color='k', s=30)  # Scatter points
v=np.sqrt(vx**2 + vy**2 + vz**2)
vx=vx/v
vy=vy/v
vz=vz/v
ax.quiver(x, y, z, vx, vy, vz, length=0.5, color='blue', label="Velocity Vectors")

# Plot the cube edges
for edge in edges:
    ax.plot([vertices[edge[0], 0], vertices[edge[1], 0]],
            [vertices[edge[0], 1], vertices[edge[1], 1]],
            [vertices[edge[0], 2], vertices[edge[1], 2]], color='red', linewidth=2)

# Set view angle and labels
ax.view_init(elev=30, azim=60)
ax.set_xlabel('X axis')
ax.set_ylabel('Y axis')
ax.set_zlabel('Z axis')

# Optional: Set aspect ratio (aspect ratio may not be exact in 3D)
ax.set_box_aspect([1, 1, 1])

# Show the plot
plt.show()
