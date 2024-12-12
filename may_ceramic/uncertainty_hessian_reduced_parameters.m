dataTable = may_ceramic_09_17;
%load("y_09_19_ratio_with_and_without_Cv.mat")
%load("hessian_Cv.mat")
%y_optimal = y_Cv;
%hessian = hessian_Cv;

P = 13;
N = size(dataTable,1);
dof = N-P;

SSR = sum(getResidualsReduced(dataTable,yReduced_optimal).^2);
covariance_matrix = inv(hessian);
y_uncert = sqrt(diag(covariance_matrix))*tinv(0.975,dof);
%y_uncert = mergeParamsAndConstraints(y_uncert_restricted,constraints);
%y_uncert = sqrt(diag(covariance_matrix))*tinv(0.975,dof);

[eta0, phi0, delta, A, width, sigmastarParams,  b, phistarParams, Cphi0params] = unzipReducedParams(yReduced_optimal);
[eta0_err, phi0_err, delta_err, A_err, width_err, sigmastarParams_err,  b_err, phistarParams_err, Cphi0params_err] = unzipReducedParams(y_uncert);