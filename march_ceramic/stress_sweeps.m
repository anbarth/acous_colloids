oldDataTable = ceramic_data_table_03_02;
dataTable = march_data_table_04_02;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\sigma (rheometer Pa)';
ax_eta.YLabel.String = '\eta (rheometer Pa s)';
hold(ax_eta,'on');

% fig_rate = figure;
% ax_rate = axes('Parent', fig_rate,'XScale','log','YScale','log');
% ax_rate.XLabel.String = '\sigma (Pa)';
% ax_rate.YLabel.String = 'shear rate (1/s)';
% hold(ax_rate,'on');
% 
fig_eta_rescaled = figure;
ax_eta_rescaled = axes('Parent', fig_eta_rescaled,'XScale','log','YScale','log');
ax_eta_rescaled.XLabel.String = '\sigma (rheometer Pa)';
ax_eta_rescaled.YLabel.String = '\eta*(\phi_0-\phi)^2 (rheometer Pa s)';
hold(ax_eta_rescaled,'on');

phi_high = [0.44,0.48,0.52,0.56,0.59];
minPhi = .3;
maxPhi = .6;
phi0=0.66;
%cmap = flipud(viridis(256)); 
cmap = turbo;

for ii=1:length(phi_high)
    phi = phi_high(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    myOldData = oldDataTable(oldDataTable(:,1)==phi & oldDataTable(:,3)==0, :);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    deltaEta = myData(:,5);

    sigmaOld = myOldData(:,2);
    etaOld = myOldData(:,4);
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    deltaEta = deltaEta(sortIdx);

    [sigmaOld,sortIdx] = sort(sigmaOld,'ascend');
    etaOld = etaOld(sortIdx);
    
    plot(ax_eta,sigma,eta, '-d','Color',myColor,'LineWidth',1);
    %plot(ax_eta,sigma*19,eta*25, '-d','Color',myColor,'LineWidth',1);
    plot(ax_eta,sigmaOld/19,etaOld/25, '--o','Color',myColor,'LineWidth',1);
    
    %plot(ax_rate,sigma,sigma./eta, '-d','Color',myColor,'LineWidth',1);
    %errorbar(ax_rate,sigma,sigma./eta,deltaEta./eta.^2,'.','Color',myColor,'LineWidth',1);

    plot(ax_eta_rescaled,sigma,eta*(phi0-phi)^2, '-d','Color',myColor,'LineWidth',1);
    %errorbar(ax_eta_rescaled,sigma,eta*(phi0-phi)^2,deltaEta*(phi0-phi)^2,'.','Color',myColor,'LineWidth',1);
end


colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
c_eta.Ticks = [phi_high];
caxis(ax_eta,[minPhi maxPhi]);

% colormap(ax_eta_rescaled,cmap);
% c_eta = colorbar(ax_eta_rescaled);
% c_eta.Ticks = [phi_high];
% caxis(ax_eta_rescaled,[minPhi maxPhi])

