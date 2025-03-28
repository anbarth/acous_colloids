function [eta0,sigmastar,phimu,phi0] = wyart_cates(my_data,showPlot)
%my_data = may_ceramic_09_17;
if nargin < 2
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
deltaPhi = 0.01;
delta_eta_volumefraction = 2*eta.*(0.7-phi).^(-1)*deltaPhi;
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

f = @(sigma,sigmastar) sigma./(sigmastar+sigma);
fitfxn = @(x) x(1)*( x(4)*(1-f(sigma,x(2))) + x(3)*f(sigma,x(2)) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./delta_eta ).^2);  

constraintMatrix = zeros(4,4);
constraintVector = [0,0,0,0];
upper_bounds = [Inf,Inf,1,1];
lower_bounds = [0,0,0.61,0.61];

opts = optimoptions('fmincon','Display','final','StepTolerance',1e-12);
%opts = optimoptions('fmincon','Display','off');
s = fmincon(costfxn, [0.1, 0.5, 0.65, 0.70],constraintMatrix,constraintVector,...
            [],[],lower_bounds,upper_bounds,[],opts);
 
eta0 = s(1);
sigmastar = s(2);
phimu = s(3);
phi0 = s(4);
%disp(s);
etaFit = fitfxn(s);

phis = [0.2 0.3 0.4 0.45 0.5 0.55 0.58 0.6];
if showPlot
    my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">"];
    figure;
    hold on;
    ax1 = gca;
    ax1.XScale = 'log';
    ax1.YScale = 'log';
    cmap = viridis(256);
    colormap(cmap);
    minPhi = 0.18;
    maxPhi = 0.62;
    for ii=1:length(phis)
        myPhi = phis(ii);
        
        myStress=logspace(log10(0.005),log10(300));
        myEtaFit=s(1)*( s(4)*(1-f(myStress,s(2))) + s(3)*f(myStress,s(2)) - myPhi ).^(-2);
        
        myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);
       plot(myStress,myEtaFit,'Color',myColor,'LineWidth',1.5);
    end
    %title('stress sweeps');
    xlabel('Shear stress \sigma (Pa)');
    ylabel('Viscosity \eta (Pa s)');
    
    colormap(cmap);
    c = colorbar;
    c.Ticks = phis;
    clim([minPhi maxPhi])
end
prettyPlot;
end