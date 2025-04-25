load("ness_data_02_04.mat");
dataTable = ness_data_table_exclude_low_phi;

phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


phi0 = 0.6492; % from ness_find_phi0_exclude_lower_phi

f = @(sigma,sigmastar) sigma./(sigmastar+sigma);
[eta0,sigmastar,phimu] = ness_wyart_cates_fix_phi0(dataTable,f,phi0,false);
%[eta0,sigmastar,phimu,phi0WC] = ness_wyart_cates(dataTable,f,true);

%return

% by hand
%D = [0.4 0.4 0.5 0.5 0.5 0.6 0.7 0.8 0.8 1 1 1.7 1.5 1 1];

% align elbows
%C = [1 0.9 0.85 0.8 0.7 0.6 0.55 0.5 0.5 0.4 0.35 0.35 0.35 0.3 0.3];
%C = C(6:end);
%C = [1.0000    1.0000    1.0000    1.0000    1.0000    1.0000    1.7500    2.5000    4.5000    2.5000];
%C = ones(size(phi_list'));

sigmastar = 0.03;
C = 0.5*[6.0000    5.6000    5.1000    4.6000    4.1000    3.6000    3.30    2.6000    2.6    1.05]*1/2.81;
%C(10)=1.2

D = (phi0-phimu)./(phi0-phi_list)';
D = D.*C;
%D = ones(size(phi_list'));

%[eta0, phi0, delta, A, width, sigmastar, D]
y_init = [eta0,phi0,-2,eta0,0.5,sigmastar,D];
myModelHandle = @modelNess;

% check that initial guess looks ok before continuing

show_F_vs_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',false,'ColorBy',2,'ShowLines',true,'PhiRange',1:10);
%ylim([1e-2 1e3])

show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',false,'ColorBy',2,'ShowLines',true,'PhiRange',1:10);
%ylim([1e-1 1e3])
return


figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
dphi = phi0-phi_list;
plot(dphi, D,'-o');
p = polyfit(log(dphi), log(D),1);
plot(dphi,exp(polyval(p,log(dphi))),'r-')
%plot(dphi, 0.3*dphi, 'r-')
return


lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

residualsfxn = @(y) get_residuals(dataTable,y,myModelHandle);
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
%[y_optimal_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,optsLsq);

costfxn = @(y) sum(get_residuals(dataTable,y,myModelHandle).^2);
optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);

%[y_optimal_fmin_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_optimal_fmin,lower_bounds,upper_bounds,optsLsq);

%show_F_vs_xc_x(dataTable,y_optimal_fmin,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); title('fmin')
show_F_vs_x(dataTable,y_optimal_fmin,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); title('fmin')


return
figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
% Q vs phi0-phi
dphi = y_optimal_fmin(2)-phi_list;
Q =  1./y_optimal_fmin(7:end);
plot(dphi, Q,'-o');
p = polyfit(log(dphi), log(Q),1);
%plot(log(dphi),p(1)*log(dphi)+p(2),'-r');
plot(dphi,exp(polyval(p,log(dphi))),'-r');

%x = log(dphi);
%y = log(1./y_optimal_fmin(7:end));
%plot(x,y,'o');
%p = polyfit(x,y,2);
%plot(x,polyval(p,x),'-r');