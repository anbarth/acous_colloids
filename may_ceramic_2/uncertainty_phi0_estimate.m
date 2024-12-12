dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
load("y_optimal_lsqnonlin_08_26.mat")
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


opts = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');

% fit for all parameters except phi0=phi0_init
myPhi0 = phi0_init;
y_init = zipParamsCrossoverFudge(eta0_init, myPhi0, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
lower_bounds = zipParamsCrossoverFudge(0,myPhi0,-Inf,0,0,zeros(1,numV),C_lower,phi_fudge_init);
upper_bounds = zipParamsCrossoverFudge(Inf,myPhi0,0,Inf,Inf,Inf*ones(1,numV),C_upper,phi_fudge_init);
[y_optimal,resnorm_init,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
goodnessOfCollapseCrossoverFudge(dataTable,phi_list,volt_list,y_optimal,true);

% now try to fix phi0=phi0+epsilon
epsilon = 0.01;
myPhi0 = phi0_init+epsilon;
y_init = zipParamsCrossoverFudge(eta0_init, myPhi0, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
lower_bounds = zipParamsCrossoverFudge(0,myPhi0,-Inf,0,0,zeros(1,numV),C_lower,phi_fudge_init);
upper_bounds = zipParamsCrossoverFudge(Inf,myPhi0,0,Inf,Inf,Inf*ones(1,numV),C_upper,phi_fudge_init);
[y_optimal,resnorm_plus,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
goodnessOfCollapseCrossoverFudge(dataTable,phi_list,volt_list,y_optimal,true);

% now try to fix phi0=phi0+epsilon
myPhi0 = phi0_init-epsilon;
y_init = zipParamsCrossoverFudge(eta0_init, myPhi0, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
lower_bounds = zipParamsCrossoverFudge(0,myPhi0,-Inf,0,0,zeros(1,numV),C_lower,phi_fudge_init);
upper_bounds = zipParamsCrossoverFudge(Inf,myPhi0,0,Inf,Inf,Inf*ones(1,numV),C_upper,phi_fudge_init);
[y_optimal,resnorm_minus,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
goodnessOfCollapseCrossoverFudge(dataTable,phi_list,volt_list,y_optimal,true);



