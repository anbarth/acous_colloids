dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
CSS = (50/19)^3;


phi_list = unique(dataTable(:,1));
%for phiNum = 12
for phiNum=6:13
    
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
%minLogSig = log(min(sigma_list));
minLogSig = log(1/CSS);
%maxLogSig = log(max(sigma_list));
maxLogSig = log(4*10^3/CSS);

L = {};
for ii=1:length(sigma_list)
    sigma = sigma_list(ii);
    if sigma < 0.1
        continue
    end
    L{end+1}=num2str(sigma);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma, :);
    myColor = cmap(round(1+255*(log(sigma)-minLogSig)/(maxLogSig-minLogSig)),:);
    V = myData(:,3);
    eta = CSS*myData(:,4);
    deltaEta = max(CSS*myData(:,5),eta*0.15);
    
    delta_phi = 0.02;
    delta_eta_volumefraction = eta*2*(0.7-phi)^(-1)*delta_phi;
    delta_eta_total = sqrt(deltaEta.^2+delta_eta_volumefraction.^2);
    
    % sort in order of ascending V
    [V,sortIdx] = sort(V,'ascend');
    eta = eta(sortIdx);

    percent_eta = eta ./ eta(1);
    delta_percent_eta = percent_eta .* sqrt( (eta./delta_eta_total).^2 + (eta(1)/delta_eta_total(1)).^2 );
    
    plot(ax_eta,acoustic_energy_density(V),percent_eta, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
    %errorbar(ax_eta,acoustic_energy_density(V),percent_eta,delta_percent_eta, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
    %errorbar(ax_eta,acoustic_energy_density(V),eta,delta_eta_total, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);

end


%c1 = colorbar(ax_eta);
%clim(ax_eta,[minLogSig maxLogSig]);
%legend(L)




prettyPlot;
myfig = gcf;
myfig.Position=[970,304,259,343];
yticks([0 0.5 1]);

ax1=gca;
ax1.XScale = 'log';
%ax1.YScale = 'log';

% percent eta
ylim([0 1])

% phi=0.52
%yticks([10 100]);
%xlim([0.05 50])
%xticks([10^-1 10^0 10^1])
%ylim([9 165])

% phi=0.59
xlim([0.05 50])
xticks([10^-1 10^0 10^1])
%ylim([9 2500])
%yticks([10 100 1000])

title(phi)

end
