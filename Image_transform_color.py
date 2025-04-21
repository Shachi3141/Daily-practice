

from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
from scipy import ndimage
from sklearn.cluster import KMeans
from skimage.measure import shannon_entropy

def image_to_matrix_color(image_path):
    """Load a color image and return as a NumPy array along with the PIL image."""
    img = Image.open(image_path).convert('RGB')
    matrix = np.array(img)
    return matrix, img

def matrix_to_image_color(matrix, save_path='reconstructed_color_image.png'):
    """Save a NumPy RGB matrix as an image."""
    img = Image.fromarray(matrix.astype(np.uint8))
    img.save(save_path)
    return img

def analyze_and_plot_color(matrix):
    """Print basic channel info and plot histograms."""
    print(f"Image Shape: {matrix.shape} (Height, Width, Channels)")

    channels = ['Red', 'Green', 'Blue']
    colors = ['red', 'green', 'blue']

    plt.figure(figsize=(12, 4))
    for i, (ch_name, color) in enumerate(zip(channels, colors)):
        ch = matrix[:, :, i]
        print(f"\n{ch_name} Channel:")
        print(f"  Max value: {np.max(ch)} at {np.unravel_index(np.argmax(ch), ch.shape)}")
        print(f"  Min value: {np.min(ch)} at {np.unravel_index(np.argmin(ch), ch.shape)}")

        plt.subplot(1, 3, i + 1)
        plt.hist(ch.ravel(), bins=range(257), color=color) # , edgecolor='black'
        plt.title(f"{ch_name} Histogram")
        plt.xlabel("Pixel Value")
        plt.ylabel("Frequency")
        plt.grid(True, linestyle='--', alpha=0.5)
    plt.tight_layout()
    plt.show()

def channel_statistics(matrix):
    """Print mean, std, median for each channel."""
    print("\n--- Channel Statistics ---")
    for i, name in enumerate(['Red', 'Green', 'Blue']):
        data = matrix[:, :, i]
        print(f"{name} - Mean: {np.mean(data):.2f}, Std: {np.std(data):.2f}, Median: {np.median(data)}")

def edge_detection(matrix):
    """Visualize image edges using Sobel filter."""
    gray = np.mean(matrix, axis=2).astype(np.uint8)
    sx = ndimage.sobel(gray, axis=0)
    sy = ndimage.sobel(gray, axis=1)
    sobel = np.hypot(sx, sy)

    plt.imshow(sobel, cmap='gray')
    plt.title("Edge Detection (Sobel Filter)")
    plt.axis('off')
    plt.show()

def sharpness_measure(matrix):
    """Calculate image sharpness as Laplacian variance."""
    gray = np.mean(matrix, axis=2).astype(np.uint8)
    lap = ndimage.laplace(gray)
    print(f"Sharpness (Laplacian Variance): {np.var(lap):.2f}")

def display_channels(matrix):
    """Show each color channel as an image."""
    titles = ['Red Channel', 'Green Channel', 'Blue Channel']
    plt.figure(figsize=(12, 4))
    for i in range(3):
        img = np.zeros_like(matrix)
        img[:, :, i] = matrix[:, :, i]
        plt.subplot(1, 3, i + 1)
        plt.imshow(img)
        plt.title(titles[i])
        plt.axis('off')
    plt.tight_layout()
    plt.show()

def find_dominant_colors(matrix, n_colors=5):
    """Use KMeans clustering to find dominant colors."""
    pixels = matrix.reshape(-1, 3)
    kmeans = KMeans(n_clusters=n_colors, random_state=42).fit(pixels)
    colors = kmeans.cluster_centers_.astype(int)

    plt.figure(figsize=(8, 2))
    for i, color in enumerate(colors):
        plt.subplot(1, n_colors, i + 1)
        plt.imshow([[color]])
        plt.axis('off')
    plt.suptitle("Dominant Colors")
    plt.show()

    print("Dominant RGB Colors:")
    for i, c in enumerate(colors, 1):
        print(f"  {i}: {tuple(c)}")

def image_colorfulness(matrix):
    """Calculate colorfulness using Hasler-Süsstrunk metric."""
    R, G, B = matrix[:, :, 0], matrix[:, :, 1], matrix[:, :, 2]
    rg = np.abs(R - G)
    yb = np.abs(0.5 * (R + G) - B)
    std_rg, std_yb = np.std(rg), np.std(yb)
    mean_rg, mean_yb = np.mean(rg), np.mean(yb)
    colorfulness = np.sqrt(std_rg**2 + std_yb**2) + 0.3 * np.sqrt(mean_rg**2 + mean_yb**2)
    print(f"Image Colorfulness: {colorfulness:.2f}")

def image_entropy(matrix):
    """Compute image entropy from grayscale version."""
    gray = np.mean(matrix, axis=2).astype(np.uint8)
    entropy = shannon_entropy(gray)
    print(f"Image Entropy: {entropy:.2f}")

def compare_images(img1, img2):
    """Check whether two images are pixel-wise identical."""
    is_equal = np.array_equal(np.array(img1), np.array(img2))
    print("\nAre the original and reconstructed images exactly equal?")
    print(is_equal)

def show_images_side_by_side(img1, img2, title1='Original Image', title2='Reconstructed Image'):
    """Display original and reconstructed images."""
    plt.figure(figsize=(10, 5))
    plt.subplot(1, 2, 1)
    plt.imshow(img1)
    plt.title(title1)
    plt.axis('off')

    plt.subplot(1, 2, 2)
    plt.imshow(img2)
    plt.title(title2)
    plt.axis('off')

    plt.tight_layout()
    plt.show()

# --- MAIN ---

image_path = 'My_image.jpg'  # Replace with your actual image path

# Step 1: Convert image to matrix
matrix_color, original_image = image_to_matrix_color(image_path)

# Step 2: Histogram and pixel value analysis
analyze_and_plot_color(matrix_color)

# Step 3: Additional image analyses
channel_statistics(matrix_color)
edge_detection(matrix_color)
sharpness_measure(matrix_color)
display_channels(matrix_color)
find_dominant_colors(matrix_color)
image_colorfulness(matrix_color)
image_entropy(matrix_color)

# Step 4: Convert matrix back to image
reconstructed_image = matrix_to_image_color(matrix_color, save_path='reconstructed_color_image.png')

# Step 5: Compare with original and show
compare_images(original_image, reconstructed_image)
show_images_side_by_side(original_image, reconstructed_image)
