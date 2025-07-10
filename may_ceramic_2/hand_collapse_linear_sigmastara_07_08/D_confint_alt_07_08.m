%optimize_C_jardy_03_19;
y = y_lsq_0V;

D = y(7:end);
logD = log(D);

D_indices = {6,7,8,9,10,11,12,13,14,15,16,17,18,19};
jacobian = numeric_jacobian_logsome(acoustics_free_data,y,myModelHandle,D_indices{:});
hessian = transpose(jacobian)*jacobian;
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
ci = sqrt(variances)*tinv(0.975,dof);

logD_ci = ci(7:end)';
logD_lower = logD-logD_ci;
logD_upper = logD+logD_ci;

D_lower = exp(logD_lower);
D_upper = exp(logD_upper);

figure; hold on;
plot(phi_list,D,'ok');
plot(phi_list,D_lower,'ro')
plot(phi_list,D_upper,'ro')
ylim([-0.2 1.2])