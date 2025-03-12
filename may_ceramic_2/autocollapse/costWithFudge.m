function cost = costWithFudge(stressTable, paramsVector, modelHandle)

res = get_residuals(stressTable, paramsVector, modelHandle);
res_cost = sum(res.^2);

phi_list = unique(stressTable(:,1));
numPhi = length(phi_list);
phi_fudge = paramsVector(end-numPhi+1:end)';
fudge_cost = sum((phi_fudge/0.01).^2);

cost = res_cost+fudge_cost;

end