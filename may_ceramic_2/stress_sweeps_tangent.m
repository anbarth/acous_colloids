dataTable = may_ceramic_09_17;
%dataTable = ness_data_table;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">",">"];

CSS = 1;
%CSS = (50/19)^3;

%phi_high = [0.44,0.48,0.52,0.56,0.59];
phi_list = unique(dataTable(:,1));
%phi_list_plot = phi_list(1:end);
plot_indices = 1:length(phi_list);


minPhi = min(phi_list);
maxPhi = max(phi_list);
cmap = viridis(256);

figure; hold on;
makeAxesLogLog;
xlabel('\sigma (Pa)')
ylabel('\eta tangent (Pa s)')
for ii=1:length(phi_list)
    if ~ismember(ii,plot_indices)
        continue
    end
    phi = phi_list(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    deltaEta = myData(:,5);
    rate = sigma./eta;
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    deltaEta = deltaEta(sortIdx);
    rate = rate(sortIdx);
    delta_phi = 0.02;
    delta_eta_volumefraction = eta*2*(phi0-phi)^(-1)*delta_phi;
    delta_eta_total = sqrt(deltaEta.^2+delta_eta_volumefraction.^2);

    % calculate eta tangent
    dsigma = sigma(2:end)-sigma(1:end-1);
    drate = rate(2:end)-rate(1:end-1);
    sigma_midpt = 1/2*(sigma(2:end)+sigma(1:end-1)); 
    rate_midpts = 1/2*(rate(2:end)+rate(1:end-1)); 
    eta_tan = dsigma./drate;
    
    %plot(ax_eta,sigma,eta, '-d','Color',myColor,'LineWidth',2);
    myMarker = my_vol_frac_markers(ii);
    
    
    plot(sigma_midpt*CSS,eta_tan*CSS, strcat(myMarker,'-'),'Color',myColor,'LineWidth',1,'MarkerFaceColor',myColor);
end

colormap(cmap);
c_eta = colorbar;
c_eta.Ruler.TickLabelFormat='%.2f';
c_eta.Ticks = round((phi_list)*100)/100;
clim([minPhi maxPhi]);

