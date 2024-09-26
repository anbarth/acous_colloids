load("y_09_19_ratio_with_and_without_Cv.mat")
load("hessian_Cv.mat")
dataTable = may_ceramic_09_17;
y_optimal = y_Cv;
hessian = hessian_Cv;

P = 116 - 13 - 5*6 - 2;
N = size(dataTable,1);
dof = N-P;

SSR = sum(getResiduals(dataTable,y_optimal).^2);
variance_matrix = inv(hessian)*SSR/dof;
y_uncert = sqrt(diag(variance_matrix));

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);
[eta0_err, phi0_err, delta_err, A_err, width_err, sigmastar_err, C_err, phi_fudge_err] = unzipParams(y_uncert,13);