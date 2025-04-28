function [eta0,sigmastar,phimu,phi0] = ness_wyart_cates_fix_phi0_phimu(my_data,f,phi0,phimu,showPlot)
%my_data = may_ceramic_09_17;
if nargin < 3
    showPlot = false;
end

% edit this list to change what's included in the fit
%phis = [44,48,52,56,59];
phis = unique(my_data(:,1));
maxSigma = 0;



no_acoustics = my_data(my_data(:,3)==0, :);
phi = no_acoustics(:,1);
sigma = no_acoustics(:,2);
eta = no_acoustics(:,4);
delta_eta = eta*0.01;
%delta_eta = 0.01*ones(size(eta));


% only include volume fractions listed at the top
include_me = false(size(phi));
for ii=1:length(phi)
    if any(phis==phi(ii))
        include_me(ii) = true;
    end
end
% only include stresses below maxSigma
if maxSigma ~= 0
    for ii=1:length(sigma)
        if sigma(ii) > maxSigma
            include_me(ii) = false;
        end
    end
end


phi = phi(include_me);
sigma = sigma(include_me);
eta = eta(include_me);
delta_eta = delta_eta(include_me);
phis = unique(phi);

% eta = A*(phi_0 (1-f) + phi_mu f - phi)^-2
% x(1) = A
% x(2) = sigma*
% x(3) = phi_mu
% x(4) = phi_0
fitfxn = @(x) x(1)*( x(4)*(1-f(sigma,x(2))) + x(3)*f(sigma,x(2)) - phi ).^(-2);
%costfxn = @(x) sum(( (fitfxn(x)-eta)./delta_eta ).^2);  
%opts = optimset('Display','off');
%s = fminsearch(costfxn,[0.1, 0.5, 0.65, 0.70],opts);
%disp(s)


wc = @(A,sigmastar,phimu,phi0,phi,sigma) A*( phi0*(1-f(sigma,sigmastar)) + phimu*f(sigma,sigmastar) - phi ).^(-2);
wcFitType = fittype(wc,'independent',["phi","sigma"]);
ftOpts = fitoptions(fitoptions(wcFitType),'StartPoint',[0.2, 0.05, phimu, phi0],'Lower',[0 0 phimu phi0],'Upper',[Inf Inf phimu phi0],'Weights',1./delta_eta.^2);
myWCfit = fit([phi,sigma],eta,wcFitType,ftOpts);
disp(myWCfit)
s = [myWCfit.A myWCfit.sigmastar myWCfit.phimu myWCfit.phi0];

eta0 = s(1);
sigmastar = s(2);
phimu = s(3);
phi0 = s(4);


% eta0 = 0.4;
% sigmastar = 0.05;
% phimu = 0.6;
% phi0 = 0.65;


if showPlot
    figure; hold on;
    ax1 = gca; ax1.XScale = 'log'; ax1.YScale = 'log';
    cmap = viridis(256);
    colormap(cmap);
    minPhi = min(phi);
    maxPhi = max(phi);
    for ii=1:length(phis)
        myPhi = phis(ii);
        
        myStress=sigma(phi==myPhi);
        myEta=eta(phi==myPhi);
        myDeltaEta=delta_eta(phi==myPhi);
        
        % sort in order of ascending sigma
        [myStress,sortIdx] = sort(myStress,'ascend');
        myEta = myEta(sortIdx);
        myDeltaEta = myDeltaEta(sortIdx);
        
        myMarker = 'o';
        myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);

        errorbar(myStress,myEta,myDeltaEta,strcat(myMarker,''),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);
        %plot(myStress,myEtaFit,'Color',myColor,'LineWidth',1);

    end
    phi_plot = linspace(minPhi, maxPhi, 10);
    sigma_plot = logspace(log10(min(sigma)),log10(max(sigma)));
    for ii=1:length(phi_plot)
        % wc = @(A,sigmastar,phimu,phi0,phi,sigma) 
        myPhi = phi_plot(ii);
        myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);
        eta_predicted = wc(eta0, sigmastar, phimu, phi0, myPhi, sigma_plot);
        plot(sigma_plot,eta_predicted,'-','Color',myColor,'LineWidth',1)
    end


    xlabel('\sigma (Pa)');
    ylabel('\eta (Pa s)');
    
    colormap(cmap);
    %c = colorbar;
    %c.Ticks = phis;
    clim([minPhi maxPhi])
   % xline(sigmastar)
end

end