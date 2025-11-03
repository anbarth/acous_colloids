dataTable = pranav_data_table;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
CSS = (50/19)^3;
CSR = (19/50);
CSV = CSS/CSR;

f = @(sigma,sigmastar)exp(-sigmastar./sigma);
[eta0,sigmastar,phimu,phi0] = wyart_cates(pranav_data_table,f,false);
sigmastar=CSS*sigmastar;
eta0=CSV*eta0;


phi_list = unique(dataTable(:,1));
for phiNum = 8

    
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



markerCode = strcat('',my_vol_frac_markers(phiNum));


myData = dataTable(dataTable(:,1)==phi, :);
sigma_list = unique(myData(:,2));
minLogSig = log(CSS*min(sigma_list));
%minLogSig = log(1);
maxLogSig = log(CSS*max(sigma_list));

L = {};
for ii=1:length(sigma_list)
    sigma_rheo = sigma_list(ii);
    sigma = CSS*sigma_rheo;

    L{end+1}=num2str(sigma);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma_rheo, :);
    myColor = cmap(round(1+255*(log(sigma)-minLogSig)/(maxLogSig-minLogSig)),:);
    V = myData(:,3);
    eta = CSV*myData(:,4);
    deltaEta = 0;
    
    delta_phi = 0.02;
    delta_eta_volumefraction = eta*2*(0.7-phi)^(-1)*delta_phi;
    delta_eta_total = sqrt(deltaEta.^2+delta_eta_volumefraction.^2);
    
    % sort in order of ascending V
    [V,sortIdx] = sort(V,'ascend');
    eta = eta(sortIdx);

    percent_eta = eta ./ eta(V==0);
    
    %plot(ax_eta,acoustic_energy_density(V)/sigma,eta, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
    %plot(ax_eta,acoustic_energy_density(V),eta, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
    errorbar(ax_eta,acoustic_energy_density(V),eta,delta_eta_total, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);

    k1 = 1/(phi0-phimu);
    k2 = 1/(phi0-phi);
    factor = (k1-k2*f(sigma,sigmastar+acoustic_energy_density(V))) / (k1-k2*f(sigma,sigmastar));
    eta_predicted = eta(V==0)*factor.^(-2);
    plot(ax_eta,acoustic_energy_density(V),eta_predicted,'-','Color',myColor)
end


c1 = colorbar(ax_eta);
clim(ax_eta,[minLogSig maxLogSig]);
%legend(L)




prettyPlot;
myfig = gcf;
myfig.Position=[457,288,414,343];

ax1=gca;
ax1.XScale = 'log';
ax1.YScale = 'log';


%title(phi)

end
