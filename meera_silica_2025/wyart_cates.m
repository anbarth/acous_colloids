function [eta0,sigmastar,phimu,phi0] = wyart_cates(my_data,f,showPlot)
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
delta_eta_rheometer = no_acoustics(:,5);
deltaPhi = 0.02;
delta_eta_volumefraction = 2*eta.*(0.64-phi).^(-1)*deltaPhi;
delta_eta = sqrt(delta_eta_rheometer.^2+delta_eta_volumefraction.^2);



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
myWCfit = fit([phi,sigma],eta,wcFitType,'StartPoint',[0.1, 0.5, 0.65, 0.70],'Weights',1./delta_eta.^2);
%myWCfit = fit([phi,sigma],eta,wcFitType,'StartPoint',[0.1, 0.5, 0.65, 0.70],'Weights',1./eta.^2);
%disp(myWCfit)
s = [myWCfit.A myWCfit.sigmastar myWCfit.phimu myWCfit.phi0];

eta0 = s(1);
sigmastar = s(2);
phimu = s(3);
phi0 = s(4);

etaFit = fitfxn(s);


if showPlot
    figure;
    hold on;
    ax1 = gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';
    cmap = viridis(256);
    colormap(cmap);
    minPhi = min(phis);
    maxPhi = max(phis);
    for ii=1:length(phis)
        myPhi = phis(ii);
        
        myStress=sigma(phi==myPhi);
        myEta=eta(phi==myPhi);
        myDeltaEta=delta_eta(phi==myPhi);
        myEtaFit=etaFit(phi==myPhi);
        
        % sort in order of ascending sigma
        [myStress,sortIdx] = sort(myStress,'ascend');
        myEta = myEta(sortIdx);
        myDeltaEta = myDeltaEta(sortIdx);
        myEtaFit = myEtaFit(sortIdx);
        
        myMarker ='o';
        myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);

        errorbar(myStress,myEta,myDeltaEta,strcat(myMarker,''),'Color',myColor,'LineWidth',0.5);
        plot(myStress,myEtaFit,'Color',myColor,'LineWidth',1);

        %errorbar(19*myStress,25*myEta,25*myDeltaEta,strcat(myMarker,''),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);
        %plot(19*myStress,25*myEtaFit,'Color',myColor,'LineWidth',1.5);
    end
    %title('stress sweeps');
    xlabel('\sigma (Pa)');
    ylabel('\eta (Pa s)');
    
    colormap(cmap);
    c = colorbar;
    c.Ticks = phis;
    clim([minPhi maxPhi])
   % annotation('textbox', [0.2, 0.65, 0.1, 0.1], 'String', strcat('\sigma^* = ',num2str(sigmastar),'Pa'))
   % xline(sigmastar)
end

end