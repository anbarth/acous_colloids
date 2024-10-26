dataTable = may_ceramic_09_17;
%dataTable = temp_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);



alpha = 1; % you MUST also set this manually in getResiduals

load("y_09_04.mat")
%y_init = y_handpicked_xcShifted_09_04;
y_init = y_handpicked_10_07;

% update best guesses for (eta0, delta, A, width) for alpha != 1
y_init = fitToInterpolatingFxn(may_ceramic_09_17,y_init);

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataTable,y_init);
%show_cardy(dataTable,y_init,'ShowInterpolatingFunction',true,'alpha',alpha)
return




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
% 0 < phi_fudge < 0
C_lower = zeros(numPhi,numV);
C_upper = Inf*ones(numPhi,numV);
C_lower(1:5,2:end) = 0;
C_upper(1:5,2:end) = 0;
C_lower(11,6:7) = 0;
C_upper(11,6:7) = 0;


lower_bounds = zipParams(0,0,-Inf,0,0,zeros(1,numV),C_lower,0*ones(1,numPhi));
upper_bounds = zipParams(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0*ones(1,numPhi));


%residualsfxn = @(y) getResiduals(dataTable,y);
%opts = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');
%[y_optimal_lsq,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);

costfxn = @(y) sum(getResiduals(dataTable,y).^2);
opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
[y_optimal_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);

%show_F_vs_x(dataTable,y_optimal_lsq,'ShowInterpolatingFunction',true); title('lsq 1')
%show_F_vs_x(dataTable,y_optimal_fmin,'ShowInterpolatingFunction',true); title('fmin 1')

%disp(costfxn(y_optimal_lsq))
% disp(costfxn(y_optimal_fmin))
