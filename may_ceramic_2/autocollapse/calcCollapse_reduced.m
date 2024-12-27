dataTable = may_ceramic_09_17;

y_init = y_red_handpicked;
myModelHandle = @modelSmoothFunctions;

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',true);
%return

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

residualsfxn = @(y) get_residuals(dataTable,y,myModelHandle);
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
%[y_optimal_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,optsLsq);

costfxn = @(y) sum(get_residuals(dataTable,y,myModelHandle).^2);
optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
[y_optimal_fmin_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_optimal_fmin,lower_bounds,upper_bounds,optsLsq);

%show_F_vs_x(dataTable,y_optimal_lsq,myModelHandle,'ShowInterpolatingFunction',true); title('lsq')
%show_F_vs_xc_x(dataTable,y_optimal_fmin,myModelHandle,'ShowInterpolatingFunction',true); title('fmin')
show_F_vs_xc_x(dataTable,y_optimal_fmin_lsq,myModelHandle,'ShowInterpolatingFunction',true); title('fmin -> lsq')


%disp(costfxn(y_optimal_lsq))
%disp(costfxn(y_optimal_fmin))
disp(costfxn(y_optimal_fmin_lsq))