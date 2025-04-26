import numpy as np
import matplotlib.pyplot as plt
import networkx as nx

# Parameters
rows, cols = 12, 12
a = 1.0  # lattice spacing
lx = cols * a
ly = rows * np.sqrt(3)/2 * a

# Generate triangular lattice coordinates
positions = []
for i in range(rows):
    for j in range(cols):
        x = j * a + (i % 2) * (a/2)
        y = i * (np.sqrt(3)/2) * a
        positions.append((x, y))

# Periodic Distance Function (minimum image convention)
def minimum_image(p1, p2, lx, ly):
    dx = p2[0] - p1[0]
    dy = p2[1] - p1[1]
    if dx > lx/2: dx -= lx
    if dx < -lx/2: dx += lx
    if dy > ly/2: dy -= ly
    if dy < -ly/2: dy += ly
    return dx, dy

# Build Graph
G = nx.Graph()
for idx, pos in enumerate(positions):
    G.add_node(idx, pos=pos)

# Threshold distances for nearest and next-nearest neighbors
threshold_nearest = 1.1 * a  # For nearest neighbors
threshold_next_nearest = 1.75 * a  # For next-nearest neighbors

nearest_neighbors = {}
next_nearest_neighbors = {}

# Loop to find nearest and next-nearest neighbors
for i in range(len(positions)):
    nearest_neighbors[i] = []
    next_nearest_neighbors[i] = []
    for j in range(len(positions)):
        if i == j:
            continue
        dx, dy = minimum_image(positions[i], positions[j], lx, ly)
        dist = np.hypot(dx, dy)
        
        # Nearest Neighbors
        if dist < threshold_nearest:
            if j not in nearest_neighbors[i]:
                G.add_edge(i, j)  # Add edge for nearest neighbors only
                nearest_neighbors[i].append(j)
        
        # Next-Nearest Neighbors (should be farther than nearest neighbors, but less than next threshold)
        elif dist < threshold_next_nearest:
            if j not in next_nearest_neighbors[i]:
                next_nearest_neighbors[i].append(j)

# Choose a particle to highlight (you can change the index here)
highlight_node = 40  # For example, Node 0

# Prepare the colors for the plot
node_colors = ['gray'] * len(positions)  # Default color for all nodes
node_colors[highlight_node] = 'red'  # Highlight the selected node in red

# Color the nearest and next-nearest neighbors
for nn in nearest_neighbors[highlight_node]:
    node_colors[nn] = 'blue'  # Color nearest neighbors in blue

for nnn in next_nearest_neighbors[highlight_node]:
    node_colors[nnn] = 'green'  # Color next-nearest neighbors in green

# Plot the lattice with colored nodes
plt.figure(figsize=(8, 8))
pos_dict = {i: positions[i] for i in range(len(positions))}
nx.draw(G, pos=pos_dict, with_labels=True, node_size=500, node_color=node_colors, edge_color="gray")

plt.title("Triangular Lattice with Colored Nodes (NN and NNN)")
plt.gca().set_aspect('equal')
plt.show()

# Print Nearest and Next-Nearest Neighbors for the highlighted particle
print("\n=== Nearest Neighbors ===")
for nn in nearest_neighbors[highlight_node]:
    print(f"Node {highlight_node} at {positions[highlight_node]}:")
    print(f"   Nearest Neighbor: Node {nn} at {positions[nn]}")

print("\n=== Next-Nearest Neighbors ===")
for nnn in next_nearest_neighbors[highlight_node]:
    print(f"Node {highlight_node} at {positions[highlight_node]}:")
    print(f"   Next-Nearest Neighbor: Node {nnn} at {positions[nnn]}")
