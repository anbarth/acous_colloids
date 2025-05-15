dataTable = phi61table_05_14;
hList = unique(dataTable(:,1));
percentGapOpen = @(h) 1-0.9173./(h+0.9173);

% plot stress sweeps for each d
cmap=viridis(256);
gapColor = @(pGap) cmap(round(1+255*(pGap)),:);


% colormap(cmap)
% c1=colorbar;
% clim([0 1])
% c1.Ticks = percentGapOpen(dList);

%for ii=1
for ii=1:length(hList)
    h = hList(ii);
    pGap = percentGapOpen(h);
    c = gapColor(pGap);

    figure; hold on; makeAxesLogLog;
    xlabel('\sigma (Pa)'); 
    ylabel('\eta (Pa s)')
    %ylabel('rate (1/s)')
    title(strcat("h=",num2str(h),"mm, h/d=",num2str(pGap)));
    
    
    myDataAsc = dataTable(:,1)==h & dataTable(:,5)==1;
    stressAsc = dataTable(myDataAsc,2);
    rateAsc = dataTable(myDataAsc,3);
    myDataDesc = dataTable(:,1)==h & dataTable(:,5)==2;
    stressDesc = dataTable(myDataDesc,2);
    rateDesc = dataTable(myDataDesc,3);
    
    
    plot(stressAsc,stressAsc./rateAsc,'-o','Color',c);
    plot(stressDesc,stressDesc./rateDesc,'-o','Color',c,'MarkerFaceColor',c);
   % plot(stressAsc,rateAsc,'-o','Color',c);
   % plot(stressDesc,rateDesc,'-o','Color',c,'MarkerFaceColor',c);
    prettyplot
    myfig = gcf;
    myfig.Position = [739,167,429,420];
    
end
