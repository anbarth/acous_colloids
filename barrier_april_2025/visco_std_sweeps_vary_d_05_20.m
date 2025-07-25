datatable = visco_std_table_05_20;
%datatable = visco_std_table_06_17;
hList = unique(datatable(:,1));
percentGapOpen = @(h) 1-0.88./(h+0.88);

newtonianEtaVsH = zeros(size(hList));


acsDesc = 1;

% plot stress sweeps for each d
cmap=viridis(256);
%minH = 0.1; maxH = 2;
minH = min(hList); maxH = max(hList);
hColor = @(h) cmap(round(1+255*(h-minH)/(maxH-minH)),:);
%gapColor = @(pGap) cmap(round(1+255*(pGap)),:);


figure; hold on; makeAxesLogLog;
xlabel('\sigma (Pa)'); ylabel('\eta (Pa s)')
colormap(cmap)
c1=colorbar;
%clim([0 1])
%c1.Ticks = percentGapOpen(hList);
clim([minH maxH])
c1.Ticks = hList;

for ii=1:length(hList)
    h = hList(ii);
    pGap = percentGapOpen(h);
    myData = datatable(:,1)==h & datatable(:,5)==acsDesc;
    stress = datatable(myData,2);
    rate = datatable(myData,3);
    %c = gapColor(pGap);
    c=hColor(h);
    viscosity = stress./rate;
    plot(stress,viscosity,'-o','Color',c);
    newtonianEtaVsH(ii) = mean(viscosity);
    yline(newtonianEtaVsH(ii),'--','Color',c)
end
%yline(5.034,'r')
prettyplot
%close

%eta_solvent=1;
eta_solvent = 5.034;
%eta_solvent=100;

% set up plot
figure; hold on; prettyplot;
%ax1=gca; ax1.YScale='log';
%ylabel('\eta (Pa s)'); 
ylabel('\eta_{eff}')

% plot measured viscosities
hd = percentGapOpen(hList);
plot(hd, newtonianEtaVsH,'-o'); xlabel('h/d'); 

% fit to line 
p = polyfit(percentGapOpen(hList),newtonianEtaVsH,1);
hdFake = linspace(0.1,0.8);
plot(hdFake,p(2)+p(1)*hdFake,'r-')
disp('eta_solvent')
disp(p(1)+p(2))
disp('A')
disp(p(2)/(p(1)+p(2)))

% extrapolate to extra h values
extraH = [0.9; 1.4; 2];
%extraH=[];
plot(percentGapOpen(extraH),polyval(p,percentGapOpen(extraH)),'ro')
disp([newtonianEtaVsH; polyval(p,percentGapOpen(extraH))])
newtonianEtaVsH_05_20 = [newtonianEtaVsH; polyval(p,percentGapOpen(extraH))];

% compare with meera's prediction
A1 = 22.5/360; % fraction of plate area covered by barrier
A2 = 30/360;
eta_effective = @(A,hd) eta_solvent*(A+hd*(1-A));


hd = linspace(0,1);
%plot(hd, eta_effective(A1,hd),'r-');
%plot(hd, eta_effective(A2,hd),'r-');