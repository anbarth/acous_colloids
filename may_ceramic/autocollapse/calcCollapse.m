dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
collapse_params;
y_init_1 = handpickedParams;


load("y_optimal_crossover_06_26.mat")
[eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init] = unzipParams(y_optimal,13);
phi_fudge_init = zeros(size(phi_list'));
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

% no constraints
%lower_bounds = [];
%upper_bounds = [];

% no fudge factors
 lower_bounds = zipParams(0,0,-Inf,0,0,zeros(1,numV),C_lower,0*ones(1,numPhi));
 upper_bounds = zipParams(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0*ones(1,numPhi));

% let all the parameters float
%lower_bounds = zipParams(0,0,-Inf,0,0,zeros(1,numV),C_lower,-0.01*ones(1,numPhi));
%upper_bounds = zipParams(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0.01*ones(1,numPhi));

% only play with the fudge factors
%lower_bounds = zipParams(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,-0.01*ones(1,numPhi));
%upper_bounds = zipParams(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,0.01*ones(1,numPhi));

% fix delta=-2
%load("y_optimal_crossover_delta2_06_26.mat"); [eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init] = unzipParamsCrossover(y_optimal,13); phi_fudge_init = zeros(1,13); 
%y_init = zipParams(eta0_init, phi0_init, -2, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
% let all the parameters float
%lower_bounds = zipParams(0,0,-2,0,width_init,zeros(1,numV),C_lower,-0.02*ones(1,numPhi));
%upper_bounds = zipParams(Inf,1,-2,Inf,width_init,Inf*ones(1,numV),C_upper,0.02*ones(1,numPhi));
% only play with the fudge factors, fix delta=-2
%lower_bounds = zipParams(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,-0.02*ones(1,numPhi));
%upper_bounds = zipParams(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,0.02*ones(1,numPhi));


%opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e4);
%y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);


residualsfxn = @(y) getResiduals(dataTable,y);
opts = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');

[y_optimal_lsq_1,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init_1,lower_bounds,upper_bounds,opts);
[y_optimal_lsq_2,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init_2,lower_bounds,upper_bounds,opts);

costfxn = @(y) sum(getResiduals(dataTable,y).^2);
opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
y_optimal_fmin_1 = fmincon(costfxn,y_init_1,[],[],[],[],lower_bounds,upper_bounds,[],opts);
y_optimal_fmin_2 = fmincon(costfxn,y_init_1,[],[],[],[],lower_bounds,upper_bounds,[],opts);


show_F_vs_x(dataTable,y_optimal_lsq_1,'ShowInterpolatingFunction',true); title('lsq 1')
show_F_vs_x(dataTable,y_optimal_lsq_2,'ShowInterpolatingFunction',true); title('lsq 2')
show_F_vs_x(dataTable,y_optimal_fmin_1,'ShowInterpolatingFunction',true); title('fmin 1')
show_F_vs_x(dataTable,y_optimal_fmin_2,'ShowInterpolatingFunction',true); title('fmin 2')


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