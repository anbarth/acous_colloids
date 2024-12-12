dataTable = may_ceramic_06_25;
phi_list = unique(dataTable(:,1));
volt_list = unique(dataTable(:,3));


disp([eta0_orig eta0_minus eta0_plus]);
disp([phi0_orig phi0_minus phi0_plus]);
disp([delta_orig delta_minus delta_plus]);
disp([A_orig A_minus A_plus]);
disp([width_orig width_minus width_plus]);


figure; hold on;
plot(phi_list,C_orig(:,1),'-ok','LineWidth',1)
plot(phi_list,C_minus(:,1),'--ob','LineWidth',1)
plot(phi_list,C_plus(:,1),'--or','LineWidth',1)
title('C(0V)')

figure; hold on;
plot(phi_list,C_orig(:,7),'-ok','LineWidth',1)
plot(phi_list,C_minus(:,7),'--ob','LineWidth',1)
plot(phi_list,C_plus(:,7),'--or','LineWidth',1)
title('C(80V)')

figure; hold on;
plot(volt_list,sigmastar_orig,'-ok','LineWidth',1)
plot(volt_list,sigmastar_minus,'--ob','LineWidth',1)
plot(volt_list,sigmastar_plus,'--or','LineWidth',1)
