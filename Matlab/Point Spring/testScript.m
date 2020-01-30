clear;
clc;

plane_size = [10,10];
plane = point.empty;  


for i = 1:plane_size(1)
    for j = 1:plane_size(2)
        plane(i,j).x = i;
        plane(i,j).y = j;
        plane(i,j).z = j;
    end
end


new = padPlane(plane);