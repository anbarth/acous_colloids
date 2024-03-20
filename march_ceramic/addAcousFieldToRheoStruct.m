fn=fieldnames(phi44_03_19);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi44_03_19.(fn{i});
    myRheoData.acous = 0;
    phi44_03_19.(fn{i}) = myRheoData;
end