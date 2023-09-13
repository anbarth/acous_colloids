fn=fieldnames(phi53_09_04);
%loop through the fields
for i=1: numel(fn)
    myRheoData = phi53_09_04.(fn{i});
    myRheoData.acous = 0;
    phi53_09_04.(fn{i}) = myRheoData;
end