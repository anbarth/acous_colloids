oldDataTable = ceramic_data_table_03_02;
dataTable = march_data_table_03_21;




fig_eta_rescaled = figure;
ax_eta_rescaled = axes('Parent', fig_eta_rescaled,'XScale','log','YScale','log');
ax_eta_rescaled.XLabel.String = '\sigma (Pa)';
ax_eta_rescaled.YLabel.String = '\eta*(\phi_0-\phi)^2 (Pa s)';
hold(ax_eta_rescaled,'on');

phi_high = [0.44,0.59];
minPhi = .3;
maxPhi = .6;
phi0=0.6804;
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
    

    plot(ax_eta_rescaled,sigma,eta*(phi0-phi)^2, '-d','Color',myColor,'LineWidth',1);
    %errorbar(ax_eta_rescaled,sigma,eta*(phi0-phi)^2,deltaEta*(phi0-phi)^2,'.','Color',myColor,'LineWidth',1);
end

phi = 0.59;
myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==60, :);
myOldData = oldDataTable(oldDataTable(:,1)==phi & oldDataTable(:,3)==0, :);
myColor = 'r';
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


plot(ax_eta_rescaled,sigma,eta*(phi0-phi)^2, '-d','Color',myColor,'LineWidth',1);
%errorbar(ax_eta_rescaled,sigma,eta*(phi0-phi)^2,deltaEta*(phi0-phi)^2,'.','Color',myColor,'LineWidth',1);


colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
c_eta.Ticks = [phi_high];
caxis(ax_eta,[minPhi maxPhi]);

% colormap(ax_eta_rescaled,cmap);
% c_eta = colorbar(ax_eta_rescaled);
% c_eta.Ticks = [phi_high];
% caxis(ax_eta_rescaled,[minPhi maxPhi])

