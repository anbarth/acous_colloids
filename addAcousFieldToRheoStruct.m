fn=fieldnames(equiv_states_06_25);
%loop through the fields
for i=1: numel(fn)
    myRheoData = equiv_states_06_25.(fn{i});
    myRheoData.acous = 0;
    equiv_states_06_25.(fn{i}) = myRheoData;
end