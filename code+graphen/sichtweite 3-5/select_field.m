function field = select_field( fields, important_places, side )
% SelectField Summary of this function goes here
%   Detailed explanation goes here

    %field = fields( round(random('Uniform',0.5,length(fields)+0.499,1,1)) );
    maxfield = 0;
    maximportance = 0;
    
    for i=1:length(fields)
        
        i_y = ceil(fields(i)/side);
        i_x = fields(i) - ((i_y-1) * side);
        
        for j=1:length(important_places)
            j_y = ceil(important_places{j}.ID/side);
            j_x = important_places{j}.ID - ((j_y-1) * side);
            
            importance = 1/sqrt((i_y - j_y)^2 + (i_x - j_x)^2 + 1) * important_places{j}.Importance;
            
            if (importance >= maximportance)
                maximportance = importance;
                maxfield = i;
            end
        end
    end
    
    field = fields(maxfield);

end

