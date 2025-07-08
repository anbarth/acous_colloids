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


% guess C
C = zeros(numPhi,numV);
D_0V = [0.01 0.025 0.1 0.2 0.25 0.4 0.7 0.8 0.85 0.97 0.95 0.97 1.02]*1/1.01/1.02;
C(:,1) = D_0V;

y_handpicked_10_28 = zipParamsHandpickedAll(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);

show_F_vs_xc_x(dataTable,y_handpicked_10_28, @modelHandpickedAll,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',false)
show_F_vs_x(dataTable,y_handpicked_10_28, @modelHandpickedAll,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',false)