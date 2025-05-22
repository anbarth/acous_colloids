%optimize_sigmastarV_03_19
y=y_lsq;
ci = get_conf_ints(dataTable,y,myModelHandle);


D = y(13:end);
D_ci = ci(13:end);

figure; hold on; prettyplot;
xlabel('\phi'); ylabel('D(\phi)')
errorbar(phi_list,D,D_ci,'ok')

sigmastar = y(6:12);
sigmastar_a = sigmastar(2:end)-sigmastar(1);
sigmastar_ci = ci(7:12);
CSS = (50/19)^3;
sigmastar_a = sigmastar_a*CSS;
sigmastar_ci = sigmastar_ci*CSS;

figure; hold on; prettyplot; makeAxesLogLog;
ylabel('\sigma^*_a'); xlabel('U_a')
V = [5 10 20 40 60 80];
errorbar(acoustic_energy_density(V),sigmastar_a,sigmastar_ci,'ok')
xlim([0.05 50])
ylim([0.05 50])
V = linspace(0,200);
plot(acoustic_energy_density(V),acoustic_energy_density(V),'k--')