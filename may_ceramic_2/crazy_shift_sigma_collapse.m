dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));
numPhi = length(phi_list);
numV = length(volt_list);

% make sure wyart_cates is set to use f = @(sigma,sigmastar) sigma./(sigmastar+sigma)
[eta0,sigmastar,phimu,phi0] = wyart_cates(may_ceramic_09_17,false);

delta_sigma = [0 0 0 0 0 0 0 0 0 0 0 1 0];

y_handpicked =[phi0, phimu, sigmastar, delta_sigma];

%phiRange = [13 10];
phiRange = 13:-1:1;
show_F_vs_x(dataTable,y_handpicked,@modelShiftSigma,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
%show_F_vs_xc_x(dataTable,y_handpicked,@modelShiftSigma,'PhiRange',phiRange,'ShowLines',true,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'ShowErrorBars',true)
%show_cardy(dataTable,y_handpicked_01_22,@modelHandpicked0V,'PhiRange',phiRange,'VoltRange',1,'ColorBy',2,'ShowInterpolatingFunction',true,'alpha',1)
%xlim([1e-6 1])
