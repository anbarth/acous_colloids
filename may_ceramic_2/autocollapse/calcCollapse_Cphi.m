dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
load("y_09_04.mat")
y_init = y_handpicked_xcShifted_09_04;


% check that initial guess looks ok before continuing
%show_F_vs_xc_x(dataTable,y_init);
%return




% constraints
% 0 < eta0 < Inf
% 0 < phi0 < 1
% -Inf < delta < 0
% 0 < A < Inf
% 0 < width < Inf
% 0 < sigmastar < Inf
% 0 < C < Inf
% C = 0 for V > 0 (no data)
C_lower = zeros(numPhi,numV);
C_upper = Inf*ones(numPhi,numV);
C_lower(:,2:end) = 0;
C_upper(:,2:end) = 0;


lower_bounds = zipParams(0,0,-Inf,0,0,zeros(1,numV),C_lower,0*ones(1,numPhi));
upper_bounds = zipParams(Inf,1,0,Inf,Inf,Inf*ones(1,numV),C_upper,0*ones(1,numPhi));


costfxn = @(y) sum(getResiduals(dataTable,y).^2);
opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);
y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);
C(:,2:end) = repmat(C(:,1),1,6);
y_optimal = setParams(y_optimal,13,'C',C);


show_F_vs_x(dataTable,y_optimal,'ShowInterpolatingFunction',true);


