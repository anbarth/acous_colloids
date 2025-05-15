%datatable = phi55table_05_09;
datatable = phi61table_05_14;
hList = unique(datatable(:,1));
percentGapOpen = @(h) 1-0.9173./(h+0.9173);

load("newtonianEtaVsH_05_09.mat") % made in visco_std_sweeps_vary_d_05_09

acsDesc = 1;

% plot stress sweeps for each d
cmap=viridis(256);
minH = min(hList); maxH = max(hList);
%hColor = @(h) cmap(round(1+255*(h-minH)/(maxH-minH)),:);
%hdColor = @(pGap) cmap(round(1+255*(pGap)),:);
minhd = percentGapOpen(minH); maxhd = percentGapOpen(maxH);
hdColor = @(hd) cmap(round(1+255*(hd-minhd)/(maxhd-minhd)),:);

figure; hold on; makeAxesLogLog;
xlabel('\sigma (Pa)'); ylabel('\eta (Pa s)')
colormap(cmap)
c1=colorbar;
clim([percentGapOpen(minH) percentGapOpen(maxH)])
c1.Ticks = percentGapOpen(hList);
%clim([minH maxH])
%c1.Ticks = hList;

%for ii=1
for ii=1:length(hList)
    h = hList(ii);
    hd = percentGapOpen(h);
    myData = datatable(:,1)==h & datatable(:,5)==acsDesc;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    c = hdColor(hd);
    %c=hColor(h);
    %plot(stress,stress./rate,'-o','Color',c);

    myNewtonianEta = newtonianEtaVsH_05_09(hList==h);
    plot(stress,stress./rate*5.034/myNewtonianEta,'-o','Color',c);
end
prettyplot

