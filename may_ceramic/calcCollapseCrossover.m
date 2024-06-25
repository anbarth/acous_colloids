dataTable = may_ceramic_06_06;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

load("y_optimal_06_15.mat")
[eta0_init, phi0_init, delta_init, sigmastar_init, C_init] = unzipParams(y_optimal,11);
A_init = eta0_init;
width_init = 0.5;

y_init = zipParamsCrossover(eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init);

% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
costfxn = @(y) goodnessOfCollapseCrossover(dataTable,phi_list,volt_list,y);

% constraints
% 0 < eta0 < Inf
% 0 < phi0 < 1
% -Inf < delta < 0
% 0 < sigmastar < Inf
% 0 < C < Inf
% C = 0 for phi=20%...40%; V > 0 (no data)
% C = 0 for phi=56%, V>=60 (no data)
C_lower = zeros(numPhi,numV);
C_upper = Inf*ones(numPhi,numV);
C_lower(1:5,2:end) = zeros(size(C_lower(1:5,2:end)));
C_upper(1:5,2:end) = zeros(size(C_upper(1:5,2:end)));
C_lower(10,6:7) = 0;
C_upper(10,6:7) = 0;

%lower_bounds = [];
%upper_bounds = [];
lower_bounds = zipParamsCrossover(0,0,-Inf,0,0,zeros(1,numV),C_lower);
upper_bounds = zipParamsCrossover(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper);

%lower_bounds = zipParamsCrossover(eta0_init,phi0_init,delta_init,0,0,sigmastar_init,C_init);
%upper_bounds = zipParamsCrossover(eta0_init,phi0_init,delta_init,Inf,Inf,sigmastar_init,C_init);

opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e4);
y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);

[eta0, phi0, delta, A, width, sigmastar, C] = unzipParamsCrossover(y_optimal,numPhi);
goodnessOfCollapseCrossover(dataTable,phi_list,volt_list,y_optimal,true);
