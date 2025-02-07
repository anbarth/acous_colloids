dataTableFull = may_ceramic_09_17;
dataTable = dataTableFull(dataTableFull(:,3)==0,:);
%dataTable = temp_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


myModelHandle = @modelWyartCatesAlpha;

f = @(sigma,sigmastar) exp(-sigmastar./sigma);
[eta0,sigmastar,phimu,phi0] = wyart_cates(dataTable,f,true);
alpha = 1;
delta = 2;
y_init = [eta0,sigmastar,phimu,phi0,alpha,delta];

% check that initial guess looks ok before continuing
%show_F_vs_x(dataTable,y_init,myModelHandle,'VoltRange',1,'ColorBy',2,'ShowLines',true,'ShowInterpolatingFunction',true);
%show_F_vs_xc_x(dataTable,y_init,myModelHandle,'VoltRange',1,'ColorBy',2,'ShowLines',true,'ShowInterpolatingFunction',true);
%return


lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));



residualsfxn = @(y) get_residuals(dataTable,y,myModelHandle);
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[y_optimal_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,optsLsq);

costfxn = @(y) sum(get_residuals(dataTable,y,myModelHandle).^2);
optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
[y_optimal_fmin_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_optimal_fmin,lower_bounds,upper_bounds,optsLsq);

show_F_vs_xc_x(dataTable,y_optimal_lsq,myModelHandle,'VoltRange',1,'ColorBy',2,'ShowLines',true,'ShowInterpolatingFunction',true,'ShowErrorBars',true); title('lsq')
show_F_vs_xc_x(dataTable,y_optimal_fmin,myModelHandle,'VoltRange',1,'ColorBy',2,'ShowLines',true,'ShowInterpolatingFunction',true,'ShowErrorBars',true); title('fmin')
show_F_vs_xc_x(dataTable,y_optimal_fmin_lsq,myModelHandle,'VoltRange',1,'ColorBy',2,'ShowLines',true,'ShowInterpolatingFunction',true,'ShowErrorBars',true); title('fmin -> lsq')


disp(costfxn(y_init))
disp(costfxn(y_optimal_lsq))
disp(costfxn(y_optimal_fmin))
disp(costfxn(y_optimal_fmin_lsq))