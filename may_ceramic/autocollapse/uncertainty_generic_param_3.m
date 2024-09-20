function [epsilon,SSR,y_list] = uncertainty_generic_param_3(dataTable,y_optimal,paramNum,rangeMinus,rangePlus,numPts)

%dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

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
opts = optimoptions('fmincon','Display','none','MaxFunctionEvaluations',3e5);


%paramNum = 20;

param_init = y_optimal(paramNum);

paramRange = linspace(param_init-rangeMinus,param_init+rangePlus,numPts);

SSR_0 = costfxn(y_optimal);
SSR = zeros(size(paramRange));
epsilon = zeros(size(paramRange));
y_list = zeros(length(paramRange),length(y_optimal));
for ii = 1:length(paramRange)
    myParam = paramRange(ii);
    my_y_init = setParams(y_optimal,13,paramNum,myParam);
    my_lb = setParams(lower_bounds,13,paramNum,myParam);
    my_ub = setParams(upper_bounds,13,paramNum,myParam);  

    if ~isreal(costfxn(my_y_init))
        continue
    end

    my_y_optimal = fmincon(costfxn,my_y_init,[],[],[],[],my_lb,my_ub,[],opts);
    mySSR = costfxn(my_y_optimal);

    epsilon(ii) = myParam-param_init;
    SSR(ii) = mySSR-SSR_0;
    y_list(ii,:) = my_y_optimal;
end

end
% figure;
% hold on;
% plot(epsilon,SSR,'o','LineWidth',1)
% p = polyfit(epsilon,SSR,2);
% plot(epsilon,p(1)*epsilon.^2+p(2)*epsilon+p(3),'-r','LineWidth',1);
% disp([p(1) p(2) p(3)])


