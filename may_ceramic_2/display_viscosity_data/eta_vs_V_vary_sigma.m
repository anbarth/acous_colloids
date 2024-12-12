dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];



phi_list = unique(dataTable(:,1));
%phiNum = 7;
for phiNum=6:13
    
phi = phi_list(phiNum);


fig_eta = figure;
%ax_eta = axes('Parent', fig_eta,'YScale','log');
ax_eta = axes('Parent', fig_eta);
ax_eta.XLabel.String = 'Acoustic voltage (V)';
ax_eta.YLabel.String = 'Viscosity \eta (Pa s)';
hold(ax_eta,'on');
cmap = winter(256);
colormap(ax_eta,cmap);


%disp(phi)
markerCode = strcat('-',my_vol_frac_markers(phiNum));
ax_eta.Title.String = strcat("\phi=",num2str(phi));

myData = dataTable(dataTable(:,1)==phi, :);
sigma_list = unique(myData(:,2));
minLogSig = 19*log(min(sigma_list));
%minLogSig = log(1);
maxLogSig = 19*log(max(sigma_list));

L = {};
for ii=1:length(sigma_list)
    sigma = sigma_list(ii);
    if sigma < 0.1
        continue
    end
    L{end+1}=num2str(19*sigma);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma, :);
    myColor = cmap(round(1+255*(19*log(sigma)-minLogSig)/(maxLogSig-minLogSig)),:);
    V = myData(:,3);
    eta = 25*myData(:,4);
    
    % sort in order of ascending V
    [V,sortIdx] = sort(V,'ascend');
    eta = eta(sortIdx);

    percent_eta = eta ./ eta(1);
    
    %plot(ax_eta,V,percent_eta, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);
    plot(ax_eta,V,eta, markerCode,'Color',myColor,'MarkerFaceColor',myColor,'LineWidth',1);

end


c1 = colorbar(ax_eta);
clim(ax_eta,[minLogSig maxLogSig]);
legend(L)


end
