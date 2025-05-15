datatable = viscostdtable_05_09;
hList = unique(datatable(:,1));
percentGapOpen = @(h) 1-0.9173./(h+0.9173);

newtonianEtaVsH = zeros(size(hList));

acsDesc = 1;


% go thru stress sweeps
for ii=1:length(hList)
    h = hList(ii);
    pGap = percentGapOpen(h);
    myData = datatable(:,1)==h & datatable(:,5)==acsDesc;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    newtonianEtaVsH(ii) = mean(stress./rate);
end



figure; hold on; prettyplot;
%ax1=gca; ax1.YScale='log';
eta_solvent = 5.034;
%ylabel('\eta (Pa s)'); 
ylabel('\eta_{eff}/\eta_{true}')
hd = percentGapOpen(hList);
plot(hd, newtonianEtaVsH/eta_solvent,'-o'); xlabel('h/d'); 


A = (1*19)/(pi*(19/2)^2); % fraction of plate area covered by barrier
eta_effective = @(hd) eta_solvent*(A+hd*(1-A));


%hd = linspace(0,1);
plot(hd, eta_effective(hd)/eta_solvent,'r-');