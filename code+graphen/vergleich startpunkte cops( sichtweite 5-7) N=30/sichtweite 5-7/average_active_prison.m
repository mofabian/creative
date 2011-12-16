
side=40;
O_to_U_Ratio = 0.7;     

% Number of iterations or average
N=15;
Number_of_Frames=60;
% number of active agents for every iteration
active_agents_all_random = zeros(N,Number_of_Frames);
active_agents_all_centre=zeros(N,Number_of_Frames);
%number of imprisoned agents for every iteration
imprisoned_agents_all_random =zeros(N,Number_of_Frames);
imprisoned_agents_all_centre =zeros(N,Number_of_Frames);
for k=1:1:N
    
    [active_agents_all_random(k,:),imprisoned_agents_all_random(k,:)]=displayrandom;
    [active_agents_all_centre(k,:),imprisoned_agents_all_centre(k,:)]=displaycentre;

end




average_active_agents_random=mean(active_agents_all_random);
stab_active_agents_random=sqrt(var(active_agents_all_random));


average_Prison_Population_random=mean(imprisoned_agents_all_random);
stab_Prison_Population_random=sqrt(var(imprisoned_agents_all_random));



average_active_agents_centre=mean(active_agents_all_centre);
stab_active_agents_centre=sqrt(var(active_agents_all_centre));

average_Prison_Population_centre=mean(imprisoned_agents_all_centre);
stab_Prison_Population_centre=sqrt(var(imprisoned_agents_all_centre));


figure
plot(1:Number_of_Frames, average_active_agents_random,1:Number_of_Frames, average_active_agents_random-stab_active_agents_random,1:Number_of_Frames, average_active_agents_random+stab_active_agents_random);
axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))]);
legend('Average Number of Active Agents (random)' ,'Location','SouthOutside');


figure
plot(1:Number_of_Frames, average_Prison_Population_random,1:Number_of_Frames, average_Prison_Population_random-stab_Prison_Population_random,1:Number_of_Frames, average_Prison_Population_random+stab_Prison_Population_random);
axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))]);
legend('Average Number of Imprisoned Agents (random)' ,'Location','SouthOutside');



figure
plot(1:Number_of_Frames, average_active_agents_centre,1:Number_of_Frames, average_active_agents_centre-stab_active_agents_centre,1:Number_of_Frames, average_active_agents_centre+stab_active_agents_centre);
axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))]);
legend('Average Number of Active Agents (centre)' ,'Location','SouthOutside');


figure
plot(1:Number_of_Frames, average_Prison_Population_centre,1:Number_of_Frames, average_Prison_Population_centre-stab_Prison_Population_centre,1:Number_of_Frames, average_Prison_Population_centre+stab_Prison_Population_centre);
axis([1 Number_of_Frames 0 side^2*(1-1/(O_to_U_Ratio+1))]);
legend('Average Number of Imprisoned Agents (centre)' ,'Location','SouthOutside');