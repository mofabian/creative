%   FIX VALUES, CHANGE THESE IF NECESSARY

clear all;

side = 40;
%Side of the playfield

L = 0.7;
%Legitimacy of the Regime

O_to_U_Ratio = 0.5;     
%Occupied Spaces to Unoccupied Spaces

C_to_A_Ratio = 0.1;     
%Cops to Agents Ratio

Jailterm_Min = 3;          
%Jailterm in Years

Jailterm_Max = 5;          
%Jailterm in Years

Jailsentence = @() random('Uniform',Jailterm_Min,Jailterm_Max,1,1);
%Jailsentence = @(x, y) random('Uniform',x,y,1,1);

Better_Deterrent_of_Jailtime = 0;
%In Paper alpha=0

Better_Aggreviance_when_Agent_leaves_Jail = false;
Aggreviance = @() random('Uniform',-0.5,0.5,1,1);

Activism_Threshold = 0.1;
%If Grievance - Net Risk > Activism_Threshold -> Agent is active

Murder_threshold =1;
Murder_success_rate = 0.0;
Murder_assasin_death_rate = 0.0;
%If Grievance - Net Risk > Murder_threshold -> Agent kills Cops

Vision_Min_Cops = 7;
Vision_Max_Cops = 7;
Vision_Min_Agent = 7;
Vision_Max_Agent = 7;

Death = false;
Agent_Death_Chance = 0.0;
Agent_Death_Legitimacy_Penalty = 0.02;
Cop_Death_Chance = 0.00;
Cop_Death_Legitimacy_Boost = 0.03;
%Agents and Cops can die in Confrontations

Important_Land = false;         
%Some spots of land are important
ID = 210;
Importance = 0;
ImportantFields{1} = Field(ID, Importance);

Important_People = false;
Important_Chance_Agents = 0.0;
Important_Effectiveness_Agents = 5;
Important_Chance_Cops = 0.0;
Important_Effectiveness_Cops = 5;
%Some people are important
%Important Agents count as "more" Agents, effectively making others rebell
%Important Cops count as "more" Cops, effectively silencing protest.
%Important People have extended Vision

Defective_Cops = false;
Legitimacy_Mod_Cop = 0.0;
Legitimacy_Threshold_Stop = 0.0;
Legitimacy_Threshold_Defect = 0.0;
%If a Cop's view of the Legitimacy drops too low, he may stop arresting, or defect.

Better_Legitimacy = false;
Legitimacy_Mod = 0.0;
%Agents all have a personal Legitimacy Modifier, which modifies the global
%Legitimacy.

Each_Round_Legitimacy_Change = -0.9/200;

One_Time_Change = true;
One_Time_Legitimacy_Change = 0;
round_for_One_Time_Legitimacy_Change = 20;

Number_of_Frames = 200;
%Number of Rounds

Plot_every_X_Frames = 50;
%Only plot some of the rounds (1=Plot every Round)

k = 2.3;                
%Constant so that 0.9 = 1 - exp(-k), see Paper

%StatisticalAnalysis
%AllReleases = [];
%AllAgentMoves = [];
%AllCopMoves = [];

    %   First, we need to generate a Problem
    %   OY, KEEP HANDS AWAY FROM CODE!

x = zeros(1, side*side+3);
y = zeros(1, side*side+3);

%Playfield;                 %Fuck you, MATLAB
%Prison;                    %Fuck you, MATLAB
Prison{1} = Empty();

Colors_Attitude = zeros(1, side*side+3);
Colors_Activism = zeros(1, side*side+3);

