function [y] = Euler_implicit(m, t_in, v1, v2, kd, ks, yt, h)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

y = zeros(size(yt));

ag = -9.81;

%Pre-allocate arrays
x = zeros(1, 2);
t = zeros(1, 2);
v = zeros(1, 2);

%Time integration using Euler's method
for i = 1:size(y(:,1))
    
    for j = 1:size(y(1,:))
        
        if(i == 1)
            F = 0;
        
        else
                
        v(1) = 1;
        x(1) = yt(i,j);
        t(1) = t_in;
        
        t(2) = t(1) + h;
        F = m*ag -ks*(1-(y(i-1, j)-yt(i-1,j))-kd*v(1);
        v(2) = v(1) + h*(F)/m;
        x(2) = x(1) + v(2)*h;

        end
        
        
        y(i,j) = x(2);

    end
    
end