function jacobian = numeric_jacobian(dataTable,myParams,myModelHandle)

[~,~,~,~,~,delta_eta,~] = myModelHandle(dataTable, myParams);

% populate jacobian
jacobian = zeros(size(dataTable,1),length(myParams));

for p = 1:length(myParams)
    myParamsMinus = myParams; myParamsPlus = myParams;
    % select a very small epsilon
    epsilon = max(myParams(p)*0.0001,sqrt(eps));

    % vary the p^th parameter by +/-epsilon
    myParamsMinus(p) = myParams(p)-epsilon;
    myParamsPlus(p) = myParams(p)+epsilon;

    % don't allow the sign of param to change
    if myParams(p)<0
        if myParamsPlus(p)>0
            myParamsPlus(p)=-1*eps;
        end
    else
        if myParamsMinus(p)<0
            myParamsMinus(p)=eps;
        end
    end

    % evaluate d(eta-hat)/d(epsilon)
    eta_hat_minus = get_eta_hat(dataTable, myParamsMinus, myModelHandle);
    eta_hat_plus = get_eta_hat(dataTable, myParamsPlus, myModelHandle);

    jacobian(:,p) = (eta_hat_plus - eta_hat_minus) / (myParamsPlus(p)-myParamsMinus(p)) ./ delta_eta;
end

% special case for "dummy rows" i use for data table restriction
% dummy rows are marked by eta=-1.
% if included they will result in NaN entries in jacobian
realDataRows = dataTable(:,4)~=-1;
jacobian = jacobian(realDataRows,:);

end