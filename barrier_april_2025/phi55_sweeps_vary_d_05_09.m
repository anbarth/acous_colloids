datatable = phi55table_05_09;
%datatable = phi61table_05_14;
hList_barrier = unique(datatable(:,1));
percentGapOpen = @(h) 1-0.9173./(h+0.9173);

load("newtonianEtaVsH_05_09.mat") % made in visco_std_sweeps_vary_d_05_09

acsDesc = 1;

% plot stress sweeps for each d
cmap=viridis(256);
minH = min(hList_barrier); maxH = max(hList_barrier);
%hColor = @(h) cmap(round(1+255*(h-minH)/(maxH-minH)),:);
%hdColor = @(pGap) cmap(round(1+255*(pGap)),:);
minhd = percentGapOpen(minH); maxhd = percentGapOpen(maxH);
hdColor = @(hd) cmap(round(1+255*(hd-minhd)/(maxhd-minhd)),:);

figure; hold on; makeAxesLogLog;
xlabel('rate (1/s)'); ylabel('\eta (Pa s)')
colormap(cmap)
c1=colorbar;
clim([percentGapOpen(minH) percentGapOpen(maxH)])
c1.Ticks = percentGapOpen(hList_barrier);
%clim([minH maxH])
%c1.Ticks = hList;

%for ii=1
beta_barrier = zeros(size(hList_barrier));
for ii=1:length(hList_barrier)
    h = hList_barrier(ii);
    hd = percentGapOpen(h);
    myData = datatable(:,1)==h & datatable(:,5)==acsDesc;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    c = hdColor(hd);
    %c=hColor(h);
    %plot(stress,stress./rate,'-o','Color',c);

    %myNewtonianEta = newtonianEtaVsH_05_09(hList==h);
    %plot(stress,stress./rate*5.034/myNewtonianEta,'-o','Color',c);
    plot(rate,stress./rate,'-o','Color',c);

    eta = stress./rate;
    dlogeta = log(eta(2:end))-log(eta(1:end-1));
    dlograte = log(rate(2:end))-log(rate(1:end-1));
    beta_barrier(ii) = max(dlogeta./dlograte);
end
prettyplot
return
% add reference
refdatatable = phi56_ref_table;
stress = refdatatable(:,2);
rate = refdatatable(:,3);
plot(rate,stress./rate,'-ok');

