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
%close
return
figure; hold on; prettyplot;
%ax1=gca; ax1.YScale='log';
ylabel('\eta (Pa s)'); 
%plot(hList,newtonianEtaVsH,'-o'); xlabel('h (mm)'); 
plot(percentGapOpen(hList), newtonianEtaVsH,'-o'); xlabel('h/d'); 

% p = polyfit(hList,newtonianEtaVsH,3);
% hFake = linspace(0.1,2);
% plot(hFake,polyval(p,hFake),'r-')

% p = polyfit(hList(end-3:end),newtonianEtaVsH(end-3:end),1);
% hFake = linspace(0.1,2);
% plot(hFake,polyval(p,hFake),'r-')
% extraH = [1.4, 2];
% plot(extraH,polyval(p,extraH),'ro')

p = polyfit(percentGapOpen(hList(end-3:end)),newtonianEtaVsH(end-3:end),1);
hdFake = linspace(0.1,0.7);
plot(hdFake,polyval(p,hdFake),'r-')
extraH = [1.4; 2];
plot(percentGapOpen(extraH),polyval(p,percentGapOpen(extraH)),'ro')

disp([newtonianEtaVsH; polyval(p,percentGapOpen(extraH))])
newtonianEtaVsH_05_09 = [newtonianEtaVsH; polyval(p,percentGapOpen(extraH))];