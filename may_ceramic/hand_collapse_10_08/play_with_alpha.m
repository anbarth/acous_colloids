dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% previously determined
phi0 = 0.7013;
sigmastar = 0.4589*ones(1,numV);
phi_fudge = zeros(size(phi_list))';

% not important here
eta0 = 0.0270; delta = -1; A = 0.04; width = 1;

% pick some alpha and construct D(phi) accordingly

alpha = 1; C_0V = [0.2 0.3 0.6 0.7 1 1 1.6 1.9 1.6 1.7 1.4 1.15 1]';
%alpha = 0.5; C_0V = [0.01 0.2 0.5 0.7 0.9 0.7 1.1 1.2 1.1 1.2 1.15 1.05 1]';
%alpha = 0.1; C_0V = [0.01 0.2 0.5 0.7 0.9 0.7 1.1 1.2 1.1 1.2 1.15 1.05 1]';
C_0V = [1 1 1 1 1 1 1 1 1 1 1 1 1]';
D = zeros(numPhi,numV);
D_0V = C_0V.*(phi0-phi_list).^-alpha;
D(:,1) = D_0V;

y_alpha = zipParams(eta0, phi0, delta, A, width, sigmastar, D, phi_fudge);

%show_cardy_x(dataTable,y_alpha,'alpha',alpha,'PhiRange',13:-1:1,'ShowLines',false,'VoltRange',1,'ColorBy',4,'ShowInterpolatingFunction',false,'ShowErrorBars',false)
show_F_vs_x(dataTable,y_alpha,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',false)