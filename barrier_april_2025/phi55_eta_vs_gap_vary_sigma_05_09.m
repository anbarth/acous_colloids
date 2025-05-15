%barrierDataTable = phi55table_05_09;
barrierDataTable = phi61table_05_14;
percentGapOpen = @(h) 1-0.9173./(h+0.9173);


% for each stress, plot eta vs h/d
figure; hold on;
ax1=gca; ax1.YScale='log';
xlabel('h/d')
ylabel('\eta (Pa s)')



hList = unique(barrierDataTable(:,1));
%newtonianEtaVsH = ones(size(hList));
load("newtonianEtaVsH_05_09.mat")
correctionFactors = 5.034./newtonianEtaVsH_05_09;
%correctionFactors =  ones(size(hList));


sigmaList = unique(barrierDataTable(:,2));


% stress color
cmap = winter(256); 
minLogSigma = log(min(sigmaList));
maxLogSigma = log(max(sigmaList));
stressColor = @(sigma) cmap(round(1+255*(log(sigma)-minLogSigma)/(maxLogSigma-minLogSigma)),:);
colormap(cmap)
c1 = colorbar;
clim([minLogSigma maxLogSigma])
c1.Ticks = log(sigmaList);
c1.TickLabels = sigmaList;

for sigmaNum = 1:length(sigmaList)
    sigma = sigmaList(sigmaNum);
    %title(strcat('\sigma = ',num2str(sigma),' Pa'))
    
    eta=[];
    rate=[];
    hd=[];

    for kk=1:size(barrierDataTable,1)
        thisSigma = barrierDataTable(kk,2);
        if abs((thisSigma-sigma)/sigma)<0.05 && barrierDataTable(kk,5)==1
            h = barrierDataTable(kk,1);
            correctionFactor = correctionFactors(hList==h);
            myRate = barrierDataTable(kk,3);
            eta(end+1) = sigma/myRate * correctionFactor;
            hd(end+1) = percentGapOpen(h);
            rate(end+1) = myRate;
        end
    end
    %plot(hd,eta,'o-')
    plot(hd,eta,'o-','Color',stressColor(sigma))
    %plot(hd,rate,'o-','Color',stressColor(sigma))
    
end
prettyplot;
%yline(5.034)
