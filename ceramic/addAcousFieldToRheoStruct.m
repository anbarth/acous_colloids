fn=fieldnames(phi52_02_23);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi52_02_23.(fn{i});
    myRheoData.acous = 0;
    phi52_02_23.(fn{i}) = myRheoData;
end