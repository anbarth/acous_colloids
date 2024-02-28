dataTable = ceramic_data_table_02_25;
phi_list = [0.40,0.44,.48,0.52,0.56,0.59];

phi_range = 6;

for ii=phi_range
    phi = phi_list(ii);
    
    myData = dataTable(dataTable(:,1)==phi, :);
    sigma = myData(:,2);
    V = myData(:,3);
    eta = myData(:,4);
    
    % fill in P values
    P = zeros(size(myData,1),1);
    for kk = 1:length(P)
        P(kk) = calculateP(phi,sigma(kk),V(kk),dataTable);
    end
    
    fig_eta = figure;
    ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
    ax_eta.XLabel.String = 'P';
    ax_eta.YLabel.String = '\eta (Pa s)';
    hold(ax_eta,'on');
    cmap = plasma(256);
    colormap(ax_eta,cmap);
    
    myColor = log(sigma);
    scatter(ax_eta,P,eta,[],myColor,'filled','o');
    colorbar;
    title(ax_eta,strcat('\phi=',num2str(phi)))
end