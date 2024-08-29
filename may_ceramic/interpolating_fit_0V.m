dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

my_phi_index = 10;

% previously determined
phi0 = 0.7011;
sigmastar = 0.3011*ones(1,numV);

% guessing now
eta0_guess = 0.03;
delta_guess = -0.8;
A_guess = 0.05;
width_guess = 0.8;
C_guess = 1; % C value for the one curve we're looking at

% set some stuff up...
C = ones(numPhi,numV);
C(my_phi_index,1) = C_guess;
phi_fudge = zeros(size(phi_list))';

% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
y_init = zipParams(eta0_guess, phi0, delta_guess, A_guess, width_guess, sigmastar, C, phi_fudge);

% check that your guess looks decent before running the rest of the script
%show_F_vs_x(dataTable,y_init,'PhiRange',my_phi_index,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true);
%return

% constraints
% 0 < eta0 < Inf
% phi0 is fixed
% -Inf < delta < 0
% 0 < A < Inf
% 0 < width < Inf
% sigmastar is fixed
% C is fixed except for the one curve we're looking at
% no fudge factors
C_lower = C;
C_upper = C;
C_lower(my_phi_index,1) = 0;
C_upper(my_phi_index,1) = 1;

lower_bounds = zipParams(0,   phi0, -Inf, 0,   0,   sigmastar, C_lower, 0*ones(1,numPhi));
upper_bounds = zipParams(Inf, phi0, 0,    Inf, Inf, sigmastar, C_upper, 0*ones(1,numPhi));


opts = optimoptions('fmincon','Display','off','MaxFunctionEvaluations',3e5);

for my_phi_index = 10:13
    myPhi = phi_list(my_phi_index);
    subsetDataTable = dataTable(dataTable(:,1)==myPhi & dataTable(:,3)==0,:);
    costfxn = @(y) sum(getResiduals(subsetDataTable,y,phi_list,volt_list).^2);

    y_optimal = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);
    [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,numPhi);
    disp([myPhi eta0 A delta width C(my_phi_index,1)])

    %show_F_vs_x(dataTable,y_optimal,'PhiRange',my_phi_index,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true); title(num2str(myPhi));
    %show_F_vs_xc_x(dataTable,y_optimal,'PhiRange',my_phi_index,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true); title(num2str(myPhi));
    show_cardy(dataTable,y_optimal,'PhiRange',my_phi_index,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true); title(num2str(myPhi));
end