for i=1:1:side
    
    for j=1:1:side
        
        x((i-1)*side + j) = i;
        y((i-1)*side + j) = j;
        
        
        
        if random('Uniform',0,1,1,1) > 1/(O_to_U_Ratio+1)
        
            if random('Uniform',0,1,1,1) > 1/(C_to_A_Ratio+1)
                %Cop
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
            else
                %Agent
                H = random('Uniform',0,1,1,1);
                R = random('Uniform',0,1,1,1);
                V = floor(random('Uniform',Vision_Min_Agent,Vision_Max_Agent,1,1));
                if Better_Legitimacy
                    Leg = random('Uniform',-Legitimacy_Mod,Legitimacy_Mod,1,1);
                else
                    Leg = 0;
                end
                if random('Uniform',0,1,1,1) < Important_Chance_Agents
                    E = Important_Effectiveness_Agents;
                    V = V*Important_Effectiveness_Agents;
                else
                    E = 1;
                end
                
                Playfield{(i-1)*side + j} = Agent(H, R, V, Leg, E);
            end
        else
            Playfield{(i-1)*side + j} = Empty();
        end
    end
    
end

    
%Dirty Hack for correct Colors
x(side*side+1) = -5;
x(side*side+2) = -5;
x(side*side+3) = -5;
y(side*side+1) = -5;
y(side*side+2) = -5;
y(side*side+3) = -5;
Colors_Attitude(side*side+1) = -5;
Colors_Attitude(side*side+2) = -3;
Colors_Attitude(side*side+3) = 1;
Colors_Activism(side*side+1) = -5;
Colors_Activism(side*side+2) = -3;
Colors_Activism(side*side+3) = 1;
    %   Then, wesolve it!
    %   OY, KEEP HANDS AWAY FROM CODE!

%fig1=figure(1);
%winsize = get(fig1,'Position');
%winsize(1:2) = [0 0];

%Movie =moviein(Number_of_Frames,fig1,winsize);
%set(fig1,'NextPlot','replacechildren');

Active_Agents_Array = zeros(1, Number_of_Frames);
Inactive_Agents_Array = zeros(1, Number_of_Frames);
Active_Cops_Array = zeros(1, Number_of_Frames);
Inactive_Cops_Array = zeros(1, Number_of_Frames);
Defected_Cops_Array = zeros(1, Number_of_Frames);
Murdered_Cops_Array = zeros(1, Number_of_Frames);

Prison_Population_Array = zeros(1, Number_of_Frames);
Legitimacy_Array = zeros(1, Number_of_Frames);

g = 0;
first=true;
figurecounter=1;

