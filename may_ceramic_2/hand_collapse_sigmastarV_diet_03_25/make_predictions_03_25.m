%build_smooth_parameters_03_24;

y = y_smooth_restricted;
dataTable = may_ceramic_09_17;
myModelHandle = @modelLogisticCSigmastarV;

% collapse all data
show_F_vs_x(dataTable,y,myModelHandle,'ColorBy',2); xlim([1e-5 1.5])
show_F_vs_xc_x(dataTable,y,myModelHandle,'ColorBy',2);

[x,F,delta_F,F_hat,eta,delta_eta,eta_hat] = myModelHandle(dataTable, y);