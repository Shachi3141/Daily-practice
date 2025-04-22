
# from PIL import Image
# import numpy as np
# import matplotlib.pyplot as plt

# def image_to_matrix(image_path):
#     # Load image in grayscale (L mode)
#     img = Image.open(image_path).convert('L')
#     matrix = np.array(img)
#     return matrix, img  # Also return original image for comparison

# def matrix_to_image(matrix, save_path='reconstructed_image.png'):
#     # Convert NumPy matrix back to PIL image
#     img = Image.fromarray(matrix.astype(np.uint8))
#     img.save(save_path)
#     return img

# def analyze_and_plot(matrix):
#     shape = matrix.shape
#     print(f"Matrix order: {shape[0]} rows x {shape[1]} columns")

#     max_val = np.max(matrix)
#     max_pos = np.unravel_index(np.argmax(matrix), matrix.shape)
#     print(f"Maximum value: {max_val} at position {max_pos}")

#     min_val = np.min(matrix)
#     min_pos = np.unravel_index(np.argmin(matrix), matrix.shape)
#     print(f"Minimum value: {min_val} at position {min_pos}")

#     plt.figure(figsize=(8, 5))
#     plt.hist(matrix.ravel(), bins=range(257), color='gray', edgecolor='black')
#     plt.title("Histogram of Pixel Intensities")
#     plt.xlabel("Pixel Value (0=Black, 255=White)")
#     plt.ylabel("Frequency")
#     plt.ylim(0,1000)
#     plt.grid(True, linestyle='--', alpha=0.5)
#     plt.tight_layout()
#     plt.show()

# def compare_images(img1, img2):
#     # Compare two images (as NumPy arrays)
#     arr1 = np.array(img1)
#     arr2 = np.array(img2)
#     is_equal = np.array_equal(arr1, arr2)
#     print("\nAre the original and reconstructed images exactly equal?")
#     print(is_equal)

# def show_images_side_by_side(img1, img2, title1='Original Image', title2='Reconstructed Image'):
#     plt.figure(figsize=(10, 5))

#     # Original image
#     plt.subplot(1, 2, 1)
#     plt.imshow(img1, cmap='gray', vmin=0, vmax=255)
#     plt.title(title1)
#     plt.axis('on')

#     # Reconstructed image
#     plt.subplot(1, 2, 2)
#     plt.imshow(img2, cmap='gray', vmin=0, vmax=255)
#     plt.title(title2)
#     plt.axis('on')
#     plt.tight_layout()
#     plt.show()

# # --- MAIN ---

# image_path = 'image1.png'  # Your image path

# # Step 1: Convert image → matrix
# matrix, original_image = image_to_matrix(image_path)

# # Step 2: Analyze and plot histogram
# analyze_and_plot(matrix)

# # Step 3: Convert matrix → image and save
# reconstructed_image = matrix_to_image(matrix, save_path='reconstructed_image.png')

# # Step 4: Compare original and reconstructed
# compare_images(original_image, reconstructed_image)

# # Step 5: Show both images side by side
# show_images_side_by_side(original_image, reconstructed_image)














# from PIL import Image
# import numpy as np
# import matplotlib.pyplot as plt
# from scipy.stats import entropy

# # --- Step 1: Load Image and Convert to Matrix ---
# def image_to_matrix(image_path):
#     img = Image.open(image_path).convert('L')
#     matrix = np.array(img)
#     return matrix, img

# # --- Step 2: Convert Matrix Back to Image ---
# def matrix_to_image(matrix, save_path='reconstructed_image.png'):
#     img = Image.fromarray(matrix.astype(np.uint8))
#     img.save(save_path)
#     return img

# # --- Step 3: Show Histogram and Image Properties ---
# def analyze_and_plot(matrix):
#     shape = matrix.shape
#     print(f"Matrix order: {shape[0]} rows x {shape[1]} columns")

