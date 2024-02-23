dataTable = ceramic_data_table_02_22;
phi_list = [0.40,0.44,.48,0.56,0.59];

phi_range = 1:5;

for ii=phi_range
    phi = phi_list(ii);
    
    myData = dataTable(dataTable(:,1)==phi, :);
    sigma = myData(:,2);
    V = myData(:,3);
    eta = myData(:,4);
    
    % fill in P values
    P = zeros(size(myData,1),1);
    for kk = 1:length(P)
        eta_0V = dataTable(dataTable(:,1)==phi & dataTable(:,2)==sigma(kk) & dataTable(:,3)==0,4);
        gamma_dot_0V = sigma(kk)/eta_0V;
        P(kk) = V(kk)^2/sigma(kk)/gamma_dot_0V;
    end
    
    fig_eta = figure;
    ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
    ax_eta.XLabel.String = 'P';
    ax_eta.YLabel.String = '\eta (Pa s)';
    hold(ax_eta,'on');
    
    myColor = log(sigma);
    scatter(ax_eta,P,eta,[],myColor,'filled','o');
    colorbar;
    title(ax_eta,strcat('\phi=',num2str(phi)))
end