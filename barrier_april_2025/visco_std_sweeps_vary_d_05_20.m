datatable = visco_std_table_05_20;
hList = unique(datatable(:,1));
percentGapOpen = @(h) 1-0.88./(h+0.88);

newtonianEtaVsH = zeros(size(hList));

acsDesc = 1;

% plot stress sweeps for each d
cmap=viridis(256);
%minH = 0.1; maxH = 2;
minH = min(hList); maxH = max(hList);
hColor = @(h) cmap(round(1+255*(h-minH)/(maxH-minH)),:);
%gapColor = @(pGap) cmap(round(1+255*(pGap)),:);


figure; hold on; makeAxesLogLog;
xlabel('\sigma (Pa)'); ylabel('\eta (Pa s)')
colormap(cmap)
c1=colorbar;
%clim([0 1])
%c1.Ticks = percentGapOpen(hList);
clim([minH maxH])
c1.Ticks = hList;

for ii=1:length(hList)
    h = hList(ii);
    pGap = percentGapOpen(h);
    myData = datatable(:,1)==h & datatable(:,5)==acsDesc;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    %c = gapColor(pGap);
    c=hColor(h);
    plot(stress,stress./rate,'-o','Color',c);
    newtonianEtaVsH(ii) = mean(stress./rate);
    yline(newtonianEtaVsH(ii),'--','Color',c)
end
%yline(5.034,'r')
prettyplot

%eta_solvent=1;
eta_solvent = 5.034;

% set up plot
figure; hold on; prettyplot;
%ax1=gca; ax1.YScale='log';
ylabel('\eta (Pa s)'); 
ylabel('\eta_{eff}/\eta_{true}')

% plot measured viscosities
hd = percentGapOpen(hList);
plot(hd, newtonianEtaVsH/eta_solvent,'-o'); xlabel('h/d'); 

% fit to line 
p = polyfit(percentGapOpen(hList),newtonianEtaVsH,1);
hdFake = linspace(0.1,0.7);
plot(hdFake,polyval(p,hdFake)/eta_solvent,'r-')

% extrapolate to extra h values
extraH = [0.9; 1.4; 2];
plot(percentGapOpen(extraH),polyval(p,percentGapOpen(extraH))/eta_solvent,'ro')
disp([newtonianEtaVsH; polyval(p,percentGapOpen(extraH))])
newtonianEtaVsH_05_20 = [newtonianEtaVsH; polyval(p,percentGapOpen(extraH))];

% compare with meera's prediction
A = (1*19)/(pi*(19/2)^2); % fraction of plate area covered by barrier
eta_effective = @(hd) eta_solvent*(A+hd*(1-A));


%hd = linspace(0,1);
plot(hd, eta_effective(hd)/eta_solvent,'r-');