#     max_val = np.max(matrix)
#     max_pos = np.unravel_index(np.argmax(matrix), matrix.shape)
#     print(f"Maximum value: {max_val} at position {max_pos}")

#     min_val = np.min(matrix)
#     min_pos = np.unravel_index(np.argmin(matrix), matrix.shape)
#     print(f"Minimum value: {min_val} at position {min_pos}")

#     plt.figure(figsize=(8, 5))
#     plt.hist(matrix.ravel(), bins=range(257), color='gray', edgecolor='black')
#     plt.title("Histogram of Pixel Intensities")
#     plt.xlabel("Pixel Value (0=Black, 255=White)")
#     plt.ylabel("Frequency")
#     plt.grid(True, linestyle='--', alpha=0.5)
#     plt.tight_layout()
#     plt.show()

# # --- Step 4: Compare Two Images ---
# def compare_images(img1, img2):
#     arr1 = np.array(img1)
#     arr2 = np.array(img2)
#     is_equal = np.array_equal(arr1, arr2)
#     print("\nAre the original and reconstructed images exactly equal?")
#     print(is_equal)

# # --- Step 5: Show Two Images Side by Side ---
# def show_images_side_by_side(img1, img2, title1='Original Image', title2='Reconstructed Image'):
#     plt.figure(figsize=(10, 5))
#     plt.subplot(1, 2, 1)
#     plt.imshow(img1, cmap='gray', vmin=0, vmax=255)
#     plt.title(title1)
#     plt.axis('off')

#     plt.subplot(1, 2, 2)
#     plt.imshow(img2, cmap='gray', vmin=0, vmax=255)
#     plt.title(title2)
#     plt.axis('off')
#     plt.tight_layout()
#     plt.show()

# # --- Step 6: Pad Matrix to Make Square ---
# def make_matrix_square(matrix):
#     rows, cols = matrix.shape
#     if rows == cols:
#         return matrix
#     if rows > cols:
#         pad = rows - cols
#         pad_left = pad // 2
#         pad_right = pad - pad_left
#         return np.pad(matrix, ((0, 0), (pad_left, pad_right)), constant_values=255)
#     else:
#         pad = cols - rows
#         pad_top = pad // 2
#         pad_bottom = pad - pad_top
#         return np.pad(matrix, ((pad_top, pad_bottom), (0, 0)), constant_values=255)

# # --- Step 7: Create Permutation Matrix with M^4 = I ---
# def construct_permutation_matrix(n, k=4):
#     while True:
#         p = np.random.permutation(n)
#         M = np.eye(n)[p]
#         Mk = np.linalg.matrix_power(M, k)
#         if np.allclose(Mk, np.identity(n)):
#             return M

# # --- Step 8: Matrix Transformation and Entropy ---
# def apply_matrix_operation(matrix, M):
#     return M @ matrix @ M.T

# def calculate_entropy(matrix):
#     values, counts = np.unique(matrix, return_counts=True)
#     prob = counts / counts.sum()
#     return entropy(prob, base=2)

# def show_transformed_results(original, transformed):
#     print(f"\nOriginal entropy: {calculate_entropy(original):.4f} bits")
#     print(f"Transformed entropy: {calculate_entropy(transformed):.4f} bits")
#     show_images_side_by_side(original, transformed, title1="Original", title2="Transformed by M")

# # --- MAIN EXECUTION ---

# image_path = 'number_zero.jpg'  # Your image path

# # Step 1: Image to Matrix
# matrix, original_image = image_to_matrix(image_path)

# # Step 2: Analyze Original
# analyze_and_plot(matrix)

# # Step 3: Make Matrix Square
# square_matrix = make_matrix_square(matrix)

# # Step 4: Construct Permutation Matrix
# n = square_matrix.shape[0]
# M = construct_permutation_matrix(n, k=4)

# # Step 5: Transform Matrix
# transformed_matrix = apply_matrix_operation(square_matrix, M)

