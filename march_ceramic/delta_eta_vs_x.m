my_vol_frac_markers = ['>','s','o','d','h','pentagram'];

vol_frac_plotting_range = 1:5;
colorBy = 3; % 1 for V, 2 for phi, 3 for P, 4 for stress
xc = 10;

collapse_params;
stressTable = march_data_table_04_02;
phi_list = [44,48,52,56,59];
minPhi = 0.3;
maxPhi = 0.6;
volt_list = [0,5,10,20,40,60,80,100];

%%%%%%%%%%%%%%%%%% make all the figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cmap = turbo;
cmap = viridis(256); 
%cmap = plasma(256);

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
hold(ax_eta,'on');
ax_eta.XLabel.String = "x";
ax_eta.YLabel.String = "delta F";
ax_eta.XLim = [10^-2, 30];
%ax_eta.XLim = [10^-10, 30];

colormap(ax_eta,cmap);
if xc ~= 0
    xline(ax_eta,xc);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_all = zeros(0,1);
F_all = zeros(0,1);


for ii=vol_frac_plotting_range
    phi = phi_list(ii)/100;
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
    eta_rescaled = eta*(phi0-phi)^2;
    
    keep_me = delta_eta>0;
    sigma = sigma(keep_me);
    V = V(keep_me);
    eta = eta(keep_me);
    eta_rescaled = eta_rescaled(keep_me);
    delta_eta = delta_eta(keep_me);
    delta_eta_rescaled = delta_eta_rescaled(keep_me);
    
    % fill in P values
    P = zeros(size(V,1),1);
    for kk = 1:length(P)
        P(kk) = calculateP(phi,sigma(kk),V(kk),dataTable);
    end
    
    %xWC = C(ii)*A(P).*f(sigma) ./ (-1*phi+phi0);
    xWC = C(ii)*f(sigma) ./ (-1*phi+phi0);
    
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
    

    scatter(ax_eta,xWC,delta_eta_rescaled,[],myColor,'filled',marker);
end



c1 = colorbar(ax_eta);
if colorBy == 1
    caxis(ax_eta,[0 100]);
    c1.Ticks = [0,5,10,20,40,60,80,100];
elseif colorBy == 2
    caxis(ax_eta,[minPhi maxPhi]);
    c1.Ticks = phi_list/100;
elseif colorBy == 3
    ax_eta.CLim = [-6, 10];
elseif colorBy == 4
    % TODO what are these numbers? lol
    caxis(ax_eta,[1.6988,6])
end