dataTable = ness_data_table;
%dataTable = temp_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

[eta0,sigmastar,phimu,phi0] = ness_wyart_cates(ness_data_table,false);
ness_find_phi_fudge; % populates phi_fudge
%phi_fudge = zeros(15,1);

phi_eff_list = phi_list+phi_fudge;

% align elbows
C = 0.55*[1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.85 1.9 2 1.7 1 1];
%C = ones(size(phi_eff_list'));
D = (phi0-phimu)./(phi0-phi_eff_list)';
D = D.*C;

%[eta0, phi0, delta, A, width, sigmastar, D]
y_init = [eta0,phi0,-2.5,eta0,1,sigmastar,D,phi_fudge'];
myModelHandle = @modelNessFudge;


%y_init(end) = 0.005;
% check that initial guess looks ok before continuing
show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',false,'ColorBy',2,'ShowLines',true,'PhiRange',15:-1:1);
show_F_vs_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',false,'ColorBy',2,'ShowLines',true,'PhiRange',15:-1:1);
return


lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));
lower_bounds(end-14:end) = y_init(end-14:end);
upper_bounds(end-14:end) = y_init(end-14:end);

residualsfxn = @(y) get_residuals(dataTable,y,myModelHandle);
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
%[y_optimal_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,optsLsq);

%costfxn = @(y) sum(get_residuals(dataTable,y,myModelHandle).^2);
costfxn = @(y) sum(log(abs(get_residuals(dataTable,y,myModelHandle))));
optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);

%[y_optimal_fmin_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_optimal_fmin,lower_bounds,upper_bounds,optsLsq);

show_F_vs_xc_x(dataTable,y_optimal_fmin,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); title('fmin')
show_F_vs_x(dataTable,y_optimal_fmin,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2,'ShowLines',true); title('fmin')

%disp(costfxn(y_optimal_lsq))
disp(costfxn(y_optimal_fmin))
%disp(costfxn(y_optimal_fmin_lsq))

figure; hold on; ax1=gca; ax1.XScale='log'; ax1.YScale='log';
% Q vs phi0-phi
%myY = y_optimal_fmin;
myY = y_init;
dphi = myY(2)-phi_eff_list;
Q = 1./myY(7:7+14);
plot(dphi, Q,'-o');
p = polyfit(log(dphi), log(Q),1);
%plot(log(dphi),p(1)*log(dphi)+p(2),'-r');
plot(dphi,exp(polyval(p,log(dphi))),'-r');

%x = log(dphi);
%y = log(1./y_optimal_fmin(7:end));
%plot(x,y,'o');
%p = polyfit(x,y,2);
%plot(x,polyval(p,x),'-r');