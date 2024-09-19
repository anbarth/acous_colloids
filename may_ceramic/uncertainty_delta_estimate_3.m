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
opts = optimoptions('fmincon','Display','final','MaxFunctionEvaluations',3e5);



deltaDelta = 0.05;
deltaRange = linspace(delta_init-deltaDelta,delta_init+deltaDelta,3);
SSR_0 = costfxn(y_optimal);
SSR = zeros(size(deltaRange));
epsilon = zeros(size(deltaRange));
for ii = 1:length(deltaRange)
    myDelta = deltaRange(ii);
    my_y_init = setParams(y_optimal,13,'delta',myDelta);
    my_lb = setParams(lower_bounds,13,'delta',myDelta);
    my_ub = setParams(upper_bounds,13,'delta',myDelta);  

    my_y_optimal = fmincon(costfxn,my_y_init,[],[],[],[],my_lb,my_ub,[],opts);
    mySSR = costfxn(my_y_optimal);

    epsilon(ii) = myDelta-delta_init;
    SSR(ii) = mySSR-SSR_0;
end

figure;
hold on;
plot(epsilon,resnorm,'-o','LineWidth',1)
% why isnt there 0,0?? issue
% also save all the y_optimals


