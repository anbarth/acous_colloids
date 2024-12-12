dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

my_phi_index = 10;

% previously determined
phi0 = 0.7011;
sigmastar = 0.3011*ones(1,numV);
C = ones(numPhi,numV);
C(:,1) = [0.01 0.025 0.05 0.1 0.25 0.5 0.75 0.8 0.85 0.925 0.95 0.975 1];

% guessing now
eta0_guess = 0.03;
delta_guess = -0.8;
A_guess = 0.05;
width_guess = 0.8;
xc_guess = 1;

% set some stuff up...
phi_fudge = zeros(size(phi_list))';

% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
y_init = zipParams(eta0_guess, phi0, delta_guess, A_guess, width_guess, sigmastar, C, phi_fudge);
y_init = [xc_guess y_init];

% check that your guess looks decent before running the rest of the script
%show_cardy(dataTable,y_init,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true);
%return

% constraints
% 0 < eta0 < Inf
% phi0 is fixed
% -Inf < delta < 0
% 0 < A < Inf
% 0 < width < Inf
% sigmastar is fixed
% C is fixed

lower_bounds = zipParams(0,   phi0, -Inf, 0,   0,   sigmastar, C, 0*ones(1,numPhi));
upper_bounds = zipParams(Inf, phi0, 0,    Inf, Inf, sigmastar, C, 0*ones(1,numPhi));
lower_bounds = [0, lower_bounds];
upper_bounds = [Inf, upper_bounds];


opts = optimoptions('fmincon','Display','off','MaxFunctionEvaluations',3e5);


acousticsFreeDataTable = dataTable(dataTable(:,3)==0,:);
costfxn = @(y) sum(getResidualsWithXc(acousticsFreeDataTable,y,phi_list,volt_list).^2);

y_optimal_xc = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);
xc = y_optimal_xc(1);
y_optimal = y_optimal_xc(2:end);
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,numPhi);
disp([eta0 A delta width xc])

% divide thru by xc to convert into units where xc=1
C(:,1) = 1/xc*C(:,1);
y_optimal = zipParams(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);

show_cardy(dataTable,y_optimal,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true);



