dataTable = chris_table_04_25;




fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = 'Stress \sigma a^2/f*';
ax_eta.YLabel.String = 'Viscosity \sigma/\eta\cdot rate';
hold(ax_eta,'on');
prettyplot

fig_rate = figure;
ax_rate = axes('Parent', fig_rate,'XScale','log','YScale','log');
ax_rate.YLabel.String = 'Stress \sigma a^2/f*';
ax_rate.XLabel.String = 'Rate \eta a^2 \gamma / f*';
hold(ax_rate,'on');
prettyplot

fig_eta_rescaled = figure;
ax_eta_rescaled = axes('Parent', fig_eta_rescaled,'XScale','log','YScale','log');
ax_eta_rescaled.XLabel.String = '\sigma (rheometer Pa)';
ax_eta_rescaled.YLabel.String = '\eta*(\phi_0-\phi)^2 (rheometer Pa s)';
hold(ax_eta_rescaled,'on');
prettyplot

%phi_high = [0.44,0.48,0.52,0.56,0.59];
phi_list = unique(dataTable(:,1));
%phi_list_plot = phi_list(1:end);
plot_indices = 1:length(phi_list);



cmap = viridis(256);
minPhi = min(phi_list);
maxPhi = max(phi_list);
colorPhi = @(phi) cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
minEta = min(dataTable(:,4));
maxEta = max(dataTable(:,4));
colorEta = @(eta) cmap(round(1+255*(log(eta)-log(minEta))/(log(maxEta)-log(minEta))),:);





for ii=1:length(phi_list)
    if ~ismember(ii,plot_indices)
        continue
    end
    phi = phi_list(ii);
    %phi_fudged = phi+phi_fudge(ii);
    phi_fudged = phi;
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    
    sigma = myData(:,2);
    eta = myData(:,4);
    deltaEta = myData(:,5);
    
    %myColor = colorEta(eta);
    myColor = colorPhi(phi);

    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    deltaEta = deltaEta(sortIdx);
    
    myMarker = "o";

    plot(ax_eta,sigma,eta, strcat(myMarker,'-'),'Color',myColor,'LineWidth',1.5,'MarkerFaceColor',myColor);
    
    plot(ax_rate,sigma./eta,sigma, '-d','Color',myColor,'LineWidth',1);


    plot(ax_eta_rescaled,sigma,eta*(0.646-phi)^2, '-d','Color',myColor,'LineWidth',1);
end

colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
%c_eta.Ticks = round((phi_list)*1000)/1000;
clim(ax_eta,[minPhi maxPhi]);


%ylim([10 10^5])


% colormap(ax_eta_rescaled,cmap);
% c_eta = colorbar(ax_eta_rescaled);
% c_eta.Ticks = [phi_high];
% caxis(ax_eta_rescaled,[minPhi maxPhi])
%close(fig_eta_rescaled)
