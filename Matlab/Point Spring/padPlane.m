function [paddedPlane] = padPlane(plane)

paddedSize = size(plane)+2;


paddedPlane = point.empty;              %Skapa ett plan

for i = 1:paddedSize(1)
    for j = 1:paddedSize(2)
        paddedPlane(i,j).x = 0;
        paddedPlane(i,j).y = 0;
        paddedPlane(i,j).z = 0;
        paddedPlane(i,j).ifPad = true;
    end
end


counterX = 1;
counterY = 1;


for i = 2:paddedSize(1)-1
    counterY = 1;
    for j = 2:paddedSize(2)-1
        
        
        
        paddedPlane(i,j).x = plane(counterX,counterY).x;
        paddedPlane(i,j).y = plane(counterX,counterY).y;
        paddedPlane(i,j).z = plane(counterX,counterY).z;
        paddedPlane(i,j).ifPad = false;
        counterY = counterY+1;
    end
    counterX = counterX+1;
    
end


end

