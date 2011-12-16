side = 40;
L = 0.8;
O_to_U_Ratio = 0.7;     
C_to_A_Ratio = 0.00;     
Jailterm_Min = 3;          
Jailterm_Max = 5;          
Jailsentence = @() random('Uniform',Jailterm_Min,Jailterm_Max,1,1);
Better_Deterrent_of_Jailtime = 0;
Better_Aggreviance_when_Agent_leaves_Jail = false;
Aggreviance = @() random('Uniform',-0.5,0.5,1,1);
Activism_Threshold = 0.1;
Murder_threshold =1;
Murder_success_rate = 0.0;
Murder_assasin_death_rate = 0.0;
Vision_Min_Cops = 1;
Vision_Max_Cops = 3;
Vision_Min_Agent = 1;
Vision_Max_Agent = 3;
Death = false;
Agent_Death_Chance = 0.0;
Agent_Death_Legitimacy_Penalty = 0.02;
Cop_Death_Chance = 0.00;
Cop_Death_Legitimacy_Boost = 0.03;
Important_Land = false;         
ID = 210;
Importance = 0;
ImportantFields{1} = Field(ID, Importance);
Important_People = false;
Important_Chance_Agents = 0.0;
Important_Effectiveness_Agents = 5;
Important_Chance_Cops = 0.0;
Important_Effectiveness_Cops = 5;
Defective_Cops = false;
Legitimacy_Mod_Cop = 0.0;
Legitimacy_Threshold_Stop = 0.0;
Legitimacy_Threshold_Defect = 0.0;
Better_Legitimacy = false;
Legitimacy_Mod = 0.0;
Each_Round_Legitimacy_Change = 0;
Number_of_Frames = 200;
Plot_every_X_Frames = 50;

for i=17:1:23
    for j=17:1:23
     V = floor(random('Uniform',Vision_Min_Cops,Vision_Max_Cops,1,1));
                if Defective_Cops
                    Leg = random('Uniform',-Legitimacy_Mod_Cop,Legitimacy_Mod_Cop,1,1);
                else
                    Leg = 0;
                end
                if random('Uniform',0,1,1,1) < Important_Chance_Cops
                    E = Important_Effectiveness_Cops;
                    V = V*Important_Effectiveness_Cops;
                else
                    E = 1;
                end
                Playfield{(i-1)*side + j} = Cop(V, Leg, E);
    end
end
