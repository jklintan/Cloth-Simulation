function [added_f] = applyForceKernel(paddedPlane,[y,x],ks,kd,R)
%APPLYFORCEKERNEL Summary of this function goes here
%   Detailed explanation goes here
    

if(paddedPlane(x,y+1).ifPad == false)
    
    vec1 = [paddedPlane(x,y+1).x-paddedPlane(x,y).x paddedPlane(x,y+1).y-paddedPlane(x,y).y paddedPlane(x,y+1).z-paddedPlane(x,y).z]
    
    vec1Length = abs(vec1);
    
    f1 = ks*(vec1Length-R)*(vec1/vec1Length);
else
    f1 = 0;
end

if(paddedPlane(x+1,y).ifPad == false)
    vec2 = [paddedPlane(x+1,y).x-paddedPlane(x,y).x paddedPlane(x+1,y).y-paddedPlane(x,y).y paddedPlane(x+1,y).z-paddedPlane(x,y).z]
    
    vec2Length = abs(vec2);
    
    f2 = ks*(vec2Length-R)*(vec2/vec2Length);
    
else
    f2 = 0;
end
    
if(paddedPlane(x,y-1).ifPad == false)
    vec3 = [paddedPlane(x,y-1).x-paddedPlane(x,y).x paddedPlane(x,y-1).y-paddedPlane(x,y).y paddedPlane(x,y-1).z-paddedPlane(x,y).z]
    
    vec3Length = abs(vec3);
    
    f3 = ks*(vec3Length-R)*(vec3/vec3Length);
    
else
    f3 = 0;
end

if(paddedPlane(x-1,y).ifPad == false)
    vec4 = [paddedPlane(x-1,y).x-paddedPlane(x,y).x paddedPlane(x-1,y).y-paddedPlane(x,y).y paddedPlane(x-1,y).z-paddedPlane(x,y).z]
    
    vec4Length = abs(vec4);
    
    f4 = ks*(vec4Length-R)*(vec4/vec4Length);
    
else
    f4 = 0;
end
    
   added_f = f1+f2+f3+f4; 

end

