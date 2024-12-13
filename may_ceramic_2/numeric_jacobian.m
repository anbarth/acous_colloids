dataTable = may_ceramic_09_17;
myModelHandle = @modelHandpickedAll;
myParams = y_optimal_lsq;

[~,~,~,~,~,delta_eta,~] = myModelHandle(dataTable, myParams);

jacobian = zeros(size(dataTable,1),length(myParams));
for p = 1:length(myParams)
    myParamsMinus = myParams; myParamsPlus = myParams;
    epsilon = myParams(p)*0.001;
    myParamsMinus(p) = myParams(p)-epsilon;
    myParamsPlus(p) = myParams(p)+epsilon;
    eta_hat_minus = get_eta_hat(dataTable, myParamsMinus, myModelHandle);
    eta_hat_plus = get_eta_hat(dataTable, myParamsPlus, myModelHandle);
    
    jacobian(:,p) = (eta_hat_plus - eta_hat_minus) / (2*epsilon) ./ delta_eta;
end

hessian = transpose(jacobian)*jacobian;
[vecs,vals_matrix] = eig(hessian); 
vals = diag(vals_matrix);