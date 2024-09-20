function chi2 = chi2_constrained(dataTable,y_optimal,paramNum,constrainedValue)

%disp(constrainedValue)

phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% constraints
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

my_y_init = setParams(y_optimal,13,paramNum,constrainedValue);
my_lb = setParams(lower_bounds,13,paramNum,constrainedValue);
my_ub = setParams(upper_bounds,13,paramNum,constrainedValue);  

if ~isreal(costfxn(my_y_init))
    chi2 = Inf;
    return
end

my_y_optimal = fmincon(costfxn,my_y_init,[],[],[],[],my_lb,my_ub,[],opts);
chi2 = costfxn(my_y_optimal);


end