barrierDataTable = viscostdtable;
%barrierDataTable = phi55table;

% for each stress, plot gamma-dot vs d
figure; hold on;
ax1=gca; ax1.YScale='log';

% good indices to use: even numbers
sigmaList = unique(barrierDataTable(:,2));


% stress color
cmap = viridis(256); 
minLogSigma = log(min(sigmaList));
maxLogSigma = log(max(sigmaList));
stressColor = @(sigma) cmap(round(1+255*(log(sigma)-minLogSigma)/(maxLogSigma-minLogSigma)),:);

for sigmaNum = 1:6:length(sigmaList)
    sigma = sigmaList(sigmaNum);
    %disp(sigma)
    for kk=1:size(barrierDataTable,1)
        thisSigma = barrierDataTable(kk,2);
        if abs((thisSigma-sigma)/sigma)<0.05 && barrierDataTable(kk,4)==1
            %disp(barrierDataTable(kk,:))
            thisGapRheo = barrierDataTable(kk,1);
            thisGap = thisGapRheo+0.1778;
            percentGapOccupied = 0.1778/thisGap;
            %disp(percentGapOccupied)
            thisRate = barrierDataTable(kk,3);
            %plot(percentGapOccupied,thisRate,'o','MarkerFaceColor',stressColor(thisSigma),'MarkerEdgeColor',stressColor(thisSigma));
            %plot(thisGap,thisRate,'o','MarkerFaceColor',stressColor(thisSigma),'MarkerEdgeColor',stressColor(thisSigma));
            plot(percentGapOccupied,sigma./thisRate,'o','MarkerFaceColor',stressColor(thisSigma),'MarkerEdgeColor',stressColor(thisSigma));
        end
    end
    %rate_newtonian = sigma/5.034;
    %yline(rate_newtonian);
    
end
%yline(5.034)
