dataTable = phi55table;
dList = unique(dataTable(:,1));
percentGapOpen = @(d) 1-0.1778./(d+0.1778);

% plot stress sweeps for each d
cmap=viridis(256);
gapColor = @(pGap) cmap(round(1+255*(pGap)),:);


% colormap(cmap)
% c1=colorbar;
% clim([0 1])
% c1.Ticks = percentGapOpen(dList);

for ii=2
%for ii=1:length(dList)
    d = dList(ii);
    pGap = percentGapOpen(d);
    c = gapColor(pGap);

    figure; hold on; makeAxesLogLog;
    xlabel('\sigma (Pa)'); %ylabel('\eta (Pa s)')
    ylabel('rate (1/s)')
    title(strcat("h/d=",num2str(pGap)));
    
    
    myDataAsc = dataTable(:,1)==d & dataTable(:,4)==1;
    stressAsc = dataTable(myDataAsc,2);
    rateAsc = dataTable(myDataAsc,3);
    myDataDesc = dataTable(:,1)==d & dataTable(:,4)==2;
    stressDesc = dataTable(myDataDesc,2);
    rateDesc = dataTable(myDataDesc,3);
    
    
    %plot(stressAsc,stressAsc./rateAsc,'-o','Color',c);
    %plot(stressDesc,stressDesc./rateDesc,'-o','Color',c,'MarkerFaceColor',c);
    plot(stressAsc,rateAsc,'-o','Color',c);
    plot(stressDesc,rateDesc,'-o','Color',c,'MarkerFaceColor',c);
    prettyplot
end
