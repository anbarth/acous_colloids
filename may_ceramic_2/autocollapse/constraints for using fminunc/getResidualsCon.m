function residuals = getResidualsCon(stressTable, paramsVectorRestricted, constraints, phi_list, volt_list)

if nargin < 4
    phi_list = unique(stressTable(:,1));
end
if nargin < 5
    volt_list = unique(stressTable(:,3));
end

paramsVector = mergeParamsAndConstraints(paramsVectorRestricted,constraints);

residuals = getResiduals(stressTable,paramsVector,phi_list,volt_list);

end