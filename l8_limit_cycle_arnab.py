import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp

mu = 1.0

def nonlinear_system(t, r):
    x, y = r
    temp = np.sqrt(x*x + y*y)
    dxdt = mu * x * (1-temp) - y
    dydt = x + mu * y * (1-temp)
    return [dxdt, dydt]

# Parameters for phase portrait
x_min, x_max = -2, 2
y_min, y_max = -2, 2
grid_points = 20
trajectory_steps = 200
t_span = [0, 20]  

# Create a grid 
x = np.linspace(x_min, x_max, grid_points)
y = np.linspace(y_min, y_max, grid_points)
X, Y = np.meshgrid(x, y)

# Vector field
U, V = nonlinear_system(0, [X,Y])

initial_conditions = np.array([
     [1.5, 1.5], [1.5, -1.5], [-1.5, -1.5], [0.001, 0] ])


plt.figure(1, figsize=(8, 6))
plt.quiver(X, Y, U, V, color='gray', alpha=0.4, headwidth = 2.5)


# Solve and plot trajectories
for r0 in initial_conditions:
    sol = solve_ivp(nonlinear_system, t_span, r0, 
                    t_eval=np.linspace(t_span[0], t_span[1], trajectory_steps))
    plt.plot(sol.y[0], sol.y[1], lw=1.5)          # Trajectory
    x_temp = sol.y[0][::5]
    y_temp = sol.y[1][::5]
    uu, vv = nonlinear_system(0, [x_temp, y_temp])
    normalised = np.sqrt(uu**2 + vv**2)
    uu = uu/normalised
    vv = vv/normalised
    plt.quiver(x_temp, y_temp, uu, vv, scale = 100, alpha = 0.6, width = 0.002,
               headlength=20, headwidth=12, headaxislength=16)



plt.xlabel('x')
plt.ylabel('y')
plt.title(r'Phase Portrait: $\dot{x} = x (1 - r) - y$, $\dot{y} = x + y (1-r)$')
plt.xlim(x_min, x_max)
plt.ylim(y_min, y_max)
plt.grid(True)
#plt.show()

plt.figure(2, figsize=(8,6))
plt.plot(np.linspace(t_span[0], t_span[1], trajectory_steps), sol.y[0])
plt.plot(np.linspace(t_span[0], t_span[1], trajectory_steps), sol.y[1])
plt.show()



