dataTable = may_ceramic_09_17;
%dataTable = ness_data_table;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">",">"];

%CSS = 1;
CSS = (50/19)^3;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
%ax_eta = axes('Parent', fig_eta,'YScale','log');
%ax_eta.XLabel.String = '\sigma (rheometer Pa)';
%ax_eta.YLabel.String = '\eta (rheometer Pa s)';
ax_eta.XLabel.String = '\sigma (Pa)';
ax_eta.YLabel.String = '\eta (Pa s)';
hold(ax_eta,'on');

fig_rate = figure;
ax_rate = axes('Parent', fig_rate,'XScale','log','YScale','log');
ax_rate.YLabel.String = '\eta (Pa s)';
ax_rate.XLabel.String = 'shear rate (1/s)';
hold(ax_rate,'on');

% 
fig_eta_rescaled = figure;
ax_eta_rescaled = axes('Parent', fig_eta_rescaled,'XScale','log','YScale','log');
ax_eta_rescaled.XLabel.String = '\sigma (rheometer Pa)';
ax_eta_rescaled.YLabel.String = '\eta*(\phi_0-\phi)^2 (rheometer Pa s)';
hold(ax_eta_rescaled,'on');

%phi_high = [0.44,0.48,0.52,0.56,0.59];
phi_list = unique(dataTable(:,1));
%phi_list_plot = phi_list(1:end);
plot_indices = 1:length(phi_list);
%plot_indices=10:11;

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

phi0=0.7;
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
    deltaEta = max(myData(:,5),eta*0.15);
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    deltaEta = deltaEta(sortIdx);
    delta_phi = 0.02;
    delta_eta_volumefraction = eta*2*(phi0-phi)^(-1)*delta_phi;
    delta_eta_total = sqrt(deltaEta.^2+delta_eta_volumefraction.^2);
    
    %plot(ax_eta,sigma,eta, '-d','Color',myColor,'LineWidth',2);
    myMarker = my_vol_frac_markers(ii);
    
    
    errorbar(ax_eta,sigma*CSS,eta*CSS, delta_eta_total*CSS,strcat(myMarker,'-'),'Color',myColor,'LineWidth',1,'MarkerFaceColor',myColor);
    %plot(ax_eta,sigma,eta, strcat(myMarker,'-'),'Color',myColor,'LineWidth',1.5,'MarkerFaceColor',myColor);
    
    %plot(ax_rate,sigma./eta,sigma*CSS, '-d','Color',myColor,'LineWidth',1);
    rate_err = deltaEta./eta.*sigma./eta;
    %errorbar(ax_rate,sigma./eta,sigma*CSS,rate_err,"horizontal",'-d','Color',myColor,'LineWidth',1,'MarkerFaceColor',myColor)
    errorbar(ax_rate,sigma./eta,eta*CSS,delta_eta_total*CSS,delta_eta_total*CSS,rate_err,rate_err,'-d','Color',myColor,'LineWidth',1,'MarkerFaceColor',myColor)

    plot(ax_eta_rescaled,sigma,eta*(phi0-phi_fudged)^2, '-d','Color',myColor,'LineWidth',1);
    errorbar(ax_eta_rescaled,sigma,eta*(phi0-phi)^2,deltaEta*(phi0-phi)^2,'.','Color',myColor,'LineWidth',1);
end

colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
c_eta.Ruler.TickLabelFormat='%.2f';
c_eta.Ticks = round((phi_list+phi_fudge')*100)/100;
clim(ax_eta,[minPhi maxPhi]);


close(fig_rate)
close(fig_eta_rescaled)


% colormap(ax_eta_rescaled,cmap);
% c_eta = colorbar(ax_eta_rescaled);
% c_eta.Ticks = [phi_high];
% caxis(ax_eta_rescaled,[minPhi maxPhi])
%close(fig_eta_rescaled)
