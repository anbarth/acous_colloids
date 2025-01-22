dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% make sure wyart_cates is set to use f = @(sigma,sigmastar) sigma./(sigmastar^2+sigma.^2).^(1/2);
[eta0,sigmastar,phimu,phi0] = wyart_cates(may_ceramic_09_17,false);


% not important here
%eta0 = 0.0270;
delta = -1; A = 0.04; width = 1;


% guess C
%D_wyartcates = (phi0-phimu)./(phi0-phi_list)';
D_0V = [0.01 0.025 0.1 0.2 0.25 0.4 0.7 0.8 0.85 1 1 1 1]*0.99999;

y_handpicked_01_22 =[eta0, phi0, delta, A, width, sigmastar, D_0V, 1];

%show_F_vs_x(dataTable,y_handpicked_01_22,@modelHandpicked0V,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
show_F_vs_xc_x(dataTable,y_handpicked_01_22,@modelHandpicked0V,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)