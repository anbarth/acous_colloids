dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% make sure wyart_cates is set to use f = @(sigma,sigmastar) sigma./(sigmastar^2+sigma.^2).^(1/2);
[eta0,sigmastar,phimu,phi0] = wyart_cates(may_ceramic_09_17,false);


% not important here
%eta0 = 0.0270;
delta = -0.3; A = 0.1; width = 0.5;


% wyart cates
%D_0V = (phi0-phimu)./(phi0-phi_list)';

% something that looks approximately fine on both plots
D_0V = [0.01 0.025 0.1 0.2 0.25 0.5 0.7 0.8  0.97 0.995 0.999 0.9999 1]*0.99999;

% make everything look power law ish
%D_0V = [0.01 0.025 0.1 0.2 0.25 0.9 0.95 0.99 0.97 0.995 0.999 0.9999 1]*0.99999;

y_handpicked_01_22 =[eta0, phi0, delta, A, width, sigmastar, D_0V];

% ii = 9;
% show_F_vs_x(dataTable,y_handpicked_01_22,@modelHandpicked0V,'PhiRange',ii+1:-1:ii,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
% show_F_vs_xc_x(dataTable,y_handpicked_01_22,@modelHandpicked0V,'PhiRange',ii:ii+1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',false,'ShowErrorBars',true)
%xlim([1e-2 1])


%show_F_vs_x(dataTable,y_handpicked_01_22,@modelHandpicked0V,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
%show_F_vs_xc_x(dataTable,y_handpicked_01_22,@modelHandpicked0V,'PhiRange',13:-1:1,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)

show_cardy(may_ceramic_09_17,y_handpicked_01_22,@modelHandpicked0V,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'alpha',1/2)