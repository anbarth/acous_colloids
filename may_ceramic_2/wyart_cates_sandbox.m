phi0 = 0.64;
phimu = 0.62;
sigmastar = 1;
eta0 = 1;
%f = @(sigma) sigma ./ (sigma+sigmastar);
f = @(sigma) exp(-sigmastar./sigma);

phiJ = @(sigma) phi0*(1-f(sigma)) + phimu*f(sigma);
etaWC_helper = @(phi,sigma) eta0*phi0^2 * (phiJ(sigma)-phi).^(-2);
etaWC = @(phi,sigma) etaWC_helper(phi,sigma).*(phi<phiJ(sigma));

%phi_list = [0.59, 0.6, 0.61, 0.615, 0.617, 0.619];
phi_list = [0.45 0.5 0.55 0.6 0.61 0.62 0.625];
sigma=logspace(-1,2);

cmap = viridis(256);
minPhi = min(phi_list);
maxPhi = max(phi_list);
colorPhi = @(myPhi) cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);

figure; hold on; makeAxesLogLog; prettyPlot;
%xlabel('rate'); ylabel('\sigma')
xlabel('Stress \sigma/\sigma^*'); ylabel('Viscosity \eta/\eta_0')
ylim([1 1e7])

for ii=1:length(phi_list)
    phi = phi_list(ii);
    eta = etaWC(phi,sigma);
    %plot(sigma./eta,sigma,'-','Color',colorPhi(phi))
    plot(sigma,eta,'-','Color',colorPhi(phi),'LineWidth',3)
end

% add colorbar
colormap(cmap);
c = colorbar;
c.Ticks = phi_list;
clim([minPhi maxPhi])