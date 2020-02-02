function [newPositions] = forcefield(t,step,plane,ks,kd,R,m)
%   Beräknar nya positioner [newPositions] för alla punkter, samt lagrar en iteration
%   bakåt av geometrin. Beräknas med Verletintegration.


%planeSize = size(plane);


paddedPlane = padPlane(plane);
paddedSize = size(paddedPlane);    

newPositions = plane;

counterX = 1;
counterY = 1;

    for i = 2:paddedSize(1)-1
        counterY = 1;
        for j = 2:paddedSize(2)-1
            
            totPointForce = applyForceKernel(paddedPlane,i,j,ks,kd,R,m);
            
            
            
            newPositions(counterX,counterY).x = paddedPlane(i,j).x;
            newPositions(counterX,counterY).y = paddedPlane(i,j).y;
            newPositions(counterX,counterY).z = paddedPlane(i,j).z;
            counterY = counterY+1;
        end
        counterX = counterX+1;
    end
    

end