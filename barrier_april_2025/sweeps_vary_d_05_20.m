barrierdatatable = phi61table_05_20;


refdatatable = phi61_ref_table;
%datatable = [barrierdatatable;refdatatable];
datatable = barrierdatatable;
hList = unique(datatable(:,1));
percentGapOpen = @(h) 1-0.88./(h+0.88);

acsDesc = 1;

load("newtonianEtaVsH_05_20_corrected.mat")

% plot stress sweeps for each d
cmap=viridis(256);
minH = min(hList); maxH = max(hList);
%hColor = @(h) cmap(round(1+255*(h-minH)/(maxH-minH)),:);
%hdColor = @(pGap) cmap(round(1+255*(pGap)),:);
minhd = percentGapOpen(minH); maxhd = percentGapOpen(maxH);
hdColor = @(hd) cmap(round(1+255*(hd-minhd)/(maxhd-minhd)),:);

figure; hold on; makeAxesLogLog;
%xlabel('\sigma (Pa)'); ylabel('rate (1/s)')
xlabel('rate (1/s)'); ylabel('\eta (Pas)')
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
    %plot(stress,rate,'-o','Color',c);
    plot(rate,stress./rate,'-o','Color',c);

    %myNewtonianEta = newtonianEtaVsH_05_20(hList==h);
    %plot(stress,stress./rate*5.034/myNewtonianEta,'-o','Color',c);
end
prettyplot

% stress_in_dataset = datatable(:,2);
% myStress = logspace(log10(min(stress_in_dataset)),1.2*log10(max(stress_in_dataset)));
% myRatesRef = phi61_ref_rate(myStress);
% plot(myRatesRef,myStress./myRatesRef,'r-')