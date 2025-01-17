function [eta0,phimu,phi0,f_params] = flexible_wyart_cates(my_data,showPlot)
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
% x(2) = phi_mu
% x(3) = phi_0
% x(4:end) = f(sigma) parameters

%f = @(sigma,sigmastar) exp(-(sigmastar./sigma).^0.5);
fitfxn = @(x) x(1)*( x(3)*(1-flexible_f(sigma,x(4:end))) + x(2)*flexible_f(sigma,x(4:end)) - phi ).^(-2);
%fitfxn = @(x) x(1)*( x(3)*(1-f(sigma,x(4))) + x(2)*f(sigma,x(4)) - phi ).^(-2);
costfxn = @(x) sum(( (fitfxn(x)-eta)./delta_eta ).^2);  
%costfxn = @(x) sum(( (fitfxn(x)-eta)).^2); 



opts = optimset('Display','off');
%x0 =[0.02, 0.61, 0.70, 1, 1];
%x0 =[0.02, 0.61, 0.70, 0.22, 0.7, 1, 1];
%x0 =[0.02, 0.61, 0.70, 0.09, 1.2, 0.7, 0.94, 1, 1];
%x0 =[0.02, 0.61, 0.70, 10, 10, 10, 10, 10, 10];
%x0 =[0.02, 0.61, 0.70, 10, 1, 10, 1, 10, 1];
%x0 =[0.02, 0.61, 0.70, 1, 1, 1, 1, 1, 1];
x0 =[0.02, 0.61, 0.70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
s = fminsearch(costfxn, x0, opts);
 
eta0 = s(1);
phimu = s(2);
phi0 = s(3);
f_params = s(4:end);
%sigmastar = s(4);
%k = s(5);
disp([eta0 phimu phi0]);
disp(s(4:2:end));
disp(s(5:2:end));
disp(costfxn(s));

etaFit = fitfxn(s);

if showPlot
    my_vol_frac_markers = ["o","o","o","o","o","square","<","hexagram","^","pentagram","v","d",">",">",">",">",">",">"];
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
        
        myMarker = my_vol_frac_markers(ii);
        myColor = cmap(round(1+255*(myPhi-minPhi)/(maxPhi-minPhi)),:);

        errorbar(myStress,myEta,myDeltaEta,strcat(myMarker,''),'Color',myColor,'LineWidth',0.5,'MarkerFaceColor',myColor);
        plot(myStress,myEtaFit,'Color',myColor,'LineWidth',1);

    
    end
    %title('stress sweeps');
    xlabel('\sigma ');
    ylabel('\eta ');
    
    colormap(cmap);
    c = colorbar;
    c.Ticks = phis;
    clim([minPhi maxPhi])
end

end