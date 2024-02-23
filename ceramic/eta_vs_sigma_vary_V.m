dataTable = ceramic_data_table_02_22;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\sigma (Pa)';
ax_eta.YLabel.String = '\eta (Pa s)';
hold(ax_eta,'on');

phi = 0.59;
volt_list = [0,5,10,20,40,60,80,100];

for ii=1:length(volt_list)
    V = volt_list(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==V, :);
    myColor = cmap(round(1+255*V/100),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    
    plot(ax_eta,sigma,eta, '-d','Color',myColor);

end