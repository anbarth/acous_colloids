dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
CSS = (50/19)^3;


phi_list = unique(dataTable(:,1));
for phiNum = 9
%for phiNum=6:13
    
phi = phi_list(phiNum);


fig_eta = figure;
%ax_eta = axes('Parent', fig_eta,'YScale','log');
ax_eta = axes('Parent', fig_eta);
ax_eta.XLabel.String = 'Acoustic energy density{\it U_a} (Pa)';
ax_eta.YLabel.String = 'Viscosity \eta (Pa s)';
%ax_eta.Title.String = strcat("\phi=",num2str(phi));
hold(ax_eta,'on');
cmap = winter(256);
colormap(ax_eta,cmap);



markerCode = strcat('-',my_vol_frac_markers(phiNum));


myData = dataTable(dataTable(:,1)==phi, :);
sigma_list = unique(myData(:,2));
minLogSig = CSS*log(min(sigma_list));
%minLogSig = log(1);
maxLogSig = CSS*log(max(sigma_list));

L = {};
for ii=1:length(sigma_list)
    sigma = sigma_list(ii);
    if sigma < 0.1
        continue
    end
    L{end+1}=num2str(sigma);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma, :);
    myColor = cmap(round(1+255*(CSS*log(sigma)-minLogSig)/(maxLogSig-minLogSig)),:);
    V = myData(:,3);
    eta = CSS*myData(:,4);
    deltaEta = CSS*myData(:,5);
    
    delta_phi = 0.02;
    delta_eta_volumefraction = eta*2*(0.7-phi)^(-1)*delta_phi;
    delta_eta_total = sqrt(deltaEta.^2+delta_eta_volumefraction.^2);
    
    % sort in order of ascending V
    [V,sortIdx] = sort(V,'ascend');
    eta = eta(sortIdx);

    percent_eta = eta ./ eta(1);
    
    %plot(ax_eta,acoustic_energy_density(V)/sigma,eta, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
    %plot(ax_eta,acoustic_energy_density(V),eta, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
    errorbar(ax_eta,acoustic_energy_density(V),eta,delta_eta_total, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);

end


c1 = colorbar(ax_eta);
clim(ax_eta,[minLogSig maxLogSig]);
legend(L)




prettyPlot;
myfig = gcf;
myfig.Position=[60, 60,414,323];

ax1=gca;
ax1.XScale = 'log';
ax1.YScale = 'log';
xlim([0.03 30])
xticks([10^-1 10^0 10^1])

end
