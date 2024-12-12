dataTable = may_ceramic_09_17;
phi_list = unique(dataTable(:,1));
stress_list = unique(dataTable(:,2));
minLogSig = log(min(stress_list)*0.99);
maxLogSig = log(max(stress_list)*1.01);

figure; hold on;
xlabel('\phi')
ylabel('\eta^{-1/2} (Pa s)^{-1/2}');

cmap = winter(256);
colormap(cmap);
L={};
for kk = 1:length(stress_list)
    sigma = stress_list(kk);
    myColor = cmap(round(1+255*(log(sigma)-minLogSig)/(maxLogSig-minLogSig)),:);
    
    L{end+1}=num2str(sigma);
    eta = [];
    delta_eta = [];
    phi = [];
    for ii=1:length(phi_list)
    
        myData = dataTable(dataTable(:,1)==phi_list(ii) & dataTable(:,3)==0, :);
        mySigma = myData(:,2);
        myEta = myData(:,4);
        myDeltaEta = myData(:,5);
            
        stressIndex = find(sigma==mySigma);
        if stressIndex
            eta(end+1) = myEta(stressIndex);
            delta_eta(end+1) = myDeltaEta(stressIndex);
            phi(end+1) = phi_list(ii);
        end
    end
    % transpose eta
    eta = eta';
    delta_eta = delta_eta';
    phi = phi';
    
    delta_eta_minushalf = 1/2 * eta.^(-3/2) .* delta_eta;
    
    lw = 0.75;
    if sigma == 0.5
        lw = 2;
    end

    errorbar(phi,eta.^(-1/2),delta_eta_minushalf,'o-','Color',myColor,'MarkerFaceColor',myColor,'LineWidth',lw);
end
legend(L)
return




ft1 = fittype('m*(phi0-x)');
opts = fitoptions(ft1);
opts.StartPoint = [16,0.67];
myFit1 = fit(phi(1:7),eta(1:7).^(-1/2),ft1,opts);
m = myFit1.m;
phi0 = myFit1.phi0;
plot([.15,.72],m*(phi0-[.15,.72]));
yline(0)


ci = confint(myFit1);
phi0_err = (ci(2,2)-ci(1,2))/2;
disp(phi0)
disp(phi0_err)
