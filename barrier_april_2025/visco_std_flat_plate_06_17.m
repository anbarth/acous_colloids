datatable = visco_std_flat_table_06_17;
hList = unique(datatable(:,1));

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
    myData = datatable(:,1)==h & datatable(:,5)==acsDesc;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    c=hColor(h);
    plot(stress,stress./rate,'-o','Color',c);
    newtonianEtaVsH(ii) = mean(stress./rate);
    yline(newtonianEtaVsH(ii),'--','Color',c)
end
%yline(5.034,'r')
prettyplot
%close

%eta_solvent=1;
%eta_solvent = 5.034;
eta_solvent=100;

% set up plot
figure; hold on; prettyplot;
%ax1=gca; ax1.YScale='log';
%ylabel('\eta (Pa s)'); 
ylabel('\eta_{eff}')

% plot measured viscosities
plot(hList, newtonianEtaVsH,'-o'); xlabel('d (mm)'); 

% fit to line 
p = polyfit(hList,newtonianEtaVsH,1);
hFake = linspace(0.1,0.8);
plot(hFake,p(2)+p(1)*hFake,'r-')
