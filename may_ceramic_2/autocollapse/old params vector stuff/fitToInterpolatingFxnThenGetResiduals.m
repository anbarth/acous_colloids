function res = fitToInterpolatingFxnThenGetResiduals(dataTable,paramsVector, phi_list, volt_list)

if nargin < 4
    phi_list = unique(dataTable(:,1));
end
if nargin < 5
    volt_list = unique(dataTable(:,3));
end

% in paramsVector, [A, eta0, delta, width] should be reasonable initial guesses
% given these collapse params, fit to interpolating fxn
try
    y_fit = fitToInterpolatingFxn(dataTable,paramsVector);
    % now calculate residuals off that interpolating fxn
    res = getResiduals(dataTable,y_fit,phi_list,volt_list);
catch
    res = Inf;
end

end