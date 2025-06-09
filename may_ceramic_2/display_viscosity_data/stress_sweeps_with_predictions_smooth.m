dataTable = may_ceramic_09_17;
myVoltNum = 1;
volt_list = [0 5 10 20 40 60 80];
voltage = volt_list(myVoltNum);

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\sigma (Pa)';
ax_eta.YLabel.String = '\eta (Pa s)';
hold(ax_eta,'on');

fig_rate = figure;
ax_rate = axes('Parent', fig_rate,'XScale','log','YScale','log');
ax_rate.XLabel.String = 'rate (1/s)';
ax_rate.YLabel.String = '\sigma (Pa)';
hold(ax_rate,'on');
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];


phi_list = unique(dataTable(:,1));
plot_indices = 1:length(phi_list);


optimize_C_jardy_03_19;
y = y_lsq_0V;
modelHandle = @modelHandpickedAllExp0V;
[~,~,~,~,~,delta_eta,~] = modelHandle(dataTable, y);
phi_fudge = zeros(size(phi_list));

minPhi = 0.18;
maxPhi = 0.62;
cmap = viridis(256);

minSigma = min(unique(dataTable(:,2)));
maxSigma = max(unique(dataTable(:,2)));

%for ii=13
for ii=1:length(phi_list)
    if ~ismember(ii,plot_indices)
        continue
    end
    phi = phi_list(ii);
    phi_fudged = phi+phi_fudge(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==voltage, :);
    deltaEta = delta_eta(dataTable(:,1)==phi & dataTable(:,3)==voltage);

    myColor = cmap(round(1+255*(phi_fudged-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    deltaEta = deltaEta(sortIdx);
    
    myMarker = my_vol_frac_markers(ii);
    
    errorbar(ax_eta,sigma,eta, deltaEta, strcat(myMarker,''),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);
    plot(ax_rate,sigma./eta,sigma, strcat(myMarker,''),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);


    % plot prediction
    sigma_fake = logspace(log10(minSigma),log10(maxSigma))';
    eta_hat = viscosity_prediction(phi,sigma_fake,voltage,dataTable,y,modelHandle);
    plot(ax_eta,sigma_fake,eta_hat,'-','Color',myColor,'LineWidth',1.5);
    plot(ax_rate,sigma_fake./eta_hat,sigma_fake,'-','Color',myColor,'LineWidth',1.5);



 
end
title(ax_eta,strcat('V=',num2str(voltage)))
colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
c_eta.Ticks = phi_list+phi_fudge';
clim(ax_eta,[minPhi maxPhi]);