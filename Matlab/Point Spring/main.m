clear;
clc;

plane = point.empty;
size = 10;


for i = 1:size
    for k = 1:size
        plane(i,k) = point(k,i,1);
    end
end


