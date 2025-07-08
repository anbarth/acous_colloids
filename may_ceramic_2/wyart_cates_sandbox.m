phi0 = 0.64;
phimu = 0.62;
sigmastar = 1;
eta0 = 1;
%f = @(sigma) sigma ./ (sigma+sigmastar);
f = @(sigma) exp(-sigmastar./sigma);

phiJ = @(sigma) phi0*(1-f(sigma)) + phimu*f(sigma);
etaWC = @(phi,sigma) eta0 * (phiJ(sigma)-phi).^(-2);

phi_list = [0.59, 0.6, 0.61, 0.615, 0.617, 0.619];
sigma=logspace(-1,2);

figure; hold on; makeAxesLogLog;
xlabel('rate'); ylabel('\sigma')
for ii=1:length(phi_list)
    phi = phi_list(ii);
    eta = etaWC(phi,sigma);
    plot(sigma./eta,sigma,'-')
end