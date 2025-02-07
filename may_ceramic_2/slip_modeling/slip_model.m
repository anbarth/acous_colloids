figure; hold on; makeAxesLogLog;

sigma = logspace(-1,3);

phi_list = [0.4 0.5 0.59];
minPhi = min(phi_list);
maxPhi = max(phi_list);



slipRate = @(sigma) heaviside(sigma-1);
k=1;
sigma_s=1;
maxV = 1e-1;
%slipRate = @(sigma)  heaviside(sigma-sigma_s)*1e-4./(1+exp(-k*(sigma-sigma_s)));
%slipRate = @(sigma)  maxV*heaviside(sigma-sigma_s) .* ( 1./(1+exp(-k*(sigma-sigma_s))) - 1/2);
slipRate = @(sigma)  maxV*heaviside(sigma-sigma_s) .* ( 1./(1+exp(-k*(sigma-sigma_s))) - 1/2);

cmap = flipud(viridis(256));

for ii=1:length(phi_list)
    phi = phi_list(ii);
    eta = etaWC(phi,sigma);
    rate = sigma./eta;
    rateMeasured = rate+slipRate(sigma);
    etaMeasured = sigma./rateMeasured;

    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    plot(sigma,eta,'--',"Color",myColor,'LineWidth',0.75)
    plot(sigma,etaMeasured,'-',"Color",myColor,'LineWidth',1)
end
plot(sigma,slipRate(sigma),'k')
