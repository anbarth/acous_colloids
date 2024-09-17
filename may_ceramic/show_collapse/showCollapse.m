dataTable = may_ceramic_09_17;


vol_frac_plotting_range = 1:13;
volt_plotting_range = 1;
colorBy = 2; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = true;
showInterpolatingFunction = false;
showErrorBars = false;

%y_optimal = y_optimal_fmin_1;
load("y_09_17_not_smooth.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);

%  load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04;
%  [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);

% remove voltage dependence
%C(:,2:end) = repmat(C(:,1),1,6);
%sigmastar(2:end) = sigmastar(1);
%y_optimal = zipParams(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);



show_F_vs_x(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction,'ShowErrorBars',showErrorBars);
%show_F_vs_xc_x(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction,'ShowErrorBars',showErrorBars);
%show_cardy(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction);