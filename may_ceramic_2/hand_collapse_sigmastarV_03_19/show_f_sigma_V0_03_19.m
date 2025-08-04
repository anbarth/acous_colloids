%optimize_C_jardy_03_19;

correctStressUnits = true;
CSS=1;
if correctStressUnits
    CSS=(50/19)^3;
end

sigmastar = CSS*y_lsq_0V(6);

sigma = logspace(-2,4);
f = @(sigma,sigmastar) exp(-sigmastar./sigma);

figure; hold on; prettyPlot;
ax1=gca; ax1.XScale='log';
plot(sigma,f(sigma,sigmastar),'-','LineWidth',3,'Color','#00c907')
xlabel('Shear stress \sigma')
%ylabel('f(\sigma)')
xlim([1e-2 1e3])
xticks([1e-2 1e0 1e2])
ylim([0 1])
yticks([0 1])
