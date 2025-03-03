determine_CIs_on_D0V_02_11;
y_init = yLogistic0V;
log_y_init = log(abs(y_init));
myModelHandle = @modelLogisticCExp0V;

acoustics_free_data = dataTable(dataTable(:,3)==0,:);

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2);
%show_F_vs_x(acoustics_free_data,y_init,myModelHandle,'ShowInterpolatingFunction',true,'ColorBy',2);
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

%costfxn = @(y)  sum(get_residuals(acoustics_free_data,y,myModelHandle).^2);
residualsfxn = @(log_y) get_residuals(acoustics_free_data,logParamsToParams(log_y,3),myModelHandle);
costfxn = @(log_y)  sum(get_residuals(acoustics_free_data,logParamsToParams(log_y,3),myModelHandle).^2);

%optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
%[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
optsFminsearch = optimset('MaxFunEvals',3e6,'MaxIter',3e6);
log_y_smooth_fminsearch_0V = fminsearch(costfxn,log_y_init,optsFminsearch);
y_smooth_fminsearch_0V = logParamsToParams(log_y_smooth_fminsearch_0V,3);

optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_smooth_lsq_0V,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log_y_init,lower_bounds,upper_bounds,optsLsq);
y_lsq_smooth_0V = logParamsToParams(log_y_smooth_lsq_0V,3);


return

phiRange = 13:-1:1;
show_F_vs_x(dataTable,y_lsq_smooth_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
show_F_vs_xc_x(dataTable,y_lsq_smooth_0V,myModelHandle,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)