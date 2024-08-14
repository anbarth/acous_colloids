dataTable = pranav_data_table;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);



% collapse params by hand
% collapse_params;
% phi0_init = phi0;
% C_init = C;
% sigmastar_init = sigmastar;
% eta0_init = 0.0298;
% delta_init = -1;
% A_init = 0.3;
% width_init = 2;
% phi_fudge_init = zeros(1,8);

load("y_optimal_08_13.mat"); [eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init] = unzipParamsCrossoverFudge(y_optimal,8);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);


costfxn = @(y) goodnessOfCollapseCrossoverFudge(dataTable,phi_list,volt_list,y);

% constraints
% 0 < eta0 < Inf
% 0 < phi0 < 1
% -Inf < delta < 0
% 0 < A < Inf
% 0 < width < Inf
% 0 < sigmastar < Inf
% 0 < C < Inf
% -0.02 < phi_fudge < 0.02
C_lower = zeros(numPhi,numV);
C_upper = Inf*ones(numPhi,numV);

% no constraints
%lower_bounds = [];
%upper_bounds = [];

% no fudge
%lower_bounds = zipParamsCrossoverFudge(0,0,-Inf,0,0,zeros(1,numV),C_lower,0*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0*ones(1,numPhi));

% let all the parameters float
%lower_bounds = zipParamsCrossoverFudge(0,0,-Inf,0,0,zeros(1,numV),C_lower,-0.01*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0.01*ones(1,numPhi));

% only play with the fudge factors
lower_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,-0.03*ones(1,numPhi));
upper_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,0.03*ones(1,numPhi));

% fix delta=-2
%load("y_optimal_crossover_delta2_06_26.mat"); [eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init] = unzipParamsCrossover(y_optimal,13); phi_fudge_init = zeros(1,13); 
%y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, -2, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
% let all the parameters float
%lower_bounds = zipParamsCrossoverFudge(0,0,-2,0,width_init,zeros(1,numV),C_lower,-0.02*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(Inf,1,-2,Inf,width_init,Inf*ones(1,numV),C_upper,0.02*ones(1,numPhi));
% only play with the fudge factors, fix delta=-2
%lower_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,-0.02*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,0.02*ones(1,numPhi));


opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e4);
y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
goodnessOfCollapseCrossoverFudge(dataTable,phi_list,volt_list,y_optimal,true);
