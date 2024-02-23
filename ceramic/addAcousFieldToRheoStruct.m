fn=fieldnames(phi59_02_22);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi59_02_22.(fn{i});
    myRheoData.acous = 0;
    phi59_02_22.(fn{i}) = myRheoData;
end