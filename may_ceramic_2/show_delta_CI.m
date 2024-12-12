load("y_09_19_ratio_with_and_without_Cv.mat")
load("y_Cv_delta_CI.mat")

show_cardy(may_ceramic_09_17,y_Cv,'ShowInterpolatingFunction',true)
show_cardy(may_ceramic_09_17,y_list_vary_delta(1,:),'ShowInterpolatingFunction',true)
show_cardy(may_ceramic_09_17,y_list_vary_delta(2,:),'ShowInterpolatingFunction',true)
%show_cardy(may_ceramic_09_17,y_list_vary_delta_toofar(1,:),'ShowInterpolatingFunction',true)

chi2 = @(y) sum(getResiduals(dataTable,y).^2);
P = 116 - 13 - 5*6 - 2;
N = size(dataTable,1);
dof = N-P;

disp([chi2(y_Cv)/dof chi2(y_list_vary_delta(1,:))/dof chi2(y_list_vary_delta(2,:))/dof])