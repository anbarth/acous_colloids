function y_optimal = optimize_params_fix_one_param(dataTable,myModelHandle,y_init,paramNum)

myParam = y_init(paramNum);

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));
lower_bounds(paramNum) = myParam;
upper_bounds(paramNum) = myParam;


costfxn = @(y) sum(get_residuals(dataTable,y,myModelHandle).^2);
optsFmin = optimoptions('fmincon','Display','none','MaxFunctionEvaluations',3e5);
y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);

%residualsfxn = @(y) get_residuals(dataTable,y,myModelHandle);
%optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','none');
%y_optimal  = lsqnonlin(residualsfxn,y_optimal_fmin,lower_bounds,upper_bounds,optsLsq);

end