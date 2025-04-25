load("ness_data_02_15.mat")
dataTable = ness_data_table_exclude_low_phi;
dataBelowSJ = dataTable(dataTable(:,4)<1e6,:);

phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


phi0 = 0.6482; % from ness_find_phi0_exclude_lower_phi

f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar,phimu] = ness_wyart_cates_fix_phi0(dataTable,f,phi0,false);
%[eta0,sigmastar,phimu,phi0WC] = ness_wyart_cates(dataTable,true);

%return

C = ones(1,length(phi_list));

%sigmastar = 0.03;
%C = 0.5*[6.0000    5.6000    5.1000    4.6000    4.1000    3.6000    3.30    2.6000    2.6    1.05];
%C(10)=1.2

D = (phi0-phimu)./(phi0-phi_list)';
D = D.*C;
D = D/1.2; % to ensure all data fall below x=1
%D = ones(size(phi_list'));

%[eta0, phi0, delta, A, width, sigmastar, D]
y_init = [eta0,phi0,-3,eta0,0.5,sigmastar,D];
myModelHandle = @modelNessExp;

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataBelowSJ,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true,'PhiRange',1:10);
%ylim([1e-1 1e3])

%show_F_vs_x(dataBelowSJ,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true,'PhiRange',10:-1:1);
%xlim([1e-10 1.5])
%return


% figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
% dphi = phi0-phi_list;
% plot(dphi, D,'-o');
% p = polyfit(log(dphi), log(D),1);
% plot(dphi,exp(polyval(p,log(dphi))),'r-')
% %plot(dphi, 0.3*dphi, 'r-')
% return


lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

residualsfxn = @(y) get_residuals(dataBelowSJ,y,myModelHandle);
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
%[y_optimal_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,optsLsq);

costfxn = @(y) sum(get_residuals(dataBelowSJ,y,myModelHandle).^2);
optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);

%[y_optimal_fmin_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_optimal_fmin,lower_bounds,upper_bounds,optsLsq);

show_F_vs_xc_x(dataTable,y_optimal_fmin,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); title('fmin')
show_F_vs_x(dataTable,y_optimal_fmin,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); title('fmin')
xlim([1e-10 1.5])

return
figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
% D vs phi0-phi
dphi = y_optimal_fmin(2)-phi_list;
D =  y_optimal_fmin(7:end);
plot(dphi, D,'-o');
p = polyfit(log(dphi), log(D),1);
%plot(log(dphi),p(1)*log(dphi)+p(2),'-r');
plot(dphi,exp(polyval(p,log(dphi))),'-r');

%x = log(dphi);
%y = log(1./y_optimal_fmin(7:end));
%plot(x,y,'o');
%p = polyfit(x,y,2);
%plot(x,polyval(p,x),'-r');