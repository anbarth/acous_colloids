function res = fitToInterpolatingFxnThenGetResidualsCon(dataTable,paramsVectorRestricted, constraints, phi_list, volt_list)

if nargin < 4
    phi_list = unique(dataTable(:,1));
end
if nargin < 5
    volt_list = unique(dataTable(:,3));
end

% sew together free+constrained collapse params
% in this y vector, [A, eta0, delta, width] should be reasonable initial guesses
paramsVectorTotal = mergeParamsAndConstraints(paramsVectorRestricted,constraints);

% now calculate residuals off that interpolating fxn
res = fitToInterpolatingFxnThenGetResiduals(dataTable,paramsVectorTotal, phi_list, volt_list);

end