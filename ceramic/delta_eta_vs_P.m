dataTable = ceramic_data_table_02_25;
phi_list = [0.40,0.44,.48,0.52,0.56,0.59];
maxPhi = 0.6;
minPhi = 0.4;
phi0 = 0.68;

phi_range = 4;
my_vol_frac_markers = ['>','s','o','d','h','pentagram'];
colorBy = 1; % 1 for V, 2 for phi, 3 for P, 4 for stress

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = 'P';
ax_eta.YLabel.String = '\Delta\eta(\phi_0-\phi)^2 (Pa s)';
hold(ax_eta,'on');
cmap = plasma(256);
colormap(ax_eta,cmap);

for ii=phi_range
    phi = phi_list(ii);
    marker = my_vol_frac_markers(ii);
    
    myData = dataTable(dataTable(:,1)==phi, :);
    sigma = myData(:,2);
    V = myData(:,3);
    eta = myData(:,4);
    
    eta_baseline = zeros(size(eta));
    for jj = 1:length(eta_baseline)
        eta_baseline(jj) = eta(V==0 & sigma==sigma(jj));
    end
    
    delta_eta = eta_baseline-eta;
    delta_eta_rescaled = delta_eta*(phi0-phi)^2;
    
    keep_me = delta_eta>0;
    sigma = sigma(keep_me);
    V = V(keep_me);
    eta = eta(keep_me);
    delta_eta = delta_eta(keep_me);
    delta_eta_rescaled = delta_eta_rescaled(keep_me);
    
    % fill in P values
    P = zeros(size(V,1),1);
    for kk = 1:length(P)
        P(kk) = calculateP(phi,sigma(kk),V(kk),dataTable);
    end
    
    if colorBy == 1
        myColor = cmap(round(1+255*V/100),:);
        %myColor = cmap(round(1+255*(log10(voltage+10)-1)/(log10(110)-1)),:);
    elseif colorBy == 2
        myColor = cmap(round(1+255*(phi-minPhi)/(maxPhi-minPhi)),:);

    elseif colorBy == 3
        myColor = log(P);
    elseif colorBy == 4
        myColor = log(sigma);
    end
    

    scatter(ax_eta,P,delta_eta_rescaled,[],myColor,'filled',marker);
    colorbar;
    title(ax_eta,strcat('\phi=',num2str(phi)))
end