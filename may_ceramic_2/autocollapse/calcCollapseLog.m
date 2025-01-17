dataTable = may_ceramic_09_17;
%dataTable = temp_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

%play_with_CV_2_10_28;
log_y_init = log(abs(y_handpicked_10_28));
%myModelHandle = @modelLogHandpickedAll;
myModelHandle = @modelHandpickedAll;

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataTable,logParamsToParams(log_y_init,3),myModelHandle,'ShowInterpolatingFunction',true);
%return


lower_bounds = -Inf*ones(size(log_y_init));
upper_bounds = Inf*ones(size(log_y_init));

residualsfxn = @(y) get_residuals(dataTable,logParamsToParams(y,3),myModelHandle);
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
%[y_optimal_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,optsLsq);

costfxn = @(y) sum(get_residuals(dataTable,logParamsToParams(y,3),myModelHandle).^2);
optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,log_y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);
[y_optimal_fmin_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_optimal_fmin,lower_bounds,upper_bounds,optsLsq);

y_optimal_fmin_lsq = logParamsToParams(y_optimal_fmin_lsq,3);

%show_F_vs_x(dataTable,y_optimal_lsq,myModelHandle,'ShowInterpolatingFunction',true); title('lsq')
%show_F_vs_xc_x(dataTable,y_optimal_fmin,myModelHandle,'ShowInterpolatingFunction',true); title('fmin')
show_F_vs_xc_x(dataTable,y_optimal_fmin_lsq,myModelHandle,'ShowInterpolatingFunction',true); title('fmin -> lsq')


%disp(costfxn(y_optimal_lsq))
%disp(costfxn(y_optimal_fmin))
disp(sum(get_residuals(dataTable,y_optimal_fmin_lsq,myModelHandle).^2))

%y_optimal = exp(y_optimal_fmin_lsq);
%y_optimal(3) = -1*y_optimal(3); % delta < 0
