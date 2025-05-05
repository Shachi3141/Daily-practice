import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Heart parametric curve
t = np.linspace(0, 2 * np.pi, 1000)
x = 16 * np.sin(t) ** 3
y = 13 * np.cos(t) - 5 * np.cos(2 * t) - 2 * np.cos(3 * t) - np.cos(4 * t)

# Set up figure and axis
fig, ax = plt.subplots(figsize=(6, 6))
ax.set_facecolor("mistyrose")
ax.set_xlim(-20, 20)
ax.set_ylim(-20, 20)
ax.axis('off')
ax.set_aspect('equal')

# Create line and fill objects
line, = ax.plot([], [], color='red', linewidth=2)
fill = ax.fill(x[:2], y[:2], color='red', alpha=0.5)[0]
text = ax.text(0, 0, '', fontsize=22, color='darkgreen',
               fontweight='bold', ha='center', va='center')

# Initialization
def init():
    line.set_data([], [])
    fill.set_xy(np.column_stack((x[:2], y[:2])))
    text.set_text('')
    return line, fill, text

# Animation update
def update(frame):
    xdata = x[:frame]
    ydata = y[:frame]
    line.set_data(xdata, ydata)
    if frame > 10:
        fill.set_xy(np.column_stack((xdata, ydata)))
    if frame >= len(x) - 5:  # Trigger text in final few frames
        text.set_text("Hi Baby ❤️")
    return line, fill, text

# Animate
ani = animation.FuncAnimation(
    fig, update, frames=len(x), init_func=init,
    interval=1, blit=True, repeat=False
)

# Save as GIF
#ani.save("animated_heart.gif", writer='pillow', fps=60)

# Show the animation
plt.show()
