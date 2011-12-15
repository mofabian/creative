classdef Cop
    %Person Summary of AGENT
    %   Detailed explanation goes here
    
    properties
       Vision;
       Can_Move = true;
       Pers_Legitimacy;
       Effectiveness=1;
    end
    
    methods
           function obj = Cop(V, Leg, E)
           % class constructor
               obj.Vision = V;
               obj.Can_Move=true;
               obj.Pers_Legitimacy = Leg;
               obj.Effectiveness = E;
           end
           function N = Get_Type (this)
               N = 'Cop';
           end
           function b = Moveable (this)
               b = this.Can_Move;
           end
           function this = Set_Move (this, b)
               this.Can_Move = b;
           end
    end
    
end

