
% Parameters
m = 1;      % Mass
k = 1;      % Spring constant

% Initial conditions
initial_position = 0.5;     % Initial displacement
initial_velocity = 0;       % Initial velocity

% Time span
tspan = [0, 10];            % Time interval for simulation

% Define the differential equation as a function
% x'(1) = x(t), x'(2) = x'(t)
% x''(t) = -k/m * x(t)
f = @(t, x) [x(2); -k/m * x(1)];

% Solve the differential equation
[t, sol] = ode45(f, tspan, [initial_position, initial_velocity]);

% Extract position from the solution
position = sol(:, 1);

% Plot the result
figure;
%plot(t, position);
xlabel('Time');
ylabel('Displacement');
title('Simple Harmonic Oscillation');
grid on;
fprintf('%d \n',position);
