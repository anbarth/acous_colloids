vol_frac_plotting_range = 13:-1:1;
%vol_frac_plotting_range = 9;
volt_plotting_range = 1;
colorBy = 2; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = true;
showInterpolatingFunction = false;
showErrorBars = true;

dataTable = may_ceramic_06_25;

%load("y_optimal_lsqnonlin_08_26.mat"); 
%collapse_params; y_optimal = handpickedParams;
%load("y_optimal_crossover_post_fudge_1percent_06_27.mat");
load("y_09_04.mat"); y_optimal = y_handpicked_xcShifted_09_04;
%y_optimal = y_optimal_lsq_2;
%y_optimal = y_optimal_fmin_1;

show_F_vs_x(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction,'ShowErrorBars',showErrorBars);
show_F_vs_xc_x(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction,'ShowErrorBars',showErrorBars);
%show_cardy(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction);