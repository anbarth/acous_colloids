vol_frac_plotting_range = 13:-1:1;
%vol_frac_plotting_range = 9;
volt_plotting_range = 1:7;
colorBy = 2; % 1 for V, 2 for phi, 3 for P, 4 for stress
showLines = false;
showInterpolatingFunction = true;

dataTable = may_ceramic_06_25;

%load("y_optimal_lsqnonlin_08_26.mat"); 
%collapse_params; y_optimal = handpickedParams;
y_optimal = y_optimal_lsq_2;
%y_optimal = y_optimal_fmin_1;

show_F_vs_x(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction);
show_F_vs_xc_x(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction);
show_cardy(dataTable,y_optimal,'PhiRange',vol_frac_plotting_range,'VoltRange',volt_plotting_range,'ColorBy',colorBy,'ShowLines',showLines,'ShowInterpolatingFunction',showInterpolatingFunction);