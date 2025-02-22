load("optimized_params_02_11.mat");
paramsVector = y_fminsearch;

jacobian = numeric_jacobian(may_ceramic_09_17,paramsVector,@modelHandpickedAllExp);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals?
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
confInts = sqrt(variances)*tinv(0.975,dof);
confInts = real(confInts);

[eta0, phi0, delta, A, width, sigmastar, D, phi_fudge] = unzipParamsHandpickedAll(paramsVector,13);
[eta0_err, phi0_err, delta_err, A_err, width_err, sigmastar_err, D_err, phi_fudge_err] = unzipParamsHandpickedAll(confInts',13);
