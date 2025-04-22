import numpy as np
from scipy.linalg import block_diag

def varied_real_root_of_identity(n, k):
    """
    Construct an n x n real matrix M such that M^k = I,
    using only real-valued blocks, with different rotation angles for variety.
    """
    blocks = []
    angle_multiplier = 1
    i = 0

    while i + 1 < n:
        theta = 2 * np.pi * angle_multiplier / k
        R = np.array([
            [np.cos(theta), -np.sin(theta)],
            [np.sin(theta),  np.cos(theta)]
        ])
        blocks.append(R)
        i += 2
        angle_multiplier += 1

    if i < n:
        # Build a 3x3 block using a new theta
        theta = 2 * np.pi * angle_multiplier / k
        R3 = np.array([
            [np.cos(theta), -np.sin(theta), 0],
            [np.sin(theta),  np.cos(theta), 0],
            [0, 0, 1]
        ])
        if len(blocks) > 0:
            blocks.pop()
            i -= 2
        blocks.append(R3)
        i += 3

    M = block_diag(*blocks)
    return M[:n, :n]

# Example usage
n = 5  # size of matrix
k = 7  # M^k = I

M = varied_real_root_of_identity(n, k)
print("Matrix M:")
print(M)

# Verify M^k = I
Mk = np.linalg.matrix_power(M, k)
Mk_rounded = np.round(Mk, decimals=8)
print(f"\nM^{k}:")
print(Mk_rounded)

print("\nIs M^k approximately identity?")
print(np.allclose(Mk_rounded, np.identity(n)))
