classdef point
    %POINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x;
        y;
        z;
    end
    
    methods
        function obj = point(inputArg1,inputArg2,inputArg3)
            %POINT Construct an instance of this class
            %   Detailed explanation goes here
            if nargin > 0
            obj.x = inputArg1;
            obj.y = inputArg2;
            obj.z = inputArg3;
            end
            
        end
        
%         function outputArg = method1(obj,inputArg)
%             %METHOD1 Summary of this method goes here
%             %   Detailed explanation goes here
%             outputArg = obj.Property1 + inputArg;
%         end
    end
end

