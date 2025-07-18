datatable = phi61table_barrier_07_16;
hList_barrier = unique(datatable(:,1));
percentGapOpen = @(h) 1-0.88./(h+0.88);

acsDesc = 1;

% plot stress sweeps for each d
cmap=viridis(256);
minH = min(hList_barrier); maxH = max(hList_barrier);  minD = min(hList_barrier)+0.88; maxD = max(hList_barrier)+0.88;
minhd = percentGapOpen(minH); maxhd = percentGapOpen(maxH);
hdColor = @(hd) cmap(round(1+255*(hd-minhd)/(maxhd-minhd)),:);
dColor = @(d) cmap(round(1+255*(d-minD)/(maxD-minD)),:);
hColor = @(h) cmap(round(1+255*(h-minH)/(maxH-minH)),:);

figure; hold on; makeAxesLogLog;
xlabel('rate (1/s)'); ylabel('\eta (Pa s)')
colormap(cmap)
c1=colorbar;
%clim([percentGapOpen(minH) percentGapOpen(maxH)]); c1.Ticks = percentGapOpen(hList_barrier);
%clim([minD maxD]); c1.Ticks=hList_barrier+0.88;
clim([minH maxH]); c1.Ticks=hList_barrier;

%for ii=1

for ii=1:length(hList_barrier)
    h = hList_barrier(ii);
    hd = percentGapOpen(h);
    myData = datatable(:,1)==h & datatable(:,5)==acsDesc;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    %c = hdColor(hd);
    %c=dColor(h+0.88);
    c=hColor(h);
    %plot(stress,stress./rate,'-o','Color',c);

    %myNewtonianEta = newtonianEtaVsH_05_09(hList==h);
    %plot(stress,stress./rate*5.034/myNewtonianEta,'-o','Color',c);
    plot(rate,stress./rate,'-o','Color',c);

    eta = stress./rate;
    dlogeta = log(eta(2:end))-log(eta(1:end-1));
    dlograte = log(rate(2:end))-log(rate(1:end-1));

end
prettyplot
title('barrier plate')
xlim([1e-3 6e-1])
ylim([1e1 1e5])



