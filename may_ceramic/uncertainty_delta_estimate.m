dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
load("y_optimal_lsqnonlin_08_26.mat")
%load("y_optimal_crossover_06_26.mat")
%phi_fudge_init = zeros(size(phi_list'));
[eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init] = unzipParamsCrossoverFudge(y_optimal,13);


residualsfxn = @(y) residualsCrossoverFudge(dataTable,phi_list,volt_list,y);

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


opts = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','StepTolerance',1e-12);

% fit for all parameters except phi0=phi0_init
%delta_center = delta_init;
%myDelta = delta_center;
y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
lower_bounds = zipParamsCrossoverFudge(0,0,-Inf,0,0,zeros(1,numV),C_lower,phi_fudge_init);
upper_bounds = zipParamsCrossoverFudge(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,phi_fudge_init);
[y_optimal,resnorm_init,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
[eta0_orig, phi0_orig, delta_orig, A_orig, width_orig, sigmastar_orig, C_orig, phi_fudge_orig] = unzipParamsCrossoverFudge(y_optimal,numPhi);
showCollapse(dataTable,y_optimal);
title('original')
delta_center = delta_orig;

% now try to fix phi0=phi0+epsilon
epsilon = 0.01;
myDelta = delta_center+epsilon;
y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, myDelta, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
lower_bounds = zipParamsCrossoverFudge(0,0,myDelta,0,0,zeros(1,numV),C_lower,phi_fudge_init);
upper_bounds = zipParamsCrossoverFudge(Inf,1,myDelta,Inf,Inf,Inf*ones(1,numV),C_upper,phi_fudge_init);
[y_optimal,resnorm_plus,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
[eta0_plus, phi0_plus, delta_plus, A_plus, width_plus, sigmastar_plus, C_plus, phi_fudge_plus] = unzipParamsCrossoverFudge(y_optimal,numPhi);
showCollapse(dataTable,y_optimal);
title('+epsilon')

% now try to fix phi0=phi0+epsilon
myDelta = delta_center-epsilon;
y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, myDelta, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
lower_bounds = zipParamsCrossoverFudge(0,0,myDelta,0,0,zeros(1,numV),C_lower,phi_fudge_init);
upper_bounds = zipParamsCrossoverFudge(Inf,1,myDelta,Inf,Inf,Inf*ones(1,numV),C_upper,phi_fudge_init);
[y_optimal,resnorm_minus,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
[eta0_minus, phi0_minus, delta_minus, A_minus, width_minus, sigmastar_minus, C_minus, phi_fudge_minus] = unzipParamsCrossoverFudge(y_optimal,numPhi);
showCollapse(dataTable,y_optimal);
title('-epsilon')

disp([resnorm_init resnorm_plus resnorm_minus])



