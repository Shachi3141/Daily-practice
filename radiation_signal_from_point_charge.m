% Constants
c = 3e8; % Speed of light in m/s
f = 1e9; % Frequency of radiation in Hz
lambda = c / f; % Wavelength in meters

% Define angles for spherical coordinates
theta = linspace(0, pi, 100); % Theta varies from 0 to pi (polar angle)
phi = linspace(0, 2*pi, 200); % Phi varies from 0 to 2*pi (azimuthal angle)

% Compute radiation pattern
E_theta = sin(theta); % E-field component in theta direction (polarization)
E_phi = zeros(size(phi)); % E-field component in phi direction (azimuthal)

% Convert spherical coordinates to Cartesian coordinates
[Theta, Phi] = meshgrid(theta, phi);
[X, Y, Z] = sph2cart(Phi, pi/2 - Theta, abs(E_theta));

% Plot radiation pattern
figure;
surf(X, Y, Z);
hold on
title('Radiation Pattern from Point Charge Acceleration');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
scale_factor = 1.5; % Adjust the length of the axes
quiver3(0, 0, 0, scale_factor, 0, 0, 'r', 'LineWidth', 2); % X-axis
quiver3(0, 0, 0, 0, scale_factor, 0, 'g', 'LineWidth', 2); % Y-axis
quiver3(0, 0, 0, 0, 0, scale_factor, 'b', 'LineWidth', 2); % Z-axis

view(-37.5, 30); % Adjust view angle for better visualization
