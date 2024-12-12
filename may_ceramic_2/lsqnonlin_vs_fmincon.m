dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
collapse_params;
sigmastar_init_1 = sigmastar(1);
y_init_1 = handpickedParams;


load("y_optimal_crossover_06_26.mat")
[eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init] = unzipParams(y_optimal,13);
phi_fudge_init = zeros(size(phi_list'));
sigmastar_init_2 = sigmastar_init(1);
y_init_2 = zipParams(eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);






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
% -0.02 < phi_fudge < 0.02
C_lower = zeros(numPhi,numV);
C_upper = Inf*ones(numPhi,numV);
C_lower(1:5,2:end) = 0;
C_upper(1:5,2:end) = 0;
C_lower(11,6:7) = 0;
C_upper(11,6:7) = 0;


lower_bounds = zipParams(0,0,-Inf,0,0,zeros(1,numV),C_lower,-0.01*ones(1,numPhi));
upper_bounds = zipParams(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0.01*ones(1,numPhi));

%lower_bounds_1 = zipParams(0,0,-Inf,0,0,[sigmastar_init_1, zeros(1,numV-1)],C_lower,0*ones(1,numPhi));
%upper_bounds_1 = zipParams(Inf,1,0,Inf,Inf,[sigmastar_init_1 Inf*ones(1,numV-1)],C_upper,0*ones(1,numPhi));
lower_bounds_1 = lower_bounds;
upper_bounds_1 = upper_bounds;

%lower_bounds_2 = zipParams(0,0,-Inf,0,0,[sigmastar_init_2, zeros(1,numV-1)],C_lower,0*ones(1,numPhi));
%upper_bounds_2 = zipParams(Inf,1,0,Inf,Inf,[sigmastar_init_2 Inf*ones(1,numV-1)],C_upper,0*ones(1,numPhi));
lower_bounds_2 = lower_bounds;
upper_bounds_2 = upper_bounds;


residualsfxn = @(y) getResiduals(dataTable,y);
opts = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');

[y_optimal_lsq_1,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init_1,lower_bounds_1,upper_bounds_1,opts);
[y_optimal_lsq_2,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init_2,lower_bounds_2,upper_bounds_2,opts);

costfxn = @(y) sum(getResiduals(dataTable,y).^2);
opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
y_optimal_fmin_1 = fmincon(costfxn,y_init_1,[],[],[],[],lower_bounds_1,upper_bounds_1,[],opts);
y_optimal_fmin_2 = fmincon(costfxn,y_init_1,[],[],[],[],lower_bounds_2,upper_bounds_2,[],opts);


show_F_vs_xc_x(dataTable,y_optimal_lsq_1,'ShowInterpolatingFunction',true); title('lsq 1')
show_F_vs_xc_x(dataTable,y_optimal_lsq_2,'ShowInterpolatingFunction',true); title('lsq 2')
show_F_vs_xc_x(dataTable,y_optimal_fmin_1,'ShowInterpolatingFunction',true); title('fmin 1')
show_F_vs_xc_x(dataTable,y_optimal_fmin_2,'ShowInterpolatingFunction',true); title('fmin 2')


%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,numPhi);
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal_lsq_1,numPhi);
disp(delta)
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal_lsq_2,numPhi);
disp(delta)
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal_fmin_1,numPhi);
disp(delta)
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal_fmin_2,numPhi);
disp(delta)

disp(costfxn(y_optimal_lsq_1))
disp(costfxn(y_optimal_lsq_2))
disp(costfxn(y_optimal_fmin_1))
disp(costfxn(y_optimal_fmin_2))
