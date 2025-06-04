barrierdatatable = phi61table_05_20;
refdatatable = phi61_ref_table;
datatable = [barrierdatatable;refdatatable];
hList = unique(datatable(:,1));
percentGapOpen = @(h) 1-0.88./(h+0.88);


% reference viscosity
ref_sigma = refdatatable(:,2);
ref_rate = refdatatable(:,3);

acsDesc = 1;

% plot stress sweeps for each d
cmap=viridis(256);
minH = min(hList); maxH = max(hList);
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
    
    [overlap_stresses,i_ref,i_h] = intersect(ref_sigma,stress);
    eta_ref = ref_sigma(i_ref)./ref_rate(i_ref);
    eta_h = stress(i_h)./rate(i_h);
    plot(overlap_stresses,eta_h./eta_ref,'-o','Color',c);


end
prettyplot