# # Step 6: Convert to Image
# reconstructed_image = matrix_to_image(square_matrix, 'square_image.png')
# transformed_image = matrix_to_image(transformed_matrix, 'transformed_image.png')

# # Step 7: Compare Reconstructed to Original
# compare_images(original_image, reconstructed_image)

# # Step 8: Show Original vs Transformed
# show_transformed_results(square_matrix, transformed_matrix)





from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import entropy

# --- Step 1: Load Image and Convert to Matrix ---
def image_to_matrix(image_path):
    img = Image.open(image_path).convert('L')
    matrix = np.array(img)
    return matrix, img

# --- Step 2: Convert Matrix Back to Image ---
def matrix_to_image(matrix, save_path='reconstructed_image.png'):
    img = Image.fromarray(matrix.astype(np.uint8))
    img.save(save_path)
    return img

# --- Step 3: Show Histogram and Image Properties ---
def analyze_and_plot(matrix):
    shape = matrix.shape
    print(f"Matrix order: {shape[0]} rows x {shape[1]} columns")

    max_val = np.max(matrix)
    max_pos = np.unravel_index(np.argmax(matrix), matrix.shape)
    print(f"Maximum value: {max_val} at position {max_pos}")

    min_val = np.min(matrix)
    min_pos = np.unravel_index(np.argmin(matrix), matrix.shape)
    print(f"Minimum value: {min_val} at position {min_pos}")

    plt.figure(figsize=(8, 5))
    plt.hist(matrix.ravel(), bins=range(257), color='gray', edgecolor='black')
    plt.title("Histogram of Pixel Intensities")
    plt.xlabel("Pixel Value (0=Black, 255=White)")
    plt.ylabel("Frequency")
    plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout()
    plt.show()

# --- Step 4: Compare Two Images ---
def compare_images(img1, img2):
    arr1 = np.array(img1)
    arr2 = np.array(img2)
    is_equal = np.array_equal(arr1, arr2)
    print("\nAre the original and reconstructed images exactly equal?")
    print(is_equal)

# --- Step 5: Show Two Images Side by Side ---
def show_images_side_by_side(img1, img2, title1='Original Image', title2='Reconstructed Image'):
    plt.figure(figsize=(10, 5))
    plt.subplot(1, 2, 1)
    plt.imshow(img1, cmap='gray', vmin=0, vmax=255)
    plt.title(title1)
    plt.axis('off')

    plt.subplot(1, 2, 2)
    plt.imshow(img2, cmap='gray', vmin=0, vmax=255)
    plt.title(title2)
    plt.axis('off')
    plt.tight_layout()
    plt.show()

# --- Step 6: Pad Matrix to Make Square ---
def make_matrix_square(matrix):
    rows, cols = matrix.shape
    if rows == cols:
        return matrix
    if rows > cols:
        pad = rows - cols
        pad_left = pad // 2
        pad_right = pad - pad_left
        return np.pad(matrix, ((0, 0), (pad_left, pad_right)), constant_values=255)
    else:
        pad = cols - rows
        pad_top = pad // 2
        pad_bottom = pad - pad_top
        return np.pad(matrix, ((pad_top, pad_bottom), (0, 0)), constant_values=255)

# # --- Step 7: Create Enhanced Permutation Matrix with M^k = I ---
# def permutation_matrix_of_order_k(n, k):
#     """
#     Constructs a permutation matrix with cycles of length k (or divisors of k)
#     to maximize pixel rearrangement while ensuring M^k = I.
#     """
#     import numpy as np

#     perm = np.zeros(n, dtype=int)
#     remaining = list(range(n))
#     current_idx = 0

#     while remaining:
#         # Prioritize cycles of length k, then fall back to divisors
#         if len(remaining) >= k:
#             cycle_len = k  # Use cycles of length 4
#         else:
#             divisors = [d for d in range(1, k + 1) if k % d == 0 and d <= len(remaining)]
#             cycle_len = max(divisors) if divisors else 1

