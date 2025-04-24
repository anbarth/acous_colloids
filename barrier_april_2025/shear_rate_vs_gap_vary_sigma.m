%barrierDataTable = viscostdtable;
barrierDataTable = phi55table;
percentGapOpen = @(d) 1-0.1778./(d+0.1778);


% for each stress, plot gamma-dot vs d
figure; hold on;
ax1=gca; ax1.YScale='log';
xlabel('h/d')
ylabel('\eta (Pa s)')

% obtained from viscostd_rate_vs_stress_vary_d
% but i manually removed the d=1.0mm value
newtonianEtaVsD = [0.1691
    0.4863
    0.7297
    0.9799
    1.1288
    1.6072
    1.6672];
dList = unique(barrierDataTable(:,1));

% good indices to use: even numbers
sigmaList = unique(barrierDataTable(:,2));


% stress color
cmap = winter(256); 
minLogSigma = log(min(sigmaList));
maxLogSigma = log(max(sigmaList));
stressColor = @(sigma) cmap(round(1+255*(log(sigma)-minLogSigma)/(maxLogSigma-minLogSigma)),:);
colormap(cmap)

for sigmaNum = 1:2:length(sigmaList)
    sigma = sigmaList(sigmaNum);
    %title(strcat('\sigma = ',num2str(sigma),' Pa'))
    
    eta=[];
    hd=[];

    for kk=1:size(barrierDataTable,1)
        thisSigma = barrierDataTable(kk,2);
        if abs((thisSigma-sigma)/sigma)<0.05 && barrierDataTable(kk,4)==1
            d = barrierDataTable(kk,1);
            newtonianEta = newtonianEtaVsD(dList==d);
            rate = barrierDataTable(kk,3);
            eta(end+1) = sigma/rate * 5.034/newtonianEta;
            hd(end+1) = percentGapOpen(d);
        end
    end
    %plot(hd,eta,'o-')
    plot(hd,eta,'o-','Color',stressColor(sigma))
    
end
prettyplot;
%yline(5.034)
