[eta0,sigmastar,phimu,phi0] = wyart_cates(may_ceramic_09_17,false);
myParams = [eta0,sigmastar,phimu,phi0];
acoustics_free_data = may_ceramic_09_17(may_ceramic_09_17(:,3)==0,:);
jacobian = numeric_jacobian(acoustics_free_data,myParams,@modelWyartCates);

hessian = transpose(jacobian)*jacobian;

% compute confidence intervals?
variances = diag(pinv(hessian));
%variances = diag(hessian);
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
errs = sqrt(variances)*tinv(0.975,dof);
disp([myParams', errs])