datatable = phi55table_05_09;
hList = unique(datatable(:,1));
hMax = max(hList);

percentGapOpen = @(h) 1-0.9173./(h+0.9173);


hMax_data = datatable(:,1)==hMax & datatable(:,5)==1;
ref_stress = datatable(hMax_data,2);
ref_rate = datatable(hMax_data,3);
% build a spline for stress(rate)
%pp = spline(ref_rate,ref_stress);
pp = csaps(ref_rate,ref_stress);
pp = fnxtr(pp); 
phi55_hMax_ref_stress = @(rate) ppval(pp,rate);
% plot the spline
figure; hold on; makeAxesLogLog;
xlabel('rate (1/s)'); ylabel('\eta (Pas)')
plot(ref_rate,ref_stress./ref_rate,'ko');
rate = logspace(-2.5,0);
plot(rate,phi55_hMax_ref_stress(rate)./rate,'k-');


% plot predictions
figure; hold on; makeAxesLogLog;
xlabel('rate (1/s)'); ylabel('\eta (Pas)')
cmap=viridis(256); colormap(cmap); c1=colorbar; 
minH = min(hList); maxH = max(hList); minhd = percentGapOpen(minH); maxhd = percentGapOpen(maxH); 
hdColor = @(hd) cmap(round(1+255*(hd-minhd)/(maxhd-minhd)),:);
clim([percentGapOpen(minH) percentGapOpen(maxH)]); c1.Ticks = percentGapOpen(hList);

A = 0.84*50 / (pi*50^2); % fraction of plate area covered by barrier
eta_ref = @(rate) phi55_hMax_ref_stress(rate)./rate;
eta_eff = @(rate, hd) A*eta_ref(rate) + (1-A)*hd.*eta_ref(rate.*hd);

%for ii=1
for ii=1:length(hList)
    h = hList(ii);
    hd = percentGapOpen(h);
    myData = datatable(:,1)==h & datatable(:,5)==1;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    c = hdColor(hd);
    %plot(rate,stress./rate,'-o','Color',c);
    rate = logspace(-2.5,0);
    %plot(rate,eta_eff(rate,hd),"Color",c)
    plot(rate,eta_ref(rate*hd),"Color",c)

end
plot(rate,eta_ref(rate),"Color",'k')
prettyplot
