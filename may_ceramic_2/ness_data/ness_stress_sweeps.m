%dataTable = ness_data_table;
dataTable = ness_data_table_exclude_low_phi;
%my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">",">"];




fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
%ax_eta = axes('Parent', fig_eta,'YScale','log');
%ax_eta.XLabel.String = '\sigma (rheometer Pa)';
%ax_eta.YLabel.String = '\eta (rheometer Pa s)';
ax_eta.XLabel.String = 'Stress \sigma a^2/fstar';
ax_eta.YLabel.String = 'Viscosity \sigma/\eta\cdot rate';
hold(ax_eta,'on');

% fig_rate = figure;
% ax_rate = axes('Parent', fig_rate,'XScale','log','YScale','log');
% ax_rate.YLabel.String = '\eta (Pa s)';
% ax_rate.XLabel.String = 'shear rate (1/s)';
% hold(ax_rate,'on');
% 
% fig_eta_rescaled = figure;
% ax_eta_rescaled = axes('Parent', fig_eta_rescaled,'XScale','log','YScale','log');
% ax_eta_rescaled.XLabel.String = '\sigma (rheometer Pa)';
% ax_eta_rescaled.YLabel.String = '\eta*(\phi_0-\phi)^2 (rheometer Pa s)';
% hold(ax_eta_rescaled,'on');

%phi_high = [0.44,0.48,0.52,0.56,0.59];
phi_list = unique(dataTable(:,1));
%phi_list_plot = phi_list(1:end);
plot_indices = 1:length(phi_list);


%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); 
phi_fudge = zeros(1,length(phi_list)); phi0 = 0.718;
%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_handpicked_10_28,13); 


%minPhi = 0.18;
%maxPhi = 0.62;

minPhi = min(phi_list);
maxPhi = max(phi_list);

%minPhi = min(phi_list_plot);
%maxPhi = max(phi_list_plot);
%phi0=0.7;
%cmap = flipud(viridis(256)); 
%cmap = turbo;
cmap = viridis(256);

for ii=1:length(phi_list)
    if ~ismember(ii,plot_indices)
        continue
    end
    phi = phi_list(ii);
    phi_fudged = phi+phi_fudge(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    myColor = cmap(round(1+255*(phi_fudged-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    deltaEta = myData(:,5);
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    deltaEta = deltaEta(sortIdx);
    
    %plot(ax_eta,sigma,eta, '-d','Color',myColor,'LineWidth',2);
    %myMarker = my_vol_frac_markers(ii);
    myMarker = "o";
    %plot(ax_eta,sigma*19,eta*25, strcat(myMarker,'-'),'Color',myColor,'LineWidth',1.5,'MarkerFaceColor',myColor);
    plot(ax_eta,sigma,eta, strcat(myMarker,'-'),'Color',myColor,'LineWidth',1.5,'MarkerFaceColor',myColor);
    
    %plot(ax_rate,sigma./eta,eta, '-d','Color',myColor,'LineWidth',1);
    %errorbar(ax_rate,sigma,sigma./eta,deltaEta./eta.^2,'.','Color',myColor,'LineWidth',1);

    %plot(ax_eta_rescaled,sigma,eta*(phi0-phi_fudged)^2, '-d','Color',myColor,'LineWidth',1);
    %errorbar(ax_eta_rescaled,sigma,eta*(phi0-phi)^2,deltaEta*(phi0-phi)^2,'.','Color',myColor,'LineWidth',1);
end

colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
c_eta.Ticks = round((phi_list+phi_fudge')*1000)/1000;
clim(ax_eta,[minPhi maxPhi]);


ylim([10 10^5])


% colormap(ax_eta_rescaled,cmap);
% c_eta = colorbar(ax_eta_rescaled);
% c_eta.Ticks = [phi_high];
% caxis(ax_eta_rescaled,[minPhi maxPhi])
%close(fig_eta_rescaled)
