fn=fieldnames(a);
%loop through the fields
for i=1: numel(fn)
    myRheoData = a.(fn{i});
    myRheoData.acous = 0;
    a.(fn{i}) = myRheoData;
end