#         # Create a cycle
#         cycle_indices = remaining[:cycle_len]
#         for i in range(cycle_len):
#             perm[cycle_indices[i]] = cycle_indices[(i + 1) % cycle_len]
#         remaining = remaining[cycle_len:]

#     # Construct permutation matrix
#     M = np.zeros((n, n), dtype=int)
#     for i in range(n):
#         M[i, perm[i]] = 1

#     return M


# Insert the new permutation_matrix_of_order_k function here
def permutation_matrix_of_order_k(n, k):
    import numpy as np
    perm = np.zeros(n, dtype=int)
    remaining = list(range(n))
    current_idx = 0
    while remaining:
        if len(remaining) >= k:
            cycle_len = k
        else:
            divisors = [d for d in range(1, k + 1) if k % d == 0 and d <= len(remaining)]
            cycle_len = max(divisors) if divisors else 1
        cycle_indices = remaining[:cycle_len]
        for i in range(cycle_len):
            perm[cycle_indices[i]] = cycle_indices[(i + 1) % cycle_len]
        remaining = remaining[cycle_len:]
    M = np.zeros((n, n), dtype=int)
    for i in range(n):
        M[i, perm[i]] = 1
    return M





# --- Step 8: Matrix Transformation and Entropy ---
def apply_matrix_operation(matrix, M):
    return M @ matrix @ M.T

def calculate_entropy(matrix):
    values, counts = np.unique(matrix, return_counts=True)
    prob = counts / counts.sum()
    return entropy(prob, base=2)

def show_transformed_results(step, original, transformed):
    print(f"\nStep {step}: Entropy Comparison")
    print(f"Original entropy: {calculate_entropy(original):.4f} bits")
    print(f"Transformed entropy: {calculate_entropy(transformed):.4f} bits")
    show_images_side_by_side(original, transformed, title1="Original", title2=f"After Step {step}")

# # --- MAIN EXECUTION ---
# if __name__ == '__main__':
#     image_path = 'number_zero.jpg'  # Your image path
#     k = 10  # Number of operations, should match M^k = I

#     # Step 1: Image to Matrix
#     matrix, original_image = image_to_matrix(image_path)

#     # Step 2: Analyze Original
#     analyze_and_plot(matrix)

#     # Step 3: Make Matrix Square
#     square_matrix = make_matrix_square(matrix)

#     # Step 4: Construct Permutation Matrix
#     n = square_matrix.shape[0]
#     M = permutation_matrix_of_order_k(n, k=k)

#     # Step 5: Apply Transformation k Times
#     current_matrix = square_matrix.copy()
#     for step in range(1, k + 1):
#         current_matrix = apply_matrix_operation(current_matrix, M)
#         transformed_image = matrix_to_image(current_matrix, save_path=f'transformed_step{step}.png')
#         if (step % int(k/2) == 0):
#             show_transformed_results(step, square_matrix, current_matrix)

#     # Step 6: Final Check
#     final_image = Image.open(f'transformed_step{k}.png').convert('L')
#     compare_images(matrix_to_image(square_matrix), final_image)



# [Rest of your main execution code]
if __name__ == '__main__':
    image_path = 'My_image.jpg'  # Your image path
    k = 20
    matrix, original_image = image_to_matrix(image_path)
    analyze_and_plot(matrix)
    square_matrix = make_matrix_square(matrix)
    n = square_matrix.shape[0]
    M = permutation_matrix_of_order_k(n, k)
    current_matrix = square_matrix.copy()
    for step in range(1, k + 1):
        current_matrix = apply_matrix_operation(current_matrix, M)
        transformed_image = matrix_to_image(current_matrix, save_path=f'transformed_step{step}.png')
        if (step % int(k/2) == 0):
            show_transformed_results(step, square_matrix, current_matrix)
    final_image = Image.open(f'transformed_step{k}.png').convert('L')
    compare_images(matrix_to_image(square_matrix), final_image)