for h=1:Number_of_Frames 
    
    %legitimicy-drop
    
        if (One_Time_Change && h==round_for_One_Time_Legitimacy_Change)
        L =L + One_Time_Legitimacy_Change;
        end
    
    
    %Reset Moves
    
    for j=1:1:side*side
        A = Playfield{j};
        
        if strcmp(A.Get_Type(), 'Agent') || strcmp(A.Get_Type(), 'Cop')
        
            A = A.Set_Move(true);

            Playfield{j} = A;
        
        end
    end
    
    % Release imprisoned 
    
    Prison_Population = 0;
    
    for i=2:1:length(Prison)
        
        A = Prison{i};
        
        if strcmp(A.Get_Type(), 'Agent')
        
            A = A.Set_Jailtime(A.Jailtime() - 1);

            if A.Jailtime() <= 0
                A = A.Set_Jailtime(0);
                A = A.Set_Hardship(max(0, min(1, A.Hardship + Aggreviance())));

                EmptyFields = [];

                for j=1:1:side*side
                    % Get all Empty Places
                    if strcmp(Playfield{j}.Get_Type(), 'Empty')
                        EmptyFields(length(EmptyFields)+1) = j;
                    end
                end
                
                EmptyFields = EmptyFields( randperm(length(EmptyFields)) );

                Release = select_field( EmptyFields, ImportantFields, side );
                %AllReleases(length(AllReleases)+1) = Release;
                
                Playfield{Release} = A;        %Actual Move
                Prison{i} = Empty();

            else
                
                Prison{i} = A;
                Prison_Population = Prison_Population + 1;
                
            end
        
        end
    end
   
    Prison_Population_Array(h) = Prison_Population;

    %Move Cops / Agents
    
    for i=1:1:side

        for j=1:1:side

                A = Playfield{(i-1)*side + j};
                
                if Defective_Cops && strcmp(A.Get_Type(), 'Cop') && A.Moveable() && L + A.Pers_Legitimacy < Legitimacy_Threshold_Defect
                    %Check if Cop,and if he defects now
                    H = random('Uniform',0,1,1,1);
                    R = random('Uniform',0,1,1,1);
                    A = Agent(H, R, A.Vision, A.Pers_Legitimacy, A.Effectiveness);
                    Playfield{(i-1)*side + j} =  A;
                    
                    Defected_Cops_Array(h) = Defected_Cops_Array(h)+1;
                end

                if (strcmp(A.Get_Type(), 'Agent') || strcmp(A.Get_Type(), 'Cop')) && A.Moveable()
                    
                    %Move to unoccupied space, check if active
                    
                    AgentFields = [];

                    if strcmp(A.Get_Type(), 'Cop') && (L + A.Pers_Legitimacy > Legitimacy_Threshold_Stop || Defective_Cops == false) || strcmp(A.Get_Type(), 'Agent') && A.Grievance(L) > Murder_threshold
                        %We have an active Cop, search for active Agents
                        %for Arrest
                        for k=1:1:A.Vision
                            % Get all agent Places
                            
                            if i > k && strcmp(Playfield{(i-1-k)*side + j}.Get_Type(), 'Agent') && Playfield{(i-1-k)*side + j}.Is_Active
                                AgentFields(length(AgentFields)+1) = (i-1-k)*side + j;
                            end
                            if i <= side-k && strcmp(Playfield{(i-1+k)*side + j}.Get_Type(), 'Agent') && Playfield{(i-1+k)*side + j}.Is_Active
                                AgentFields(length(AgentFields)+1) = (i-1+k)*side + j;
                            end
                            if j > k && strcmp(Playfield{(i-1)*side + j-k}.Get_Type(), 'Agent') && Playfield{(i-1)*side + j-k}.Is_Active
                                AgentFields(length(AgentFields)+1) = (i-1)*side + j-k;
                            end
                            if j <= side-k && strcmp(Playfield{(i-1)*side + j+k}.Get_Type(), 'Agent') && Playfield{(i-1)*side + j+k}.Is_Active
                                AgentFields(length(AgentFields)+1) = (i-1)*side + j+k;
                            end
                        end
                        AgentFields = AgentFields( randperm(length(AgentFields)) );
                    end
                    
                    EmptyFields = [];

                    if strcmp(A.Get_Type(), 'Agent') || (strcmp(A.Get_Type(), 'Cop') && length(AgentFields) == 0)
                        %We have an Agent or a Cop who can't find Agents to
                        %Arrest -> wander aimlessly
                        for k=1:1:A.Vision
                            % Get all Empty Places
                            if i > k && strcmp(Playfield{(i-1-k)*side + j}.Get_Type(), 'Empty')
                                EmptyFields(length(EmptyFields)+1) = (i-1-k)*side + j;
                            end
                            if i <= side-k && strcmp(Playfield{(i-1+k)*side + j}.Get_Type(), 'Empty')
                                EmptyFields(length(EmptyFields)+1) = (i-1+k)*side + j;
                            end
                            if j > k && strcmp(Playfield{(i-1)*side + j-k}.Get_Type(), 'Empty')
                                EmptyFields(length(EmptyFields)+1) = (i-1)*side + j-k;
                            end
                            if j <= side-k && strcmp(Playfield{(i-1)*side + j+k}.Get_Type(), 'Empty')
                                EmptyFields(length(EmptyFields)+1) = (i-1)*side + j+k;
                            end
                        end
                        EmptyFields = EmptyFields( randperm(length(EmptyFields)) );
                    end                
                                        
                    CopFields = [];

                    if strcmp(A.Get_Type(), 'Agent') && A.Grievance(L) > Murder_threshold
                        %We have an Agent that is ready to kill, search
                        %Assassination targets
                        for k=1:1:A.Vision
                            % Get all Empty Places
                            if i > k && strcmp(Playfield{(i-1-k)*side + j}.Get_Type(), 'Cop')
                                CopFields(length(CopFields)+1) = (i-1-k)*side + j;
                            end
                            if i <= side-k && strcmp(Playfield{(i-1+k)*side + j}.Get_Type(), 'Cop')
                                CopFields(length(CopFields)+1) = (i-1+k)*side + j;
                            end
                            if j > k && strcmp(Playfield{(i-1)*side + j-k}.Get_Type(), 'Cop')
                                CopFields(length(CopFields)+1) = (i-1)*side + j-k;
                            end
                            if j <= side-k && strcmp(Playfield{(i-1)*side + j+k}.Get_Type(), 'Cop')
                                CopFields(length(CopFields)+1) = (i-1)*side + j+k;
                            end
                        end
                    
                        CopFields = CopFields( randperm(length(CopFields)) );                    
                    end
                    
                    if strcmp(A.Get_Type(), 'Cop') && length(AgentFields) >= 1
                        %Our Cop has found some Agents to Arrest
                        if random('Uniform',0,1,1,1) < Agent_Death_Chance
                            %HE tried to arrest an Agent, but the Agent
                            %died.
                            L = L - Agent_Death_Legitimacy_Penalty;
                            Arrest = select_field(AgentFields, ImportantFields, side );

                            A = A.Set_Move(false);

                            Playfield{(i-1)*side + j} = Empty();
                            Playfield{Arrest} = A;                        %Free Cell
                        elseif random('Uniform',0,1,1,1) < Cop_Death_Chance
                            %He tried to arrest an Agent,but the Cop died.
                            L = L + Cop_Death_Legitimacy_Boost;
                            Playfield{(i-1)*side + j} = Empty();
                        else
                            %Arrest successful
                            Arrest = select_field( AgentFields, ImportantFields, side );
                            ArrestedAgent = Playfield{Arrest};
                            ArrestedAgent = ArrestedAgent.Set_Jailtime(Jailsentence());   
                            Prison{length(Prison)+1} = ArrestedAgent;           %Jail

                            A = A.Set_Move(false);

                            Playfield{(i-1)*side + j} = Empty();
                            Playfield{Arrest} = A;                        %Free Cell
                        end
                        
                        %AllCopMoves(length(AllCopMoves)+1) = Arrest;

                    elseif length(CopFields) >= 1 && A.Grievance(L) - A.Net_Risk(A.Chance_of_Arrest(k, length(CopFields), length(AgentFields)), Jailterm_Max, Better_Deterrent_of_Jailtime) > Murder_threshold && random('Uniform',0,1,1,1) < Murder_success_rate
                        %Our Agent successfully murders a Cop
                        GoTo = select_field( CopFields, ImportantFields, side );

                        A = A.Set_Move(false);

                        %AllAgentMoves(length(AllAgentMoves)+1) = GoTo;

                        Playfield{(i-1)*side + j} = Empty();
                        Playfield{GoTo} = A;        %Actual Move
                        
                        Murdered_Cops_Array(h) = Murdered_Cops_Array(h)+1;
                    elseif length(CopFields) >= 1 && random('Uniform',0,1,1,1) > Murder_success_rate && random('Uniform',0,1,1,1) < Murder_assasin_death_rate
                        %Our Agent tries to murder a Cop, but dies in the
                        %process
                        Playfield{(i-1)*side + j} = Empty();
                    elseif length(EmptyFields) >= 1
                        %Wander aimlessly
                        GoTo = select_field(EmptyFields, ImportantFields, side );
                        
                        A = A.Set_Move(false);

                        %AllAgentMoves(length(AllAgentMoves)+1) = GoTo;

                        Playfield{(i-1)*side + j} = Empty();
                        Playfield{GoTo} = A;        %Actual Move
                    end
                    
                else
                    %Empty Square, do nothing
                end
                
        end
        
    
    end
    
    % Accomplish Actions forAgents & Cops
    Active_Agents= 0;
    Inactive_Agents = 0;
    Active_Cops = 0;
    Inactive_Cops = 0;

    for i=1:1:side

        for j=1:1:side
            
            A = Playfield{(i-1)*side + j};

            if strcmp(A.Get_Type(), 'Agent')

                Cops = 0;
                Agents = 1;

                for k=1:1:A.Vision

                    if i > k && strcmp(Playfield{(i-1)*side + j - k*side}.Get_Type(), 'Agent')
                        Agents = Agents+Playfield{(i-1)*side + j - k*side}.Effectiveness;
                    elseif i > k && strcmp(Playfield{(i-1)*side + j - k*side}.Get_Type(), 'Cop')
                        Cops = Cops+Playfield{(i-1)*side + j - k*side}.Effectiveness;
                    end
                    if i <= side-k && strcmp(Playfield{(i-1)*side + j + k*side}.Get_Type(), 'Agent')
                        Agents = Agents+Playfield{(i-1)*side + j + k*side}.Effectiveness;
                    elseif i <= side-k && strcmp(Playfield{(i-1)*side + j + k*side}.Get_Type(), 'Cop')
                        Cops = Cops+Playfield{(i-1)*side + j + k*side}.Effectiveness;
                    end
                    if j > k && strcmp(Playfield{(i-1)*side + j - k}.Get_Type(), 'Agent')
                        Agents = Agents+Playfield{(i-1)*side + j - k}.Effectiveness;
                    elseif j > k && strcmp(Playfield{(i-1)*side + j - k}.Get_Type(), 'Cop')
                        Cops = Cops+Playfield{(i-1)*side + j - k}.Effectiveness;
                    end
                    if j <= side-k && strcmp(Playfield{(i-1)*side + j + k}.Get_Type(), 'Agent')
                        Agents = Agents+Playfield{(i-1)*side + j + k}.Effectiveness;
                    elseif j <= side-k && strcmp(Playfield{(i-1)*side + j + k}.Get_Type(), 'Cop')
                        Cops = Cops+Playfield{(i-1)*side + j + k}.Effectiveness;
                    end

                end

                Colors_Attitude((i-1)*side + j) = max(-1, A.Grievance(L) - A.Net_Risk(A.Chance_of_Arrest(k, Cops, Agents), Jailterm_Max, Better_Deterrent_of_Jailtime));%random('Uniform',0,1,1,1);
                if A.Grievance(L) - A.Net_Risk(A.Chance_of_Arrest(k, Cops, Agents), Jailterm_Max, Better_Deterrent_of_Jailtime) > Activism_Threshold
                    Colors_Activism((i-1)*side + j) = 1;
                    A = A.Set_Active(true);
                    Playfield{(i-1)*side + j} = A;

                    Active_Agents = Active_Agents + 1;
                else
                    Colors_Activism((i-1)*side + j) = 0;
                    
                    Inactive_Agents = Inactive_Agents + 1;
                end
                
                
            elseif strcmp(A.Get_Type(), 'Cop')
                
                Colors_Attitude((i-1)*side + j) = -5;
                Colors_Activism((i-1)*side + j) = -5;
                
                if (L + A.Pers_Legitimacy > Legitimacy_Threshold_Stop || Defective_Cops == false)
                    Active_Cops = Active_Cops + 1;
                else
                    Inactive_Cops = Inactive_Cops + 1;
                end
                
            else
                
                Colors_Attitude((i-1)*side + j) = -3;
                Colors_Activism((i-1)*side + j) = -3;
                
            end
        end
        
    end
    
    Active_Agents_Array(h) = Active_Agents;
    Inactive_Agents_Array(h) = Inactive_Agents;
    Active_Cops_Array(h) = Active_Cops;
    Inactive_Cops_Array(h) = Inactive_Cops;
    Legitimacy_Array(h) = L;
    
    L = max(0, min(1, L + Each_Round_Legitimacy_Change));
    
    %Provide Feedback
    h

    if g == 0
        
        figx=figure(figurecounter);
        figurecounter = figurecounter+1;
        axes;
        scatter(x, y, 150, Colors_Attitude, 's', 'filled');
        legend([ 'Attitude Round ', num2str(h), 10, 'Dark Blue = Cops', 10, 'Light Blue = Empty', 10, 'Red = Agents, the darker the worse the Attitude', 10,10, 'Active Agents = ', num2str(Active_Agents), 10, 'Inactive Agents = ', num2str(Inactive_Agents), 10, 'Active Cops = ', num2str(Active_Cops)] ,'Location','SouthOutside');
        axis([0 side+1 0 side+1]);

        figx=figure(figurecounter);
        figurecounter = figurecounter+1;
        axes;
        scatter(x, y, 150, Colors_Activism, 's', 'filled');
        legend([ 'Activism Round ', num2str(h), 10, 'Dark Blue = Cops', 10, 'Light Blue = Empty', 10, 'Red = Active Agents', 10, 'Light Red = Inactive Agents', 10,10, 'Active Agents = ', num2str(Active_Agents), 10, 'Inactive Agents = ', num2str(Inactive_Agents), 10, 'Active Cops = ', num2str(Active_Cops)] ,'Location','SouthOutside');
        axis([0 side+1 0 side+1]);
        %Movie(:,i)=getframe(fig1,winsize); 
        
        if h == 1 && Plot_every_X_Frames > 1
            g=Plot_every_X_Frames-1;
        else
           g=Plot_every_X_Frames;
        end
    end
    
    g=g-1;

