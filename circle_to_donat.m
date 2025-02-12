% Making donat shape by rotating the circle around the y axis.


nt = 100;
t = linspace(0,2*pi,nt).'; % I want this as a column vector
C = [2, 3]; % the center of the circle in the (x,y) plane.
R = 1; % radius 1
xy = C + R*[cos(t), sin(t)]; % points in the circle
plot(xy(:,1),xy(:,2),'r-')
axis equal;


nphi = 200; % 100 elements around the axis.
phi = linspace(0,2*pi,nphi + 1);
[T,PHI] = ndgrid(t,phi);


%Now build the nodes in (x,y,z), by rotating the circle around the y axis.
X = (C(1)+R*cos(T)).*cos(PHI); % Multiply the original x by cos(phi)
Y = (C(2)+R*sin(T)); % Leave Y alone
Z = (C(1)+R*cos(T)).*sin(PHI); % Multiply the original x by sin(phi) to create the Z component
surf(X,Y,Z)
axis equal
box on
xlabel X
ylabel Y
zlabel Z

