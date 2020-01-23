classdef particle
    %PARTICLE Class representing a small particle
    % for building a particle system
    
    properties
        % Row and column??
        initalPos; %Initial position
        pos; %Current position
        prevPos; %The last known position
        v; %Velocity
        a; %Acceleration
        F_ext; %External forces acting on particle
        F; %Internal forces
    end
    
    methods
        function particle = particle(x,y)
            %PARTICLE Construct an instance of particle at position x,y
            particle.pos = [x y];
            particle.v = [0 0];
            particle.a = [0 0];
        end
        
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

