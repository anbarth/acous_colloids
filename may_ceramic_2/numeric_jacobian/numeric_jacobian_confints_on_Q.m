dataTable = may_ceramic_09_17;
load("01_12_optimal_params.mat")
myModelHandle = @modelHandpickedAll; myParams = y_full_fmin_lsq;
%myModelHandle = @modelHandpickedAll; myParams = y_optimal;

jacobian = numeric_jacobian(dataTable,myParams,myModelHandle);
hessian = transpose(jacobian)*jacobian;

% compute confidence intervals?
variances = diag(pinv(hessian));
dof = size(jacobian,1)-size(jacobian,2); % dof = N-P
confInts = sqrt(variances)*tinv(0.975,dof);
%disp([myParams', errs])


alpha = 0;
voltNum = 1;

[eta0, phi0, delta, A, width, sigmastar, D, phi_fudge] = unzipParamsHandpickedAll(myParams,13);
[eta0_err, phi0_err, delta_err, A_err, width_err, sigmastar_err, D_err, phi_fudge_err] = unzipParamsHandpickedAll(confInts',13);

phi_list = unique(dataTable(:,1));
volt_list = [0,5,10,20,40,60,80];

figure;
hold on;
%ylabel(strcat('C_',num2str(alpha)))
ylabel('D')
xlabel('\phi')


myD = D(:,voltNum);
myD_err = D_err(:,voltNum);
myPhi = phi_list+phi_fudge';


myPhi = myPhi(myD ~= 0);
myD_err = myD_err(myD~=0);
myD = myD(myD~=0);


%myD = myD .* (phi0-myPhi).^alpha;
%myD_err = myD_err .* (phi0-myPhi).^alpha;

myQ = 1./myD;
myQ_err = myD_err ./ myD.^2;

ax1=gca; ax1.XScale='log'; ax1.YScale='log';
dphi = phi0-myPhi;
errorbar(dphi,myD,myD_err,'o','LineWidth',1)

%ylim([0 50])
%errorbar(myPhi,myQ,myQ_err,'o')
%plot(myPhi,myQ,'o');

l1=10:13;
linearfit = fittype('poly1');
myft1 = fit(log(dphi(l1)),log(D(l1))',linearfit);
plot(dphi(l1),exp(myft1.p2)*dphi(l1).^myft1.p1,'k')
