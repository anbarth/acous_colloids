fn=fieldnames(metamaterial_phi59_02_27);
%loop through the fields
for i=1: numel(fn)
    myRheoData = metamaterial_phi59_02_27.(fn{i});
    myRheoData.acous = 0;
    metamaterial_phi59_02_27.(fn{i}) = myRheoData;
end