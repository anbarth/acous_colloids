function jacobian = numeric_jacobian(dataTable,myParams,myModelHandle)



[~,~,~,~,~,delta_eta,~] = myModelHandle(dataTable, myParams);

% populate jacobian
jacobian = zeros(size(dataTable,1),length(myParams));
for p = 1:length(myParams)
    myParamsMinus = myParams; myParamsPlus = myParams;
    % select a very small epsilon
    epsilon = max(myParams(p)*0.0001,eps);

    % vary the p^th parameter by +/-epsilon
    myParamsMinus(p) = myParams(p)-epsilon;
    myParamsPlus(p) = myParams(p)+epsilon;

    % evaluate d(eta-hat)/d(epsilon)
    eta_hat_minus = get_eta_hat(dataTable, myParamsMinus, myModelHandle);
    eta_hat_plus = get_eta_hat(dataTable, myParamsPlus, myModelHandle);
    
    jacobian(:,p) = (eta_hat_plus - eta_hat_minus) / (2*epsilon) ./ delta_eta;
end

end