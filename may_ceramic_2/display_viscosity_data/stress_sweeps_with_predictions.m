dataTable = may_ceramic_09_17;
myVoltNum = 1;
volt_list = [0 5 10 20 40 60 80];
voltage = volt_list(myVoltNum);

fig_eta = figure;
%ax_eta = axes('Parent', fig_eta,'YScale','log');
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
%ax_eta.XLabel.String = '\sigma (rheometer Pa)';
%ax_eta.YLabel.String = '\eta (rheometer Pa s)';
ax_eta.XLabel.String = '\sigma (Pa)';
ax_eta.YLabel.String = '\eta (Pa s)';
hold(ax_eta,'on');
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];


phi_list = unique(dataTable(:,1));
plot_indices = 1:length(phi_list);


optimize_C_jardy_03_19;
y_optimal = y_lsq_0V;
modelHandle = @modelHandpickedAllExp0V;
[~,~,~,~,~,delta_eta,eta_hat] = modelHandle(dataTable, y_optimal);
phi_fudge = zeros(size(phi_list));

minPhi = 0.18;
maxPhi = 0.62;
cmap = viridis(256);

%for ii=13
for ii=1:length(phi_list)
    if ~ismember(ii,plot_indices)
        continue
    end
    phi = phi_list(ii);
    phi_fudged = phi+phi_fudge(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==voltage, :);
    myEtaHat = eta_hat(dataTable(:,1)==phi & dataTable(:,3)==voltage);
    deltaEta = delta_eta(dataTable(:,1)==phi & dataTable(:,3)==voltage);

    myColor = cmap(round(1+255*(phi_fudged-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    deltaEta = deltaEta(sortIdx);
    myEtaHat = myEtaHat(sortIdx);
    
    myMarker = my_vol_frac_markers(ii);
    %plot(ax_eta,sigma,eta, strcat(myMarker,'--'),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);
    
    errorbar(ax_eta,sigma,eta, deltaEta, strcat(myMarker,''),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);
    plot(ax_eta,sigma,myEtaHat,'-','Color',myColor,'LineWidth',1.5);

    %errorbar(ax_eta,sigma*19,eta*25, deltaEta*25, strcat(myMarker,''),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);
    %plot(ax_eta,sigma*19,myEtaHat*25,'-','Color',myColor,'LineWidth',1.5);
 
end
title(ax_eta,strcat('V=',num2str(voltage)))
colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
c_eta.Ticks = phi_list+phi_fudge';
clim(ax_eta,[minPhi maxPhi]);