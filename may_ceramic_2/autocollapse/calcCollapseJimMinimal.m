dataTable = may_ceramic_09_17;
%dataTable = temp_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


%y_init = y_handpicked_10_28;
%myModelHandle = @modelHandpickedAll;

% phi0 alpha A B C D E A0 eta0 width delta
y_init = [0.7 1 0.00000001 1 1 1 0 0.02 0.02 10 -1];
myModelHandle = @modelJimMinimal;

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',true);

%return




% constraints
lower_bounds = -Inf*ones(size(y_init));
upper_bounds = Inf*ones(size(y_init));

residualsfxn = @(y) get_residuals(dataTable,y,myModelHandle);
optsLsq = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
[y_optimal_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,optsLsq);

costfxn = @(y) sum(get_residuals(dataTable,y,myModelHandle).^2);
%optsFmin = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
%[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],optsFmin);

%[y_optimal_fmin_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_optimal_fmin,lower_bounds,upper_bounds,optsLsq);

show_F_vs_x(dataTable,y_optimal_lsq,myModelHandle,'ShowInterpolatingFunction',true); title('lsq')
%show_F_vs_xc_x(dataTable,y_optimal_fmin,myModelHandle,'ShowInterpolatingFunction',true); title('fmin')
%show_F_vs_xc_x(dataTable,y_optimal_fmin_lsq,myModelHandle,'ShowInterpolatingFunction',true); title('fmin -> lsq')


disp(costfxn(y_optimal_lsq))
%disp(costfxn(y_optimal_fmin))
%disp(costfxn(y_optimal_fmin_lsq))