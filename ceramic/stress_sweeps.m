dataTable = ceramic_data_table_02_24;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\sigma (Pa)';
ax_eta.YLabel.String = '\eta (Pa s)';
hold(ax_eta,'on');

fig_rate = figure;
ax_rate = axes('Parent', fig_rate,'XScale','log','YScale','log');
ax_rate.XLabel.String = '\sigma (Pa)';
ax_rate.YLabel.String = 'shear rate (1/s)';
hold(ax_rate,'on');


phi_high = [.3,.40,0.44,.48,0.52,0.56,0.59];
minPhi = .3;
maxPhi = .6;
%cmap = flipud(viridis(256)); 
cmap = turbo;

for ii=1:length(phi_high)
    phi = phi_high(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    
    
    plot(ax_eta,sigma,eta, '-d','Color',myColor,'LineWidth',1);
    plot(ax_rate,sigma,sigma./eta, '-d','Color',myColor,'LineWidth',1);
end


colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
c_eta.Ticks = [phi_high];
caxis(ax_eta,[minPhi maxPhi])

