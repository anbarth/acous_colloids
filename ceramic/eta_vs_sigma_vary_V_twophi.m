dataTable = ceramic_data_table_02_25;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\sigma (Pa)';
ax_eta.YLabel.String = '\eta(\phi_0-\phi)^2 (Pa s)';
hold(ax_eta,'on');
cmap = plasma(256);
colormap(ax_eta,cmap);

phi1 = 0.44;
phi2 = 0.59;
phi0 = 0.6804;
volt_list = [0,5,10,20,40,60,80,100];

for ii=1:length(volt_list)
    V = volt_list(ii);
    myData1 = dataTable(dataTable(:,1)==phi1 & dataTable(:,3)==V, :);
    myColor = cmap(round(1+255*V/100),:);
    sigma1 = myData1(:,2);
    eta1 = myData1(:,4);
    
    % sort in order of ascending sigma
    [sigma1,sortIdx] = sort(sigma1,'ascend');
    eta1 = eta1(sortIdx);
    
    plot(ax_eta,sigma1,eta1*(phi0-phi1)^2, '-d','Color',myColor);

    myData2 = dataTable(dataTable(:,1)==phi2 & dataTable(:,3)==V, :);
    myColor = cmap(round(1+255*V/100),:);
    sigma2 = myData2(:,2);
    eta2 = myData2(:,4);
    
    % sort in order of ascending sigma
    [sigma2,sortIdx] = sort(sigma2,'ascend');
    eta2 = eta2(sortIdx);
    
    plot(ax_eta,sigma2,eta2*(phi0-phi2)^2, '--o','Color',myColor);

end


c1 = colorbar(ax_eta);
caxis(ax_eta,[0 100]);
c1.Ticks = [0,5,10,20,40,60,80,100];