classdef Agent
    %Person Summary of AGENT
    %   Detailed explanation goes here
    
    properties
        Hardship;
        Risk_Aversion;
        Vision;
        Jailt=0;
        Can_Move = true;
        Pers_Legitimacy;
        Effectiveness=1;
        Is_Active = false;
    end
    
    methods
           function obj = Agent(H, R, V, Leg, E)
           % class constructor
               obj.Hardship = H;
               obj.Risk_Aversion = R;
               obj.Vision = V;
               obj.Jailt=0;
               obj.Can_Move=true;
               obj.Pers_Legitimacy = Leg;
               obj.Effectiveness = E;
               obj.Is_Active = false;
           end
           
           function G = Grievance (this, L)
               G = this.Hardship*(1-min(1, max(0, L+this.Pers_Legitimacy)));
           end
           function P = Chance_of_Arrest (this, k, C, A)
               P = 1 - exp(-k*C/A);
           end
           function N = Net_Risk (this, P, J, alpha)
               N = this.Risk_Aversion*P*(J^alpha);
           end
           function N = Get_Type (this)
               N = 'Agent';
           end
           function N = Jailtime (this)
               N = this.Jailt;
           end
           function this = Set_Jailtime (this, J)
               this.Jailt = J;
           end
           function this = Set_Hardship (this, H)
               this.Hardship = H;
           end
           function b = Moveable (this)
               b = this.Can_Move;
           end
           function this = Set_Move (this, b)
               this.Can_Move = b;
           end
           function b = Active (this)
               b = this.Is_Active;
           end
           function this = Set_Active (this, b)
               this.Is_Active = b;
           end
    end
    
end

