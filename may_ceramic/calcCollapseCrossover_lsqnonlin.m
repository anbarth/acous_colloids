dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]

load("y_optimal_crossover_06_26.mat")
[eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init] = unzipParamsCrossover(y_optimal,13);

% collapse_params;
% phi0_init = phi0;
% C_init = C;
% sigmastar_init = sigmastar;
% eta0_init = 0.03;
% A_init = eta0_init;
% delta_init = -1.2;
% width_init = 0.5;
% phi_fudge_init = zeros(size(phi_list'));


y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);


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

% no constraints
%lower_bounds = [];
%upper_bounds = [];

% no fudge factors
 lower_bounds = zipParamsCrossoverFudge(0,0,-Inf,0,0,zeros(1,numV),C_lower,0*ones(1,numPhi));
 upper_bounds = zipParamsCrossoverFudge(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0*ones(1,numPhi));

% let all the parameters float
%lower_bounds = zipParamsCrossoverFudge(0,0,-Inf,0,0,zeros(1,numV),C_lower,-0.01*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0.01*ones(1,numPhi));

% only play with the fudge factors
%lower_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,-0.01*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,0.01*ones(1,numPhi));

% fix delta=-2
%load("y_optimal_crossover_delta2_06_26.mat"); [eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init] = unzipParamsCrossover(y_optimal,13); phi_fudge_init = zeros(1,13); 
%y_init = zipParamsCrossoverFudge(eta0_init, phi0_init, -2, A_init, width_init, sigmastar_init, C_init, phi_fudge_init);
% let all the parameters float
%lower_bounds = zipParamsCrossoverFudge(0,0,-2,0,width_init,zeros(1,numV),C_lower,-0.02*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(Inf,1,-2,Inf,width_init,Inf*ones(1,numV),C_upper,0.02*ones(1,numPhi));
% only play with the fudge factors, fix delta=-2
%lower_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,-0.02*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,0.02*ones(1,numPhi));


%opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e4);
%y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);

opts = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','FunctionTolerance',1e-8);%,'MaxFunctionEvaluations',1e5);
[y_optimal,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);
disp(resnorm)

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
showCollapse(dataTable,y_optimal)
