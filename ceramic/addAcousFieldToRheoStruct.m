fn=fieldnames(phi48_02_20);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi48_02_20.(fn{i});
    myRheoData.acous = 0;
    phi48_02_20.(fn{i}) = myRheoData;
end