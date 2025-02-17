function y_optimal = optimize_params_fix_one_param_0V_02_11(acoustics_free_data,myModelHandle,y_init,paramNum)

myParam = y_init(paramNum);

lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));
lower_bounds(paramNum) = log(abs(myParam));
upper_bounds(paramNum) = log(abs(myParam));

residualsfxn = @(log_y) get_residuals(acoustics_free_data,logParamsToParams(log_y,3),myModelHandle);
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[log_y_optimal,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,log(abs(y_init)),lower_bounds,upper_bounds,optsLsq);
y_optimal = logParamsToParams(log_y_optimal,3);

end