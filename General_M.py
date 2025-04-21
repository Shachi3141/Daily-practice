# M is a k-th root of the identity matrix,
# choose both the matrix size n and the order k. 


import numpy as np
from scipy.linalg import block_diag

def construct_root_of_identity(n, k):
    """
    Construct an n x n real matrix M such that M^k = I.
    Uses block-diagonal 2x2 rotation matrices of angle 2π/k.
    """
    blocks = []
    theta = 2 * np.pi / k

    # Create as many 2x2 rotation blocks as possible
    i = 0
    while i + 1 < n:
        R = np.array([[np.cos(theta), -np.sin(theta)],
                      [np.sin(theta),  np.cos(theta)]])
        blocks.append(R)
        i += 2

    # If n is odd, add a 1x1 identity at the end
    if i < n:
        blocks.append(np.array([[1]]))

    # Combine blocks into an n x n matrix
    M = block_diag(*blocks)
               # remove it to get folat <----------
    # Ensure it is exactly n x n
    M = np.array(M, dtype=float)
    return M

# Example usage
n = 5   # size of the matrix
k = 7   # power such that M^k = I
M = construct_root_of_identity(n, k)

print("Matrix M:")
print(M)

# Verify M^k = I
Mk = np.linalg.matrix_power(M, k)
Mk = np.round(Mk)
print(f"\nM^{k}:")
print(Mk)

print("\nIs M^k approximately identity?")
print(np.allclose(Mk, np.identity(n)))
