dList = unique(viscostdtable(:,1));
%thisGapRheo = barrierDataTable(kk,1);
%thisGap = thisGapRheo+0.1778;
percentGapOpen = @(d) 1-0.1778./(d+0.1778);

newtonianEtaVsD = zeros(size(dList));

acsDesc = 2;

% plot stress sweeps for each d
cmap=viridis(256);
%dColor = @(d) cmap(round(1+255*(d-min(dList))/(max(dList)-min(dList))),:);
gapColor = @(pGap) cmap(round(1+255*(pGap)),:);

figure; hold on; makeAxesLogLog;
xlabel('\sigma (Pa)'); ylabel('rate (1/s)')
colormap(cmap)
c1=colorbar;
clim([0 1])
c1.Ticks = percentGapOpen(dList);

for ii=1:length(dList)
    d = dList(ii);
    pGap = percentGapOpen(d);
    myData = viscostdtable(:,1)==d & viscostdtable(:,4)==acsDesc;
    stress = viscostdtable(myData,2);
    rate = viscostdtable(myData,3);
    c = gapColor(pGap);
    plot(stress,rate,'-o','Color',c);
    plot(stress(stress==max(stress)),rate(stress==max(stress)),'p','MarkerEdgeColor',c,'MarkerFaceColor',c,'MarkerSize',10)
    newtonianEtaVsD(ii) = stress(stress==max(stress))/rate(stress==max(stress));
end
plot(stress,stress/5.034)
prettyplot


figure; hold on; makeAxesLogLog;
xlabel('\sigma (Pa)'); ylabel('\eta (Pa s)')
colormap(cmap)
c1=colorbar;
clim([0 1])
c1.Ticks = percentGapOpen(dList);

for ii=1:length(dList)
    d = dList(ii);
    pGap = percentGapOpen(d);
    myData = viscostdtable(:,1)==d & viscostdtable(:,4)==acsDesc;
    stress = viscostdtable(myData,2);
    rate = viscostdtable(myData,3);
    c = gapColor(pGap);
    plot(stress,stress./rate,'-o','Color',c);
    plot(stress(stress==max(stress)),stress(stress==max(stress))/rate(stress==max(stress)),'p','MarkerEdgeColor',c,'MarkerFaceColor',c,'MarkerSize',10)
end
yline(5.034,'r')
prettyplot

figure; hold on;
xlabel('fraction of gap unobstructed by barrier'); ylabel('\eta (Pa s)')
plot(percentGapOpen(dList),newtonianEtaVsD,'-o');
prettyplot;
disp(newtonianEtaVsD)