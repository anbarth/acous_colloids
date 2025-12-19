function [Q,Q_table] = getQuantityTable(myResultsStructs,quantity)

% each sim gets a column
firstColumn = myResultsStructs{1}.(quantity);
Q_table = zeros(length(firstColumn),length(myResultsStructs));

for ii=1:length(myResultsStructs)
    % fill in energy table
    myExperiment = myResultsStructs{ii};
    
    myColumn = myExperiment.(quantity);


    if length(myColumn)~=length(firstColumn) 
        Q_table(:,ii) = NaN;
    else
        Q_table(:,ii) = myColumn;
    end
end

%Q = mean(Q_table,2);
Q_table_geomean = Q_table;
Q_table_geomean(Q_table_geomean<0)=NaN;
Q = geomean(Q_table_geomean,2,"omitnan");

end