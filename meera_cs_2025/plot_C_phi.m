figure; hold on;

phi_list = unique(meera_cs_table(:,1));
phi_plot_range = 1:30;

collapse_params;
%plot(phi_list(phi_plot_range),C(phi_plot_range,1),'-ok','LineWidth',1);
plot(phi_list(phi_plot_range),C(phi_plot_range,1).*(phi0-phi_list(phi_plot_range)),'-ok','LineWidth',1);
