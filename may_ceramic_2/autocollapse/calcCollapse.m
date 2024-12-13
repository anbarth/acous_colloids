dataTable = may_ceramic_09_17;
%dataTable = temp_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


%y_init = y_handpicked_10_28;
%myModelHandle = @modelHandpickedAll;

y_init = y_red_handpicked;
myModelHandle = @modelSmoothFunctions;

% check that initial guess looks ok before continuing
show_F_vs_xc_x(dataTable,y_init,myModelHandle,'ShowInterpolatingFunction',true);

%return




% constraints
% 0 < eta0 < Inf
% 0 < phi0 < 1
% -Inf < delta < 0
% 0 < A < Inf
% 0 < width < Inf
% 0 < sigmastar < Inf
% 0 < C < Inf
% C = 0 for phi=20%...40%; V > 0 (no data)
% C = 0 for phi=56%, V>=60 (no data)
% phi_fudge = 0
C_lower = zeros(numPhi,numV);
C_upper = Inf*ones(numPhi,numV);
C_lower(1:5,2:end) = 0;
C_upper(1:5,2:end) = 0;
C_lower(11,6:7) = 0;
C_upper(11,6:7) = 0;


%lower_bounds = zipParamsHandpickedAll(0,0,-Inf,0,0,zeros(1,numV),C_lower,0*ones(1,numPhi));
%upper_bounds = zipParamsHandpickedAll(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0*ones(1,numPhi));
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