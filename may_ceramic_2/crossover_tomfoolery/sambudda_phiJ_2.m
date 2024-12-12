dataTable = may_ceramic_09_17;
%[eta0,sigmastar,phimu,phi0] = wyart_cates(may_ceramic_09_17);

f = @(sigma) sigma ./ (sigma+sigmastar);
phiJ = @(sigma) (1-f(sigma))*phi0 + f(sigma)*phimu;
phi_list = unique(dataTable(:,1));
stress_list = unique(dataTable(:,2));
minLogSig = log(min(stress_list)*0.99);
maxLogSig = log(max(stress_list)*1.01);

figure; hold on;
ax1 = gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
cmap = winter(256);
colormap(cmap);
L={};

eta = [];
delta_eta = [];
phi = [];
for kk = 1:size(dataTable,1)
    if dataTable(kk,3) ~= 0
        continue
    end
    myPhi = dataTable(kk,1);
    mySigma = dataTable(kk,2);
    myEta = dataTable(kk,4);
    myDeltaEta = dataTable(kk,5);
    myColor = cmap(round(1+255*(log(mySigma)-minLogSig)/(maxLogSig-minLogSig)),:);


    

    
end
%plot(phiJ(sigma)-phi,eta,'-o','Color',myColor)
%legend(L);