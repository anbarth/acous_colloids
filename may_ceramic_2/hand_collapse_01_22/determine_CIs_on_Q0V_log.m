calcCollapse_acous_free_01_22;

jacobian = numeric_jacobian(acoustics_free_data,y_optimal,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals?
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
confInts = sqrt(variances)*tinv(0.975,dof);
%disp([myParams', errs])

alpha = 0;
voltNum = 1;


D = y_optimal(7:end);
D_err = confInts(7:end);

myQ = 1./D;
myQ_err = D_err ./ D.^2;

figure; hold on;
ylabel('D')
xlabel('\phi')
errorbar(myPhi,myD,myD_err,'o')

figure; hold on;
ax1=gca; ax1.XScale='log'; ax1.YScale='log';
phi0 = y_optimal(2);
ylabel('Q')
xlabel('\phi_0-\phi')
%ylim([0 50])
errorbar(myPhi,myQ,myQ_err,'o')
plot(myPhi,myQ,'o');

