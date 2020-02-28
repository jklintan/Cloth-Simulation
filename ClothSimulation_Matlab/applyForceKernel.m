function [added_f] = applyForceKernel(paddedPlane,x,y,ks,kd,R,m, airRes)
%APPLYFORCEKERNEL Summary of this function goes here
%   Detailed explanation goes here
    

if(paddedPlane(x,y+1).ifPad == false)
    
    vec1 = [paddedPlane(x,y+1).x-paddedPlane(x,y).x paddedPlane(x,y+1).y-paddedPlane(x,y).y paddedPlane(x,y+1).z-paddedPlane(x,y).z];
    
    vec1Length = norm(vec1);
    
    vel1 = paddedPlane(x,y+1).prevVel-paddedPlane(x,y).prevVel;
   
    f1 = ks*(vec1Length-R)*(vec1/vec1Length) + kd*vel1 - airRes*vel1;
else
    f1 = 0;
end

if(paddedPlane(x+1,y).ifPad == false)
    vec2 = [paddedPlane(x+1,y).x-paddedPlane(x,y).x paddedPlane(x+1,y).y-paddedPlane(x,y).y paddedPlane(x+1,y).z-paddedPlane(x,y).z];
    
    vec2Length = norm(vec2);
    
    vel2 = paddedPlane(x+1,y).prevVel-paddedPlane(x,y).prevVel;
    
    f2 = ks*(vec2Length-R)*(vec2/vec2Length) + kd*vel2 - airRes*vel2;
    
else
    f2 = 0;
end
    
if(paddedPlane(x,y-1).ifPad == false)
    vec3 = [paddedPlane(x,y-1).x-paddedPlane(x,y).x paddedPlane(x,y-1).y-paddedPlane(x,y).y paddedPlane(x,y-1).z-paddedPlane(x,y).z];
    
    vec3Length = norm(vec3);
    
    vel3 = paddedPlane(x,y-1).prevVel-paddedPlane(x,y).prevVel;
    
    f3 = ks*(vec3Length-R)*(vec3/vec3Length) + kd*vel3 - airRes*vel3;
    
else
    f3 = 0;
end

if(paddedPlane(x-1,y).ifPad == false)
    vec4 = [paddedPlane(x-1,y).x-paddedPlane(x,y).x paddedPlane(x-1,y).y-paddedPlane(x,y).y paddedPlane(x-1,y).z-paddedPlane(x,y).z];
    
    vec4Length = norm(vec4);
    
    vel4 = paddedPlane(x-1,y).prevVel-paddedPlane(x,y).prevVel;
    
    f4 = ks*(vec4Length-R)*(vec4/vec4Length) + kd*vel4 - airRes*vel4;
    
else
    f4 = 0;
end

mg = -m*9.81;


added_f = f1+f2+f3+f4;
%added_f = [0 0 0];
added_f(3) = added_f(3) + mg;

end

