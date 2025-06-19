datatable = phi61table_05_20;
refdatatable = phi61_ref_table;



% plot stress sweep
figure; hold on; makeAxesLogLog;
xlabel('rate (1/s)'); ylabel('\eta (Pas)')
%ylabel('\sigma (Pa)')
stress = refdatatable(:,2);
rate = refdatatable(:,3);
plot(rate,stress./rate,'-o');
prettyplot

% plot spline
stress_in_dataset = datatable(:,2);
myStress = logspace(1.9*log10(min(stress_in_dataset)),1.2*log10(max(stress_in_dataset)));
myRatesRef = phi61_ref_rate(myStress);
plot(myRatesRef,myStress./myRatesRef,'r-')

myRates = logspace(-3, -0.2);
myStressRef = phi61_ref_stress(myRates);
plot(myRates,myStressRef./myRates,'g-')


%return

% plot predictions
hList = unique(datatable(:,1));
percentGapOpen = @(h) 1-0.88./(h+0.88);

A = 22.5/360; % fraction of plate area covered by barrier
%A = 30/360;
eta_ref = @(rate) phi61_ref_stress(rate)./rate;
eta_eff = @(rate, hd) A*eta_ref(rate) + (1-A)*hd.*eta_ref(rate.*hd);



figure; hold on; makeAxesLogLog;
xlabel('rate (1/s)'); ylabel('\eta (Pas)')
cmap=viridis(256); colormap(cmap); c1=colorbar; 
minH = min(hList); maxH = max(hList); minhd = percentGapOpen(minH); maxhd = percentGapOpen(maxH); 
hdColor = @(hd) cmap(round(1+255*(hd-minhd)/(maxhd-minhd)),:);
clim([percentGapOpen(minH) percentGapOpen(maxH)]); c1.Ticks = percentGapOpen(hList);


%for ii=1
for ii=1:length(hList)
    h = hList(ii);
    hd = percentGapOpen(h);
    myData = datatable(:,1)==h & datatable(:,5)==1;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    c = hdColor(hd);
    %plot(rate,stress./rate,'-o','Color',c);
    rate = logspace(-2.5,-0.5);
    %plot(rate,eta_eff(rate,hd),"Color",c)
    plot(rate,eta_ref(rate*hd),"Color",c)

end
plot(rate,eta_ref(rate),"Color",'k')
prettyplot




return
figure; hold on; makeAxesLogLog;
xlabel('h/d'); ylabel('\eta_{eff} (Pas)')

% stress color
sigmaList = unique(datatable(:,2));
cmap = winter(256); minLogSigma = log(min(sigmaList)); maxLogSigma = log(max(sigmaList));
stressColor = @(sigma) cmap(round(1+255*(log(sigma)-minLogSigma)/(maxLogSigma-minLogSigma)),:);
colormap(cmap); c1 = colorbar;
clim([minLogSigma maxLogSigma]); c1.Ticks = log(sigmaList); c1.TickLabels = sigmaList;

%for sigmaNum=1:3
for sigmaNum = 1:length(sigmaList)
    sigma = sigmaList(sigmaNum);
    %title(strcat('\sigma = ',num2str(sigma),' Pa'))
    

    myData = datatable(:,2)==sigma & datatable(:,5)==1;
    rate = datatable(myData,3);
    eta = sigma./rate;
    h = datatable(myData,1);
    hd = percentGapOpen(h);

    %plot(hd,eta,'o-','Color',stressColor(sigma))
    %eta_s_1 = fsolve(@(x) phi61_ref_rate(x))
    %plot()
    plot(hd,eta_eff(rate,hd),'o-','Color',stressColor(sigma))

    
end
prettyplot;
%yline(5.034)