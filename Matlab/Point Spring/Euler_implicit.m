function [x,t] = Euler_implicit(m, kd, ks, n, tf, v0, x0, t0)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
ag = -9.81;
h = tf/n; %Time step

%Pre-allocate arrays
x = zeros(1, n+1);
t = zeros(1, n+1);
v = zeros(1, n+1);

v(1) = v0;
x(1) = x0;
t(1) = t0;

%Time integration using Euler's method
for i = 1:n
    t(i+1) = t(i) + h;
    Fk = (ag -ks*x(i)-kd*v(i))*m; % F = ma 
    v(i+1) = v(i) + h*(Fk/m);
    x(i+1) = x(i) + v(i+1)*h;
    
end
end

