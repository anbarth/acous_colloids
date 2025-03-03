optimize_C_jardy_02_11
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

figure; hold on;
ax1=gca; ax1.XScale='log'; ax1.YScale='log';
phi0 = paramsVector(2);
ylabel('D')
xlabel('\phi_0-\phi')
dphi = paramsVector(2)-phi_list;
errorbar(dphi,D,D_err,'o','LineWidth',1)
%return
l1 = 1:6;
l2 = 10:13;

linearfit = fittype('poly1');
%myft1 = fit(log(dphi(l1)),log(D(l1))',linearfit);
myft2 = fit(log(dphi(l2)),log(D(l2))',linearfit);
%plot(dphi(l1),exp(myft1.p2)*dphi(l1).^myft1.p1,'k')
plot(dphi(l2),exp(myft2.p2)*dphi(l2).^myft2.p1,'k')
%close;
disp(myft2)
alpha = -myft2.p1;

C = D'.*dphi.^alpha;
figure; hold on;
ylabel('C')
xlabel('\phi')
errorbar(phi_list,C,D_err,'o')

logisticFit = fittype("L/(1+exp(-k*(x-x0)))");
cFit = fit(phi_list,C,logisticFit,'StartPoint',[0.95, 50, 0.4],'Weights',1./D_err);

logistic = @(L,k,x0,x) L./(1+exp(-k*(x-x0)));
plot(phi_list,logistic(cFit.L,cFit.k,cFit.x0,phi_list));

%yLogistic0V = [paramsVector(1:6) alpha cFit.L cFit.k cFit.x0];
yLogistic0V = [paramsVector(1:6) alpha cFit.L*0.999 cFit.k cFit.x0];

%show_F_vs_xc_x(acoustics_free_data,yLogistic0V,@modelLogisticCExp0V,'ColorBy',2,'ShowLines',true,'ShowErrorBars',true)