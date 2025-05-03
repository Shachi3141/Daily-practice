
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import animation

# Generate flower data
n = 300
r = np.linspace(0, 1, n)
theta = np.linspace(0, 2 * np.pi, n)
R, THETA = np.meshgrid(r, theta)

petalNum = 6
x = 1 - (1 / 2) * ((5 / 4) * (1 - np.mod(petalNum * THETA, 2 * np.pi) / np.pi) ** 2 - 1 / 4) ** 2
phi = (np.pi / 2) * np.exp(-2 * np.pi / (8 * np.pi))
y = 1.95653 * (R ** 2) * ((1.27689 * R - 1) ** 2) * np.sin(phi)
R2 = x * (R * np.sin(phi) + y * np.cos(phi))

X = R2 * np.sin(THETA)
Y = R2 * np.cos(THETA)
Z = x * (R * np.cos(phi) - y * np.sin(phi))

# Set up the figure and axis
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.axis('off')
surf = ax.plot_surface(X, Y, Z, cmap='cool', linewidth=0, antialiased=False)

# Animation function
def update(frame):
    ax.view_init(elev=81.2, azim=frame)

# Create animation
ani = animation.FuncAnimation(fig, update, frames=np.linspace(0, 360, 120), interval=50)

plt.show()



# Flower to grid and netrowk

# DONT DELETE IT
# import numpy as np
# import matplotlib.pyplot as plt
# from mpl_toolkits.mplot3d import Axes3D
# from matplotlib import animation
# import networkx as nx
# from matplotlib.animation import PillowWriter

# # Flower shape
# n = 50  # lower for network clarity
# r = np.linspace(0, 1, n)
# theta = np.linspace(0, 2 * np.pi, n)
# R, THETA = np.meshgrid(r, theta)

# petalNum = 6
# x = 1 - (1 / 2) * ((5 / 4) * (1 - np.mod(petalNum * THETA, 2 * np.pi) / np.pi) ** 2 - 1 / 4) ** 2
# phi = (np.pi / 2) * np.exp(-2 * np.pi / (8 * np.pi))
# y = 1.95653 * (R ** 2) * ((1.27689 * R - 1) ** 2) * np.sin(phi)
# R2 = x * (R * np.sin(phi) + y * np.cos(phi))

# X = R2 * np.sin(THETA)
# Y = R2 * np.cos(THETA)
# Z = x * (R * np.cos(phi) - y * np.sin(phi))

# # Set up plot
# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')
# ax.axis('off')

# # Initial surface and wire
# surf = ax.plot_surface(X, Y, Z, cmap='cool', linewidth=0, antialiased=False, alpha=1.0)
# wire = ax.plot_wireframe(X, Y, Z, rstride=1, cstride=1, color='black', linewidth=0.3, alpha=0.0)

# # Build networkx graph from mesh grid
# G = nx.Graph()
# pos_3d = {}
# for i in range(n):
#     for j in range(n):
#         idx = i * n + j
#         G.add_node(idx)
#         pos_3d[idx] = (X[i, j], Y[i, j], Z[i, j])
#         # Connect to neighbors
#         if i > 0:
#             G.add_edge(idx, (i - 1) * n + j)
#         if j > 0:
#             G.add_edge(idx, i * n + (j - 1))

# # Draw networkx nodes/edges
# network_lines = []
# def draw_network(alpha):
#     for line in network_lines:
#         line.remove()
#     network_lines.clear()
#     for u, v in G.edges():
#         x_vals = [pos_3d[u][0], pos_3d[v][0]]
#         y_vals = [pos_3d[u][1], pos_3d[v][1]]
#         z_vals = [pos_3d[u][2], pos_3d[v][2]]
#         line = ax.plot(x_vals, y_vals, z_vals, color='darkviolet', alpha=alpha, linewidth=0.5)
#         network_lines.extend(line)

# # Animation
# def update(frame):
#     azim_angle = frame * 3
#     ax.view_init(elev=81.2, azim=azim_angle)

#     t = frame / 100

#     # Phase 1: fade surface ➝ grid
#     if frame < 50:
#         surf.set_alpha(1 - t * 2)
#         wire.set_alpha(t * 2)
#     # Phase 2: fade grid ➝ network
#     elif frame < 100:
#         surf.set_alpha(0)
#         wire.set_alpha(2 - t * 2)
#         draw_network((t - 0.5) * 2)
#     else:
#         draw_network(1)

# # Animate
# ani = animation.FuncAnimation(fig, update, frames=120, interval=50)

# ani.save('flower_to_network.gif', writer=PillowWriter(fps=20))

# #plt.show()