end

figx=figure(figurecounter);
figurecounter = figurecounter+1;
plot(1:Number_of_Frames, Active_Agents_Array);
axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))]);
legend('Active Agents' ,'Location','SouthOutside');

figx=figure(figurecounter);
figurecounter = figurecounter+1;
plot(1:Number_of_Frames, Inactive_Agents_Array);
axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))]);
legend('Inactive Agents' ,'Location','SouthOutside');

figx=figure(figurecounter);
figurecounter = figurecounter+1;
plot(1:Number_of_Frames, Prison_Population_Array);
axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))]);
legend('Imprisoned Agents' ,'Location','SouthOutside');

%figx=figure(figurecounter);
%figurecounter = figurecounter+1;
%plot(1:Number_of_Frames, Active_Cops_Array);
%axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))]);
%legend('Active Cops' ,'Location','SouthOutside');

%figx=figure(figurecounter);
%figurecounter = figurecounter+1;
%plot(1:Number_of_Frames, Inactive_Cops_Array);
%axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))]);
%legend('Inactive Cops' ,'Location','SouthOutside');

%figx=figure(figurecounter);
%figurecounter = figurecounter+1;
%plot(1:Number_of_Frames, Defected_Cops_Array);
%axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))/25]);
%legend('Defected Cops' ,'Location','SouthOutside');

%figx=figure(figurecounter);
%figurecounter = figurecounter+1;
%plot(1:Number_of_Frames, Murdered_Cops_Array);
%axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))/100]);
%legend('Murdered Cops' ,'Location','SouthOutside');

figx=figure(figurecounter);
figurecounter = figurecounter+1;
plot(1:Number_of_Frames, Legitimacy_Array);
axis([1 Number_of_Frames 0 1]);
legend('Legitimacy' ,'Location','SouthOutside');


