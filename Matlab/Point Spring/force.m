function [f] = force(K,point)
%FORCE Summary of this function goes here
%   Detailed explanation goes here

x = point.x;
y = point.y;
z = point.z;

euc_length = sqrt((x^2)+(y^2)+(z^2));

f = K*(euc_length-)

end

