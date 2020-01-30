function [x, y, t] = Euler_implicit_2(m, kd, ks, n, tf, v0, x0, y0, t0)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
ag = -9.81;
h = tf/n; %Time step

%Pre-allocate arrays
x = zeros(1, n+1);
y = zeros(1, n+1);
t = zeros(1, n+1);
v = zeros(1, n+1);

vx(1) = v0;
vy(1) = v0;
x(1) = x0;
y(1) = y0;
t(1) = t0;

%Time integration using Euler's method
for i = 1:n
    t(i+1) = t(i) + h;
    Fx = (-ks*x(i)-kd*v(i))*m; % F = ma 
    Fy = ag;
    vx(i+1) = vx(i) + h*(Fx/m);
    vy(i+1) = vy(i) + h*(Fy/m);
    x(i+1) = x(i) + vx(i+1)*h;
    y(i+1) = y(i) + vy(i+1)*h;
end
end