function jacobian = numeric_jacobian_exp(dataTable,myParams,myModelHandle, varargin)

myExpParams = exp(myParams);

[~,~,~,~,~,delta_eta,~] = myModelHandle(dataTable, myParams);

% populate jacobian
jacobian = zeros(size(dataTable,1),length(myParams));

for p = 1:length(myParams)
    myExpParamsMinus = myExpParams; myExpParamsPlus = myExpParams;
    % select a very small epsilon
    epsilon = max(myExpParams(p)*0.0001,sqrt(eps));

    % vary the p^th parameter by +/-epsilon
    myExpParamsMinus(p) = myExpParams(p)-epsilon;
    myExpParamsPlus(p) = myExpParams(p)+epsilon;

    % don't allow the sign of param to change
    if myExpParams(p)<0
        if myExpParamsPlus(p)>0
            myExpParamsPlus(p)=-1*sqrt(eps);
        end
    else
        if myExpParamsMinus(p)<0
            myExpParamsMinus(p)=sqrt(eps);
        end
    end

    % evaluate d(eta-hat)/d(epsilon)
    eta_hat_minus = get_eta_hat(dataTable, logParamsToParams(myExpParamsMinus,varargin{:}), myModelHandle);
    eta_hat_plus = get_eta_hat(dataTable, logParamsToParams(myExpParamsPlus,varargin{:}), myModelHandle);

    jacobian(:,p) = (eta_hat_plus - eta_hat_minus) / (myExpParamsPlus(p)-myExpParamsMinus(p)) ./ delta_eta;
end

% special case for "dummy rows" i use for data table restriction
% dummy rows are marked by eta=-1.
% if included they will result in NaN entries in jacobian
realDataRows = dataTable(:,4)~=-1;
jacobian = jacobian(realDataRows,:);

end