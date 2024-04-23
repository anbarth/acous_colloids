fn=fieldnames(phi59p5_04_16);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi59p5_04_16.(fn{i});
    myRheoData.acous = 0;
    phi59p5_04_16.(fn{i}) = myRheoData;
end