dataTable = may_ceramic_09_17;
%dataTable = temp_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
%load("y_09_04.mat")
%y_init = y_handpicked_xcShifted_09_04;

y_init = y_Cv;

% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataTable,y_init);
%return




% constraints
% C = 0 for phi=20%...40%; V > 0 (no data)
% C = 0 for phi=56%, V>=60 (no data)
% phi_fudge = 0
C_con = NaN(numPhi,numV);
C_con(1:5,2:end) = 0;
C_con(11,6:7) = 0;
phi_fudge_con = 0*ones(1,numPhi);
constraints = zipParams(NaN,NaN,NaN,NaN,NaN,NaN(1,numV),C_con,phi_fudge_con);

y_init_restricted = removeConstraintsFromParamVec(y_init,constraints);


costfxncon = @(y) sum(getResidualsCon(dataTable,y,constraints).^2);
opts = optimoptions('fminunc','Display','final','MaxFunctionEvaluations',3e5,'StepTolerance',1e-12);
[y_optimal_restricted,fval,exitflag,output,grad,hessian] = fminunc(costfxncon,y_init_restricted,opts);
y_optimal = mergeParamsAndConstraints(y_optimal_restricted,constraints);
disp(sum(getResiduals(dataTable,y_optimal).^2));

%show_F_vs_x(dataTable,y_optimal_lsq,'ShowInterpolatingFunction',true); title('lsq 1')
%show_F_vs_x(dataTable,y_optimal_fmin,'ShowInterpolatingFunction',true); title('fmin 1')

% disp(costfxn(y_optimal_lsq))
% disp(costfxn(y_optimal_fmin))

