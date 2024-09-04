dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% previously determined
phi0 = 0.7011;
sigmastar = 0.3011*ones(1,numV);
phi_fudge = zeros(size(phi_list))';


% not important here
%eta0_guess = 0.03; delta_guess = -0.8; A_guess = 0.05; width_guess = 0.8;
eta0_guess = 0.0270; delta_guess = -1.1995; A_guess = 0.0227; width_guess = 1.0955;


% guess C
C = ones(numPhi,numV);
%C(:,1) = [0.01 0.025 0.05 0.1 0.25 0.5 0.75 0.8 0.85 0.925 0.95 0.975 1];
C(:,1) = [0.01 0.025 0.05 0.1 0.25 0.5 0.75 0.8 0.85 0.925 0.95 0.975 1]*1/1.0162;

y_init = zipParams(eta0_guess, phi0, delta_guess, A_guess, width_guess, sigmastar, C, phi_fudge);

show_F_vs_x(dataTable,y_init,'PhiRange',6:13,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true)
