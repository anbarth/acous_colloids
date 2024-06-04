dataTable = march_data_table_05_02;
phi_list = unique(dataTable(:,1));
maxPhi = 0.6;
minPhi = 0.4;

phi_range = 3:9;
colorBy = 4; % 1 for V, 2 for phi, 3 for P, 4 for stress

% fig_eta = figure;
% ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
% ax_eta.XLabel.String = 'P';
% ax_eta.YLabel.String = '\Delta\eta(\phi_0-\phi)^2 (Pa s)';
% hold(ax_eta,'on');
% cmap = plasma(256);
% colormap(ax_eta,cmap);

for ii=phi_range
    figure; hold on;
    phi = phi_list(ii);
    xlabel('V')
    ylabel('(\eta(0V)-\eta(V))/\eta(0V)')
    
    myData = dataTable(dataTable(:,1)==phi, :);
    sigma = myData(:,2);
    V = myData(:,3);
    eta = myData(:,4);
    
    eta_baseline = zeros(size(eta));
    for jj = 1:length(eta_baseline)
        eta_baseline(jj) = eta(V==0 & sigma==sigma(jj));
    end
    
    delta_eta = eta_baseline-eta;
    
    keep_me = delta_eta>0;
    sigma = sigma(keep_me);
    V = V(keep_me);
    eta = eta(keep_me);
    delta_eta = delta_eta(keep_me);
   
    
    if colorBy == 1
        myColor = cmap(round(1+255*V/100),:);
    elseif colorBy == 2
        myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);
    elseif colorBy == 4
        myColor = log(sigma);
    end
    

    scatter(V,delta_eta./eta,[],myColor,'filled',marker);
    colorbar;
    title(strcat('\phi=',num2str(phi)))
end