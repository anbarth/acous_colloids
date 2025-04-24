dList = unique(phi55table(:,1));
%thisGapRheo = barrierDataTable(kk,1);
%thisGap = thisGapRheo+0.1778;
percentGapOpen = @(d) 1-0.1778./(d+0.1778);

% obtained from viscostd_rate_vs_stress_vary_d
% but i manually removed the d=1.0mm value
newtonianEtaVsD = [0.1691
    0.4863
    0.7297
    0.9799
    1.1288
    1.6072
    1.6672];

% plot stress sweeps for each d
cmap=viridis(256);
%dColor = @(d) cmap(round(1+255*(d-min(dList))/(max(dList)-min(dList))),:);
gapColor = @(pGap) cmap(round(1+255*(pGap)),:);

% figure; hold on; makeAxesLogLog;
% xlabel('\sigma (Pa)'); ylabel('rate (1/s)')
% colormap(cmap)
% c1=colorbar;
% clim([0 1])
% c1.Ticks = percentGapOpen(dList);
% 
% for ii=1:length(dList)
%     d = dList(ii);
%     pGap = percentGapOpen(d);
%     myData = phi55table(:,1)==d & phi55table(:,4)==1;
%     stress = phi55table(myData,2);
%     rate = phi55table(myData,3);
%     c = gapColor(pGap);
%     plot(stress,rate,'-o','Color',c);
%     %plot(stress(end),rate(end),'p','MarkerEdgeColor',c,'MarkerFaceColor',c,'MarkerSize',10)
%     %newtonianEtaVsD(ii) = stress(end)/rate(end);
% end
% prettyplot


figure; hold on; makeAxesLogLog;
xlabel('\sigma (Pa)'); ylabel('\eta (Pa s)')
colormap(cmap)
c1=colorbar;
clim([0 1])
c1.Ticks = percentGapOpen(dList);

for ii=1:length(dList)
    d = dList(ii);
    pGap = percentGapOpen(d);
    myData = phi55table(:,1)==d & phi55table(:,4)==2;
    stress = phi55table(myData,2);
    rate = phi55table(myData,3);
    c = gapColor(pGap);
    plot(stress,stress./rate,'-o','Color',c);
    %plot(stress(end),stress(end)/rate(end),'p','MarkerEdgeColor',c,'MarkerFaceColor',c,'MarkerSize',10)
end
prettyplot


figure; hold on; makeAxesLogLog;
xlabel('\sigma (Pa)'); ylabel('\eta_{corrected} (Pa s)')
colormap(cmap)
c1=colorbar;
clim([0 1])
c1.Ticks = percentGapOpen(dList);

for ii=1:length(dList)
    d = dList(ii);
    pGap = percentGapOpen(d);
    myData = phi55table(:,1)==d & phi55table(:,4)==2;
    stress = phi55table(myData,2);
    rate = phi55table(myData,3);
    c = gapColor(pGap);
    plot(stress,stress./rate/newtonianEtaVsD(ii)*5.034,'-o','Color',c);
    %plot(stress(end),stress(end)/rate(end),'p','MarkerEdgeColor',c,'MarkerFaceColor',c,'MarkerSize',10)
end
prettyplot

return

figure; hold on;
xlabel('fraction of gap unobstructed by barrier'); ylabel('\eta (Pa s)')
plot(percentGapOpen(dList),newtonianEtaVsD,'-o');
yline(5.034)
prettyplot;