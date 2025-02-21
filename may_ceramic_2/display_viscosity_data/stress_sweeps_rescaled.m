dataTable = may_ceramic_09_17;
my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">",">"];

paramsVector = y_optimal;
phi0=paramsVector(2);
sigmastar=paramsVector(6);


fig_sigma = figure;
ax_sigma = axes('Parent', fig_sigma,'XScale','log','YScale','log');
%ax_eta = axes('Parent', fig_eta,'YScale','log');
%ax_eta.XLabel.String = '\sigma (rheometer Pa)';
%ax_eta.YLabel.String = '\eta (rheometer Pa s)';
ax_sigma.XLabel.String = '\sigma (Pa)';
ax_sigma.YLabel.String = '\eta(\phi_0-\phi)^2 (Pa s)';
hold(ax_sigma,'on');

fig_fsigma = figure;
ax_fsigma = axes('Parent', fig_fsigma,'XScale','log','YScale','log');
ax_fsigma.XLabel.String = 'f(\sigma)';
ax_fsigma.YLabel.String = '\eta(\phi_0-\phi)^2 (Pa s)';
hold(ax_fsigma,'on');

%phi_high = [0.44,0.48,0.52,0.56,0.59];
phi_list = unique(dataTable(:,1));
%phi_list_plot = phi_list(1:end);
plot_indices = 1:length(phi_list);


%load("y_optimal_crossover_post_fudge_1percent_06_27.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_optimal,13); 
phi_fudge = zeros(1,length(phi_list));
%[eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParams(y_handpicked_10_28,13); 


%minPhi = 0.18;
%maxPhi = 0.62;

minPhi = min(phi_list);
maxPhi = max(phi_list);

%minPhi = min(phi_list_plot);
%maxPhi = max(phi_list_plot);
%phi0=0.7;
%cmap = flipud(viridis(256)); 
%cmap = turbo;
cmap = viridis(256);

for ii=1:length(phi_list)
    if ~ismember(ii,plot_indices)
        continue
    end
    phi = phi_list(ii);
    phi_fudged = phi+phi_fudge(ii);
    myData = dataTable(dataTable(:,1)==phi & dataTable(:,3)==0, :);
    myColor = cmap(round(1+255*(phi_fudged-minPhi)/(maxPhi-minPhi)),:);
    sigma = myData(:,2);
    eta = myData(:,4);
    deltaEta = myData(:,5);
    
    
    % sort in order of ascending sigma
    [sigma,sortIdx] = sort(sigma,'ascend');
    eta = eta(sortIdx);
    deltaEta = deltaEta(sortIdx);

    f = exp(-sigmastar./sigma);
    
    %plot(ax_eta,sigma,eta, '-d','Color',myColor,'LineWidth',2);
    myMarker = my_vol_frac_markers(ii);
   
    plot(ax_sigma,sigma,eta*(phi0-phi)^2, strcat(myMarker,'-'),'Color',myColor,'LineWidth',1.5,'MarkerFaceColor',myColor); 
    plot(ax_fsigma,f,eta*(phi0-phi)^2, strcat(myMarker,'-'),'Color',myColor,'LineWidth',1.5,'MarkerFaceColor',myColor); 
   

end

colormap(ax_sigma,cmap);
c_eta = colorbar(ax_sigma);
c_eta.Ticks = round((phi_list+phi_fudge')*100)/100;
clim(ax_sigma,[minPhi maxPhi]);
