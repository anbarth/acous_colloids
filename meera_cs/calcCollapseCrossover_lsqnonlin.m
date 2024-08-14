dataTable = meera_cs_table;
phi_list = unique(dataTable(:,1));
volt_list = [0 5 10 20 40 60 80];
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
collapse_params;
eta0_init = eta0;
phi0_init = phi0;
delta_init = delta;
A_init = A;
width_init = width;
sigmastar_init = sigmastar;
sigmastar_init(2:end) = 0;
C_init = C;
C_init(26:end,:) = 0;
C_init(:,2:end) = 0;
phi_fudge_init = phi_fudge;
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
% C = 0 for phi > 54%
% C = 0 for V > 0
C_lower = zeros(numPhi,numV);
C_upper = Inf*ones(numPhi,numV);
C_lower(26:end,:) = 0;
C_upper(26:end,:) = 0;
C_lower(:,2:end) = 0;
C_upper(:,2:end) = 0;

% no constraints
%lower_bounds = [];
%upper_bounds = [];

% no fudge factors
%lower_bounds = zipParamsCrossoverFudge(0,0,-Inf,0,0,zeros(1,numV),C_lower,0*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(Inf,1,0,Inf,Inf,[Inf, ones(1,numV-1)],C_upper,0*ones(1,numPhi));

% let all the parameters float
%lower_bounds = zipParamsCrossoverFudge(0,0,-Inf,0,0,zeros(1,numV),C_lower,-0.01*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0.01*ones(1,numPhi));

% only play with the fudge factors
%lower_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,-0.01*ones(1,numPhi));
%upper_bounds = zipParamsCrossoverFudge(eta0_init,phi0_init,delta_init,A_init,width_init,sigmastar_init,C_init,0.01*ones(1,numPhi));

% just fit to the interpolating fxn
lower_bounds = zipParamsCrossoverFudge(0,phi0_init,-Inf,0,0,sigmastar_init,C_init,0*ones(1,numPhi));
upper_bounds = zipParamsCrossoverFudge(Inf,phi0_init,0,Inf,Inf,sigmastar_init,C_init,0*ones(1,numPhi));


%opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e4);
%y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);

opts = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt');%,'MaxFunctionEvaluations',1e5);
[y_optimal,resnorm,residual,exitflag,output,lambda,jacobian]  = lsqnonlin(residualsfxn,y_init,lower_bounds,upper_bounds,opts);

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,numPhi);
%goodnessOfCollapseCrossoverFudge(dataTable,phi_list,volt_list,y_optimal,true);
