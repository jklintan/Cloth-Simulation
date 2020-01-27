classdef particle
    %PARTICLE Class representing a small particle with a finite mass
    
    properties
        % Row and column??
        m; %Mass
        initalPos; %Initial position
        pos; %Current position
        prevPos; %The last known position
        v; %Velocity
        a; %Acceleration
        F_ext; %External forces acting on particle
        F; %Internal forces
        row;
        col;
        isFixed; %True or false if false or not
    end
    
    methods
        function particle = particle(x,y, mass, fixed)
            %PARTICLE Construct an instance of particle at position x,y
            particle.row = x;
            particle.col = y;
            particle.initalPos = [(y-1)/100 (x-1)/100];
            particle.pos = particle.initalPos;
            particle.v = [0 0];
            particle.a = [0 0];
            particle.m = mass;
            particle.F_ext = [0 0];
            particle.isFixed = fixed;
        end
        
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

