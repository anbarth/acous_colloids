fn=fieldnames(phi59_05_30);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi59_05_30.(fn{i});
    myRheoData.acous = 0;
    phi59_05_30.(fn{i}) = myRheoData;
end