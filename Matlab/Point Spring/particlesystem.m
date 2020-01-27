classdef particlesystem 
    %PARTICLESYSTEM Collection of particles
    
    properties
        row;
        col;
        particles;
    end
    
    methods
        function particlesystem = particlesystem(r,c, particles)
            %Constructor
            particlesystem.row = r;
            particlesystem.col = c;
            particlesystem.particles = particles;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end