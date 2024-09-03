dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);




% pre-reqs: play_with_CV, fit_sigmastar, fit_C


% y = [eta0, phi0, delta, A, width, [sigmastar(V)], [C(V=0)], [C(V=5)], [C(V=10)], ...]
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y2,numPhi);
y_init = y2;
xc_guess = 1;


% check that your guess looks decent before running the rest of the script
%show_F_vs_xc_x(dataTable,y_init,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true);
%return

% constraints
% 0 < eta0 < Inf
% phi0 is fixed
% -Inf < delta < 0
% 0 < A < Inf
% 0 < width < Inf
% sigmastar is fixed
% C is fixed

lower_bounds = zipParams(0,   phi0, -Inf, 0,   0,   sigmastar, C, -0.01*ones(1,numPhi));
upper_bounds = zipParams(Inf, phi0, 0,    Inf, Inf, sigmastar, C, 0.01*ones(1,numPhi));
lower_bounds = [1, lower_bounds];
upper_bounds = [1, upper_bounds];
y_init = [xc_guess y_init];


opts = optimoptions('fmincon','Display','off','MaxFunctionEvaluations',3e5);


costfxn = @(y) sum(getResidualsWithXc(dataTable,y).^2);

y_optimal_xc = fmincon(costfxn,y_init,[],[],[],[],lower_bounds,upper_bounds,[],opts);
xc = y_optimal_xc(1);
y_optimal = y_optimal_xc(2:end);
[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,numPhi);
disp([eta0 A delta width xc])

% divide thru by xc to convert into units where xc=1
%C(:,1) = 1/xc*C(:,1);
%y_optimal = zipParams(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);

show_cardy(dataTable,y_optimal,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',1:7,'ColorBy',2,'ShowInterpolatingFunction',true);



