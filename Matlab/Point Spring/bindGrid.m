function [X,Y,Z] = bindGrid(plane,plane_size)
%BINDGRID Summary of this function goes here
%   Detailed explanation goes here


for i = 1:plane_size
    for j = 1:plane_size
        X(i,j) = plane(i,j).x;
        Y(i,j) = plane(i,j).y;
        Z(i,j) = plane(i,j).z;
    end
end


end

