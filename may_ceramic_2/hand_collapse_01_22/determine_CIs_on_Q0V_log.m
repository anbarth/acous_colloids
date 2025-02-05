calcCollapse_acous_free_01_22;
paramsVector = y_optimal;

jacobian = numeric_jacobian(acoustics_free_data,paramsVector,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals?
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
confInts = sqrt(variances)*tinv(0.975,dof);
%disp([myParams', errs])

alpha = 0;
voltNum = 1;


D = paramsVector(7:end);
D_err = confInts(7:end)';

myQ = 1./D;
myQ_err = D_err ./ D.^2;

% figure; hold on;
% ylabel('D')
% xlabel('\phi')
% errorbar(phi_list,D,D_err,'o')

% figure; hold on;
% ax1=gca; ax1.XScale='log'; ax1.YScale='log';
% phi0 = paramsVector(2);
% ylabel('Q')
% xlabel('\phi_0-\phi')
% dphi = paramsVector(2)-phi_list;
% errorbar(dphi,myQ,myQ_err,'o')

figure; hold on;
ax1=gca; ax1.XScale='log'; ax1.YScale='log';
phi0 = paramsVector(2);
ylabel('D')
xlabel('\phi_0-\phi')
dphi = paramsVector(2)-phi_list;
errorbar(dphi,D,D_err,'o','LineWidth',1)

l1 = 1:6;
l2 = 10:13;
%p1 = polyfit(log(dphi(l1)),log(D(l1)),1);
%p2 = polyfit(log(dphi(l2)),log(D(l2)),1);
%plot(dphi(l1),exp(polyval(p1,log(dphi(l1)))),'k');
%plot(dphi(l2),exp(polyval(p2,log(dphi(l2)))),'k');


linearfit = fittype('poly1');
myft1 = fit(log(dphi(l1)),log(D(l1))',linearfit);
myft2 = fit(log(dphi(l2)),log(D(l2))',linearfit);
plot(dphi(l1),exp(myft1.p2)*dphi(l1).^myft1.p1,'k')
plot(dphi(l2),exp(myft2.p2)*dphi(l2).^myft2.p1,'k')

figure; hold on;
ylabel('C')
xlabel('\phi')
errorbar(phi_list,D'.*dphi.^(-myft2.p1),D_err,'o')