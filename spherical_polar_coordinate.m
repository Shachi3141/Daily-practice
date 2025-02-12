% 3D spherical polar coordinate plot


nt = 100;
t = linspace(0,pi/2,nt).'; % I want this as a column vector
C = [0, 0]; % the center of the circle in the (x,y) plane.
R = 1; % radius 1
xy = C + R*[cos(t), sin(t)]; % points in the circle
plot(xy(:,1),xy(:,2),'r-')
axis equal;


nphi = 200; % 100 elements around the axis.
phi = linspace(0,pi,nphi + 1);
[T,PHI] = ndgrid(t,phi);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
[theta,phi]=meshgrid(linspace(-pi/2,pi/2),linspace(0,2*pi));
r=1+sin(theta*3).*cos(phi*2);
X=cos(theta).*cos(phi).*r;
Y=cos(theta).*sin(phi).*r;
Z=sin(theta).*r;
surf(X,Y,Z)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




X = (C(1)+R*sin(T)).*cos(PHI); 
Y = (C(2)+R*sin(T)).*sin(PHI); 
Z = (C(1)+R*cos(T));

surf(X,Y,Z)
hold on
scatter3(0,0,-R)
axis equal
box on
xlabel X
ylabel Y
zlabel Z
% Plot the axes
scale_factor = 1.5; % Adjust the length of the axes
quiver3(0, 0, 0, scale_factor, 0, 0, 'r', 'LineWidth', 2); % X-axis
quiver3(0, 0, 0, 0, scale_factor, 0, 'g', 'LineWidth', 2); % Y-axis
quiver3(0, 0, 0, 0, 0, scale_factor, 'b', 'LineWidth', 2); % Z-axis

