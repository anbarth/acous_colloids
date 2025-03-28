dataTable = may_ceramic_09_17;
%dataTable = temp_data_table;

vol_frac_plotting_range = 13:-1:1;
%volt_plotting_range = 6;
volt_plotting_range = 1:7;
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = false;
showInterpolatingFunction = false;
showErrorBars = false;

%load("y_09_19_ratio_with_and_without_Cv.mat")
%y_optimal = y_Cv;

%  load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04;

y_optimal = y_handpicked_10_07;
%load("y_09_19_ratio_with_and_without_Cv.mat"); y_optimal = y_Cv;

[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13);
% remove phi dependence
%phi_list = unique(dataTable(:,1)); C(:,1) = 1./(phi0-phi_list);

% remove voltage dependence
%sigmastar(2:end) = sigmastar(1);
%C(:,2:end) = repmat(C(:,1),1,6);
y_optimal = zipParams(eta0, phi0, delta, A, width, sigmastar, C, phi_fudge);



%show_F_vs_x(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction,'ShowErrorBars',showErrorBars);
show_F_vs_xc_x(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction,'ShowErrorBars',showErrorBars);
%show_cardy(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction,'ShowErrorBars',showErrorBars);