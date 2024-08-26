figure; hold on;

phi_list = unique(meera_cs_table(:,1));
phi_plot_range = 1:25;

collapse_params;
%plot(phi_list(phi_plot_range),C(phi_plot_range,1),'-ok','LineWidth',1);
plot(phi_list(phi_plot_range),C(phi_plot_range,1).*(phi0-phi_list(phi_plot_range)),'-ok','LineWidth',1);
eta0_1 = eta0;
phi0_1 = phi0;
delta_1 = delta;
A_1 = A;
width_1 = width;
sigmastar_1 = sigmastar(1);

load("y_cs_08_14.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,30);
%plot(phi_list(phi_plot_range),C(phi_plot_range,1),'-ob','LineWidth',1);
plot(phi_list(phi_plot_range),C(phi_plot_range,1).*(phi0-phi_list(phi_plot_range)),'-ob','LineWidth',1);

disp([eta0_1 eta0])
disp([phi0_1 phi0])
disp([delta_1 delta])
disp([A_1 A])
disp([width_1 width])
disp([sigmastar_1 sigmastar(1)])