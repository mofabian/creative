classdef Empty
    %Person Summary of EMPTY
    %   Detailed explanation goes here
    
    properties
        Vision=0;
    end
    
    methods
           function obj = Empty()
                % class constructor
                Vision = 0;
           end
           
           function N = Get_Type (this)
               N = 'Empty';
           end
    end
    
end
