classdef Field
    %Person Summary of FIELD
    %   Detailed explanation goes here
    
    properties
        Importance = 0;
        ID;
    end
    
    methods
        function obj = Field(d, I)
           % class constructor
               obj.ID = d;
               obj.Importance = I;
           end
    end
    
end

