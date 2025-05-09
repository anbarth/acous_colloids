dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% y = [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
costfxn = @(y) goodnessOfCollapsePowerLaw(dataTable,phi_list,volt_list,y);

% constraints
% 0 < eta0 < Inf
% 0 < phi0 < 1
% -Inf < delta < 0
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


%load("y_optimal_06_26.mat");
load("y_optimal_delta2_06_27.mat")
[eta0_init, phi0_init, delta_init, sigmastar_init, C_init] = unzipParamsPowerLawFudgeless(y_optimal,13);
phi_fudge_init = zeros(1,numPhi);
y_init = zipParamsPowerLaw(eta0_init,phi0_init,delta_init,sigmastar_init,C_init,phi_fudge_init);

% no constraints
%lower_bounds = [];
%upper_bounds = [];

% let all parameters float
%lower_bounds = zipParamsFudge(0,0,-Inf,zeros(1,numV),C_lower,-0.02*ones(1,numPhi));
%upper_bounds = zipParamsFudge(Inf,1,0,Inf*ones(1,numV),C_upper,0.02*ones(1,numPhi));

% only let the volume fractions float
%lower_bounds = zipParamsFudge(eta0_init,phi0_init,delta_init,sigmastar_init,C_init,-0.02*ones(1,numPhi));
%upper_bounds = zipParamsFudge(eta0_init,phi0_init,delta_init,sigmastar_init,C_init,0.02*ones(1,numPhi));

% fix delta = -2
lower_bounds = zipParamsFudge(0,0,-2,zeros(1,numV),C_lower,-0.02*ones(1,numPhi));
upper_bounds = zipParamsFudge(Inf,1,-2,10*ones(1,numV),C_upper,0.02*ones(1,numPhi));
y_init = zipParamsPowerLaw(eta0_init,phi0_init,-2,sigmastar_init,C_init,phi_fudge_init);

opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e4,'MaxIterations',1e4);
y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);

[eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsPowerLaw(y_optimal,numPhi);
