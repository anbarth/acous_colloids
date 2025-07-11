%optimize_sigmastarV_03_19

% get optimal parameters
y=y_lsq;
sigmastar = y(6:12);
sigmastar_0 = sigmastar(1);
sigmastar_a = sigmastar(2:end)-sigmastar(1);

[sigmastar_0_ci_u,sigmastar_0_ci_l,sigmastar_a_ci_u,sigmastar_a_ci_l] = get_sigmastar_a_confints_logspace(y,dataTable);


figure; hold on;
makeAxesLogLog;
prettyPlot
xlabel('U_a')
ylabel('\sigma^*_a')
V = [5 10 20 40 60 80];
CSS=(50/19)^3;
cmap = plasma(256);
%myColor = @(V) cmap(round(1+255*V/80),:);
logMinE0 = log(acoustic_energy_density(5));
logMaxE0 = log(acoustic_energy_density(80));
myColor = @(U) cmap(round(1+255*(log(U)-logMinE0)/( logMaxE0-logMinE0 )),:);


xpts = logspace(-5,5);
plot(xpts,xpts,'k--')
for ii=1:length(V)
    disp(ii)
    U = acoustic_energy_density(V(ii));
    errorbar(U,CSS*sigmastar_a(ii),CSS*sigmastar_a_ci_l(ii),CSS*sigmastar_a_ci_u(ii),'o','Color',myColor(U),'MarkerFaceColor',myColor(U),'LineWidth',1.5)
end

myfig = gcf;
myfig.Position=[1992,313,250,323];
xlim([0.044905934284051,44.90593428405083])
xticks([10^-1 10^0 10^1])
ylim([0.002,100])
yticks([10^-2 10^0 10^2])

disp(sigmastar_0*CSS)
disp(CSS*(sigmastar_0-sigmastar_0_ci_l))
disp(CSS*(sigmastar_0+sigmastar_0_ci_u))

