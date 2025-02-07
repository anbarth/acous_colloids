figure; hold on; makeAxesLogLog;

sigma = logspace(-1,3);

phi_list = [0.4 0.5 0.59 0.6];
minPhi = min(phi_list);
maxPhi = max(phi_list);

f = @(sigma) exp(-1./sigma);

cmap = flipud(viridis(256));

phimu = 0.6;
phi0 = 0.64;

for ii=1:length(phi_list)
    phi = phi_list(ii);
    eta = etaWC(phi,sigma);
    rate = sigma./eta;
    
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    plot(f(sigma),eta*(phi0-phi)^2,'-',"Color",myColor,'LineWidth',0.75)
end

