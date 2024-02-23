my_data = ceramic_data_table_02_22;

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


phi_high = [.3, .40,0.44,.48,0.56,0.59];
minPhi = .3;
maxPhi = .6;
%cmap = flipud(viridis(256)); 
cmap = turbo;

for ii=1:length(phi_high)
    phi = phi_high(ii);
    myData = my_data(my_data(:,1)==phi & my_data(:,3)==0, :);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    
    
    plot(ax_eta,sigma,eta, '-d','Color',myColor);
    plot(ax_rate,sigma,sigma./eta, '-d','Color',myColor);
end



%colormap(cmap);
%c = colorbar;
%c.Ticks = [phi_high];
%caxis([minPhi maxPhi])
