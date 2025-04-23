dList = unique(viscostdtable(:,1));
thisGapRheo = barrierDataTable(kk,1);
thisGap = thisGapRheo+0.1778;
percentGapOccupied = @(d) 0.1778./(d+0.1778);

newtonianEtaVsD = zeros(size(dList));

% plot stress sweeps for each d
cmap=viridis(256);
%dColor = @(d) cmap(round(1+255*(d-min(dList))/(max(dList)-min(dList))),:);
gapColor = @(pGap) cmap(round(1+255*(pGap)),:);

figure; hold on; makeAxesLogLog;
xlabel('\sigma (Pa)'); ylabel('rate (1/s)')
colormap(cmap)
c1=colorbar;
clim([0 1])
c1.Ticks = flip(percentGapOccupied(dList));

for ii=1:length(dList)
    d = dList(ii);
    pGap = percentGapOccupied(d);
    myData = viscostdtable(:,1)==d & viscostdtable(:,4)==1;
    stress = viscostdtable(myData,2);
    rate = viscostdtable(myData,3);
    c = gapColor(pGap);
    plot(stress,rate,'-o','Color',c);
    plot(stress(end),rate(end),'p','MarkerEdgeColor',c,'MarkerFaceColor',c,'MarkerSize',10)
    newtonianEtaVsD(ii) = stress(end)/rate(end);
end
plot(stress,stress/5.034)
prettyplot


figure; hold on; makeAxesLogLog;
xlabel('\sigma (Pa)'); ylabel('\eta (Pa s)')
colormap(cmap)
c1=colorbar;
clim([0 1])
c1.Ticks = flip(percentGapOccupied(dList));

for ii=1:length(dList)
    d = dList(ii);
    pGap = percentGapOccupied(d);
    myData = viscostdtable(:,1)==d & viscostdtable(:,4)==1;
    stress = viscostdtable(myData,2);
    rate = viscostdtable(myData,3);
    c = gapColor(pGap);
    plot(stress,stress./rate,'-o','Color',c);
    plot(stress(end),stress(end)/rate(end),'p','MarkerEdgeColor',c,'MarkerFaceColor',c,'MarkerSize',10)
end
yline(5.034,'r')
prettyplot

figure; hold on;
xlabel('fraction of gap occupied by barrier'); ylabel('\eta (Pa s)')
plot(percentGapOccupied(dList),newtonianEtaVsD,'-o');
prettyplot;