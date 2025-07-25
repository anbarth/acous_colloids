datatable = phi61table_pp_07_16;
hList_barrier = unique(datatable(:,1));

acsDesc = 1;

% plot stress sweeps for each d
hList_pp = unique(datatable(:,1)); minD = min(hList_pp); maxD = max(hList_pp);
cmap=viridis(256);
dColor = @(d) cmap(round(1+255*(d-minD)/(maxD-minD)),:);

figure; hold on; makeAxesLogLog;
xlabel('rate (1/s)'); ylabel('\eta (Pas)')
colormap(cmap)
c1=colorbar;
clim([minD maxD])
c1.Ticks = hList_pp;

%for ii=1
for ii=1:length(hList_pp)
    d = hList_pp(ii);
    myData = datatable(:,1)==d; % & datatable(:,5)==acsDesc;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    c = dColor(d);
    %c=hColor(h);
    %plot(stress,rate,'-o','Color',c);
    plot(rate,stress./rate,'-o','Color',c);

    %myNewtonianEta = newtonianEtaVsH_05_20(hList==h);
    %plot(stress,stress./rate*5.034/myNewtonianEta,'-o','Color',c);
    
    eta = stress./rate;
    dlogeta = log(eta(2:end))-log(eta(1:end-1));
    dlograte = log(rate(2:end))-log(rate(1:end-1));
end
prettyplot

title('parallel plate')
xlim([1e-3 6e-1])
ylim([1e1 1e5])