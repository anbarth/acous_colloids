
dataTable = march_data_table_05_02;

% collapse_params; % just to get f(sigma) and phi0
% % from best_fit_power_law_0V (but including all the voltages lol)
% myConst = 0.0042;
% myDelta = -1.4663;

f = @(sigma,jj) exp(-sigmastar(jj)./sigma);
[myConst, phi0, myDelta, sigmastar, C] = unzipParams(y_optimal,9);


fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\sigma (rheometer Pa)';
ax_eta.YLabel.String = '\eta (rheometer Pa s)';
hold(ax_eta,'on');

% 
fig_eta_rescaled = figure;
ax_eta_rescaled = axes('Parent', fig_eta_rescaled,'XScale','log','YScale','log');
ax_eta_rescaled.XLabel.String = '\sigma (rheometer Pa)';
ax_eta_rescaled.YLabel.String = '\eta*(\phi_0-\phi)^2 (rheometer Pa s)';
hold(ax_eta_rescaled,'on');


phi_list = unique(dataTable(:,1));


minPhi = min(phi_list);
maxPhi = max(phi_list);

cmap = turbo;

for ii=1:length(phi_list)
    phi = phi_list(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    deltaEta = myData(:,5);

    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    deltaEta = deltaEta(sortIdx);

    plot(ax_eta,sigma,eta, 'd','Color',myColor,'LineWidth',1);

    sigmaFake = logspace(log10(min(sigma)),log10(max(sigma)));
    etaFit = myConst * (phi0-phi)^-2 * (1-f(sigmaFake,jj)*C(ii,jj)/(phi0-phi)).^myDelta;
    plot(ax_eta,sigmaFake,etaFit,'Color',myColor);
   
    plot(ax_eta_rescaled,sigma,eta*(phi0-phi)^2, 'd','Color',myColor,'LineWidth',1);
    plot(ax_eta_rescaled,sigmaFake,etaFit*(phi0-phi)^2,'Color',myColor);

end

colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
c_eta.Ticks = phi_list;
clim(ax_eta,[minPhi maxPhi]);

close(fig_eta_rescaled)