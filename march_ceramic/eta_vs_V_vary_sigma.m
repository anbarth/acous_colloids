dataTable = march_data_table_05_02;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'YScale','log');
ax_eta.XLabel.String = 'Acoustic voltage (V)';
ax_eta.YLabel.String = '\eta (Pa s)';
hold(ax_eta,'on');
cmap = winter(256);
colormap(ax_eta,cmap);

phi_list = unique(dataTable(:,1));
phi = phi_list(6);
disp(phi)
ax_eta.Title.String = num2str(phi);

myData = dataTable(dataTable(:,1)==phi, :);
sigma_list = 50*unique(myData(:,2));
minLogSig = log(min(sigma_list));
%minLogSig = log(1);
maxLogSig = log(max(sigma_list));


for ii=1:length(sigma_list)
    sigma = sigma_list(ii);
    if sigma < 1
        continue
    end
    myData = dataTable(dataTable(:,1)==phi & 50*dataTable(:,2)==sigma, :);
    myColor = cmap(round(1+255*(log(sigma)-minLogSig)/(maxLogSig-minLogSig)),:);
    V = myData(:,3);
    eta = 25*myData(:,4);
    
    % sort in order of ascending V
    [V,sortIdx] = sort(V,'ascend');
    eta = eta(sortIdx);
    
    plot(ax_eta,V,eta, '-o','Color',myColor,'LineWidth',1);

end

c1 = colorbar(ax_eta);
caxis(ax_eta,[minLogSig maxLogSig]);
