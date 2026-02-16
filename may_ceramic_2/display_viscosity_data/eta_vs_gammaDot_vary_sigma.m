dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];



phi_list = unique(dataTable(:,1));


fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'YScale','log','XScale','log');
%ax_eta = axes('Parent', fig_eta);
ax_eta.XLabel.String = 'rate_{acoustic}/rate_{shear}';
ax_eta.YLabel.String = 'Viscosity \eta (Pa s)';
hold(ax_eta,'on');
cmap = winter(256);
colormap(ax_eta,cmap);

%for phiNum=6:13
for phiNum = 6
    
phi = phi_list(phiNum);





%disp(phi)
markerCode = strcat('-',my_vol_frac_markers(phiNum));
ax_eta.Title.String = strcat("\phi=",num2str(phi));

myData = dataTable(dataTable(:,1)==phi, :);
sigma_list = unique(myData(:,2));
minLogSig = log(min(sigma_list));
maxLogSig = log(50);
%maxLogSig = log(max(sigma_list));


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
    eta = myData(:,4);
    eta0V = eta(V==0);
    
    % sort in order of ascending V
    [V,sortIdx] = sort(V,'ascend');
    eta = eta(sortIdx);

    d33 = 300e-12;
    f = 1.15e6;
    h=211e-6;
    gammaDotAcous = V*d33*f/h; % SI units
    %gammaDotShear = sigma*19/(eta0V*25); % SI units
    gammaDotShear = sigma./eta; % SI units

    plot(ax_eta,gammaDotAcous./gammaDotShear,eta, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);

end


c1 = colorbar(ax_eta);
clim(ax_eta,[minLogSig maxLogSig]);
legend(L)


end
