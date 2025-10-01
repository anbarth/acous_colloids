phi0 = 0.64;
phimu = 0.62;
sigmastar0 = 1;
sigmastar1 = 1.5;
sigmaprobe = 5;
eta0 = 1;
%f = @(sigma) sigma ./ (sigma+sigmastar);
f = @(sigma,sigmastar) exp(-sigmastar./sigma);

phiJ = @(sigma,sigmastar) phi0*(1-f(sigma,sigmastar)) + phimu*f(sigma,sigmastar);
etaWC_helper = @(phi,sigma,sigmastar) eta0*phi0^2 * (phiJ(sigma,sigmastar)-phi).^(-2);
etaWC = @(phi,sigma,sigmastar) etaWC_helper(phi,sigma,sigmastar).*(phi<phiJ(sigma,sigmastar));

%phi_list = [0.59, 0.6, 0.61, 0.615, 0.617, 0.619];
phi=0.615;
sigma=logspace(-1,2);

cmap = viridis(256);
minPhi = min(phi_list);
maxPhi = max(phi_list);
colorPhi = @(myPhi) cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);

figure; hold on; makeAxesLogLog; prettyPlot;
%xlabel('rate'); ylabel('\sigma')
xlabel('Stress \sigma/\sigma^*_0'); ylabel('Viscosity \eta/\eta_0')
ylim([1e2 1e5])
plot(sigma,etaWC(phi,sigma,sigmastar0),'k-')
plot(sigma,etaWC(phi,sigma,sigmastar1),'r-')
plot(sigmaprobe,etaWC(phi,sigmaprobe,sigmastar0),'kp','MarkerFaceColor','k','MarkerSize',7)
legend('sound off','sound on')

figure; hold on; makeAxesLogLog; prettyPlot;
%xlabel('rate'); ylabel('\sigma')
xlabel('Rate'); ylabel('Viscosity \eta/\eta_0')
ylim([1e2 1e5])
plot(sigma./etaWC(phi,sigma,sigmastar0),etaWC(phi,sigma,sigmastar0),'k-')
plot(sigma./etaWC(phi,sigma,sigmastar1),etaWC(phi,sigma,sigmastar1),'r-')
plot(sigmaprobe/etaWC(phi,sigmaprobe,sigmastar0),etaWC(phi,sigmaprobe,sigmastar0),'kp','MarkerFaceColor','k','MarkerSize',7)
legend('sound off','sound on')


