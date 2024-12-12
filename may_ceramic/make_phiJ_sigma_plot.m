f = @(sigma) sigma./(sigma+1);
phi0 = 0.64;
phimu = 0.62;
phiJ = @(sigma) phi0*(1-f(sigma))+phimu*f(sigma);

figure; hold on;
ax1=gca; ax1.XScale = 'log';

sigma = logspace(-3,3);
xlim([1e-3 1e3])
ylim([phimu-0.005 phi0+0.005])
plot(sigma,phiJ(sigma),'LineWidth',2,'Color',[0.49,0.18,0.56]);
prettyPlot;