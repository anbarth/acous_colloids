dataTable = may_ceramic_06_25;

fig_eta = figure;
ax_eta = axes('Parent', fig_eta,'XScale','log','YScale','log');
ax_eta.XLabel.String = '\sigma (Pa)';
ax_eta.YLabel.String = '\eta (Pa s)';
hold(ax_eta,'on');

phi_list = unique(dataTable(:,1));
plot_indices = 1:length(phi_list);

%collapse_params; phi_fudge = zeros(1,13);
%load("y_optimal_06_26.mat"); [eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,13); phi_fudge = zeros(1,13); fxnType = 1;
%load("y_optimal_simultaneous_fudge_06_26.mat"); [eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsFudge(y_optimal,13); fxnType = 1;
%load("y_optimal_post_fudge_06_26.mat"); [eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsFudge(y_optimal,13); fxnType = 1;
%load("y_optimal_crossover_06_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C] = unzipParamsCrossover(y_optimal,13); phi_fudge = zeros(1,13); fxnType = 2;
load("y_optimal_crossover_simultaneous_fudge_06_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
%load("y_optimal_crossover_post_fudge_06_26.mat"); [eta0, phi0, delta, A, width, sigmastar, C, phi_fudge] = unzipParamsCrossoverFudge(y_optimal,13); fxnType = 2;
%load("y_optimal_delta2_06_27.mat"); [eta0, phi0, delta, sigmastar, C] = unzipParams(y_optimal,13); phi_fudge = zeros(1,13); fxnType = 1;
%load("y_optimal_delta2_post_fudge_06_27.mat"); [eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsFudge(y_optimal,13); fxnType = 1;
%load("y_optimal_delta2_simultaneous_fudge_06_27.mat"); [eta0, phi0, delta, sigmastar, C, phi_fudge] = unzipParamsFudge(y_optimal,13); fxnType = 1;


f = @(sigma,jj) exp(-(sigmastar(jj) ./ sigma).^1);

minPhi = 0.18;
maxPhi = 0.62;
cmap = turbo;

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
    
    plot(ax_eta,sigma,eta, 'd','Color',myColor,'LineWidth',1);
    %plot(ax_eta,sigma*19,eta*25, '-d','Color',myColor,'LineWidth',1);
    
    x = f(sigma,1)*C(ii,1);
    if fxnType == 1
        Fhat = eta0*(1-x).^delta;
    elseif fxnType ==2
        xi = 1./x-1;
        logintersection = log(A/eta0)/(-delta-2);
        mediator = cosh(width*(log(xi)-logintersection));
        Hconst = exp(1/(2*width)*(-2-delta)*log(2)+(1/2)*log(A*eta0));
        Hhat = Hconst * xi.^((delta-2)/2) .* (mediator).^((-2-delta)/(2*width));
        Fhat = 1./x.^2 .* Hhat;
    end

    etaHat = Fhat / (phi0-phi_fudged)^2;
    plot(ax_eta,sigma,etaHat,'-','Color',myColor,'LineWidth',1);

end

colormap(ax_eta,cmap);
c_eta = colorbar(ax_eta);
c_eta.Ticks = phi_list+phi_fudge';
clim(ax_eta,[minPhi maxPhi]);




% colormap(ax_eta_rescaled,cmap);
% c_eta = colorbar(ax_eta_rescaled);
% c_eta.Ticks = [phi_high];
% caxis(ax_eta_rescaled,[minPhi maxPhi])
%close(fig_eta_rescaled)
