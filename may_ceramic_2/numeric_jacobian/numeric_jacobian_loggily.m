function jacobian = numeric_jacobian_loggily(dataTable,myParams,myModelHandle, varargin)

myLogParams = log(abs(myParams));

[~,~,~,~,~,delta_eta,~] = myModelHandle(dataTable, myParams);

% populate jacobian
jacobian = zeros(size(dataTable,1),length(myParams));

for p = 1:length(myParams)
    myLogParamsMinus = myLogParams; myLogParamsPlus = myLogParams;
    % select a very small epsilon
    epsilon = max(myLogParams(p)*0.0001,sqrt(eps));

    % vary the p^th parameter by +/-epsilon
    myLogParamsMinus(p) = myLogParams(p)-epsilon;
    myLogParamsPlus(p) = myLogParams(p)+epsilon;

    % don't allow the sign of param to change
    if myLogParams(p)<0
        if myLogParamsPlus(p)>0
            myLogParamsPlus(p)=-1*sqrt(eps);
        end
    else
        if myLogParamsMinus(p)<0
            myLogParamsMinus(p)=sqrt(eps);
        end
    end

    % evaluate d(eta-hat)/d(epsilon)
    eta_hat_minus = get_eta_hat(dataTable, logParamsToParams(myLogParamsMinus,varargin{:}), myModelHandle);
    eta_hat_plus = get_eta_hat(dataTable, logParamsToParams(myLogParamsPlus,varargin{:}), myModelHandle);

    jacobian(:,p) = 1/myParams(p) * (eta_hat_plus - eta_hat_minus) / (myLogParamsPlus(p)-myLogParamsMinus(p)) ./ delta_eta;
    %jacobian(:,p) = (eta_hat_plus - eta_hat_minus) / (myLogParamsPlus(p)-myLogParamsMinus(p)) ./ delta_eta;
end

% special case for "dummy rows" i use for data table restriction
% dummy rows are marked by eta=-1.
% if included they will result in NaN entries in jacobian
realDataRows = dataTable(:,4)~=-1;
jacobian = jacobian(realDataRows,:);

end