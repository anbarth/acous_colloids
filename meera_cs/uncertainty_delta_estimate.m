dataTable = meera_cs_table;
phi_list = unique(dataTable(:,1));
volt_list = [0 5 10 20 40 60 80];
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
load("y_cs_08_26.mat")
[eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init] = unzipParamsCrossoverFudge(y_optimal,numPhi);


residualsfxn = @(y) residualsCrossoverFudge(dataTable,phi_list,volt_list,y);

% constraints
% 0 < eta0 < Inf
% 0 < phi0 < 1
% -Inf < delta < 0
% 0 < A < Inf
% 0 < width < Inf
% 0 < sigmastar < Inf
% 0 < C < Inf
% C = 0 for phi > 54%
% C = 0 for V > 0
C_lower = zeros(numPhi,numV);
C_upper = Inf*ones(numPhi,numV);
C_lower(26:end,:) = 0;
C_upper(26:end,:) = 0;
C_lower(:,2:end) = 0;
C_upper(:,2:end) = 0;


opts = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');

% fit for all parameters except delta+delta_init
myDelta = delta_init;
y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, myDelta, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
lower_bounds = zipParamsCrossoverFudge(0,0,myDelta,0,0,zeros(1,numV),C_lower,phi_fudge_init);
upper_bounds = zipParamsCrossoverFudge(Inf,1,myDelta,Inf,Inf,Inf*ones(1,numV),C_upper,phi_fudge_init);
[y_optimal,resnorm_init,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
goodnessOfCollapseCrossoverFudge(dataTable,phi_list,volt_list,y_optimal,true);
title('original')

% now try to fix delta=delta+epsilon
epsilon = 0.3;
myDelta = delta_init+epsilon;
y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, myDelta, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
lower_bounds = zipParamsCrossoverFudge(0,0,myDelta,0,0,zeros(1,numV),C_lower,phi_fudge_init);
upper_bounds = zipParamsCrossoverFudge(Inf,1,myDelta,Inf,Inf,Inf*ones(1,numV),C_upper,phi_fudge_init);
[y_optimal,resnorm_plus,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
goodnessOfCollapseCrossoverFudge(dataTable,phi_list,volt_list,y_optimal,true);
title('+epsilon')

% now try to fix delta=delta-epsilon
myDelta = delta_init-epsilon;
y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, myDelta, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
lower_bounds = zipParamsCrossoverFudge(0,0,myDelta,0,0.0001,zeros(1,numV),C_lower,phi_fudge_init);
upper_bounds = zipParamsCrossoverFudge(Inf,1,myDelta,Inf,Inf,Inf*ones(1,numV),C_upper,phi_fudge_init);
[y_optimal,resnorm_minus,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
goodnessOfCollapseCrossoverFudge(dataTable,phi_list,volt_list,y_optimal,true);
title('-epsilon')

disp([resnorm_init resnorm_plus resnorm_minus])



