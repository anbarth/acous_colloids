dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
load("y_09_17_not_smooth.mat")
[eta0_init, phi0_init, delta_init, A_init, width_init, sigmastar_init, C_init, phi_fudge_init] = unzipParams(y_optimal,13);

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
% 0 < phi_fudge < 0
C_lower = zeros(numPhi,numV);
C_upper = Inf*ones(numPhi,numV);
C_lower(1:5,2:end) = 0;
C_upper(1:5,2:end) = 0;
C_lower(11,6:7) = 0;
C_upper(11,6:7) = 0;

lower_bounds = zipParams(0,0,-Inf,0,0,zeros(1,numV),C_lower,0*ones(1,numPhi));
upper_bounds = zipParams(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0*ones(1,numPhi));


costfxn = @(y) sum(getResiduals(dataTable,y).^2);

SSR_0 = costfxn(y_optimal);
epsilon = 0.05;

opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
y_init_plus = setParams(y_optimal,13,'delta',delta_init+epsilon);
lb_plus = setParams(lower_bounds,13,'delta',delta_init+epsilon);
ub_plus = setParams(upper_bounds,13,'delta',delta_init+epsilon);
y_plus = fmincon(costfxn,y_init_plus,[],[],[],[],lb_plus,ub_plus,[],opts);
SSR_plus = costfxn(y_plus);

y_init_minus = setParams(y_optimal,13,'delta',delta_init-epsilon);
lb_minus = setParams(lower_bounds,13,'delta',delta_init-epsilon);
ub_minus = setParams(upper_bounds,13,'delta',delta_init-epsilon);
y_minus = fmincon(costfxn,y_init_minus,[],[],[],[],lb_minus,ub_minus,[],opts);
SSR_minus = costfxn(y_minus);

disp([SSR_0 SSR_minus SSR_plus])


