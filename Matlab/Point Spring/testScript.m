clear;
clc;

plane_size = [10,10];
plane = point.empty;  


for i = 1:plane_size(1)
    for j = 1:plane_size(2)
        plane(i,j).x = j;
        plane(i,j).y = i;
        plane(i,j).z = 0;
    end
end


new = padPlane(plane);
newSize = size(new);

forces = applyForceKernel(new,2,2,100,10,1.0,0.1)

