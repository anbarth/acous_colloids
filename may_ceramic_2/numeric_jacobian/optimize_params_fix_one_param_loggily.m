function y_optimal = optimize_params_fix_one_param_loggily(dataTable,myModelHandle,y_init,paramNum)

log_y_init = log(abs(y_init));

myLogParam = log_y_init(paramNum);

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));
lower_bounds(paramNum) = myLogParam;
upper_bounds(paramNum) = myLogParam;


costfxn = @(log_y)  sum(get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle).^2);
optsFmin = optimoptions('fmincon','Display','none','MaxFunctionEvaluations',3e5);
log_y_optimal = fmincon(costfxn,log_y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
y_optimal = logParamsToParams(log_y_optimal,3);

%residualsfxn = @(log_y) get_residuals(dataTable,logParamsToParams(log_y,3),myModelHandle);
%optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','none');
%y_optimal  = lsqnonlin(residualsfxn,y_optimal_fmin,lower_bounds,upper_bounds,optsLsq);

end