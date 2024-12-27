dataTable = may_ceramic_09_17;
myModelHandle = @modelHandpickedAll;
myParams = y_optimal_fmin_lsq;

[~,~,~,~,~,delta_eta,~] = myModelHandle(dataTable, myParams);

jacobian = zeros(size(dataTable,1),length(myParams));
for p = 1:length(myParams)
    myParamsMinus = myParams; myParamsPlus = myParams;
    %epsilon = eps;
    epsilon = max(myParams(p)*0.0001,eps);
    myParamsMinus(p) = myParams(p)-epsilon;
    myParamsPlus(p) = myParams(p)+epsilon;
    eta_hat_minus = get_eta_hat(dataTable, myParamsMinus, myModelHandle);
    eta_hat_plus = get_eta_hat(dataTable, myParamsPlus, myModelHandle);
    
    jacobian(:,p) = (eta_hat_plus - eta_hat_minus) / (2*epsilon) ./ delta_eta;
end

hessian = transpose(jacobian)*jacobian;
[vecs,vals_matrix] = eig(hessian); 
vals = diag(vals_matrix);
figure; hold on; ax1=gca;ax1.YScale='log';
plot(vals,'o')
%disp(vals(vals<=0))
%return
% compute confidence intervals?

variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
errs = sqrt(variances)*tinv(0.975,dof);
disp([myParams', errs])

return
figure; hold on;
ax1=gca;ax1.YScale='log';
%for ii=1:size(vecs,2)
for ii=14
    plot(abs(vecs(:,ii)),'-o')
end
legend;