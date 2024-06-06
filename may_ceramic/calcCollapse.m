dataTable = may_ceramic_06_05;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

eta0_init = 0.03;
phi0_init = 0.69;
delta_init = -1.5;
sigmastar_init = [0.3600    0.6566    0.6435    0.7994    0.9990    1.3038    1.6757];
C1 = [ 0.01    0.025    0.1389    0.2379    0.3716    0.4516    0.7308    0.7433    0.8549    0.8376    0.8586];
C2 = [0         0         0         0         0    0.2954    0.6053    0.6188    0.7561    0.7409    0.7729];
C3 = [0         0         0         0         0    0.2939    0.6202    0.6347    0.7764    0.7554    0.7977];
C4 = [0         0         0         0         0    0.2801    0.5636    0.5687    0.7083    0.6848    0.7028];
C5 = [0         0         0         0         0    0.2836    0.5318    0.5280    0.6649    0.6359    0.6443];
C6 = [0         0         0         0         0    0.3299    0.5288    0.5488    0.6912         0    0.6716];
C7 = [0         0         0         0         0    0.2926    0.4862    0.5045    0.6600         0    0.6331];
C_init = 1/10*[C1',C2',C3',C4',C5',C6',C7'];

y_init = zipParams(eta0_init,phi0_init,delta_init,sigmastar_init,C_init);

% y = [eta0, phi0, delta, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
costfxn = @(y) goodnessOfCollapseAllParams(dataTable,phi_list,volt_list,y);

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
lower_bounds = zipParams(0,0,-Inf,zeros(1,numV),C_lower);
upper_bounds = zipParams(Inf,1,0,Inf*ones(1,numV),C_upper);

opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e4);
y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);

[eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,numPhi);
