function [newPositions] = force(step,plane,K,m)
%   Beräknar nya positioner [newPositions] för alla punkter, samt lagrar en iteration
%   bakåt av geometrin. Beräknas med Verletintegration.


planeSize = size(plane);
newPositions = plane;

 

    
    
    for i = 1:planeSize(1)
        for j = 1:planeSize(2)
            
            applyForceKernel(plane,i,j);
            
            newPositions(i,j).x = newPositions(i,j).x;
            newPositions(i,j).y = newPositions(i,j).y;
            newPositions(i,j).z = newPositions(i,j).z;
        end
    end

    
    

end