%optimize_C_jardy_02_11
paramsVector = y_lsq_0V;

jacobian = numeric_jacobian(acoustics_free_data,paramsVector,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals?
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
confInts = real(sqrt(variances)*tinv(0.975,dof));
%disp([myParams', errs])

alpha = 0;
voltNum = 1;


D = paramsVector(7:end);
D_err = confInts(7:end)';

loggy_thing = D' ./ (1+log(dphi));

figure; hold on;
ax1=gca; ax1.XScale='log'; %ax1.YScale='log';
phi0 = paramsVector(2);
ylabel('D')
xlabel('\phi')
dphi = paramsVector(2)-phi_list;
plot(dphi,D,'-o')
