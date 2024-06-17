dataTable = may_ceramic_06_06;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

eta0_init = 0.03;
phi0_init = 0.69;
delta_init = -1.5;
sigmastar_init = [0.3600    0.4    0.5    0.7994    1.2    2   2.5];
C1 = [ 0.01    0.025    0.1389    0.2379    0.3716    0.4516    0.7308    0.7433    0.8549    0.8376    0.8586];
C2 = 1.7*[0         0         0         0         0    0.2954    0.45    0.45    0.5    0.5    0.5];
C3 = 1.7*[0         0         0         0         0    0.2939    0.4    0.45    0.5    0.5    0.5];
C4 = 1.7*[0         0         0         0         0    0.2801    0.45    0.45    0.5    0.5    0.5];
C5 = 1.4*[0         0         0         0         0    0.2836    0.45    0.5280    0.6    0.6    0.6];
C6 = 1*[0         0         0         0         0    0.3299    0.5288    0.65    0.8         0    0.8];
C7 = 0.8*[0         0         0         0         0    0.2926    0.4862    0.7    0.9         0    1];
C_init = [C1',C2',C3',C4',C5',C6',C7'];
C_init(6,:) = 0.7*C_init(6,:);
C_init = 1.1*C_init;

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
