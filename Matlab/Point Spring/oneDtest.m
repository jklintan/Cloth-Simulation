  
close('all');
clear all;
clc;
%Spring-mass, Euler's integration
m = 0.01; % Kg
kd = 1;  % Ns/m
ks = 10; % N/m
tf = 10; %Final time
n = 1000; % No. of time steps

%Initial conditions
v0 = 0;
x0 = 1;
%y0 = 1;
t0 = 0;

[x, t] = Euler_implicit(m, kd, ks, n, tf, v0, x0, t0);

plot(t,x)